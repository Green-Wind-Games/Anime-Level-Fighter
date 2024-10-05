/// @description Insert description here
// You can write your code in this editor

if !window_get_fullscreen() {
	if keyboard_check_pressed(vk_f1) {
		resize_window(1);
	}
	if keyboard_check_pressed(vk_f2) {
		resize_window(-1);
	}
	if keyboard_check_pressed(vk_f3) {
		resize_window(window_max_scale);
	}
}

if keyboard_check_pressed(vk_f4) {
	toggle_fullscreen();
}

if keyboard_check_pressed(vk_f5) {
	for(var i = 0; i < max_players; i++) {
		with(player[i]) {
			input = player_input[i+11];
		}
	}
}
if keyboard_check_pressed(vk_f6) {
	for(var i = 0; i < max_players; i++) {
		with(player[i]) {
			input = player_input[player_slot[i]];
		}
	}
}

if keyboard_check(vk_insert) {
	with(obj_char) {
		hp = max_hp;
		mp = max_mp;
		tp = max_tp;
	}
}
if keyboard_check(vk_home) {
	with(obj_char) {
		hp = max_hp / 4;
		mp = mp_stock_size;
		tp = tp_stock_size;
	}
}
if keyboard_check_pressed(vk_pageup) {
	with(obj_char) {
		xp = max_xp;
	}
}
if keyboard_check_pressed(vk_delete) {
	with(player[0]) {
		dead = true;
		take_damage(noone,max_hp * 10,true);
		change_state(hard_knockdown_state);
		xspeed = -3 * facing;
		yspeed = -5;
	}
}

if keyboard_check_pressed(ord("0")) {
	round_timer = 0;
}

var _fps = game_get_speed(gamespeed_fps);
var _change = 6;

if keyboard_check_pressed(vk_add) {
	game_set_speed(game_get_speed(gamespeed_fps) + _change, gamespeed_fps);
}
if keyboard_check_pressed(vk_subtract) and (_fps > _change) {
	game_set_speed(game_get_speed(gamespeed_fps) - _change, gamespeed_fps);
}
if keyboard_check_pressed(vk_multiply) {
	game_set_speed(60, gamespeed_fps);
}

with(all) {
	visible = false;
}
visible = true;