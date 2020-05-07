/// @desc Camera

x = 240;
y = 180;

instance_create_layer(x, y, "Instances", oCursor);
follow = oCursor;

camera = view_camera[0];
view_width_half = camera_get_view_width(camera)/2;
view_height_half = camera_get_view_height(camera)/2;


xTo = x;
yTo = y;