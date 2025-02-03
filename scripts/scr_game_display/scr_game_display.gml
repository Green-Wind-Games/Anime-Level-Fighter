globalvar	screen_width, screen_height, screen_aspectratio,
			game_width, game_height, game_aspectratio,
			gui_width, gui_height, hud_height,
			window_width, window_height, window_scale, window_max_scale,
			fullscreen_scale, fullscreen_width, fullscreen_height,
			screen_fade_color, screen_fade_duration, screen_fade_type;

screen_width = display_get_width();
screen_height = display_get_height();
screen_aspectratio = screen_width / screen_height;

var _test = false;
var _factor = 0.75;

game_width = 640;
game_height = 360;

if os_type == os_android or _test {
	game_width = floor(game_width * _factor);
	game_height = floor(game_height * _factor);
}

//game_width = round(game_height * (4 / 3));
//game_height = round(game_width / (4 / 3));
//game_width = round(game_height * (16 / 9));
game_height = round(game_width / (16 / 9));
//game_width = round(game_height * screen_aspectratio);
//game_height = round(game_width / screen_aspectratio);

game_aspectratio = game_width / game_height;

window_max_scale = min(screen_width / game_width, (screen_height - 80) / game_height);
//if (game_width * window_max_scale) >= screen_width
//or (game_height * window_max_scale) >= (screen_height - 48) {
//	window_max_scale -= 1;
//}
window_max_scale = max(1,window_max_scale);
window_scale = window_max_scale;
window_width = round(game_width * window_scale);
window_height = round(game_height * window_scale);

fullscreen_scale = min(screen_width / game_width, screen_height / game_height);
fullscreen_width = floor(game_width * fullscreen_scale);
fullscreen_height = floor(game_height * fullscreen_scale);

var gui_scale = 0.75;

gui_width = round(game_width * gui_scale);
gui_height = round(game_height * gui_scale);

if os_type == os_android or _test {
	gui_width = floor(gui_width * _factor);
	gui_height = floor(gui_height * _factor);
}

hud_height = gui_height / 3;

screen_fade_color = c_black;
screen_fade_duration = 30;
screen_fade_type = fade_types.normal;

function init_view() {
	view_enabled = true;
	view_visible[0] = true;
	#macro view view_camera[0]
	camera_set_view_size(view,game_width,game_height);
}

function update_view() {
	if screen_shake_timer > 0 {
		screen_shake_timer -= game_speed;
		screen_shake_x = sine_wave(screen_shake_timer,4,screen_shake_intensity/2,0);
		screen_shake_y = sine_wave(screen_shake_timer+1,4,screen_shake_intensity,0);
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
		if ((!dead) or (xspeed != 0) or (yspeed != 0)) and is_char(id) {
			_x1 = min(_x1,x-width_half);
			_y1 = min(_y1,y-height);
			_x2 = max(_x2,x+width_half);
			_y2 = max(_y2,y);
		}
	}
	
	var playerdist = abs(_x1 - _x2);
	var max_dist = (right_wall-left_wall) + 25;
	var desired_zoom = game_width / (min(playerdist+50,max_dist));
	desired_zoom = min(desired_zoom,1.25);
	if superfreeze_active {
		desired_zoom = 1.5;
	}
	if game_state == gamestates.versus_results {
		desired_zoom = 1;
		screen_zoom_target = noone;
	}
	screen_zoom = approach(screen_zoom,desired_zoom,1/10);
	
	var _w = round(game_width / screen_zoom);
	var _h = round(game_height / screen_zoom);
	var _w2 = round(_w/2);
	var _h2 = round(_h/2);
	
	var _view_x = mean(_x1,_x2);
	var _view_y = lerp(_y1,_y2,0.25);
	
	if superfreeze_active {
		_view_x = superfreeze_activator.x;
		_view_y = superfreeze_activator.y-superfreeze_activator.height_half;
	}
	
	_view_x = clamp(_view_x,_w2,room_width-_w2-1);
	_view_y = clamp(_view_y,_h2,room_height-_h2-1);
	
	_view_x += screen_shake_x;
	_view_y += screen_shake_y;
		
	camera_set_view_size(view,_w,_h);
	camera_set_view_pos(view,_view_x-_w2,_view_y-_h2);
}

function resize_window(_factor = 0) {
	_factor = round(_factor);
	window_scale += _factor;
	window_scale = round(window_scale);
	if window_scale < 1 {
		window_scale = 1;
	}
	else if window_scale > window_max_scale {
		window_scale = window_max_scale;
	}
	window_width = round(game_width * window_scale);
	window_height = round(game_height * window_scale);
	reposition_window();
}

function reposition_window() {
	window_set_rectangle(
		clamp((screen_width/2)-(window_width/2),0,screen_width),
		clamp(((screen_height-40)/2)-(window_height/2),32,screen_height),
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

function shake_screen(_duration, _intensity = 1) {
	if screen_shake_timer <= 1 {
		screen_shake_timer = _duration;
	}
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
	if os_type == os_android {
		var _flags = 1024|4096;
		display_set_ui_visibility(_flags);
	}
}
//enable_fullscreen();