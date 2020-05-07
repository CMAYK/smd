if (!audio_is_playing(mus_overworld))
{
audio_stop_all();
global.bgm = audio_play_sound(mus_overworld, 0, false);
intro_length = 1.778;
loop_length = 39.117;
}
total_length = intro_length + loop_length;