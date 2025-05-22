var _drop_timer = 60 * 2;

for(var i = 0; i < array_length(player_input); i++) {
	with(player_input[i]) {
		if menu_confirm or up_pressed or down_pressed {
			with(other) {
				assigned_input = i;
				input_drop_timer = _drop_timer;
				//hover_marker = "[P" + string(i+1) + "]> ";
			}
		}
	}
}

if assigned_input != -1 {
	var _hover = hover;
	
	if player_input[assigned_input].up_pressed {
		hover--;
	}
	if player_input[assigned_input].down_pressed {
		hover++;
	}

	if hover != _hover {
		input_drop_timer = _drop_timer;
		play_sound(snd_ui_menu_scroll,1,1);
	}
	
	if hover >= options_count {
		hover = 0;
	}
	else if hover < 0 {
		hover = options_count-1;
	}

	if player_input[assigned_input].menu_confirm {
		for(var i = 1; i < array_length(options[hover]); i++) {
			var _func = options[hover][i];
			if (_func != -1) then _func();
		}
		play_sound(snd_ui_menu_select,1,1);
		instance_destroy();
	}

	if input_drop_timer-- <= 0 {
		assigned_input = -1;
		//hover_marker = "[P?]> ";
	}
}