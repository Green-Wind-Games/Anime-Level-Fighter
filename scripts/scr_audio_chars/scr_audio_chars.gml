function init_charaudio(_name = "") {
	sound = noone;
	voice = noone;
	
	voice_volume_mine = 1;
	voice_pitch_mine = 1;
	
	var _prefix = "vc_" + _name + "_";
	
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

function play_chartheme(_char) {
	with(_char) {
		if (audio_is_playing(music)) {
			if (music_timer < music_min_duration) {
				return false;
			}
		}
		if (audio_is_playing(theme)) {
			return false;
		}
		if ds_list_find_index(music_played_list,theme) == -1 {
			play_music(theme,1,theme_pitch);
			return true;
		}
		else {
			play_music(theme,1,theme_pitch);
			return false;
		}
	}
	return false;
}

function play_leveluptheme(_char) {
	with(_char) {
		if ds_list_find_index(music_played_list,theme) == -1 {
			play_chartheme(id);
		}
		else {
			if music_timer < min(music_min_duration, audio_sound_get_loop_start(music)) {
				exit;
			}
			
			var _musiclist = array_create(0);
			var _nextlevel = level+1;
			switch(_nextlevel) {
				default:
				array_push(_musiclist,
					mus_extremebutoden_snakeway
				);
				break;
				
				case max_level:
				array_push(_musiclist,
					mus_extremebutoden_kaisworld
				);
				break;
			}
			
			var _already = 0;
			
			for(var i = 0; i < array_length(_musiclist); i++) {
				if ds_list_find_index(music_played_list,_musiclist[i]) != -1 {
					_already++;
				}
			}
			
			if _already < array_length(_musiclist) - 1 {
				for(var i = 0; i < array_length(_musiclist); i++) {
					if ds_list_find_index(music_played_list,_musiclist[i]) != -1 {
						array_delete(_musiclist,i,1);
						i--;
					}
				}
			}
			
			if array_length(_musiclist) >= 1 {
				array_shuffle(_musiclist);
				play_music(_musiclist[0]);
			}
			else {
				play_music(theme,1,theme_pitch);
			}
		}
	}
}