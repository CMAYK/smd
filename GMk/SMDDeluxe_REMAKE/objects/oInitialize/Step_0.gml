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

rotation_direction += r_speed;
if rotVarActive == 1 {
    switch (rotation_direction) {
        case 1:
            if r_speed <= 12 {
                r_speed += acceleration;
            }
            else if r_speed >=14 {
                r_speed = 14;
            }
            case -1:
                if r_speed >= -12 {
                    r_speed -= acceleration;
                }
                else if r_speed <=-14 {
                    r_speed = -14;
                }
    }
}
else {
    exit;
}

// Object Selection
if (instance_exists(oSpringboard)) {
	if (oSpringboard.selected = 1) {
			weaponHUDLocation -= 15;
			if (weaponHUDLocation <= 0) {
				weaponHUDLocation = 0;
			}
	}
	if (oSpringboard.selected = 0) {
			weaponHUDLocation += 15;
			if (weaponHUDLocation >= 180) {
				weaponHUDLocation = 180;
			}	
	}
}
if (instance_exists(oShellLauncher)) {
	if (oShellLauncher.selected = 1) {
			weaponHUDLocation -= 15;
			if (weaponHUDLocation <= 0) {
				weaponHUDLocation = 0;
			}
	}
	if (oShellLauncher.selected = 0) {
			weaponHUDLocation += 15;
			if (weaponHUDLocation >= 180) {
				weaponHUDLocation = 180;
			}
	}
}
if (objectSelected = 1) {
	weaponHUDLocation -= 15;
		if (weaponHUDLocation <= 0) {
			weaponHUDLocation = 0;
		}
}
if (objectSelected = 0) {
	weaponHUDLocation += 15;
		if (weaponHUDLocation >= 180) {
			weaponHUDLocation = 180;
		}
}
//show_debug_message(weaponHUDLocation);