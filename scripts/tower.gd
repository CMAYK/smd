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

# Hammer Bro specific
var throw_left_next: bool = true
var pendulum_time: float = 0.0
var pendulum_anchor: Vector2 = Vector2.ZERO
var pendulum_half_width: float = 48.0  # 3 tiles each side
var pendulum_drop: float = 32.0  # 2 tiles drop at center
var pendulum_period: float = 2.5
var hammer_bro_sprite: Sprite2D = null
var platform_sprite: AnimatedSprite2D = null

# Swinging Stone specific
var swing_angle: float = 0.0

# Boo Chest specific
var boo_lifetime: float = 5.0

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
			sprite.offset_left = -8.0
			sprite.offset_right = 8.0
			sprite.offset_top = -16.0
			sprite.offset_bottom = 0.0
			selection_highlight.offset_left = -10.0
			selection_highlight.offset_right = 10.0
			selection_highlight.offset_top = -18.0
			selection_highlight.offset_bottom = 2.0

	_update_range_shape()
	_update_visuals()
	selection_highlight.visible = false

	if not tower_data.get("directional", false):
		direction_indicator.visible = false


func _setup_hammer_bro() -> void:
	# Hide the default colored rect sprite - we use real sprites
	sprite.visible = false
	selection_highlight.visible = false

	pendulum_anchor = global_position

	# Load platform sprite (2-frame animation, 109x26 sheet = 2 frames of 54x26 with 1px gap)
	var platform_tex := load("res://resources/sprites/hammer_bro_platform.png") as Texture2D
	if platform_tex:
		platform_sprite = AnimatedSprite2D.new()
		var frames := SpriteFrames.new()
		frames.add_animation("flap")
		var img: Image = platform_tex.get_image()
		for i in range(2):
			var frame_img := img.get_region(Rect2i(i * 55, 0, 54, 26))
			var frame_tex := ImageTexture.create_from_image(frame_img)
			frames.add_frame("flap", frame_tex)
		frames.set_animation_speed("flap", 6.0)
		frames.set_animation_loop("flap", true)
		platform_sprite.sprite_frames = frames
		platform_sprite.play("flap")
		platform_sprite.offset = Vector2(0, -13)  # Bottom-center origin
		add_child(platform_sprite)

	# Load hammer bro sprite (31x22, single frame)
	var bro_tex := load("res://resources/sprites/hammer_bro.png") as Texture2D
	if bro_tex:
		hammer_bro_sprite = Sprite2D.new()
		hammer_bro_sprite.texture = bro_tex
		hammer_bro_sprite.offset = Vector2(0, -16 - 11)  # +16px from origin, then half height
		add_child(hammer_bro_sprite)


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

	if tower_type == "swinging_stone":
		var chain_len: float = tower_data.get("chain_length", 48.0)
		var ball_r: float = tower_data.get("ball_radius", 16.0)
		var ball_pos := Vector2(cos(swing_angle), sin(swing_angle)) * chain_len
		var num_segments: int = int(chain_len / float(TILE))
		for i in range(num_segments):
			var t: float = (float(i) + 0.5) / float(num_segments)
			var seg_pos := ball_pos * t
			var seg_color := Color(0.35, 0.3, 0.25) if i % 2 == 0 else Color(0.4, 0.35, 0.3)
			var half_seg := float(TILE) / 2.0 * 0.6
			draw_rect(Rect2(seg_pos.x - half_seg, seg_pos.y - half_seg, half_seg * 2.0, half_seg * 2.0), seg_color)
		draw_circle(ball_pos, ball_r, Color(0.45, 0.45, 0.5))
		draw_arc(ball_pos, ball_r, 0, TAU, 32, Color(0.3, 0.3, 0.35), 1.5)


# ===== PROJECTILE TOWER (Koopa Shell Pipe) =====
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
	# Smooth pendulum: use cosine for X (smooth at edges), sine for Y (smooth dip)
	pendulum_time += delta
	var t: float = pendulum_time * TAU / pendulum_period
	# X: cosine gives smooth reversal at edges
	var offset_x: float = pendulum_half_width * cos(t)
	# Y: use cos(2t) for a smooth U-shaped dip (lowest at center, highest at edges)
	# cos(2t) = 1 at edges (t=0,PI), -1 at center (t=PI/2)
	# We want Y=0 at edges, Y=drop at center
	var offset_y: float = pendulum_drop * (1.0 - cos(2.0 * t)) * 0.5
	global_position = pendulum_anchor + Vector2(offset_x, offset_y)

	# Throw hammers
	reload_timer -= delta
	if reload_timer <= 0:
		var has_targets := false
		for child in get_tree().current_scene.get_children():
			if child is Enemy and child.is_alive:
				var dist: float = child.global_position.distance_to(pendulum_anchor)
				if dist < attack_range:
					has_targets = true
					break
		if has_targets:
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

	# Flip the hammer bro sprite to face throw direction
	if hammer_bro_sprite:
		hammer_bro_sprite.flip_h = throw_left_next

	throw_left_next = !throw_left_next
	get_tree().current_scene.add_child(hammer)


# ===== BOO CHEST =====
func _process_boo_chest(delta: float) -> void:
	reload_timer -= delta
	if reload_timer <= 0:
		var targets := _get_valid_targets()
		if targets.size() > 0:
			var best: Enemy = targets[0]
			for t in targets:
				if t.global_position.x > best.global_position.x:
					best = t
			_spawn_boo(best)
			reload_timer = reload_time


func _spawn_boo(target: Enemy) -> void:
	var boo := preload("res://scenes/boo.tscn").instantiate()
	boo.global_position = global_position + Vector2(0, -8)
	boo.target_enemy = target
	boo.damage_per_tick = damage
	boo.tick_rate = tower_data.get("boo_dps_tick_rate", 0.2)
	boo.move_speed = tower_data.get("boo_speed", 50.0)
	boo.float_amplitude = tower_data.get("boo_float_amplitude", 8.0)
	boo.lifetime = boo_lifetime
	boo.launch_velocity = Vector2(0, -60.0)
	boo.source_range_area = range_area
	get_tree().current_scene.add_child(boo)


# ===== SWINGING STONE =====
func _process_swinging_stone(delta: float) -> void:
	var rot_speed: float = tower_data.get("rotation_speed", 1.257)
	swing_angle += rot_speed * delta

	var chain_len: float = tower_data.get("chain_length", 48.0)
	var ball_r: float = tower_data.get("ball_radius", 16.0)
	var ball_pos := global_position + Vector2(cos(swing_angle), sin(swing_angle)) * chain_len

	reload_timer -= delta
	if reload_timer <= 0:
		reload_timer = tower_data.get("dps_tick_rate", 0.1)
		for child in get_tree().current_scene.get_children():
			if child is Enemy and child.is_alive:
				var dist: float = child.global_position.distance_to(ball_pos)
				if dist < ball_r + 6.0:
					child.take_damage(damage)

	queue_redraw()


# ===== SHARED HELPERS =====
func _get_valid_targets() -> Array[Enemy]:
	var targets := range_area.get_overlapping_bodies()
	var valid: Array[Enemy] = []
	for body in targets:
		if body is Enemy and body.is_alive:
			valid.append(body as Enemy)
	return valid


# Check if a world position is over this tower's clickable area
func is_point_on_tower(world_pos: Vector2) -> bool:
	if tower_type == "hammer_bro":
		# Clickable area is the hammer bro sprite itself, not the anchor
		var local := world_pos - global_position
		# Platform + bro area: roughly 48 wide, 48 tall from bottom
		return abs(local.x) < 24.0 and local.y > -48.0 and local.y < 4.0
	else:
		# Default: click near the tower position
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
		var orig_color: Color = tower_data.get("color", Color(0.5, 0.5, 0.5))
		if sprite.visible:
			sprite.color = Color(1, 1, 1)
			var tween := create_tween()
			tween.tween_property(sprite, "color", orig_color, 0.3)
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
	if selection_highlight and tower_type != "hammer_bro":
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
