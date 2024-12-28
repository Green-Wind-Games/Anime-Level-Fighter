function basic_attack(_hitframe,_damage,_strength,_hiteffect) {
	if check_frame(_hitframe) {
		var _w = sprite_get_bbox_right(sprite) - sprite_get_xoffset(sprite);
		var _h = sprite_get_height(sprite) * 0.69;
		var _x = 2;
		var _y = -_h;
		create_hitbox(
			_x,
			_y,
			_w,
			_h,
			_damage,
			3,
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
		var _h = sprite_get_height(sprite) * 0.25;
		var _x = 2;
		var _y = -_h;
		create_hitbox(
			_x,
			_y,
			_w,
			_h,
			_damage,
			1,
			-2,
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
		var _h = sprite_get_height(sprite);
		var _x = 2;
		var _y = -_h;
		create_hitbox(
			_x,
			_y,
			_w,
			_h,
			_damage,
			10,
			-5,
			attacktype.wall_splat,
			attackstrength.super,
			_hiteffect
		);
	}
	can_cancel = false;
}

function basic_launcher(_hitframe,_damage,_hiteffect) {
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
			2,
			-10,
			attacktype.antiair,
			attackstrength.super,
			_hiteffect
		);
	}
	can_cancel = false;
}

function basic_smash(_hitframe,_damage,_hiteffect) {
	if check_frame(_hitframe) {
		var _w = sprite_get_bbox_right(sprite) - sprite_get_xoffset(sprite);
		var _h = sprite_get_height(sprite);
		var _x = 2;
		var _y = -_h * 0.69;
		create_hitbox(
			_x,
			_y,
			max(_w,45),
			_h,
			_damage,
			3,
			15,
			attacktype.hard_knockdown,
			attackstrength.super,
			_hiteffect
		);
	}
	return_to_idle();
}

function basic_light_attack(_hitframe,_hiteffect) {
	basic_attack_stepforward(_hitframe);
	basic_attack(_hitframe,400,attackstrength.light,_hiteffect);
	return_to_idle();
}

function basic_medium_attack(_hitframe,_hiteffect) {
	basic_attack_stepforward(_hitframe);
	basic_attack(_hitframe,700,attackstrength.medium,_hiteffect);
	return_to_idle();
}

function basic_heavy_attack(_hitframe,_hiteffect) {
	basic_attack_stepforward(_hitframe);
	basic_wallsplat(_hitframe,1000,_hiteffect);
	if frame >= min(anim_frames-1,_hitframe+2) {
		if combo_timer > 10 {
			xspeed = 30 * facing;
			yspeed = -5;
			if on_ground {
				create_specialeffect(spr_dust_dash,x,y,facing * 0.5,0.5);
				play_sound(snd_jump);
			}
			else {
				play_sound(snd_airjump);
			}
			play_sound(snd_dash);
			change_state(air_state);
		}
		else {
			return_to_idle();
		}
	}
	return_to_idle();
}

function basic_light_lowattack(_hitframe,_hiteffect) {
	basic_attack_stepforward(_hitframe);
	basic_attack(_hitframe,100,attackstrength.light,_hiteffect);
	return_to_idle();
}

function basic_medium_lowattack(_hitframe,_hiteffect) {
	if check_frame(max(_hitframe-1,1)) {
		xspeed = 8 * facing;
	}
	basic_sweep(_hitframe,200,attackstrength.medium,_hiteffect);
	return_to_idle();
}

function basic_heavy_lowattack(_hitframe,_hiteffect) {
	if check_frame(max(_hitframe-1,1)) {
		xspeed = 5 * facing;
		yspeed = -5;
	}
	basic_launcher(_hitframe,360,_hiteffect);
	if frame >= min(anim_frames-1,_hitframe+2) {
		if combo_timer > 20 {
			xspeed = 5 * facing;
			yspeed = -10;
			create_specialeffect(spr_dust_dash,x,y,facing * 0.5,0.5);
			play_sound(snd_jump);
			play_sound(snd_dash);
			change_state(air_state);
		}
		else {
			return_to_idle();
		}
	}
}

function basic_light_airattack(_hitframe,_hiteffect) {
	basic_attack_stepforward(_hitframe);
	basic_attack(_hitframe,160,attackstrength.light,_hiteffect);
	return_to_idle();
}

function basic_medium_airattack(_hitframe,_hiteffect) {
	basic_attack_stepforward(_hitframe);
	basic_attack(_hitframe,240,attackstrength.medium,_hiteffect);
	return_to_idle();
}

function basic_heavy_airattack(_hitframe,_hiteffect) {
	basic_attack_stepforward(_hitframe);
	basic_smash(_hitframe,420,_hiteffect);
	if check_frame(_hitframe+1) {
		xspeed = -3 * facing;
		yspeed = -3;
	}
	return_to_idle();
}

function basic_attack_stepforward(_hitframe) {
	if check_frame(max(_hitframe-1,1)) {
		if target_distance <= 50 {
			xspeed = max(5,(target_distance_x / 4)) * facing;
			if is_airborne {
				yspeed = min(-1.8,(target_y-y) / 8);
			}
		}
		else {
			if on_ground {
				xspeed = 5 * facing;
			}
		}
	}
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
		var _true_scale = _scale / 3;
		xscale = _scale;
		yscale = _scale;
		width = sprite_get_width(sprite) * _true_scale;
		height = sprite_get_height(sprite) * _true_scale;
		width_half = floor(width / 2);
		height_half = floor(height / 2);
		
		var _xoffset = -sprite_get_xoffset(sprite) * _true_scale;
		var _yoffset = -sprite_get_yoffset(sprite) * _true_scale;
		
		hitbox = create_hitbox(
			_xoffset,
			_yoffset,
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

function basic_light_shot(_x,_y,_xspeed,_yspeed,_sprite,_scale,_hiteffect) {
	var shot = create_shot(
		_x,
		_y,
		_xspeed,
		_yspeed,
		_sprite,
		_scale,
		100,
		3,
		0,
		attacktype.normal,
		attackstrength.light,
		_hiteffect
	);
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
			_xlength * 10,
			_ylength * 10,
			attacktype.hard_knockdown,
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
				xoffset = 0;
				
				var hitbox_scale = 1/3;
				
				image_yscale = (sprite_get_height(other.sprite) / sprite_get_height(spr_hitbox));
				image_yscale *= hitbox_scale * _scale;
				yoffset = -(image_yscale * sprite_get_height(spr_hitbox)) / 2;
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
						hitstop = 1;
						x = clamp(x+other.xspeed,left_wall,right_wall);
						y = min(y+other.yspeed,ground_height);
					}
				}
			}
		}
	}
	with(beam) {
		ds_list_clear(hitbox.hit_list);
		alpha = 1;
		duration = 12;
		
		xspeed = _xlength * other.facing;
		yspeed = _ylength;
		affected_by_gravity = false;
		x = owner.x + (_x * other.facing);
		y = owner.y + _y;
		with(hitbox) {
			xknockback = _xlength * 10;
			yknockback = _ylength * 10;
			if yknockback == 0 then yknockback -= 2;
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