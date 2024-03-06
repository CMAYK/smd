extends Node2D

var speed := 80.0

func _process(delta: float) -> void:
	$ballnchain.rotation_degrees += speed * delta
