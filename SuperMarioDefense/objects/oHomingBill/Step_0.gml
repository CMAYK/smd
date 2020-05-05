speed = 1;

if (instance_exists(oEnemy)) {
	if (point_in_circle(oEnemy.x, oEnemy.y, x, y, billRadius)) {
		billSpeed = point_direction(x, y, oEnemy.x, oEnemy.y);
		direction += sign(dsin(billSpeed - direction)) * 20;
		image_angle = direction;
	}
}