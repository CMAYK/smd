extends CharacterBody2D
class_name Enemy

signal died(enemy: Enemy, coin_reward: int)
signal reached_castle(enemy: Enemy)

@export var move_speed: float = 25.0
@export var max_hp: float = 5.0
@export var coin_reward: int = 5

var current_hp: float
var castle_x: float = 0.0  # Set by spawner
var is_alive: bool = true

@onready var sprite: ColorRect = $Sprite
@onready var hp_bar_bg: ColorRect = $HPBarBG
@onready var hp_bar: ColorRect = $HPBar


func _ready() -> void:
	current_hp = max_hp
	_update_hp_bar()
	add_to_group("enemies")


func _physics_process(delta: float) -> void:
	if not is_alive:
		return

	velocity = Vector2(move_speed, 0)
	move_and_slide()

	# Check if reached castle
	if global_position.x >= castle_x:
		_reach_castle()


func take_damage(amount: float) -> void:
	if not is_alive:
		return

	current_hp -= amount
	_update_hp_bar()

	# Flash white briefly
	sprite.color = Color.WHITE
	var tween := create_tween()
	tween.tween_property(sprite, "color", Color(0.9, 0.2, 0.2), 0.15)

	if current_hp <= 0:
		_die()


func _die() -> void:
	is_alive = false
	died.emit(self, coin_reward)
	# Simple death effect - shrink and fade
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.3)
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	tween.chain().tween_callback(queue_free)


func _reach_castle() -> void:
	is_alive = false
	reached_castle.emit(self)
	queue_free()


func _update_hp_bar() -> void:
	if hp_bar:
		var ratio := clampf(current_hp / max_hp, 0.0, 1.0)
		hp_bar.size.x = 14.0 * ratio
		# Color shifts from green to red
		hp_bar.color = Color(1.0 - ratio, ratio, 0.0)
