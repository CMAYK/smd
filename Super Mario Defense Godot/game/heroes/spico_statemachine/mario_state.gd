extends CharacterBody2D

@export var health : int
@export_node_path() var jump_path: NodePath
@export_node_path() var knockback_path: NodePath
@export_node_path() var die_path: NodePath
@export_node_path() var walk_path: NodePath
@export var collision: CollisionShape2D
@export var area2d: Area2D

@onready var state_machine = $StateMachine
@onready var playstate = get_parent().get_parent()
@onready var sound_player = playstate.sound_player

var knockback_amt
var hit_dir
var hit_pos

func _ready():
	$health.text = str(health)

func _physics_process(delta):
	$health.rotation = -self.rotation
	if Input.is_action_just_pressed("ui_accept"):
		state_machine.change_state(get_node(jump_path)) 

func _on_hurtbox_area_entered(area):
	if area:
		area.pierce -= 1
		hit_dir = area.direction
		hit_pos = area.global_position

		if health - area.damage > 0:
			var sp = sound_player.instantiate()
			sp.sfx = load("res://game/sounds/smw_stomp.wav")
			sp.volume = 0
			sp.from = 0.02
			sp.position = self.position
			playstate.add_child(sp)
			health -= area.damage
			$health.text = str(health)
			if area.knockback > 0 and state_machine.current_state != get_node(knockback_path):
				knockback_amt = area.knockback
				state_machine.change_state(get_node(knockback_path))
		else:
			$health.text = "0"
			var fx = load("res://game/effects/cloud.tscn").instantiate()
			get_parent().add_child(fx)
			fx.position = self.position

			var sp = sound_player.instantiate()
			sp.sfx = load("res://game/sounds/smw_yoshi_stomp.wav")
			sp.volume = 0
			sp.from = 0.02
			sp.position = self.position
			playstate.add_child(sp)
			state_machine.change_state(get_node(die_path))
