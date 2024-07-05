/// @description Insert description here
// You can write your code in this editor

var u, d, l, r, a, b, c, d;

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
	break;
	
	case input_types.joystick:
	u =	gamepad_axis_value(pad,gp_axislv) < 0 or gamepad_button_check(pad,gp_padu);
	d =	gamepad_axis_value(pad,gp_axislv) > 0 or gamepad_button_check(pad,gp_padd);
	l =	gamepad_axis_value(pad,gp_axislh) < 0 or gamepad_button_check(pad,gp_padl);
	r =	gamepad_axis_value(pad,gp_axislh) > 0 or gamepad_button_check(pad,gp_padr);
	
	a = gamepad_button_check_pressed(pad,gp_face3);
	b = gamepad_button_check_pressed(pad,gp_face1);
	c = gamepad_button_check_pressed(pad,gp_face2);
	d = gamepad_button_check_pressed(pad,gp_face4);
	break;
	
	case input_types.wasd:
	u = keyboard_check(ord("W"));
	d = keyboard_check(ord("c"));
	l = keyboard_check(ord("A"));
	r = keyboard_check(ord("D"));
	
	a = keyboard_check_pressed(ord("B"));
	b = keyboard_check_pressed(ord("N"));
	c = keyboard_check_pressed(ord("M"));
	d = keyboard_check_pressed(ord("H"));
	break;
	
	case input_types.numpad:
	u = keyboard_check(vk_up);
	d = keyboard_check(vk_down);
	l = keyboard_check(vk_left);
	r = keyboard_check(vk_right);
	
	a = keyboard_check_pressed(vk_numpad1);
	b = keyboard_check_pressed(vk_numpad2);
	c = keyboard_check_pressed(vk_numpad3);
	d = keyboard_check_pressed(vk_numpad5);
	break;
}

up_pressed = !up and u;
down_pressed = !down and d;
left_pressed = !left and l;
right_pressed = !right and r;

up = u;
down = d;
left = l;
right = r;

button1 = a;
button2 = b;
button3 = c;
button4 = d;