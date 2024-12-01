globalvar master_volume, sound_volume, music_volume, voice_volume;
master_volume = 1;
sound_volume = 1;
music_volume = 1;
voice_volume = 1;

audio_set_master_gain(0,0.1);

globalvar music, music_timer, music_min_duration;
music = noone;
music_timer = 0;
music_min_duration = 60*45;

globalvar meme_enabled, meme_chance;
meme_enabled = true;
meme_chance = 10;

function set_music_loop(_music,_start,_end) {
	audio_sound_loop_start(_music,_start);
	audio_sound_loop_end(_music,_end);
}
	
function init_charaudio(_name = "") {
	sound = noone;
	voice = noone;
	
	voice_volume_mine = 1;
	
	var _prefix = "snd_" + _name + "_";
	
	voice_attack = asset_get_index(_prefix + "attack");
	voice_heavyattack = asset_get_index(_prefix + "heavyattack");
	
	voice_hurt = asset_get_index(_prefix + "hurt");
	voice_hurt_heavy = asset_get_index(_prefix + "hurt_heavy");
	voice_grabbed = asset_get_index(_prefix + "grabbed");
	
	voice_powerup = asset_get_index(_prefix + "powerup");
	voice_transform = asset_get_index(_prefix + "transform");
	
	voice_intro = asset_get_index(_prefix + "intro");
	voice_victory = asset_get_index(_prefix + "victory");
	voice_defeat = asset_get_index(_prefix + "defeat");
	voice_dead = asset_get_index(_prefix + "dead");
}

function update_music() {
	if (audio_is_playing(music)) {
		music_timer += 1;
		if (keyboard_check_pressed(vk_end)) {
			audio_sound_set_track_position(music,80);
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

function play_sound(_snd,_volume = 1,_pitch = 1 + (random(0.02) * choose(1,-1))) {
	if (audio_exists(_snd)) {
		var _audioname = audio_get_name(_snd);
		var _sounds;
		_sounds[0] = _snd;
		var i = 1;
		while(audio_exists(asset_get_index(_audioname + string(i+1)))) {
			_sounds[i] = asset_get_index(_audioname + string(i+1));
			i++;
		}
		sound = audio_play_sound(
			_sounds[irandom(array_length(_sounds)-1)],
			1,
			false,
			_volume*master_volume*sound_volume,
			0,
			_pitch
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
	if (!sound_is_playing(_snd)) {
		play_sound(_snd,_volume,_pitch);
	}
}

function play_voiceline(_snd,_chance = 100,_interrupt = true) {
	if (_interrupt) or ((!_interrupt) and (!sound_is_playing(voice))) {
		if (random(100) < _chance) {
			stop_sound(voice);
			if (audio_exists(_snd)) {
				var _audioname = audio_get_name(_snd);
				var _sounds;
				_sounds[0] = _snd;
				var i = 1;
				while(audio_exists(asset_get_index(_audioname + string(i+1)))) {
					_sounds[i] = asset_get_index(_audioname + string(i+1));
					i++;
				}
				voice = audio_play_sound(
					_sounds[irandom(array_length(_sounds)-1)],
					1,
					false,
					master_volume*voice_volume*voice_volume_mine,
					0,
					1 + (random(0.02) * choose(1,-1))
				);
				return voice;
			}
		}
	}
	return -1;
}

function play_chartheme(_theme) {
	if (audio_is_playing(_theme)) {
		return false;
	}
	if (audio_is_playing(music)) {
		if (music_timer < music_min_duration) {
			return false;
		}
	}
	if (audio_is_playing(_theme)) {
		return false;
	}
	play_music(_theme);
	return true;
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