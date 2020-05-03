timer_var += 1
if (timer_var = 35) {
	instance_destroy(other);
	audio_play_sound(snd_door, 2, 0);
	image_index = 0;
	timer_var = 0;
	global.livescounter -= 1;
}
else {image_index = 1;}

if (global.livescounter = 0) {
	room_goto(gameover);
}
