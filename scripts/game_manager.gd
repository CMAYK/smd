extends Node

# ===== SIGNALS =====
signal coins_changed(new_amount: int)
signal castle_hp_changed(new_hp: int)
signal wave_started(wave_number: int)
signal wave_completed(wave_number: int)
signal level_won(medal: String)
signal level_lost()
signal enemy_killed(coin_reward: int)

# ===== GAME STATE =====
var coins: int = 0 :
	set(value):
		coins = value
		coins_changed.emit(coins)

var castle_hp: int = 10 :
	set(value):
		castle_hp = max(value, 0)
		castle_hp_changed.emit(castle_hp)
		if castle_hp <= 0:
			level_lost.emit()

var castle_max_hp: int = 10
var current_wave: int = 0
var total_waves: int = 5
var is_level_active: bool = false

# ===== LEVEL CONFIG =====
# Phase 1 test level - will be data-driven later
var level_data: Dictionary = {
	"starting_coins": 1000,
	"castle_hp": 10,
	"total_waves": 5,
	"battlefield_width": 1920,
	"waves": [
		{"count": 3, "enemy_type": "mario", "base_hp": 3, "spawn_delay": 1.5},
		{"count": 5, "enemy_type": "mario", "base_hp": 4, "spawn_delay": 1.2},
		{"count": 6, "enemy_type": "mario", "base_hp": 6, "spawn_delay": 1.0},
		{"count": 8, "enemy_type": "mario", "base_hp": 8, "spawn_delay": 0.8},
		{"count": 10, "enemy_type": "mario", "base_hp": 12, "spawn_delay": 0.7},
	]
}

# ===== TOWER DEFINITIONS =====
var tower_defs: Dictionary = {
	"koopa_shell_pipe": {
		"name": "SHELL PIPE",
		"cost": 30,
		"sell_value": 15,
		"damage": 1.0,
		"range": 128.0,
		"reload_time": 2.0,
		"projectile_speed": 80.0,
		"ground_only": true,
		"directional": true,
		"tower_script": "projectile",
		"upgrade_cost_base": 20,
		"upgrade_damage_add": 1.0,
		"upgrade_range_add": 8.0,
		"upgrade_reload_mult": 0.85,
		"max_level": 5,
		"color": Color(0.2, 0.65, 0.2),
		"description": "Fires koopa shells in a set direction."
	},
	"hammer_bro": {
		"name": "HAMMER BRO",
		"cost": 70,
		"sell_value": 35,
		"damage": 0.4,
		"range": 128.0,
		"reload_time": 1.0,
		"projectile_speed": 60.0,
		"ground_only": false,
		"directional": false,
		"tower_script": "hammer_bro",
		"pendulum_half_width": 48.0,
		"pendulum_drop": 32.0,
		"pendulum_period": 2.5,
		"hammer_gravity": 300.0,
		"hammer_bounce_vy": -40.0,
		"hammer_tick_rate": 0.15,
		"min_height_clearance": 32.0,
		"upgrade_cost_base": 35,
		"upgrade_damage_add": 0.2,
		"upgrade_range_add": 8.0,
		"upgrade_reload_mult": 0.87,
		"max_level": 5,
		"color": Color(0.1, 0.6, 0.1),
		"description": "Throws arcing hammers left and right that bounce and deal DPS."
	},
	"boo_chest": {
		"name": "BOO CHEST",
		"cost": 100,
		"sell_value": 50,
		"damage": 0.3,
		"range": 100.0,
		"reload_time": 10.0,
		"projectile_speed": 0.0,
		"ground_only": true,
		"directional": false,
		"tower_script": "boo_chest",
		"boo_speed": 50.0,
		"boo_float_amplitude": 8.0,
		"boo_lifetime": 5.0,
		"boo_dps_tick_rate": 0.2,
		"boo_launch_velocity": Vector2(0, -200.0),
		"upgrade_cost_base": 50,
		"upgrade_damage_add": 0.15,
		"upgrade_range_add": 10.0,
		"upgrade_reload_mult": 0.8,
		"upgrade_lifetime_add": 1.0,
		"max_level": 5,
		"color": Color(0.85, 0.85, 0.9),
		"description": "Spawns boos that chase and attach to marios dealing DPS."
	},
	"swinging_stone": {
		"name": "SWING STONE",
		"cost": 200,
		"sell_value": 100,
		"damage": 0.5,
		"range": 48.0,
		"reload_time": 0.0,
		"projectile_speed": 0.0,
		"ground_only": false,
		"directional": false,
		"tower_script": "swinging_stone",
		"chain_length": 48.0,
		"ball_radius": 16.0,
		"rotation_speed": 1.257,
		"dps_tick_rate": 0.1,
		"min_height_clearance": 48.0,
		"upgrade_cost_base": 80,
		"upgrade_damage_add": 0.25,
		"upgrade_range_add": 0.0,
		"upgrade_reload_mult": 1.0,
		"max_level": 5,
		"color": Color(0.4, 0.4, 0.45),
		"description": "A stone that swings in a circle dealing continuous DPS."
	},
	"bob_omb_cannon": {
		"name": "BOB-OMB CANNON",
		"cost": 120,
		"sell_value": 60,
		"damage": 2.0,
		"range": 80.0,
		"reload_time": 4.0,
		"projectile_speed": 0.0,
		"ground_only": true,
		"directional": false,
		"tower_script": "bob_omb_cannon",
		"bob_chase_range": 80.0,
		"bob_chase_speed": 40.0,
		"bob_wander_time": 5.0,
		"bob_launch_velocity": -160.0,
		"upgrade_cost_base": 50,
		"upgrade_damage_add": 1.0,
		"upgrade_range_add": 8.0,
		"upgrade_reload_mult": 0.85,
		"max_level": 5,
		"color": Color(0.15, 0.15, 0.15),
		"description": "Fires bob-ombs that float down and chase marios."
	},
	"springboard": {
		"name": "SPRINGBOARD",
		"cost": 30,
		"sell_value": 15,
		"damage": 1.0,
		"range": 10.0,
		"reload_time": 0.0,
		"projectile_speed": 0.0,
		"ground_only": true,
		"directional": false,
		"tower_script": "springboard",
		"launch_height": 48.0,
		"upgrade_cost_base": 15,
		"upgrade_damage_add": 1.0,
		"upgrade_range_add": 0.0,
		"upgrade_reload_mult": 1.0,
		"max_level": 5,
		"color": Color(0.9, 0.8, 0.1),
		"description": "Launches marios upward dealing fall damage."
	},
	"bowser_statue": {
		"name": "BOWSER STATUE",
		"cost": 200,
		"sell_value": 100,
		"damage": 1.0,
		"range": 256.0,
		"reload_time": 0.0,
		"projectile_speed": 0.0,
		"ground_only": true,
		"directional": true,
		"tower_script": "bowser_statue",
		"dps_tick_rate": 0.1,
		"max_stack_tiles": 2,
		"upgrade_cost_base": 80,
		"upgrade_damage_add": 0.5,
		"upgrade_range_add": 0.0,
		"upgrade_reload_mult": 1.0,
		"max_level": 5,
		"color": Color(0.4, 0.4, 0.4),
		"description": "Fires a continuous 45 degree laser when marios are in line of sight."
	},
	"lakitu": {
		"name": "LAKITU",
		"cost": 120,
		"sell_value": 60,
		"damage": 2.0,
		"range": 80.0,
		"reload_time": 2.0,
		"projectile_speed": 0.0,
		"ground_only": false,
		"directional": false,
		"tower_script": "lakitu",
		"spiny_speed": 18.0,
		"spiny_drop_damage_mult": 2.0,
		"min_height_clearance": 48.0,
		"upgrade_cost_base": 50,
		"upgrade_damage_add": 1.0,
		"upgrade_range_add": 8.0,
		"upgrade_reload_mult": 0.85,
		"max_level": 5,
		"color": Color(0.2, 0.7, 0.2),
		"description": "Drops spinys that chase and damage marios."
	},
	"lava_lotus": {
		"name": "LAVA LOTUS",
		"cost": 400,
		"sell_value": 200,
		"damage": 2.0,
		"range": 60.0,
		"reload_time": 3.0,
		"projectile_speed": 0.0,
		"ground_only": true,
		"directional": false,
		"tower_script": "lava_lotus",
		"lava_ball_count": 3,
		"lava_ball_lifetime": 10.0,
		"lava_cone_angle": 120.0,
		"upgrade_cost_base": 100,
		"upgrade_damage_add": 1.0,
		"upgrade_range_add": 0.0,
		"upgrade_reload_mult": 0.9,
		"max_level": 5,
		"color": Color(0.9, 0.3, 0.1),
		"description": "Fires lava balls in a cone that rest on the ground."
	},
}


func start_level() -> void:
	coins = level_data["starting_coins"]
	castle_max_hp = level_data["castle_hp"]
	castle_hp = castle_max_hp
	total_waves = level_data["total_waves"]
	current_wave = 0
	is_level_active = true


func get_wave_data(wave_index: int) -> Dictionary:
	if wave_index < level_data["waves"].size():
		return level_data["waves"][wave_index]
	return {}


func get_medal() -> String:
	var hp_ratio := float(castle_hp) / float(castle_max_hp)
	if hp_ratio >= 0.8:
		return "gold"
	elif hp_ratio >= 0.5:
		return "silver"
	elif hp_ratio > 0.0:
		return "bronze"
	return "none"


func can_afford(cost: int) -> bool:
	return coins >= cost


func spend_coins(amount: int) -> bool:
	if can_afford(amount):
		coins -= amount
		return true
	return false
