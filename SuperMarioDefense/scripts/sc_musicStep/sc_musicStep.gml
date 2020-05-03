// music looping
var pos = audio_sound_get_track_position(global.bgm);
if(pos > total_length)
{
	audio_sound_set_track_position(global.bgm, pos - loop_length);
}