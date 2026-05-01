extends Area2D

var move = Vector2.ZERO
var look_vector = Vector2.ZERO

var direction = Vector2.ZERO
var speed
var damage
var knockback
var pierce
var dopierce
var color = [Color.YELLOW, Color.RED, Color.YELLOW, Color.WHITE, Color.RED]

var cast_point
var line_point

@onready var playstate = get_parent().get_parent()
@onready var sound_player = playstate.sound_player

func _ready():
	$Line2D.modulate = color[globals.colormod]
	#0 pierce means infinate pierce
	if pierce <= 0:
		dopierce = false
	else:
		dopierce = true

func _physics_process(delta):
	$RayCast2D.force_raycast_update()

	if $RayCast2D.is_colliding():
		cast_point = to_local($RayCast2D.get_collision_point())
		line_point = $Line2D.points[1]

		var tween = get_tree().create_tween()
		tween.tween_method(func(interpolate_position: Vector2) -> void: $Line2D.points = [line_point, interpolate_position], line_point, cast_point, 0)
		tween.tween_property($hitbox, "position", cast_point, 1)

	$Line2D.modulate = color[globals.colormod]

	#$hitbox.global_position = global_position.move_toward(Vector2(global_position.x-64, global_position.y+64), speed * delta)

	if dopierce:
		if pierce <= 0:
			_kill() 

func _kill():
	#var fx = load("res://game/effects/star_burst.tscn").instantiate()
	#get_parent().add_child(fx)
	#fx.position = self.position
	queue_free()

func _on_body_entered(body):
		_kill()
