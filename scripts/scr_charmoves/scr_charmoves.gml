// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function add_move(_move,_input,_ground = true,_air = true) {
	if _ground {
		if (ground_movelist[0][0] == noone) {
			ground_movelist[0][0] = _move;
			ground_movelist[0][1] = _input;
		}
		else {
			var n = array_length(ground_movelist);
			ground_movelist[n][0] = _move;
			ground_movelist[n][1] = _input;
		}
	}
	if _air {
		if (air_movelist[0][0] == noone) {
			air_movelist[0][0] = _move;
			air_movelist[0][1] = _input;
		}
		else {
			var n = array_length(air_movelist);
			air_movelist[n][0] = _move;
			air_movelist[n][1] = _input;
		}
	}
}

function add_ground_move(_move,_input) {
	add_move(_move,_input,true,false);
}

function add_air_move(_move,_input) {
	add_move(_move,_input,false,true);
}

function check_moves() {
	var moved = false;
			
	var available_moves = ds_priority_create();
	var min_cancel = 0; //floor(combo_hits * 0.5);
	if on_ground {
		if (ds_list_empty(cancelable_moves)) {
			for(var i = min_cancel; i < array_length(ground_movelist); i++) {
				if (active_state == ground_movelist[i][0]) {
					min_cancel = i+1;
					break;
				}
			}
		}
		for(var i = min_cancel; i < array_length(ground_movelist); i++) {
			var move = ground_movelist[i][0];
			var input = ground_movelist[i][1];
			if (ds_list_find_index(cancelable_moves,move) != -1)
			or ds_list_empty(cancelable_moves) {
				if (check_input(input)) {
					ds_priority_add(available_moves,move,string_length(input));
				}
			}
		}
	}
	else {
		if (ds_list_empty(cancelable_moves)) {
			for(var i = min_cancel; i < array_length(air_movelist); i++) {
				if (active_state == air_movelist[i][0]) {
					min_cancel = i+1;
					break;
				}
			}
		}
		for(var i = min_cancel; i < array_length(air_movelist); i++) {
			var move = air_movelist[i][0];
			var input = air_movelist[i][1];
			if (ds_list_find_index(cancelable_moves,move) != -1)
			or ds_list_empty(cancelable_moves) {
				if (check_input(input)) {
					ds_priority_add(available_moves,move,string_length(input));
				}
			}
		}
	}
	if (!ds_priority_empty(available_moves)) {
		var _xspeed = xspeed;
		var _yspeed = yspeed;
		for(var i = 0; i < ds_priority_size(available_moves); i++) {
			var _state = ds_priority_find_max(available_moves);
			reset_cancels();
			change_state(_state);
			if (active_state == idle_state) or (active_state == air_state) {
				ds_priority_delete_max(available_moves);
				i--;
				xspeed = _xspeed;
				yspeed = _yspeed;
			}
			else {
				if (abs(xspeed) > 15) {
					show_debug_message(name + "'s " + input_buffer + " has abnormally high xspeed!");
				}
				can_guard = false;
				can_cancel = false;
				input_buffer = update_input_buffer_direction();
				input_buffer_timer = 0;
				moved = true;
				break;
			}
		}
	}
	ds_priority_destroy(available_moves);
	
	return moved;
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
	var valid = true;
	var _input_dir = string_digits(input_buffer);
	var _input_btn = string_letters(input_buffer);
	var cmd_dir = string_digits(_input);
	var cmd_btn = string_letters(_input);
	if cmd_dir != "" {
		if (!string_ends_with(_input_dir,cmd_dir)) and (!string_ends_with(_input_dir,cmd_dir + "5")) {
			valid = false;
		}
		switch(cmd_dir) {
			case "2":
			if (!string_ends_with(_input_dir,"1")) 
			and (!string_ends_with(_input_dir,"2")) 
			and (!string_ends_with(_input_dir,"3")) 
			and (!string_ends_with(_input_dir,"15")) 
			and (!string_ends_with(_input_dir,"25")) 
			and (!string_ends_with(_input_dir,"35")) {
				valid = false;
			}
			break;
			case "4":
			if (!string_ends_with(_input_dir,"1")) 
			and (!string_ends_with(_input_dir,"4")) 
			and (!string_ends_with(_input_dir,"7")) 
			and (!string_ends_with(_input_dir,"15")) 
			and (!string_ends_with(_input_dir,"45")) 
			and (!string_ends_with(_input_dir,"75")) { 
				valid = false;
			}
			break;
			case "6":
			if (!string_ends_with(_input_dir,"3")) 
			and (!string_ends_with(_input_dir,"6")) 
			and (!string_ends_with(_input_dir,"9")) 
			and (!string_ends_with(_input_dir,"35")) 
			and (!string_ends_with(_input_dir,"65")) 
			and (!string_ends_with(_input_dir,"95")) { 
				valid = false;
			}
			break;
			case "8":
			if (!string_ends_with(_input_dir,"7")) 
			and (!string_ends_with(_input_dir,"8")) 
			and (!string_ends_with(_input_dir,"9")) 
			and (!string_ends_with(_input_dir,"75")) 
			and (!string_ends_with(_input_dir,"85")) 
			and (!string_ends_with(_input_dir,"95")) { 
				valid = false;
			}
			break;
		}
	}
	if !string_ends_with(_input_btn,cmd_btn) {
		valid = false;
	}
	return valid;
}

function setup_autocombo() {
	for(var i = 0; i < array_length(autocombo); i++) {
		add_move(autocombo[i],"A");
	}
}

function setup_basicmoves() {
	add_ground_move(dash_state,"656");
	add_ground_move(backdash_state,"454");
	
	add_air_move(airdash_state,"656");
	add_air_move(air_backdash_state,"454");
	
	add_ground_move(light_attack,"A");
	add_ground_move(light_attack_forward,"6A");
	add_ground_move(light_attack_down,"2A");
	add_air_move(light_airattack,"A");
	
	add_ground_move(heavy_attack,"B");
	add_ground_move(heavy_attack_forward,"6B");
	add_ground_move(heavy_attack_down,"2B");
	add_air_move(heavy_airattack,"B");
	
	add_move(teleport_state,"F");
}

function timestop(_duration = 30) {
	timestop_active = true;
	timestop_activator = id;
	timestop_timer = _duration;
}

function superfreeze(_duration = 30) {
	superfreeze_active = true;
	superfreeze_activator = id;
	superfreeze_timer = _duration;
}

function activate_super(_duration = 30) {
	xspeed = 0;
	yspeed = 0;
	super_state = active_state;
	superfreeze(_duration);
	play_sound(snd_activate_super);
	create_particles(
		x,
		y-(height*0.75),
		x,
		y-(height*0.75),
		super_particle
	);
}

function activate_ultimate(_duration = 60) {
	xspeed = 0;
	yspeed = 0;
	super_state = active_state;
	superfreeze(_duration);
	play_sound(snd_activate_ultimate);
	create_particles(
		x,
		y-(height*0.75),
		x,
		y-(height*0.75),
		ultimate_particle
	);
}

function deactivate_super() {
	super_active = false;
}

function check_mp(_stocks) {
	if mp >= (_stocks * mp_stock_size) {
		return true;
	}
	return false;
}

function spend_mp(_stocks) {
	mp -= (_stocks * mp_stock_size);
}

function check_tp(_stocks) {
	if tp >= (_stocks * tp_stock_size) {
		return true;
	}
	return false;
}

function spend_tp(_stocks) {
	tp -= (_stocks * tp_stock_size);
}