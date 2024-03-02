extends Camera2D

var FOLLOW_POINT = clamp(0, 0.0, 10.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	FOLLOW_POINT = clamp(FOLLOW_POINT, -512.0, 512.0)
	if Input.is_action_just_released("scroll_up"):
		FOLLOW_POINT -= 128
	if Input.is_action_just_released("scroll_down"):
		FOLLOW_POINT += 128

	self.position.x = FOLLOW_POINT
