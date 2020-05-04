timer_var += 1

if (!wave = 0) {
	if (instance_number(oEnemy) = 5) {
		spawnerSpeed = 90000000000;
	}
	if timer_var >= spawnerSpeed {
		timer_var = 0;
		instance_create_layer(x, y, "Enemys_Weapons", oEnemy);
		audio_play_sound(snd_pipe, 1, 0);
	}	
}

wave = oInitialize.clockHandRevolutions - 1;