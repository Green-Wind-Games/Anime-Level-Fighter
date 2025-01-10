enum attacktype {
	normal,
	
	unblockable,
	grab,
	antiair,
	
	beam,
	
	hard_knockdown,
	slide_knockdown,
	
	wall_splat,
	wall_bounce,
	ground_bounce,
}

enum attackstrength {
	weak,
	light,
	medium,
	heavy,
	super,
	ultimate
}

enum hiteffects {
	none,
	
	hit,
	slash,
	pierce,
	
	fire,
	fire_dark,
	
	thunder_blue,
	thunder_yellow,
	thunder_purple,
	
	ice,
	water,
	wind,
	
	dark,
	light,
}

function get_true_attacker(_obj) {
	var _true_attacker = _obj;
	while(!is_char(_true_attacker)) {
		_true_attacker = _true_attacker.owner;
		if !instance_exists(_true_attacker) {
			_true_attacker = noone;
			break;
		}
	}
	return _true_attacker;
}

function get_attack_hitstun(_attackstrength) {
	var _hitstun = 0;
	if _attackstrength > 0 {
		_hitstun = 15 + (attack_strength * 5);
	}
	
	return round(_hitstun);
}

function get_attack_blockstun(_attackstrength) {
	var _blockstun = get_attack_hitstun(_attackstrength) - 5;
	_blockstun = max(_blockstun,0);
	
	return round(_blockstun);
}

function get_attack_hitstop(_attackstrength) {
	var _hitstop = 0;
	with(_hitbox) {
		if attack_strength > 0 {
			_hitstop = 10 + power(attack_strength,1.25);
		}
	}
	
	return round(_hitstop);
}

function check_guard(_attacktype) {
	var _guarding = false;
	if is_char(id) {
		if is_guarding _guarding = true;
		if (!ai_enabled) {
			if input.back _guarding = true;
		}
		else { 
			if chance(map_value(ai_level,1,ai_level_max,50,100)) _guarding = true;
		}
	}
	
	var _guard_valid = (can_guard) and (!is_hit);
	if _attacktype == attacktype.unblockable
	or _attacktype == attacktype.grab {
		_guard_valid = false;
	}
	if _attacktype == attacktype.antiair
	and is_airborne {
		_guard_valid = false;
	}
	
	return (_guarding and _guard_valid);
}

function guard_attack(_hitbox) {
	change_state(guard_state);
	change_sprite(guard_sprite,3,false);
	xspeed *= 1.5;
	//yspeed /= 2;
	yspeed = _yspeed;
	if on_ground {
		yspeed = 0;
	}
}

function get_hit_by_attack(_hitbox) {
	var _attacker = _hitbox.owner;
	var _true_attacker = get_true_attacker(_hitbox);
	
	xspeed = _hitbox.xknockback * _attacker.facing;
	yspeed = _hitbox.yknockback;
		
	switch(_attacktype) {
		default:
		change_state(hit_state);
		if on_ground and _hitbox.yknockback >= 0 {
			yspeed = 0;
		}
		else if is_airborne and _hitbox.yknockback == 0 {
			yspeed = -abs(xspeed) / 2;
		}
		break;
				
		case attacktype.hard_knockdown:
		change_state(hard_knockdown_state);
		break;
				
		case attacktype.wall_splat:
		change_state(wall_splat_state);
		break;
				
		case attacktype.wall_bounce:
		if previous_state != wall_bounce_state {
			change_state(wall_bounce_state);
			play_sound(snd_launch);
			hitstun = max(hitstun,100);
		}
		else {
			change_state(hit_state);
		}
		break;
				
		case attacktype.slide_knockdown:
		change_state(slide_knockdown_state);
		break;
				
		case attacktype.grab:
		with(_hitbox.owner) {
			init_grab(id,other);
		}
		break;
	}
			
	change_sprite(
		sprite == hit_high_sprite ? hit_low_sprite : hit_high_sprite,
		3,
		false
	);
	if is_airborne or (yspeed < 0) {
		change_sprite(hit_air_sprite,frame_duration,false);
	}
	if (abs(xspeed) >= 10) or (abs(yspeed) >= 10) {
		change_sprite(launch_sprite,frame_duration,true);
		yoffset = -height_half;
		rotation = point_direction(0,0,abs(xspeed),-yspeed);
	}
	if yspeed <= -10 {
		change_sprite(spinout_sprite,frame_duration,true);
		yoffset = -height_half;
		rotation = point_direction(0,0,abs(xspeed),-yspeed);
	}
	
	if (previous_hp > 0) {
		if (hp > 0) {
			var _is_strong_attack = true;
			if _hitbox.attack_strength < attackstrength.super { _is_strong_attack = false; }
			if (abs(xspeed) < 10) and (abs(yspeed) < 10) { _is_strong_attack = false; }
			//if (yspeed > -10) and on_ground { _is_strong_attack = false; }
			
			if _is_strong_attack {
				play_voiceline(voice_hurt_heavy,50,true);
			
				if meme_enabled {
					if chance(meme_chance) {
						stop_sound(voice);
						voice = play_sound(snd_meme_scream_disappear,3);
					}
				}
			}
			else {
				play_voiceline(voice_hurt,50,true);
			}
		}
		else {
			if is_char(id) {
				play_voiceline(voice_dead,100,true);
			}
			if on_ground {
				if yspeed >= 0 {
					yspeed = -5;
					xspeed = 5 * _attacker.facing;
				}
			}
		}
	}
			
	frame = 0;
	frame_timer = 0;
	facing = -_attacker.facing;
}

function connect_attack(_hitbox, _hurtbox) {
	var _attacker = _hitbox.owner;
	var _true_attacker = get_true_attacker(_hitbox);
	
	hitstun = get_attack_hitstun(_hitbox);
	blockstun = get_attack_blockstun(_hitbox);
	hitstop = get_attack_hitstop(_hitbox);
	
	hitstun = max(hitstun - (combo_hits_taken / 4), 10);
	
	var _is_strong_attack = true;
	if _hitbox.attack_strength < attackstrength.super { _is_strong_attack = false; }
	if (abs(xspeed) < 10) and (abs(yspeed) < 10) { _is_strong_attack = false; }
	//if (yspeed > -10) and on_ground { _is_strong_attack = false; }
		
	if _is_strong_attack {
		hitstun = max(hitstun,60);
	}
	
	if is_char(_attacker) {
		with(_attacker) {
			var _recovery = (anim_frames - frame) * frame_duration;
			hitstun = _recovery;
		}
	}
	else {
		hitstop *= 0.75;
	}
	
	hitstun = round(hitstun);
	blockstun = round(blockstun);
	hitstop = round(hitstop);
	
	var dmg = _hitbox.damage;
	
	if check_guard(_hitbox.attack_type) {
		guard_attack(_hitbox);
		dmg /= 20;
		take_damage(_true_attacker,dmg,false);
	}
	else {
		var _stun = true;
		if invincible {
			_stun = false;
		}
		if is_shot(_attacker) {
			if immune_to_projectiles {
				_stun = false;
			}
		}
		
		if _stun {
			get_hit_by_attack(_hitbox);
			dmg /= 1.5;
		}
		take_damage(_true_attacker,dmg,_stun);
	}
	
	if on_wall {
		if is_char(_attacker) or is_helper(_attacker) {
			_attacker.xspeed = xspeed * -0.75;
		}
	}
	
	deactivate_super();
	
	depth = 0;
	_attacker.depth = -1;
	if is_char(_attacker) or is_helper(_attacker) {
		with(_attacker) {
			_attacker.hitstop = hitstop;
			_attacker.can_cancel = true;
		}
	}
	
	if is_hit {
		combo_damage_taken += dmg;
		combo_hits_taken++;
	
		combo_timer = hitstun;
		if active_state == hard_knockdown_state
		or active_state == wall_bounce_state {
			combo_timer += 60;
		}
			
		combo_hits = 0;
		combo_damage = 0;
			
		with(_true_attacker) {
			combo_timer = other.combo_timer;
			combo_hits++;
			combo_damage += dmg;
		}
	}
	
	with(_true_attacker) {
		attack_hits++;
	}
	
	var mp_gain = dmg / 2;
	var xp_gain = dmg;
	
	var attack_mp_gain = mp_gain * 1.0;
	var attack_xp_gain = xp_gain * 1.0;
	
	var defend_mp_gain = mp_gain * 0.75;
	var defend_xp_gain = xp_gain * 0.75;
	
	with(_true_attacker) {
		attack_xp_gain /= level / other.level;
		defend_xp_gain *= level / other.level;
		if special_active or super_active or ultimate_active {
			attack_mp_gain = 0;
			attack_xp_gain *= 2;
		}
	}
	
	mp += defend_mp_gain;
	xp += defend_xp_gain;
	with(_true_attacker) {
		mp += attack_mp_gain;
		xp += attack_xp_gain;
	}
	
	create_hitspark(_hitbox,_hurtbox);
	apply_hiteffect(_hitbox.attack_strength,_hitbox.hit_effect,is_guarding);
}

function take_damage(_attacker,_amount,_kill) {
	var dmg = round(_amount / 2);
	
	var _defender = id;
	
	var _true_attacker = get_true_attacker(_attacker);
	if !instance_exists(_true_attacker) {
		_true_attacker = noone;
		dmg *= 1/4;
		_kill = false;
	}
	
	with(_true_attacker) {
		dmg *= attack_power + ((level - 1) * level_scaling);
	}
	
	if is_char(_defender){
		//_kill = (_defender.level >= 3);
		
		var _scale = true;
		var _guts = true;
		with(_true_attacker) {
			if active_state == finisher_move {
				_scale = false;
				_guts = false;
				_kill = true;
			}
			if active_state == signature_move {
				_scale = false;
				//_kill = true;
			}
		}
		if _scale {
			dmg *= get_damage_scaling(_defender);
		}
		if _guts {
			dmg *= get_damage_scaling_guts(_defender);
		}
	}
	
	dmg /= max(_defender.defense,0.1);
	
	dmg = max(round(dmg),1);
	
	hp = approach(hp,0,dmg);
	if !dead {
		if !_kill {
			hp = max(hp,1);
		}
	}
	
	return dmg;
}

function get_damage_scaling(_defender) {
	with(_defender) {
		var scaling = map_value(
			combo_hits_taken,
			0,
			50,
			1,
			0.1
		);
		scaling = clamp(scaling,0.1,1);
		return scaling;
	}
}

function get_damage_scaling_guts(_defender) {
	with(_defender) {
		var guts = map_value(
			hp+combo_damage_taken,
			max_hp/5,
			0,
			1,
			2
		);
		guts = max(guts,1);
		return clamp(1 / guts,0.1,1);
	}
}

function reset_combo() {
	if combo_hits_taken > 1 {
		show_debug_message("combo hits: " + string(combo_hits_taken));
		show_debug_message("combo damage: " + string(combo_damage_taken));
	}
	combo_hits = 0;
	combo_damage = 0;
	combo_hits_taken = 0;
	combo_damage_taken = 0;
}

function init_clash(_char1, _char2) {
	
}