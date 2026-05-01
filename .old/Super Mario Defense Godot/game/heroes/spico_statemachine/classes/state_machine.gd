class_name StateMachine
extends Node

@export_node_path() var parent_path: NodePath
@export_node_path() var starting_state_path: NodePath

@onready var parent = get_node(parent_path)
@onready var sprite = get_parent().get_node("looks/sprite")
var current_state: Node

func _ready():
	# we set the parent and state nodes of the children states so we can reference them and their contents
	# this will be how we reference characterbodies velocities for example
	for state_node in get_children():
		# DONT FORGET TO EXTEND ALL STATES WITH STATE
		state_node.parent = parent
		state_node.state_machine = self
	current_state = get_node(starting_state_path)
	current_state.enter()

# using the doppelganger physics process function we made so it only triggers the state we want
# MIND THAT THERE ISNT AN UNDERSCORE IN FRONT OF THE ONE WE HAVE
func _physics_process(delta):
	var new_state = current_state.physics_process(delta)
	# the returned value should be the node itself, dont forget to do "get_node(state_path)" before returning.
	# if we return the path directly it will not find anything as its based on the location of the node that
	# returns it
	if new_state:
		change_state(new_state)

# change state, and run the exit and enter functions
func change_state(new_state: Node):
	current_state.exit()
	current_state = new_state
	current_state.enter()
