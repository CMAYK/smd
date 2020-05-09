/// @desc oInitialize
window_center()
// Clock Function
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
// Music Looper
var pos = audio_sound_get_track_position(global.bgm);
if(pos > total_length)
{
	audio_sound_set_track_position(global.bgm, pos - loop_length);
}

// Parallax Background
var layer_1 = layer_get_id("Backgrounds_1");
var layer_2 = layer_get_id("Backgrounds_2");
var layer_3 = layer_get_id("Backgrounds_3");
var layer_base = layer_get_id("Base_BGColor");

layer_x(layer_1, lerp(0,camera_get_view_x(view_camera[0]), .8));
layer_x(layer_2, lerp(0,camera_get_view_x(view_camera[0]), .65));
layer_x(layer_3, lerp(0,camera_get_view_x(view_camera[0]), .3));
layer_x(layer_base, lerp(0,camera_get_view_x(view_camera[0]), 0));

// RotVar test

if (rotVarActive = true) {
	rotVar += 0.5;	
	if (rotVar >= 15) {
		rotVar += 0.3;
		if (rotVar >= 19) {
			rotVar += 0.1;
			if (rotVar >= 19.5) {
				rotVarActive = false;	
			}	
		}	
	}
}
if (rotVarActive = false) {
	rotVar -= 1;	
	if (rotVar <= -15) {
		rotVar -= 0.3;
		if (rotVar <= -19) {
			rotVar -= 0.1;
			if (rotVar <= -19.5) {
				rotVarActive = true;	
			}	
		}	
	}
}