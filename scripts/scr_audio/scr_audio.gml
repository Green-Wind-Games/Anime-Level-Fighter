globalvar master_volume, sound_volume, music_volume, voice_volume;
master_volume = 1;
sound_volume = 1;
music_volume = 1;
voice_volume = 1;

audio_set_master_gain(0,0.03);

globalvar music, music_timer, music_min_duration;
music = noone;
music_timer = 0;
music_min_duration = 60*45;

function set_music_loop(_music,_start,_end) {
	audio_sound_loop_start(_music,_start);
	audio_sound_loop_end(_music,_end);
}
	
function init_charaudio() {
	sound = noone;
	voice = noone;
	
	voice_intro[0] = noone;
	
	voice_attack[0] = noone;
	voice_heavyattack[0] = noone;
	
	voice_hurt[0] = noone;
	voice_hurt_heavy[0] = noone;
	
	voice_grabbed[0] = noone;
	
	voice_powerup[0] = noone;
	voice_transform[0] = noone;
	
	voice_dead[0] = noone;
	
	voice_victory[0] = noone;
	voice_defeat[0] = noone;
}

function update_music() {
	if audio_is_playing(music) {
		music_timer += 1;
		if keyboard_check_pressed(vk_end) {
			audio_sound_set_track_position(music,80);
		}
	}
	else {
		music_timer = 0;
	}
}

function play_music(_music,_volume = 1,_pitch = 1) {
	stop_music();
	music = audio_play_sound(_music,1,true,master_volume*music_volume*_volume,0,_pitch);
	music_timer = 0;
	return music;
}

function stop_music() {
	audio_stop_sound(music);
}

function play_sound(_snd,_volume = 1,_pitch = 1) {
	if audio_exists(_snd) {
		sound = audio_play_sound(
			_snd,
			1,
			false,
			_volume*master_volume*sound_volume,
			0,
			_pitch + (random(1/100) * choose(1,-1))
		);
		return sound;
	}
	return noone;
}

function stop_sound(_snd) {
	audio_stop_sound(_snd);
}

function sound_is_playing(_snd) {
	return audio_is_playing(_snd);
}

function loop_sound(_snd,_volume = 1,_pitch = 1) {
	if !sound_is_playing(_snd) {
		play_sound(_snd,_volume,_pitch);
	}
}

function play_voiceline(_snd,_chance = 100,_interrupt = true) {
	if (_interrupt) or ((!_interrupt) and (!sound_is_playing(voice))) {
		if random(100) < _chance {
			stop_sound(voice);
			var _voice = _snd;
			if is_array(_snd) {
				_voice = _snd[irandom(array_length(_snd)-1)];
			}
			if audio_exists(_voice) {
				voice = audio_play_sound(
					_voice,
					1,
					false,
					master_volume*voice_volume,
					0,
					1 + (random(1/100) * choose(1,-1))
				);
				return voice;
			}
		}
	}
	return -1;
}

function play_chartheme(_theme) {
	if audio_is_playing(music) {
		if music_timer < music_min_duration {
			return false;
		}
	}
	if audio_is_playing(_theme) {
		return false;
	}
	play_music(_theme);
	return true;
}

set_music_loop(mus_umvc3_charselect,40.819,86.862);

set_music_loop(mus_dbfz_goku,11.993,166.397);
set_music_loop(mus_dbfz_trunks,10.808,153.298);
set_music_loop(mus_naruto_strongandstrike,20.991,121.857);
set_music_loop(mus_opm_genos,51.630,199.342);