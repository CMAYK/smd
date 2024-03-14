extends State

var max_speed: float = 75.0
var acceleration: float = 5.0
var gravity: float = 10.0
var traction: float = 10
var hit_dir

# we want to export the nodes paths and return them when we want to switch states, see state machine on why
@export_node_path() var walk_path: NodePath
@export_node_path() var air_path: NodePath

func enter():
	
	hit_dir = parent.hit_pos.direction_to(parent.global_position)
	parent.velocity.x = parent.knockback_amt * hit_dir.x
	state_machine.sprite.play("fall")

func physics_process(delta):
	parent.velocity.x += traction * -hit_dir.x
	parent.velocity.y += gravity
	# if you want to change states do it after move and slide so everything updates nicely, as return
	# exits the loop
	parent.move_and_slide()
	if parent.velocity.x == 0:
		if parent.is_on_floor():
			return get_node(walk_path)
		else:
			return get_node(air_path)

