extends StaticBody2D
class_name Tower

signal sold(tower: Tower)

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

	# Set sprite color based on tower type
	sprite.color = tower_data.get("color", Color(0.5, 0.5, 0.5))

	# Resize sprite for swinging stone (smaller base)
	if tower_type == "swinging_stone":
		sprite.offset_left = -3.0
		sprite.offset_right = 3.0
		sprite.offset_top = -6.0
		sprite.offset_bottom = 0.0

	_update_range_shape()
	_update_visuals()
	selection_highlight.visible = false

	# Hide direction indicator for non-directional towers
	if not tower_data.get("directional", false):
		direction_indicator.visible = false


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

	if is_selected:
		queue_redraw()


func _draw() -> void:
	if is_selected:
		# Draw range circle
		draw_arc(Vector2.ZERO, attack_range, 0, TAU, 64, Color(1, 1, 0, 0.25), 1.0)
		draw_circle(Vector2.ZERO, attack_range, Color(1, 1, 0, 0.08))

		# Draw swinging stone chain and ball
		if tower_type == "swinging_stone":
			pass  # Already drawn in _process_swinging_stone visually

	# Always draw swinging stone chain
	if tower_type == "swinging_stone":
		var chain_len: float = tower_data.get("chain_length", 48.0)
		var ball_r: float = tower_data.get("ball_radius", 16.0)
		var ball_pos := Vector2(cos(swing_angle), sin(swing_angle)) * chain_len
		# Draw chain
		draw_line(Vector2.ZERO, ball_pos, Color(0.3, 0.3, 0.3), 2.0)
		# Draw ball
		draw_circle(ball_pos, ball_r, Color(0.45, 0.45, 0.5))
		draw_arc(ball_pos, ball_r, 0, TAU, 32, Color(0.3, 0.3, 0.35), 1.0)


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
	reload_timer -= delta
	if reload_timer <= 0:
		var targets := _get_valid_targets()
		if targets.size() > 0:
			_throw_hammer()
			reload_timer = reload_time


func _throw_hammer() -> void:
	var hammer := preload("res://scenes/hammer.tscn").instantiate()
	hammer.global_position = global_position + Vector2(0, -10)
	hammer.damage_per_tick = damage
	hammer.tick_rate = tower_data.get("hammer_tick_rate", 0.15)
	hammer.fall_accel = tower_data.get("hammer_gravity", 120.0)
	hammer.bounce_vy = tower_data.get("hammer_bounce_vy", -80.0)
	hammer.ground_y = 160.0  # GROUND_Y

	# Alternate left and right
	var h_speed: float = projectile_speed
	if throw_left_next:
		hammer.velocity = Vector2(-h_speed, -h_speed * 0.8)
	else:
		hammer.velocity = Vector2(h_speed, -h_speed * 0.8)
	throw_left_next = !throw_left_next

	get_tree().current_scene.add_child(hammer)


# ===== BOO CHEST =====
func _process_boo_chest(delta: float) -> void:
	reload_timer -= delta
	if reload_timer <= 0:
		var targets := _get_valid_targets()
		if targets.size() > 0:
			# Target the mario with most progression (highest X)
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
	get_tree().current_scene.add_child(boo)


# ===== SWINGING STONE =====
func _process_swinging_stone(delta: float) -> void:
	var rot_speed: float = tower_data.get("rotation_speed", 1.257)
	swing_angle += rot_speed * delta

	var chain_len: float = tower_data.get("chain_length", 48.0)
	var ball_r: float = tower_data.get("ball_radius", 16.0)
	var ball_pos := global_position + Vector2(cos(swing_angle), sin(swing_angle)) * chain_len

	# DPS tick
	reload_timer -= delta
	if reload_timer <= 0:
		reload_timer = tower_data.get("dps_tick_rate", 0.1)
		# Check all enemies for contact with ball
		for child in get_tree().current_scene.get_children():
			if child is Enemy and child.is_alive:
				var dist: float = child.global_position.distance_to(ball_pos)
				if dist < ball_r + 6.0:  # 6px = half enemy width
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
		# Boo chest: upgrade lifetime too
		if tower_data.has("upgrade_lifetime_add"):
			boo_lifetime += tower_data["upgrade_lifetime_add"]
		_update_range_shape()
		# Flash on upgrade
		var orig_color: Color = tower_data.get("color", Color(0.5, 0.5, 0.5))
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
	if selection_highlight:
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
