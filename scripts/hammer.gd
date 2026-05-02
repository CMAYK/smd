extends Area2D
class_name Hammer

var velocity: Vector2 = Vector2.ZERO
var fall_accel: float = 0.0
var bounce_vy: float = 0.0
var ground_y: float = 192.0
var damage_per_tick: float = 0.0
var tick_rate: float = 0.0
var has_bounced: bool = false
var lifetime: float = 4.0

var damage_timers: Dictionary = {}
var anim_sprite: AnimatedSprite2D = null


func _ready() -> void:
	# Create animated sprite from hammer spritesheet
	# 133x16 image, 8 frames of 16x16 with 1px padding = 17px stride
	var tex := load("res://resources/sprites/hammer_anim.png") as Texture2D
	if tex:
		anim_sprite = AnimatedSprite2D.new()
		var frames := SpriteFrames.new()
		frames.add_animation("spin")
		var img: Image = tex.get_image()
		for i in range(8):
			var frame_img := img.get_region(Rect2i(i * 17, 0, 16, 16))
			var frame_tex := ImageTexture.create_from_image(frame_img)
			frames.add_frame("spin", frame_tex)
		frames.set_animation_speed("spin", 16.0)
		frames.set_animation_loop("spin", true)
		anim_sprite.sprite_frames = frames
		anim_sprite.play("spin")
		add_child(anim_sprite)
		# Hide the default ColorRect
		$Sprite.visible = false


func _process(delta: float) -> void:
	velocity.y += fall_accel * delta
	position += velocity * delta

	# Bounce off ground once
	if not has_bounced and position.y >= ground_y - 3.0:
		position.y = ground_y - 3.0
		velocity.y = bounce_vy
		has_bounced = true
	elif has_bounced and position.y > ground_y + 60.0:
		queue_free()
		return

	# DPS tick on overlapping enemies
	for body in get_overlapping_bodies():
		if body is Enemy and body.is_alive:
			var eid: int = body.get_instance_id()
			if not damage_timers.has(eid):
				damage_timers[eid] = 0.0
				body.take_damage(damage_per_tick)
			else:
				damage_timers[eid] -= delta
				if damage_timers[eid] <= 0.0:
					body.take_damage(damage_per_tick)
					damage_timers[eid] = tick_rate

	# Clean up stale timers
	var current_ids: Array[int] = []
	for body in get_overlapping_bodies():
		current_ids.append(body.get_instance_id())
	for eid in damage_timers.keys():
		if eid not in current_ids:
			damage_timers.erase(eid)

	lifetime -= delta
	if lifetime <= 0:
		queue_free()
