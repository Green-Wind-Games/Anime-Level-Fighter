function basic_attack(_hitframe,_damage,_strength,_hiteffect) {
	if state_timer == 1 {
		if is_airborne {
			if target_distance <= 30 {
				xspeed = 3 * facing;
				yspeed = -2.64;
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
	if state_timer == max(1,(_hitframe-1)*frame_duration) {
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
	if state_timer == 1 {
		if target_distance <= 30 {
			xspeed = 3 * facing;
			yspeed = -2.69;
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