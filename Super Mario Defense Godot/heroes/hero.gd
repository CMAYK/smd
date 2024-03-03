extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	$AnimatedSprite2D.play()
	$AnimatedSprite2D.animation = "walk"
	
	velocity.x = SPEED

	if is_on_floor():
		var normal: Vector2 = get_floor_normal()
		self.rotation = lerp(self.rotation, normal.angle()+ PI / 2, 0.1)
	else:
		velocity.y += gravity * delta
	
	move_and_slide()
