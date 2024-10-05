function basic_attack(_hitframe,_damage,_strength,_hiteffect) {
	if check_frame(max(_hitframe-1,1)) {
		if is_airborne {
			if (target_distance <= 50) {
				xspeed = max(4,(target_distance_x / 5)) * facing;
				yspeed = min(-1.75,(target_y-y) / 4);
			}
		}
		else {
			if (target_distance <= 50) {
				xspeed = max(4,(target_distance_x / 5)) * facing;
			}
			else {
				xspeed = 3 * facing;
			}
		}
	}
	if check_frame(_hitframe) {
		var _w = sprite_get_bbox_right(sprite) - sprite_get_xoffset(sprite);
		var _h = sprite_get_height(sprite) * 0.69;
		var _x = 2;
		var _y = -_h;
		create_hitbox(_x,_y,_w,_h,_damage,4,0,attacktype.normal,_strength,_hiteffect);
	}
	if frame < _hitframe {
		can_cancel = false;
	}
}

function basic_launcher(_hitframe,_damage,_hiteffect) {
	if check_frame(max(_hitframe-1,1)) {
		xspeed = 3 * facing;
		yspeed = -5;
	}
	if check_frame(_hitframe) {
		var _w = sprite_get_bbox_right(sprite) - sprite_get_xoffset(sprite);
		var _h = sprite_get_height(sprite);
		var _x = 2;
		var _y = -_h;
		create_hitbox(_x,_y,_w,_h,_damage,2,-10,attacktype.normal,attackstrength.super,_hiteffect);
	}
	if anim_finished {
		if target.is_hit {
			change_state(homing_dash_state);
		}
		else {
			land();
		}
	}
	can_cancel = false;
}

function basic_smash(_hitframe,_damage,_hiteffect) {
	if check_frame(max(_hitframe-1,1)) {
		if target_distance <= 50 {
			xspeed = max(5,(target_distance_x / 5)) * facing;
			yspeed = min(-2,(target_y-y) / 4);
		}
	}
	if check_frame(_hitframe) {
		var _w = sprite_get_bbox_right(sprite) - sprite_get_xoffset(sprite);
		var _h = sprite_get_height(sprite) / 2;
		var _x = 2;
		var _y = -_h * 0.69;
		create_hitbox(_x,_y,_w,_h,_damage,3,15,attacktype.hard_knockdown,attackstrength.super,_hiteffect);
		
		xspeed = -3 * facing;
		yspeed = -3;
	}
	land();
}

function air_chase() {
	var _factor = 0.2;
	xspeed = (target_x-x) * _factor;
	yspeed = min(-2.25,(target_y-y) * _factor);
	//xspeed += target.xspeed;
	//yspeed += target.yspeed;
	//xspeed = 3 * facing;
	//yspeed = -2.5;
}

function create_shot(_x,_y,_xspeed,_yspeed,_sprite,_scale,_damage,_xknockback,_yknockback,_attacktype,_strength,_hiteffect) {
	var me = id;
	var shot = instance_create(x+(_x*facing),y+_y,obj_shot);
	with(shot) {
		owner = me;
		if (!is_char(owner)) and (!is_helper(owner)) {
			owner = owner.owner;
		}
		init_sprite(_sprite);
		change_sprite(sprite,max(1,round(60/sprite_get_speed(_sprite))),true);
		xscale = _scale;
		yscale = _scale;
		width = min(sprite_get_width(sprite),sprite_get_height(sprite)) * _scale * 0.5;
		height = width;
		width_half = floor(width / 2);
		height_half = floor(height / 2);
		
		var _offset = min(sprite_get_xoffset(sprite),sprite_get_yoffset(sprite)) * (_scale / 2);
		
		hitbox = create_hitbox(
			-_offset,
			-_offset,
			width,
			height,
			_damage,
			_xknockback,
			_yknockback,
			_attacktype,
			_strength,
			_hiteffect
		);
		hitbox.duration = -1;
		attack_power = owner.attack_power;
		
		xspeed = _xspeed * owner.facing;
		yspeed = _yspeed;
		team = owner.team;
		facing = owner.facing;
		target = owner.target;
		
		homing_speed = max(abs(xspeed),abs(yspeed));
		
		rotation = point_direction(0,0,xspeed,yspeed);

		if xspeed > 0 {
			facing = 1;
		}
		else if xspeed < 0 {
			facing = -1;
		}
	}
	return shot;
}

function fire_beam(_x,_y,_sprite,_scale,_angle,_damage) {
	var _xlength = lengthdir_x(1,_angle);
	var _ylength = lengthdir_y(1,_angle);
	if !instance_exists(beam) {
		beam = create_shot(
			_x,
			_y,
			_xlength,
			_ylength,
			_sprite,
			_scale,
			_damage,
			_xlength * 4,
			_ylength * 4,
			attacktype.normal,
			attackstrength.light,
			hiteffects.none
		);
		with(beam) {
			rotation = _angle;
			blend = true;
			hit_limit = -1;
			duration = 10;
			xscale = 100 / sprite_get_width(sprite);
			with(hitbox) {
				var hitbox_scale = 1/3;
				xoffset = 0;
				yoffset *= hitbox_scale;
				image_yscale *= hitbox_scale;
			}
			active_script = function() {
				xscale += 100 / sprite_get_width(sprite);
				alpha = duration / 10;
				with(hitbox) {
					image_angle = point_direction(0,0,abs(other.xspeed),other.yspeed);
					image_xscale = ((sprite_get_width(other.sprite) * other.xscale) / sprite_get_width(spr_hitbox)) * other.facing;
				}
			}
			hit_script = function(_hit) {
				if is_beam(_hit) {
					var _x = mean(x, _hit.x);
					var _y = mean(y, _hit.y);
					if height >= _hit.height {
						xscale = point_distance(x,y,_x,_y) / sprite_get_width(sprite);
					}
					if _hit.height >= height {
						with(_hit) {
							xscale = point_distance(x,y,_x,_y) / sprite_get_width(sprite);
						}
					}
				}
				else if is_char(_hit) or is_helper(_hit) {
					with(_hit) {
						hitstop = 0;
					}
				}
			}
		}
	}
	with(beam) {
		ds_list_clear(hitbox.hit_list);
		alpha = 1;
		duration = 10;
		
		xspeed = _xlength * other.facing;
		yspeed = _ylength;
		x = owner.x + (_x * other.facing);
		y = owner.y + _y;
		with(hitbox) {
			xknockback = _xlength * 4;
			yknockback = _ylength * 4;
			if yknockback == 0 then yknockback -= 1/3;
		}
	}
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
		if random(100) < 5 return true;
	}
	return false;
}

function check_substitution(_defender,_cost = 1) {
	with(_defender) {
		if !is_char(id) return false;
		if !check_tp(_cost) return false;
		if combo_timer > 10 return false;
		
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