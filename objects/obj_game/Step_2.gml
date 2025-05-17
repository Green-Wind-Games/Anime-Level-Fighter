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

debug_step();

with(all) {
	visible = false;
}
visible = true;