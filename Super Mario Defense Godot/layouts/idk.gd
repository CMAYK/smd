extends Node2D

func _ready():
	var arr = [Vector2(0, 1), Vector2(2, 0), Vector2(1, 1), Vector2(1, 0), Vector2(0, 2)]
	# In this example we compare the lengths.
	print(arr.max())

func is_length_greater(a, b):
	return a.length() > b.length()
