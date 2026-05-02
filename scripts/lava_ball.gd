extends Area2D
class_name LavaBall

var velocity: Vector2 = Vector2.ZERO
var damage: float = 2.0
var ground_y: float = 192.0
var floor_lifetime: float = 10.0
var is_on_ground: bool = false
var lifetime_timer: float = 0.0
const GRAVITY: float = 80.0

@onready var sprite: ColorRect = $Sprite


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
	if not is_on_ground:
		# Apply gravity
		velocity.y += GRAVITY * delta
		position += velocity * delta

		# Land on ground
		if global_position.y >= ground_y:
			global_position.y = ground_y
			is_on_ground = true
			velocity = Vector2.ZERO
			# Shrink to 4x4 resting lava
			if sprite:
				sprite.offset_left = -2.0
				sprite.offset_right = 2.0
				sprite.offset_top = -4.0
				sprite.offset_bottom = 0.0
				sprite.color = Color(1.0, 0.4, 0.0, 0.8)
	else:
		# On ground, count down lifetime
		lifetime_timer += delta
		if lifetime_timer >= floor_lifetime:
			# Fade out and despawn
			var tween := create_tween()
			tween.tween_property(self, "modulate:a", 0.0, 0.3)
			tween.tween_callback(queue_free)
			set_process(false)


func _on_body_entered(body: Node2D) -> void:
	if body is Enemy and body.is_alive:
		body.take_damage(damage)
		# Lava ball is consumed on hit
		queue_free()
