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
	if Input.is_action_pressed("test1"):
		DisplayServer.window_set_size(Vector2(640, 380))
	if Input.is_action_pressed("test2"):
		DisplayServer.window_set_size(Vector2(640*2, 380*2))
	if Input.is_action_pressed("test3"):
		DisplayServer.window_set_size(Vector2(640*3, 380*3))

	if Input.is_action_just_released("scroll_up"):
		self.position.x -= 128/2
	if Input.is_action_just_released("scroll_down"):
		self.position.x += 128/2

	self.position.x = clamp(self.position.x, get_viewport_rect().size.x /2, limit_right - get_viewport_rect().size.x /2)
