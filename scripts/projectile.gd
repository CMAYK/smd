extends Area2D
class_name Projectile

var speed: float = 80.0
var damage: float = 1.0
var direction: Vector2 = Vector2.RIGHT
var lifetime: float = 5.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
	position += direction * speed * delta
	lifetime -= delta
	if lifetime <= 0:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		(body as Enemy).take_damage(damage)
		queue_free()
