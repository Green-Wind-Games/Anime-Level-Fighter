// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function init_grab(_attacker, _target) {
	with(_attacker) {
		if grabbed return false;
	}
	with(_target) {
		if grabbed return false;
		if is_blocking {
			return false;
		}
		if !can_block {
			return false;
		}
	}
	if _attacker.on_ground != _target.on_ground return false;
	
	_attacker.grabbed = _target;
	_target.grabbed = _attacker;
	with(_target) {
		change_state(grabbed_state);
	}
	with(_attacker) {
		change_state(grab_connect_state);
	}
	play_sound(snd_grab);
	return true;
}

function grab_frame(_frame, _x, _y, _rotation, _back) {
	if frame >= _frame {
		with(grabbed) {
			facing = -other.facing;
			if _back {
				facing = -facing;
			}
			x = other.x + (_x * other.facing);
			y = other.y + _y;
			rotation = _rotation;
		}
	}
}

function release_grab(_frame,_x,_y,_xspeed,_yspeed,_damage,_attacktype,_strength,_hiteffect,_hitanim) {
	if frame >= _frame {
		with(grabbed) {
			grabbed = noone;
			other.x -= other.facing;
			x = other.x + (_x * other.facing);
			y = other.y + _y;
			get_hit(other,_damage,_xspeed,_yspeed,_attacktype,_strength,_hiteffect,_hitanim);
		}
		grabbed = noone;
	}
}