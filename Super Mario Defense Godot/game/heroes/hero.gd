extends CharacterBody2D

var gravity = 1000

var speed = 75.0
var health = 24

@onready var playstate = get_parent().get_parent()
@onready var sound_player = playstate.sound_player
@export var target_pos = Marker2D
@onready var anim = $sprite/AnimationPlayer
@onready var sprite = $sprite

var normal = Vector2.ZERO

func _physics_process(delta):
	if speed < 75:
		speed += 4
	
	$health.text = str(health)
	$health.rotation = -self.rotation
	velocity.x = speed

	if is_on_floor():
		normal = get_floor_normal()
		self.rotation = lerp(self.rotation, normal.angle()+ PI / 2, 0.1)
		anim.play("walk")
	else:
		velocity.y += gravity * delta
	if health <= 0:
		_kill()
	
	move_and_slide()



func _kill():

	var fx = load("res://game/effects/cloud.tscn").instantiate()
	get_parent().add_child(fx)
	fx.position = self.position
	fx = load("res://game/heroes/mario_defeated.tscn").instantiate()
	get_parent().add_child(fx)
	fx.position = self.position

	var sp = sound_player.instantiate()
	sp.sfx = load("res://game/sounds/smw_yoshi_stomp.wav")
	sp.volume = 0
	sp.from = 0.02
	sp.position = self.position
	playstate.add_child(sp)

	queue_free()


func _on_hero_hurtbox_area_entered(area):
		if area:
			area.pierce -= 1
			speed -= area.knockback*3
			
			if health - area.damage > 0:
				var sp = sound_player.instantiate()
				sp.sfx = load("res://game/sounds/smw_stomp.wav")
				sp.volume = 0
				sp.from = 0.02
				sp.position = self.position
				playstate.add_child(sp)

			health -= area.damage
