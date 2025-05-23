globalvar	lightattack_startup, mediumattack_startup, heavyattack_startup,
			lightattack_recovery, mediumattack_recovery, heavyattack_recovery;

lightattack_startup = 5;
mediumattack_startup = 8;
heavyattack_startup = 12;

lightattack_recovery = 20;
mediumattack_recovery = 25;
heavyattack_recovery = 30;

function basic_attack_stepforward(_hitframe) {
	if check_frame(max(_hitframe-2,1)) {
		if on_ground {
			xspeed = 5 * facing;
		}
		else {
			if target_distance <= 30 {
				xspeed = 5 * facing;
				yspeed = clamp(jump_towards_y(target_y,3),-3.5,-2.5);
			}
		}
	}
}

function basic_attack_chase(_hitframe) {
	var chase_time = (_hitframe * frame_duration) + 5;
	if chase_time >= anim_duration - 1 {
		chase_time = anim_duration - 1;
	}
	if (anim_timer >= chase_time) {
		if (combo_hits > 0) and (attack_hits > 0) {
			if (!input.back) {
				change_state(homing_dash_state);
				print("chasing");
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
	if frame < (_hitframe - 1) {
		can_cancel = false;
	}
}

function basic_attack_frame_speed(_startup_frame,_recovery_frame,_startup_duration,_recovery_duration) {
	if frame <= _startup_frame {
		anim_speed = (max(1,_startup_frame) * frame_duration) / _startup_duration;
	}
	else if frame >= _recovery_frame {
		anim_speed = (max(1,anim_frames - _recovery_frame) * frame_duration) / _recovery_duration;
	}
	else {
		anim_speed = 1;
	}
}

function add_basic_light_attack_state(_sprite, _hitframe, _strength, _hiteffect) {
	var i = array_length(light_attack);
	light_attack[i] = new charstate();
	
	light_attack[i].sprite = _sprite;
	light_attack[i].hit_frame = _hitframe;
	light_attack[i].strength = _strength;
	light_attack[i].hit_effect = _hiteffect;
	light_attack[i].whiff_sound = get_whiff_sound(_strength,_hiteffect);
	light_attack[i].unique_script = function() {};
	
	light_attack[i].start = function() {
		change_sprite(active_state.sprite,false);
		play_sound(active_state.whiff_sound);
		play_voiceline(voice_attack,100,false);
	}
	light_attack[i].run = function() {
		basic_attack_frame_speed(
			active_state.hit_frame-1,
			active_state.hit_frame+1,
			lightattack_startup,
			lightattack_recovery
		);
		basic_attack_stepforward(active_state.hit_frame);
		basic_attack(
			active_state.hit_frame,
			(active_state.strength * 100) + 100,
			active_state.strength,
			active_state.hit_effect
		);
		active_state.unique_script();
		anim_finish_idle();
	}
	
	add_ground_move(light_attack[i],"A");
	
	return light_attack[i];
}

function add_basic_light_attack_launcher_state(_sprite, _hitframe, _hiteffect) {
	var i = array_length(light_attack);
	light_attack[i] = new charstate();
	light_attack[i].attack_id = i;
	
	light_attack[i].sprite = _sprite;
	light_attack[i].hit_frame = _hitframe;
	light_attack[i].strength = attackstrength.super;
	light_attack[i].hit_effect = _hiteffect;
	light_attack[i].whiff_sound = get_whiff_sound(light_attack[i].strength,_hiteffect);
	light_attack[i].unique_script = function() {};
	
	light_attack[i].start = function() {
		change_sprite(active_state.sprite,false);
		play_sound(active_state.whiff_sound);
		play_voiceline(voice_heavyattack,50,true);
	}
	light_attack[i].run = function() {
		basic_attack_frame_speed(
			active_state.hit_frame-1,
			active_state.hit_frame+1,
			heavyattack_startup,
			heavyattack_recovery
		);
		basic_attack_stepforward(active_state.hit_frame);
		basic_launcherattack(
			active_state.hit_frame,
			(active_state.strength * 100) + 100,
			active_state.hit_effect
		);
		active_state.unique_script();
		basic_attack_chase(active_state.hit_frame);
		anim_finish_idle();
	}
	
	add_ground_move(light_attack[i],"A");
	
	return light_attack[i];
}

function add_basic_light_airattack_state(_sprite, _hitframe, _hiteffect) {
	light_airattack.sprite = _sprite;
	light_airattack.hit_frame = _hitframe;
	light_airattack.strength = attackstrength.light;
	light_airattack.hit_effect = _hiteffect;
	light_airattack.whiff_sound = get_whiff_sound(light_airattack.strength,_hiteffect);
	light_airattack.unique_script = function() {};
	
	light_airattack.start = function() {
		change_sprite(light_airattack.sprite,false);
		play_sound(light_airattack.whiff_sound);
		play_voiceline(voice_attack,100,false);
	}
	light_airattack.run = function() {
		basic_attack_frame_speed(
			light_airattack.hit_frame-1,
			light_airattack.hit_frame+1,
			lightattack_startup,
			lightattack_recovery
		);
		basic_attack_stepforward(light_airattack.hit_frame);
		basic_attack(
			light_airattack.hit_frame,
			(light_airattack.strength * 100) + 100,
			light_airattack.strength,
			light_airattack.hit_effect
		);
		light_airattack.unique_script();
		anim_finish_idle();
	}
}

function add_basic_medium_attack_state(_sprite, _hitframe, _hiteffect) {
	medium_attack.sprite = _sprite;
	medium_attack.hit_frame = _hitframe;
	medium_attack.strength = attackstrength.medium;
	medium_attack.hit_effect = _hiteffect;
	medium_attack.whiff_sound = get_whiff_sound(medium_attack.strength,_hiteffect);
	medium_attack.unique_script = function() {};
	
	medium_attack.start = function() {
		change_sprite(medium_attack.sprite,false);
		play_sound(medium_attack.whiff_sound);
		play_voiceline(voice_attack,100,false);
	}
	medium_attack.run = function() {
		basic_attack_frame_speed(
			medium_attack.hit_frame-1,
			medium_attack.hit_frame+1,
			mediumattack_startup,
			mediumattack_recovery
		);
		basic_attack_stepforward(medium_attack.hit_frame);
		basic_attack(
			medium_attack.hit_frame,
			(medium_attack.strength * 100) + 100,
			medium_attack.strength,
			medium_attack.hit_effect
		);
		medium_attack.unique_script();
		anim_finish_idle();
	}
}

function add_basic_medium_sweep_state(_sprite, _hitframe, _hiteffect) {
	medium_sweep.sprite = _sprite;
	medium_sweep.hit_frame = _hitframe;
	medium_sweep.strength = attackstrength.medium;
	medium_sweep.hit_effect = _hiteffect;
	medium_sweep.whiff_sound = get_whiff_sound(medium_sweep.strength,_hiteffect);
	medium_sweep.unique_script = function() {};
	
	medium_sweep.start = function() {
		change_sprite(medium_sweep.sprite,false);
		play_sound(medium_sweep.whiff_sound);
		play_voiceline(voice_attack,100,false);
	}
	medium_sweep.run = function() {
		basic_attack_frame_speed(
			medium_sweep.hit_frame-1,
			medium_sweep.hit_frame+1,
			mediumattack_startup,
			mediumattack_recovery
		);
		basic_attack_stepforward(medium_sweep.hit_frame);
		basic_sweep(
			medium_sweep.hit_frame,
			(medium_sweep.strength * 100) + 100,
			medium_sweep.strength,
			medium_sweep.hit_effect
		);
		medium_sweep.unique_script();
		anim_finish_idle();
	}
}

function add_basic_medium_airattack_state(_sprite, _hitframe, _hiteffect) {
	medium_airattack.sprite = _sprite;
	medium_airattack.hit_frame = _hitframe;
	medium_airattack.strength = attackstrength.medium;
	medium_airattack.hit_effect = _hiteffect;
	medium_airattack.whiff_sound = get_whiff_sound(medium_airattack.strength,_hiteffect);
	medium_airattack.unique_script = function() {};
	
	medium_airattack.start = function() {
		change_sprite(medium_airattack.sprite,false);
		play_sound(medium_airattack.whiff_sound);
		play_voiceline(voice_attack,100,false);
	}
	medium_airattack.run = function() {
		basic_attack_frame_speed(
			medium_airattack.hit_frame-1,
			medium_airattack.hit_frame+1,
			mediumattack_startup,
			mediumattack_recovery
		);
		basic_attack_stepforward(medium_airattack.hit_frame);
		basic_attack(
			medium_airattack.hit_frame,
			(medium_airattack.strength * 100) + 100,
			medium_airattack.strength,
			medium_airattack.hit_effect
		);
		medium_airattack.unique_script();
		anim_finish_idle();
	}
}

function add_basic_heavy_attack_state(_sprite, _hitframe, _hiteffect) {
	heavy_attack.sprite = _sprite;
	heavy_attack.hit_frame = _hitframe;
	heavy_attack.strength = attackstrength.super;
	heavy_attack.hit_effect = _hiteffect;
	heavy_attack.whiff_sound = get_whiff_sound(heavy_attack.strength,_hiteffect);
	heavy_attack.unique_script = function() {};
	
	heavy_attack.start = function() {
		change_sprite(heavy_attack.sprite,false);
		play_sound(heavy_attack.whiff_sound);
		play_voiceline(voice_attack,100,false);
	}
	heavy_attack.run = function() {
		basic_attack_frame_speed(
			heavy_attack.hit_frame-1,
			heavy_attack.hit_frame+1,
			heavyattack_startup,
			heavyattack_recovery
		);
		basic_attack_stepforward(heavy_attack.hit_frame);
		basic_wallsplat(
			heavy_attack.hit_frame,
			(heavy_attack.strength * 100) + 100,
			heavy_attack.hit_effect
		);
		heavy_attack.unique_script();
		basic_attack_chase(heavy_attack.hit_frame);
		anim_finish_idle();
	}
}

function add_basic_heavy_launcher_state(_sprite, _hitframe, _hiteffect) {
	heavy_launcher.sprite = _sprite;
	heavy_launcher.hit_frame = _hitframe;
	heavy_launcher.strength = attackstrength.super;
	heavy_launcher.hit_effect = _hiteffect;
	heavy_launcher.whiff_sound = get_whiff_sound(heavy_launcher.strength,_hiteffect);
	heavy_launcher.unique_script = function() {};
	
	heavy_launcher.start = function() {
		change_sprite(heavy_launcher.sprite,false);
		play_sound(heavy_launcher.whiff_sound);
		play_voiceline(voice_attack,100,false);
	}
	heavy_launcher.run = function() {
		basic_attack_frame_speed(
			heavy_launcher.hit_frame-1,
			heavy_launcher.hit_frame+1,
			heavyattack_startup,
			heavyattack_recovery
		);
		if check_frame(1) {
			xspeed = 2 * facing;
			yspeed = -4;
		}
		basic_launcherattack(
			heavy_launcher.hit_frame,
			(heavy_launcher.strength * 100) + 100,
			heavy_launcher.hit_effect
		);
		heavy_launcher.unique_script();
		basic_attack_chase(heavy_attack.hit_frame);
		anim_finish_idle();
	}
}

function add_basic_heavy_airattack_state(_sprite, _hitframe, _hiteffect) {
	heavy_airattack.sprite = _sprite;
	heavy_airattack.hit_frame = _hitframe;
	heavy_airattack.strength = attackstrength.super;
	heavy_airattack.hit_effect = _hiteffect;
	heavy_airattack.whiff_sound = get_whiff_sound(heavy_airattack.strength,_hiteffect);
	heavy_airattack.unique_script = function() {};
	
	heavy_airattack.start = function() {
		change_sprite(heavy_airattack.sprite,false);
		play_sound(heavy_airattack.whiff_sound);
		play_voiceline(voice_attack,100,false);
		attack_connect_script = function(_attacker, _defender) {
			if _attacker == id {
				xspeed = -5 * facing;
				yspeed = -5;
			}
		}
	}
	heavy_airattack.run = function() {
		basic_attack_frame_speed(
			heavy_airattack.hit_frame-1,
			heavy_airattack.hit_frame+1,
			heavyattack_startup,
			heavyattack_recovery
		);
		basic_attack_stepforward(heavy_airattack.hit_frame);
		basic_smashattack(
			heavy_airattack.hit_frame,
			(heavy_airattack.strength * 100) + 100,
			heavy_airattack.hit_effect
		);
		heavy_airattack.unique_script();
		anim_finish_idle();
	}
}

function add_basic_heavy_air_launcher_state(_sprite, _hitframe, _hiteffect) {
	heavy_air_launcher.sprite = _sprite;
	heavy_air_launcher.hit_frame = _hitframe;
	heavy_air_launcher.strength = attackstrength.super;
	heavy_air_launcher.hit_effect = _hiteffect;
	heavy_air_launcher.whiff_sound = get_whiff_sound(heavy_air_launcher.strength,_hiteffect);
	heavy_air_launcher.unique_script = function() {};
	
	heavy_air_launcher.start = function() {
		change_sprite(heavy_air_launcher.sprite,false);
		play_sound(heavy_air_launcher.whiff_sound);
		play_voiceline(voice_heavyattack,50,false);
	}
	heavy_air_launcher.run = function() {
		basic_attack_frame_speed(
			heavy_air_launcher.hit_frame-1,
			heavy_air_launcher.hit_frame+1,
			heavyattack_startup,
			heavyattack_recovery
		);
		basic_attack_stepforward(heavy_air_launcher.hit_frame);
		var _strong = ds_list_find_index(combo_moves, homing_dash_state) == -1;
		if _strong {
			basic_launcherattack(heavy_air_launcher.hit_frame,500,heavy_air_launcher.hit_effect);
			basic_attack_chase(heavy_air_launcher.hit_frame);
		}
		else {
			basic_attack(heavy_air_launcher.hit_frame,400,attackstrength.heavy,heavy_air_launcher.hit_effect);
		}
		anim_finish_idle();
		land();
	}
}