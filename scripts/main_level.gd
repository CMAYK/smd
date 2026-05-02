extends Node2D

const VIEWPORT_W := 358
const VIEWPORT_H := 224
const TILE := 16
const GROUND_HEIGHT := TILE * 2  # 32px
const GROUND_Y := VIEWPORT_H - GROUND_HEIGHT  # 192
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
var hammer_bro_preview: Sprite2D = null
var drag_just_started: bool = false

@onready var camera: Camera2D = $Camera2D
@onready var wave_spawner: WaveSpawner = $WaveSpawner
@onready var hud: HUD = $HUD


func _ready() -> void:
	GameManager.start_level()
	_connect_signals()

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

	# Hammer bro placement preview sprite
	var preview_tex := load("res://resources/sprites/hammer_bro_preview.png") as Texture2D
	if preview_tex:
		hammer_bro_preview = Sprite2D.new()
		hammer_bro_preview.texture = preview_tex
		hammer_bro_preview.visible = false
		hammer_bro_preview.z_index = 100
		hammer_bro_preview.modulate.a = 0.6
		hammer_bro_preview.offset = Vector2(0, -29 + 32)
		add_child(hammer_bro_preview)

	# Setup HUD
	hud.setup_hp(GameManager.castle_max_hp)
	_update_hud()


func _connect_signals() -> void:
	# GameManager signals
	GameManager.coins_changed.connect(func(_v: int) -> void: _update_hud())
	GameManager.castle_hp_changed.connect(func(_v: int) -> void: _update_hud())
	GameManager.wave_started.connect(_on_wave_started)
	GameManager.level_lost.connect(_on_level_lost)
	wave_spawner.all_waves_complete.connect(_on_all_waves_complete)

	# HUD signals
	hud.tower_buy_requested.connect(_on_shop_buy)
	hud.upgrade_requested.connect(_on_upgrade_pressed)
	hud.sell_requested.connect(_on_sell_pressed)
	hud.pause_requested.connect(_on_pause_pressed)
	hud.next_wave_requested.connect(_on_next_wave_pressed)


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
	return hud.is_point_over_hud(mouse_screen)


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
						_stop_dragging()
					else:
						_deselect_tower()

	if event is InputEventKey and event.is_pressed():
		var key := (event as InputEventKey).keycode
		match key:
			KEY_SPACE:
				if wave_spawner.is_waiting() and wave_spawner.can_skip:
					wave_spawner.skip_to_next_wave()
				get_viewport().set_input_as_handled()
			KEY_LEFT:
				if selected_tower and selected_tower.facing_right:
					selected_tower.flip_direction()
					hud.refresh_tower_panel(selected_tower)
			KEY_RIGHT:
				if selected_tower and not selected_tower.facing_right:
					selected_tower.flip_direction()
					hud.refresh_tower_panel(selected_tower)
			KEY_ESCAPE:
				if dragging_tower:
					_stop_dragging()
				else:
					_deselect_tower()


func _stop_dragging() -> void:
	dragging_tower = false
	drag_preview.visible = false
	if hammer_bro_preview:
		hammer_bro_preview.visible = false


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
		hud.show_message("NOT ENOUGH COINS")
		_stop_dragging()
		return

	var place_pos := world_pos

	if def["ground_only"]:
		place_pos.y = float(GROUND_Y)
	else:
		var max_height_y: float = 72.0
		place_pos.y = maxf(place_pos.y, max_height_y)

		if def.has("min_height_clearance"):
			var clearance: float = def["min_height_clearance"]
			var extra_drop: float = 0.0
			if drag_tower_type == "hammer_bro":
				extra_drop = 32.0
			var max_y: float = float(GROUND_Y) - clearance - extra_drop
			place_pos.y = minf(place_pos.y, max_y)

	if place_pos.x < 10.0 or place_pos.x > float(BATTLEFIELD_W) - 40.0:
		hud.show_message("CANNOT PLACE HERE")
		return

	GameManager.spend_coins(cost)

	var tower: Tower = tower_scene.instantiate()
	tower.tower_type = drag_tower_type
	tower.global_position = place_pos
	add_child(tower)

	if not GameManager.can_afford(cost):
		_stop_dragging()


func _try_select_tower_at(world_pos: Vector2) -> bool:
	var best_tower: Tower = null

	for child in get_children():
		if child is Tower:
			var tower := child as Tower
			if tower.is_point_on_tower(world_pos):
				best_tower = tower

	if best_tower:
		_select_tower(best_tower)
		return true
	return false


func _select_tower(tower: Tower) -> void:
	if selected_tower:
		selected_tower.set_selected(false)
	selected_tower = tower
	selected_tower.set_selected(true)
	hud.show_tower_panel(tower)


func _deselect_tower() -> void:
	if selected_tower:
		selected_tower.set_selected(false)
	selected_tower = null
	hud.hide_tower_panel()


func _update_drag_preview() -> void:
	if dragging_tower and drag_tower_type != "":
		var mouse_world := get_global_mouse_position()
		var def: Dictionary = GameManager.tower_defs[drag_tower_type]

		if drag_tower_type == "hammer_bro":
			drag_preview.visible = false
			if hammer_bro_preview:
				var preview_y: float = mouse_world.y
				preview_y = maxf(preview_y, 72.0)
				if def.has("min_height_clearance"):
					var clearance: float = def["min_height_clearance"]
					var max_y: float = float(GROUND_Y) - clearance - 32.0
					preview_y = minf(preview_y, max_y)
				hammer_bro_preview.global_position = Vector2(mouse_world.x, preview_y)
				hammer_bro_preview.visible = true
		else:
			if hammer_bro_preview:
				hammer_bro_preview.visible = false

			var preview_y: float
			if def["ground_only"]:
				preview_y = float(GROUND_Y) - 14.0
			else:
				preview_y = mouse_world.y - 7.0
				preview_y = maxf(preview_y, 72.0 - 7.0)
				if def.has("min_height_clearance"):
					var clearance: float = def["min_height_clearance"]
					var extra_drop: float = 0.0
					var max_y: float = float(GROUND_Y) - clearance - extra_drop - 7.0
					preview_y = minf(preview_y, max_y)

			drag_preview.position = Vector2(mouse_world.x - 5.0, preview_y)
			drag_preview.color = def.get("color", Color(0.5, 0.5, 0.5))
			drag_preview.color.a = 0.5
			drag_preview.visible = true
	else:
		drag_preview.visible = false
		if hammer_bro_preview:
			hammer_bro_preview.visible = false


func _update_hud() -> void:
	hud.update_coins(GameManager.coins)
	hud.update_wave(GameManager.current_wave, GameManager.total_waves)
	hud.update_hp(GameManager.castle_hp)

	if selected_tower:
		hud.refresh_tower_panel(selected_tower)


func _update_timer_display() -> void:
	if wave_spawner.is_waiting():
		hud.update_timer(wave_spawner.get_countdown(), wave_spawner.can_skip)
	else:
		hud.hide_timer()


# ===== SIGNAL HANDLERS =====

func _on_shop_buy(tower_type: String) -> void:
	var def: Dictionary = GameManager.tower_defs[tower_type]
	if not GameManager.can_afford(def["cost"]):
		hud.show_message("NOT ENOUGH COINS")
		return
	drag_tower_type = tower_type
	dragging_tower = true
	drag_just_started = true
	_deselect_tower()


func _on_upgrade_pressed() -> void:
	if selected_tower:
		if selected_tower.upgrade():
			hud.refresh_tower_panel(selected_tower)
		else:
			hud.show_message("CANNOT UPGRADE")


func _on_sell_pressed() -> void:
	if selected_tower:
		selected_tower.sell()
		_deselect_tower()


func _on_pause_pressed() -> void:
	get_tree().paused = not get_tree().paused


func _on_next_wave_pressed() -> void:
	if wave_spawner.is_waiting() and wave_spawner.can_skip:
		wave_spawner.skip_to_next_wave()


func _on_wave_started(wave_number: int) -> void:
	_update_hud()
	hud.show_message("WAVE %d" % wave_number)


func _on_level_lost() -> void:
	level_ended = true
	hud.show_message("CASTLE DESTROYED")


func _on_all_waves_complete() -> void:
	await get_tree().create_timer(1.0).timeout
	if GameManager.castle_hp > 0:
		level_ended = true
		var medal := GameManager.get_medal()
		hud.show_message("VICTORY - %s" % medal.to_upper())
		GameManager.level_won.emit(medal)
