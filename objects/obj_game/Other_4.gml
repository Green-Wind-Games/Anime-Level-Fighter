/// @description Insert description here
// You can write your code in this editor
	
for(var i = 0; i < array_length(player_slot); i++) {
	player[i] = noone;
}

init_view();

stop_music();

ground_height = room_height - round(game_height * 0.25);

var active_players = 0;
for(var i = 0; i < array_length(player_slot); i++) {
	if player_slot[i] != noone {
		active_players++;
	}
}
var _w = game_width / 3;
var _w2 = _w / 2;

switch(room) {
	case rm_versus_charselect:
	for(var i = 0; i < array_length(player_slot); i++) {
		player_ready[i] = false;
	}
	ready_timer = 100;
	stage = choose(rm_namek);
	play_music(mus_umvc3_charselect);
	break;
	
	case rm_versus:
	play_music(mus_slammasters_versus);
	break;
	
	case stage:
	round_state = roundstates.intro;
	round_timer = round_timer_max;
	round_state_timer = 0;
		
	battle_x = room_width / 2;
	battle_y = -game_height;
	left_wall = 0;
	right_wall = room_width;
		
	var _x1 = battle_x - _w2;
	var _x2 = battle_x + _w2;
	var spawned_players = 0;
	for(var i = 0; i < array_length(player_slot); i++) {
		if player_slot[i] != noone {
			var _x = map_value(spawned_players,0,active_players-1,_x1,_x2);
			var _y = battle_y;
			with(instance_create(_x,_y,get_char_object(player_char[i]))) {
				player[i] = id;
				input = player_input[player_slot[i]];
				if x <= battle_x {
					team = 1;
					facing = 1;
				}
				else {
					team = 2;
					facing = -1;
				}
				change_state(enter_state);
			}
			spawned_players++;
		}
	}
	
	stop_music();
	var picked_player = instance_find(obj_char,irandom(instance_number(obj_char)-1));
	play_music(picked_player.theme);
	
	switch(room) {
		default:
		ground_sprite = noone;
		break;
		
		case rm_training:
		ground_sprite = spr_grid_ground;
		break;
		
		//case rm_namek:
		//ground_sprite = spr_namek_ground;
		//break;
	}
	break;
	
	case rm_versus_results:
	var placed_players = 0;
	var _x1 = (room_width / 2) - _w2;
	var _x2 = _x1 + _w;
	var team1_score = get_team_score(1);
	var team2_score = get_team_score(2);
	with(obj_char) {
		x = map_value(placed_players,0,active_players-1,_x1,_x2);
		y = ground_height;
		placed_players++;
		
		reset_sprite();
		if team == 1 {
			facing = 1;
		}
		else {
			facing = -1;
		}
		
		yscale = (game_height / 8) / height;
		if ((team == 1) and (team1_score > team2_score))
		or ((team == 2) and (team2_score > team1_score)) {
			change_state(victory_state);
			yscale *= 2;
			depth = 0;
		}
		else {
			change_state(defeat_state);
			depth = 99;
		}
		xscale = yscale;
		yoffset = (((-game_height/2) + (room_height-ground_height)) + (height_half * yscale));
		
		dead = false;
		hp = max_hp;
	}
	break;
}