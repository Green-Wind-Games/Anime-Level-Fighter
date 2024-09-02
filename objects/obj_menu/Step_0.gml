var _hover = hover;
var mouse_over = false;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

if point_in_rectangle(mx,my,x,y,x+width,y+height) {
	mouse_over = true;
	var _mouse_hover_line = (my - y) div height_line;
	if (description != -1) then _mouse_hover_line -= 1;
	_mouse_hover_line = clamp(_mouse_hover_line,0,options_count-1);
	hover = _mouse_hover_line;
}

if hover != _hover {
	play_sound(snd_menu_scroll);
}

if (mouse_over) and (mouse_check_button_pressed(mb_left)) {
	for(var i = 1; i < array_length(options[hover]); i++) {
		var _func = options[hover][i];
		if (_func != -1) then _func();
	}
	play_sound(snd_menu_select);
	instance_destroy();
}