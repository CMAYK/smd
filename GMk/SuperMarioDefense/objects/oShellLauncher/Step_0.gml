/// @desc Variables
if instance_exists(oEnemy) {
	nearEnemy = instance_nearest(x, y, oEnemy);
	if point_in_circle(nearEnemy.x, nearEnemy.y, x, y, launcherRange) {
	   active = true;
	   timer_var += 1
	   }
	else {
	   active = false;
	   timer_var = 0;
	   }
}

if timer_var = launcherSpeed {
	timer_var = 0;
	instance_create_layer(x+8, y-32, "Enemys_Weapons", oShell);
	audio_play_sound(snd_pipe, 1, 0);
	}
