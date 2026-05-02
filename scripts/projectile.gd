extends Area2D
class_name Projectile

var speed: float = 80.0
var damage: float = 1.0
var direction: Vector2 = Vector2.RIGHT
var lifetime: float = 5.0

var shell_sprite: AnimatedSprite2D = null


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	_setup_shell_sprite()


func _setup_shell_sprite() -> void:
	# Hide the placeholder ColorRect
	var placeholder: ColorRect = get_node_or_null("Sprite")
	if placeholder:
		placeholder.visible = false

	# Shell projectile: 67x16, 4 frames of 16x16 with 1px padding
	var shell_tex := load("res://resources/sprites/koopa_shell_projectile.png") as Texture2D
	if shell_tex:
		shell_sprite = AnimatedSprite2D.new()
		var frames := SpriteFrames.new()
		frames.add_animation("spin")
		var img: Image = shell_tex.get_image()
		for i in range(4):
			var frame_img := img.get_region(Rect2i(i * 17, 0, 16, 16))
			frames.add_frame("spin", ImageTexture.create_from_image(frame_img))
		frames.set_animation_speed("spin", 12.0)
		frames.set_animation_loop("spin", true)
		shell_sprite.sprite_frames = frames
		shell_sprite.play("spin")
		add_child(shell_sprite)


func _process(delta: float) -> void:
	position += direction * speed * delta
	lifetime -= delta
	if lifetime <= 0:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		(body as Enemy).take_damage(damage)
		queue_free()
