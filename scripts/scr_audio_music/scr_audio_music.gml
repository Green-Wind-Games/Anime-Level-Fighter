globalvar music, music_timer, music_min_duration, music_played_list;
music = noone;
music_timer = 0;
music_min_duration = 30;
music_played_list = ds_list_create();

function update_music() {
	if (audio_is_playing(music)) {
		music_timer += 1 / game_get_speed(gamespeed_fps);
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
	if !audio_exists(_music) exit;
	
	if audio_sound_get_asset(music) != _music {
		stop_music();
		music = audio_play_sound(_music,1,_loop,master_volume*music_volume*_volume,0,_pitch);
		music_timer = 0;
	}
	else {
		audio_sound_gain(music,_volume,0);
		audio_sound_pitch(music,_pitch);
	}
	
	ds_list_add(music_played_list,_music);
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

set_music_loop(mus_dbfz_space,120.022,236.846);
set_music_loop(mus_dbfz_westcity,6.354,184.636);
set_music_loop(mus_extremebutoden_kaisworld,13.504,127.968);
set_music_loop(mus_extremebutoden_snakeway,19.551,207.153);

set_music_loop(mus_naruto_strongandstrike,20.991,121.857);
set_music_loop(mus_naruto_clashofninja_qualifiers,12.544,118.476);

set_music_loop(mus_ff4_ds_bossbattle,14.827,76.940);
set_music_loop(mus_yakuza_zero_tusk,24.706,156.364);

set_music_loop(mus_dbfz_goku,11.993,166.397);
set_music_loop(mus_dbfz_trunks,10.808,153.298);
set_music_loop(mus_dbfz_trunks_remix,6.854,147.153);

set_music_loop(mus_opm_genos,51.630,199.342);