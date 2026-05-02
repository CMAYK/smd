extends CanvasLayer
class_name HUD

# ===== SIGNALS =====
signal tower_buy_requested(tower_type: String)
signal upgrade_requested()
signal sell_requested()
signal pause_requested()
signal next_wave_requested()

# ===== CONSTANTS =====
const SLOTS_PER_PAGE := 6
# page_dot.png is 9x4: left 4x4 = selected, 1px gap, right 4x4 = unselected
const DOT_SELECTED_REGION := Rect2(0, 0, 4, 4)
const DOT_UNSELECTED_REGION := Rect2(5, 0, 4, 4)

# ===== PRELOADED TEXTURES =====
var shop_slot_frame_tex: Texture2D = preload("res://resources/sprites/hud/shop_slot_frame.png")
var page_dot_tex: Texture2D = preload("res://resources/sprites/hud/page_dot.png")
var coin_icon_tex: Texture2D = preload("res://resources/sprites/hud/icon_coin.png")
var hp_icon_tex: Texture2D = preload("res://resources/sprites/hud/icon_hp.png")

# ===== TOWER SHOP STATE =====
var tower_types: Array[String] = []
var current_page: int = 0
var total_pages: int = 1

# ===== NODE REFERENCES =====
# Coin display
@onready var coin_label: Label = $HUDRoot/CoinRow/CoinLabel

# Left controls (manually positioned)
@onready var pause_button: TextureButton = $HUDRoot/PauseButton
@onready var next_wave_button: TextureButton = $HUDRoot/NextWaveButton
@onready var wave_label: Label = $HUDRoot/WaveLabel

# HP mushrooms
@onready var hp_container: HBoxContainer = $HUDRoot/HPContainer

# Tower shop
@onready var shop_container: HBoxContainer = $HUDRoot/ShopBar/ShopSlots
@onready var page_left_button: TextureButton = $HUDRoot/ShopBar/PageLeft
@onready var page_right_button: TextureButton = $HUDRoot/ShopBar/PageRight
@onready var page_dots_container: HBoxContainer = $HUDRoot/PageDots

# Tower info panel
@onready var tower_panel: PanelContainer = $HUDRoot/TowerPanel
@onready var tower_info_label: Label = $HUDRoot/TowerPanel/VBox/InfoLabel
@onready var upgrade_button: Button = $HUDRoot/TowerPanel/VBox/UpgradeButton
@onready var sell_button: Button = $HUDRoot/TowerPanel/VBox/SellButton

# Flash message & timer
@onready var message_label: Label = $HUDRoot/MessageLabel
@onready var timer_label: Label = $HUDRoot/TimerLabel

# Dynamic children
var hp_icons: Array[TextureRect] = []
var shop_slots: Array[Control] = []
var page_dot_selected_tex: AtlasTexture = null
var page_dot_unselected_tex: AtlasTexture = null
var page_dots: Array[TextureRect] = []


func _ready() -> void:
	tower_panel.visible = false
	message_label.visible = false
	timer_label.visible = false

	# Create atlas textures for page dots (split the 9x4 sprite)
	page_dot_selected_tex = AtlasTexture.new()
	page_dot_selected_tex.atlas = page_dot_tex
	page_dot_selected_tex.region = DOT_SELECTED_REGION

	page_dot_unselected_tex = AtlasTexture.new()
	page_dot_unselected_tex.atlas = page_dot_tex
	page_dot_unselected_tex.region = DOT_UNSELECTED_REGION

	# Connect buttons
	pause_button.pressed.connect(func() -> void: pause_requested.emit())
	next_wave_button.pressed.connect(func() -> void: next_wave_requested.emit())
	page_left_button.pressed.connect(_page_left)
	page_right_button.pressed.connect(_page_right)
	upgrade_button.pressed.connect(func() -> void: upgrade_requested.emit())
	sell_button.pressed.connect(func() -> void: sell_requested.emit())

	_build_tower_list()
	_build_shop_slots()
	_build_page_dots()
	_update_shop_page()


# ===== SETUP =====

func _build_tower_list() -> void:
	tower_types.clear()
	for key in GameManager.tower_defs.keys():
		tower_types.append(key)
	total_pages = maxi(1, ceili(float(tower_types.size()) / float(SLOTS_PER_PAGE)))


func _build_shop_slots() -> void:
	for child in shop_container.get_children():
		child.queue_free()
	shop_slots.clear()

	for i in range(SLOTS_PER_PAGE):
		var slot := _create_shop_slot(i)
		shop_container.add_child(slot)
		shop_slots.append(slot)


func _create_shop_slot(index: int) -> Control:
	# Use a plain Control so we can layer: tower icon (back) → frame (mid) → cost (front)
	var slot := Control.new()
	slot.custom_minimum_size = Vector2(32, 32)

	# Layer 1 (back): Tower icon sprite — centered in the 32x32 slot
	var icon := TextureRect.new()
	icon.name = "TowerIcon"
	icon.expand_mode = TextureRect.EXPAND_KEEP_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	slot.add_child(icon)

	# Layer 2 (mid): Shop frame sprite on top
	var frame := TextureRect.new()
	frame.texture = shop_slot_frame_tex
	frame.expand_mode = TextureRect.EXPAND_KEEP_SIZE
	frame.stretch_mode = TextureRect.STRETCH_KEEP
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.position = Vector2.ZERO
	slot.add_child(frame)

	# Layer 3 (front): Cost row
	var cost_row := HBoxContainer.new()
	cost_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cost_row.position = Vector2(-5, 0)
	cost_row.add_theme_constant_override("separation", 1)

	var coin_icon := TextureRect.new()
	coin_icon.texture = coin_icon_tex
	coin_icon.expand_mode = TextureRect.EXPAND_KEEP_SIZE
	coin_icon.stretch_mode = TextureRect.STRETCH_KEEP
	coin_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cost_row.add_child(coin_icon)

	var cost_label := Label.new()
	cost_label.name = "CostLabel"
	cost_label.text = "0"
	cost_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cost_row.add_child(cost_label)

	slot.add_child(cost_row)

	# Clickable area over the whole slot
	var click_btn := Button.new()
	click_btn.flat = true
	click_btn.position = Vector2.ZERO
	click_btn.size = Vector2(32, 32)
	click_btn.mouse_filter = Control.MOUSE_FILTER_STOP
	click_btn.pressed.connect(_on_slot_pressed.bind(index))
	slot.add_child(click_btn)

	return slot


func _build_page_dots() -> void:
	for child in page_dots_container.get_children():
		child.queue_free()
	page_dots.clear()

	if total_pages <= 1:
		page_dots_container.visible = false
		return

	page_dots_container.visible = true
	for i in range(total_pages):
		var dot := TextureRect.new()
		dot.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		dot.stretch_mode = TextureRect.STRETCH_KEEP
		dot.mouse_filter = Control.MOUSE_FILTER_IGNORE
		page_dots_container.add_child(dot)
		page_dots.append(dot)

	_update_page_dots()


func _update_page_dots() -> void:
	for i in range(page_dots.size()):
		if i == current_page:
			page_dots[i].texture = page_dot_selected_tex
		else:
			page_dots[i].texture = page_dot_unselected_tex


# ===== SHOP PAGINATION =====

func _page_left() -> void:
	if current_page > 0:
		current_page -= 1
		_update_shop_page()


func _page_right() -> void:
	if current_page < total_pages - 1:
		current_page += 1
		_update_shop_page()


func _update_shop_page() -> void:
	var start_idx: int = current_page * SLOTS_PER_PAGE

	for i in range(SLOTS_PER_PAGE):
		var tower_idx: int = start_idx + i
		var slot: Control = shop_slots[i]

		if tower_idx < tower_types.size():
			var ttype: String = tower_types[tower_idx]
			var def: Dictionary = GameManager.tower_defs[ttype]
			slot.visible = true

			var cost_label: Label = slot.find_child("CostLabel", true, false)
			if cost_label:
				cost_label.text = str(def["cost"])

			# Load tower shop icon: res://resources/sprites/hud/{tower_type}_shop.png
			var icon: TextureRect = slot.find_child("TowerIcon", true, false)
			if icon:
				var icon_path := "res://resources/sprites/hud/%s_shop.png" % ttype
				var tex := load(icon_path) as Texture2D
				if tex:
					icon.texture = tex
					# Center the icon in the 32x32 slot
					var tex_size := tex.get_size()
					icon.position = Vector2((32.0 - tex_size.x) / 2.0, (32.0 - tex_size.y) / 2.0 - 2.0)
				else:
					icon.texture = null
		else:
			slot.visible = false

	# Arrows: always show but dim when can't navigate
	page_left_button.disabled = current_page <= 0
	page_left_button.modulate.a = 1.0 if current_page > 0 else 0.3
	page_right_button.disabled = current_page >= total_pages - 1
	page_right_button.modulate.a = 1.0 if current_page < total_pages - 1 else 0.3

	_update_page_dots()


func _on_slot_pressed(slot_index: int) -> void:
	var tower_idx: int = current_page * SLOTS_PER_PAGE + slot_index
	if tower_idx < tower_types.size():
		tower_buy_requested.emit(tower_types[tower_idx])


# ===== HP ICONS =====

func setup_hp(max_hp: int) -> void:
	for icon in hp_icons:
		if is_instance_valid(icon):
			icon.queue_free()
	hp_icons.clear()

	for i in range(max_hp):
		var mush := TextureRect.new()
		mush.texture = hp_icon_tex
		mush.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		mush.stretch_mode = TextureRect.STRETCH_KEEP
		mush.mouse_filter = Control.MOUSE_FILTER_IGNORE
		hp_container.add_child(mush)
		hp_icons.append(mush)


func update_hp(current_hp: int) -> void:
	for i in range(hp_icons.size()):
		if is_instance_valid(hp_icons[i]):
			if i < current_hp:
				hp_icons[i].modulate = Color(1, 1, 1, 1)
			else:
				hp_icons[i].modulate = Color(0.3, 0.3, 0.3, 0.4)


# ===== HUD UPDATES =====

func update_coins(amount: int) -> void:
	coin_label.text = str(amount)


func update_wave(current_wave: int, total_waves: int) -> void:
	wave_label.text = "%d/%d" % [current_wave, total_waves]

# ===== TOWER PANEL =====

func show_tower_panel(tower: Tower) -> void:
	tower_panel.visible = true
	_refresh_tower_panel(tower)


func _refresh_tower_panel(tower: Tower) -> void:
	var info := "LV%d %s\nDMG: %s RNG: %d\nSELL: %d" % [
		tower.current_level,
		tower.tower_data["name"],
		_format_damage(tower.damage),
		int(tower.attack_range),
		tower.sell_value
	]
	tower_info_label.text = info

	if tower.current_level >= tower.tower_data["max_level"]:
		upgrade_button.text = "MAX"
		upgrade_button.disabled = true
	else:
		var cost: int = tower.get_upgrade_cost()
		upgrade_button.text = "UPG %d" % cost
		upgrade_button.disabled = not GameManager.can_afford(cost)


func hide_tower_panel() -> void:
	tower_panel.visible = false


func refresh_tower_panel(tower: Tower) -> void:
	if tower_panel.visible:
		_refresh_tower_panel(tower)


func _format_damage(dmg: float) -> String:
	if dmg == floorf(dmg):
		return str(int(dmg))
	return "%.1f" % dmg


# ===== MESSAGES =====

func show_message(text: String) -> void:
	message_label.text = text
	message_label.visible = true
	var tween := create_tween()
	tween.tween_interval(1.5)
	tween.tween_callback(func() -> void: message_label.visible = false)


# ===== GUI HIT TEST =====

func is_point_over_hud(screen_pos: Vector2) -> bool:
	if screen_pos.y < 58.0:
		return true
	if tower_panel.visible:
		var panel_rect := Rect2(tower_panel.position, tower_panel.size)
		if panel_rect.has_point(screen_pos):
			return true
	return false
