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

enum hitanims {
	normal,
	spinout,
	flipout
}

enum hiteffects {
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

function get_hit(_attacker, _damage, _xknockback, _yknockback, _attacktype, _hiteffect, _hitanim) {
	var _xspeed = xspeed;
	var _yspeed = yspeed;
	xspeed = _xknockback * _attacker.facing;
	yspeed = _yknockback;
	switch(_attacktype) {
		case attacktype.light:
		hitstun = 15;
		blockstun = 12;
		hitstop = 8;
		break;
		
		case attacktype.medium:
		case attacktype.antiair:
		case attacktype.unblockable:
		hitstun = 20;
		blockstun = 18;
		hitstop = 10;
		break;
		
		case attacktype.heavy:
		case attacktype.hard_knockdown:
		hitstun = 25;
		blockstun = 20;
		hitstop = 12;
		break
		
		case attacktype.ground_bounce:
		case attacktype.launcher:
		case attacktype.slide_knockdown:
		case attacktype.smash:
		case attacktype.wall_bounce:
		case attacktype.wall_splat:
		hitstun = 60;
		blockstun = 20;
		hitstop = 20;
		break;
		
		case attacktype.beam:
		hitstun = 60;
		blockstun = 20;
		hitstop = 0;
		xspeed = abs(_attacker.xspeed);
		yspeed = _attacker.yspeed - 3;
		break;
	}
			
	var blocking =	((input_back or input_down)
					or ((ai_enabled) and (irandom(100) <= map_value(ai_level,1,ai_level_max,10,90)))
					or (is_blocking));
	var block_valid = (can_block) and (!is_hit);
	if _attacktype == attacktype.unblockable
	or _attacktype == attacktype.grab {
		block_valid = false;
	}
	if _attacktype == attacktype.antiair
	and is_airborne {
		block_valid = false;
	}
	if block_valid and blocking {
		change_state(block_state);
		change_sprite(guard_sprite,6,false);
		xspeed *= 2;
		//yspeed /= 2;
		yspeed = _yspeed;
		if on_ground {
			yspeed = 0;
		}
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
				case attacktype.wall_splat:
				case attacktype.smash:
				change_state(hard_knockdown_state);
				break;
									
				case attacktype.slide_knockdown:
				change_state(slide_knockdown_state);
				break;
									
				case attacktype.grab:
				case attacktype.hit_grab:
				with(_attacker) {
					init_grab(id,other);
				}
				break;
			}
			change_sprite(hurt_sprite,3,false);
			if _hitanim == hitanims.spinout {
				change_sprite(spinout_sprite,3,true);
				yoffset = -height_half;
			}
			else if (abs(xspeed) >= 10) or (abs(yspeed) >= 10) {
				change_sprite(launch_sprite,3,true);
				yoffset = -height_half;
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
			
			if _attacker.object_index == obj_shot or object_is_ancestor(_attacker.object_index,obj_shot) {
				with(_attacker.owner) {
					combo_hits++;
					combo_damage += dmg;
				}
			}
			else {
				with(_attacker) {
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
	//if block_valid {
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
	
	depth = 0;
	_attacker.depth = -1;
	_attacker.hitstop = hitstop;
	_attacker.can_cancel = true;
	create_hitspark(x-width_half,y-(height*0.75),x+width_half,y-(height*0.25),_attacktype,_hiteffect,block_valid && blocking);
}

function take_damage(_attacker,_amount,_kill) {
	var dmg = round(_amount);
	
	var true_attacker = _attacker;
	if !object_is_ancestor(_attacker.object_index,obj_char) {
		true_attacker = _attacker.owner;
	}
	var defender = id;
	
	dmg *= true_attacker.attack_power;
	
	dmg /= defender.defense;
	
	var scaling = map_value(hp + combo_damage_taken,max_hp,0,1,0);
	scaling = clamp(scaling,0.1,1);
	dmg *= scaling;
	
	dmg *= true_attacker.level * level_scaling;
	
	dmg = max(ceil(dmg),1);
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