extends AudioStreamPlayer2D

var sfx
var volume = 0
var from

func _ready():
	stream = sfx
	volume_db = volume
	play(from)

func _on_finished():
	queue_free()
