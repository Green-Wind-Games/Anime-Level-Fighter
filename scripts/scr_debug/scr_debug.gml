randomize();

function print(_message = "") {
	show_debug_message(string(_message));
}

function debug_step() {
	if (keyboard_check_pressed(vk_end)) {
		play_music(mus_dbfz_space);
		audio_sound_set_track_position(
			music,
			audio_sound_get_loop_end(music) - 5
		);
	}
	
	if keyboard_check(vk_insert) {
		with(obj_char) {
			hp = max_hp;
			mp = max_mp;
			tp = max_tp;
		}
	}
	if keyboard_check(vk_home) {
		with(obj_char) {
			hp = max_hp / 4;
			mp = mp_stock_size;
			tp = tp_stock_size;
		}
	}
	if keyboard_check_pressed(vk_pageup) {
		with(obj_char) {
			xp = max_xp;
		}
	}
	if keyboard_check_pressed(vk_pagedown) {
		with(obj_char) {
			xp = 0;
		}
	}
	if keyboard_check_pressed(vk_delete) {
		with(player[0]) {
			dead = true;
			take_damage(noone,max_hp * 10,true);
			change_state(hard_knockdown_state);
			xspeed = -3 * facing;
			yspeed = -5;
		}
	}

	if keyboard_check_pressed(ord("0")) {
		round_timer = 0;
	}

	var _fps = game_get_speed(gamespeed_fps);
	var _change = 6;

	if keyboard_check_pressed(vk_add) {
		game_set_speed(_fps + _change, gamespeed_fps);
	}
	if keyboard_check_pressed(vk_subtract) and (_fps > _change) {
		game_set_speed(_fps - _change, gamespeed_fps);
	}
	if keyboard_check_pressed(vk_multiply) {
		game_set_speed(60, gamespeed_fps);
	}
	if keyboard_check_pressed(vk_divide) {
		game_set_speed(600, gamespeed_fps);
	}

	if keyboard_check_pressed(vk_f5)
	or (game_get_speed(gamespeed_fps) > 60) {
		for(var i = 0; i < max_players; i++) {
			with(player[i]) {
				input = player_input[i+11];
			}
		}
	}
	if keyboard_check_pressed(vk_f6) {
		for(var i = 0; i < max_players; i++) {
			with(player[i]) {
				input = player_input[player_slot[i]];
			}
		}
	}
}

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