function update_charphysics() {
	var _xspeed = xspeed * game_speed;
	var _yspeed = yspeed * game_speed;
	
	var _xto = clamp(x + _xspeed,left_wall,right_wall);
	var _yto = min(y + _yspeed,ground_height);
	
	var _steps = ceil(max(abs(_xspeed),abs(_yspeed),1));
	
	repeat(_steps) {
		x = approach(x,_xto,1);
		y = approach(y,_yto,1);
		
		with(target) {
			if !on_wall break;
			if (!is_hit) and (!is_guarding) break;
			if state_timer > (hitstun / 2) break;
			if hitstop break;
			if superfreeze_active break;
			if timestop_active break;
			
			var _push = xspeed * 0.25;
			with(other) {
				x -= _push;
			}
		}
		
		with(obj_char) {
			if grabbed or other.grabbed continue;
			if dead or other.dead continue;
			if team == other.team continue;
			if is_helper(id) {
				if duration != -1 continue;
			}
			if is_helper(other) {
				if other.duration != -1 continue;
			}
			
			if !rectangle_in_rectangle(
				x-width_half,
				y-height,
				x+width_half,
				y,
				other.x-other.width_half,
				other.y-other.height,
				other.x+other.width_half,
				other.y
			) continue;
			
			var _dist = abs(x-other.x);
			_dist -= width_half;
			_dist -= other.width_half;
			if _dist >= 0 continue;
	
			var pushme = true;
			var pushthem = true;
	
			if is_char(id) {
				if is_helper(other) {
					pushme = false;
					pushthem = true;
				}
			}
			else if is_helper(id) {
				if is_char(other) {
					pushme = true;
					pushthem = false;
				}
			}
	
			if !(pushme or pushthem) {
				pushme = true;
				pushthem = true;
			}
			
			var _push = -sign(x-other.x);
			//if _push == 0 then _push = sign(on_left_wall - on_right_wall) * sign(y - other.y);
			if _push == 0 then _push = facing;
			if _push == 0 then _push = 1;
			_push *= 0.5;
			
			repeat(ceil(abs(_dist))) {
				if pushme {
					x = clamp(x-_push, left_wall, right_wall);
				}
				if pushthem {
					other.x = clamp(other.x+_push, left_wall, right_wall);
				}
				_dist = point_distance(x,0,other.x,0) - (width_half + other.width_half);
			}
		}
		
		if (x == _xto) and (y == _yto) {
			break;
		}
	}
	
	update_physics(0);
}

function get_char_walk_speed(_char) {
	var _speed = 5;
	with(_char) {
		_speed = move_speed;
		_speed += ((level - 1) * 1.25);
		_speed *= move_speed_mod;
		_speed *= move_speed_buff;
	}
	return _speed;
}

function get_char_dash_speed(_char) {
	return get_char_walk_speed(_char) * 2;
}

function get_char_jump_speed(_char) {
	var _speed = 8;
	with(_char) {
		_speed = jump_speed;
		_speed *= lerp(move_speed_mod,1,0.5);
		_speed *= lerp(move_speed_buff,1,0.5)
	}
	return _speed;
}

function jump_towards_x(_x, _time) {
	var _distance_x = _x - x;
	
	var _xspeed = _distance_x / _time;
	
	return _xspeed;
}

function jump_towards_y(_y, _time) {
	var _distance_y = _y - y;
	
	var _yspeed = (_distance_y - 0.5 * (ygravity * ygravity_mod) * sqr(_time)) / _time;
	
	return _yspeed;
}

function jump_towards(_x, _y, _time) {
	xspeed = jump_towards_x(_x,_time);
	yspeed = jump_towards_y(_y,_time);
}
