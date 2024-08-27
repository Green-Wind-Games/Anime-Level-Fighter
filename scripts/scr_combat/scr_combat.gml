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
	
	wind,
	ice,
	water,
	
	dark,
	light,
}

function get_hit(_attacker, _damage, _xknockback, _yknockback, _attacktype, _strength, _hiteffect) {
	var _xspeed = xspeed;
	var _yspeed = yspeed;
	xspeed = _xknockback * _attacker.facing;
	yspeed = _yknockback;
	
	hitstun = map_value(_strength,attackstrength.light,attackstrength.heavy,15,20);
	blockstun = hitstun - 5;
	hitstop = map_value(_strength,attackstrength.light,attackstrength.heavy,10,15);
	
	if object_is_ancestor(_attacker.object_index,obj_shot) {
		hitstop *= 0.5;
		target = _attacker.owner;
	}
	else {
		var _recovery = _attacker.anim_duration - _attacker.anim_timer;
		hitstun = max(hitstun,_recovery);
		blockstun = _recovery - 10;
		target = _attacker;
	}
	
	hitstun = max(hitstun - (combo_hits_taken / 3), 1);
		
	if abs(_xknockback) >= 10
	or abs(_yknockback) >= 10 {
		hitstun = max(hitstun,40);
	}
	
	hitstun = round(hitstun);
	blockstun = round(blockstun);
	hitstop = round(hitstop);
			
	var guarding =	((input.back or input.down)
					or ((ai_enabled) and (random(100) < map_value(ai_level,1,ai_level_max,10,90)))
					or (is_guarding));
	var guard_valid = (can_guard) and (!is_hit);
	if _attacktype == attacktype.unblockable
	or _attacktype == attacktype.grab {
		guard_valid = false;
	}
	if _attacktype == attacktype.antiair
	and is_airborne {
		guard_valid = false;
	}
	if guard_valid and guarding {
		change_state(guard_state);
		change_sprite(guard_sprite,6,false);
		xspeed *= 2;
		//yspeed /= 2;
		yspeed = _yspeed;
		if on_ground {
			yspeed = 0;
		}
		take_damage(_attacker,_damage/10,false);
	}
	else {
		var connect = true;
		if invincible {
			connect = false;
		}
		if _attacker.object_index == obj_shot or object_is_ancestor(_attacker.object_index,obj_shot) {
			if immune_to_projectiles {
				connect = false;
			}
		}
		if connect {
			switch(_attacktype) {
				default:
				change_state(hit_state);
				if on_ground and _yknockback >= 0 {
					yspeed = 0;
				}
				else if is_airborne and _yknockback == 0 {
					yspeed = -abs(xspeed) / 2;
				}
				break;
									
				case attacktype.wall_bounce:
				if previous_state != wall_bounce_state {
					change_state(wall_bounce_state);
				}
				else {
					change_state(hit_state);
				}
				break;
									
				case attacktype.hard_knockdown:
				change_state(hard_knockdown_state);
				break;
									
				case attacktype.slide_knockdown:
				change_state(slide_knockdown_state);
				break;
									
				case attacktype.grab:
				with(_attacker) {
					init_grab(id,other);
				}
				break;
			}
			
			change_sprite(choose(hit_high_sprite,hit_low_sprite),3,false);
			if is_airborne {
				change_sprite(hit_air_sprite,frame_duration,false);
			}
			if (abs(xspeed) >= 10) or (abs(yspeed) >= 10) {
				change_sprite(launch_sprite,frame_duration,true);
			}
			if yspeed <= -10 {
				change_sprite(spinout_sprite,frame_duration,true);
			}
			
			if on_wall and on_ground {
				if object_is_ancestor(_attacker.object_index,obj_char) {
					_attacker.xspeed = xspeed * -0.5;
				}
			}
			
			var _hp = hp;
			var dmg = take_damage(_attacker,_damage,!grabbed);
			
			combo_hits_taken++;
			combo_damage_taken += dmg;
			
			combo_timer = hitstun + 10;
			
			if object_is_ancestor(_attacker.object_index,obj_char) {
				with(_attacker) {
					combo_timer = other.combo_timer;
					combo_hits++;
					combo_damage += dmg;
				}
			}
			else {
				with(_attacker.owner) {
					combo_timer = other.combo_timer;
					combo_hits++;
					combo_damage += dmg;
				}
			}
			
			if (_hp > 0) {
				if (hp > 0) {
					var _heavyattack_speed = 10;
					var is_heavyattack = ((abs(xspeed) >= _heavyattack_speed) or (abs(yspeed) >= _heavyattack_speed));
					if on_ground and (yspeed > -_heavyattack_speed) {
						is_heavyattack = false;
					}
					if is_heavyattack {
						play_voiceline(voice_hurt_heavy,50,true);
					}
					else {
						play_voiceline(voice_hurt,50,true);
					}
				}
				else {
					play_voiceline(voice_dead,100,true);
				}
			}
			
			frame = 0;
			frame_timer = 0;
			facing = -_attacker.facing;
		}
		else {
			xspeed = _xspeed;
			yspeed = _yspeed;
		}
	}
	var mp_gain = _damage;
	var attack_mp_multiplier = 3;
	var defend_mp_multiplier = 2;
	//if guard_valid {
	//	mp_gain *= 0.5;
	//}
	mp += mp_gain * defend_mp_multiplier;
	if _attacker.object_index == obj_shot or object_is_ancestor(_attacker.object_index,obj_shot) {
		with(_attacker.owner) {
			if !super_active {
				mp += mp_gain * attack_mp_multiplier;
			}
		}
	}
	else {
		with(_attacker) {
			if !super_active {
				mp += mp_gain * attack_mp_multiplier;
			}
		}
	}
	
	super_active = false;
	
	depth = 0;
	_attacker.depth = -1;
	_attacker.hitstop = hitstop;
	_attacker.can_cancel = true;
	create_hitspark(x-width_half,y-(height*0.75),x+width_half,y-(height*0.25),_strength,_hiteffect,guard_valid and guarding);
	apply_hiteffect(_hiteffect,_strength,guard_valid and guarding);
}

function take_damage(_attacker,_amount,_kill) {
	var dmg = round(_amount);
	
	var true_attacker = _attacker;
	if !object_is_ancestor(_attacker.object_index,obj_char) {
		true_attacker = _attacker.owner;
	}
	var defender = id;
	
	var scaling = map_value(
		combo_hits_taken,
		0,
		30,
		1,
		0
	);
	scaling = clamp(scaling,0.1,1);
	
	var guts = map_value(
		hp + combo_damage_taken,
		max_hp*0.5,
		0,
		1,
		0
	);
	guts = clamp(guts,0.1,1);
	
	dmg *= scaling;
	dmg *= guts;
	
	dmg *= true_attacker.attack_power;
	dmg /= defender.defense;
	
	dmg *= true_attacker.level;
	
	with(true_attacker) {
		for(var i = 0; i < array_length(autocombo); i++) {
			if active_state == autocombo[i] {
				dmg /= 4;
				break;
			}
		}
	}
	
	dmg = max(round(dmg),1);
	
	hp -= dmg;
	if !_kill {
		hp = max(hp,1);
	}
	return dmg;
}

function reset_combo() {
	combo_hits = 0;
	combo_damage = 0;
	combo_hits_taken = 0;
	combo_damage_taken = 0;
}

function init_clash(_char1, _char2) {
	
}