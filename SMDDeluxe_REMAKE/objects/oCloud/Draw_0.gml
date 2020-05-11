if (selected = 1) {
	draw_set_alpha(0.25);
	draw_circle_color(x-1, y, bombCloudRange/2, c_yellow, c_yellow, 0);
	draw_set_alpha(1);
}
draw_self()