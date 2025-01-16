enum gamestates {
	intro,
	title,
	main_menu,
	options,
	
	story_select,
	story_cutscene,
	story_vs,
	story_battle,
	story_results,
	
	arcade_select,
	arcade_vs,
	arcade_battle,
	arcade_results,
	
	versus_setup,
	versus_select,
	versus_vs,
	versus_battle,
	versus_results,
	
	training_select,
	training,
	
	credits
}



function change_gamestate(_gamestate, _wait = 0) {
	next_game_state = _gamestate;
	game_state_timer = min(game_state_timer,screen_fade_duration);
	game_state_duration = _wait + (screen_fade_duration*2);
}

function update_gamestate() {
	var _gamestate = game_state;
	var _gamesubstate = game_substate;
	
	var _nextstate = next_game_state;
	var _nextsubstate = next_game_substate;

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
					//["Story Mode",-1],
					//["Arcade Mode",-1],
					["Versus Mode",goto_versus_select],
					//["Training Mode",-1],
					//["Settings",-1],
					["Quit Game",game_end]
				],
				"Main Menu"
			);
		}
		break;
	
		case gamestates.story_select:
		case gamestates.versus_select:
		case gamestates.training_select:
		update_charselect();
		break;
	
		case gamestates.versus_vs:
		var _min_time = vs_fadein_duration;
		var _max_time = game_state_duration - vs_fadeout_duration;
		if value_in_range(game_state_timer,_min_time,_max_time) {
			for(var i = 0; i < max_players; i++) {
				if player_slot[i] != noone {
					if player_input[player_slot[i]].confirm {
						game_state_timer = _max_time + 1;
					}
				}
			}
		}
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
			for(var i = 0; i < max_players; i++) {
				if player_slot[i] != noone {
					if player_input[player_slot[i]].confirm {
						change_gamestate(gamestates.versus_select);
					}
				}
			}
		}
		break;
	}

	game_state_timer += game_speed;
	if next_game_state != -1 {
		if game_state_timer >= game_state_duration {
			game_state = next_game_state;
		
			game_state_timer = 0;
			game_substate_duration = -1;
			next_game_state = -1;
		
			game_substate = 0;
		
			game_substate_timer = 0;
			game_substate_duration = -1;
			next_game_substate = -1;
		}
	}

	game_substate_timer += game_speed;
	if next_game_substate != -1 {
		if game_substate_timer >= game_substate_duration {
			game_substate = next_game_state;
			game_substate_timer = 0;
			next_game_substate = -1;
		}
	}

	if _gamestate != game_state {
		previous_game_state = _gamestate;
		game_state_timer = 0;
		game_state_duration = -1;
	
		game_substate = 0;
		game_state_timer = 0;
		game_substate_duration = -1;

		stop_music();
	
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
			texture_prefetch("Icons");
			texture_prefetch("Portraits");
			room_goto(rm_versus_charselect);
			break;
			
			case gamestates.versus_vs:
			texture_prefetch("Portraits");
			room_goto(rm_versus);
			change_gamestate(
				gamestates.versus_battle,
				vs_fadeout_time - vs_fadein_duration - vs_fadeout_duration
			);
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

	if game_substate != _gamesubstate {
		previous_game_substate = _gamesubstate;
		game_substate_timer = 0;
		game_substate_duration = -1;
	}
}

function update_game_substate() {
	switch(game_state) {
		case gamestates.versus_vs:
		switch(game_substate) {
			case vs_screen_substates.fadein:
			next_game_substate = vs_screen_substates.slidein;
			game_substate_duration = vs_fadein_duration;
			break;
			
			case vs_screen_substates.slidein:
			next_game_substate = vs_screen_substates.vs_slidein;
			game_substate_duration = vs_slidein_duration;
			break;
			
			case vs_screen_substates.vs_slidein:
			next_game_substate = vs_screen_substates.slideout;
			game_substate_duration = vs_slidein2_duration;
			break;
			
			case vs_screen_substates.slideout:
			next_game_substate = vs_screen_substates.fadeout;
			game_substate_duration = vs_slideout_duration;
			break;
			
			case vs_screen_substates.fadeout:
			next_game_substate = vs_screen_substates.fadeout;
			game_substate_duration = vs_fadeout_duration;
			break;
		}
		break;
	}
}