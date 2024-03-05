extends Node2D

func sort_ascending(a, b):
	if a[0] < b[0]:
		return true
	return false

func _ready():
	var my_items = [[5, "Potato"], [9, "Rice"], [4, "Tomato"]]
	my_items.sort_custom(sort_ascending)
	print(my_items) # Prints [[4, Tomato], [5, Potato], [9, Rice]].

	# Descending, lambda version.
	my_items.sort_custom(func(a, b): return a[0] > b[0])
	print(my_items) # Prints [[9, Rice], [5, Potato], [4, Tomato]].
