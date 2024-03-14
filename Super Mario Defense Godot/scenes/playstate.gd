extends Node2D

var layout_name:String = "layout_test"
var layout
var tilemap

@onready var camera = $camera_main

var sound_player = preload("res://game/sounds/sound_player.tscn")
var hero_spawner = preload("res://game/heroes/hero_spawner/hero_spawner.tscn")
var castle = preload("res://game/layouts/castle.tscn")

func _ready():
	_load_layout()
	_load_spawner()
	_load_castle()
	camera._limit_camera(tilemap)

func _load_layout():
	var layout_path = load("res://game/layouts/%s.tscn" % [layout_name])
	var layout_instance = layout_path.instantiate()
	$layout.add_child(layout_instance)
	layout = $layout.get_child(0)
	tilemap = layout.tilemap

func _load_spawner():
	var hs_instance = hero_spawner.instantiate()
	hs_instance.position = layout.spawn_pos.position
	$heros.add_child(hs_instance)
	
func _load_castle():
	var c_instance = castle.instantiate()
	c_instance.position = layout.castle_pos.position
	$heros.add_child(c_instance)
