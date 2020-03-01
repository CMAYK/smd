/// @desc Camera

y = 180;

if (room = menu) {
	instance_create_layer(x,y,"Instances",oMenuCursor);
	follow = oMenuCursor;
}
else {
	instance_create_layer(x,y,"Instances",oCursor);
	follow = oCursor;
}

camera = camera_create();

var vm = matrix_build_lookat(x, y, -10, x, y, 0, 0, 1, 0);
var pm = matrix_build_projection_ortho(480, 360, 1, 100000);

camera_set_view_mat(camera,vm);
camera_set_proj_mat(camera,pm);

view_camera[0] = camera;

xTo = x;
yTo = y;