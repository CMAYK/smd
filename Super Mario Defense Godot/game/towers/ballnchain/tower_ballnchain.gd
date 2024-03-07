extends Area2D

var speed = 85
var damage = 5
var knockback = 50
var pierce = 100

func _process(delta: float) -> void:
	self.rotation_degrees += speed * delta
	$base.rotation = -self.rotation

func _kill():
	pass

func _on_area_entered(area):
	var areaparent = area.get_parent()
	areaparent.speed -= knockback*3
	areaparent.velocity.y -= knockback*2
	areaparent.health -= damage
