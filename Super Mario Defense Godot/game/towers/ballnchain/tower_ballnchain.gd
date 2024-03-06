extends Area2D

var speed = 85
var damage = 5

func _process(delta: float) -> void:
	self.rotation_degrees += speed * delta
	$base.rotation = -self.rotation

func _kill():
	pass

func _on_area_entered(area):
	var areaparent = area.get_parent()
	if areaparent.ballhit == false:
		areaparent.speed -= speed *2
		areaparent.health -= damage
		areaparent.ballhit = true
