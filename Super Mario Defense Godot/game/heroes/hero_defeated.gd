extends CharacterBody2D

var gravity = 1000
# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.x = -100
	velocity.y = -200
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$sprite/AnimationPlayer.play("default")
	
	velocity.y += gravity * delta
	if position.y >= 64:
		queue_free()
	move_and_slide()
