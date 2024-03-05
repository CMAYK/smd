extends Area2D

var move = Vector2.ZERO
var speed = 3
var look_vector = Vector2.ZERO
var target
var damage = 3

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

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "hit":
		_kill()


func _on_body_entered(body):
		_kill()

func _kill():
	var mario = load("res://game/effects/star_burst.tscn").instantiate()
	get_parent().add_child(mario)
	mario.position = self.position
	queue_free()
