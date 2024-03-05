extends Node2D

func _ready():
	$StarBurst/AnimationPlayer.play("bang!")

func _on_animation_player_animation_finished(anim_name):
	queue_free()
