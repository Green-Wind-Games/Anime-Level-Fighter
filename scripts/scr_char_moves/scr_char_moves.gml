// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function add_move(_move = light_attack, _input = "A", _ground = true, _air = true) {
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
	var _moved = false;
	var _available_moves = ds_priority_create();
	var _min_cancel = 0;
	var _movelist = on_ground ? ground_movelist : air_movelist;
	
	if (ds_list_empty(cancelable_moves)) {
		var _moveid = get_movelist_index(active_state)[1];
		if _moveid != -1 {
			_min_cancel = _moveid + 1;
			break;
		}
	}
	for(var i = _min_cancel; i < array_length(_movelist); i++) {
		var _move = _movelist[i][0];
		if (ds_list_find_index(cancelable_moves,_move) != -1)
		or ds_list_empty(cancelable_moves) {
			if (check_input(get_move_input(_move))) {
				ds_priority_add(_available_moves,_move,string_length(get_move_input(_move)));
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
			change_state(_state);
			if (active_state == idle_state) or (active_state == air_state) {
				xspeed = _xspeed;
				yspeed = _yspeed;
				facing = _facing;
				moved = false;
			}
			else {
				attack_hits = 0;
				can_guard = false;
				can_cancel = false;
				input_buffer = update_input_buffer_direction();
				input_buffer_timer = 0;
				moved = true;
			}
			if moved { break; }
		}
	}
	ds_priority_destroy(_available_moves);
	
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
			and (!string_ends_with(_input_dir,"3")) {
				valid = false;
			}
			break;
			case "4":
			if (!string_ends_with(_input_dir,"1")) 
			and (!string_ends_with(_input_dir,"4")) 
			and (!string_ends_with(_input_dir,"7")) { 
				valid = false;
			}
			break;
			case "6":
			if (!string_ends_with(_input_dir,"3")) 
			and (!string_ends_with(_input_dir,"6")) 
			and (!string_ends_with(_input_dir,"9")) { 
				valid = false;
			}
			break;
			case "8":
			if (!string_ends_with(_input_dir,"7")) 
			and (!string_ends_with(_input_dir,"8")) 
			and (!string_ends_with(_input_dir,"9")) { 
				valid = false;
			}
			break;
		}
	}
	if !string_ends_with(_input_btn,cmd_btn) {
		valid = false;
	}
	if (string_length(cmd_btn) == 1) {
		if input_buffer_timer > max(1, input_buffer_duration - (input_delay * game_speed * (game_get_speed(gamespeed_fps) / 60))) {
			valid = false;
		}
	}
	return valid;
}

function get_move_input(_move) {
	var _movelist = ground_movelist;
	repeat(2) {
		for(var i = 0; i < array_length(_movelist); i++) {
			if _move == _movelist[i][0] {
				return _movelist[i][1];
			}
		}
		_movelist = air_movelist;
	}
	return "ERROR";
}

function get_movelist_index(_move) {
	var _movelist = ground_movelist;
	repeat(2) {
		for(var i = 0; i < array_length(_movelist); i++) {
			if _move == _movelist[i][0] {
				return [_movelist, i];
			}
		}
		_movelist = air_movelist;
	}
	return [_movelist, -1];
}

function setup_autocombo() {
	for(var i = 0; i < array_length(autocombo); i++) {
		add_move(autocombo[i],"A");
	}
}

function setup_basicmoves() {
	medium_attack2 = new charstate();
	medium_attack2.start = function() {
		medium_lowattack.start();
	}
	medium_attack2.run = function() {
		medium_lowattack.run();
	}
	
	medium_attack3 = new charstate();
	medium_attack3.start = function() {
		medium_attack.start();
	}
	medium_attack3.run = function() {
		medium_attack.run();
	}
	
	medium_attack4 = new charstate();
	medium_attack4.start = function() {
		signature_move.start();
		
		if active_state != medium_attack4 {
			change_state(backdash_state);
		}
	}
	medium_attack4.run = function() {
		signature_move.run();
	}
	
	light_airattack2 = new charstate();
	light_airattack2.start = function() {
		medium_airattack.start();
	}
	light_airattack2.run = function() {
		medium_airattack.run();
	}
	
	light_airattack3 = new charstate();
	light_airattack3.start = function() {
		heavy_airattack.start();
	}
	light_airattack3.run = function() {
		heavy_airattack.run();
	}
	
	add_ground_move(dash_state,"656");
	add_ground_move(backdash_state,"454");
	
	add_air_move(airdash_state,"656");
	add_air_move(airdash_state,"956");
	add_air_move(air_backdash_state,"454");
	add_air_move(air_backdash_state,"754");
	
	add_move(teleport_state,"F");
	
	add_ground_move(light_attack,"A");
	add_ground_move(light_attack2,"A");
	add_ground_move(light_attack3,"A");
	
	add_ground_move(light_lowattack,"2A");
	
	add_air_move(light_airattack,"A");
	add_air_move(light_airattack2,"A");
	add_air_move(light_airattack3,"A");
	
	add_ground_move(medium_attack,"B");
	add_ground_move(medium_attack2,"B");
	add_ground_move(medium_attack3,"B");
	add_ground_move(medium_attack4,"B");
	
	add_ground_move(medium_lowattack,"2B");
	add_air_move(medium_airattack,"B");
	
	add_ground_move(heavy_attack,"C");
	add_ground_move(launcher_attack,"2C");
	add_air_move(heavy_airattack,"C");
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