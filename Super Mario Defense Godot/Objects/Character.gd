extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if is_on_floor():
		pass
		#var normal: Vector2 = get_floor_normal()
		#$AnimatedSprite2D.rotation = normal.angle() + PI / 2
	else:
		velocity.y += gravity * delta

	$AnimatedSprite2D.play()
	$AnimatedSprite2D.animation = "walk"
	velocity.x = SPEED

	if is_on_floor():
		var normal: Vector2 = get_floor_normal()
		$AnimatedSprite2D.rotation = normal.angle() + PI / 2
	
	move_and_slide()
