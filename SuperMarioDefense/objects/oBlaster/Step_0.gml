timer_var += 1;

if (timer_var >= 60) {
	timer_var = 0;
	instance_create_depth(x, y, 1, oHomingBill);
}