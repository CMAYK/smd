extends Node2D
class_name BobOmb

const GROUND_Y := 192.0

# Set by tower on spawn
var damage: float = 0.0
var chase_range: float = 0.0
var chase_speed: float = 0.0
var wander_time: float = 0.0

# Launch phase
var launch_velocity: float = 0.0
var gravity: float = 200.0
var vy: float = 0.0

# Float-down phase
var is_floating: bool = false
var float_time: float = 0.0
var sine_amplitude: float = 16.0  # Horizontal drift range
var float_speed: float = 30.0  # Downward speed while floating
var sine_frequency: float = 3.0
var float_origin_x: float = 0.0

# Ground phase
var on_ground: bool = false
var target_enemy: Enemy = null
var wander_timer: float = 0.0
var wander_dir: float = 1.0
var wander_speed: float = 15.0
var has_exploded: bool = false

# Visual
var bob_sprite: ColorRect = null


func _ready() -> void:
	vy = launch_velocity
	float_origin_x = global_position.x

	# Placeholder visual — replace with bob-omb sprite later
	# TODO: Replace with TextureRect/AnimatedSprite2D using bob-omb spritesheet
	bob_sprite = ColorRect.new()
	bob_sprite.size = Vector2(10, 10)
	bob_sprite.position = Vector2(-5, -10)
	bob_sprite.color = Color(0.1, 0.1, 0.1)
	add_child(bob_sprite)


func _process(delta: float) -> void:
	if has_exploded:
		return

	if on_ground:
		_process_ground(delta)
	elif is_floating:
		_process_float(delta)
	else:
		_process_launch(delta)


func _process_launch(delta: float) -> void:
	# Rise upward, slow down with gravity
	vy += gravity * delta
	global_position.y += vy * delta

	# Once velocity turns downward, switch to float phase
	if vy >= 0:
		is_floating = true
		float_time = 0.0
		float_origin_x = global_position.x


func _process_float(delta: float) -> void:
	# Sine-wave horizontal drift while floating down
	float_time += delta
	global_position.x = float_origin_x + sin(float_time * sine_frequency) * sine_amplitude
	global_position.y += float_speed * delta

	# Slight rotation to match drift direction
	var drift := cos(float_time * sine_frequency) * sine_amplitude * sine_frequency
	rotation = drift * 0.02

	# Check if landed
	if global_position.y >= GROUND_Y:
		global_position.y = GROUND_Y
		rotation = 0.0
		on_ground = true
		_on_land()


func _on_land() -> void:
	# Look for a mario in chase range
	target_enemy = _find_target_in_range()
	if target_enemy == null:
		# No target — start wandering
		wander_timer = wander_time
		wander_dir = [-1.0, 1.0].pick_random()


func _process_ground(delta: float) -> void:
	if is_instance_valid(target_enemy) and target_enemy.is_alive:
		# Chase the target
		var dir_to_target: float = sign(target_enemy.global_position.x - global_position.x)
		global_position.x += dir_to_target * chase_speed * delta

		# Flip sprite to face direction
		if bob_sprite:
			bob_sprite.scale.x = -1.0 if dir_to_target < 0 else 1.0

		# Check if close enough to explode
		var dist: float = global_position.distance_to(target_enemy.global_position)
		if dist < 12.0:
			_explode()
	else:
		# Lost target or no target — try to find a new one
		target_enemy = _find_target_in_range()
		if target_enemy != null:
			return

		# Wander
		wander_timer -= delta
		if wander_timer <= 0:
			_fade_out()
			return

		global_position.x += wander_dir * wander_speed * delta

		# Reverse wander direction at edges (stay near landing spot)
		if abs(global_position.x - float_origin_x) > 40.0:
			wander_dir = -wander_dir

		# Periodically check for new targets while wandering
		if fmod(wander_timer, 0.5) < delta:
			target_enemy = _find_target_in_range()


func _find_target_in_range() -> Enemy:
	var best: Enemy = null
	var best_dist: float = chase_range

	for child in get_tree().current_scene.get_children():
		if child is Enemy and child.is_alive:
			var dist: float = global_position.distance_to(child.global_position)
			if dist < best_dist:
				best_dist = dist
				best = child as Enemy

	return best


func _explode() -> void:
	if has_exploded:
		return
	has_exploded = true

	# Deal damage to target
	if is_instance_valid(target_enemy) and target_enemy.is_alive:
		target_enemy.take_damage(damage)

	# Also damage nearby enemies (splash)
	var splash_range: float = 20.0
	for child in get_tree().current_scene.get_children():
		if child is Enemy and child.is_alive and child != target_enemy:
			var dist: float = global_position.distance_to(child.global_position)
			if dist < splash_range:
				child.take_damage(damage * 0.5)

	# Explosion visual
	if bob_sprite:
		bob_sprite.color = Color(1.0, 0.5, 0.0)

	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2(2.0, 2.0), 0.15)
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	tween.tween_callback(queue_free)
	set_process(false)


func _fade_out() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.tween_callback(queue_free)
	set_process(false)
