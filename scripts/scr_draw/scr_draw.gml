// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function draw_text_outlined(_x,_y,_text,_outlinecolor,_text_color) {
	draw_set_color(_outlinecolor);
	draw_text(_x-1,_y,_text);
	draw_text(_x+1,_y,_text);
	draw_text(_x,_y-1,_text);
	draw_text(_x,_y+1,_text);
	
	draw_set_color(_text_color);
	draw_text(_x,_y,_text);
}

function draw_text_announcer(_x,_y,_text) {
	draw_set_font(fnt_announcer);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_alpha(0.5);
	draw_set_color(c_black);
	draw_text(_x + 10, _y + 15,_text);
	draw_set_alpha(1);
	draw_set_color(make_color_rgb(128,0,0));
	draw_text(_x + 3, _y + 3,_text);
	draw_set_color(c_white);
	draw_text(_x,_y,_text);
}

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
	for(var i = 0; i < array_length(player_slot); i++) {
		with(obj_helper) {
			if owner == player[i] {
				draw_my_playerindicator(i);
			}
		}
		with(player[i]) {
			draw_my_playerindicator(i);
		}
	}
}

function draw_my_playerindicator(_playerid = 0) {
	draw_set_halign(fa_center);
	draw_set_valign(fa_bottom);
	draw_set_font(fnt_playerindicator);
	
	var border = string_height("[]");
	
	var indicator_x = x;
	var indicator_y = y - 2;
	//var _height = (sprite_get_bbox_bottom(sprite) - sprite_get_bbox_top(sprite));
	indicator_y -= height * yscale * ystretch;
	indicator_y = clamp(
		indicator_y,
		camera_get_view_y(view)+border,
		camera_get_view_y(view)+camera_get_view_height(view)
	);
	
	var text = "[P"+string(_playerid+1)+"]";
	draw_text_outlined(indicator_x,indicator_y,text,c_black,player_color[_playerid]);
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
		if id == superfreeze_activator continue;
			
		draw_script();
	}
	with(obj_char) {
		if sprite_exists(aura_sprite) {
			gpu_set_blendmode(bm_add);
			var _scale = mean(
				width / sprite_get_width(aura_sprite),
				height / sprite_get_height(aura_sprite),
			) * 3;
			draw_sprite_ext(
				aura_sprite,
				floor(aura_frame),
				x,
				y + 5,
				_scale,
				_scale,
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
	var shadow_scale = -0.2;
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
	draw_timer();
	draw_playerhud();
}

function draw_playerhud() {
	var _w = gui_width;
	var _h = gui_height;
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
	
	var hud_w = _w / active_players;
	//var hud_h = (_spacing * 2) + hp_bar_height + mp_bar_height + tp_bar_height + playertext_height;
	var hud_x = 0;
	var hud_y = 0;

	var hp_border_width = (_w / active_players) - (_spacing * 2);
	var mp_border_width = hp_border_width * 0.75;
	var tp_border_width = mp_border_width * 0.75;
	var hp_xscale = hp_border_width / sprite_get_width(spr_bar_hp_border);
	var mp_xscale = mp_border_width / sprite_get_width(spr_bar_mp_border);
	var tp_xscale = tp_border_width / sprite_get_width(spr_bar_tp_border);
	
	//var hp_border_height = 24;
	//var mp_border_height = hp_border_height * 0.75;
	//var tp_border_height = mp_border_height * 0.75;
	//var hp_yscale = hp_border_height / sprite_get_height(spr_bar_hp_border);
	//var mp_yscale = mp_border_height / sprite_get_height(spr_bar_mp_border);
	//var tp_yscale = tp_border_height / sprite_get_height(spr_bar_tp_border);
	
	var hp_yscale = hp_xscale / 2;
	var mp_yscale = mp_xscale / 2;
	var tp_yscale = tp_xscale / 2;
	var hp_border_height = sprite_get_height(spr_bar_hp_border) * hp_yscale;
	var mp_border_height = sprite_get_height(spr_bar_mp_border) * mp_yscale;
	var tp_border_height = sprite_get_height(spr_bar_tp_border) * tp_yscale;
	
	var hp_bar_xoffset = 4 * hp_xscale;
	var hp_bar_yoffset = 4 * hp_yscale;
	
	var mp_bar_xoffset = 4 * mp_xscale;
	var mp_bar_yoffset = 4 * mp_yscale;
	
	var tp_bar_xoffset = 3 * tp_xscale;
	var tp_bar_yoffset = 2 * tp_yscale;
	
	var hp_bar_width = hp_border_width - (hp_bar_xoffset * 2);
	var mp_bar_width = mp_border_width - (mp_bar_xoffset * 2);
	var tp_bar_width = tp_border_width - (tp_bar_xoffset * 2);
	
	var hp_bar_height = hp_border_height - (hp_bar_yoffset * 2);
	var mp_bar_height = mp_border_height - (mp_bar_yoffset * 2);
	var tp_bar_height = tp_border_height - (tp_bar_yoffset * 2);
	
	var mp_stock_scale = mp_border_height / sprite_get_height(spr_bar_mp_stocks);
	var mp_stock_width = sprite_get_width(spr_bar_mp_stocks) * mp_stock_scale;
	var mp_stock_height = sprite_get_height(spr_bar_mp_stocks) * mp_stock_scale;
	var mp_stock_xoffset = 0;
	
	draw_set_font(fnt_hud);
	var playertext = "Player N: Anime Character";
	var playertext_width = string_width(playertext);
	var playertext_height = string_height(playertext);

	for (var i = 0; i < array_length(player_slot); i++) {
		var _right = hud_x >= _w2;
		var hp_border_x1, hp_border_x2, hp_border_y1, hp_border_y2;
		var mp_border_x1, mp_border_x2, mp_border_y1, mp_border_y2;
		var tp_border_x1, tp_border_x2, tp_border_y1, tp_border_y2;
		
		var hp_bar_x1, hp_bar_x2, hp_bar_y1, hp_bar_y2;
		var mp_bar_x1, mp_bar_x2, mp_bar_y1, mp_bar_y2;
		var tp_bar_x1, tp_bar_x2, tp_bar_y1, tp_bar_y2;

		if (!_right) {
			hp_border_x1 = hud_x + _spacing;
			hp_border_x2 = hp_border_x1 + hp_border_width;
			
			mp_border_x1 = hp_border_x1;
			mp_border_x2 = mp_border_x1 + mp_border_width;

			tp_border_x1 = hp_border_x1;
			tp_border_x2 = tp_border_x1 + tp_border_width;
		} 
		else {
			hp_border_x2 = hud_x + hud_w - _spacing;
			hp_border_x1 = hp_border_x2 - hp_border_width;
			
			mp_border_x2 = hp_border_x2;
			mp_border_x1 = mp_border_x2 - mp_border_width;
			
			tp_border_x2 = hp_border_x2;
			tp_border_x1 = tp_border_x2 - tp_border_width;
		}

		hp_border_y1 = hud_y + _spacing;
		hp_border_y2 = hp_border_y1 + hp_border_height;

		mp_border_y1 = hp_border_y2;
		mp_border_y2 = mp_border_y1 + mp_border_height;
		
		tp_border_y1 = mp_border_y2;
		tp_border_y2 = tp_border_y1 + tp_border_height;
		
		var hp_bar_x1, hp_bar_x2, hp_bar_y1, hp_bar_y2;
		var mp_bar_x1, mp_bar_x2, mp_bar_y1, mp_bar_y2;
		var tp_bar_x1, tp_bar_x2, tp_bar_y1, tp_bar_y2;
			
		hp_bar_x1 = hp_border_x1 + hp_bar_xoffset;
		hp_bar_x2 = hp_bar_x1 + hp_bar_width;
		hp_bar_y1 = hp_border_y1 + hp_bar_yoffset;
		hp_bar_y2 = hp_bar_y1 + hp_bar_height;
				
		mp_bar_x1 = mp_border_x1 + mp_bar_xoffset;
		mp_bar_x2 = mp_bar_x1 + mp_bar_width;
		mp_bar_y1 = mp_border_y1 + mp_bar_yoffset;
		mp_bar_y2 = mp_bar_y1 + mp_bar_height;
				
		tp_bar_x1 = tp_border_x1 + tp_bar_xoffset;
		tp_bar_x2 = tp_bar_x1 + tp_bar_width;
		tp_bar_y1 = tp_border_y1 + tp_bar_yoffset;
		tp_bar_y2 = tp_bar_y1 + tp_bar_height;

		with(player[i]) {
			if (!_right) {
				if (hp > 0) {
					var _hp_w = map_value(hp, 1, max_hp, 1, hp_bar_width);
					draw_sprite_stretched(spr_bar_hp_bar,0,hp_bar_x1,hp_bar_y1,_hp_w,hp_bar_height);

					if (combo_damage_taken > 0) {
						var _dmg_w = map_value(combo_damage_taken, 0, max_hp, 0, hp_bar_width);
						draw_sprite_stretched(spr_bar_hp_bar_damage,0,hp_bar_x1+_hp_w,hp_bar_y1,_dmg_w,hp_bar_height);
					}
				}

				if (mp > 0) {
					var _mp_w = map_value(mp, 1, max_mp, 1, mp_bar_width);
					draw_sprite_stretched(spr_bar_mp_bar,0,mp_bar_x1,mp_bar_y1,_mp_w,mp_bar_height);
				}
				
				if (tp > 0) {
					var _tp_w = map_value(tp, 1, max_tp, 1, tp_bar_width);
					draw_sprite_stretched(spr_bar_tp_bar,0,tp_bar_x1,tp_bar_y1,_tp_w,tp_bar_height);
				}
				draw_sprite_ext(spr_bar_hp_border,0,hp_border_x1,hp_border_y1,hp_xscale,hp_yscale,0,c_white,1);
				draw_sprite_ext(spr_bar_mp_border,0,mp_border_x1,mp_border_y1,mp_xscale,mp_yscale,0,c_white,1);
				draw_sprite_ext(spr_bar_tp_border,0,tp_border_x1,tp_border_y1,tp_xscale,tp_yscale,0,c_white,1);
				
				draw_sprite_ext(
					spr_bar_mp_stocks,
					0,
					mp_border_x1 - mp_stock_xoffset,
					mp_border_y1,
					mp_stock_scale,
					mp_stock_scale,
					0,
					c_white,
					1
				);
				
				//draw_set_color(c_yellow);
				//draw_set_halign(fa_top);
				//draw_set_valign(fa_right);
				//draw_set_font(fnt_hud);
				//draw_text(mp_border_x1,mp_
			}
			else {
				if (hp > 0) {
					var _hp_w = map_value(hp, 1, max_hp, 1, hp_bar_width);
					draw_sprite_stretched(spr_bar_hp_bar,0,hp_bar_x2 - _hp_w,hp_bar_y1,_hp_w,hp_bar_height);

					if (combo_damage_taken > 0) {
						var _dmg_w = map_value(combo_damage_taken, 0, max_hp, 0, hp_bar_width);
						draw_sprite_stretched(spr_bar_hp_bar_damage,0,hp_bar_x2-_hp_w-_dmg_w,hp_bar_y1,_dmg_w,hp_bar_height);
					}
				}

				if (mp > 0) {
					var _mp_w = map_value(mp, 1, max_mp, 1, mp_bar_width);
					draw_sprite_stretched(spr_bar_mp_bar,0,mp_bar_x2-_mp_w,mp_bar_y1,_mp_w,mp_bar_height);
				}
				
				if (tp > 0) {
					var _tp_w = map_value(tp, 1, max_tp, 1, tp_bar_width);
					draw_sprite_stretched(spr_bar_tp_bar,0,tp_bar_x2-_tp_w,tp_bar_y1,_tp_w,tp_bar_height);
				}
				draw_sprite_ext(spr_bar_hp_border,0,hp_border_x2, hp_border_y1,-hp_xscale,hp_yscale,0,c_white,1);
				draw_sprite_ext(spr_bar_mp_border,0,mp_border_x2, mp_border_y1,-mp_xscale,mp_yscale,0,c_white,1);
				draw_sprite_ext(spr_bar_tp_border,0,tp_border_x2, tp_border_y1,-tp_xscale,tp_yscale,0,c_white,1);
				
				draw_sprite_ext(
					spr_bar_mp_stocks,
					0,
					mp_border_x2 + mp_stock_xoffset,
					mp_border_y1,
					-mp_stock_scale,
					mp_stock_scale,
					0,
					c_white,
					1
				);
			}
			
			draw_set_font(fnt_hud);
			draw_set_halign(fa_left);
			draw_set_valign(fa_top);
			var playertext = "Player " + string(i+1) + ": " + name;
			playertext += "\n" + "Level " + string(level); 
			var playertext_width = string_width(playertext);
			var playertext_height = string_height(playertext);
			var playertext_x1 = hp_border_x1;
			var playertext_y1 = tp_border_y2 + 1;
			var playertext_x2 = playertext_x1 + playertext_width;
			var playertext_y2 = playertext_y1 + playertext_height;
			
			if _right {
				playertext_x2 = hp_border_x2;
				playertext_x1 = playertext_x2 - playertext_width;
				
				draw_set_halign(fa_right);
				draw_text_outlined(playertext_x2,playertext_y1,playertext,c_black,player_color[i]);
			}
			else {
				draw_set_halign(fa_left);
				draw_text_outlined(playertext_x1,playertext_y1,playertext,c_black,player_color[i]);
			}
			
			hud_x += hud_w;
		}
	}
}

function draw_timer() {
	draw_set_font(fnt_timer);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	
	draw_set_color(c_white);
	
	var _timer_sprite = spr_timer2;
	var _timer_x = gui_width/2;
	var _timer_y = gui_height + 1 - (sprite_get_height(_timer_sprite) - sprite_get_yoffset(_timer_sprite));
	var _timer_text = string(ceil(round_timer / 60));
	
	draw_sprite(_timer_sprite,0,_timer_x,_timer_y);
	
	draw_set_color(make_color_rgb(255,255,0));
	draw_text(_timer_x,_timer_y,_timer_text);
	
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_color(c_white);
}

function draw_hitboxes() {
	with(obj_hitbox_parent) {
		draw_self();
	}
}

function draw_portraits() {
	var _w = gui_width;
	var _h = gui_height;
	var _x1 = _w * 0.1;
	var _x2 = _w * 0.9;
	var _y = _h * 0.5;
	var size = gui_height / 4;
	
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
	draw_rectangle(0,0,gui_width,gui_height,false);
	draw_set_alpha(1);
	draw_set_color(c_white);
	draw_set_font(fnt_hud);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_text(gui_width/2,gui_height/2,"Jogo Pausado");
}

function draw_countdown() {
	var text_x = gui_width/2;
	var text_y = gui_height/2;
	var _number = map_value(round_state_timer,0,round_countdown_duration,3.9,-1);
	var text = string(floor(_number));
	if _number < 1 {
		text = "LET IT RIP!";
		if _number > 0 {
			text_x += random_range(-5,5);
			text_y += random_range(-5,5);
		}
	}
	draw_text_announcer(text_x,text_y,text);
}

function draw_knockout() {
	var text_x = gui_width/2;
	var text_y = gui_height/2;
	var text = "K.O!";
	if round_state_timer < 10 {
		text_x += random_range(-5,5);
		text_y += random_range(-5,5);
	}
	draw_text_announcer(text_x,text_y,text);
}

function draw_timeover() {
	var text_x = gui_width/2;
	var text_y = gui_height/2;
	var text = "Time over...";
	draw_text_announcer(text_x,text_y,text);
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
					draw_set_color(c_yellow);
				}
				else {
					draw_set_color(c_white);
				}
				draw_text(x, y + (i * height_line), _str);
			}
		}
	}
}