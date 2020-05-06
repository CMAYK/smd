timer_var += 1;

if (timer_var >= 160) {
	timer_var = 0;
	if (instance_exists(oEnemy)) {
		nearEnemy = instance_nearest(x, y, oEnemy);
		if (point_in_circle(nearEnemy.x, nearEnemy.y, x, y, 500)) {
			instance_create_layer(x, y, "Enemys_Weapons", oHomingBill);
		}
	}
}