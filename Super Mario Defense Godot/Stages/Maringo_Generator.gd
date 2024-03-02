extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var mario_path = preload("res://Objects/test_mario.tscn")
var spawn_time = 10
var spawn_timer = spawn_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	spawn_timer -= 1
	if spawn_timer <= 0:
		spawn_timer = spawn_time
		create_mario()

func create_mario():
	var mario = mario_path.instantiate()
	get_parent().add_child(mario)
	mario.position = self.position
