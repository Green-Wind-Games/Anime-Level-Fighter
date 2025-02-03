function get_char_sprite(_id) {
	return char_list[_id].sprite;
}

function get_char_portrait(_id) {
	return char_list[_id].portrait;
}

function get_char_icon(_id) {
	return char_list[_id].icon;
}

function get_char_name(_id) {
	return char_list[_id].name;
}

function get_char_object(_id) {
	return char_list[_id].object;
}

function update_charselect() {
	if (game_state_timer < screen_fade_duration) exit;
	if (next_game_state != -1) exit;
	
	charselect_joinin();
	charselect_dropout();
	charselect_changechars();
	charselect_readyup();
	charselect_startgame();
}

function charselect_joinin() {
	for(var i = 0; i < array_length(player_input); i++) {
		if (!player_input[i].assigned)
		and player_input[i].confirm {
			for(var ii = 0; ii < max_players; ii++) {
				if player_slot[ii] != noone continue;
				player_slot[ii] = i;
				player_char[ii] = ii;
				player_ready[ii] = false;
				player_input[i].assigned = true;
				player_input[i].confirm = false;
				play_sound(snd_ui_menu_select,1,1);
				break;
			}
		}
	}
}

function charselect_dropout() {
	for(var i = 0; i < max_players; i++) {
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
	for(var i = 0; i < max_players; i++) {
		if player_slot[i] != noone {
			if !player_ready[i] {
				var _previous_char = player_char[i];
				if player_input[player_slot[i]].left_pressed {
					if (player_char[i] mod chars_per_row) == 0 {
						player_char[i] += chars_per_row;
					}
					player_char[i] -= 1;
				}
				if player_input[player_slot[i]].right_pressed {
					if (player_char[i] mod chars_per_row) == (chars_per_row - 1) {
						player_char[i] -= chars_per_row;
					}
					player_char[i] += 1;
				}
				if player_input[player_slot[i]].up_pressed {
					player_char[i] -= chars_per_row;
					if player_char[i] < 0 {
						player_char[i] += max_characters;
					}
				}
				if player_input[player_slot[i]].down_pressed {
					player_char[i] += chars_per_row;
					if player_char[i] >= max_characters {
						player_char[i] -= max_characters;
					}
				}
				if player_input[player_slot[i]].char_random mod 6 == 1 {
					while((player_char[i] == _previous_char) or (!object_exists(get_char_object(player_char[i])))) {
						player_char[i] = irandom(max_characters-1);
					}
				}
				if player_char[i] != _previous_char {
					if player_input[player_slot[i]].char_random {
						play_sound(snd_ui_menu_scroll,0.5,1.25);
					}
					else {
						play_sound(snd_ui_menu_scroll,1,1);
					}
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
	for(var i = 0; i < max_players; i++) {
		if player_slot[i] != noone {
			if (!player_ready[i]) {
				if player_input[player_slot[i]].confirm {
					if object_exists(get_char_object(player_char[i])) {
						player_ready[i] = true;
						player_input[i].confirm = false;
						play_sound(snd_ui_menu_select,1,1);
					}
				}
			}
			else if player_ready[i] {
				if player_input[player_slot[i]].cancel {
					player_ready[i] = false;
					player_input[i].cancel = false;
				}
			}
		}
	}
}

function charselect_startgame() {
	var active_players = 0;
	var ready_players = 0;
	for(var i = 0; i < max_players; i++) {
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
		for(var i = 0; i < max_players; i++) {
			if player_slot[i] != noone {
				if player_input[player_slot[i]].confirm {
					change_gamestate(gamestates.versus_vs);
				}
			}
		}
	}
}

function draw_charselect() {
	draw_charselect_boxes();
	
	var active_players = 0;
	for(var i = 0; i < max_players; i++) {
		if player_slot[i] != noone {
			active_players++;
		}
	}
	var _team1_members = ceil(active_players/2);
	var _team2_members = floor(active_players/2);
	
	var _w = gui_width;
	var _h = gui_height;
	var _w2 = _w / 2;
	var _h2 = _h / 2;
	var _w3 = _w2 / 2;
	var _w4_t1 = _w3 / max(1,_team1_members);
	var _w4_t2 = _w3 / max(1,_team2_members);
	
	var _x = 0;
	var _y = _h * 0.69;
	
	var _drawn_players = 0;
	var _drawn_t1_players = 0;
	var _drawn_t2_players = 0;
	for(var i = 0; i < max_players; i++) {
		if player_slot[i] != noone {
			var _x = _w2;
			var _xscale = 1;
			if _drawn_players < _team1_members {
				_x = _w4_t1 * (_drawn_t1_players + 1);
			}
			else {
				_x = _w2 + (_w4_t2 * (_drawn_t2_players + 1));
				_xscale = -1;
			}
			
			var _sprite = get_char_sprite(player_char[i]);
			if sprite_exists(_sprite) {
				draw_sprite_ext(_sprite,0,_x,_y,_xscale,1,0,c_white,1);
			}
			
			draw_set_font(fnt_menu);
			draw_set_halign(fa_center);
			draw_set_valign(fa_top);
			var _text = "Player " + string(i+1);
			with(player_input[player_slot[i]]) {
				_text += "\n(";
				switch(type) {
					case input_types.joystick: _text += "Controller " + string(pad + 1); break;
					case input_types.wasd: _text += "WASD"; break;
					case input_types.numpad: _text += "Numpad"; break;
					case input_types.touch: _text += "Touch"; break;
					case input_types.ai: _text += "AI"; break;
				}
				_text += ")";
			}
			_text += "\n" + get_char_name(player_char[i]);
			if player_ready[i] {
				_text += "\n" + "OK!";
			}
			draw_text_outlined(_x,_y,_text,c_black,player_color[i],0.75);
			
			if _drawn_players <= _drawn_t1_players {
				_drawn_t1_players++;
			}
			else {
				_drawn_t2_players++;
			}
			_drawn_players++;
		}
	}
	if ready_timer <= 0 {
		draw_set_font(fnt_menu);
		draw_set_halign(fa_center);
		draw_set_valign(fa_bottom);
		draw_text_outlined(_w/2,_h * 0.95,"Ready to start!",c_black,c_white);
	}
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_color(c_white);
}

function draw_charselect_boxes() {
	var _w = gui_width;
	var _h = gui_height;
	var _w2 = _w / 2;
	var _h2 = _h / 2;
	var _w3 = _w / 3;
	var _h3 = _h / 3;
	
	var _x = _w2;
	var _y = 10;
	
	var box_size = min(
		_w3 / chars_per_row,
		_h3 / chars_per_column
	);
	var icon_size = box_size * 0.8;
	
	_x -= (box_size * (chars_per_row / 2));
	
	for(var r = 0; r < 3; r++) {
		var _char_i = 0;
		
		for(var i = 0; i < chars_per_column; i++) {
			for(var ii = 0; ii < chars_per_row; ii++) {
				var _x1 = _x + (box_size * ii);
				var _y1 = _y + (box_size * i);
				var _x2 = _x1 + box_size - 1;
				var _y2 = _y1 + box_size - 1;
				
				if r == 0 {
					draw_set_color(c_black);
					draw_set_alpha(0.5);
					for(var iii = 0; iii < max_players; iii++) {
						if player_slot[iii] == noone continue;
						if player_char[iii] != _char_i continue;
				
						if draw_get_color() == c_black {
							draw_set_color(player_color[iii]);
						}
						else {
							draw_set_color(merge_color(draw_get_color(),player_color[iii],0.5));
						}
						draw_set_alpha(1);
					}
					draw_rectangle(_x1,_y1,_x2,_y2,false);
				}
				else if r == 1 {
					draw_set_alpha(1);
					draw_set_color(c_white);
					draw_rectangle(_x1,_y1,_x2,_y2,true);
				}
				else {
					var _icon = get_char_icon(_char_i);
					var _icon_scale = icon_size / average_char_icon_height;
					var _icon_x = mean(_x1,_x2);
					var _icon_y = mean(_y1,_y2) + (icon_size/2);
					if sprite_exists(_icon) {
						draw_sprite_ext(
							_icon,
							0,
							_icon_x,
							_icon_y,
							ii <= (chars_per_row / 2) ? _icon_scale : -_icon_scale,
							_icon_scale,
							0,
							c_white,
							1
						);
					}
					else {
						var _nochar = "?";
						var _icon_scale = icon_size / max(string_width(_nochar),string_height(_nochar));
						var _icon_color = make_color_rgb(255,192,0);
						draw_set_halign(fa_center);
						draw_set_valign(fa_bottom);
						draw_set_font(fnt_menu);
						draw_text_outlined(_icon_x-1,_icon_y,_nochar,c_white,_icon_color,_icon_scale);
						draw_text_outlined(_icon_x,_icon_y,_nochar,c_black,_icon_color,_icon_scale);
					}
				}
			
				_char_i++;
			}
		}
	}
}