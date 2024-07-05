/// @description Insert description here
// You can write your code in this editor

init_view();

stop_music();

ground_height = room_height - floor(game_height * 0.25);

switch(room) {
	case rm_charselect:
	p1_charselect_id = 0;
	p1_charselect_state = charselectstates.char;
	p1_selecting_char = 0;
	p1_selecting_form = 0;
	p1_selecting_assist = assist_type.a;

	p2_charselect_id = 0;
	p2_charselect_state = charselectstates.char;
	p2_selecting_char = 0;
	p2_selecting_form = 0;
	p2_selecting_assist = assist_type.a;
	
	for(var i = 0; i < max_team_size; i++) {
		p1_selected_assist[i] = 0;
		p1_selected_char[i] = 0;
		p1_selected_form[i] = 0;
		p2_selected_assist[i] = 0;
		p2_selected_char[i] = 0;
		p2_selected_form[i] = 0;
	}
	
	play_music(mus_umvc3_charselect);
	
	stage = choose(rm_grassfield);
	break;
	
	case stage:
	round_state = roundstates.intro;
	round_timer = round_timer_max;
	round_state_timer = 0;
		
	battle_x = room_width / 2;
	battle_y = ground_height;
	left_wall = 0;
	right_wall = room_width;
		
	var _x = battle_x;
	var _w = round(game_width / 5);
	var _x1 = _x - _w;
	var _x2 = _x + _w;
		
	for(var i = max_team_size - 1; i >= 0; i--) {
		p1_char[i] = instance_create(_x1,ground_height,charselect_obj[p1_selected_char[i]][p1_selected_form[i]]);;
		p1_char_x[i] = 0;
		p1_char_y[i] = 0;
		p1_char_hp[i] = 0;
		p1_char_hp_percent[i] = 0;
		p1_char_facing[i] = 1;
		p1_char_assist_type[i] = p1_selected_assist[i];
		p1_char_assist_timer[i] = 0;
	
		p2_char[i] = instance_create(_x2,ground_height,charselect_obj[p2_selected_char[i]][p2_selected_form[i]]);
		p2_char_x[i] = 0;
		p2_char_y[i] = 0;
		p2_char_hp[i] = 0;
		p2_char_hp_percent[i] = 0;
		p2_char_facing[i] = -1;
		p2_char_assist_type[i] = p2_selected_assist[i];
		p2_char_assist_timer[i] = 0;
		
		p2_char[i].facing = -1;
		
		p1_char[i].x -= 32 * i;
		p2_char[i].x += 32 * i;
	}

	p1_active_character = p1_char[0];
	p2_active_character = p2_char[0];
	
	with(p1_active_character) {
		change_state(intro_state);
	}
	with(p2_active_character) {
		change_state(intro_state);
	}
	
	p1_mp = mp_stock_size;
	p1_tp = max_tp;
	p1_sp = 0;
	
	p2_mp = mp_stock_size;
	p2_tp = max_tp;
	p2_sp = 0;
	
	update_teamstats();
	
	play_music(choose(p1_active_character.theme,p2_active_character.theme));
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
}