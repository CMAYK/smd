if (mouse_check_button_pressed(mb_left)) && (oInitialize.shopDescription = 0) {
	oInitialize.shopDescription	-= 0;
}
else {
	oInitialize.shopDescription	-= 1;
}

if point_in_rectangle(mouse_x, mouse_y, x+41, y+22, x-41, y-22) {
	draw_text(x, y, "AHHHHHHH")
}
