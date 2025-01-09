function test_ai_matchup(_char1,_char2) {
	if timeskip_active return;
	
	audio_stop_all();
	var _char1_wins = 0;
	var _char2_wins = 0;
	var _round = 0;
	show_debug_message("test_ai_matchup() is now running.");
	for(var i = 0; i < 10; i++) {
		_round = string(i+1);
		change_gamestate(gamestates.versus_select);
		while(game_state != gamestates.versus_select) {
			timeskip();
		}
		stage = rm_training;
		player_slot[0] = player_input[0];
		player_slot[1] = player_input[1];
		player_char[0] = _char1;
		player_char[1] = _char2;
		change_gamestate(gamestates.versus_battle);
		while(game_state != gamestates.versus_battle) {
			timeskip();
		}
		//change_ai_level(ai_level_max);
		show_debug_message("ai matchup round " + _round + " starting now");
		with(obj_char) {
			input = instance_create(0,0,obj_input);
			with(input) {
				type = input_types.ai;
				persistent = false;
			}
		}
		while(game_state == gamestates.versus_battle) {
			timeskip();
			with(obj_char) {
				if state_timer > 600 {
					show_debug_message("oh shit, im stuck");
				}
			}
		}
		if get_team_score(1) > get_team_score(2) {
			_char1_wins++;
			show_debug_message("char 1 won round " + _round);
		}
		else if get_team_score(1) < get_team_score(2) {
			_char2_wins++;
			show_debug_message("char 2 won round " + _round);
		}
	}
	show_debug_message("char 1 won " + string(_char1_wins) + " matches");
	show_debug_message("char 2 won " + string(_char2_wins) + " matches");
	change_gamestate(gamestates.versus_select);
}

function test_ai_matchup_live(_char1,_char2) {
	if timeskip_active return;
	
	show_debug_message("test_ai_matchup_live()");
	change_gamestate(gamestates.versus_select);
	while(game_state != gamestates.versus_select) {
		timeskip();
	}
	stage = rm_training;
	player_slot[0] = player_input[0];
	player_slot[1] = player_input[1];
	player_char[0] = _char1;
	player_char[1] = _char2;
	change_gamestate(gamestates.versus_battle);
	while(game_state != gamestates.versus_battle) {
		timeskip();
	}
	//change_ai_level(ai_level_max);
	with(obj_char) {
		input = instance_create(0,0,obj_input);
		with(input) {
			type = input_types.ai;
			persistent = false;
		}
	}
}