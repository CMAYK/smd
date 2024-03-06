extends CharacterBody2D

var speed = 75.0
var health = 25
var ballhit = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if speed < 75:
		speed += 4
	
	$health.text = str(health)
	$health.rotation = -self.rotation
	$AnimatedSprite2D.play()
	$AnimatedSprite2D.animation = "walk"
	
	velocity.x = speed

	if is_on_floor():
		var normal: Vector2 = get_floor_normal()
		self.rotation = lerp(self.rotation, normal.angle()+ PI / 2, 0.1)
	else:
		velocity.y += gravity * delta
	
	if health <= 0:
		queue_free()
	
	move_and_slide()


func _on_area_2d_area_entered(area):
	$AnimatedSprite2D/AnimationPlayer.play("RESET")
	$AnimatedSprite2D/AnimationPlayer.play("hurt")
	health -= area.damage
	area._kill()
