extends Camera2D

@export var tilemap: TileMap


func _ready():

	var mapRect = tilemap.get_used_rect()
	var tileSize = tilemap.rendering_quadrant_size
	var worldSizeInPixels = mapRect.size * tileSize
	limit_right = worldSizeInPixels.x

	print_debug(worldSizeInPixels.x)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("scroll_up"):
		self.position.x -= 128/2
	if Input.is_action_just_released("scroll_down"):
		self.position.x += 128/2


	self.position.x = clamp(self.position.x, get_viewport_rect().size.x /4, limit_right - get_viewport_rect().size.x /4)

	
	print(get_viewport_rect().size.x /4)
	
