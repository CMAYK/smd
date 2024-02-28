if instance_exists(oEnemy) {
	nearEnemy = instance_nearest(x, y, oEnemy);
	if point_in_circle(nearEnemy.x, nearEnemy.y, x, y, bombCloudRange) {
		active = true;
		timer_var += 1;
	}
	else {
		active = false;
		timer_var = 0;
	}
}

if timer_var = bombCloudReload {
	timer_var = 0;
	instance_create_layer(x, y, "Weapons", oParaBomb);
}

// Bobbing animation
if (canMove = 1) {
	y -= 0.5;
	if (y <= yPos - 2) {
		canMove2 = 1;
		if (canMove2 = 1) {
			y -= 0.001;
			if (y <= yPos - 6) {
				canMove = 0;
				canMove2 = 1;
			}
		}
	}
}
if (canMove = 0) {
	y += 0.5;
	if (y >= yPos + 2) {
		canMove2 = 0;
		if (canMove2 = 0) {
			y += 0.001;
			if (y >= yPos + 6) {
				canMove = 1;	
			}
		}
	}
}

show_debug_message(y);