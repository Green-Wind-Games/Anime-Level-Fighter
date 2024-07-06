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
		var u, d, l, r, a, b, c, d, e, f;

		switch(type) {
			default:
			u = false;
			d = false;
			l = false;
			r = false;
	
			a = false;
			b = false;
			c = false;
			d = false;
			e = false;
			f = false;
			break;
	
			case input_types.joystick:
			u =	gamepad_axis_value(pad,gp_axislv) < 0 or gamepad_button_check(pad,gp_padu);
			d =	gamepad_axis_value(pad,gp_axislv) > 0 or gamepad_button_check(pad,gp_padd);
			l =	gamepad_axis_value(pad,gp_axislh) < 0 or gamepad_button_check(pad,gp_padl);
			r =	gamepad_axis_value(pad,gp_axislh) > 0 or gamepad_button_check(pad,gp_padr);
	
			a = gamepad_button_check(pad,gp_face1);
			b = gamepad_button_check(pad,gp_face2);
			c = gamepad_button_check(pad,gp_face3);
			d = gamepad_button_check(pad,gp_face4);
			e = gamepad_button_check(pad,gp_shoulderl) or gamepad_button_check(pad,gp_shoulderlb);
			f = gamepad_button_check(pad,gp_shoulderr) or gamepad_button_check(pad,gp_shoulderrb);
			break;
	
			case input_types.wasd:
			u = keyboard_check(ord("W"));
			d = keyboard_check(ord("c"));
			l = keyboard_check(ord("A"));
			r = keyboard_check(ord("D"));
	
			a = keyboard_check(ord("B"));
			b = keyboard_check(ord("N"));
			c = keyboard_check(ord("M"));
			d = keyboard_check(ord("G"));
			e = keyboard_check(ord("H"));
			f = keyboard_check(ord("J"));
			break;
	
			case input_types.numpad:
			u = keyboard_check(vk_up);
			d = keyboard_check(vk_down);
			l = keyboard_check(vk_left);
			r = keyboard_check(vk_right);
	
			a = keyboard_check(vk_numpad1);
			b = keyboard_check(vk_numpad2);
			c = keyboard_check(vk_numpad3);
			d = keyboard_check(vk_numpad4);
			e = keyboard_check(vk_numpad5);
			f = keyboard_check(vk_numpad6);
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

		button1 = (!button1_held) and a;
		button2 = (!button2_held) and b;
		button3 = (!button3_held) and c;
		button4 = (!button4_held) and d;
		button4 = (!button5_held) and e;
		button4 = (!button6_held) and f;
		
		button1_held = a;
		button2_held = b;
		button3_held = c;
		button4_held = d;
		button4_held = e;
		button4_held = f;
	}
}

function update_charinputs() {
	with(obj_char) {
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
