vsp += grv;

// vertical collision
if (place_meeting(x,y+vsp,oWall)) {
	while (!place_meeting(x,y+sign(vsp),oWall))
	{
		y = y + sign(vsp);
	}
	vsp = 0;
}
y = y + vsp;

if instance_exists(oEnemy) {
	nearEnemy = instance_nearest(x, y, oEnemy);
	// Glare
	if point_in_rectangle(nearEnemy.x, nearEnemy.y, x-48, y, x+16, y+480) {
			image_index = 1;
			}	
			else {
			image_index = 0;
	}
	// Drop
	if (canDrop = true) { 
		if (canDamage = true) {
			if point_in_rectangle(nearEnemy.x, nearEnemy.y, x-16, y, x+16, y+480) {
				image_index = 2;
				vsp += 2; 
				canDrop = false;
				if (place_meeting(x, y+vsp, oWall)) {
					alarm[0] = 60;
				}
			}
		}
	}
}
if (resetPos = true) {
	vsp -= 0.2;
	sprite_index = 0;
	if (y <= ystart) {
		vsp = 0;
		y = ystart;
		resetPos = false;
		canDamage = true; 	
		alarm[1] = 60;
	}
}

//	stompEffect = instance_create_layer(x+10, y+10, "Instances", oEffectStomp);
//	stompEffect.dir = 2;
//	stompEffect = instance_create_layer(x+2, y+10, "Instances", oEffectStomp);
//	stompEffect.dir = -2;