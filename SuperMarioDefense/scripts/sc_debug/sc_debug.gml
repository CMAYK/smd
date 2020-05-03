///Debug abilities

// Alter enemy speed
if (keyboard_check_pressed(ord("M"))) {
	spd += 10;	
}

// Alter enemy spawner speed
if keyboard_check(ord("I")) {
	if (oESpawner >= 500) {
		oESpawner.spawnerSpeed += 1;
	}
	if (oESpawner <= 499) {
		oESpawner.spawnerSpeed += 0.5;
	}
}
if keyboard_check(ord("O")) {
	if (oESpawner >= 500) {
		oESpawner.spawnerSpeed -= 1;
	}
	if (oESpawner <= 499) {
		oESpawner.spawnerSpeed -= 0.5;
	}
}