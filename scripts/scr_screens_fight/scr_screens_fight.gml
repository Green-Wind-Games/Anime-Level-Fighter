function setup_battle() {
	var active_players = 0;
	for(var i = 0; i < max_players; i++) {
		if player_slot[i] != noone {
			active_players++;
		}
	}
	
	var team1_members = ceil(active_players/2);
	var team2_members = floor(active_players/2);
	
	var _w = 300;
	var _w2 = _w / 2;
	var _w3 = _w2 / 2;

	var _w4_t1 = _w3 / max(1,team1_members);
	var _w4_t2 = _w3 / max(1,team2_members);
	
	if round_state != roundstates.fight {
		//randomize();
		
		screen_fade_type = fade_types.bottom;
		round_state = roundstates.intro;
		round_timer = round_timer_max;
		round_state_timer = 0;
		
		var spawned_players = 0;
		var spawned_team1_players = 0;
		var spawned_team2_players = 0;
		for(var i = 0; i < max_players; i++) {
			if player_slot[i] != noone {
				var _x = battle_x;
				if spawned_players < team1_members {
					_x -= _w2;
					_x += _w4_t1 * (spawned_team1_players + 1);
				}
				else {
					//_x += _w2;
					_x += _w4_t2 * (spawned_team2_players + 1);
				}
				var _y = ground_height - (1000 * (game_state == gamestates.versus_battle));
				with(instance_create(_x,_y,get_char_object(player_char[i]))) {
					player[i] = id;
					input = player_input[player_slot[i]];
					if spawned_players < team1_members {
						team = 1;
						facing = 1;
						spawned_team1_players++
					}
					else {
						team = 2;
						facing = -1;
						spawned_team2_players++;
					}
					change_state(game_state == gamestates.versus_battle ? enter_state : idle_state);
				}
				spawned_players++;
			}
		}
	
		stop_music();
		play_music(
			choose(
				mus_dbfz_westcity,
				mus_ff4_ds_bossbattle,
				mus_guiltygear_fatalduel,
				mus_yakuza_zero_tusk,
			)
		);
		//var picked_player = instance_find(obj_char,irandom(instance_number(obj_char)-1));
		//play_chartheme(picked_player);
	}
}

function toggle_pause() {
	if round_state == roundstates.fight {
		pause_game();
	}
	else if round_state == roundstates.pause {
		unpause_game();
	}
}

function pause_game() {
	round_state = roundstates.pause;
	var _options = [
		["Resume",unpause_game],
		["Reset",reset_fight],
		["Quit Match",goto_versus_select]
	];
	open_menu(
		gui_width/2,
		gui_height/2,
		_options,
		"Pause Menu"
	);
}

function unpause_game() {
	instance_destroy(obj_menu);
	round_state = roundstates.fight;
}

function reset_fight() {
	change_gamestate(game_state);
	timestop(screen_fade_duration*2);
}