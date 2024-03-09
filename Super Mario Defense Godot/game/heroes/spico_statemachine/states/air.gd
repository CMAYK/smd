extends State

var max_speed: float = 75.0
var acceleration: float = 4.0
var gravity: float = 10.0

# we want to export the nodes paths and return them when we want to switch states, see state machine on why
@export_node_path() var walk_path: NodePath

func enter():
	state_machine.sprite.play("jump")

func physics_process(delta):
	parent.velocity.x = clamp(parent.velocity.x + (sign(state_machine.sprite.scale.x) * acceleration), -max_speed, max_speed)
	parent.velocity.y += gravity
	# if you want to change states do it after move and slide so everything updates nicely, as return
	# exits the loop
	parent.move_and_slide()
	if parent.is_on_floor():
		return get_node(walk_path)

