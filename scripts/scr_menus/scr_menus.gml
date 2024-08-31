// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function open_menu(_x,_y,_options,_description = -1) {
	with(instance_create(_x,_y,obj_menu)) {
		options = _options;
		description = _description;
		options_count = array_length(options);
		hover_marker = "-> ";
		
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
		
		width_full = width + margin;
		height_full = height + (margin*2);
		x -= (width_full / 2);
		y -= (height_full / 2);
		
		player2 = false;
		
		return id;
	}
}

function open_p2_menu(_x,_y,_options,_description = -1) {
	open_menu(_x,_y,_options,_description).player2 = true;
}

function update_menus() {
	with(obj_menu) {
		var _hover = hover;
		if player2 == false {
			hover += obj_game.p1_down_pressed-obj_game.p1_up_pressed;
		}
		else {
			hover += obj_game.p2_down_pressed-obj_game.p2_up_pressed;
		}

		if _hover != hover {
			if hover >= options_count then hover = 0;
			if hover < 0 then hover = options_count - 1;
			play_sound(snd_menu_scroll);
		}

		if (player2 == false and obj_game.p1_button1) or (player2 == true and obj_game.p2_button1) {
			var _func = options[hover][1];
			if _func != -1 then _func();
			play_sound(snd_menu_select);
			instance_destroy();
		}
	}
}

function goto_versus_select() {
	game_state = gamestates.versus_select;
}