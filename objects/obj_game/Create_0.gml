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
	story_map,
	story_status,
	story_cutscene,
	story_battle,
	story_results,
	
	versus_setup,
	versus_select,
	versus_intro,
	versus_battle,
	versus_results,
	
	training_select,
	training
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

enum assist_type {
	a,
	b,
	c
}

enum hitanims {
	normal,
	spinout
}

enum hiteffects {
	punch,
	slash,
	pierce,
	fire,
	fire_dark,
	thunder_blue,
	thunder_yellow,
	thunder_purple,
	wind,
	ice,
	water,
	dark,
	light,
}

globalvar	p1_active_character, p1_char, p1_remaining_chars,
			p1_char_x, p1_char_y, p1_char_facing,

			p1_char_hp, p1_char_hp_percent,
			p1_mp, p1_mp_percent, p1_mp_stocks,
			p1_tp, p1_tp_percent, p1_tp_stocks,
			p1_sp, p1_sp_percent, p1_sp_stocks,
			
			p1_char_assist_timer, p1_char_assist_type,
			
			p1_hitstun, p1_blockstun, p1_is_hit, p1_is_blocking,
			
			p1_combo_hits, p1_combo_damage, p1_combo_timer,
			
			p2_active_character, p2_char, p2_remaining_chars,
			
			p2_char_hp, p2_char_hp_percent,
			p2_mp, p2_mp_percent, p2_mp_stocks,
			p2_tp, p2_tp_percent, p2_tp_stocks,
			p2_sp, p2_sp_percent, p2_sp_stocks,
			
			p2_char_x, p2_char_y, p2_char_facing,
			
			p2_char_assist_timer, p2_char_assist_type,
			
			p2_hitstun, p2_blockstun, p2_is_hit, p2_is_blocking,
			
			p2_combo_hits, p2_combo_damage, p2_combo_timer,
			
			p1_grabbed, p2_grabbed,
			
			p1_color, p2_color, p_color,
			
			ygravity, ground_height, battle_x, battle_y, left_wall, right_wall,
			p1_on_ground, p2_on_ground, p1_is_airborne, p2_is_airborne,
			
			max_mp, max_mp_stocks, mp_stock_size,
			max_tp, max_tp_stocks, tp_stock_size,
			max_sp, max_sp_stocks, sp_stock_size,
			
			assist_a_cooldown, assist_b_cooldown, assist_c_cooldown,
			
			max_buttons, max_team_size, max_level,
			game_state, game_state_previous, game_state_timer, game_state_duration,
			round_state, round_timer, round_state_timer, round_timer_max, round_countdown_duration, round_is_infinite,
			stage,
			
			superfreeze_active, superfreeze_timer, superfreeze_activator,
			p1_super_active, p2_super_active,
			
			screen_shake_x, screen_shake_y, screen_shake_intensity, screen_shake_timer,
			screen_flash_color, screen_flash_timer,
			screen_overlay_sprite, screen_overlay_timer,
			screen_zoom, screen_zoom_target, 
			
			screen_width, screen_height, screen_aspectratio,
			game_width, game_height, game_aspectratio,
			window_width, window_height, window_scale, window_max_scale,
			fullscreen_width, fullscreen_height,
			
			screen_flash_alpha, screen_shake_enabled, screen_overlay_alpha;

max_buttons = 6;

game_state = gamestates.main_menu;
game_state_previous = -1;
game_state_duration = -1;
game_state_timer = -1;

stage = rm_training;
round_state = roundstates.intro;
round_state_timer = 0;
round_timer_max = 300 * 60;
round_timer = round_timer_max;
round_countdown_duration = (3 * 30) + 30;
round_is_infinite = false;

p1_color = make_color_rgb(0,192,255);
p2_color = make_color_rgb(255,64,0);
p_color = make_color_rgb(192,64,255);

for(var i = 0; i < max_team_size; i++) {
	p1_char[i] = noone;
	p1_char_x[i] = 0;
	p1_char_y[i] = 0;
	p1_char_hp[i] = 0;
	p1_char_hp_percent[i] = 0;
	p1_char_facing[i] = 1;
	p1_char_assist_type[i] = assist_type.a;
	p1_char_assist_timer[i] = 0;
	
	p2_char[i] = noone;
	p2_char_x[i] = 0;
	p2_char_y[i] = 0;
	p2_char_hp[i] = 0;
	p2_char_hp_percent[i] = 0;
	p2_char_facing[i] = -1;
	p2_char_assist_type[i] = assist_type.a;
	p2_char_assist_timer[i] = 0;
}

p1_active_character = p1_char[0];
p2_active_character = p2_char[0];

mp_stock_size = 600;
max_mp_stocks = 5;
max_mp = max_mp_stocks * mp_stock_size;

tp_stock_size = 200;
max_tp_stocks = 2;
max_tp = max_tp_stocks * tp_stock_size;

sp_stock_size = 200;
max_sp_stocks = 4;
max_sp = sp_stock_size * max_sp_stocks;

p1_mp = max_mp;
p1_mp_percent = (p1_mp / max_mp) * 100;
p1_mp_stocks = floor(p1_mp / mp_stock_size);

p1_tp = max_tp * 0.1;
p1_tp_percent = (p1_tp / max_tp) * 100;

p1_sp = max_sp;
p1_sp_percent = (p1_sp / max_sp) * 100;
p1_sp_stocks = floor(p1_sp / sp_stock_size);

p1_hitstun = 0;
p1_blockstun = 0;
p1_is_hit = false;
p1_is_blocking = false;
p1_combo_hits = 0;
p1_combo_damage = 0;
p1_combo_timer = 0;
p1_super_active = false;

p1_on_ground = true;
p1_is_airborne = false;

p1_grabbed = false;

p1_remaining_chars = 0;

p2_mp = max_mp;
p2_mp_percent = (p2_mp / max_mp) * 100;
p2_mp_stocks = floor(p2_mp / mp_stock_size);

p2_tp = max_tp * 0.1;
p2_tp_percent = (p2_tp / max_tp) * 100;

p2_sp = max_sp;
p2_sp_percent = (p2_sp / max_sp) * 100;
p2_sp_stocks = floor(p2_sp / sp_stock_size);

p2_hitstun = 0;
p2_blockstun = 0;
p2_is_hit = false;
p2_is_blocking = false;
p2_combo_hits = 0;
p2_combo_damage = 0;
p2_combo_timer = 0;
p2_super_active = false;

p2_on_ground = true;
p2_is_airborne = false;

p2_grabbed = false;

p2_remaining_chars = 0;

p1_up = 0;
p1_down = 0;
p1_left = 0;
p1_right = 0;

p1_up_pressed = 0;
p1_down_pressed = 0;
p1_left_pressed = 0;
p1_right_pressed = 0;

p1_button1 = 0;
p1_button2 = 0;
p1_button3 = 0;
p1_button4 = 0;
p1_button5 = 0;
p1_button6 = 0;

p1_button1_held = 0;
p1_button2_held = 0;
p1_button3_held = 0;
p1_button4_held = 0;
p1_button5_held = 0;
p1_button6_held = 0;

p2_up = 0;
p2_down = 0;
p2_left = 0;
p2_right = 0;

p2_up_pressed = 0;
p2_down_pressed = 0;
p2_left_pressed = 0;
p2_right_pressed = 0;

p2_button1 = 0;
p2_button2 = 0;
p2_button3 = 0;
p2_button4 = 0;
p2_button5 = 0;
p2_button6 = 0;

p2_button1_held = 0;
p2_button2_held = 0;
p2_button3_held = 0;
p2_button4_held = 0;
p2_button5_held = 0;
p2_button6_held = 0;

assist_a_cooldown = 100;
assist_b_cooldown = assist_a_cooldown;
assist_c_cooldown = ceil(max(assist_a_cooldown,assist_b_cooldown) * 3);

superfreeze_active = false;
superfreeze_activator = noone;
superfreeze_timer = 0;

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
	if i != rm_start {
		room_set_width(i,game_width*2);
		room_set_height(i,game_height*2);
	}
}