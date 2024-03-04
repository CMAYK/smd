extends Node2D

var mario_path = preload("res://heroes/mario_small.tscn")
var fast_path = preload("res://heroes/mario_fast.tscn")
var spawn_time = 50
var spawn_timer = spawn_time

var count = 0

func _ready():
	create_mario()

func _process(delta):
	spawn_timer -= 1
	if spawn_timer <= 0:
		spawn_timer = spawn_time
		create_mario()

func create_mario():
	if count % 2 == 0:
		var fast = fast_path.instantiate()
		get_parent().add_child(fast)
		fast.position = self.position
		count += 1
	else:
		var mario = mario_path.instantiate()
		get_parent().add_child(mario)
		mario.position = self.position
		count += 1
