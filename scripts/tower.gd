extends StaticBody2D
class_name Tower

signal sold(tower: Tower)

const GROUND_Y := 192.0
const MIN_PLACE_Y := 72.0
const TILE := 16

@export var tower_type: String = "koopa_shell_pipe"
@export var facing_right: bool = false

var tower_data: Dictionary
var current_level: int = 1
var damage: float = 0.0
var attack_range: float = 0.0
var reload_time: float = 0.0
var projectile_speed: float = 0.0
var sell_value: int = 0
var reload_timer: float = 0.0
var is_selected: bool = false

# Hammer Bro
var throw_left_next: bool = true
var pendulum_time: float = 0.0
var pendulum_anchor: Vector2 = Vector2.ZERO
var pendulum_half_width: float = 48.0
var pendulum_drop: float = 32.0
var pendulum_period: float = 2.5
var hammer_bro_sprite: AnimatedSprite2D = null
var platform_sprite: AnimatedSprite2D = null
var has_targets_cached: bool = false

# Ball n Chain
var swing_angle: float = 0.0
var chain_tex: ImageTexture = null
var ball_tex: ImageTexture = null
var base_tex: ImageTexture = null

# Boo Chest
var boo_lifetime: float = 5.0
var chest_sprite: AnimatedSprite2D = null
var chest_open_timer: float = 0.0
var chest_pre_spawn_timer: float = 0.0
var _pending_boo_target: Enemy = null

@onready var sprite: ColorRect = $Sprite
@onready var range_area: Area2D = $RangeArea
@onready var range_shape: CollisionShape2D = $RangeArea/CollisionShape2D
@onready var direction_indicator: ColorRect = $DirectionIndicator
@onready var selection_highlight: ColorRect = $SelectionHighlight


func _ready() -> void:
	tower_data = GameManager.tower_defs[tower_type]
	damage = tower_data["damage"]
	attack_range = tower_data["range"]
	reload_time = tower_data["reload_time"]
	sell_value = tower_data["sell_value"]
	if tower_data.has("projectile_speed"):
		projectile_speed = tower_data["projectile_speed"]
	if tower_data.has("boo_lifetime"):
		boo_lifetime = tower_data["boo_lifetime"]

	sprite.color = tower_data.get("color", Color(0.5, 0.5, 0.5))

	match tower_type:
		"hammer_bro":
			_setup_hammer_bro()
		"swinging_stone":
			_setup_ball_chain()
		"boo_chest":
			_setup_boo_chest()

	_update_range_shape()
	_update_visuals()
	selection_highlight.visible = false

	if not tower_data.get("directional", false):
		direction_indicator.visible = false


# ===== SETUP =====

func _setup_hammer_bro() -> void:
	sprite.visible = false
	selection_highlight.visible = false
	pendulum_anchor = global_position
	# Start at the lowest center of the swing arc (quarter period = bottom)
	pendulum_time = pendulum_period / 4.0

	# Platform: 109x26, 2 frames of 54x26 with 1px gap
	var platform_tex_res := load("res://resources/sprites/hammer_bro_platform.png") as Texture2D
	if platform_tex_res:
		platform_sprite = AnimatedSprite2D.new()
		var frames := SpriteFrames.new()
		frames.add_animation("flap")
		var img: Image = platform_tex_res.get_image()
		for i in range(2):
			var frame_img := img.get_region(Rect2i(i * 55, 0, 54, 26))
			var frame_tex := ImageTexture.create_from_image(frame_img)
			frames.add_frame("flap", frame_tex)
		frames.set_animation_speed("flap", 6.0)
		frames.set_animation_loop("flap", true)
		platform_sprite.sprite_frames = frames
		platform_sprite.play("flap")
		platform_sprite.offset = Vector2(0, -13)
		add_child(platform_sprite)

	# Hammer Bro: 63x22, 2 frames of 31x22 with 1px gap
	# Frame 0 = throwing, Frame 1 = idle
	var bro_tex := load("res://resources/sprites/hammer_bro.png") as Texture2D
	if bro_tex:
		hammer_bro_sprite = AnimatedSprite2D.new()
		var frames := SpriteFrames.new()
		frames.add_animation("throw")
		frames.add_animation("idle")
		var img: Image = bro_tex.get_image()
		var throw_img := img.get_region(Rect2i(0, 0, 31, 22))
		var idle_img := img.get_region(Rect2i(32, 0, 31, 22))
		frames.add_frame("throw", ImageTexture.create_from_image(throw_img))
		frames.add_frame("idle", ImageTexture.create_from_image(idle_img))
		frames.set_animation_speed("throw", 1.0)
		frames.set_animation_speed("idle", 1.0)
		frames.set_animation_loop("throw", false)
		frames.set_animation_loop("idle", false)
		hammer_bro_sprite.sprite_frames = frames
		hammer_bro_sprite.play("idle")
		hammer_bro_sprite.offset = Vector2(0, -16 - 11)
		add_child(hammer_bro_sprite)


func _setup_ball_chain() -> void:
	sprite.visible = false

	# Ball n chain parts: 66x28
	# Ball: 32x28 at (0,0)
	# Chain: 16x16 at (33, 12)
	# Base: 16x16 at (50, 12)
	var parts_tex := load("res://resources/sprites/ball_chain_parts.png") as Texture2D
	if parts_tex:
		var img: Image = parts_tex.get_image()
		ball_tex = ImageTexture.create_from_image(img.get_region(Rect2i(0, 0, 32, 28)))
		chain_tex = ImageTexture.create_from_image(img.get_region(Rect2i(33, 12, 16, 16)))
		base_tex = ImageTexture.create_from_image(img.get_region(Rect2i(50, 12, 16, 16)))

	# Start vertical: ball at top, swing_angle = -PI/2 (pointing up)
	swing_angle = -PI / 2.0


func _setup_boo_chest() -> void:
	sprite.visible = false

	# Chest: 65x32, closed (32x32), 1px gap, open (32x32)
	var chest_tex_res := load("res://resources/sprites/boo_chest.png") as Texture2D
	if chest_tex_res:
		chest_sprite = AnimatedSprite2D.new()
		var frames := SpriteFrames.new()
		frames.add_animation("closed")
		frames.add_animation("open")
		var img: Image = chest_tex_res.get_image()
		frames.add_frame("closed", ImageTexture.create_from_image(img.get_region(Rect2i(0, 0, 32, 32))))
		frames.add_frame("open", ImageTexture.create_from_image(img.get_region(Rect2i(33, 0, 32, 32))))
		frames.set_animation_speed("closed", 1.0)
		frames.set_animation_speed("open", 1.0)
		frames.set_animation_loop("closed", false)
		frames.set_animation_loop("open", false)
		chest_sprite.sprite_frames = frames
		chest_sprite.play("closed")
		chest_sprite.offset = Vector2(0, -16)
		add_child(chest_sprite)


# ===== PROCESS =====

func _process(delta: float) -> void:
	match tower_data.get("tower_script", ""):
		"projectile":
			_process_projectile(delta)
		"hammer_bro":
			_process_hammer_bro(delta)
		"boo_chest":
			_process_boo_chest(delta)
		"swinging_stone":
			_process_swinging_stone(delta)

	if is_selected or tower_type == "swinging_stone":
		queue_redraw()


func _draw() -> void:
	if is_selected:
		var range_center := Vector2.ZERO
		if tower_type == "hammer_bro":
			range_center = pendulum_anchor - global_position
		draw_arc(range_center, attack_range, 0, TAU, 64, Color(1, 1, 0, 0.25), 1.0)
		draw_circle(range_center, attack_range, Color(1, 1, 0, 0.08))

	# Ball n Chain: 4 segments — base, chain, chain, ball
	# Each segment has 1px gap between them
	# Segments are laid out along the swing direction from base (center) outward to ball
	if tower_type == "swinging_stone":
		var dir := Vector2(cos(swing_angle), sin(swing_angle))

		# Segment sizes: base=16x16, chain=16x16, chain=16x16, ball=32x28
		# With 1px gaps: base(16) + 1 + chain(16) + 1 + chain(16) + 1 + ball center
		# Segments placed along dir from origin outward

		# Base at origin (centered)
		if base_tex:
			draw_texture(base_tex, Vector2(-8, -8))

		# Chain 1: 16px from center + 1px gap = 17px along dir
		if chain_tex:
			var chain1_pos := dir * 17.0
			draw_texture(chain_tex, chain1_pos - Vector2(8, 8))

		# Chain 2: 17 + 16 + 1 = 34px along dir
		if chain_tex:
			var chain2_pos := dir * 34.0
			draw_texture(chain_tex, chain2_pos - Vector2(8, 8))

		# Ball: 34 + 16 + 1 = 51px along dir (ball is 32x28, offset from center)
		if ball_tex:
			var ball_pos := dir * 51.0
			draw_texture(ball_tex, ball_pos - Vector2(16, 14))


# ===== KOOPA SHELL PIPE =====

func _process_projectile(delta: float) -> void:
	reload_timer -= delta
	if reload_timer <= 0:
		var targets := _get_valid_targets()
		if targets.size() > 0:
			_fire_shell(targets[0])
			reload_timer = reload_time


func _fire_shell(_target: Enemy) -> void:
	var projectile := preload("res://scenes/projectile.tscn").instantiate()
	projectile.global_position = global_position + Vector2(-4.0 if not facing_right else 4.0, -4.0)
	projectile.damage = damage
	projectile.speed = projectile_speed
	projectile.direction = Vector2.RIGHT if facing_right else Vector2.LEFT
	get_tree().current_scene.add_child(projectile)


# ===== HAMMER BRO =====

func _process_hammer_bro(delta: float) -> void:
	pendulum_time += delta
	var t: float = pendulum_time * TAU / pendulum_period
	var offset_x: float = pendulum_half_width * cos(t)
	var offset_y: float = pendulum_drop * (1.0 - cos(2.0 * t)) * 0.5
	global_position = pendulum_anchor + Vector2(offset_x, offset_y)

	# Check targets (range centered on anchor)
	has_targets_cached = false
	for child in get_tree().current_scene.get_children():
		if child is Enemy and child.is_alive:
			var dist: float = child.global_position.distance_to(pendulum_anchor)
			if dist < attack_range:
				has_targets_cached = true
				break

	# Idle animation when no targets
	if hammer_bro_sprite and not has_targets_cached:
		if hammer_bro_sprite.animation != "idle":
			hammer_bro_sprite.play("idle")

	reload_timer -= delta
	if reload_timer <= 0 and has_targets_cached:
		_throw_hammer()
		reload_timer = reload_time


func _throw_hammer() -> void:
	var hammer := preload("res://scenes/hammer.tscn").instantiate()
	var throw_offset := Vector2(14.0 if not throw_left_next else -14.0, -30.0)
	hammer.global_position = global_position + throw_offset
	hammer.damage_per_tick = damage
	hammer.tick_rate = tower_data.get("hammer_tick_rate", 0.15)
	hammer.fall_accel = tower_data.get("hammer_gravity", 300.0)
	hammer.bounce_vy = tower_data.get("hammer_bounce_vy", -40.0)
	hammer.ground_y = GROUND_Y

	var h_speed: float = projectile_speed
	if throw_left_next:
		hammer.velocity = Vector2(-h_speed, -h_speed * 1.5)
	else:
		hammer.velocity = Vector2(h_speed, -h_speed * 1.5)

	if hammer_bro_sprite:
		hammer_bro_sprite.play("throw")
		hammer_bro_sprite.flip_h = throw_left_next

	throw_left_next = !throw_left_next
	get_tree().current_scene.add_child(hammer)


# ===== BOO CHEST =====

func _process_boo_chest(delta: float) -> void:
	# Chest close timer (after boo spawns)
	if chest_open_timer > 0:
		chest_open_timer -= delta
		if chest_open_timer <= 0:
			if chest_sprite:
				chest_sprite.play("closed")

	# Pre-spawn timer: chest opens 0.5s before boo fires
	if chest_pre_spawn_timer > 0:
		chest_pre_spawn_timer -= delta
		if chest_pre_spawn_timer <= 0:
			_do_spawn_boo()

	reload_timer -= delta
	if reload_timer <= 0 and chest_pre_spawn_timer <= 0:
		var targets := _get_valid_targets()
		if targets.size() > 0:
			# Find most advanced mario
			var best: Enemy = targets[0]
			for t_enemy in targets:
				if t_enemy.global_position.x > best.global_position.x:
					best = t_enemy
			# Open chest, schedule boo spawn in 0.5s
			if chest_sprite:
				chest_sprite.play("open")
			chest_pre_spawn_timer = 0.5
			_pending_boo_target = best
			reload_timer = reload_time


func _do_spawn_boo() -> void:
	if is_instance_valid(_pending_boo_target) and _pending_boo_target.is_alive:
		_spawn_boo(_pending_boo_target)
	else:
		var targets := _get_valid_targets()
		if targets.size() > 0:
			var best: Enemy = targets[0]
			for t_enemy in targets:
				if t_enemy.global_position.x > best.global_position.x:
					best = t_enemy
			_spawn_boo(best)
	# Keep chest open 0.5s after spawn
	chest_open_timer = 0.5
	_pending_boo_target = null


func _spawn_boo(target: Enemy) -> void:
	var boo := preload("res://scenes/boo.tscn").instantiate()
	boo.global_position = global_position + Vector2(0, -16)
	boo.target_enemy = target
	boo.damage_per_tick = damage
	boo.tick_rate = tower_data.get("boo_dps_tick_rate", 0.2)
	boo.move_speed = tower_data.get("boo_speed", 50.0)
	boo.float_amplitude = tower_data.get("boo_float_amplitude", 8.0)
	boo.lifetime = boo_lifetime
	# Jump 4-5 tiles high while also drifting toward target
	boo.launch_velocity = Vector2(0, -200.0)
	boo.source_range_area = range_area
	get_tree().current_scene.add_child(boo)


# ===== BALL N CHAIN =====

func _process_swinging_stone(delta: float) -> void:
	var rot_speed: float = tower_data.get("rotation_speed", 1.257)
	swing_angle += rot_speed * delta

	# Ball is 51px from center along swing direction
	var ball_r: float = tower_data.get("ball_radius", 16.0)
	var ball_pos := global_position + Vector2(cos(swing_angle), sin(swing_angle)) * 51.0

	reload_timer -= delta
	if reload_timer <= 0:
		reload_timer = tower_data.get("dps_tick_rate", 0.1)
		for child in get_tree().current_scene.get_children():
			if child is Enemy and child.is_alive:
				var dist: float = child.global_position.distance_to(ball_pos)
				if dist < ball_r + 6.0:
					child.take_damage(damage)

	queue_redraw()


# ===== SHARED =====

func _get_valid_targets() -> Array[Enemy]:
	var targets := range_area.get_overlapping_bodies()
	var valid: Array[Enemy] = []
	for body in targets:
		if body is Enemy and body.is_alive:
			valid.append(body as Enemy)
	return valid


func is_point_on_tower(world_pos: Vector2) -> bool:
	if tower_type == "hammer_bro":
		var local := world_pos - global_position
		return abs(local.x) < 28.0 and local.y > -48.0 and local.y < 4.0
	elif tower_type == "boo_chest":
		var local := world_pos - global_position
		return abs(local.x) < 18.0 and local.y > -34.0 and local.y < 4.0
	elif tower_type == "swinging_stone":
		var local := world_pos - global_position
		return abs(local.x) < 12.0 and abs(local.y) < 12.0
	else:
		var dist: float = global_position.distance_to(world_pos)
		return dist < 16.0


func upgrade() -> bool:
	if current_level >= tower_data["max_level"]:
		return false
	var cost: int = get_upgrade_cost()
	if GameManager.spend_coins(cost):
		current_level += 1
		damage += tower_data["upgrade_damage_add"]
		attack_range += tower_data["upgrade_range_add"]
		if reload_time > 0:
			reload_time *= tower_data["upgrade_reload_mult"]
		sell_value += cost / 2
		if tower_data.has("upgrade_lifetime_add"):
			boo_lifetime += tower_data["upgrade_lifetime_add"]
		_update_range_shape()
		return true
	return false


func get_upgrade_cost() -> int:
	return tower_data["upgrade_cost_base"] + (current_level - 1) * 10


func sell() -> void:
	GameManager.coins += sell_value
	sold.emit(self)
	queue_free()


func flip_direction() -> void:
	facing_right = !facing_right
	_update_visuals()


func set_selected(selected: bool) -> void:
	is_selected = selected
	if selection_highlight and tower_type not in ["hammer_bro", "swinging_stone", "boo_chest"]:
		selection_highlight.visible = selected
	queue_redraw()


func _update_range_shape() -> void:
	if range_shape and range_shape.shape is CircleShape2D:
		(range_shape.shape as CircleShape2D).radius = attack_range


func _update_visuals() -> void:
	if direction_indicator and tower_data.get("directional", false):
		if facing_right:
			direction_indicator.position = Vector2(5, -9)
		else:
			direction_indicator.position = Vector2(-7, -9)
