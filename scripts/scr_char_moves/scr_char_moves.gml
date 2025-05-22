// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function add_move(_move = light_attack, _input = "A", _ground = true, _air = true) {
	if _ground {
		var n = get_movelist_index(ground_movelist,_move);
		if n == -1 {
			n = array_length(ground_movelist);
			array_push(ground_movelist,[_move]);
		}
		array_push(ground_movelist[n],_input);
	}
	if _air {
		var n = get_movelist_index(air_movelist,_move);
		if n == -1 {
			n = array_length(air_movelist);
			array_push(air_movelist,[_move]);
		}
		array_push(air_movelist[n],_input);
	}
}

function add_ground_move(_move,_input) {
	add_move(_move,_input,true,false);
}

function add_air_move(_move,_input) {
	add_move(_move,_input,false,true);
}

function check_moves() {
	var _moved = false;
	var _available_moves = ds_priority_create();
	var _min_cancel = 0;
	var _movelist = on_ground ? ground_movelist : air_movelist;
	var _jump_cancel = false;
	
	if input.up {
		if (air_actions < max_air_actions) or on_ground {
			_movelist = air_movelist;
			_jump_cancel = true;
		}
	}
	
	if (ds_list_empty(cancelable_moves)) {
		var _moveid = get_movelist_index(_movelist, active_state);
		if _moveid != -1 {
			_min_cancel = _moveid + 1;
		}
	}
	for(var i = _min_cancel; i < array_length(_movelist); i++) {
		var _move = _movelist[i][0];
		var _moveinput = get_move_input(_move);
		if (ds_list_find_index(cancelable_moves,_move) != -1)
		or (ds_list_empty(cancelable_moves)) {
			if (check_input(_moveinput)) {
				var _priority = (-i) + (string_length(_moveinput[0]) * 1000);
				ds_priority_add(_available_moves,_move,_priority);
			}
		}
	}
	
	if (!ds_priority_empty(_available_moves)) {
		var _xspeed = xspeed;
		var _yspeed = yspeed;
		var _facing = facing;
		repeat(ds_priority_size(_available_moves)) {
			var _state = ds_priority_find_max(_available_moves);
			ds_priority_delete_max(_available_moves);
			reset_cancels();
			face_target();
			if _jump_cancel {
				xspeed = 5 * facing;
				yspeed = -5;
			}
			change_state(_state);
			if (active_state == idle_state) or (active_state == air_state) {
				xspeed = _xspeed;
				yspeed = _yspeed;
				facing = _facing;
				_moved = false;
			}
			else {
				attack_hits = 0;
				can_guard = false;
				can_cancel = false;
				input_buffer = update_input_buffer_direction();
				input_buffer_timer = 0;
				
				if _jump_cancel {
					if is_airborne {
						air_actions++;
					}
				}
				
				_moved = true;
				break;
			}
		}
	}
	ds_priority_destroy(_available_moves);
	
	return _moved;
}

function add_cancel(_move) {
	if ds_list_find_index(cancelable_moves,_move) == -1 {
		ds_list_add(cancelable_moves,_move);
	}
}

function reset_cancels() {
	ds_list_clear(cancelable_moves);
}

function check_input(_input) {
	var _combinations = [_input];
	if is_array(_input) {
		_combinations = _input;
	}
	for(var i = 0; i < array_length(_combinations); i++) {
		var _string = _combinations[i];
		var _valid = true;
		var _input_dir = string_digits(input_buffer);
		var _input_btn = string_letters(input_buffer);
		var cmd_dir = string_digits(_string);
		var cmd_btn = string_letters(_string);
		if cmd_dir != "" {
			if (!string_ends_with(_input_dir,cmd_dir)) {
				if (string_length(cmd_dir) >= 3) {
					if (!string_ends_with(_input_dir,cmd_dir + "5")) {
						_valid = false;
					}
				}
				else if (string_length(cmd_dir) == 2) {
					if (!string_starts_with(cmd_dir,"5")) {
						if (!string_ends_with(_input_dir,string_insert("5",cmd_dir,2))) {
							_valid = false;
						}
					}
				}
				else {
					_valid = false;
				}
			}
			switch(cmd_dir) {
				case "2":
				if (!string_ends_with(_input_dir,"1")) 
				and (!string_ends_with(_input_dir,"2")) 
				and (!string_ends_with(_input_dir,"3")) {
					_valid = false;
				}
				break;
				case "4":
				if (!string_ends_with(_input_dir,"1")) 
				and (!string_ends_with(_input_dir,"4")) 
				and (!string_ends_with(_input_dir,"7")) { 
					_valid = false;
				}
				break;
				case "6":
				if (!string_ends_with(_input_dir,"3")) 
				and (!string_ends_with(_input_dir,"6")) 
				and (!string_ends_with(_input_dir,"9")) { 
					_valid = false;
				}
				break;
				case "8":
				if (!string_ends_with(_input_dir,"7")) 
				and (!string_ends_with(_input_dir,"8")) 
				and (!string_ends_with(_input_dir,"9")) { 
					_valid = false;
				}
				break;
			}
		}
		if !string_ends_with(_input_btn,cmd_btn) {
			_valid = false;
		}
		if (string_length(cmd_btn) == 1) {
			if input_buffer_timer > max(1, input_buffer_duration - (input_delay * game_speed * (game_get_speed(gamespeed_fps) / 60))) {
				_valid = false;
			}
		}
		
		if _valid {
			return true;
		}
	}
	return false;
}

function get_move_input(_move) {
	var _movelist = on_ground ? ground_movelist : air_movelist;
	repeat(2) {
		var _move_id = get_movelist_index(_movelist,_move);
		if _move_id != -1 {
			var _possible_inputs = [];
			for(var i = 1; i < array_length(_movelist[_move_id]); i++) {
				array_push(_possible_inputs,_movelist[_move_id][i]);
			}
			return _possible_inputs;
		}
		_movelist = on_ground ? air_movelist : ground_movelist;
	}
	return ["none"];
}

function get_movelist_index(_movelist, _move) {
	for(var i = 0; i < array_length(_movelist); i++) {
		if _move == _movelist[i][0] {
			return i;
		}
	}
	return -1;
}

function setup_autocombo() {
	for(var i = 0; i < array_length(autocombo); i++) {
		add_move(autocombo[i],"A");
	}
}

function timestop(_duration = 30) {
	timestop_active = true;
	timestop_activator = id;
	timestop_timer = _duration;
}

function superfreeze(_duration = 30) {
	if _duration > 0 {
		superfreeze_active = true;
		superfreeze_activator = id;
		superfreeze_timer = _duration;
	}
}

function activate_special(_cost) {
	if special_state != active_state {
		special_state = active_state;
		if _cost > 0 {
			spend_mp(_cost);
			play_sound(snd_activate_super,1,1.25);
			create_particles(
				x,
				y-height_half,
				super_activate_particle
			);
		}
	}
}

function activate_super(_duration = 30) {
	xspeed = 0;
	yspeed = 0;
	super_state = active_state;
	superfreeze(_duration);
	play_sound(snd_activate_super);
	create_particles(
		x,
		y-height_half,
		super_activate_particle
	);
}

function activate_ultimate(_duration = 60) {
	xspeed = 0;
	yspeed = 0;
	ultimate_state = active_state;
	superfreeze(_duration);
	play_sound(snd_activate_ultimate);
	create_particles(
		x,
		y-height_half,
		ultimate_activate_particle
	);
}

function deactivate_super() {
	special_state = noone;
	super_state = noone;
	ultimate_state = noone;
	
	special_active = false;
	super_active = false;
	ultimate_active = false;
}

function attempt_special(_cost = 1, _condition = true) {
	var _valid = check_mp(_cost) and (_condition);
	
	if _valid {
		activate_special(_cost);
		return true;
	}
	else {
		change_state(idle_state);
		return false;
	}
}

function attempt_super(_cost = 2, _condition = true) {
	if !check_mp(_cost) return false;
	if !_condition return false;
	
	activate_super();
	spend_mp(_cost);
	return true;
}

function attempt_ultimate(_cost = 5, _condition = true) {
	if !check_mp(_cost) return false;
	if !_condition return false;
	
	activate_ultimate();
	spend_mp(_cost);
	return true;
}

function check_mp(_stocks) {
	if mp >= (_stocks * mp_stock_size) {
		return true;
	}
	return false;
}

function spend_mp(_stocks) {
	if _stocks > 0 {
		mp -= (_stocks * mp_stock_size);
	}
}

function check_tp(_stocks) {
	if tp >= (_stocks * tp_stock_size) {
		return true;
	}
	return false;
}

function spend_tp(_stocks) {
	if _stocks > 0 {
		tp -= (_stocks * tp_stock_size);
	}
}