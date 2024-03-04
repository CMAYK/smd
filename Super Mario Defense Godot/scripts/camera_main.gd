extends Camera2D

#var tilemap: TileMap
var continue_load: bool = false
var scroll_method = 0 #0 = scrolling / 1 = A+D / 2 = cursor position

func _ready():
	pass
#	DisplayServer.window_set_size(Vector2(400*3.2, 224*3.21428571))
#	DisplayServer.window_set_position(Vector2.ZERO)

func _physics_process(delta):

	#this changes scrolling input method
	if Input.is_action_just_released("test5"):
		scroll_method += 1
		if scroll_method >= 4: 
			scroll_method = 0
	match scroll_method:
		0: #scroll wheel input
			#print("scrolling with mw")
			if Input.is_action_just_released("scrollw_up"):
				self.position.x -= 128/2
			if Input.is_action_just_released("scrollw_down"):
				self.position.x += 128/2	
		1: #scroll via A and D input
			#print("scrolling with A/D")
			if Input.is_action_just_pressed("scrollb_up"):
				self.position.x -= 128/2
			if Input.is_action_just_pressed("scrollb_down"):
				self.position.x += 128/2	
		2: #a third secret scrolling option
			pass

	#this changes the game window size; test1, 2 and 3 correspond to placeholder inputs mapped in project settings
	if Input.is_action_just_pressed("test1"):
		_update_window_res(400, 226)
	if Input.is_action_just_pressed("test2"):
		_update_window_res(1280, 720)
	if Input.is_action_just_pressed("test3"):
		_update_window_res(1920, 1080)
	if Input.is_action_just_pressed("test4"):
		_update_window_res(2560, 1440)

	self.position.x = clamp(self.position.x, get_viewport_rect().size.x /2, limit_right - get_viewport_rect().size.x /2)

func _limit_camera(tilemap:TileMap):
	
	var mapRect = tilemap.get_used_rect()
	var tileSize = tilemap.rendering_quadrant_size
	var worldSizeInPixels = mapRect.size * tileSize
	limit_right = worldSizeInPixels.x

func _update_window_res(size_x,size_y):
	DisplayServer.window_set_size(Vector2(size_x, size_y))
	print(str(size_y) + "p")

	var window_size = Vector2(size_x,size_y)
	var screen_size = DisplayServer.screen_get_size(DisplayServer.window_get_current_screen())
	var centered = Vector2(screen_size.x/2 - window_size.x/2, screen_size.y/2 - window_size.y/2)
	DisplayServer.window_set_position(centered)
