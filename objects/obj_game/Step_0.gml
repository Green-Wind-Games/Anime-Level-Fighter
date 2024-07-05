update_input();

var _gamestate = game_state;
update_menus();

switch(game_state) {
	case gamestates.main_menu:
	if !instance_exists(obj_menu) {
		open_menu(
			display_get_gui_width()/2,
			display_get_gui_height()/2,
			[
				["Modo História",-1],
				["Modo Arcade",-1],
				["Modo Versus",goto_versus_select],
				["Treinamento",-1],
				["Sair do Jogo",game_end]
			],
			"Menu Principal"
		);
	}
	break;
	
	case gamestates.story_battle:
	case gamestates.versus_battle:
	case gamestates.training:
	if round_state != roundstates.pause {
		update_fight();
	}
	if keyboard_check_pressed(vk_enter) {
		if round_state == roundstates.fight {
			round_state = roundstates.pause;
		}
		else if round_state == roundstates.pause {
			round_state = roundstates.fight;
		}
	}
	break;
	
	case gamestates.story_select:
	case gamestates.versus_select:
	case gamestates.training_select:
	switch(p1_charselect_state) {
		case charselectstates.char:
		if p1_up_pressed {
			if p1_selecting_char < chars_per_row {
				while(p1_selecting_char < max_characters) {
					p1_selecting_char += chars_per_row;
				}
			}
			p1_selecting_char -= chars_per_row;
		}
		if p1_down_pressed {
			if p1_selecting_char >= max_characters - chars_per_row {
				while(p1_selecting_char >= 0) {
					p1_selecting_char -= chars_per_row;
				}
			}
			p1_selecting_char += chars_per_row;
		}
		if p1_left_pressed {
			if p1_selecting_char mod chars_per_row == 0 {
				p1_selecting_char += chars_per_row;
			}
			p1_selecting_char -= 1
		}
		if p1_right_pressed {
			if p1_selecting_char mod chars_per_row == (chars_per_row - 1) {
				p1_selecting_char -= chars_per_row;
			}
			p1_selecting_char += 1
		}
		
		if object_exists(charselect_obj[p1_selecting_char][0]) {
			p1_selected_char[p1_charselect_id] = p1_selecting_char;
			p1_selected_form[p1_charselect_id] = 0;
			p1_selected_assist[p1_charselect_id] = assist_type.a;
			
			p1_selecting_form = 0;
			
			if p1_button1 {
				if array_length(charselect_obj[p1_selecting_char]) > 1 {
					p1_charselect_state = charselectstates.form;
				}
				else {
					if max_team_size > 1 {
						p1_charselect_state = charselectstates.assist;
					}
					else {
						p1_charselect_state = charselectstates.finished;
					}
				}
			}
			if p1_button2 {
				if p1_charselect_id > 0 {
					p1_charselect_state = charselectstates.assist;
					p1_charselect_id -= 1;
				}
			}
		}
		break;
		
		case charselectstates.form:
		if p1_left_pressed {
			if p1_selecting_form <= 0 {
				p1_selecting_form = array_length(charselect_obj[p1_selecting_char]) - 1;
			}
			else {
				p1_selecting_form -= 1;
			}
		}
		if p1_right_pressed {
			if p1_selecting_form >= array_length(charselect_obj[p1_selecting_char]) - 1 {
				p1_selecting_form = 0;
			}
			else {
				p1_selecting_form += 1;
			}
		}
		p1_selected_form[p1_charselect_id] = p1_selecting_form;
		
		if p1_button1 {
			if max_team_size > 1 {
				p1_charselect_state = charselectstates.assist;
			}
			else {
				p1_charselect_state = charselectstates.finished;
			}
		}
		if p1_button2 {
			p1_selected_form[p1_charselect_id] = 0;
			p1_charselect_state = charselectstates.char;
		}
		break;
		
		case charselectstates.assist:
		if p1_left_pressed {
			if p1_selecting_assist <= assist_type.a {
				p1_selecting_assist = assist_type.c;
			}
			else {
				p1_selecting_assist -= 1;
			}
		}
		if p1_right_pressed {
			if p1_selecting_assist >= assist_type.c {
				p1_selecting_assist = assist_type.a;
			}
			else {
				p1_selecting_assist += 1;
			}
		}
		p1_selected_assist[p1_charselect_id] = p1_selecting_assist;
		
		if p1_button1 {
			p1_selected_assist[p1_charselect_id] = p1_selecting_assist;
			if p1_charselect_id >= max_team_size - 1 {
				p1_charselect_state = charselectstates.finished;
			}
			else {
				p1_charselect_state = charselectstates.char;
				p1_charselect_id += 1;
			}
		}
		if p1_button2 {
			p2_selected_assist[p2_charselect_id] = 0;
			if array_length(charselect_obj[p1_selecting_char]) > 1 {
				p1_charselect_state = charselectstates.form;
			}
			else {
				p1_charselect_state = charselectstates.char;
			}
		}
		break;
		
		case charselectstates.finished:
		if p1_button2 {
			if max_team_size > 1 {
				p1_charselect_state = charselectstates.assist;
			}
			else {
				if array_length(charselect_obj[p1_selecting_char]) > 1 {
					p1_charselect_state = charselectstates.form;
				}
				else {
					p1_charselect_state = charselectstates.char;
				}
			}
		}
		break;
	}
	
	switch(p2_charselect_state) {
		case charselectstates.char:
		if p2_up_pressed {
			if p2_selecting_char < chars_per_row {
				while(p2_selecting_char < max_characters) {
					p2_selecting_char += chars_per_row;
				}
			}
			p2_selecting_char -= chars_per_row;
		}
		if p2_down_pressed {
			if p2_selecting_char >= max_characters - chars_per_row {
				while(p2_selecting_char >= 0) {
					p2_selecting_char -= chars_per_row;
				}
			}
			p2_selecting_char += chars_per_row;
		}
		if p2_left_pressed {
			if p2_selecting_char mod chars_per_row == 0 {
				p2_selecting_char += chars_per_row;
			}
			p2_selecting_char -= 1
		}
		if p2_right_pressed {
			if p2_selecting_char mod chars_per_row == (chars_per_row - 1) {
				p2_selecting_char -= chars_per_row;
			}
			p2_selecting_char += 1
		}
		
		if object_exists(charselect_obj[p2_selecting_char][0]) {
			p2_selected_char[p2_charselect_id] = p2_selecting_char;
			p2_selected_form[p2_charselect_id] = 0;
			p2_selected_assist[p2_charselect_id] = assist_type.a;
			
			p2_selecting_form = 0;
			
			if p2_button1 {
				if array_length(charselect_obj[p2_selecting_char]) > 1 {
					p2_charselect_state = charselectstates.form;
				}
				else {
					if max_team_size > 1 {
						p2_charselect_state = charselectstates.assist;
					}
					else {
						p2_charselect_state = charselectstates.finished;
					}
				}
			}
			if p2_button2 {
				if p2_charselect_id > 0 {
					p2_charselect_state = charselectstates.assist;
					p2_charselect_id -= 1;
				}
			}
		}
		break;
		
		case charselectstates.form:
		if p2_left_pressed {
			if p2_selecting_form <= 0 {
				p2_selecting_form = array_length(charselect_obj[p2_selecting_char]) - 1;
			}
			else {
				p2_selecting_form -= 1;
			}
		}
		if p2_right_pressed {
			if p2_selecting_form >= array_length(charselect_obj[p2_selecting_char]) - 1 {
				p2_selecting_form = 0;
			}
			else {
				p2_selecting_form += 1;
			}
		}
		p2_selected_form[p2_charselect_id] = p2_selecting_form;
		
		if p2_button1 {
			if max_team_size > 1 {
				p2_charselect_state = charselectstates.assist;
			}
			else {
				p2_charselect_state = charselectstates.finished;
			}
		}
		if p2_button2 {
			p2_selected_form[p2_charselect_id] = 0;
			p2_charselect_state = charselectstates.char;
		}
		break;
		
		case charselectstates.assist:
		if p2_left_pressed {
			if p2_selecting_assist <= assist_type.a {
				p2_selecting_assist = assist_type.c;
			}
			else {
				p2_selecting_assist -= 1;
			}
		}
		if p2_right_pressed {
			if p2_selecting_assist >= assist_type.c {
				p2_selecting_assist = assist_type.a;
			}
			else {
				p2_selecting_assist += 1;
			}
		}
		p2_selected_assist[p2_charselect_id] = p2_selecting_assist;
		if p2_button1 {
			if p2_charselect_id >= max_team_size - 1 {
				p2_charselect_state = charselectstates.finished;
			}
			else {
				p2_charselect_state = charselectstates.char;
				p2_charselect_id += 1;
			}
		}
		if p2_button2 {
			p2_selected_assist[p2_charselect_id] = 0;
			if array_length(charselect_obj[p2_selecting_char]) > 1 {
				p2_charselect_state = charselectstates.form;
			}
			else {
				p2_charselect_state = charselectstates.char;
			}
		}
		break;
		
		case charselectstates.finished:
		if p2_button2 {
			if max_team_size > 1 {
				p2_charselect_state = charselectstates.assist;
			}
			else {
				if array_length(charselect_obj[p2_selecting_char]) > 1 {
					p2_charselect_state = charselectstates.form;
				}
				else {
					p2_charselect_state = charselectstates.char;
				}
			}
		}
		break;
	}
	
	if p1_charselect_state == charselectstates.finished
	and p2_charselect_state == charselectstates.finished {
		game_state = gamestates.versus_intro;
	}
	break;
}
	
game_state_timer += 1;
if game_state_duration != -1 {
	if game_state_timer >= game_state_duration {
		switch(game_state) {
			case gamestates.versus_intro:
			game_state = gamestates.versus_battle;
			break;
		}
	}
}

if _gamestate != game_state {
	game_state_previous = _gamestate;
	game_state_timer = 0;
	game_state_duration = -1;
}

if game_state_timer <= 0 {
	switch(game_state) {
		case gamestates.versus_select:
		room_goto(rm_charselect);
		break;
		
		case gamestates.versus_intro:
		game_state_duration = 360;
		audio_stop_sound(music);
		play_sound(mus_slammasters_versus);
		break;
		
		case gamestates.story_battle:
		case gamestates.versus_battle:
		case gamestates.training:
		room_goto(stage);
		break;
	}
}

update_particles();
update_music();

update_view();

with(all) {
	visible = false;
}
visible = true;