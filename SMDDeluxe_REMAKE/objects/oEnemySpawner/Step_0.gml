
//if (!wave = 0) {
	if (instance_number(oEnemy) = 5) {
		spawnerSpeed = NaN;
	}

	if global.timer_var >= spawnerSpeed {
		global.timer_var = 0;
		instance_create_layer(x, y, "Enemys_Weapons", oEnemy);
		//o.enemyHealth = oInitialize.enemySpawnHealth;
		//audio_play_sound(snd_pipe, 1, 0);
	}	
//}
