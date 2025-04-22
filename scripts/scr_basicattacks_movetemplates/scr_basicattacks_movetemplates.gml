function basic_attack_stepforward(_hitframe) {
	if check_frame(max(_hitframe-2,1)) {
		if target_distance <= 40 {
			xspeed = max(5,target_distance_x / 5) * facing;
			if is_airborne {
				yspeed = min(-3,target_distance_y / 5);
			}
		}
		else {
			if on_ground {
				xspeed = 5 * facing;
			}
		}
	}
}

function basic_attack_chase(_hitframe) {
	if check_frame(min(anim_frames-1,_hitframe+2)) {
		if (attack_hits > 0) {
			if (!input.back) {
				change_state(homing_dash_state);
			}
		}
	}
}

function basic_attack(_hitframe,_damage,_strength,_hiteffect) {
	if check_frame(_hitframe) {
		var _w = sprite_get_bbox_right(sprite) - sprite_get_xoffset(sprite);
		var _h = sprite_get_height(sprite) * 0.75;
		var _x = 2;
		var _y = -height_half - (_h / 2);
		create_hitbox(
			_x,
			_y,
			_w,
			_h,
			_damage,
			2 + _strength,
			0,
			attacktype.normal,
			_strength,
			_hiteffect
		);
	}
	if frame < _hitframe {
		can_cancel = false;
	}
}

function basic_sweep(_hitframe,_damage,_strength,_hiteffect) {
	if check_frame(_hitframe) {
		var _w = sprite_get_bbox_right(sprite) - sprite_get_xoffset(sprite);
		var _h = sprite_get_height(sprite) * 0.5;
		var _x = 2;
		var _y = -_h;
		create_hitbox(
			_x,
			_y,
			_w,
			_h,
			_damage,
			1,
			-3,
			attacktype.normal,
			_strength,
			_hiteffect
		);
	}
	if frame < _hitframe {
		can_cancel = false;
	}
}

function basic_wallsplat(_hitframe,_damage,_hiteffect) {
	if check_frame(_hitframe) {
		var _w = sprite_get_bbox_right(sprite) - sprite_get_xoffset(sprite);
		var _h = sprite_get_height(sprite) * 0.75;
		var _x = 2;
		var _y = -height_half - (_h / 2);
		create_hitbox(
			_x,
			_y,
			_w,
			_h,
			_damage,
			12,
			-5,
			attacktype.normal,
			attackstrength.super,
			_hiteffect
		);
	}
	can_cancel = false;
}

function basic_launcherattack(_hitframe,_damage,_hiteffect) {
	if check_frame(_hitframe) {
		var _w = sprite_get_bbox_right(sprite) - sprite_get_xoffset(sprite);
		var _h = sprite_get_height(sprite);
		var _x = 2;
		var _y = -_h;
		create_hitbox(
			_x,
			_y,
			_w,
			_h,
			_damage,
			3,
			-10,
			attacktype.antiair,
			attackstrength.super,
			_hiteffect
		);
	}
	can_cancel = false;
}

function basic_smashattack(_hitframe,_damage,_hiteffect) {
	if check_frame(_hitframe) {
		var _w = sprite_get_bbox_right(sprite) - sprite_get_xoffset(sprite);
		var _h = sprite_get_height(sprite);
		var _x = 2;
		var _y = -_h * 0.75;
		create_hitbox(
			_x,
			_y,
			max(_w,45),
			_h,
			_damage,
			3,
			12,
			attacktype.hard_knockdown,
			attackstrength.super,
			_hiteffect
		);
	}
}

function basic_multihit_attack(_hitframe,_damage,_strength,_hiteffect) {
	if check_frame(_hitframe) {
		var _w = sprite_get_bbox_right(sprite) - sprite_get_xoffset(sprite);
		var _h = sprite_get_height(sprite) * 0.75;
		var _x = 2;
		var _y = -height_half - (_h / 2);
		create_hitbox(
			_x,
			_y,
			_w,
			_h,
			_damage,
			1 + _strength,
			0,
			attacktype.multihit,
			_strength,
			_hiteffect
		);
	}
	if frame < _hitframe {
		can_cancel = false;
	}
}

function add_basic_light_attack_state(_sprite, _hitframe, _hiteffect) {
	light_attack_sprite = _sprite;
	light_attack_sprite_hit_frame = _hitframe;
	light_attack_hit_effect = _hiteffect;
	
	switch(_hiteffect) {
		default:
		light_attack_whiff_sound = snd_punch_whiff_light;
		break;
		
		case hiteffects.slash:
		case hiteffects.pierce:
		light_attack_whiff_sound = snd_slash_hit_light;
		break;
	}
	
	light_attack.start = function() {
		change_sprite(light_attack_sprite,false);
		play_sound(light_attack_whiff_sound);
		play_voiceline(voice_attack,50,false);
	}
	light_attack.run = function() {
		basic_attack_stepforward(light_attack_sprite_hit_frame);
		basic_attack(light_attack_sprite_hit_frame,200,attackstrength.light,light_attack_hit_effect);
		anim_finish_idle();
	}
}

function add_basic_light_attack2_state(_sprite, _hitframe, _hiteffect) {
	light_attack2_sprite = _sprite;
	light_attack2_sprite_hit_frame = _hitframe;
	light_attack2_hit_effect = _hiteffect;
	
	switch(_hiteffect) {
		default:
		light_attack2_whiff_sound = snd_punch_whiff_medium;
		break;
		
		case hiteffects.slash:
		case hiteffects.pierce:
		light_attack2_whiff_sound = snd_slash_hit_medium;
		break;
	}
	
	light_attack2.start = function() {
		change_sprite(light_attack2_sprite,false);
		play_sound(light_attack2_whiff_sound);
		play_voiceline(voice_attack,50,false);
	}
	light_attack2.run = function() {
		basic_attack_stepforward(light_attack2_sprite_hit_frame);
		basic_attack(light_attack2_sprite_hit_frame,300,attackstrength.medium,light_attack2_hit_effect);
		anim_finish_idle();
	}
}

function add_basic_light_attack3_state(_sprite, _hitframe, _hiteffect) {
	light_attack3_sprite = _sprite;
	light_attack3_sprite_hit_frame = _hitframe;
	light_attack3_hit_effect = _hiteffect;
	
	switch(_hiteffect) {
		default:
		light_attack3_whiff_sound = snd_punch_whiff_heavy;
		break;
		
		case hiteffects.slash:
		case hiteffects.pierce:
		light_attack3_whiff_sound = snd_slash_hit_heavy;
		break;
	}
	
	light_attack3.start = function() {
		change_sprite(light_attack3_sprite,false);
		play_sound(light_attack3_whiff_sound);
		play_voiceline(voice_attack,50,false);
	}
	light_attack3.run = function() {
		basic_attack_stepforward(light_attack3_sprite_hit_frame);
		basic_launcherattack(light_attack3_sprite_hit_frame,500,light_attack3_hit_effect);
		basic_attack_chase(light_attack3_sprite_hit_frame);
		anim_finish_idle();
	}
}

function add_basic_medium_attack_state(_sprite, _hitframe, _hiteffect) {
	medium_attack_sprite = _sprite;
	medium_attack_sprite_hit_frame = _hitframe;
	medium_attack_hit_effect = _hiteffect;
	
	switch(_hiteffect) {
		default:
		medium_attack_whiff_sound = snd_punch_whiff_medium;
		break;
		
		case hiteffects.slash:
		case hiteffects.pierce:
		medium_attack_whiff_sound = snd_slash_hit_medium;
		break;
	}
	
	medium_attack.start = function() {
		change_sprite(medium_attack_sprite,false);
		play_sound(medium_attack_whiff_sound);
		play_voiceline(voice_attack,50,false);
	}
	medium_attack.run = function() {
		basic_attack_stepforward(medium_attack_sprite_hit_frame);
		basic_attack(medium_attack_sprite_hit_frame,300,attackstrength.medium,medium_attack_hit_effect);
		anim_finish_idle();
	}
}

function add_basic_heavy_attack_state(_sprite, _hitframe, _hiteffect) {
	heavy_attack_sprite = _sprite;
	heavy_attack_sprite_hit_frame = _hitframe;
	heavy_attack_hit_effect = _hiteffect;
	
	switch(_hiteffect) {
		default:
		heavy_attack_whiff_sound = snd_punch_whiff_super;
		break;
		
		case hiteffects.slash:
		case hiteffects.pierce:
		heavy_attack_whiff_sound = snd_slash_hit_super;
		break;
	}
	
	heavy_attack.start = function() {
		change_sprite(heavy_attack_sprite,false);
		play_sound(heavy_attack_whiff_sound);
		play_voiceline(voice_heavyattack,50,false);
	}
	heavy_attack.run = function() {
		if check_frame(1) {
			xspeed = 10 * facing;
		}
		basic_wallsplat(heavy_attack_sprite_hit_frame,500,heavy_attack_hit_effect);
		basic_attack_chase(heavy_attack_sprite_hit_frame);
		anim_finish_idle();
	}
}

function add_basic_light_lowattack_state(_sprite, _hitframe, _hiteffect) {
	light_lowattack_sprite = _sprite;
	light_lowattack_sprite_hit_frame = _hitframe;
	light_lowattack_hit_effect = _hiteffect;
	
	switch(_hiteffect) {
		default:
		light_lowattack_whiff_sound = snd_punch_whiff_light;
		break;
		
		case hiteffects.slash:
		case hiteffects.pierce:
		light_lowattack_whiff_sound = snd_slash_hit_light;
		break;
	}
	
	light_lowattack.start = function() {
		change_sprite(light_lowattack_sprite,false);
		play_sound(light_lowattack_whiff_sound);
		play_voiceline(voice_attack,50,false);
	}
	light_lowattack.run = function() {
		basic_attack_stepforward(light_lowattack_sprite_hit_frame);
		basic_attack(light_lowattack_sprite_hit_frame,200,attackstrength.light,light_lowattack_hit_effect);
		anim_finish_idle();
	}
}

function add_basic_medium_lowattack_state(_sprite, _hitframe, _hiteffect) {
	medium_lowattack_sprite = _sprite;
	medium_lowattack_sprite_hit_frame = _hitframe;
	medium_lowattack_hit_effect = _hiteffect;
	
	switch(_hiteffect) {
		default:
		medium_lowattack_whiff_sound = snd_punch_whiff_medium;
		break;
		
		case hiteffects.slash:
		case hiteffects.pierce:
		medium_lowattack_whiff_sound = snd_slash_hit_medium;
		break;
	}
	
	medium_lowattack.start = function() {
		change_sprite(medium_lowattack_sprite,false);
		play_sound(medium_lowattack_whiff_sound);
		play_voiceline(voice_attack,50,false);
	}
	medium_lowattack.run = function() {
		basic_attack_stepforward(medium_lowattack_sprite_hit_frame);
		basic_sweep(medium_lowattack_sprite_hit_frame,300,attackstrength.medium,medium_lowattack_hit_effect);
		anim_finish_idle();
	}
}

function add_basic_heavy_lowattack_state(_sprite, _hitframe, _hiteffect) {
	heavy_lowattack_sprite = _sprite;
	heavy_lowattack_sprite_hit_frame = _hitframe;
	heavy_lowattack_hit_effect = _hiteffect;
	
	switch(_hiteffect) {
		default:
		heavy_lowattack_whiff_sound = snd_punch_whiff_super;
		break;
		
		case hiteffects.slash:
		case hiteffects.pierce:
		heavy_lowattack_whiff_sound = snd_slash_hit_super;
		break;
	}
	
	heavy_lowattack.start = function() {
		change_sprite(heavy_lowattack_sprite,false);
		play_sound(heavy_lowattack_whiff_sound);
		play_voiceline(voice_heavyattack,50,false);
	}
	heavy_lowattack.run = function() {
		if check_frame(1) {
			xspeed = 3 * facing;
			yspeed = -5;
		}
		basic_launcherattack(heavy_lowattack_sprite_hit_frame,500,heavy_lowattack_hit_effect);
		basic_attack_chase(heavy_lowattack_sprite_hit_frame);
		anim_finish_idle();
	}
}

function add_basic_light_airattack_state(_sprite, _hitframe, _hiteffect) {
	light_airattack_sprite = _sprite;
	light_airattack_sprite_hit_frame = _hitframe;
	light_airattack_hit_effect = _hiteffect;
	
	switch(_hiteffect) {
		default:
		light_airattack_whiff_sound = snd_punch_whiff_light;
		break;
		
		case hiteffects.slash:
		case hiteffects.pierce:
		light_airattack_whiff_sound = snd_slash_hit_light;
		break;
	}
	
	light_airattack.start = function() {
		change_sprite(light_airattack_sprite,false);
		play_sound(light_airattack_whiff_sound);
		play_voiceline(voice_attack,50,false);
	}
	light_airattack.run = function() {
		basic_attack_stepforward(light_airattack_sprite_hit_frame);
		basic_attack(light_airattack_sprite_hit_frame,200,attackstrength.light,light_airattack_hit_effect);
		anim_finish_idle();
	}
}

function add_basic_medium_airattack_state(_sprite, _hitframe, _hiteffect) {
	medium_airattack_sprite = _sprite;
	medium_airattack_sprite_hit_frame = _hitframe;
	medium_airattack_hit_effect = _hiteffect;
	
	switch(_hiteffect) {
		default:
		medium_airattack_whiff_sound = snd_punch_whiff_medium;
		break;
		
		case hiteffects.slash:
		case hiteffects.pierce:
		medium_airattack_whiff_sound = snd_slash_hit_medium;
		break;
	}
	
	medium_airattack.start = function() {
		change_sprite(medium_airattack_sprite,false);
		play_sound(medium_airattack_whiff_sound);
		play_voiceline(voice_attack,50,false);
	}
	medium_airattack.run = function() {
		basic_attack_stepforward(medium_airattack_sprite_hit_frame);
		basic_attack(medium_airattack_sprite_hit_frame,300,attackstrength.medium,medium_airattack_hit_effect);
		anim_finish_idle();
	}
}

function add_basic_heavy_airattack_state(_sprite, _hitframe, _hiteffect) {
	heavy_airattack_sprite = _sprite;
	heavy_airattack_sprite_hit_frame = _hitframe;
	heavy_airattack_hit_effect = _hiteffect;
	
	switch(_hiteffect) {
		default:
		heavy_airattack_whiff_sound = snd_punch_whiff_super;
		break;
		
		case hiteffects.slash:
		case hiteffects.pierce:
		heavy_airattack_whiff_sound = snd_slash_hit_super;
		break;
	}
	
	heavy_airattack.start = function() {
		change_sprite(heavy_airattack_sprite,false);
		play_sound(heavy_airattack_whiff_sound);
		play_voiceline(voice_heavyattack,50,false);
		attack_hit_script = function(_attacker,_defender) {
			print("attack hit script");
			if _attacker == id {
				xspeed = -5 * facing;
				yspeed = -3;
			}
		}
	}
	heavy_airattack.run = function() {
		basic_attack_stepforward(heavy_airattack_sprite_hit_frame);
		basic_smashattack(heavy_airattack_sprite_hit_frame,500,heavy_airattack_hit_effect);
		anim_finish_idle();
	}
}

function add_basic_heavy_air_launcher_state(_sprite, _hitframe, _hiteffect) {
	heavy_air_launcher_sprite = _sprite;
	heavy_air_launcher_sprite_hit_frame = _hitframe;
	heavy_air_launcher_hit_effect = _hiteffect;
	
	switch(_hiteffect) {
		default:
		heavy_air_launcher_whiff_sound = snd_punch_whiff_super;
		break;
		
		case hiteffects.slash:
		case hiteffects.pierce:
		heavy_air_launcher_whiff_sound = snd_slash_hit_super;
		break;
	}
	
	heavy_air_launcher.start = function() {
		change_sprite(heavy_air_launcher_sprite,false);
		play_sound(heavy_air_launcher_whiff_sound);
		play_voiceline(voice_heavyattack,50,false);
		xspeed = 3 * facing;
		yspeed = -5;
	}
	heavy_air_launcher.run = function() {
		if ds_list_find_index(combo_moves, homing_dash_state) == -1 {
			basic_launcherattack(heavy_air_launcher_sprite_hit_frame,500,heavy_air_launcher_hit_effect);
			basic_attack_chase(heavy_air_launcher_sprite_hit_frame);
		}
		else {
			basic_attack_stepforward(heavy_air_launcher_sprite_hit_frame);
			basic_attack(heavy_air_launcher_sprite_hit_frame,400,attackstrength.heavy,heavy_air_launcher_hit_effect);
		}
		anim_finish_idle();
	}
}