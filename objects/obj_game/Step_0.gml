var _gamestate = game_state;
var _nextstate = next_game_state;

switch(game_state) {
	default:
	game_state++;
	if game_state > gamestates.credits {
		game_state = 0;
	}
	break;
	
	case gamestates.main_menu:
	if next_game_state != -1 break;
	
	if !instance_exists(obj_menu) {
		open_menu(
			gui_width/2,
			gui_height/2,
			[
				//["Modo História",-1],
				//["Modo Arcade",-1],
				["Modo Versus",goto_versus_select],
				//["Treinamento",-1],
				//["Configurações",-1],
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
	//if (game_state_timer > game_state_duration - screen_fade_duration) {
	//and (game_state_timer < game_state_duration - screen_fade_duration) {
	//	for(var i = 0; i < array_length(player_slot); i++) {
	//		if player_slot[i] != noone {
	//			if player_input[player_slot[i]].confirm {
	//				change_gamestate(next_game_state,0);
	//			}
	//		}
	//	}
	//}
	break;
	
	case gamestates.story_battle:
	case gamestates.arcade_battle:
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
	
	case gamestates.versus_results:
	if (game_state_timer > (3 * 60)) and (next_game_state == -1) {
		for(var i = 0; i < array_length(player_slot); i++) {
			if player_slot[i] != noone {
				if player_input[player_slot[i]].confirm {
					change_gamestate(gamestates.versus_select);
				}
			}
		}
	}
	break;
}

game_state_timer += 1;
if next_game_state != -1 {
	if game_state_timer >= game_state_duration {
		game_state = next_game_state;
		game_state_timer = 0;
		next_game_state = -1;
	}
}
else {
	game_state_timer = min(game_state_timer,screen_fade_duration);
}

if _gamestate != game_state {
	previous_game_state = _gamestate;
	game_state_timer = 0;
	game_state_duration = -1;
	screen_fade_alpha = 1;
	
	draw_texture_flush();
	texture_prefetch("Default");
	
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
		
		case gamestates.versus_select:
		texture_prefetch("Portraits");
		room_goto(rm_versus_charselect);
		break;
		
		case gamestates.versus_intro:
		texture_prefetch("Portraits");
		room_goto(rm_versus);
		change_gamestate(gamestates.versus_battle,(5*60)-screen_fade_duration);
		break;
		
		case gamestates.story_battle:
		case gamestates.versus_battle:
		case gamestates.training:
		texture_prefetch("SpecialEffects");
		room_goto(stage);
		break;
		
		case gamestates.versus_results:
		texture_prefetch("SpecialEffects");
		with(obj_char) {
			persistent = input.persistent;
			hp = max_hp;
			dead = false;
		}
		room_goto(rm_versus_results);
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