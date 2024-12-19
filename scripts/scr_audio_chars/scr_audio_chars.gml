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