// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

enum input_types {
	joystick,
	wasd,
	numpad,
	touch,
	ai
}

globalvar input_buffer_duration, input_delay;
input_buffer_duration = 10;
input_delay = 3;

function update_input_buffer() {
	var _buffer = input_buffer;
	
	update_input_buffer_direction();
	update_input_buffer_buttons();
	
	if input_buffer != _buffer {
		input_buffer_timer = input_buffer_duration;
		if hitstop {
			input_buffer_timer -= input_delay;
		}
	}
	else {
		if (!hitstop) and (!timestop_active) and (!superfreeze_active) {
			input_buffer_timer -= game_speed;
			if input_buffer_timer <= 0 {
				input_buffer = update_input_buffer_direction();
				input_buffer_timer = 0;
			}
		}
	}
}

function update_input_buffer_direction() {
	update_input_forward_back();
	
	var hor = sign(input.forward - input.back);
	var ver = sign(input.up - input.down);
	var dir = string(5 + hor + (ver * 3));
	
	if !string_ends_with(string_digits(input_buffer),dir) {
		input_buffer += dir;
		input_buffer_timer = input_buffer_duration;
	}
	return dir;
}

function update_input_forward_back() {
	input.forward = sign(input.right - input.left) == (facing);
	input.back = sign(input.right - input.left) == (-facing);
	return (input.forward) - (input.back);
}

function update_input_buffer_buttons() {
	var _command = "";
	if input.light_attack { _command += "A"; }
	if input.medium_attack { _command += "B"; }
	if input.heavy_attack { _command += "C"; }
	if input.unique_attack { _command += "D"; }
	if input.supercharge { _command += "E"; }
	if input.use_tech { _command += "F"; }
	
	if _command != "" {
		input_buffer_timer = input_buffer_duration;
		input_buffer += _command;
	}
	return _command;
}