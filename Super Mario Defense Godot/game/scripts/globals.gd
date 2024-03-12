extends Node

var tilemap: TileMap

var time = 0.1
var timer = 0.1
var colormod = 0

func _ready():
	timer = time

func _process(delta):
	timer -= 1
	if timer <= 0:
		timer = time
		colormod += 1
		if colormod >= 5:
			colormod = 0
