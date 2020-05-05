distance_travelled = clamp(distance_travelled - rotation_direction - rotation_speed, -90, 90);

if (distance_travelled == -90) or (distance_travelled == 90) {
	
	rotation_direction *= -1;
	
}


image_angle = distance_travelled;