/// @desc

if (oCursor.x = 1264) or (oCursor.x = 240) {
	x += (xTo - x) / 12;	
} else {x += (xTo - x) / 25;}

y += (yTo - y) / 25;

if (follow != noone)
{
	xTo = follow.x;
	yTo = follow.y;
}

x = clamp(x, view_width_half, room_width - view_width_half);
y = clamp(y, view_height_half, room_height - view_height_half);
camera_set_view_pos(camera, x - view_width_half, y - view_height_half);