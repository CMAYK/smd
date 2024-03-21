extends State

# we want to export the nodes paths and return them when we want to switch states, see state machine on why
@export_node_path() var walk_path: NodePath

func enter():
	return get_node(walk_path)

func _physics_process(delta: float) -> void:
	pass
