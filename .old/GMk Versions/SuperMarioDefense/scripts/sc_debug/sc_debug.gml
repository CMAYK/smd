///Debug abilities

// Alter enemy speed
if (keyboard_check_pressed(ord("M"))) {
	if (instance_exists(oEnemy)){
		oEnemy.spd += 10;	
	}
}

// Alter enemy health
if (keyboard_check_pressed(ord("U"))) {
	if (instance_exists(oEnemy)){
		oEnemy.enemyHealth += 10;	
	}
}

// Alter enemy spawner speed
if keyboard_check(ord("I")) {
	if (oEnemySpawner >= 500) {
		oEnemySpawner.spawnerSpeed += 1;
	}
	if (oEnemySpawner <= 499) {
		oEnemySpawner.spawnerSpeed += 0.5;
	}
}
if keyboard_check(ord("O")) {
	if (oEnemySpawner >= 500) {
		oEnemySpawner.spawnerSpeed -= 1;
	}
	if (oEnemySpawner <= 499) {
		oEnemySpawner.spawnerSpeed -= 0.5;
	}
}
if keyboard_check(ord("P")) {
	oEnemySpawner.spawnerSpeed = 60;
}