/// @description Insert description here
// You can write your code in this editor

if instance_number(object_index) > 1 {
	instance_destroy();
	exit;
}

enum gamestates {
	intro,
	title,
	main_menu,
	options,
	
	story_select,
	story_cutscene,
	story_battle,
	story_results,
	
	arcade_select,
	arcade_battle,
	arcade_results,
	
	versus_setup,
	versus_select,
	versus_intro,
	versus_battle,
	versus_results,
	
	training_select,
	training,
	
	credits
}

enum roundstates {
	intro,
	countdown,
	fight,
	pause,
	knockout,
	time_over,
	victory
}

enum fade_types {
	normal,
	bottom,
	top,
	left,
	right
}

globalvar	player, player_char, player_input,
			player_slot, player_ready, ready_timer,
			player_color,
			
			ygravity, ground_height, battle_x, battle_y, left_wall, right_wall,
			
			base_hp, base_movespeed, base_jumpspeed,
			max_mp, max_mp_stocks, mp_stock_size,
			max_tp, max_tp_stocks, tp_stock_size,
			max_xp, max_level, level_scaling,
			
			transform_heal_percent, transform_late_heal_percent_increase,
			
			game_state, previous_game_state, next_game_state, game_state_timer, game_state_duration,
			round_state, round_timer, round_state_timer, round_timer_max, round_countdown_duration, round_is_infinite,
			stage,
			
			timestop_active, timestop_timer, timestop_activator,
			superfreeze_active, superfreeze_timer, superfreeze_activator,
			player_super_active,
			
			screen_shake_x, screen_shake_y, screen_shake_intensity, screen_shake_timer,
			screen_flash_color, screen_flash_timer,
			screen_overlay_sprite, screen_overlay_timer,
			screen_zoom, screen_zoom_target,
			screen_flash_alpha, screen_shake_enabled, screen_overlay_alpha,
			screen_fade_color, screen_fade_duration, screen_fade_type;
			
for(var i = 0; i < 8; i++) {
	player[i] = noone;
	player_char[i] = 0;
	player_slot[i] = noone;
	player_ready[i] = false;
}

for(var i = 0; i < 8; i++) {
	gamepad_set_axis_deadzone(i,0.5);
}

for(var i = 0; i <= 10 + array_length(player_slot); i++) {
	with(instance_create(0,0,obj_input)) {
		player_input[i] = id;
		persistent = true;
		type = input_types.joystick;
		pad = i;
		if i == 8 {
			type = input_types.wasd;
		}
		else if i == 9 {
			type = input_types.numpad;
		}
		else if i == 10 {
			type = input_types.touch;
		}
		else if i > 10 {
			type = input_types.ai;
		}
	}
}

var i = 0;
player_color[i++] = make_color_rgb(255,64,64);
player_color[i++] = make_color_rgb(0,160,255);
player_color[i++] = make_color_rgb(255,192,0);
player_color[i++] = make_color_rgb(0,224,0);
player_color[i++] = make_color_rgb(128,0,255);
player_color[i++] = make_color_rgb(255,0,255);
player_color[i++] = make_color_rgb(255,128,0);
player_color[i++] = make_color_rgb(128,64,32);

game_state = gamestates.intro;
previous_game_state = -1;
next_game_state = -1;
game_state_duration = -1;
game_state_timer = -1;

stage = rm_training;
round_state = roundstates.intro;
round_state_timer = 0;
round_timer_max = 400 * 60;
round_timer = round_timer_max;
round_countdown_duration = (3 * 30) + 30;
round_is_infinite = false;

base_hp = 1000;
base_movespeed = 5;
base_jumpspeed = 8;

mp_stock_size = 1000;
max_mp_stocks = 7;
max_mp = max_mp_stocks * mp_stock_size;

tp_stock_size = 8 * 60;
max_tp_stocks = 4;
max_tp = max_tp_stocks * tp_stock_size;

max_xp = 1000;
max_level = 5;
level_scaling = 0.35;

transform_heal_percent = 60;
transform_late_heal_percent_increase = 10;

superfreeze_active = false;
superfreeze_activator = noone;
superfreeze_timer = 0;

timestop_active = false;
timestop_activator = noone;
timestop_timer = 0;

screen_flash_color = c_white;
screen_flash_timer = 0;
screen_flash_alpha = 1;

screen_shake_intensity = 0;
screen_shake_x = 0;
screen_shake_y = 0;
screen_shake_timer = 0;
screen_shake_enabled = true;

screen_overlay_sprite = noone;
screen_overlay_timer = 0;
screen_overlay_alpha = 1;

screen_fade_color = c_black;
screen_fade_duration = 30;
screen_fade_type = fade_types.normal;

screen_zoom = 1;
screen_zoom_target = noone;

ygravity = 0.35;
left_wall = 0;
right_wall = room_width;
ground_height = room_height;
battle_x = room_width / 2;
battle_y = ground_height;
ground_sprite = noone;

depth = -9999;

for(var i = 0; i <= room_last; i++) {
	if i <= rm_training {
		room_set_width(i,game_width*2);
		room_set_height(i,game_height*2);
	}
}

texture_prefetch("Default");