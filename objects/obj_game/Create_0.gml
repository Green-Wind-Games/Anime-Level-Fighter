/// @description Insert description here
// You can write your code in this editor

if instance_number(object_index) > 1 {
	instance_destroy();
	exit;
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

enum vs_screen_substates {
	fadein,
	slidein,
	vs_slidein,
	slideout,
	fadeout
}

globalvar	game_state, previous_game_state, next_game_state, game_state_timer, game_state_duration,
			game_substate, previous_game_substate, next_game_substate, game_substate_timer, game_substate_duration,
			round_state, round_timer, round_state_timer, round_timer_max, round_timer_visible_max, round_ready_countdown_duration, round_ready_fight_duration, round_is_infinite,
			stage,
			
			max_players, player, player_char, player_input,
			player_slot, player_ready, ready_timer,
			player_color,
			
			game_speed,
			
			ygravity, ground_height, battle_x, battle_y, left_wall, right_wall,
			
			base_max_hp,
			base_max_mp_stocks, base_mp_stock_size,
			base_max_tp_stocks, base_tp_stock_size,
			base_max_xp, max_level, level_scaling,
			base_movespeed, base_jumpspeed,
			
			transform_heal_percent, transform_late_heal_percent_increase,
			
			timestop_active, timestop_timer, timestop_activator,
			superfreeze_active, superfreeze_timer, superfreeze_activator,
			player_super_active,
			
			screen_shake_x, screen_shake_y, screen_shake_intensity, screen_shake_timer,
			screen_flash_color, screen_flash_timer,
			screen_overlay_sprite, screen_overlay_timer,
			screen_flash_alpha, screen_shake_enabled, screen_overlay_alpha;
			
game_state = gamestates.intro;
previous_game_state = -1;
next_game_state = -1;

game_state_duration = -1;
game_state_timer = -1;

game_substate = -1;
next_game_substate = -1;
previous_game_substate = -1;

game_substate_duration = -1;
game_substate_timer = -1;

stage = rm_training;
round_state = roundstates.intro;
round_state_timer = 0;
round_timer_max = 500 * 60;
round_timer = round_timer_max;
round_timer_visible_max = 999;
round_ready_countdown_duration = 100;
round_ready_fight_duration = 50;
round_is_infinite = false;

game_speed = 1;

max_players = 8;

for(var i = 0; i < max_players; i++) {
	player[i] = noone;
	player_char[i] = 0;
	player_slot[i] = noone;
	player_ready[i] = false;
}

for(var i = 0; i < 10 + max_players; i++) {
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
		else if i >= 11 {
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

max_level = 5;

base_max_hp = 10000 * 5;

base_mp_stock_size = 1000;
base_max_mp_stocks = 10;

base_tp_stock_size = 8 * 60;
base_max_tp_stocks = 4;

base_max_xp = 10000;
level_scaling = 0.5;

base_movespeed = 5;
base_jumpspeed = 8;

transform_heal_percent = 0;
transform_late_heal_percent_increase = 0;

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

ygravity = 0.35;
left_wall = 0;
right_wall = room_width;
ground_height = room_height;
battle_x = room_width / 2;
battle_y = ground_height;
ground_sprite = noone;

voice = noone;
voice_volume_mine = 1;
voice_pitch_mine = 1;

depth = -9999;

for(var i = 0; i <= room_last; i++) {
	var _stage_size = game_width * 1.25;
	var _stage_width = round(_stage_size);
	var _stage_height = round(_stage_size / (16/9));
	var _menu_size = game_width;
	var _menu_width = round(_menu_size);
	var _menu_height = round(_menu_size);
	if i >= rm_training {
		room_set_width(i,_stage_width);
		room_set_height(i,_stage_height);
	}
	else if i != rm_start {
		room_set_width(i,_menu_width);
		room_set_height(i,_menu_height);
	}
}

texture_prefetch("Default");