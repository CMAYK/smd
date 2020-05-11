if (selected = 1) {
	draw_set_alpha(0.25);
	draw_circle_color(x-1, y-8, shellLauncherRange/2, c_yellow, c_yellow, 0);
	draw_set_alpha(1);
}
draw_sprite(spr_pipeTop, 0, x, y-16);
draw_sprite(spr_pipeMiddle, shellLauncherDirection, x, y);
draw_sprite(spr_shellLauncherIcon, shellLauncherLevel, x+3, y);
draw_sprite(spr_pipeExt, 0, x, y+16);
draw_sprite(spr_pipeExt, 0, x, y+32);
draw_sprite(spr_pipeExt, 0, x, y+48);