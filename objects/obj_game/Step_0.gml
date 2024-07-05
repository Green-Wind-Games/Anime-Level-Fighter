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
	update_charselect();
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