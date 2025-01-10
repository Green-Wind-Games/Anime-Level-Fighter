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
			if on_wall and (is_hit or is_guarding) {
				var _push = xspeed * 0.75;
				with(other) {
					x -= _push;
				}
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
			
			var i = 0;
			while(_dist < 0) {
				if pushme {
					x = clamp(x-_push, left_wall, right_wall);
				}
				if pushthem {
					other.x = clamp(other.x+_push, left_wall, right_wall);
				}
				_dist = point_distance(x,0,other.x,0) - (width_half + other.width_half);
				if i++ > 10 break;
			}
		}
		
		if (x == _xto) and (y == _yto) {
			break;
		}
	}
	
	update_physics(0);
}