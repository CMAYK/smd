extends Node2D

var hero_bodies = []
var current_hero
var bullet = preload("res://game/towers/Bullet.tscn")
@onready var spawn_pos = $spawn_pos
@onready var head = $barrel_sprite

func _ready():
	pass

func _process(delta):
	if hero_bodies.is_empty() == false:
		hero_bodies.sort_custom(first)
		current_hero =  hero_bodies[0]
		$Sight/Redbox.global_position = Vector2(current_hero.global_position.x, current_hero.global_position.y - 30)


func first(a, b):
	if a.global_position > b.global_position:
		return true
	return false

func _on_sight_body_entered(body):
	if body:
		hero_bodies.append(body)
func _on_sight_body_exited(body):
	if body:
		hero_bodies.erase(body)

func _on_fire_rate_timeout():
	if current_hero:
		if hero_bodies:
			if current_hero == hero_bodies[0]:
				$barrel_sprite/AnimationPlayer.play("RESET")
				$barrel_sprite/AnimationPlayer.play("fire")
				head.look_at(current_hero.global_position)
				var bullet_instance = bullet.instantiate()
				bullet_instance.global_position = spawn_pos.global_position
				bullet_instance.target = current_hero
				get_parent().add_child(bullet_instance)
