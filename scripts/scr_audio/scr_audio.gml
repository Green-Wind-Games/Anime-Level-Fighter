globalvar master_volume, sound_volume, music_volume, voice_volume;
master_volume = 1;
sound_volume = 1;
music_volume = 1;
voice_volume = 1;

audio_set_master_gain(0,0.25);

//globalvar bitcrusher_effect, lowpass_effect;
//var i = 0;
//bitcrusher_effect = audio_effect_create(AudioEffectType.Bitcrusher);
//bitcrusher_effect.factor = 8;
//audio_bus_main.effects[i++] = bitcrusher_effect;
//lowpass_effect = audio_effect_create(AudioEffectType.LPF2);
//lowpass_effect.cutoff = 1000;
//audio_bus_main.effects[i++] = lowpass_effect;

globalvar meme_enabled, meme_chance;
meme_enabled = false;
meme_chance = 10;

function play_sound(_snd,_volume = 1,_pitch = 1) {
	if (audio_exists(_snd)) {
		var _audioname = audio_get_name(_snd);
		var _sounds = array_create(0);
		_sounds[0] = _snd;
		
		for(var i = 1; i < 10; i++) {
			var _snd2 = asset_get_index(_audioname + string(i+1));
			if !audio_exists(_snd2) continue;
			array_push(_sounds,_snd2);
		}
		
		var _universe = -1;
		if is_char(id) {
			_universe = universe;
		}
		else if is_helper(id) or is_shot(id) or is_beam(id) {
			if instance_exists(owner) {
				_universe = owner.universe;
			}
		}
		var _prefix = "snd_" + get_universe_shortname(_universe) + "_";
		var _noprefix = string_delete(_audioname,1,4);
		for(var i = 0; i < 10; i++) {
			var _audioname2 = _prefix + _noprefix;
			if i > 0 {
				_audioname2 += string(i+1);
			}
			var _snd2 = asset_get_index(_audioname2);
			if !audio_exists(_snd2) continue;
			if i == 0 {
				array_delete(_sounds,0,array_length(_sounds));
			}
			array_push(_sounds,_snd2);
		}
		
		array_shuffle(_sounds);
		
		var _random_pitch = false;
		if object_is_ancestor(object_index,obj_char)
		or object_is_ancestor(object_index,obj_shot)
		or object_is_ancestor(object_index,obj_hitbox_parent) {
			_random_pitch = 0.05;
		}
		
		sound = audio_play_sound(
			_sounds[0],
			1,
			false,
			_volume*master_volume*sound_volume,
			0,
			_pitch + random_range(_random_pitch,-_random_pitch)
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
		if chance(_chance) {
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
					voice_pitch_mine + random_range(0.02,-0.02)
				);
				return voice;
			}
		}
	}
	return -1;
}

function get_whiff_sound(_strength, _hiteffect) {
	var _strengthname = "light";
	var _effectname = "punch";
	
	if _strength < attackstrength.medium {
		_strengthname = "light";
	}
	else if _strength < attackstrength.heavy {
		_strengthname = "medium";
	}
	else if _strength < attackstrength.super {
		_strengthname = "heavy";
	}
	else if _strength < attackstrength.ultimate {
		_strengthname = "super";
	}
	else {
		_strengthname = "ultimate";
	}
	
	if _hiteffect == hiteffects.slash {
		_effectname = "slash";
	}
	
	return asset_get_index("snd_"+ _effectname + "_whiff_" + _strengthname);
}