/// @description Insert description here
// You can write your code in this editor

if !window_get_fullscreen() {
	if keyboard_check_pressed(vk_f1) {
		resize_window(1);
	}
	if keyboard_check_pressed(vk_f2) {
		resize_window(-1);
	}
}

if keyboard_check_pressed(vk_f4) {
	toggle_fullscreen();
}

if keyboard_check_pressed(vk_f5) {
	with(obj_char) {
		ai_enabled = true;
	}
}
if keyboard_check_pressed(vk_f6) {
	with(obj_char) {
		ai_enabled = false;
	}
}

if keyboard_check_pressed(vk_insert) {
	with(obj_char) {
		mp += mp_stock_size;
	}
}
if keyboard_check_pressed(vk_delete) {
	with(obj_char) {
		hp = map_value(transform_min_hp_percent,0,100,0,max_hp) + 1;
	}
}

with(all) {
	visible = false;
}
visible = true;