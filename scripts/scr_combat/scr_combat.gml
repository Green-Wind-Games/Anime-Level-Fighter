enum attacktype {
	normal,
	multihit,
	
	hard_knockdown,
	
	unblockable,
	antiair,
	
	hit_grab,
	grab,
	command_grab,
	
	wall_bounce,
	ground_bounce,
	
	beam
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
	fire_blue,
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

function get_true_owner(_obj) {
	if !instance_exists(_obj) return noone;
	var _true_owner = _obj;
	while(instance_exists(_true_owner.owner)) {
		_true_owner = _true_owner.owner;
	}
	return _true_owner;
}

function get_attack_hitstun(_attackstrength) {
	var _hitstun = 5;
	if _attackstrength > 0 {
		_hitstun = 15 + (_attackstrength * 5);
	}
	
	return round(_hitstun);
}

function get_attack_blockstun(_attackstrength) {
	var _blockstun = get_attack_hitstun(_attackstrength) - 5;
	_blockstun = max(_blockstun,5);
	
	return round(_blockstun);
}

function get_attack_hitstop(_attackstrength) {
	var _hitstop = 5;
	if _attackstrength > 0 {
		_hitstop = 10 + power(_attackstrength,1.5);
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
	or _attacktype == attacktype.grab
	or _attacktype == attacktype.command_grab {
		_guard_valid = false;
	}
	if _attacktype == attacktype.antiair {
		if is_airborne _guard_valid = false;
	}
	
	return (_guarding and _guard_valid);
}

function guard_attack(_hitbox) {
	change_state(guard_state);
	change_sprite(guard_sprite,false);
	xspeed *= 1.5;
	yspeed = 0;
}

function react_to_attack_type(_hitbox, _attacktype) {
	var _attacker = _hitbox.owner;
	var _true_attacker = get_true_owner(_hitbox.owner);
	
	switch(_attacktype) {
		default:
		change_state(hit_state);
		break;
		
		case attacktype.hard_knockdown:
		if on_ground and (yspeed >= 0) {
			change_state(hit_state);
		}
		else {
			var _kd = true;
			if ds_list_size(_true_attacker.combo_moves) > 1 {
				_kd = false;
				with(_true_attacker) {
					var _input = "";
					for(var i = 0; i < ds_list_size(combo_moves); i++) {
						var _move = ds_list_find_value(combo_moves,i);
						var _thisinput = get_move_input(_move)[0];
					
						if (_thisinput != "none")
						and (_move != homing_dash_state) {
							if _input == "" {
								_input = _thisinput;
							}
							else {
								if _input != _thisinput {
									print("kd");
									_kd = true;
									break;
								}
							}
						}
					}
				}
			}
			if _kd {
				change_state(hard_knockdown_state);
			}
			else {
				change_state(hit_state);
			}
		}
		break;
		
		case attacktype.wall_bounce:
		if previous_state != wall_bounce_state {
			change_state(wall_bounce_state);
			play_sound(snd_dbz_hit_launch);
			hitstun = max(hitstun,100);
		}
		else {
			change_state(hit_state);
		}
		break;
		
		case attacktype.grab:
		with(_hitbox.owner) {
			init_grab(id,other);
		}
		break;
	}
	change_sprite_hit();
}

function change_sprite_hit() {
	change_sprite(
		sprite == hit_high_sprite ? hit_low_sprite : hit_high_sprite,
		false
	);
	if is_airborne or (yspeed < 0) {
		change_sprite(hit_air_sprite,false);
	}
	if (abs(xspeed) >= 10) or (abs(yspeed) >= 10) {
		change_sprite(launch_sprite,true);
		yoffset = -height_half;
		rotation = point_direction(0,0,abs(xspeed),-yspeed);
	}
	if yspeed <= -10 {
		change_sprite(spinout_sprite,true);
		yoffset = -height_half;
		rotation = point_direction(0,0,abs(xspeed),-yspeed);
	}
}

function play_hurt_sound(_is_strong_attack) {
	if (previous_hp > 0) {
		if (hp > 0) {
			var _voice_chance = 50 + (dmg_percent * 2);
			if _is_strong_attack {
				play_voiceline(
					(meme_enabled and chance(meme_chance)) ? snd_meme_scream : voice_hurt_heavy,
					_voice_chance,
					true
				);
			}
			else {
				play_voiceline(
					(dmg_percent < 10) ? voice_hurt : voice_hurt_heavy,
					_voice_chance,
					false
				);
			}
		}
		else {
			if is_char(id) {
				play_voiceline(voice_dead,100,true);
			}
		}
	}
}

function get_hit_by_attack(_hitbox) {
	var _attacker = _hitbox.owner;
	var _true_attacker = get_true_owner(_attacker);
	
	xspeed = _hitbox.xknockback * _attacker.facing;
	yspeed = _hitbox.yknockback;
	
	if on_ground and (yspeed >= 0) {
		yspeed = 0;
	}
	else if is_airborne and (yspeed == 0) {
		yspeed = -abs(xspeed);
	}
	
	react_to_attack_type(_hitbox, _hitbox.attack_type);
	
	var _is_strong_attack = (abs(xspeed) >= 10) or (abs(yspeed) >= 10);
	if _is_strong_attack {
		var _recenter_dir = _attacker.rotation;
		
		var _recenter_dist = width_half;
		_recenter_dist += max(
			_attacker.width_half,
			_hitbox.width/2
		);
		
		var _recenter_x = _attacker.x;
		var _recenter_y = _attacker.y + (height_half - _attacker.height_half);
		
		_recenter_x += lengthdir_x(_recenter_dist,_recenter_dir) * _attacker.facing;
		_recenter_y += lengthdir_y(_recenter_dist,_recenter_dir);
		
		var _lerp = 1;
		_recenter_x = lerp(x,_recenter_x,_lerp);
		_recenter_y = lerp(y,_recenter_y,_lerp);
		
		_recenter_x = clamp(_recenter_x,left_wall,right_wall);
		_recenter_y = min(_recenter_y,ground_height);
		
		x = _recenter_x;
		y = _recenter_y;
		
		play_hurt_sound(true);
	}
	else {
		play_hurt_sound(false);
	}
	
	facing = -_attacker.facing;
}

function connect_attack(_hitbox,_hurtbox) {
	var _attacker = _hitbox.owner.id;
	var _defender = _hurtbox.owner.id;
	var _true_attacker = get_true_owner(_attacker);
	
	hitstun = _hitbox.hitstun;
	blockstun = _hitbox.blockstun;
	hitstop = _hitbox.hitstop;
	
	hitstun = max(hitstun - (combo_hits_taken / 4), 10);
	
	if (_hitbox.attack_type == attacktype.multihit)
	or !is_char(_attacker) {
		hitstop *= 0.5;
	}
	
	var _is_strong_attack = true;
	if _hitbox.attack_strength < attackstrength.super { _is_strong_attack = false; }
	if (abs(xspeed) < 10) and (abs(yspeed) < 10) { _is_strong_attack = false; }
	//if (yspeed > -10) and on_ground { _is_strong_attack = false; }
		
	if _is_strong_attack {
		hitstun = max(hitstun,60);
	}
	
	hitstun = round(hitstun);
	blockstun = round(blockstun);
	hitstop = round(hitstop);
	
	var dmg = _hitbox.damage;
	
	if check_guard(_hitbox.attack_type) {
		guard_attack(_hitbox);
		dmg = take_damage(_true_attacker,dmg/20,false);
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
		}
		else {
			dmg *= 0.75;
		}
		dmg = take_damage(_true_attacker,dmg,_stun);
	}
	
	deactivate_super();
	
	depth = 0;
	_attacker.depth = -1;
	if is_char(_attacker) or is_helper(_attacker) {
		with(_attacker) {
			hitstop = _defender.hitstop;
		}
	}
	
	with(_attacker) {
		if is_char(id) or is_helper(id) {
			can_cancel = true;
		}
	}
	with(_true_attacker) {
		attack_hits++;
		if attack_hits == 1 {
			ds_list_add(combo_moves, _hitbox.my_state);
		}
	}
	
	if is_hit {
		combo_damage_taken += dmg;
		combo_hits_taken++;
	
		combo_timer = hitstun;
		if active_state == hard_knockdown_state
		or active_state == wall_bounce_state {
			combo_timer += 30;
		}
			
		combo_hits = 0;
		combo_damage = 0;
			
		with(_true_attacker) {
			combo_timer = other.combo_timer;
			combo_hits++;
			combo_damage += dmg;
			
			combo_hits_counter = combo_hits;
			combo_damage_counter = combo_damage;
			
			if attack_hits == 1 {
				var _scaling = 0.99;
				if combo_hits == 1 {
					_scaling = map_value(state_timer,0,10,0.90,1);
					_scaling = clamp(_scaling,0.5,1);
					if state_timer >= 30 {
						_scaling = 1.5;
					}
				}
				with(_defender) {
					combo_damage_scaling *= _scaling;
					combo_damage_scaling = max(combo_damage_scaling,0.1);
				}
			}
		}
	}
	
	var mp_gain = dmg * 2;
	var xp_gain = dmg / 2;
	
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
	
	with(_true_attacker) {
		attack_connect_script(_attacker,_defender);
		if _defender.is_hit {
			attack_hit_script(_attacker,_defender);
		}
		else if _defender.is_guarding {
			attack_block_script(_attacker,_defender);
		}
		print(state_timer);
	}
	with(_defender) {
		defense_connect_script(_attacker,_defender);
		if is_hit {
			defense_hit_script(_attacker,_defender);
		}
		else if is_guarding {
			defense_block_script(_attacker,_defender);
		}
	}
	
	create_hitspark(_hitbox,_hurtbox);
	apply_hiteffect(_hitbox.attack_strength,_hitbox.hit_effect,is_guarding);
}

function take_damage(_attacker,_amount,_kill) {
	var dmg = round(_amount);
	
	var _defender = id;
	
	var _true_attacker = get_true_owner(_attacker);
	if !instance_exists(_true_attacker) {
		_true_attacker = noone;
		//dmg *= 1/4;
		//_kill = false;
	}
	
	with(_true_attacker) {
		dmg *= attack_power;
		dmg *= 1 + ((level - 1) * level_scaling);
		
		//if (!special_active)
		//and (!super_active)
		//and (!ultimate_active) {
		//	dmg /= attack_hits < 2 ? 1 : 3;
		//}
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
	
	//dmg *= ((80/1000) / (2500 / base_max_hp));
	
	dmg = max(round(dmg),1);
	
	if (hp > 0) {
		hp = approach(hp,!_kill,dmg);
	}
	
	return dmg;
}

function get_damage_scaling(_defender) {
	with(_defender) {
		//var _scaling = map_value(
		//	combo_hits_taken,
		//	0,
		//	50,
		//	1,
		//	0
		//);
		var _scaling = combo_damage_scaling;
		_scaling = clamp(_scaling,0.1,1);
		return _scaling;
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
	if combo_hits_taken > 0 {
		show_debug_message("combo hits: " + string(combo_hits_taken));
		show_debug_message("combo damage: " + string(combo_damage_taken));
	}
	combo_hits = 0;
	combo_damage = 0;
	combo_hits_taken = 0;
	combo_damage_taken = 0;
	combo_damage_scaling = 1;
	
	ds_list_clear(combo_moves);
}

function reset_combo_counter() {
	combo_hits_visible = 0;
	combo_damage_visible = 0;
	combo_hits_counter = 0;
	combo_damage_counter = 0;
}

function init_clash(_hitbox1, _hitbox2) {
	var _char1 = _hitbox1.owner;
	var _char2 = _hitbox2.owner;
	
	with(_char1) {
		attack_hits++;
	}
	with(_char2) {
		attack_hits++;
	}
	
	create_particles(
		mean(
			_hitbox1.bbox_left,
			_hitbox1.bbox_right,
			_hitbox2.bbox_left,
			_hitbox2.bbox_right
		),
		mean(
			_hitbox1.bbox_top,
			_hitbox1.bbox_bottom,
			_hitbox2.bbox_top,
			_hitbox2.bbox_bottom
		),
		parry_spark
	);
}