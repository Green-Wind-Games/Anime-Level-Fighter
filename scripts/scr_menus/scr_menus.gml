// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function open_menu(_x,_y,_options,_description = -1) {
	with(instance_create(_x,_y,obj_menu)) {
		options = _options;
		description = _description;
		options_count = array_length(options);
		hover_marker = "> ";
		
		margin = 8;
		draw_set_font(fnt_menu);
		
		width = 1;
		if description != -1 width = max(width,string_width(description));
		for(var i = 0; i < options_count; i++) {
			width = max(width,string_width(options[i][0]));
		}
		width += string_width(hover_marker);
		
		height_line = string_height("ABC");
		height = height_line * (options_count + (description != -1));
		
		width_full = width + (margin*2);
		height_full = height + (margin*2);
		x -= (width_full / 2);
		y -= (height_full / 2);
		
		return id;
	}
}

function goto_versus_select() {
	change_gamestate(gamestates.versus_select);
}

function goto_training_select() {
	change_gamestate(gamestates.training_select);
}

function goto_training() {
	change_gamestate(gamestates.training);
}