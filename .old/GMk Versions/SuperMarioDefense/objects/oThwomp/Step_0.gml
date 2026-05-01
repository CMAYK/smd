if (instance_exists(oEnemy)) {
	nearEnemy = instance_nearest(x, y, oEnemy);
	if point_in_rectangle(nearEnemy.x, nearEnemy.y, x-48, y, x+16, y+480) && (canMoveDown) {
		image_index = 1;
	}	
	if (point_in_rectangle(nearEnemy.x, nearEnemy.y, x-6, y, x+6, y+480)) {
		image_index = 1;
		if (canMoveDown) { 
			image_index = 2;
			vsp += 0.8; 
		}
	}
	else {
	image_index = 0;	
	}
}

if (movingUp) { 
	vsp = -1.5;
}

if (place_meeting(x,y+1,oWall)) && (canMoveDown) {
	stompEffect = instance_create_layer(x+1, y+10, "Instances", oEffectStomp);
	stompEffect.dir = 2;
	stompEffect = instance_create_layer(x+1, y+10, "Instances", oEffectStomp);
	stompEffect.dir = -2;
	image_index = 2;
	vsp = 0;	
	canMoveDown = false;
	alarm[0] = 60;
}

y += vsp;

if (y < y_start) && (movingUp) {
	movingUp = false;
	alarm[1] = 60;
	vsp = 0;
	y = y_start;
}

if (y = y_start) && !(canDamage) {
	canDamage = true;
	countdown = false;
}