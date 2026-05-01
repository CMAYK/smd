extends Node
#human, I remember your globals

var tilemap: TileMap

#timer for color modulataion on bowser statue laser
var time = 0.1 #probably could've used a better var name for this
var timer = 0.1 #probably could've used a better var name for this
var colormod = 0 #probably could've used a better var name for this

var basehealth = 100

func _ready():
	timer = time
	basehealth = 100

func _process(delta):
	timer -= 1 
	if timer <= 0:
		timer = time
		colormod += 1
		if colormod >= 5: #5 is the amount of colors used in the modulation array in the bowser statue laser
			colormod = 0
