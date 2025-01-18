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
			5,
			-12,
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
		var _y = -_h * 0.75;
		create_hitbox(
			_x,
			_y,
			max(_w,45),
			_h,
			_damage,
			5,
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
	basic_attack(_hitframe,200,attackstrength.light,_hiteffect);
	return_to_idle();
}

function basic_medium_attack(_hitframe,_hiteffect) {
	basic_attack_stepforward(_hitframe);
	basic_attack(_hitframe,300,attackstrength.medium,_hiteffect);
	return_to_idle();
}

function basic_heavy_attack(_hitframe,_hiteffect) {
	basic_attack_stepforward(_hitframe);
	basic_wallsplat(_hitframe,500,_hiteffect);
	if check_frame(min(anim_frames-1,_hitframe+2)) {
		if (attack_hits > 0)
		and (!input.back) {
			change_state(homing_dash_state);
		}
	}
	return_to_idle();
}

function basic_light_lowattack(_hitframe,_hiteffect) {
	basic_attack_stepforward(_hitframe);
	basic_attack(_hitframe,200,attackstrength.light,_hiteffect);
	return_to_idle();
}

function basic_medium_lowattack(_hitframe,_hiteffect) {
	if check_frame(max(_hitframe-1,1)) {
		xspeed = 8 * facing;
	}
	basic_sweep(_hitframe,300,attackstrength.medium,_hiteffect);
	return_to_idle();
}

function basic_heavy_lowattack(_hitframe,_hiteffect) {
	if check_frame(max(_hitframe-1,1)) {
		xspeed = 2 * facing;
		yspeed = -2;
	}
	basic_launcher(_hitframe,500,_hiteffect);
	if check_frame(min(anim_frames-1,_hitframe+2)) {
		if (attack_hits > 0) and (!input.back) {
			change_state(homing_dash_state);
		}
	}
	return_to_idle();
}

function basic_light_airattack(_hitframe,_hiteffect) {
	basic_attack_stepforward(_hitframe);
	basic_attack(_hitframe,200,attackstrength.light,_hiteffect);
	return_to_idle();
}

function basic_medium_airattack(_hitframe,_hiteffect) {
	basic_attack_stepforward(_hitframe);
	basic_attack(_hitframe,300,attackstrength.medium,_hiteffect);
	return_to_idle();
}

function basic_heavy_airattack(_hitframe,_hiteffect) {
	basic_attack_stepforward(_hitframe);
	basic_smash(_hitframe,500,_hiteffect);
	if check_frame(_hitframe+1) {
		xspeed = -3 * facing;
		yspeed = -3;
	}
	return_to_idle();
}

function basic_attack_stepforward(_hitframe) {
	if check_frame(max(_hitframe-2,1)) {
		if target_distance <= 50 {
			xspeed = max(5,abs(x-target_x) / 4) * facing;
			if is_airborne {
				yspeed = min(-1.8,(target_y-y) / 6);
			}
		}
		else {
			if on_ground {
				xspeed = 5 * facing;
			}
		}
	}
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