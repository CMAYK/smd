if instance_exists(oEnemy) {
	nearEnemy = instance_nearest(x, y, oEnemy);
	if point_in_circle(nearEnemy.x, nearEnemy.y, x, y, shellLauncherRange) {
		active = true;
		timer_var += 1;
	}
	else {
		active = false;
		timer_var = 0;
	}
}

if timer_var = shellLauncherReload {
	timer_var = 0;
	instance_create_layer(x+2, y-24, "Weapons", oShell);
}