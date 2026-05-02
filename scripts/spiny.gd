extends Area2D
class_name Spiny

var damage: float = 2.0
var drop_damage: float = 4.0
var walk_speed: float = 18.0
var walk_direction: float = 1.0
var ground_y: float = 192.0
var fall_speed: float = 0.0
var is_on_ground: bool = false
var has_hit_on_drop: bool = false
const FALL_GRAVITY: float = 200.0

@onready var sprite: ColorRect = $Sprite


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
	if not is_on_ground:
		# Falling
		fall_speed += FALL_GRAVITY * delta
		position.y += fall_speed * delta

		# Check for drop hit on enemies while falling
		if not has_hit_on_drop:
			for body in get_overlapping_bodies():
				if body is Enemy and body.is_alive:
					body.take_damage(drop_damage)
					has_hit_on_drop = true

		# Land on ground
		if global_position.y >= ground_y:
			global_position.y = ground_y
			is_on_ground = true
			fall_speed = 0.0
			# Change color to indicate walking state
			if sprite:
				sprite.color = Color(0.8, 0.2, 0.1)
	else:
		# Walk along ground
		position.x += walk_direction * walk_speed * delta

		# Despawn if off screen (far left or right)
		if global_position.x < -20.0 or global_position.x > 2000.0:
			queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Enemy and body.is_alive:
		if is_on_ground:
			body.take_damage(damage)
		else:
			body.take_damage(drop_damage)
		# Spiny dies on contact
		queue_free()
