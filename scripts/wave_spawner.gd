extends Node2D
class_name WaveSpawner

signal all_waves_complete()
signal wave_enemies_spawned(wave_number: int)

@export var spawn_x: float = -10.0
@export var spawn_y: float = 160.0  # Ground surface Y
@export var castle_x: float = 700.0

var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")

var wave_timer: float = 0.0
var wave_countdown: float = 12.0
var spawn_timer: float = 0.0
var enemies_to_spawn: int = 0
var enemies_alive: int = 0
var current_wave_data: Dictionary = {}
var is_spawning: bool = false
var wave_active: bool = false
var waiting_for_wave: bool = false
var can_skip: bool = false  # True after 3-second mark


func start_waves() -> void:
	waiting_for_wave = true
	wave_countdown = 12.0
	can_skip = false


func skip_to_next_wave() -> void:
	if can_skip and waiting_for_wave:
		_start_next_wave()


func _process(delta: float) -> void:
	if waiting_for_wave:
		wave_countdown -= delta
		if wave_countdown <= 9.0:
			can_skip = true
		if wave_countdown <= 0:
			_start_next_wave()


func _start_next_wave() -> void:
	if GameManager.current_wave >= GameManager.total_waves:
		return

	var wave_data := GameManager.get_wave_data(GameManager.current_wave)
	if wave_data.is_empty():
		return

	current_wave_data = wave_data
	enemies_to_spawn = wave_data["count"]
	spawn_timer = 0.0
	is_spawning = true
	waiting_for_wave = false
	wave_active = true
	can_skip = false

	GameManager.current_wave += 1
	GameManager.wave_started.emit(GameManager.current_wave)


func _physics_process(delta: float) -> void:
	if not is_spawning:
		return

	spawn_timer -= delta
	if spawn_timer <= 0 and enemies_to_spawn > 0:
		_spawn_enemy()
		spawn_timer = current_wave_data["spawn_delay"]
		enemies_to_spawn -= 1
		if enemies_to_spawn <= 0:
			is_spawning = false
			wave_enemies_spawned.emit(GameManager.current_wave)
			# Start countdown for next wave (or check completion)
			_begin_next_wave_countdown()


func _spawn_enemy() -> void:
	var enemy: Enemy = enemy_scene.instantiate()
	enemy.global_position = Vector2(spawn_x, spawn_y)
	enemy.max_hp = current_wave_data["base_hp"]
	enemy.coin_reward = max(2, int(current_wave_data["base_hp"] * 1.5))
	enemy.castle_x = castle_x

	enemy.died.connect(_on_enemy_died)
	enemy.reached_castle.connect(_on_enemy_reached_castle)

	enemies_alive += 1
	get_tree().current_scene.add_child(enemy)


func _on_enemy_died(enemy: Enemy, coin_reward: int) -> void:
	GameManager.coins += coin_reward
	GameManager.enemy_killed.emit(coin_reward)
	enemies_alive -= 1
	_check_wave_complete()


func _on_enemy_reached_castle(enemy: Enemy) -> void:
	GameManager.castle_hp -= 1
	enemies_alive -= 1
	_check_wave_complete()


func _check_wave_complete() -> void:
	if enemies_alive <= 0 and not is_spawning:
		wave_active = false
		GameManager.wave_completed.emit(GameManager.current_wave)
		if GameManager.current_wave >= GameManager.total_waves:
			all_waves_complete.emit()


func _begin_next_wave_countdown() -> void:
	if GameManager.current_wave < GameManager.total_waves:
		waiting_for_wave = true
		wave_countdown = 12.0
		can_skip = false


func get_countdown() -> float:
	return wave_countdown


func is_waiting() -> bool:
	return waiting_for_wave
