if round_state == roundstates.pause exit;
if (superfreeze_active) exit;
if (timestop_active) exit;
		
var active = true;

if !value_in_range(x,-room_width,room_width*2) {
	active = false;
}
if duration != -1 {
	duration -= 1;
	if duration <= 0 {
		active = false
	}
}
if hit_limit != -1 {
	if hit_count >= hit_limit {
		active = false;
	}
}
		
if !active {
	expire_script();
	instance_destroy();
	exit;
}

gravitate(affected_by_gravity);
if bounce {
	if x <= left_wall {
		xspeed = abs(xspeed);
	}
	if x >= right_wall {
		xspeed = -abs(xspeed);
	}
	if y >= ground_height {
		yspeed = -abs(yspeed);
	}
}
if homing {
	if target_exists() {
		target_x = target.x;
		target_y = target.y-target.height_half;
		target_direction = point_direction(x,y,target_x,target_y);
		var _direction = point_direction(0,0,xspeed,yspeed);
		if homing_max_turn > 0 {
			var turn = angle_difference(target_direction,_direction);
			turn = clamp(turn,-homing_max_turn,homing_max_turn);
			_direction += turn;
		}
		else {
			_direction = target_direction;
		}
		xspeed = lengthdir_x(homing_speed,_direction);
		yspeed = lengthdir_y(homing_speed,_direction);
	}
}

active_script();

if xspeed != 0 {
	facing = sign(xspeed);
}

rotation = point_direction(0,0,xspeed,yspeed);
run_animation();

run_physics();