randomize();

function change_gamestate(_gamestate, _wait = 0) {
	next_game_state = _gamestate;
	game_state_timer = min(game_state_timer,screen_fade_duration);
	game_state_duration = _wait + (screen_fade_duration*2);
}

function run_gamestate() {
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
	
		case gamestates.versus_vs:
		//if (game_state_timer > game_state_duration - screen_fade_duration) {
		//and (game_state_timer < game_state_duration - screen_fade_duration) {
		//	for(var i = 0; i < max_players; i++) {
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

	game_state_timer += 1;
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

	game_substate_timer += 1;
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
			texture_prefetch("Portraits");
			room_goto(rm_versus_charselect);
			break;
		
			case gamestates.versus_vs:
			texture_prefetch("Portraits");
			room_goto(rm_versus);
			change_gamestate(gamestates.versus_battle,vs_fadeout_time - vs_fadein_duration - vs_fadeout_duration);
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

function run_game_substate() {
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

function update_fight() {
	round_state_timer += 1;
	var _roundstate = round_state;
	if round_state == roundstates.intro {
		var ready = round_state_timer > 60;
		with(obj_char) {
			if active_state != idle_state { ready = false; }
			if sound_is_playing(voice) { ready = false; }
			if state_timer < 60 { ready = false; }
		}
		if ready {
			round_state = roundstates.countdown;
		}
	}
	else if round_state == roundstates.countdown {
		if round_state_timer >= round_countdown_duration {
			round_state = roundstates.fight;
		}
	}
	else if round_state == roundstates.fight {
		round_timer -= 1;
		if round_timer <= 0 {
			round_state = roundstates.time_over;
		}
		
		var alldead = instance_number(obj_char) - instance_number(obj_helper);
		with(obj_char) {
			if !dead {
				alldead -= is_char(id);
			}
		}
		if alldead {
			round_state = roundstates.knockout;
			play_sound(snd_round_end_knockout);
		}
	}
	else if round_state == roundstates.time_over or round_state == roundstates.knockout {
		var ready = round_state_timer > 60;
		with(obj_char) {
			if dead {
				if active_state != liedown_state { ready = false; }
			}
			else {
				if active_state != idle_state { ready = false; }
			}
			if state_timer < 60 { ready = false; }
		}
		if ready {
			round_state = roundstates.victory;
		}
	}
	else if round_state == roundstates.victory {
		var team1_score = get_team_score(1);
		var team2_score = get_team_score(2);
		var ready = round_state_timer > 60;
		with(obj_char) {
			if active_state == idle_state {
				if (team == 1 and (team1_score > team2_score))
				or (team == 2 and (team2_score > team1_score)) {
					change_state(victory_state);
				}
				else {
					change_state(defeat_state);
				}
			}
			if !anim_finished { ready = false; }
			if sound_is_playing(voice) { ready = false; }
			if state_timer < 60 { ready = false; }
		}
		if ready {
			if next_game_state == -1 {
				change_gamestate(game_state+1);
				if next_game_state == gamestates.training + 1 {
					change_gamestate(gamestates.training);
				}
			}
		}
	}
	if round_state != _roundstate {
		round_state_timer = 0;
	}
	
	var border = 16;
	var _x1 = room_width;
	var _y1 = room_height;
	var _x2 = 0;
	var _y2 = 0;
	with(obj_char) {
		if (!dead) and (!is_helper(id)) {
			_x1 = min(_x1,x);
			_y1 = min(_y1,y);
			_x2 = max(_x2,x);
			_y2 = max(_y2,y);
		}
	}
	battle_x = mean(_x1,_x2);
	battle_y = mean(_y1,_y2);
	var battle_size = game_width;
	left_wall = clamp(battle_x - (battle_size / 2),0,room_width-game_width) + border;
	right_wall = clamp(battle_x + (battle_size / 2),game_width,room_width) - border;
	
	if superfreeze_timer > 0 {
		superfreeze_active = true;
		superfreeze_timer -= 1;
	}
	else {
		superfreeze_active = false;
		superfreeze_activator = noone;
		superfreeze_timer = 0;
	}
	
	if timestop_timer > 0 {
		timestop_active = true;
		timestop_timer -= 1;
	}
	else {
		timestop_active = false;
		timestop_activator = noone;
		timestop_timer = 0;
	}
}