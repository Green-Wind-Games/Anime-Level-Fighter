globalvar music, music_timer, music_min_duration;
music = noone;
music_timer = 0;
music_min_duration = 30;

function update_music() {
	if (audio_is_playing(music)) {
		music_timer = audio_sound_get_track_position(music);
		if (keyboard_check_pressed(vk_end)) {
			audio_sound_set_track_position(
				music,
				audio_sound_get_loop_end(music) - 5
			);
		}
	}
	else {
		music_timer = 0;
	}
}

function play_music(_music,_volume = 1,_pitch = 1,_loop = true) {
	stop_music();
	music = audio_play_sound(_music,1,_loop,master_volume*music_volume*_volume,0,_pitch);
	music_timer = 0;
	return music;
}

function stop_music() {
	audio_stop_sound(music);
}

function set_music_loop(_music,_start,_end) {
	audio_sound_loop_start(_music,_start);
	audio_sound_loop_end(_music,_end);
}

set_music_loop(mus_umvc3_charselect,40.819,86.862);

set_music_loop(mus_dbfz_goku,11.993,166.397);
set_music_loop(mus_dbfz_trunks,10.808,153.298);
set_music_loop(mus_dbfz_space,120.022,236.846);
set_music_loop(mus_extremebutoden_kaisworld,13.504,127.968);
set_music_loop(mus_extremebutoden_snakeway,19.551,207.153);

set_music_loop(mus_naruto_strongandstrike,20.991,121.857);
set_music_loop(mus_naruto_clashofninja_qualifiers,12.544,118.476);

set_music_loop(mus_opm_genos,51.630,199.342);

set_music_loop(mus_dbfz_trunks_remix,6.854,147.153);