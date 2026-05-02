extends Node2D
class_name PlacementGrid

# Stores all occupied pixels as a set of Vector2i keys
var _occupied: Dictionary = {}

# Maps tower instance ID -> array of Vector2i pixels it occupies
var _tower_pixels: Dictionary = {}

# Cache loaded mask images per tower type
var _mask_cache: Dictionary = {}

# Default mask: 16x16 solid rectangle
var _default_mask: Image


func _ready() -> void:
	_default_mask = Image.create(16, 16, false, Image.FORMAT_RGBA8)
	_default_mask.fill(Color(1, 1, 1, 1))


## Get the placement mask image for a tower type
func get_mask(tower_type: String) -> Image:
	if _mask_cache.has(tower_type):
		return _mask_cache[tower_type]

	# Try to load a mask PNG for this tower type
	var mask_path := "res://resources/sprites/masks/%s_mask.png" % tower_type
	var mask_image: Image = null

	if ResourceLoader.exists(mask_path):
		var tex := load(mask_path) as Texture2D
		if tex:
			mask_image = tex.get_image()

	if mask_image == null:
		mask_image = _default_mask

	_mask_cache[tower_type] = mask_image
	return mask_image


## Get the mask offset (center-bottom anchor by default)
## The mask is positioned so that the tower's snapped position is at the
## horizontal center and vertical bottom of the mask
func get_mask_offset(tower_type: String) -> Vector2i:
	var def: Dictionary = GameManager.tower_defs.get(tower_type, {})
	if def.has("mask_offset"):
		return def["mask_offset"] as Vector2i

	# Default: center-bottom origin
	var mask: Image = get_mask(tower_type)
	return Vector2i(-mask.get_width() / 2, -mask.get_height())


## Check if a tower can be placed at the given snapped position
func can_place(tower_type: String, snapped_pos: Vector2) -> bool:
	var mask: Image = get_mask(tower_type)
	var offset: Vector2i = get_mask_offset(tower_type)
	var origin := Vector2i(int(snapped_pos.x), int(snapped_pos.y)) + offset

	for y in range(mask.get_height()):
		for x in range(mask.get_width()):
			var pixel_color: Color = mask.get_pixel(x, y)
			if pixel_color.a > 0.5:
				var world_pixel := Vector2i(origin.x + x, origin.y + y)
				if _occupied.has(world_pixel):
					return false
	return true


## Register a placed tower's pixels as occupied
func register_tower(tower: Tower, snapped_pos: Vector2) -> void:
	var mask: Image = get_mask(tower.tower_type)
	var offset: Vector2i = get_mask_offset(tower.tower_type)
	var origin := Vector2i(int(snapped_pos.x), int(snapped_pos.y)) + offset

	var pixels: Array[Vector2i] = []

	for y in range(mask.get_height()):
		for x in range(mask.get_width()):
			var pixel_color: Color = mask.get_pixel(x, y)
			if pixel_color.a > 0.5:
				var world_pixel := Vector2i(origin.x + x, origin.y + y)
				_occupied[world_pixel] = true
				pixels.append(world_pixel)

	_tower_pixels[tower.get_instance_id()] = pixels


## Unregister a tower's pixels (when sold/removed)
func unregister_tower(tower: Tower) -> void:
	var tid: int = tower.get_instance_id()
	if _tower_pixels.has(tid):
		var pixels: Array = _tower_pixels[tid]
		for pixel in pixels:
			_occupied.erase(pixel)
		_tower_pixels.erase(tid)


## Get the pixel positions a mask would occupy (for debug/preview drawing)
func get_mask_pixels(tower_type: String, snapped_pos: Vector2) -> Array[Vector2i]:
	var mask: Image = get_mask(tower_type)
	var offset: Vector2i = get_mask_offset(tower_type)
	var origin := Vector2i(int(snapped_pos.x), int(snapped_pos.y)) + offset
	var pixels: Array[Vector2i] = []

	for y in range(mask.get_height()):
		for x in range(mask.get_width()):
			var pixel_color: Color = mask.get_pixel(x, y)
			if pixel_color.a > 0.5:
				pixels.append(Vector2i(origin.x + x, origin.y + y))

	return pixels


## Get the bounding rect of a mask at a given position (for preview tinting)
func get_mask_rect(tower_type: String, snapped_pos: Vector2) -> Rect2:
	var mask: Image = get_mask(tower_type)
	var offset: Vector2i = get_mask_offset(tower_type)
	var origin := Vector2(snapped_pos.x + float(offset.x), snapped_pos.y + float(offset.y))
	return Rect2(origin, Vector2(float(mask.get_width()), float(mask.get_height())))
