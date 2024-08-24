// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

enum input_types {
	joystick,
	wasd,
	numpad,
	touch,
	ai
}

function update_input() {
	with(obj_input) {
		var u, d, l, r, b1, b2, b3, b4, b5, b6;

		switch(type) {
			default:
			u = false;
			d = false;
			l = false;
			r = false;
	
			b1 = false;
			b2 = false;
			b3 = false;
			b4 = false;
			b5 = false;
			b6 = false;
			break;
	
			case input_types.joystick:
			u =	gamepad_axis_value(pad,gp_axislv) < 0 or gamepad_button_check(pad,gp_padu);
			d =	gamepad_axis_value(pad,gp_axislv) > 0 or gamepad_button_check(pad,gp_padd);
			l =	gamepad_axis_value(pad,gp_axislh) < 0 or gamepad_button_check(pad,gp_padl);
			r =	gamepad_axis_value(pad,gp_axislh) > 0 or gamepad_button_check(pad,gp_padr);
	
			b1 = gamepad_button_check(pad,gp_face1);
			b2 = gamepad_button_check(pad,gp_face2);
			b3 = gamepad_button_check(pad,gp_face3);
			b4 = gamepad_button_check(pad,gp_face4);
			b5 = gamepad_button_check(pad,gp_shoulderl) or gamepad_button_check(pad,gp_shoulderlb);
			b6 = gamepad_button_check(pad,gp_shoulderr) or gamepad_button_check(pad,gp_shoulderrb);
			break;
	
			case input_types.wasd:
			u = keyboard_check(ord("W"));
			d = keyboard_check(ord("S"));
			l = keyboard_check(ord("A"));
			r = keyboard_check(ord("D"));
	
			b1 = keyboard_check(ord("B"));
			b2 = keyboard_check(ord("N"));
			b3 = keyboard_check(ord("M"));
			b4 = keyboard_check(ord("G"));
			b5 = keyboard_check(ord("H"));
			b6 = keyboard_check(ord("J"));
			break;
	
			case input_types.numpad:
			u = keyboard_check(vk_up);
			d = keyboard_check(vk_down);
			l = keyboard_check(vk_left);
			r = keyboard_check(vk_right);
	
			b1 = keyboard_check(vk_numpad1);
			b2 = keyboard_check(vk_numpad2);
			b3 = keyboard_check(vk_numpad3);
			b4 = keyboard_check(vk_numpad4);
			b5 = keyboard_check(vk_numpad5);
			b6 = keyboard_check(vk_numpad6);
			break;
		}

		up_pressed = (!up) and u;
		down_pressed = (!down) and d;
		left_pressed = (!left) and l;
		right_pressed = (!right) and r;

		up = u;
		down = d;
		left = l;
		right = r;

		button1 = (!button1_held) and b1;
		button2 = (!button2_held) and b2;
		button3 = (!button3_held) and b3;
		button4 = (!button4_held) and b4;
		button5 = (!button5_held) and b5;
		button6 = (!button6_held) and b6;
		
		button1_held = b1;
		button2_held = b2;
		button3_held = b3;
		button4_held = b4;
		button5_held = b5;
		button6_held = b6;
	}
}

function update_charinputs() {
	with(obj_char) {
		if ai_enabled {
			update_ai();
		}
		
		var _buffer = input_buffer;
		
		input.forward = sign(input.right - input.left) == (facing);
		input.back = sign(input.right - input.left) == (-facing);
	
		var hor = sign(input.forward - input.back);
		var ver = sign(input.up - input.down);
		var dir = string(5 + hor + (ver * 3));
	
		if !string_ends_with(string_digits(input_buffer),dir) {
			input_buffer += dir;
		}
		
		var command = "";
		if input.button1 { command += "A"; }
		if input.button2 { command += "B"; }
		if input.button3 { command += "C"; }
		if input.button4 { command += "D"; }
		if input.button5 { command += "E"; }
		if input.button6 { command += "F"; }
		
		input_buffer += command;
	
		if input_buffer != _buffer {
			input_buffer_timer = 10;
		}
		else {
			input_buffer_timer -= (!hitstop);
			if input_buffer_timer <= 0 {
				input_buffer = dir;
				input_buffer_timer = 0;
			}
		}
	}
}
