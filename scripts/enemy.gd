extends CharacterBody2D
class_name Enemy

signal died(enemy: Enemy, coin_reward: int)
signal reached_castle(enemy: Enemy)

@export var move_speed: float = 25.0
@export var max_hp: float = 5.0
@export var coin_reward: int = 5

var current_hp: float
var castle_x: float = 0.0
var is_alive: bool = true

const MARIO_SHEET_PATH := "res://resources/sprites/mario/mario.png"

# Variable-width frame definitions: [x, y, width, height] for each frame
# 16 frames total in a 279x32 sheet
# Adjust these rects to match your actual sprite layout
var frame_rects: Array[Rect2i] = [
	Rect2i(0, 0, 14, 32),    # 0: walk1
	Rect2i(15, 0, 15, 32),   # 1: walk2
	Rect2i(31, 0, 14, 32),   # 2: walk_hold1
	Rect2i(47, 0, 15, 32),   # 3: walk_hold2
	Rect2i(63, 0, 16, 32),   # 4: kick_held
	Rect2i(80, 0, 16, 32),   # 5: run1
	Rect2i(97, 0, 15, 32),  # 6: run2
	Rect2i(113, 0, 16, 32),  # 7: jump
	Rect2i(130, 0, 16, 32),  # 8: fall
	Rect2i(147, 0, 15, 32),  # 9: ride_yoshi
	Rect2i(163, 0, 16, 32),  # 10: death1
	Rect2i(180, 0, 16, 32),  # 11: death2
	Rect2i(204, 0, 16, 32),  # 12: falling1
	Rect2i(221, 0, 16, 32),  # 13: falling2
	Rect2i(238, 0, 20, 32),  # 14: falling_land1
	Rect2i(259, 0, 20, 32),  # 15: falling_land2
]

var anim_sprite: AnimatedSprite2D = null

@onready var hp_bar_bg: ColorRect = $HPBarBG
@onready var hp_bar: ColorRect = $HPBar


func _ready() -> void:
	current_hp = max_hp
	_setup_mario_sprite()
	_update_hp_bar()
	add_to_group("enemies")


func _setup_mario_sprite() -> void:
	var sheet := load(MARIO_SHEET_PATH) as Texture2D
	if not sheet:
		return

	if has_node("Sprite"):
		$Sprite.queue_free()

	anim_sprite = AnimatedSprite2D.new()
	var frames := SpriteFrames.new()
	var img: Image = sheet.get_image()

	# Walk animation (frames 0 and 1)
	frames.add_animation("walk")
	frames.set_animation_speed("walk", 6.0)
	frames.set_animation_loop("walk", true)
	for i in [0, 1]:
		var rect: Rect2i = frame_rects[i]
		var frame_img := img.get_region(rect)
		var frame_tex := ImageTexture.create_from_image(frame_img)
		frames.add_frame("walk", frame_tex)

	# Death animation (frames 10 and 11)
	frames.add_animation("death")
	frames.set_animation_speed("death", 4.0)
	frames.set_animation_loop("death", false)
	for i in [10, 11]:
		var rect: Rect2i = frame_rects[i]
		var frame_img := img.get_region(rect)
		var frame_tex := ImageTexture.create_from_image(frame_img)
		frames.add_frame("death", frame_tex)

	anim_sprite.sprite_frames = frames
	anim_sprite.offset = Vector2(0, -16)
	anim_sprite.play("walk")
	add_child(anim_sprite)


func _physics_process(delta: float) -> void:
	if not is_alive:
		return

	velocity = Vector2(move_speed, 0)
	move_and_slide()

	if global_position.x >= castle_x:
		_reach_castle()


func take_damage(amount: float) -> void:
	if not is_alive:
		return

	current_hp -= amount
	_update_hp_bar()

	if anim_sprite:
		anim_sprite.modulate = Color(10, 10, 10, 1)
		var tween := create_tween()
		tween.tween_property(anim_sprite, "modulate", Color(1, 1, 1, 1), 0.15)
	elif has_node("Sprite"):
		$Sprite.color = Color.WHITE
		var tween := create_tween()
		tween.tween_property($Sprite, "color", Color(0.9, 0.2, 0.2), 0.15)

	if current_hp <= 0:
		_die()


func _die() -> void:
	is_alive = false
	died.emit(self, coin_reward)

	if anim_sprite and anim_sprite.sprite_frames.has_animation("death"):
		anim_sprite.play("death")

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
		hp_bar.color = Color(1.0 - ratio, ratio, 0.0)
