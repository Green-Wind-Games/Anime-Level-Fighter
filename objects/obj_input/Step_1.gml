if (type == input_types.ai) and (ai_assigned_player == noone) exit;

var u, d, l, r, b;

u = false;
d = false;
l = false;
r = false;
	
for(var i = 0; i < array_length(button); i++) {
	b[i] = false;
}

switch(type) {
	case input_types.ai:
	u = player_input[ai_assigned_player].up;
	d = player_input[ai_assigned_player].down;
	l = player_input[ai_assigned_player].left;
	r = player_input[ai_assigned_player].right;
	
	for(var i = 0; i < array_length(button); i++) {
		b[i] = player_input[ai_assigned_player].button_held[i];
	}
	break;
	
	case input_types.joystick:
	gamepad_set_axis_deadzone(pad,0.5);
	
	u =	(gamepad_axis_value(pad,gp_axislv) < 0) or gamepad_button_check(pad,gp_padu);
	d =	(gamepad_axis_value(pad,gp_axislv) > 0) or gamepad_button_check(pad,gp_padd);
	l =	(gamepad_axis_value(pad,gp_axislh) < 0) or gamepad_button_check(pad,gp_padl);
	r =	(gamepad_axis_value(pad,gp_axislh) > 0) or gamepad_button_check(pad,gp_padr);
	
	b[0] = gamepad_button_check(pad,gp_start);
	
	b[1] = gamepad_button_check(pad,gp_face1);
	b[2] = gamepad_button_check(pad,gp_face2);
	b[3] = gamepad_button_check(pad,gp_face3);
	b[4] = gamepad_button_check(pad,gp_face4);
	
	b[5] = gamepad_button_check(pad,gp_shoulderl);
	b[6] = gamepad_button_check(pad,gp_shoulderr);
	b[7] = gamepad_button_check(pad,gp_shoulderlb);
	b[8] = gamepad_button_check(pad,gp_shoulderrb);
	break;
	
	case input_types.wasd:
	u = keyboard_check(ord("W"));
	d = keyboard_check(ord("S"));
	l = keyboard_check(ord("A"));
	r = keyboard_check(ord("D"));
	
	b[0] = keyboard_check(ord("P")) or keyboard_check(vk_escape);
	
	b[1] = keyboard_check(ord("B"));
	b[2] = keyboard_check(ord("N"));
	b[3] = keyboard_check(ord("M"));
	b[4] = keyboard_check(ord("G"));
	
	b[5] = keyboard_check(ord("H"));
	b[6] = keyboard_check(ord("J"));
	b[7] = keyboard_check(ord("Q"));
	b[8] = keyboard_check(ord("E"));
	break;
	
	case input_types.numpad:
	u = keyboard_check(vk_up);
	d = keyboard_check(vk_down);
	l = keyboard_check(vk_left);
	r = keyboard_check(vk_right);
	
	b[0] = keyboard_check(vk_enter);
	
	b[1] = keyboard_check(vk_numpad1);
	b[2] = keyboard_check(vk_numpad2);
	b[3] = keyboard_check(vk_numpad3);
	b[4] = keyboard_check(vk_numpad4);
	
	b[5] = keyboard_check(vk_numpad5);
	b[6] = keyboard_check(vk_numpad6);
	b[7] = keyboard_check(vk_numpad0);
	b[8] = keyboard_check(vk_decimal);
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

for(var i = 0; i < array_length(button); i++) {
	button[i] = (!button_held[i]) and b[i];
		
	if b[i] button_held[i] += game_speed; else button_held[i] = 0;
}

menu_confirm = button[1];
menu_cancel = button[2];

charselect_random = button_held[5];
charselect_teamswitch = button[6];
	
switch(type) {
	default:
	light_attack = button[1];
	medium_attack = button[2];
	heavy_attack = button[3];
	unique_attack = button[4];
	break;
	
	case input_types.joystick:
	light_attack = button[3];
	medium_attack = button[4];
	heavy_attack = button[2];
	unique_attack = button[1];
	break;
}

supercharge = button[5];
use_tech = button[6];
	
supercharge_held = button_held[5] - 10;
dodge = button_held[6];