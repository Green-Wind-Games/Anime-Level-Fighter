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
	
game_width = 640;
game_height = 480;

//game_width = round(game_height * screen_aspectratio);
game_height = round(game_width / screen_aspectratio);

game_aspectratio = game_width / game_height;

gui_width = game_width;
gui_height = game_height;

window_max_scale = floor(min(screen_width / game_width, screen_height / game_height));
if (game_width * window_max_scale) >= screen_width
or (game_height * window_max_scale) >= screen_height {
	window_max_scale -= 1;
}
window_scale = 1;
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
	if instance_exists(obj_char) {
		var playerdist = point_distance(
			p1_active_character.x,
			0,
			p2_active_character.x,
			0
		);
		playerdist += p1_active_character.width_half;
		playerdist += p2_active_character.width_half;
		var max_dist = right_wall-left_wall;
		var desired_zoom = game_width / playerdist;
		desired_zoom = min(desired_zoom,1);
		if superfreeze_active {
			desired_zoom = 2;
			screen_zoom_target = superfreeze_activator;
		}
		else {
			screen_zoom_target = noone;
		}
		screen_zoom = approach(screen_zoom,desired_zoom,0.1);
		
		var _w = round(game_width / screen_zoom);
		var _h = round(game_height / screen_zoom);
		var _w2 = round(_w/2);
		var _h2 = round(_h/2);
		
		camera_set_view_size(view,_w,_h);
		
		var _x = mean(p1_active_character.x,p2_active_character.x);
		var _y = min(
			p1_active_character.y-(p1_active_character.height_half),
			p2_active_character.y-(p2_active_character.height_half)
		);
	
		var _view_x = _x;
		var _view_y = _y;
		if screen_zoom_target != noone {
			_view_x = screen_zoom_target.x;
			_view_y = screen_zoom_target.y-screen_zoom_target.height_half;
		}
		_view_x = median(_view_x,_w2,room_width-_w2);
		_view_y = median(_view_y,_h2,room_height-_h2);
		camera_set_view_pos(view,_view_x-_w2,_view_y-_h2);
	}
	else {
		camera_set_view_size(view,game_width,game_height);
		camera_set_view_pos(view,0,0);
	}
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
	window_set_fullscreen(true);
	surface_resize(application_surface,fullscreen_width,fullscreen_height);
}

function disable_fullscreen() {
	window_set_fullscreen(false);
	surface_resize(application_surface,window_width,window_height);
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

display_set_gui_size(gui_width,gui_height);
resize_window(window_max_scale);
if os_type == os_windows {
	disable_fullscreen();
}
else {
	enable_fullscreen();
}