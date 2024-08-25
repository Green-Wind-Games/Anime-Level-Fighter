// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

globalvar	screen_width, screen_height, screen_aspectratio,
			game_width, game_height, game_aspectratio,
			gui_width, gui_height,
			window_width, window_height, window_scale, window_max_scale,
			fullscreen_width, fullscreen_height;

screen_width = display_get_width();
screen_height = display_get_height();
screen_aspectratio = screen_width / screen_height;
	
game_width = 520;
game_height = 390;

//game_width = round(game_height * (16 / 9));
game_height = round(game_width / (16 / 9));

//game_width = round(game_height * screen_aspectratio);
//game_height = round(game_width / screen_aspectratio);

game_aspectratio = game_width / game_height;

gui_width = game_width;
gui_height = game_height;

window_max_scale = floor(min(screen_width / game_width, screen_height / game_height));
if (game_width * window_max_scale) >= screen_width
or (game_height * window_max_scale) >= (screen_height - 48) {
	window_max_scale -= 1;
}
window_max_scale = max(1,window_max_scale);
window_scale = window_max_scale;
window_width = game_width * window_scale;
window_height = game_height * window_scale;
	
fullscreen_width = round(screen_height * game_aspectratio);
fullscreen_height = screen_height;

function init_view() {
	view_enabled = true;
	view_visible[0] = true;
	#macro view view_camera[0]
	camera_set_view_size(view,game_width,game_height);
}

function update_view() {
	if screen_shake_timer > 0 {
		screen_shake_timer--;
		screen_shake_x = random(screen_shake_intensity / 2) * choose(1,-1);
		screen_shake_y = random(screen_shake_intensity) * choose(1,-1);
	}
	else {
		screen_shake_timer = 0;
		screen_shake_x = 0;
		screen_shake_y = 0;
	}
	var _x1 = room_width;
	var _y1 = room_height;
	var _x2 = 0;
	var _y2 = 0;
	with(obj_char) {
		if (!dead) or (xspeed != 0) or (yspeed != 0) {
			_x1 = min(_x1,x-width_half);
			_y1 = min(_y1,y-height);
			_x2 = max(_x2,x+width_half);
			_y2 = max(_y2,y);
		}
	}
	
	var playerdist = abs(_x1 - _x2);
	var max_dist = (right_wall-left_wall) + 30;
	var desired_zoom = game_width / (min(playerdist+100,max_dist));
	desired_zoom = min(desired_zoom,1.2);
	if superfreeze_active {
		desired_zoom = 1.25;
		screen_zoom_target = superfreeze_activator;
	}
	else {
		screen_zoom_target = noone;
	}
	screen_zoom = approach(screen_zoom,desired_zoom,1/15);
	
	var _w = round(game_width / screen_zoom);
	var _h = round(game_height / screen_zoom);
	var _w2 = round(_w/2);
	var _h2 = round(_h/2);
	
	var _view_x = battle_x;
	var _view_y = battle_y;
	
	if screen_zoom_target != noone {
		_view_x = screen_zoom_target.x;
		_view_y = screen_zoom_target.y-screen_zoom_target.height_half;
	}
	
	_view_x = median(_view_x,_w2,room_width-_w2);
	_view_y = median(_view_y,_h2,room_height-_h2);
	
	_view_x += screen_shake_x;
	_view_y += screen_shake_y;
		
	camera_set_view_size(view,_w,_h);
	camera_set_view_pos(view,_view_x-_w2,_view_y-_h2);
}

function resize_window(_factor = 0) {
	window_scale += _factor;
	if window_scale < 1 {
		window_scale = 1;
	}
	else if window_scale > window_max_scale {
		window_scale = window_max_scale;
	}
	window_width = game_width * window_scale;
	window_height = game_height * window_scale;
	reposition_window();
}

function reposition_window() {
	window_set_rectangle(
		(screen_width/2)-(window_width/2),
		(screen_height/2)-(window_height/2),
		window_width,
		window_height
	);
}

function enable_fullscreen() {
	surface_resize(application_surface,fullscreen_width,fullscreen_height);
	window_set_fullscreen(true);
}

function disable_fullscreen() {
	surface_resize(application_surface,window_width,window_height);
	window_set_fullscreen(false);
	reposition_window();
}

function toggle_fullscreen() {
	if window_get_fullscreen() {
		disable_fullscreen();
	}
	else {
		enable_fullscreen();
	}
}

function shake_screen(_duration, _intensity) {
	screen_shake_timer = _duration;
	screen_shake_intensity = _intensity;
}

window_enable_borderless_fullscreen(true);
display_set_gui_size(gui_width,gui_height);
resize_window(window_max_scale);
if os_type == os_windows {
	disable_fullscreen();
}
else {
	enable_fullscreen();
}