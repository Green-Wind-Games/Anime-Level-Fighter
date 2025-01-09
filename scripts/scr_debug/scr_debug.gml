function test_ai_matchup(_char1,_char2) {
	var _char1_wins = 0;
	var _char2_wins = 0;
	repeat(10) {
		stage = rm_training;
		player_slot[0] = player_input[0];
		player_slot[1] = player_input[1];
		player_char[0] = _char1;
		player_char[1] = _char2;
		change_gamestate(gamestates.versus_battle);
		while(game_state != gamestates.versus_battle) {
			timeskip(60);
		}
		change_ai_level(ai_level_max);
		with(obj_char) {
			input = instance_create(0,0,obj_input);
			with(input) {
				type = input_types.ai;
				persistent = false;
			}
		}
		while(game_state == gamestates.versus_battle) {
			timeskip(60);
		}
		if get_team_score(1) > get_team_score(2) {
			_char1_wins++;
		}
		else if get_team_score(1) < get_team_score(2) {
			_char2_wins++;
		}
	}
	show_debug_message("char 1 won " + string(_char1_wins) + " matches");
	show_debug_message("char 2 won " + string(_char2_wins) + " matches");
	change_gamestate(gamestates.versus_select);
}