extends State

var max_speed: float = 75.0
var acceleration: float = 4.0
var jump_height: float = -200.0

# we want to export the nodes paths and return them when we want to switch states, see state machine on why
@export_node_path() var air_path: NodePath

# tip: if there is code on the class that we inherit from that you want to use, use "super()" when you want
# it to happen. it will execute at that spot, if you dont itll get overwritten
func enter():
	state_machine.sprite.play("walk")

func physics_process(delta):
	parent.velocity.x = clamp(parent.velocity.x + (sign(state_machine.sprite.scale.x) * acceleration), -max_speed, max_speed)
	# debug jumping ability that switches to the air state
	if Input.is_key_pressed(KEY_W):
		parent.velocity.y = jump_height
		return get_node(air_path)
	# if you want to change states do it after move and slide so everything updates nicely, as return
	# exits the loop
	parent.move_and_slide()
	if !parent.is_on_floor():
		return get_node(air_path)

func exit():
	pass
