// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function create_hurtbox(_xoffset, _yoffset, _width, _height) {
	var _hurtbox = instance_create(x,y,obj_hurtbox);
	with(_hurtbox) {
		owner = other;
		xoffset = _xoffset;
		yoffset = _yoffset;
		image_xscale = _width / sprite_get_width(spr_hitbox);
		image_yscale = _height / sprite_get_width(spr_hitbox);
	}
	return _hurtbox;
}

function create_hitbox(_xoffset,_yoffset,_width,_height,_damage,_xknockback,_yknockback,_attacktype,_strength,_hiteffect) {
	var _hitbox = instance_create(x,y,obj_hitbox);
	with(_hitbox) {
		owner = other;
		xoffset = _xoffset;
		yoffset = _yoffset;
		image_xscale = _width / sprite_get_width(spr_hurtbox);
		image_yscale = _height / sprite_get_width(spr_hurtbox);
		damage = _damage;
		xknockback = _xknockback;
		yknockback = _yknockback;
		attack_type = _attacktype;
		attack_strength = _strength;
		hit_effect = _hiteffect;
		my_state = owner.active_state;
		duration = owner.frame_duration;
	}
	return _hitbox;
}

function check_hit() {
	var a = id;
	var a2 = owner;
	with(obj_hitbox) {
		var b = id;
		var b2 = owner;
		
		if a2.team == b2.team continue;
		if ds_list_find_index(a.hit_list,b2) != -1 continue;
		if !place_meeting(x,y,a) continue;
		
		if is_char(a2) and is_char(b2) {
			init_clash(a2,b2);
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
		if !place_meeting(x,y,a) continue;
		
		if is_shot(a2) {
			if b2.dodging_projectiles {
				continue;
			}
			if b2.deflecting_projectiles {
				if !is_beam(b2) {
					var _speed = abs(a2.xspeed) + abs(a2.yspeed) * 2;
					var _dir = choose(45,135,225,315);
					a2.xspeed = lengthdir_x(_speed * b2.facing,_dir);
					a2.yspeed = lengthdir_y(_speed,_dir);
					a2.homing = false;
					a2.affected_by_gravity = 10;
				}
				create_particles(a2.x,a2.y,a2.x,a2.y,deflect_spark);
				continue;
			}
		}
		else {
			if b2.dodging_attacks {
				continue;
			}
			if b2.deflecting_attacks {
				a2.xspeed = 12 * b2.facing;
				//a2.yspeed = b2.yspeed;
				create_particles(a2.x,a2.y,a2.x,a2.y,deflect_spark);
				continue;
			}
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
		
		with(b2) {
			get_hit(a2,a.damage,a.xknockback,a.yknockback,a.attack_type,a.attack_strength,a.hit_effect);
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