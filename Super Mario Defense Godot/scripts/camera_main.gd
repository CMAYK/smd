extends Camera2D

#var tilemap: TileMap
var continue_load: bool = false

func _ready():
	pass

func _limit_camera(tilemap):
		var mapRect = tilemap.get_used_rect()
		var tileSize = tilemap.rendering_quadrant_size
		var worldSizeInPixels = mapRect.size * tileSize
		limit_right = worldSizeInPixels.x

func _physics_process(delta):
	if Input.is_action_pressed("w"):
		pass
	if Input.is_action_just_released("scroll_up"):
		self.position.x -= 128/2
	if Input.is_action_just_released("scroll_down"):
		self.position.x += 128/2

	self.position.x = clamp(self.position.x, get_viewport_rect().size.x /4, limit_right - get_viewport_rect().size.x /4)
