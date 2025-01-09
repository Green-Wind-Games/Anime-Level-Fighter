function greenwind_swirls() {
	char_specialeffect(
		spr_wind_spin,
		random_range(-width_half,width_half),
		-random(height),
		random(1),
		random(1),
		random(360),
		random(20),
		greenwind_color
	);
	play_sound(snd_chakra_loop,1,1.5);
}