function init_charscripts() {
	char_script = function() {};
	
	alive_script = function() {};
	
	death_script = function() {};
	death_timer = 0;
	
	attack_whiff_script = function() {};
	attack_dodge_script = function() {};
	attack_connect_script = function() {};
	attack_hit_script = function() {};
	attack_block_script = function() {};
	attack_parry_script = function() {};
	
	defense_whiff_script = function() {};
	defense_dodge_script = function() {};
	defense_connect_script = function() {};
	defense_hit_script = function() {};
	defense_block_script = function() {};
	defense_parry_script = function() {};
	
	anim_end_script = function() {};
	state_change_script = function() {};
	
	levelup_script = function() {
		play_voiceline(voice_powerup);
	};
	transform_script = function() {
		play_voiceline(voice_transform);
	};

	draw_script = function() {};
	
	ai_script = function() {};
}

function check_charge() {
	if mp >= max_mp {
		if level >= max_level {
			return false;
		}
	}
	if !is_char(id) return false;
	if (previous_state == charge_state) and (state_timer < 30) return false;
	if (!ai_enabled) {
		if (input.charge) return true;
	}
	else {
		if mp >= max_mp {
			if xp < (max_xp * 0.8) {
				return false;
			}
		}
		if target_distance_x < 256 return false;
		if active_state == charge_state return true;
		if chance(5) return true;
	}
	return false;
}

function check_substitution(_defender,_cost = 1) {
	with(_defender) {
		if !is_char(id) return false;
		if !check_tp(_cost) return false;
		//if combo_timer > 10 return false;
		
		if !ai_enabled {
			if input.dodge return true;
		}
		else {
			if !target_exists() return false;
			if target.super_active return true;
			if combo_damage_taken < (max_hp / 20) return false;
		}
	}
	return false;
}

function teleport(_x,_y) {
	x = _x;
	y = _y;
	if !value_in_range(x,left_wall,right_wall) {
		x = clamp(x,left_wall,right_wall);
		with(target) {
			if value_in_range(x,other.x-other.width_half,other.x+other.width_half) {
				x = approach(x,room_width/2,width);
			}
		}
	}
	if y > ground_height {
		y = ground_height;
	}
}