// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

globalvar	ai_level, ai_level_max,
			ai_think_interval, ai_think_interval_base;
			
ai_level_max = 8;

function change_ai_level(_level = ai_level) {
	ai_level = clamp(round(_level),1,ai_level_max);
	ai_think_interval = round(map_value(ai_level,1,ai_level_max,16,8));
	//ai_think_interval = 6;
}

change_ai_level(ai_level_max/2);

function update_ai() {
	ai_timer -= game_speed;
	if (ai_timer <= 0) {
		//input.up = false;
		//input.down = false;
		//input.left = false;
		//input.right = false;
		//input.forward = false;
		//input.back = false;
		
		ai_default_movement();
		ai_perform_random_moves();
		ai_combo();
		ai_script();
		
		input.left = false;
		input.right = false;
		var _x = sign(input.forward - input.back);
		if (facing == 1) {
			if (_x > 0) {
				input.right = true;
			}
			else if (_x < 0) {
				input.left = true;
			}
		}
		else {
			if (_x > 0) {
				input.left = true;
			}
			else if (_x < 0) {
				input.right = true;
			}
		}
		
		ai_timer = ai_think_interval;
	}
}

function ai_default_movement() {
	var _x = sign(input.right-input.left);
	var _y = 0;
	
	if chance(10) { _y = 1; }
	if chance(10 + (10 * max_air_moves)) { _y = -1; }
	if chance(30) { _x = -facing; }
	if chance(40) { _x = facing; }
	
	input.up = _y < 0;
	input.down = _y > 0;
	input.left = _x < 0;
	input.right = _x > 0;
	
	input.forward = _x == facing;
	input.back = _x == -facing;
	
	if (active_state == crouch_state) {
		if chance(2) {
			input.down = false;
			input.up = true;
		}
	}
	if (target_distance_x < 100) {
		ai_input_move(backdash_state,10);
	}
	if (target_distance_x > 50) {
		ai_input_move(dash_state,10);
	}
}

function ai_perform_random_moves() {
	var _inputs = ds_list_create();
	if on_ground {
		for(var i = 0; i < array_length(ground_movelist); i++) {
			if (ds_list_find_index(_inputs,ground_movelist[i][1]) == -1) {
				ds_list_add(_inputs,ground_movelist[i][1]);
			}
		}
	}
	else {
		for(var i = 0; i < array_length(air_movelist); i++) {
			if (ds_list_find_index(_inputs,air_movelist[i][1]) == -1) {
				ds_list_add(_inputs,air_movelist[i][1]);
			}
		}
	}
	
	var _move = ds_list_find_value(_inputs,irandom(ds_list_size(_inputs)-1));
	ai_input_command(_move,map_value(target_distance,right_wall-left_wall,0,10,100));
	
	ds_list_destroy(_inputs);
}

function ai_combo() {
	if (combo_timer > 0) {
		var _movelist = on_ground ? ground_movelist : air_movelist;
		var _move = _movelist[irandom(array_length(_movelist)-1)][0];
		if !ds_list_empty(cancelable_moves) {
			_move = ds_list_find_value(cancelable_moves,irandom(ds_list_size(cancelable_moves)-1));
		}
		ai_input_move(_move,map_value(ai_level,1,ai_level_max,50,100));
		//for(var i = 0; i < array_length(autocombo)-1; i++) {
		//	if (active_state == autocombo[i]) {
		//		ai_input_move(autocombo[0],100);
		//	}
		//}
	}
}

function ai_input_command(_command,_chance = 100) {
	if chance(_chance) {
		input_buffer += _command;
		input_buffer_timer = ai_think_interval;
	}
}

function ai_input_move(_move,_chance = 100) {
	if chance(_chance) {
		var _movelist = on_ground ? ground_movelist : air_movelist;
		var _move_input = "";
		for(var i = 0; i < array_length(_movelist); i++) {
			if (_movelist[i][0] == _move) {
				_move_input = _movelist[i][1];
			}
		}
		ai_input_command(_move_input,100);
	}
}

function ai_autocombo() {
	if (target_distance < width) {
		ai_input_move(autocombo[0],30);
	}
	for(var i = 0; i < array_length(autocombo)-2; i++) {
		if ((active_state == autocombo[i])
		or (previous_state == autocombo[i]))
		and (combo_hits > 0) {
			ai_input_move(autocombo[0],100);
			break;
		}
	}
}