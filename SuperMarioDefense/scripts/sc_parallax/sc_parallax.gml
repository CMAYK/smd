var layer_1 = layer_get_id("Backgrounds_1");
var layer_2 = layer_get_id("Backgrounds_2");
var layer_3 = layer_get_id("Backgrounds_3");
var layer_base = layer_get_id("Background_Base");

layer_x(layer_1, lerp(0,camera_get_view_x(view_camera[0]), .8));
layer_x(layer_2, lerp(0,camera_get_view_x(view_camera[0]), .65));
layer_x(layer_3, lerp(0,camera_get_view_x(view_camera[0]), .3));
layer_x(layer_base, lerp(0,camera_get_view_x(view_camera[0]), 0));
