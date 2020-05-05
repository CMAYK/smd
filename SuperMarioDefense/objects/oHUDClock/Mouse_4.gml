if (oInitialize.clockSeconds = 0) or (oInitialize.clockSeconds = 1) or (oInitialize.clockSeconds = 2) or (oInitialize.clockSeconds = 3) {
	audio_play_sound(snd_rejected, 0, false);
}
else {
	oInitialize.clockSeconds = 0;
}