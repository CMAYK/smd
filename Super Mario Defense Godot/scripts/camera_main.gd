extends Camera2D

#var tilemap: TileMap
var continue_load: bool = false
var scroll_method = 0 #0 = scrolling / 1 = A+D / 2 = cursor position

func _ready():
	pass

func _limit_camera(tilemap):
		var mapRect = tilemap.get_used_rect()
		var tileSize = tilemap.rendering_quadrant_size
		var worldSizeInPixels = mapRect.size * tileSize
		limit_right = worldSizeInPixels.x

func _physics_process(delta):
	#this changes the game window size; test1, 2 and 3 correspond to placeholder inputs mapped in project settings
	if Input.is_action_pressed("test1"):
		print("base res")
		DisplayServer.window_set_size(Vector2(640, 380)) # 1x base res
	if Input.is_action_pressed("test2"):
		print("720p")
		DisplayServer.window_set_size(Vector2(640*2, 380*2)) # 720p
	if Input.is_action_pressed("test3"):
		print("1080p")
		DisplayServer.window_set_size(Vector2(640*3, 380*3)) # 1080p
	
	#this changes scrolling input method
	if Input.is_action_just_released("test4"):
		scroll_method += 1
		if scroll_method >= 4: 
			scroll_method = 0

	match scroll_method:
		0: #scroll wheel input
			print("scrolling with mw")
			if Input.is_action_just_released("scrollw_up"):
				self.position.x -= 128/2
			if Input.is_action_just_released("scrollw_down"):
				self.position.x += 128/2	
		1: #scroll via A and D input
			print("scrolling with A/D")
			if Input.is_action_just_pressed("scrollb_up"):
				self.position.x -= 128/2
			if Input.is_action_just_pressed("scrollb_down"):
				self.position.x += 128/2	
		2: #a third secret scrolling option
			pass

	self.position.x = clamp(self.position.x, get_viewport_rect().size.x /2, limit_right - get_viewport_rect().size.x /2)
