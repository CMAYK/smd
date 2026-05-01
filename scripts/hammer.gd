extends Area2D
class_name Hammer

var velocity: Vector2 = Vector2.ZERO
var fall_accel: float = 120.0
var bounce_vy: float = -80.0
var ground_y: float = 160.0
var damage_per_tick: float = 0.4
var tick_rate: float = 0.15
var has_bounced: bool = false
var lifetime: float = 5.0
var spin_angle: float = 0.0

# Track per-enemy damage cooldowns
var damage_timers: Dictionary = {}

@onready var sprite: ColorRect = $Sprite


func _process(delta: float) -> void:
	velocity.y += fall_accel * delta
	position += velocity * delta

	# Spin visual
	spin_angle += 12.0 * delta
	if sprite:
		sprite.rotation = spin_angle

	# Bounce off ground once
	if not has_bounced and position.y >= ground_y - 3.0:
		position.y = ground_y - 3.0
		velocity.y = bounce_vy
		has_bounced = true
	elif has_bounced and position.y > ground_y + 60.0:
		queue_free()
		return

	# DPS tick on overlapping enemies
	for body in get_overlapping_bodies():
		if body is Enemy and body.is_alive:
			var eid: int = body.get_instance_id()
			if not damage_timers.has(eid):
				damage_timers[eid] = 0.0
				body.take_damage(damage_per_tick)
			else:
				damage_timers[eid] -= delta
				if damage_timers[eid] <= 0.0:
					body.take_damage(damage_per_tick)
					damage_timers[eid] = tick_rate

	# Clean up timers for bodies no longer overlapping
	var overlapping_ids: Array[int] = []
	for body in get_overlapping_bodies():
		overlapping_ids.append(body.get_instance_id())
	for eid in damage_timers.keys():
		if eid not in overlapping_ids:
			damage_timers.erase(eid)

	lifetime -= delta
	if lifetime <= 0:
		queue_free()
