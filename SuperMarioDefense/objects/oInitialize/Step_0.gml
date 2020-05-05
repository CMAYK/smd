timer_var += 1
if (timer_var = 60) {
	timer_var = 0;
	clockSeconds += 1; 
	if (clockSeconds >= 13) {
		clockSeconds = 0;
		clockHandAngle = 0;
			if (clockSeconds = 0) {
			clockSeconds = 1;
			clockHandAngle = 0;
		}
	}
}
if (clockSeconds = 0) {
	clockHandAngle = 0;	
	if (clockSeconds = 0) {
		clockSeconds = 1;
		clockHandAngle = 0;
	}
}

if (clockHandAngle = -360) || (clockHandAngle = 0) {
	clockHandRevolutions += 1;	
}

clockHandAngle -= 0.5;

// music looping
var pos = audio_sound_get_track_position(global.bgm);
if(pos > total_length)
{
	audio_sound_set_track_position(global.bgm, pos - loop_length);
}

// DEBUG
if keyboard_check_pressed(vk_f4) {
	window_set_size(window_get_width() * 2, window_get_height() * 2)
}

// parallax background
var layer_1 = layer_get_id("Backgrounds_1");
var layer_2 = layer_get_id("Backgrounds_2");
var layer_3 = layer_get_id("Backgrounds_3");
var layer_base = layer_get_id("Background_Base");

layer_x(layer_1, lerp(0,camera_get_view_x(view_camera[0]), .8));
layer_x(layer_2, lerp(0,camera_get_view_x(view_camera[0]), .65));
layer_x(layer_3, lerp(0,camera_get_view_x(view_camera[0]), .3));
layer_x(layer_base, lerp(0,camera_get_view_x(view_camera[0]), 0));
