extends Node2D
class_name Boo

var target_enemy: Enemy = null
var move_speed: float = 50.0
var float_amplitude: float = 8.0
var damage_per_tick: float = 0.3
var tick_rate: float = 0.2
var lifetime: float = 5.0
var attached: bool = false

var float_time: float = 0.0
var damage_timer: float = 0.0
var base_y: float = 0.0

@onready var sprite: ColorRect = $Sprite


func _ready() -> void:
	base_y = global_position.y


func _process(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0.0:
		_fade_out()
		return

	# Check if target is gone
	if not is_instance_valid(target_enemy) or not target_enemy.is_alive:
		_fade_out()
		return

	float_time += delta * 3.0

	if not attached:
		# Float toward target
		var target_pos: Vector2 = target_enemy.global_position + Vector2(0, -8)
		var dir: Vector2 = (target_pos - global_position)
		var dist: float = dir.length()

		if dist < 6.0:
			# Attach to enemy
			attached = true
			damage_timer = 0.0
		else:
			dir = dir.normalized()
			# Floaty movement: move toward target but oscillate vertically
			var move := dir * move_speed * delta
			global_position += move
			global_position.y += sin(float_time) * float_amplitude * delta * 2.0
	else:
		# Stay attached to enemy, follow their position
		global_position = target_enemy.global_position + Vector2(0, -10)
		global_position.y += sin(float_time) * 2.0  # Subtle bob

		# Deal DPS
		damage_timer -= delta
		if damage_timer <= 0.0:
			if is_instance_valid(target_enemy) and target_enemy.is_alive:
				target_enemy.take_damage(damage_per_tick)
			damage_timer = tick_rate

	# Transparency pulse when attached
	if sprite and attached:
		sprite.modulate.a = 0.7 + sin(float_time * 2.0) * 0.2


func _fade_out() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	tween.tween_callback(queue_free)
	set_process(false)
