extends CharacterBody2D

var gravity = 1000

func _ready():
	velocity.x = -100
	velocity.y = -200
	pass

func _physics_process(delta):
	$sprite/AnimationPlayer.play("default")
	
	velocity.y += gravity * delta
	if position.y >= 64:
		queue_free()
	move_and_slide()
