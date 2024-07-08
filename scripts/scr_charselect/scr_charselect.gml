// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

enum playerchars {
	goku,
	//vegeta,
	//trunks,
	
	//naruto,
	//sasuke,
	//sakura,
	
	//ichigo,
	//renji,
	//zaraki,
	
	allchars
}

globalvar max_characters;
max_characters = playerchars.allchars;

function update_charselect() {
	charselect_joinin();
	charselect_dropout();
	charselect_changechars();
	charselect_readyup();
	charselect_startgame();
}

function charselect_joinin() {
	for(var i = 0; i < array_length(player_input); i++) {
		if (!player_input[i].assigned)
		and player_input[i].button1 {
			for(var ii = 0; ii < array_length(player_slot); ii++) {
				if player_slot[ii] != noone continue;
				player_slot[ii] = i;
				player_char[ii] = ii;
				player_ready[ii] = false;
				player_input[i].assigned = true;
				player_input[i].button1 = false;
				break;
			}
		}
	}
}

function charselect_dropout() {
	for(var i = 0; i < array_length(player_slot); i++) {
		if player_slot[i] != noone {
			if player_input[player_slot[i]].button2
			and (!player_ready[i]) {
				player_input[player_slot[i]].assigned = false;
				player_input[player_slot[i]].button2 = false;
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
				}
				if player_input[player_slot[i]].right_pressed {
					player_char[i]++;
				}
			}
		}
		if player_char[i] < 0 {
			player_char[i] = max_characters - 1;
		}
		if player_char[i] >= max_characters {
			player_char[i] = 0;
		}
	}
}

function charselect_readyup() {
	for(var i = 0; i < array_length(player_slot); i++) {
		if player_slot[i] != noone {
			if player_input[player_slot[i]].button1 {
				player_ready[i] = true;
				player_input[i].button1 = false;
			}
			else if player_input[player_slot[i]].button2 {
				player_ready[i] = false;
				player_input[i].button2 = false;
			}
		}
	}
	var active_players = 0;
	var ready_players = 0;
	for(var i = 0; i < array_length(player_slot); i++) {
		if player_slot[i] != noone {
			active_players++;
			if player_ready[i] { ready_players++; }
		}
	}
	var countdown = false;
	if active_players > 0 
	and ready_players == active_players { countdown = true; }
	if !countdown { ready_timer = 10; } else { ready_timer--; }
}

function charselect_startgame() {
	if ready_timer <= 0 {
		for(var i = 0; i < array_length(player_slot); i++) {
			if player_slot[i] != noone {
				if player_input[player_slot[i]].button1 {
					game_state = gamestates.versus_intro;
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
	var _w2 = _w / max(3,active_players);
	var _h2 = _h / 2;
	var _x = _w2;
	var _y = _h2 + 24;
	for(var i = 0; i < array_length(player_slot); i++) {
		if player_slot[i] != noone {
			draw_sprite(get_char_sprite(player_char[i]),0,_x,_y);
			
			draw_set_font(fnt_menu);
			draw_set_halign(fa_center);
			draw_set_valign(fa_top);
			draw_set_color(player_color[i]);
			var _text = "Player " + string(i+1); 
			_text += "\n" + get_char_name(player_char[i]);
			if player_ready[i] {
				_text += "\n" + "OK!";
			}
			draw_text(_x,_y,_text);
			_x += _w2;
		}
	}
	if ready_timer <= 0 {
		draw_set_font(fnt_menu);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_set_color(c_white);
		draw_text(_w/2,_h/4,"Pronto para iniciar!");
	}
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_color(c_white);
}

function get_char_sprite(_id) {
	switch(_id) {
		case playerchars.goku: return spr_goku_idle; break;
	}
}

function get_char_portrait(_id) {
	switch(_id) {
		case playerchars.goku: return spr_goku_portrait; break;
	}
}

function get_char_name(_id) {
	switch(_id) {
		case playerchars.goku: return "Goku"; break;
	}
}

function get_char_object(_id) {
	switch(_id) {
		case playerchars.goku: return obj_goku; break;
	}
}