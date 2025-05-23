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
		
		ai_default_attacks();
		
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
	ai_combo();
}

function ai_default_movement() {
	var _x = sign(input.right-input.left);
	var _y = 0;
	
	if chance(1) { _y = 1; }
	if chance(5) { _x = -facing; }
	if chance(5 + (5 * max_air_actions)) { _y = -1; }
	if chance(80) { _x = facing; }
	
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
	if (target_distance_x < 50) {
		ai_input_move(backdash_state,10);
	}
	if (target_distance_x > 50) {
		ai_input_move(dash_state,10);
	}
}

function ai_default_attacks() {
	if (target_distance < 30) and (!combo_hits) {
		ai_input_move(light_attack[0],100);
		
		//ai_input_move(heavy_attack,50);
		//ai_input_move(heavy_launcher,50);
		
		//ai_input_move(medium_attack,50);
		ai_input_move(medium_sweep,50);
	}
}

function ai_perform_random_moves() {
	var _inputs = ds_list_create();
	var _movelist = on_ground ? ground_movelist : air_movelist;
	for(var i = 0; i < array_length(_movelist); i++) {
		if (ds_list_find_index(_inputs,_movelist[i][1]) == -1) {
			ds_list_add(_inputs,_movelist[i][1]);
		}
	}
	var _move = ds_list_find_value(_inputs,irandom(ds_list_size(_inputs)-1));
	ai_input_command(_move,map_value(target_distance,right_wall-left_wall,0,10,100));
	
	ds_list_destroy(_inputs);
}

function ai_input_command(_command,_chance = 100) {
	if chance(_chance) {
		input_buffer = _command;
		input_buffer_timer = input_buffer_duration - input_delay;
	}
}

function ai_input_move(_move,_chance = 100) {
	if chance(_chance) {
		ai_input_command(get_move_input(_move)[0],100);
		if get_movelist_index(air_movelist,_move) != -1 {
			input.up = true;
		}
	}
}