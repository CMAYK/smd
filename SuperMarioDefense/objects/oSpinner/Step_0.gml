distance_travelled = clamp(distance_travelled + rotation_direction + rotation_speed, -180, 0);

if ((distance_travelled > -120) && (distance_travelled < 90)) or ((distance_travelled < 120) && (distance_travelled > -90)){
	rotation_speed = 8;	
}
if ((distance_travelled > -120) && (distance_travelled < -160)) or ((distance_travelled < 120) && (distance_travelled > 160)){
	rotation_speed = 9;	
}


if (distance_travelled == -180) or (distance_travelled == 0) {
	
	rotation_direction *= -1;
	rotation_speed *= -1;
	
}

xx = x + lengthdir_x(distance_from_center, rotation_direction);
yy = y + lengthdir_y(distance_from_center, rotation_direction);