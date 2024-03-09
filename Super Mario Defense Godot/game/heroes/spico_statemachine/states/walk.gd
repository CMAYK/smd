extends State

var normal_velocity: Vector2

var gravity: float = 50.0
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
	normal_velocity = Vector2(clamp(normal_velocity.x + (sign(state_machine.sprite.scale.x) * acceleration), -max_speed, max_speed), 0)
	parent.velocity = Vector2(normal_velocity).rotated(parent.rotation)
	parent.velocity.y += gravity
	# if you want to change states do it after move and slide so everything updates nicely, as return
	# exits the loop
	parent.move_and_slide()
	if parent.is_on_floor():
		var floor_normal = parent.get_floor_normal()
		parent.rotation = lerp(parent.rotation, floor_normal.angle()+ PI / 2, 0.1)

func exit():
	pass
