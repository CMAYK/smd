extends Area2D
var heros = []
var target = Vector2.ZERO
var mario
var is_mario_in_range : bool

func _ready():
	pass

func _process(delta):
	if heros.is_empty() == false:
		var size = heros.size() - 1 
		$Redbox.global_position = Vector2(heros[0].global_position.x, heros[0].global_position.y - 30)


func _on_body_entered(body):
	if body:
		heros.append(body)
	#	print(heros)


func _on_body_exited(body):
	if body:
		heros.erase(body)
	#	print(heros)
