# DONT FORGET TO EXTEND ALL STATES WITH STATE
class_name State
extends Node

# for references
var parent
var state_machine

# called when the state is entered
func enter():
	pass

# a doppelganger function of the regular physics process that we can use to trigger whenever we want
# MIND THAT THERE IS NO UNDERSCORE IN FRONT
func physics_process(delta):
	pass

# called when the state is exited
func exit():
	pass
