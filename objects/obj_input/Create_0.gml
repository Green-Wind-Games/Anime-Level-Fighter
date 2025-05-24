/// @description Insert description here
// You can write your code in this editor

type = input_types.joystick;
pad = 0;

assigned = false;
ai_assigned_player = noone;

up = false;
down = false;
left = false;
right = false;

forward = false;
back = false;

up_pressed = false;
down_pressed = false;
left_pressed = false;
right_pressed = false;

forward_pressed = false;
back_pressed = false;

for(var i = 0; i <= 8; i++) {
	button[i] = false;
	button_held[i] = false;
}

pause = false;

menu_confirm = false;
menu_cancel = false;

charselect_teamswitch = false;
charselect_random = false;

light_attack = false;
medium_attack = false;
heavy_attack = false;
unique_attack = false;

supercharge = false;
use_tech = false;

supercharge_held = false;