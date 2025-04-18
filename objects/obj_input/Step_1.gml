if (type == input_types.ai) and (ai_assigned_player == noone) exit;

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
	
	case input_types.ai:
	u = player_input[ai_assigned_player].up;
	d = player_input[ai_assigned_player].down;
	l = player_input[ai_assigned_player].left;
	r = player_input[ai_assigned_player].right;
	
	b1 = player_input[ai_assigned_player].button1;
	b2 = player_input[ai_assigned_player].button2;
	b3 = player_input[ai_assigned_player].button3;
	b4 = player_input[ai_assigned_player].button4;
	b5 = player_input[ai_assigned_player].button5;
	b6 = player_input[ai_assigned_player].button6;
	break;
	
	case input_types.joystick:
	gamepad_set_axis_deadzone(pad,0.5);
	
	u =	(gamepad_axis_value(pad,gp_axislv) < 0) or gamepad_button_check(pad,gp_padu);
	d =	(gamepad_axis_value(pad,gp_axislv) > 0) or gamepad_button_check(pad,gp_padd);
	l =	(gamepad_axis_value(pad,gp_axislh) < 0) or gamepad_button_check(pad,gp_padl);
	r =	(gamepad_axis_value(pad,gp_axislh) > 0) or gamepad_button_check(pad,gp_padr);
	
	b1 = gamepad_button_check(pad,gp_face1);
	b2 = gamepad_button_check(pad,gp_face2);
	b3 = gamepad_button_check(pad,gp_face3);
	b4 = gamepad_button_check(pad,gp_face4);
	b5 = gamepad_button_check(pad,gp_shoulderl);
	b6 = gamepad_button_check(pad,gp_shoulderr);
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
		
if b1 button1_held += game_speed; else button1_held = 0;
if b2 button2_held += game_speed; else button2_held = 0;
if b3 button3_held += game_speed; else button3_held = 0;
if b4 button4_held += game_speed; else button4_held = 0;
if b5 button5_held += game_speed; else button5_held = 0;
if b6 button6_held += game_speed; else button6_held = 0;

confirm = button1;
cancel = button2;

char_random = button5_held;
char_teamswitch = button6;
	
switch(type) {
	default:
	light_attack = button1;
	medium_attack = button2;
	heavy_attack = button3;
	unique_attack = button4;
	break;
	
	case input_types.joystick:
	light_attack = button3;
	medium_attack = button4;
	heavy_attack = button2;
	unique_attack = button1;
	break;
}

supercharge = button5;
use_teleport = button6;
	
charge = button5_held - 10;
dodge = button6_held;