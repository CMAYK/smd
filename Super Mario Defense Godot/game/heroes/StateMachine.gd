extends Node
class_name State

var states = {}
@export var initial_state : State
var current_state

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_transition.connect(_change_state)

	if initial_state:
		initial_state._Enter()
		current_state = initial_state

func _physics_process(delta):
	if current_state:
		current_state._Update(delta)

func _change_state(source_state:State, new_state_name:String):
	if source_state != current_state:
		print("Invalid state_change")
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		print("new_state is empty")
		return

	if current_state:
		current_state._Exit()
	new_state._Enter()

func _Enter():
	pass

func _Update(delta:float):
	pass

func _Exit():
	pass
