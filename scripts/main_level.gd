extends Node2D

const VIEWPORT_W := 358
const VIEWPORT_H := 224
const TILE := 16
const GROUND_HEIGHT := TILE * 4
const GROUND_Y := VIEWPORT_H - GROUND_HEIGHT  # 160
const BATTLEFIELD_W := 1074

const SCROLL_SPEED := 150.0
const SCROLL_WHEEL_STEP := 40.0
const SCROLL_SMOOTH := 8.0

var tower_scene: PackedScene = preload("res://scenes/tower.tscn")

var camera_x: float = 0.0
var camera_target_x: float = 0.0
var dragging_tower: bool = false
var drag_tower_type: String = ""
var selected_tower: Tower = null
var level_ended: bool = false
var drag_preview: ColorRect = null
var drag_just_started: bool = false

@onready var camera: Camera2D = $Camera2D
@onready var wave_spawner: WaveSpawner = $WaveSpawner
@onready var coin_label: Label = $HUD/HUDRoot/TopBar/CoinLabel
@onready var hp_label: Label = $HUD/HUDRoot/TopBar/HPLabel
@onready var wave_label: Label = $HUD/HUDRoot/TopBar/WaveLabel
@onready var timer_label: Label = $HUD/HUDRoot/TimerLabel
@onready var tower_panel: PanelContainer = $HUD/HUDRoot/TowerPanel
@onready var upgrade_button: Button = $HUD/HUDRoot/TowerPanel/VBox/UpgradeButton
@onready var sell_button: Button = $HUD/HUDRoot/TowerPanel/VBox/SellButton
@onready var tower_info_label: Label = $HUD/HUDRoot/TowerPanel/VBox/InfoLabel
@onready var message_label: Label = $HUD/HUDRoot/MessageLabel

# Shop buttons
@onready var buy_shell: Button = $HUD/HUDRoot/ShopBar/BuyShell
@onready var buy_hammer: Button = $HUD/HUDRoot/ShopBar/BuyHammer
@onready var buy_boo: Button = $HUD/HUDRoot/ShopBar/BuyBoo
@onready var buy_stone: Button = $HUD/HUDRoot/ShopBar/BuyStone

# All shop buttons and their tower types
var shop_buttons: Array[Dictionary] = []


func _ready() -> void:
	GameManager.start_level()
	_connect_signals()
	tower_panel.visible = false
	message_label.visible = false

	wave_spawner.castle_x = float(BATTLEFIELD_W) - 30.0
	wave_spawner.spawn_y = float(GROUND_Y)

	camera_target_x = float(VIEWPORT_W) / 2.0
	camera_x = camera_target_x
	camera.position = Vector2(camera_x, float(VIEWPORT_H) / 2.0)

	wave_spawner.start_waves()

	drag_preview = ColorRect.new()
	drag_preview.size = Vector2(10, 14)
	drag_preview.color = Color(0.5, 0.5, 0.5, 0.5)
	drag_preview.visible = false
	drag_preview.z_index = 100
	add_child(drag_preview)

	# Setup shop buttons
	shop_buttons = [
		{"button": buy_shell, "type": "koopa_shell_pipe"},
		{"button": buy_hammer, "type": "hammer_bro"},
		{"button": buy_boo, "type": "boo_chest"},
		{"button": buy_stone, "type": "swinging_stone"},
	]
	for entry in shop_buttons:
		var btn: Button = entry["button"]
		var ttype: String = entry["type"]
		btn.pressed.connect(_on_shop_buy.bind(ttype))

	_update_hud()


func _connect_signals() -> void:
	GameManager.coins_changed.connect(func(_v: int) -> void: _update_hud())
	GameManager.castle_hp_changed.connect(func(_v: int) -> void: _update_hud())
	GameManager.wave_started.connect(_on_wave_started)
	GameManager.level_lost.connect(_on_level_lost)
	wave_spawner.all_waves_complete.connect(_on_all_waves_complete)
	upgrade_button.pressed.connect(_on_upgrade_pressed)
	sell_button.pressed.connect(_on_sell_pressed)


func _process(delta: float) -> void:
	_handle_keyboard_scroll(delta)
	camera_x = lerpf(camera_x, camera_target_x, SCROLL_SMOOTH * delta)
	camera.position.x = camera_x
	_update_timer_display()
	_update_drag_preview()

	if drag_just_started:
		drag_just_started = false


func _handle_keyboard_scroll(delta: float) -> void:
	var scroll_dir := 0.0
	if Input.is_action_pressed("scroll_left"):
		scroll_dir = -1.0
	elif Input.is_action_pressed("scroll_right"):
		scroll_dir = 1.0
	if scroll_dir != 0.0:
		camera_target_x += scroll_dir * SCROLL_SPEED * delta
		_clamp_camera_target()


func _scroll_camera_by(amount: float) -> void:
	camera_target_x += amount
	_clamp_camera_target()


func _clamp_camera_target() -> void:
	var half_vp := float(VIEWPORT_W) / 2.0
	camera_target_x = clampf(camera_target_x, half_vp, float(BATTLEFIELD_W) - half_vp)


func _is_mouse_over_gui() -> bool:
	var mouse_screen: Vector2 = get_viewport().get_mouse_position()
	# Shop bar area (top 26px)
	if mouse_screen.y < 26.0:
		return true
	# Tower panel
	if tower_panel.visible:
		var panel_rect := Rect2(tower_panel.position, tower_panel.size)
		if panel_rect.has_point(mouse_screen):
			return true
	return false


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.pressed:
			match mb.button_index:
				MOUSE_BUTTON_WHEEL_UP:
					_scroll_camera_by(-SCROLL_WHEEL_STEP)
				MOUSE_BUTTON_WHEEL_DOWN:
					_scroll_camera_by(SCROLL_WHEEL_STEP)
				MOUSE_BUTTON_LEFT:
					_handle_left_click()
				MOUSE_BUTTON_RIGHT:
					if dragging_tower:
						dragging_tower = false
						drag_preview.visible = false
					else:
						_deselect_tower()

	if event is InputEventKey and event.is_pressed():
		var key := (event as InputEventKey).keycode
		match key:
			KEY_SPACE:
				if wave_spawner.is_waiting() and wave_spawner.can_skip:
					wave_spawner.skip_to_next_wave()
			KEY_LEFT:
				if selected_tower and selected_tower.facing_right:
					selected_tower.flip_direction()
					_update_tower_panel()
			KEY_RIGHT:
				if selected_tower and not selected_tower.facing_right:
					selected_tower.flip_direction()
					_update_tower_panel()
			KEY_ESCAPE:
				if dragging_tower:
					dragging_tower = false
					drag_preview.visible = false
				else:
					_deselect_tower()


func _handle_left_click() -> void:
	if level_ended:
		return
	if _is_mouse_over_gui():
		return
	if drag_just_started:
		return

	var world_pos := get_global_mouse_position()

	if dragging_tower:
		_try_place_tower(world_pos)
	else:
		if not _try_select_tower_at(world_pos):
			_deselect_tower()


func _try_place_tower(world_pos: Vector2) -> void:
	var def: Dictionary = GameManager.tower_defs[drag_tower_type]
	var cost: int = def["cost"]

	if not GameManager.can_afford(cost):
		_show_message("NOT ENOUGH COINS")
		dragging_tower = false
		drag_preview.visible = false
		return

	var place_pos := world_pos
	if def["ground_only"]:
		place_pos.y = float(GROUND_Y)

	if place_pos.x < 10.0 or place_pos.x > float(BATTLEFIELD_W) - 40.0:
		_show_message("CANNOT PLACE HERE")
		return

	GameManager.spend_coins(cost)

	var tower: Tower = tower_scene.instantiate()
	tower.tower_type = drag_tower_type
	tower.global_position = place_pos
	add_child(tower)

	if not GameManager.can_afford(cost):
		dragging_tower = false
		drag_preview.visible = false


func _try_select_tower_at(world_pos: Vector2) -> bool:
	var closest_tower: Tower = null
	var closest_dist: float = 16.0

	for child in get_children():
		if child is Tower:
			var dist: float = child.global_position.distance_to(world_pos)
			if dist < closest_dist:
				closest_dist = dist
				closest_tower = child as Tower

	if closest_tower:
		_select_tower(closest_tower)
		return true
	return false


func _select_tower(tower: Tower) -> void:
	if selected_tower:
		selected_tower.set_selected(false)
	selected_tower = tower
	selected_tower.set_selected(true)
	_update_tower_panel()
	tower_panel.visible = true


func _deselect_tower() -> void:
	if selected_tower:
		selected_tower.set_selected(false)
	selected_tower = null
	tower_panel.visible = false


func _update_tower_panel() -> void:
	if not selected_tower:
		return

	var info := "LV%d %s\nDMG: %s RNG: %d\nSELL: %d" % [
		selected_tower.current_level,
		selected_tower.tower_data["name"],
		_format_damage(selected_tower.damage),
		int(selected_tower.attack_range),
		selected_tower.sell_value
	]
	tower_info_label.text = info

	if selected_tower.current_level >= selected_tower.tower_data["max_level"]:
		upgrade_button.text = "MAX LEVEL"
		upgrade_button.disabled = true
	else:
		var cost: int = selected_tower.get_upgrade_cost()
		upgrade_button.text = "UPGRADE %d" % cost
		upgrade_button.disabled = not GameManager.can_afford(cost)


func _format_damage(dmg: float) -> String:
	if dmg == floorf(dmg):
		return str(int(dmg))
	return "%.1f" % dmg


func _update_drag_preview() -> void:
	if dragging_tower and drag_tower_type != "":
		var mouse_world := get_global_mouse_position()
		var def: Dictionary = GameManager.tower_defs[drag_tower_type]
		var preview_y := float(GROUND_Y) - 14.0 if def["ground_only"] else mouse_world.y - 7.0
		drag_preview.position = Vector2(mouse_world.x - 5.0, preview_y)
		drag_preview.color = def.get("color", Color(0.5, 0.5, 0.5))
		drag_preview.color.a = 0.5
		drag_preview.visible = true
	else:
		drag_preview.visible = false


func _update_hud() -> void:
	coin_label.text = "COINS: %d" % GameManager.coins
	hp_label.text = "HP: %d" % GameManager.castle_hp
	wave_label.text = "WAVE: %d" % GameManager.current_wave

	# Update shop button text
	for entry in shop_buttons:
		var btn: Button = entry["button"]
		var ttype: String = entry["type"]
		var def: Dictionary = GameManager.tower_defs[ttype]
		var short_name: String = def["name"].split(" ")[0]
		btn.text = "%s %d" % [short_name, def["cost"]]


func _update_timer_display() -> void:
	if wave_spawner.is_waiting():
		var t: int = ceili(wave_spawner.get_countdown())
		timer_label.text = "NEXT WAVE: %d" % t
		if wave_spawner.can_skip:
			timer_label.text += " *SPACE*"
		timer_label.visible = true
	else:
		timer_label.visible = false


func _show_message(text: String) -> void:
	message_label.text = text
	message_label.visible = true
	var tween := create_tween()
	tween.tween_interval(1.5)
	tween.tween_callback(func() -> void: message_label.visible = false)


# ===== SIGNAL HANDLERS =====

func _on_shop_buy(tower_type: String) -> void:
	var def: Dictionary = GameManager.tower_defs[tower_type]
	if not GameManager.can_afford(def["cost"]):
		_show_message("NOT ENOUGH COINS")
		return
	drag_tower_type = tower_type
	dragging_tower = true
	drag_just_started = true
	_deselect_tower()


func _on_upgrade_pressed() -> void:
	if selected_tower:
		if selected_tower.upgrade():
			_update_tower_panel()
		else:
			_show_message("CANNOT UPGRADE")


func _on_sell_pressed() -> void:
	if selected_tower:
		selected_tower.sell()
		_deselect_tower()


func _on_wave_started(wave_number: int) -> void:
	_update_hud()
	_show_message("WAVE %d" % wave_number)


func _on_level_lost() -> void:
	level_ended = true
	_show_message("CASTLE DESTROYED")


func _on_all_waves_complete() -> void:
	await get_tree().create_timer(1.0).timeout
	if GameManager.castle_hp > 0:
		level_ended = true
		var medal := GameManager.get_medal()
		_show_message("VICTORY. %s" % medal.to_upper())
		GameManager.level_won.emit(medal)
