function basic_attack(_hitframe,_damage,_strength,_hiteffect) {
	if check_frame(max(_hitframe-1,1)) {
		if is_airborne {
			if target_distance <= 30 {
				xspeed = 3 * facing;
				yspeed = -1.8;
			}
		}
		else {
			xspeed = 3 * facing;
		}
	}
	if check_frame(_hitframe) {
		var _w = sprite_get_bbox_right(sprite) - sprite_get_xoffset(sprite);
		var _h = sprite_get_height(sprite) * 0.69;
		var _x = 2;
		var _y = -_h;
		create_hitbox(_x,_y,_w,_h,_damage,3,0,attacktype.normal,_strength,_hiteffect);
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
		create_hitbox(_x,_y,_w,_h,_damage,3,-10,attacktype.normal,attackstrength.heavy,_hiteffect);
	}
	if anim_finished {
		if combo_hits > 0 {
			change_state(homing_dash_state);
		}
		else {
			land();
		}
	}
}

function basic_smash(_hitframe,_damage,_hiteffect) {
	if check_frame(max(_hitframe-1,1)) {
		if target_distance <= 30 {
			xspeed = 3 * facing;
			yspeed = -2;
		}
	}
	if check_frame(_hitframe) {
		var _w = sprite_get_bbox_right(sprite) - sprite_get_xoffset(sprite);
		var _h = sprite_get_height(sprite) / 2;
		var _x = 2;
		var _y = -_h * 0.69;
		create_hitbox(_x,_y,_w,_h,_damage,3,10,attacktype.hard_knockdown,attackstrength.heavy,_hiteffect);
		
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
		if owner.object_index == obj_shot or object_is_ancestor(owner.object_index,obj_shot) {
			owner = me.owner;
		}
		init_sprite(_sprite);
		change_sprite(sprite,3,true);
		xscale = _scale;
		yscale = _scale;
		width = min(sprite_get_width(sprite),sprite_get_height(sprite)) * _scale * 0.5;
		height = width;
		width_half = floor(width / 2);
		height_half = floor(height / 2);
		hitbox = create_hitbox(-width/2,-height/2,width,height,_damage,_xknockback,_yknockback,_attacktype,_strength,_hiteffect);
		hitbox.duration = -1;
		xspeed = _xspeed * owner.facing;
		yspeed = _yspeed;
		team = owner.team;
		facing = owner.facing;
		target = owner.target;
		
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
			_xlength * 10,
			_ylength * 10,
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
				with(_hit) {
					if object_is_ancestor(_hit.object_index,obj_char) {
						if (!on_ground) or (other.yspeed <= 0) {
							x += other.xspeed*4;
							y += other.yspeed*4;
						}
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
			xknockback = _xlength * 10;
			yknockback = _ylength * 10;
			if yknockback == 0 then yknockback -= 2;
		}
	}
}

function check_charge() {
	//if mp >= max_mp return false;
	if (previous_state == charge_state) and (state_timer < 30) return false;
	if !ai_enabled {
		if (input.button5_held >= 10) return true;
	}
	else {
		if target_distance_x < 100 return false;
		if active_state == charge_state return true;
		if random(100) < 5 return true;
	}
	return false;
}

function check_substitution(_defender,_cost = 1) {
	with(_defender) {
		if check_input("F") {
			if check_tp(_cost) {
				spend_tp(_cost);
				change_state(substitution_state);
				hitstop = 0;
				return true;
			}
		}
	}
	return false;
}