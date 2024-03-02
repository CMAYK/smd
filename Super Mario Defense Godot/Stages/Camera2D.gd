extends Camera2D

var FOLLOW_POINT = clamp(0, 0.0, 10.0)
@onready var tilemap = Globals.tilemap

func _ready():
	await get_tree().create_timer(1.0).timeout
	var mapRect = tilemap.get_used_rect()
	var tileSize = tilemap.rendering_quadrant_size
	var worldSizeInPixels = mapRect.size * tileSize
	limit_right = worldSizeInPixels.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#FOLLOW_POINT = clamp(FOLLOW_POINT, -512.0, 512.0)
	if Input.is_action_just_released("scroll_up"):
		FOLLOW_POINT -= 128
	if Input.is_action_just_released("scroll_down"):
		FOLLOW_POINT += 128

	self.position.x = FOLLOW_POINT
