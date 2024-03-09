extends Area2D

var move = Vector2.ZERO
var look_vector = Vector2.ZERO

var direction = Vector2.ZERO
var speed
var damage
var knockback
var pierce
var dopierce

@onready var playstate = get_parent().get_parent()
@onready var sound_player = playstate.sound_player

func _ready():
	#0 pierce means infinate pierce
	if pierce <= 0:
		dopierce = false
	else:
		dopierce = true


	#if direction != null:
		#$sprite.look_at(direction)
		#look_vector = direction - global_position
#
		##fixes the bullet spite orentation
		#if look_vector.x > 0:
			#$sprite.flip_v = false
		#else:
			#$sprite.flip_v = true

func _physics_process(delta):

	#move = move.move_toward(look_vector, delta)
	#move = move.normalized() * speed
	global_position = global_position.move_toward(Vector2(global_position.x-48, global_position.y+64), speed * delta)

	if dopierce:
		if pierce <= 0:
			_kill() 

func _kill():
	var fx = load("res://game/effects/star_burst.tscn").instantiate()
	get_parent().add_child(fx)
	fx.position = self.position
	queue_free()

func _on_body_entered(body):
		_kill()
