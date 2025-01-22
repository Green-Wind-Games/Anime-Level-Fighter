function target_exists() {
	if instance_exists(target) {
		return true;
	}
	else {
		target = noone;
		return false;
	}
}

function face_target(_away = false) {
	if target_exists() {
		var _face = facing;
		if x < target.x {
			facing = _away ? -1 : 1;
		}
		else if x > target.x {
			facing = _away ? 1 : -1;
		}
		if facing != _face {
			input_buffer = update_input_buffer_direction() + update_input_buffer_buttons();
		}
	}
}

function target_closest_enemy() {
	var me = id;
	var dist = room_width+room_height;
	var _target = noone;
	with(obj_char) {
		var me2 = id;
		if me.team == me2.team continue;
		if round_state == roundstates.fight {
			if me2.dead continue;
		}
		
		var mydist = point_distance(x,y,other.x,other.y);
		if mydist > dist continue;
		
		dist = mydist;
		
		_target = me2;
	}
	return _target;
}

function target_front_enemy() {
	var me = id;
	var dist = room_width+room_height;
	var _target = noone;
	with(obj_char) {
		var me2 = id;
		if me.team == me2.team continue;
		if me2.dead continue;
		
		if me.x < me2.x and me.facing != 1 continue;
		if me.x > me2.x and me.facing !=-1 continue;
		
		var mydist = point_distance(x,y,other.x,other.y);
		if mydist > dist continue;
		
		dist = mydist;
		
		_target = me2;
	}
	return _target;
}