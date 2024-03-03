extends Node2D

var layout_name:String = "layout_test"
var layout
var tilemap

@onready var camera = $camera_main


func _ready():
	load_layout()
	camera._limit_camera(tilemap)

func load_layout():
	var layout_path = load("res://layouts/%s.tscn" % [layout_name])
	var layout_instance = layout_path.instantiate()
	$layout.add_child(layout_instance)
	layout = $layout.get_child(0)
	tilemap = layout.tilemap
