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
				play_sound(snd_menu_select,1,1);
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
						play_sound(snd_menu_scroll,0.5,1.25);
					}
					else {
						play_sound(snd_menu_scroll,1,1);
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
						play_sound(snd_menu_select,1,1);
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
	var _w = gui_width;
	var _h = gui_height;
	var _w2 = _w / max(2,active_players+1);
	var _h2 = _h / 2;
	var _x = _w2;
	var _y = _h * 0.65;
	for(var i = 0; i < max_players; i++) {
		if player_slot[i] != noone {
			var _xscale = 1;
			if _x > (_w/2) _xscale *= -1;
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
					case input_types.numpad: _text += "Arrows"; break;
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
			_x += _w2;
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
	
	var _x = _w2;
	var _y = 10;
	
	var box_size = (_h2 - (_y * 2)) / chars_per_column;
	var icon_size = box_size * 0.8;
	
	_x -= (box_size * (chars_per_row / 2));
	
	var _char_i = 0;
	
	for(var i = 0; i < chars_per_column; i++) {
		for(var ii = 0; ii < chars_per_row; ii++) {
			var _x1 = _x + (box_size * ii);
			var _y1 = _y + (box_size * i);
			var _x2 = _x1 + box_size - 1;
			var _y2 = _y1 + box_size - 1;
			
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
			draw_set_alpha(1);
			draw_set_color(c_white);
			draw_rectangle(_x1,_y1,_x2,_y2,true);
			
			var _icon = get_char_icon(_char_i);
			if sprite_exists(_icon) {
				var _icon_scale = icon_size / min(sprite_get_width(_icon),sprite_get_height(_icon));
				var _icon_xscale = _icon_scale;
				if ii >= (chars_per_row / 2) { _icon_xscale *= -1; }
				draw_sprite_ext(_icon,0,mean(_x1,_x2),mean(_y1,_y2),_icon_xscale,_icon_scale,0,c_white,1);
			}
			
			_char_i++;
		}
	}
}