extends Node2D
class_name Boo

var target_enemy: Enemy = null
var move_speed: float = 0.0
var float_amplitude: float = 0.0
var damage_per_tick: float = 0.0
var tick_rate: float = 0.0
var lifetime: float = 0.0
var attached: bool = false
var launch_velocity: Vector2 = Vector2.ZERO
var source_range_area: Area2D = null

var float_time: float = 0.0
var damage_timer: float = 0.0
var launch_phase: bool = true
var boo_sprite: Sprite2D = null


func _ready() -> void:
	var boo_tex := load("res://resources/sprites/boo.png") as Texture2D
	if boo_tex:
		boo_sprite = Sprite2D.new()
		boo_sprite.texture = boo_tex
		add_child(boo_sprite)
		$Sprite.visible = false


func _process(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0.0:
		_fade_out()
		return

	float_time += delta * 3.0

	# Check target validity (except during launch)
	if not launch_phase:
		if not is_instance_valid(target_enemy) or not target_enemy.is_alive:
			attached = false
			target_enemy = _find_new_target()
			if target_enemy == null:
				_fade_out()
				return

	if launch_phase:
		# Move upward AND drift toward target
		global_position += launch_velocity * delta
		launch_velocity.y += 350.0 * delta  # Gravity arc

		if is_instance_valid(target_enemy) and target_enemy.is_alive:
			var dir: Vector2 = (target_enemy.global_position + Vector2(0, -8) - global_position).normalized()
			global_position += dir * move_speed * 0.5 * delta

		# End launch when velocity turns downward
		if launch_velocity.y > 0:
			launch_phase = false
		return

	if not attached:
		var target_pos: Vector2 = target_enemy.global_position + Vector2(0, -8)
		var dir: Vector2 = target_pos - global_position
		var dist: float = dir.length()

		if dist < 6.0:
			attached = true
			damage_timer = 0.0
		else:
			dir = dir.normalized()
			global_position += dir * move_speed * delta
			global_position.y += sin(float_time) * float_amplitude * delta * 2.0
	else:
		global_position = target_enemy.global_position + Vector2(0, -10)
		global_position.y += sin(float_time) * 2.0

		damage_timer -= delta
		if damage_timer <= 0.0:
			if is_instance_valid(target_enemy) and target_enemy.is_alive:
				target_enemy.take_damage(damage_per_tick)
			damage_timer = tick_rate

	# Visual pulse when attached
	if boo_sprite and attached:
		boo_sprite.modulate.a = 0.7 + sin(float_time * 2.0) * 0.2
	elif boo_sprite:
		boo_sprite.modulate.a = 0.9


func _find_new_target() -> Enemy:
	var best: Enemy = null
	var best_x: float = -1.0

	if is_instance_valid(source_range_area):
		for body in source_range_area.get_overlapping_bodies():
			if body is Enemy and body.is_alive:
				if body.global_position.x > best_x:
					best_x = body.global_position.x
					best = body as Enemy
	else:
		for child in get_tree().current_scene.get_children():
			if child is Enemy and child.is_alive:
				if child.global_position.x > best_x:
					best_x = child.global_position.x
					best = child as Enemy

	return best


func _fade_out() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	tween.tween_callback(queue_free)
	set_process(false)
