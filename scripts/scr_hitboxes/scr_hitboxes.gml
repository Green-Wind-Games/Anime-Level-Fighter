// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function create_hurtbox(_xoffset, _yoffset, _width, _height) {
	var _hurtbox = instance_create(x,y,obj_hurtbox);
	with(_hurtbox) {
		owner = other;
		xoffset = _xoffset;
		yoffset = _yoffset;
		width = _width;
		height = _height;
		image_xscale = width / sprite_get_width(spr_hurtbox);
		image_yscale = height / sprite_get_width(spr_hurtbox);
	}
	return _hurtbox;
}

function create_hitbox(_xoffset,_yoffset,_width,_height,_damage,_xknockback,_yknockback,_attacktype,_strength,_hiteffect) {
	var _hitbox = instance_create(x,y,obj_hitbox);
	with(_hitbox) {
		owner = other;
		xoffset = _xoffset;
		yoffset = _yoffset;
		width = _width;
		height = _height;
		image_xscale = width / sprite_get_width(spr_hurtbox);
		image_yscale = height / sprite_get_width(spr_hurtbox);
		damage = _damage;
		xknockback = _xknockback;
		yknockback = _yknockback;
		attack_type = _attacktype;
		attack_strength = _strength;
		hit_effect = _hiteffect;
		hitstun = get_attack_hitstun(_strength);
		blockstun = get_attack_blockstun(_strength);
		hitstop = get_attack_hitstop(_strength);
		my_state = owner.active_state;
		duration = owner.frame_duration;
	}
	return _hitbox;
}

function hitbox_check_hit() {
	var a = id;
	var a2 = owner;
	with(obj_hitbox) {
		var b = id;
		var b2 = owner;
		
		if a2.team == b2.team continue;
		if ds_list_find_index(a.hit_list,b2) != -1 continue;
		if !place_meeting(x,y,a) continue;
		
		if is_char(a2) and is_char(b2) {
			init_clash(a,b);
			ds_list_add(a.hit_list,b2);
			ds_list_add(b.hit_list,a2);
		}
		else if is_shot(a2) and is_shot(b2) {
			with(a2) {
				hit_script(b2);
				if b2.width >= a2.width {
					hit_count++;
				}
			}
			with(b2) {
				hit_script(a2);
				if a2.width >= b2.width {
					hit_count++;
				}
			}
		}
	}
	with(obj_hurtbox) {
		var b = id;
		var b2 = owner;
		
		if a2.team == b2.team continue;
		if ds_list_find_index(a.hit_list,b2) != -1 continue;
		if b2.grabbed continue;
		if (b2.active_state == b2.liedown_state) {
			if (a.attack_type != attacktype.otg) {
				continue;
			}
		}
		if !place_meeting(x,y,a) continue;
		var _break = false;
		
		with(get_true_owner(a)) {
			var _reps = 0;
			for(var i = 0; i < ds_list_size(combo_moves); i++) {
				if ds_list_find_value(combo_moves,i) == a.my_state {
					_reps++;
				}
			}
			if _reps >= 2 {
				if attack_hits < 1 {
					_break = true;
				}
			}
		}
		if _break {
			continue;
		}
		
		if is_char(b2) {
			if check_substitution(b2,2) {
				with(b2) {
					spend_tp(2);
					change_state(substitution_state);
					hitstop = 0;
				}
				continue;
			}
		}
		
		if is_shot(a2) {
			if b2.dodging_projectiles {
				with(a2.owner) {
					attack_dodge_script(b2);
				}
				with(b2) {
					defense_dodge_script(a2);
				}
				continue;
			}
			if b2.deflecting_projectiles {
				if !is_beam(a2) {
					var _speed = abs(a2.xspeed) + abs(a2.yspeed) * 2;
					var _dir = 90 - (45 * b2.facing);
					a2.xspeed = lengthdir_x(_speed * b2.facing,_dir);
					a2.yspeed = lengthdir_y(_speed,_dir);
					a2.homing = false;
					a2.ygravity_mod = 2;
				}
				with(a2.owner) {
					attack_parry_script(b2);
				}
				with(b2) {
					defense_parry_script(a2);
				}
				create_particles(a2.x,a2.y,parry_spark);
				continue;
			}
		}
		else {
			if b2.dodging_attacks {
				with(a2) {
					attack_dodge_script(b2);
				}
				with(b2) {
					defense_dodge_script(a2);
				}
				continue;
			}
			if b2.deflecting_attacks {
				a2.xspeed = 12 * b2.facing;
				//a2.yspeed = b2.yspeed;
				with(a2) {
					attack_parry_script(b2);
				}
				with(b2) {
					defense_parry_script(a2);
				}
				create_particles(a2.x,a2.y,parry_spark);
				continue;
			}
		}
		
		with(b2) {
			connect_attack(a,b);
		}
		with(a2) {
			if is_shot(id) {
				hit_script(b2);
				hit_count++;
			}
		}
		ds_list_add(a.hit_list,b2);
	}
}