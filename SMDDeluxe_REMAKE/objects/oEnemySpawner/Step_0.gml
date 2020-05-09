timer_var += 1;

//if (!wave = 0) {
	if (instance_number(oEnemy) = 5) {
		spawnerSpeed = 90;
	}

	if timer_var >= spawnerSpeed {
		timer_var = 0;
		instance_create_layer(x, y+22, "Weapons", oEnemy);
		//o.enemyHealth = oInitialize.enemySpawnHealth;
		//audio_play_sound(snd_pipe, 1, 0);
	}	
//}
