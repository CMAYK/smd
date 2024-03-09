extends Node2D

@export var projectile : PackedScene
@export var spawn_pos : Marker2D

@export var damage : int
@export var pierce : int
@export var reload : float
@export var radius : float
@export var knockback : float
@export var projectile_speed : float

@onready var playstate = get_parent().get_parent()
@onready var sound_player = playstate.sound_player

var hero_list = []
var reloaded : bool = false
var timer = 0
var current_hero
var target_pos : Vector2

func _ready():
	$sight/radius.shape.set_radius(radius)

func _physics_process(delta):

	if reloaded == false:
		timer += 1
	if timer >= reload:
		reloaded = true
		timer = 0.0

	if !hero_list.is_empty():
		current_hero = _get_first(hero_list)
		target_pos = current_hero.get_parent().target_pos.global_position
		if reloaded:
			_shoot()
			reloaded = false

func _shoot():
	var p = projectile.instantiate()
	p.global_position = spawn_pos.global_position
	p.direction = 135
	p.speed = projectile_speed
	p.damage = damage
	p.knockback = knockback
	p.pierce = pierce
	get_parent().add_child(p)

	var sp = sound_player.instantiate()
	sp.sfx = load("res://game/sounds/smw_thud.wav")
	sp.volume = 0
	sp.from = 0.13
	sp.position = self.position
	playstate.add_child(sp)

func _get_first(array:Array):
	if array.is_empty() == false:
		array.sort_custom(first)
		return array[0]

func first(a, b):
	if a.global_position > b.global_position:
		return true
	return false

func _on_sight_area_entered(area):
	if area:
		hero_list.append(area)
func _on_sight_area_exited(area):
	if area:
		hero_list.erase(area)
