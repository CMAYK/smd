extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var mario = preload("res://Objects/test_mario.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for x in 1:
		create_mario()

func create_mario():
	var mario = mario.instantiate()
	get_parent().add_child(mario)
