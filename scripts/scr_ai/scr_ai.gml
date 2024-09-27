// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

globalvar	ai_level, ai_level_max,
			ai_think_interval, ai_think_interval_base;
			
ai_level_max = 8;

function change_ai_level(_level = ai_level) {
	ai_level = round(clamp(_level,1,ai_level_max));
	ai_think_interval = round(map_value(ai_level,1,ai_level_max,15,3));
	//ai_think_interval = 0;
}

change_ai_level(ai_level_max);

function update_ai() {
	if ai_timer-- <= 0 {
		input.up = false;
		input.down = false;
		input.left = false;
		input.right = false;
		input.forward = false;
		input.back = false;
		
		ai_default_movement();
		ai_perform_random_moves();
		ai_script();
		ai_combo();
		
		input.left = false;
		input.right = false;
		var _x = sign(input.forward - input.back);
		if facing == 1 {
			if _x > 0 {
				input.right = true;
			}
			else if _x < 0 {
				input.left = true;
			}
		}
		else {
			if _x > 0 {
				input.left = true;
			}
			else if _x < 0 {
				input.right = true;
			}
		}
		
		ai_timer = ai_think_interval;
	}
}

function ai_default_movement() {
	var _x = sign(input.right-input.left);
	var _y = 0;
	
	if irandom(8) == 1 { _y = 1; }
	if irandom(6) == 1 { _y = -1; }
	if irandom(4) == 1 { _x = -facing; }
	if irandom(2) == 1 { _x = facing; }
	
	input.up = _y > 0;
	input.down = _y < 0;
	input.left = _x < 0;
	input.right = _x > 0;
	
	input.forward = _x == facing;
	input.back = _x == -facing;
	
	if active_state == crouch_state {
		if irandom(50) == 1 {
			input.down = false;
			input.up = true;
		}
	}
	if target_distance_x < 100 {
		ai_input_move(backdash_state,5);
	}
	if target_distance_x > 50 {
		ai_input_move(dash_state,5);
	}
}

function ai_perform_random_moves() {
	var _inputs = ds_list_create();
	for(var i = 0; i < array_length(movelist); i++) {
		if ds_list_find_index(_inputs,movelist[i][1]) == -1 {
			ds_list_add(_inputs,movelist[i][1]);
		}
	}
	
	var _move = ds_list_find_value(_inputs,irandom(ds_list_size(_inputs)-1));
	ai_input_command(_move,map_value(target_distance,game_width,0,20,60));
	
	ds_list_destroy(_inputs);
}

function ai_combo() {
	if combo_hits > 0 {
		var _move;
		for(var i = 0; i < array_length(autocombo); i++) {
			if active_state == autocombo[i] {
				_move = autocombo[0];
			}
		}
		if ds_list_empty(cancelable_moves) {
			_move = movelist[irandom(array_length(movelist)-1)][0];
		}
		else {
			_move = ds_list_find_value(cancelable_moves,irandom(ds_list_size(cancelable_moves)-1));
		}
		ai_input_move(_move,100);
	}
}

function ai_input_command(_command,_chance = 100) {
	if random(100) < _chance {
		input_buffer += _command;
		input_buffer_timer = ai_think_interval;
	}
}

function ai_input_move(_move,_chance = 100) {
	if random(100) < _chance {
		var _move_input = "";
		for(var i = 0; i < array_length(movelist); i++) {
			if movelist[i][0] == _move {
				_move_input = movelist[i][1];
			}
		}
		ai_input_command(_move_input,100);
	}
}

function ai_autocombo() {
	if target_distance < width {
		ai_input_move(autocombo[0],30);
	}
	for(var i = 0; i < array_length(autocombo)-2; i++) {
		if (active_state == autocombo[i]
		or previous_state == autocombo[i])
		and combo_hits > 0 {
			ai_input_move(autocombo[0],100);
			break;
		}
	}
}