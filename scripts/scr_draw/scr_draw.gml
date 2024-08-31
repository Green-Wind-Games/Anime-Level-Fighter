// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function draw_ground() {
	if sprite_exists(ground_sprite) {
		var ground_w = room_width * 1.5;
		var ground_h = (room_height-ground_height)*1.5;
		var ground_x = (-ground_w/2);
		var ground_y = ground_height-sprite_get_yoffset(ground_sprite);
		draw_sprite_stretched(ground_sprite,0,ground_x,ground_y,ground_w,ground_h);
	}
}

function draw_playerindicators() {
	draw_set_halign(fa_center);
	draw_set_valign(fa_bottom);
	draw_set_font(fnt_playerindicator);
	var border = string_height("[]");
	for(var i = 0; i < array_length(player_slot); i++) {
		with(player[i]) {
			var indicator_x = x;
			
			var indicator_y = y - 2;
			//var _height = (sprite_get_bbox_bottom(sprite) - sprite_get_bbox_top(sprite));
			indicator_y -= height * yscale * ystretch;
			indicator_y = clamp(
				indicator_y,
				camera_get_view_y(view)+border,
				camera_get_view_y(view)+camera_get_view_height(view)
			);
			
			var text = "[P"+string(i+1)+"]";
			draw_set_color(c_black);
			draw_text(indicator_x+1,indicator_y,text);
			draw_text(indicator_x-1,indicator_y,text);
			draw_text(indicator_x,indicator_y-1,text);
			draw_text(indicator_x,indicator_y+1,text);
			draw_set_color(player_color[i]);
			draw_text(indicator_x,indicator_y,text);
		}
	}
}

function draw_chars() {
	draw_char_shadows();
	
	var draw_order = ds_priority_create();
	with(obj_char) {
		ds_priority_add(draw_order,id,depth);
	}
	while(!ds_priority_empty(draw_order)) {
		with(ds_priority_find_max(draw_order)) {
			var _x = x + (xoffset*facing);
			var _y = y + yoffset;
			_x += random(hitstop)*choose(1,-1);
			_y += random(hitstop)*choose(1,-1)*is_airborne;
		
			if flash {
				gpu_set_fog(true,flash_color,0,0);
			}

			draw_sprite_ext(
				sprite,
				frame,
				_x,
				_y,
				xscale*xstretch*facing,
				yscale*ystretch,
				rotation*facing*sign(xscale)*sign(xstretch),
				color,
				alpha
			);

			gpu_set_fog(false,c_white,0,0);
		}
		ds_priority_delete_max(draw_order);
	}
	ds_priority_destroy(draw_order);
	with(obj_char) {
		draw_script();
	}
	with(obj_char) {
		if sprite_exists(aura_sprite) {
			gpu_set_blendmode(bm_add);
			draw_sprite_ext(
				aura_sprite,
				floor(aura_frame),
				x,
				y,
				sprite_get_width(sprite) / sprite_get_width(aura_sprite) * 2,
				sprite_get_height(sprite) / sprite_get_height(aura_sprite) * 2,
				0,
				c_white,
				alpha
			)
		}
		gpu_set_blendmode(bm_normal);
	}
	
	draw_playerindicators();
}

function draw_char_shadows() {
	var shadow_scale = -0.1;
	var shadow_alpha = 0.5;
	with(obj_char) {
		var _x = x + (xoffset*facing);
		var _y = ground_height;
		_y += map_value(y+yoffset,ground_height,0,-1,-(room_height/2)*shadow_scale);
		//_x += random(hitstop)*choose(1,-1);
		//_y -= random(hitstop)*choose(1,-1)*is_airborne;
		
		draw_sprite_ext(
			sprite,
			frame,
			_x,
			_y,
			xscale*xstretch*facing,
			yscale*ystretch*shadow_scale,
			0,
			c_black,
			alpha * shadow_alpha
		);
	}
}

function draw_shots() {
	with(obj_shot) {
		if blend {
			gpu_set_blendmode(bm_add);
		}

		draw_sprite_ext(
			sprite,
			frame,
			x,
			y,
			xscale,
			yscale*facing,
			rotation,
			color,
			alpha
		);

		gpu_set_blendmode(bm_normal);
	}
}

function draw_superfreeze() {
	if superfreeze_active {
		draw_set_alpha(0.5);
		draw_set_color(c_black);
		var _x1 = camera_get_view_x(view);
		var _y1 = camera_get_view_y(view);
		var _x2 = _x1 + camera_get_view_width(view);
		var _y2 = _y1 + camera_get_view_height(view);
		draw_rectangle(_x1,_y1,_x2,_y2,false);
		draw_set_alpha(1);
		draw_set_color(c_white);
		with(superfreeze_activator) {
			var _x = x + (xoffset*facing);
			var _y = y + yoffset;
		
			if flash {
				gpu_set_fog(true,flash_color,0,0);
			}

			draw_sprite_ext(
				sprite,
				frame,
				_x,
				_y,
				xscale*xstretch*facing,
				yscale*ystretch,
				rotation*facing*sign(xscale)*sign(xstretch),
				color,
				alpha
			);

			gpu_set_fog(false,c_white,0,0);
			
			draw_script();
		}
	}
}

function draw_particles() {
	part_system_drawit(particle_system);
}

function draw_hud() {
	var _w = display_get_gui_width();
	var _h = display_get_gui_height();
	var _w2 = _w / 2;
	var _h2 = _h / 2;
	var _spacing = 5;
	var icon_size = 24;
	var icon_scale = 0.5;
	
	var active_players = 0;
	for (var i = 0; i < array_length(player_slot); i++) {
		if player_slot[i] != noone {
			active_players++;
		}
	}

	var hp_bar_width = (_w / active_players) - (_spacing * 2);
	var hp_bar_height = 8;
	var mp_bar_width = hp_bar_width * 0.8;
	var mp_bar_height = hp_bar_height * 0.5;
	var tp_bar_width = mp_bar_width * 0.8;
	var tp_bar_height = mp_bar_height;
	
	draw_set_font(fnt_hud);
	var playertext = "Player N: Character";
	var playertext_width = string_width(playertext);
	var playertext_height = string_height(playertext);
	
	var hud_w = _w / active_players;
	var hud_h = (_spacing * 2) + hp_bar_height + mp_bar_height + tp_bar_height + playertext_height;
	var hud_x = 0;
	var hud_y = 0;

	var hp_color = make_color_rgb(0, 255, 0);
	var dmg_color = make_color_rgb(255, 0, 0);
	var mp_color = make_color_rgb(0, 192, 255);
	var tp_color = make_color_rgb(255, 192, 0);

	for (var i = 0; i < array_length(player_slot); i++) {
		var _right = hud_x >= _w2;
		var hp_x1, hp_x2, hp_y1, hp_y2;
		var mp_x1, mp_x2, mp_y1, mp_y2;
		var tp_x1, tp_x2, tp_y1, tp_y2;

		if (!_right) {
			hp_x1 = hud_x + _spacing;
			hp_x2 = hp_x1 + hp_bar_width;
			
			mp_x1 = hp_x1;
			mp_x2 = mp_x1 + mp_bar_width;

			tp_x1 = hp_x1;
			tp_x2 = tp_x1 + tp_bar_width;
		} 
		else {
			hp_x2 = hud_x + hud_w - _spacing;
			hp_x1 = hp_x2 - hp_bar_width;
			
			mp_x2 = hp_x2;
			mp_x1 = mp_x2 - mp_bar_width;
			
			tp_x2 = hp_x2;
			tp_x1 = tp_x2 - tp_bar_width;
		}

		hp_y1 = hud_y + _spacing;
		hp_y2 = hp_y1 + hp_bar_height;

		mp_y1 = hp_y2 + 1;
		mp_y2 = mp_y1 + mp_bar_height;
		
		tp_y1 = mp_y2 + 1;
		tp_y2 = tp_y1 + tp_bar_height;

		with(player[i]) {
			draw_set_color(c_black);
			draw_set_alpha(1);
			draw_rectangle(hp_x1, hp_y1, hp_x2, hp_y2, false);
			draw_rectangle(mp_x1, mp_y1, mp_x2, mp_y2, false);
			draw_rectangle(tp_x1, tp_y1, tp_x2, tp_y2, false);

			if (!_right) {
				if (hp_percent > 0) {
					draw_set_color(hp_color);
					var _hp_x = map_value(hp_percent, 0, 100, hp_x1 + 1, hp_x2 - 1);
					draw_rectangle(hp_x1 + 1, hp_y1 + 1, _hp_x, hp_y2 - 1, false);

					if (combo_damage_taken > 0) {
						var _dmg_x = map_value(hp + combo_damage_taken, 0, max_hp, hp_x1 + 1, hp_x2 - 1);
						draw_set_color(dmg_color);
						draw_set_alpha(1);
						draw_rectangle(_hp_x + 1, hp_y1 + 1, _dmg_x, hp_y2 - 1, false);
					}
				}

				if (mp_percent > 0) {
					draw_set_color(mp_color);
					var _mp_x = map_value(mp_percent, 0, 100, mp_x1 + 1, mp_x2 - 1);
					draw_rectangle(mp_x1 + 1, mp_y1 + 1, _mp_x, mp_y2 - 1, false);
				}
				
				if (tp_percent > 0) {
					draw_set_color(tp_color);
					var _tp_x = map_value(tp_percent, 0, 100, tp_x1 + 1, tp_x2 - 1);
					draw_rectangle(tp_x1 + 1, tp_y1 + 1, _tp_x, tp_y2 - 1, false);
				}
			}
			else {
				if (hp_percent > 0) {
					draw_set_color(hp_color);
					var _hp_x = map_value(hp_percent, 0, 100, hp_x2 - 1, hp_x1 + 1);
					draw_rectangle(_hp_x, hp_y1 + 1, hp_x2 - 1, hp_y2 - 1, false);

					if (combo_damage_taken > 0) {
						var _dmg_x = map_value(hp + combo_damage_taken, 0, max_hp, hp_x2 - 1, hp_x1 + 1);
						draw_set_color(dmg_color);
						draw_set_alpha(1);
						draw_rectangle(_dmg_x, hp_y1 + 1, _hp_x - 1, hp_y2 - 1, false);
					}
				}

				if (mp_percent > 0) {
					draw_set_color(mp_color);
					var _mp_x = map_value(mp_percent, 0, 100, mp_x2 - 1, mp_x1 + 1);
					draw_rectangle(_mp_x, mp_y1 + 1, mp_x2 - 1, mp_y2 - 1, false);
				}
				
				if (tp_percent > 0) {
					draw_set_color(tp_color);
					var _tp_x = map_value(tp_percent, 0, 100, tp_x2 - 1, tp_x1 + 1);
					draw_rectangle(_tp_x, tp_y1 + 1, tp_x2 - 1, tp_y2 - 1, false);
				}
			}
			
			draw_set_color(c_black);
			var hp_segments = 4;
			for(var ii = 0; ii < hp_segments - 1; ii++) {
				var _x = map_value(ii,-1,hp_segments-1,hp_x1+1,hp_x2-1);
				var _y1 = hp_y1;
				var _y2 = hp_y2;
				draw_line(_x,_y1,_x,_y2);
			}
			for(var ii = 0; ii < max_mp_stocks - 1; ii++) {
				var _x = map_value(ii,-1,max_mp_stocks-1,mp_x1+1,mp_x2-1);
				var _y1 = mp_y1;
				var _y2 = mp_y2;
				draw_line(_x,_y1,_x,_y2);
			}
			for(var ii = 0; ii < max_tp_stocks - 1; ii++) {
				var _x = map_value(ii,-1,max_tp_stocks-1,tp_x1+1,tp_x2-1);
				var _y1 = tp_y1;
				var _y2 = tp_y2;
				draw_line(_x,_y1,_x,_y2);
			}
			
			draw_set_font(fnt_hud);
			var playertext = "Player " + string(i+1) + ": " + name;
			var playertext_width = string_width(playertext);
			var playertext_height = string_height(playertext);
			draw_set_halign(fa_left);
			draw_set_valign(fa_top);
			var playertext_x1 = hp_x1;
			var playertext_y1 = tp_y2 + 1;
			var playertext_x2 = playertext_x1 + playertext_width;
			var playertext_y2 = playertext_y1 + playertext_height;
			
			if _right {
				playertext_x2 = hp_x2;
				playertext_x1 = playertext_x2 - playertext_width;
			}
			
			draw_set_color(c_black);
			draw_rectangle(playertext_x1, playertext_y1, playertext_x2, playertext_y2, false);
			
			draw_set_color(player_color[i]);
			draw_text(playertext_x1,playertext_y1,playertext);
			
			hud_x += hud_w;
		}
	}
	
	draw_set_font(fnt_timer);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	var clock_text_max = string(round(round_timer_max / 60)*10);
	var clock_text_width = string_width(clock_text_max);
	var clock_text_height = string_height(clock_text_max);
	var clock_text = string(ceil(round_timer / 60));
	var clock_x = _w2;
	var clock_y = _h - _spacing - clock_text_height;
	//if _w - (hp_bar_width * 2) - (_spacing * 2) - (icon_size * 2) > text_width {
	//	text_y = mean(hp_y1,hp_y2);
	//}
	
	//var clock_x1 = clock_x - (clock_text_width / 2) + 1;
	//var clock_x2 = clock_x + (clock_text_width / 2) - 1;
	//var clock_y1 = clock_y - (clock_text_height / 2);
	//var clock_y2 = clock_y + (clock_text_height / 2);
	//draw_set_color(c_black);
	//draw_rectangle(clock_x1,clock_y1,clock_x2,clock_y2,false);
	draw_sprite(spr_timer,0,clock_x,clock_y);
	draw_set_color(make_color_rgb(255,255,0));
	draw_text(clock_x,clock_y,clock_text);
}

function draw_hitboxes() {
	with(obj_hitbox_parent) {
		draw_self();
	}
}

function draw_portraits() {
	var _w = display_get_gui_width();
	var _h = display_get_gui_height();
	var _x1 = _w * 0.1;
	var _x2 = _w * 0.9;
	var _y = _h * 0.5;
	var size = display_get_gui_height() / 4;
	
	var p1_portrait = charselect_portrait[p1_selecting_char][p1_selected_form[p1_charselect_id]];
	if sprite_exists(p1_portrait) {
		var p1_scale = size / sprite_get_height(p1_portrait);
		draw_sprite_ext(p1_portrait,0,_x1,_y,p1_scale,p1_scale,0,c_white,1);
	}
	
	var p2_portrait = charselect_portrait[p2_selecting_char][p2_selected_form[p2_charselect_id]];
	if sprite_exists(p2_portrait) {
		var p2_scale = size / sprite_get_height(p2_portrait);
		draw_sprite_ext(p2_portrait,0,_x2,_y,-p2_scale,p2_scale,0,c_white,1);
	}
	
	draw_set_font(fnt_assists);
	var _margin = 4;
	var text = "";
	if p1_charselect_state == charselectstates.char {
		text = charselect_name[p1_selecting_char];
	}
	if text != "" {
		var text_width = string_width(text);
		var text_height = string_height(text);
		var text_x = _x1;
		var text_y = _y + text_height;
		var text_box_width = text_width + (_margin * 2);
		var text_box_height = text_height + (_margin * 2);
		var text_box_x = text_x - (text_box_width / 2);
		var text_box_y = text_y - (text_box_height / 2);
		draw_sprite_stretched(spr_menu,0,text_box_x,text_box_y,text_box_width,text_box_height);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_set_color(c_white);
		draw_text(text_x,text_y,text);
	}
	text = "";
	if p2_charselect_state == charselectstates.char {
		text = charselect_name[p2_selecting_char];
	}
	if text != "" {
		var text_width = string_width(text);
		var text_height = string_height(text);
		var text_x = _x2;
		var text_y = _y + text_height;
		var text_box_width = text_width + (_margin * 2);
		var text_box_height = text_height + (_margin * 2);
		var text_box_x = text_x - (text_box_width / 2);
		var text_box_y = text_y - (text_box_height / 2);
		draw_sprite_stretched(spr_menu,0,text_box_x,text_box_y,text_box_width,text_box_height);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_set_color(c_white);
		draw_text(text_x,text_y,text);
	}
}

//function draw_charselect() {
//	var _w = display_get_gui_width();
//	var _h = display_get_gui_height();
//	var _w2	= _w / 2;
//	var _h2 = _h / 2;
//	var grid_size = 40;
//	var grid_x = (display_get_gui_width()/2) - (chars_per_row * grid_size / 2);
//	var grid_y = grid_size * 0.5;
//	var i = 0;
//	for(var ii = 0; ii < chars_per_column; ii++) {
//		for(var iii = 0; iii < chars_per_row; iii++) {
//			var _x1 = grid_x+(grid_size*iii);
//			var _y1 = grid_y+(grid_size*ii)
//			var _x2 = _x1+grid_size-2;
//			var _y2 = _y1+grid_size-2;
			
//			if p1_selecting_char == i
//			and p2_selecting_char == i {
//				draw_set_color(p_color);
//			}
//			else if p1_selecting_char == i {
//				draw_set_color(p1_color);
//			}
//			else if p2_selecting_char == i {
//				draw_set_color(p2_color);
//			}
//			else {
//				draw_set_color(c_black);
//			}
//			draw_set_alpha(0.75);
//			draw_rectangle(_x1,_y1,_x2,_y2,false);
			
//			draw_set_alpha(1);
//			draw_set_color(c_white);
//			draw_rectangle(_x1,_y1,_x2,_y2,true);
//			i += 1;
//		}
//	}
//	var i = 0;
//	for(var ii = 0; ii < chars_per_column; ii++) {
//		for(var iii = 0; iii < chars_per_row; iii++) {
//			var _x = grid_x+(grid_size*iii)+(grid_size/2);
//			var _y = grid_y+(grid_size*ii)+(grid_size/2);
//			if sprite_exists(charselect_icon[i]) {
//				draw_sprite(charselect_icon[i],0,_x,_y);
//			}
//			i += 1;
//		}
//	}
//	draw_set_font(fnt_assists);
//	var _margin = 4;
//	var text = "";
//	if p1_charselect_state == charselectstates.form {
//		text = "Selecione a forma."
//	}
//	else if p1_charselect_state == charselectstates.assist {
//		var text = "Assist [";
//		if p1_selecting_assist == assist_type.a {
//			text += "A";
//		}
//		else if p1_selecting_assist == assist_type.b {
//			text += "B";
//		}
//		else if p1_selecting_assist == assist_type.c {
//			text += "C";
//		}
//		text += "]: ";
//		text += charselect_assist[p1_selecting_char][p1_selecting_form][p1_selecting_assist];
//	}
//	if text != "" {
//		var text_width = string_width(text);
//		var text_height = string_height(text);
//		var text_x = _w * 0.25;
//		var text_y = _h2;
//		var text_box_width = text_width + (_margin * 2);
//		var text_box_height = text_height + (_margin * 2);
//		var text_box_x = text_x - (text_box_width / 2);
//		var text_box_y = text_y - (text_box_height / 2);
//		draw_sprite_stretched(spr_menu,0,text_box_x,text_box_y,text_box_width,text_box_height);
//		draw_set_halign(fa_center);
//		draw_set_valign(fa_middle);
//		draw_set_color(c_white);
//		draw_text(text_x,text_y,text);
//	}
//	text = "";
//	if p2_charselect_state == charselectstates.form {
//		text = "Selecione a forma."
//	}
//	else if p2_charselect_state == charselectstates.assist {
//		var text = "Assist [";
//		if p2_selecting_assist == assist_type.a {
//			text += "A";
//		}
//		else if p2_selecting_assist == assist_type.b {
//			text += "B";
//		}
//		else if p2_selecting_assist == assist_type.c {
//			text += "C";
//		}
//		text += "]: ";
//		text += charselect_assist[p2_selecting_char][p2_selecting_form][p2_selecting_assist];
//	}
//	if text != "" {
//		var text_width = string_width(text);
//		var text_height = string_height(text);
//		var text_x = _w * 0.75;
//		var text_y = _h2;
//		var text_box_width = text_width + (_margin * 2);
//		var text_box_height = text_height + (_margin * 2);
//		var text_box_x = text_x - (text_box_width / 2);
//		var text_box_y = text_y - (text_box_height / 2);
//		draw_sprite_stretched(spr_menu,0,text_box_x,text_box_y,text_box_width,text_box_height);
//		draw_set_halign(fa_center);
//		draw_set_valign(fa_middle);
//		draw_set_color(c_white);
//		draw_text(text_x,text_y,text);
//	}
//}

function draw_versus() {
	var active_players = 0;
	for(var i = 0; i < array_length(player_slot); i++) {
		if player_slot[i] != noone {
			active_players++;
		}
	}
	var _w = gui_width;
	var _h = gui_height;
	var _w2 = _w / max(3,active_players+1);
	var _h2 = _h / 2;
	var _x = _w2;
	var _y = 0;
	for(var i = 0; i < array_length(player_slot); i++) {
		if player_slot[i] != noone {
			var _portrait = get_char_portrait(player_char[i]);
			var _yscale = _h / sprite_get_height(_portrait);
			var _xscale = _yscale;
			
			if i >= active_players / 2 {
				_xscale *= -1;
			}
			
			draw_sprite_ext(_portrait,0,_x,_y,_xscale,_yscale,0,c_white,1);
			_x += _w2;
		}
	}
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_color(c_white);
}

function draw_pause() {
	draw_set_alpha(0.5);
	draw_set_color(c_black);
	draw_rectangle(0,0,display_get_gui_width(),display_get_gui_height(),false);
	draw_set_alpha(1);
	draw_set_color(c_white);
	draw_set_font(fnt_hud);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_text(display_get_gui_width()/2,display_get_gui_height()/2,"Jogo Pausado");
}

function draw_countdown() {
	draw_set_font(fnt_announcer);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	var text_x = display_get_gui_width()/2;
	var text_y = display_get_gui_height()/2;
	var _number = map_value(round_state_timer,0,round_countdown_duration,3.9,-1);
	var text = string(floor(_number));
	if _number < 1 {
		text = "LET IT RIP!";
		if _number > 0 {
			text_x += random_range(-5,5);
			text_y += random_range(-5,5);
		}
	}
	draw_set_alpha(0.5);
	draw_set_color(c_black);
	draw_text(text_x + 10, text_y + 15,text);
	draw_set_alpha(1);
	draw_set_color(make_color_rgb(192,0,0));
	draw_text(text_x + 3, text_y + 3,text);
	draw_set_color(c_white);
	draw_text(text_x, text_y,text);
}

function draw_knockout() {
	draw_set_font(fnt_announcer);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	var text_x = display_get_gui_width()/2;
	var text_y = display_get_gui_height()/2;
	var text = "K.O!";
	if round_state_timer < 10 {
		text_x += random_range(-5,5);
		text_y += random_range(-5,5);
	}
	draw_set_alpha(0.5);
	draw_set_color(c_black);
	draw_text(text_x + 10, text_y + 15,text);
	draw_set_alpha(1);
	draw_set_color(make_color_rgb(192,0,0));
	draw_text(text_x + 3, text_y + 3,text);
	draw_set_color(c_white);
	draw_text(text_x, text_y,text);
}

function draw_timeover() {
	draw_set_font(fnt_announcer);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	var text_x = display_get_gui_width()/2;
	var text_y = display_get_gui_height()/2;
	var text = "Time over...";
	draw_set_alpha(0.5);
	draw_set_color(c_black);
	draw_text(text_x + 10, text_y + 15,text);
	draw_set_alpha(1);
	draw_set_color(make_color_rgb(192,0,0));
	draw_text(text_x + 3, text_y + 3,text);
	draw_set_color(c_white);
	draw_text(text_x, text_y,text);
}

function draw_menu() {
	with(obj_menu) {
		draw_sprite_stretched(spr_menu,0,x-margin,y-margin,width_full,height_full);
		draw_set_font(fnt_menu);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
	
		var _desc = (description != -1);
		for(var i = 0; i < (options_count + _desc); i++) {
			draw_set_color(c_white);
			if (i == 0) and _desc {
				draw_text(x,y,description);
			}
			else {
				var _str = options[i-_desc][0];
				if hover == i - _desc {
					_str = hover_marker + _str;
					if !player2 {
						draw_set_color(c_yellow);
						with(obj_menu) {
							if id != other {
								if id == player2 {
									with(other) {
										draw_set_color(p1_color);
									}
								}
							}
						}
					}
					else {
						draw_set_color(p2_color);
					}
				}
				draw_text(x, y + (i * height_line), _str);
			}
		}
	}
}