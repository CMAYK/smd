speed = min(billSpeed + 0.5, 10);

if (instance_exists(oEnemy)) {
	nearEnemy = instance_nearest(x, y, oEnemy);
	if (point_in_circle(nearEnemy.x, nearEnemy.y, x, y, billRadius)) {
		direction = point_direction(x, y, nearEnemy.x, nearEnemy.y);
		image_angle = direction;
	}
}