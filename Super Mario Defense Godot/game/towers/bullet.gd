extends Area2D

var move = Vector2.ZERO
var speed = 3
var look_vector = Vector2.ZERO
var target

func _ready():
	$sprite/AnimationPlayer.play("idle")
	
	if target != null:
		$sprite.look_at(target.global_position)
		look_vector = target.global_position - global_position

func _physics_process(delta):
	move = Vector2.ZERO
	
	move = move.move_toward(look_vector, delta)
	move = move.normalized() * speed
	global_position += move


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	speed = 0
	$CollisionShape2D.disabled = true
	$sprite/AnimationPlayer.play("hit")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "hit":
		queue_free()
