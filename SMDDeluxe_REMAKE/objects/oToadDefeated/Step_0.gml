timer_var += 1;

if (timer_var = 5) {
	timer_var = 0;
	image_xscale *= -1;
}

if !(moving) exit;

image_angle += 15;

if (vsp <= 3){
	vsp = vsp + grv;
}

y = y + vsp;

x = x + hsp;