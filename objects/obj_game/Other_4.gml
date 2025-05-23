/// @description Insert description here
// You can write your code in this editor

init_view();

for(var i = 0; i < max_players; i++) {
	if (!instance_exists(player[i])) {
		player[i] = noone;
	}
}

screen_fade_type = fade_types.normal;

ground_height = room_height - 100;
		
battle_x = room_width / 2;
battle_y = ground_height;
left_wall = 0;
right_wall = room_width;

ds_list_clear(music_played_list);

var active_players = 0;
for(var i = 0; i < max_players; i++) {
	if player_slot[i] != noone {
		active_players++;
	}
}
	
var team1_members = ceil(active_players/2);
var team2_members = floor(active_players/2);
	
var _w = battle_width;
var _w2 = _w / 2;
var _w3 = _w2 / 2;

var _w4_t1 = _w3 / max(1,team1_members);
var _w4_t2 = _w3 / max(1,team2_members);

switch(room) {
	case rm_versus_charselect:
	for(var i = 0; i < max_players; i++) {
		player_ready[i] = false;
	}
	ready_timer = 100;
	stage = choose(
		rm_namek
	);
	play_music(mus_umvc3_charselect);
	break;
	
	case rm_versus:
	screen_fade_type = fade_types.bottom;
	play_music(mus_slammasters_versus,1,1,false);
	break;
	
	case stage:
	setup_battle();
	
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

//instance_create(0,0,obj_test_flamethrower);