extends Camera2D

var FOLLOW_POINT = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("scroll_up"):
		FOLLOW_POINT -= 50
	if Input.is_action_just_released("scroll_down"):
		FOLLOW_POINT += 50

	self.position.x = lerp(self.position.x, FOLLOW_POINT, 0.02)
