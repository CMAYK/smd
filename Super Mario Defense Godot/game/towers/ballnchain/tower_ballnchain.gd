extends Area2D

var speed = 85
var damage = 5
var knockback = 300
var pierce = 100
var direction: Vector2

func _ready():
	direction = Vector2(-1, 0)

func _process(delta: float) -> void:
	self.rotation_degrees += speed * delta
	$base.rotation = -self.rotation
	print($spr_ball.position)
