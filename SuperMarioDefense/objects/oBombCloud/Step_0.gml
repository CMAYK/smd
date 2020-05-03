if instance_exists(oEnemy) {
	nearEnemy = instance_nearest(x, y, oEnemy);
	if point_in_circle(nearEnemy.x, nearEnemy.y, x, y, dropperRange) {
	   active = true;
	   timer_var += 1
	   }
	else {
	   active = false;
	   timer_var = 0;
	   }
}

if timer_var = dropperSpeed {
	timer_var = 0;
	instance_create_layer(x+8, y-32, "Enemys_Weapons", oBomb);
	audio_play_sound(snd_pipe, 1, 0);
	}