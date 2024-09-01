var _gamestate = game_state;
var _nextstate = next_game_state;

switch(game_state) {
	default:
	game_state++;
	break;
	
	case gamestates.main_menu:
	if next_game_state != -1 break;
	
	if !instance_exists(obj_menu) {
		open_menu(
			gui_width/2,
			gui_height/2,
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
	
	case gamestates.story_select:
	case gamestates.versus_select:
	case gamestates.training_select:
	update_charselect();
	break;
	
	case gamestates.versus_intro:
	// check inputs to speed up this screen
	break;
	
	case gamestates.story_battle:
	case gamestates.versus_battle:
	case gamestates.training:
	if keyboard_check_pressed(ord("P")) {
		if round_state == roundstates.fight {
			round_state = roundstates.pause;
		}
		else if round_state == roundstates.pause {
			round_state = roundstates.fight;
		}
	}
	if round_state != roundstates.pause {
		update_fight();
	}
	break;
}

if _nextstate != next_game_state {
	if next_game_state != -1 {
		game_state_timer = 0;
	}
}

game_state_timer += 1;
if game_state_duration != -1 {
	if game_state_timer >= game_state_duration {
		game_state = next_game_state;
		next_game_state = -1;
	}
}

if _gamestate != game_state {
	previous_game_state = _gamestate;
	game_state_timer = 0;
	game_state_duration = -1;
	screen_fade_alpha = 1;
	switch(game_state) {
		case gamestates.intro:
		room_goto(rm_intro);
		break;
		
		case gamestates.title:
		room_goto(rm_titlescreen);
		break;
		
		case gamestates.main_menu:
		room_goto(rm_mainmenu);
		break;
		
		case gamestates.story_select:
		case gamestates.versus_select:
		case gamestates.training_select:
		room_goto(rm_charselect);
		break;
		
		case gamestates.versus_intro:
		room_goto(rm_versus);
		next_game_state = gamestates.versus_battle;
		game_state_duration = 60 * 5;
		break;
		
		case gamestates.story_battle:
		case gamestates.versus_battle:
		case gamestates.training:
		room_goto(stage);
		break;
	}
}

switch(game_state) {
	default:
	update_particles();
	break;
		
	case gamestates.story_battle:
	case gamestates.versus_battle:
	case gamestates.training:
	if round_state != roundstates.pause {
		update_particles();
	}
	break;
}

update_music();

update_view();

var _fade = 0;
if (game_state_duration != -1) 
and (game_state_timer >= (game_state_duration - screen_fade_duration)) {
	_fade = 1;
}
screen_fade_alpha = approach(screen_fade_alpha,_fade,1/screen_fade_duration);