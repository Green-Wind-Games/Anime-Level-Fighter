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

function play_sound(_snd,_volume = 1,_pitch = 1) {
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
			_pitch * (random(0.05) * choose(1,-1))
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
					1 * (random(0.02) * choose(1,-1))
				);
				return voice;
			}
		}
	}
	return -1;
}