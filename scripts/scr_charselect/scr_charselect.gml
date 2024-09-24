// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

enum playerchars {
	goku,
	//vegeta,
	//trunks,
	//freeza,
	//cell,
	//broly,
	
	naruto,
	//sasuke,
	//kakashi,
	
	//ichigo,
	//renji,
	//zaraki,
	
	//saitama,
	genos,
	
	allchars
}

globalvar max_characters;
max_characters = playerchars.allchars;

function update_charselect() {
	if (game_state_duration == -1) {
		charselect_joinin();
		charselect_dropout();
		charselect_changechars();
		charselect_readyup();
		charselect_startgame();
	}
}

function charselect_joinin() {
	for(var i = 0; i < array_length(player_input); i++) {
		if (!player_input[i].assigned)
		and player_input[i].confirm {
			for(var ii = 0; ii < array_length(player_slot); ii++) {
				if player_slot[ii] != noone continue;
				player_slot[ii] = i;
				player_char[ii] = ii;
				player_ready[ii] = false;
				player_input[i].assigned = true;
				player_input[i].confirm = false;
				play_sound(snd_menu_select);
				break;
			}
		}
	}
}

function charselect_dropout() {
	for(var i = 0; i < array_length(player_slot); i++) {
		if player_slot[i] != noone {
			if player_input[player_slot[i]].cancel
			and (!player_ready[i]) {
				player_input[player_slot[i]].assigned = false;
				player_input[player_slot[i]].cancel = false;
				player_slot[i] = noone;
				player_char[i] = i;
				player_ready[i] = false;
			}
		}
	}
}

function charselect_changechars() {
	for(var i = 0; i < array_length(player_slot); i++) {
		if player_slot[i] != noone {
			if !player_ready[i] {
				if player_input[player_slot[i]].left_pressed {
					player_char[i]--;
					play_sound(snd_menu_scroll);
				}
				if player_input[player_slot[i]].right_pressed {
					player_char[i]++;
					play_sound(snd_menu_scroll);
				}
				if player_input[player_slot[i]].char_random mod 6 == 1 {
					var _char = player_char[i];
					while(player_char[i] == _char) {
						player_char[i] = irandom(max_characters-1);
					}
					play_sound(snd_menu_scroll,0.5,1.25);
				}
			}
			if player_char[i] < 0 {
				player_char[i] = max_characters-1;
			}
			if player_char[i] >= max_characters {
				player_char[i] = 0;
			}
		}
	}
}

function charselect_readyup() {
	for(var i = 0; i < array_length(player_slot); i++) {
		if player_slot[i] != noone {
			if (!player_ready[i]) and player_input[player_slot[i]].confirm {
				player_ready[i] = true;
				player_input[i].confirm = false;
				play_sound(snd_menu_select);
			}
			else if player_ready[i] and player_input[player_slot[i]].cancel {
				player_ready[i] = false;
				player_input[i].cancel = false;
			}
		}
	}
}

function charselect_startgame() {
	var active_players = 0;
	var ready_players = 0;
	for(var i = 0; i < array_length(player_slot); i++) {
		if player_slot[i] != noone {
			active_players++;
			if player_ready[i] { ready_players++; }
		}
	}
	var countdown = false;
	if active_players >= 2
	and ready_players == active_players { 
		countdown = true; 
	}
	if countdown { ready_timer--; } else { ready_timer = 20; }
	if ready_timer <= 0 {
		for(var i = 0; i < array_length(player_slot); i++) {
			if player_slot[i] != noone {
				if player_input[player_slot[i]].confirm {
					next_game_state = gamestates.versus_intro;
					game_state_duration = screen_fade_duration;
				}
			}
		}
	}
}

function draw_charselect() {
	var active_players = 0;
	for(var i = 0; i < array_length(player_slot); i++) {
		if player_slot[i] != noone {
			active_players++;
		}
	}
	var _w = gui_width;
	var _h = gui_height;
	var _w2 = _w / (active_players+1);
	var _h2 = _h / 2;
	var _x = _w2;
	var _y = _h2;
	for(var i = 0; i < array_length(player_slot); i++) {
		if player_slot[i] != noone {
			var _xscale = 1;
			if _x > (_w/2) _xscale *= -1;
			draw_sprite_ext(get_char_sprite(player_char[i]),0,_x,_y,_xscale,1,0,c_white,1);
			
			draw_set_font(fnt_menu);
			draw_set_halign(fa_center);
			draw_set_valign(fa_top);
			var _text = "Player " + string(i+1); 
			_text += "\n" + get_char_name(player_char[i]);
			if player_ready[i] {
				_text += "\n" + "OK!";
			}
			draw_text_outlined(_x,_y,_text,c_black,player_color[i]);
			_x += _w2;
		}
	}
	if ready_timer <= 0 {
		draw_set_font(fnt_menu);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_text_outlined(_w/2,_h/8,"Pronto para iniciar!",c_black,c_white);
	}
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_color(c_white);
}

function get_char_sprite(_id) {
	switch(_id) {
		case playerchars.goku: return spr_goku_idle; break;
		
		case playerchars.naruto: return spr_naruto_idle; break;
		
		case playerchars.genos: return spr_genos_idle; break;
	}
}

function get_char_portrait(_id) {
	switch(_id) {
		case playerchars.goku: return spr_goku_portrait; break;
		
		case playerchars.naruto: return spr_naruto_portrait; break;
		
		case playerchars.genos: return spr_genos_portrait; break;
	}
}

function get_char_name(_id) {
	switch(_id) {
		case playerchars.goku: return "Goku"; break;
		
		case playerchars.naruto: return "Naruto"; break;
		
		case playerchars.genos: return "Genos"; break;
	}
}

function get_char_object(_id) {
	switch(_id) {
		case playerchars.goku: return obj_goku; break;
		
		case playerchars.naruto: return obj_naruto; break;
		
		case playerchars.genos: return obj_genos; break;
	}
}