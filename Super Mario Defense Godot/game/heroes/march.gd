extends State

signal state_transition

@export var anim : AnimationPlayer



func _Enter():
	anim.play("walk")

func _Update(delta:float):
	pass
	
	#if health = 0
	#Transition die
	
	#if entered jump trigger 
	#Transition Jump

	#if projectile enters and knockback > 0
	#Transition Knockback 

func _Exit():
	pass
