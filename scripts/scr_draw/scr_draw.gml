// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function draw_ground() {
	if sprite_exists(ground_sprite) {
		var ground_x = (-room_width/2)+screen_shake_x;
		var ground_y = ground_height-sprite_get_yoffset(ground_sprite)+screen_shake_y;
		var ground_w = room_width * 2;
		var ground_h = (room_height-ground_height)*1.25;
		draw_sprite_stretched(ground_sprite,0,ground_x,ground_y,ground_w,ground_h);
	}
}

function draw_playerindicators() {
	draw_set_halign(fa_center);
	draw_set_valign(fa_bottom);
	draw_set_font(fnt_playerindicator);
	var border = string_height("[]");
	for(var i = 0; i < array_length(player); i++) {
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
			draw_set_color(p1_color);
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
			var _x = x + (xoffset*facing) + screen_shake_x;
			var _y = y + yoffset + screen_shake_y;
			_x += random(hitstop)*choose(1,-1);
			_y += random(hitstop)*choose(1,-1)*is_airborne;
		
			if flash {
				gpu_set_fog(true,flash_color,0,0);
			}
			
			if weapon_enabled {
				if sprite == swing_sprite
				or sprite == thrust_sprite
				or sprite == shoot_sprite {
					var weapon_x = _x + lengthdir_x(32,rotation+90);
					var weapon_y = _y + lengthdir_y(32,rotation+90);
					draw_sprite_ext(
						weapon_sprite,
						frame,
						weapon_x,
						weapon_y,
						xscale*xstretch*facing,
						yscale*ystretch,
						rotation*facing*sign(xscale)*sign(xstretch),
						color,
						alpha
					);
				}
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
	
	draw_playerindicators();
}

function draw_char_shadows() {
	var shadow_scale = 0.2;
	var shadow_alpha = 0.5;
	with(obj_char) {
		var _x = x + (xoffset*facing) + screen_shake_x;
		var _y = ground_height + screen_shake_y;
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
			var _x = x + (xoffset*facing) + screen_shake_x;
			var _y = y + yoffset + screen_shake_y;
		
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
	
	draw_set_font(fnt_timer);
	var text_max = string(round(round_timer_max / 60)*10);
	var text_width = string_width(text_max);
	var text_height = string_height(text_max);
	
	var active_players = 0;
	for(var i = 0; i < array_length(player_slot); i++) {
		if player_slot[i] != noone {
			active_players++;
		}
	}
	
	var hp_bar_width = (_w / active_players) - _spacing - icon_size;
	var hp_bar_height = icon_size;
	var other_bar_width = 10;
	var other_bar_height = 50;
	
	var hp_y1 = _spacing;
	var hp_y2 = hp_y1 + hp_bar_height
	
	var icon_y = hp_y1 + (hp_bar_height/2);
	
	var mp_y1 = _h - _spacing - mp_bar_height;
	var mp_y2 = mp_y1 + mp_bar_height;
	
	var tp_y1 = _h - _spacing - tp_bar_height;
	var tp_y2 = tp_y1 + tp_bar_height;
	
	var sp_y1 = _h - _spacing - sp_bar_height;
	var sp_y2 = sp_y1 + sp_bar_height;
	
	var hp_color = make_color_rgb(0,255,0);
	var dmg_color = make_color_rgb(255,0,0);
	var mp_color = make_color_rgb(64,192,255);
	var tp_color = make_color_rgb(255,255,255);
	var sp_color = make_color_rgb(255,255,0);
		
	for(var i = 0; i < array_length(player); i++) {
		var hp_x1 = _spacing + icon_size + (hp_bar_width * i);
		var hp_x2 = _x1 + hp_bar_width;
		var hp_y1 = hp_y1;
		var hp_y2 = _y1 + hp_bar_height;
		
		var mp_x1 = hp_x1;
		var mp_x2 = mp_x1 + other_bar_width;
		
		with(player[i]) {
			draw_set_color(c_black);
			draw_set_alpha(1);
			draw_rectangle(_x1,_y1,_x2,_y2,false);
		
			if hp_percent > 0 {
				var _hp_x = map_value(hp_percent,0,100,hp1_x1+1,hp1_x2-1);
				draw_set_color(hp_color);
				draw_set_alpha(1);
				draw_rectangle(
					hp1_x1+1,
					_y1+1,
					_hp_x,
					_y2-1,
					false
				);
			
				if combo_damage_taken > 0 {
					var _dmg_x = map_value(hp+combo_damage_taken,0,max_hp,hp1_x1+1,hp1_x2-1);
					draw_set_color(dmg_color);
					draw_set_alpha(1);
					draw_rectangle(
						_hp_x+1,
						_y1+1,
						_dmg_x,
						_y2-1,
						false
					);
				}
			}
			draw_sprite_ext(icon,0,_x1 - icon_size,icon_y,icon_scale,icon_scale,0,c_white,1);
		}
	}
	
	draw_set_font(fnt_timer);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	var text = string(ceil(clamp(round_timer,0,round_timer_max) / 60));
	var text_x = _w2;
	var text_y = hp_y2 + (text_height/2);
	if _w - (hp_bar_width * 2) - (_spacing * 2) - (icon_size * 2) > text_width {
		text_y = mean(hp_y1,hp_y2);
	}
	
	var text_x1 = text_x - (text_width / 2) + 1;
	var text_x2 = text_x + (text_width / 2) - 1;
	var text_y1 = text_y - (text_height / 2);
	var text_y2 = text_y + (text_height / 2);
	draw_set_color(c_black);
	draw_rectangle(text_x1,text_y1,text_x2,text_y2,false);
	draw_set_color(c_white);
	draw_text(text_x,text_y,text);
	
	var hp_segments = 4;
	for(var i = 0; i < hp_segments - 1; i++) {
		var _x1 = map_value(i,-1,hp_segments-1,hp1_x1,hp1_x2);
		var _x2 = map_value(i,-1,hp_segments-1,hp2_x1,hp2_x2);
		var _y1 = hp_y1;
		var _y2 = hp_y2-1;
		draw_set_color(c_black);
		draw_line(_x1,_y1,_x1,_y2);
		draw_line(_x2,_y1,_x2,_y2);
	}
	for(var i = 0; i < max_mp_stocks - 1; i++) {
		var _y = map_value(i,-1,max_mp_stocks - 1,mp_y1,mp_y2)-1;
		draw_set_color(c_black);
		draw_line(mp1_x1-1,_y,mp1_x2,_y);
		draw_line(mp2_x1-1,_y,mp2_x2,_y);
	}
	for(var i = 0; i < max_sp_stocks - 1; i++) {
		var _y = map_value(i,-1,max_sp_stocks - 1,sp_y1,sp_y2)-1;
		draw_set_color(c_black);
		draw_line(sp1_x1-1,_y,sp1_x2,_y);
		draw_line(sp2_x1-1,_y,sp2_x2,_y);
	}
	for(var i = 0; i < max_tp_stocks - 1; i++) {
		var _y = map_value(i,-1,max_tp_stocks - 1,tp_y1,tp_y2)-1;
		draw_set_color(c_black);
		draw_line(tp1_x1-1,_y,tp1_x2,_y);
		draw_line(tp2_x1-1,_y,tp2_x2,_y);
	}
	
	if p1_combo_timer > 0 {
		draw_set_font(fnt_combo);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		var text_x = _w * 0.1;
		var text_y = hp_y2 + 16;
		var text = string(p1_combo_hits) + " Acerto";
		if p1_combo_hits > 1 {
			text += "s";
		}
		text += "!";
		text += "\n" + string(p1_combo_damage) + " de dano!";
		text_x += random(p2_active_character.hitstop);
		text_y += random(p2_active_character.hitstop);
		draw_set_alpha(0.5);
		draw_set_color(c_black);
		draw_text(text_x + 3, text_y + 5,text);
		draw_set_alpha(1);
		draw_set_color(p1_color);
		draw_text(text_x + 2, text_y + 2,text);
		draw_set_color(c_white);
		draw_text(text_x, text_y,text);
	}
	if p2_combo_timer > 0 {
		draw_set_font(fnt_combo);
		draw_set_halign(fa_right);
		draw_set_valign(fa_top);
		var text_x = _w * 0.9;
		var text_y = hp_y2 + 16;
		var text = string(p2_combo_hits) + " Acerto";
		if p2_combo_hits > 1 {
			text += "s";
		}
		text += "!";
		text += "\n" + string(p2_combo_damage) + " de dano!";
		text_x -= random(p1_active_character.hitstop);
		text_y += random(p1_active_character.hitstop);
		draw_set_alpha(0.5);
		draw_set_color(c_black);
		draw_text(text_x + 3, text_y + 5,text);
		draw_set_alpha(1);
		draw_set_color(p2_color);
		draw_text(text_x + 2, text_y + 2,text);
		draw_set_color(c_white);
		draw_text(text_x, text_y,text);
	}
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

function draw_charselect() {
	var _w = display_get_gui_width();
	var _h = display_get_gui_height();
	var _w2	= _w / 2;
	var _h2 = _h / 2;
	var grid_size = 40;
	var grid_x = (display_get_gui_width()/2) - (chars_per_row * grid_size / 2);
	var grid_y = grid_size * 0.5;
	var i = 0;
	for(var ii = 0; ii < chars_per_column; ii++) {
		for(var iii = 0; iii < chars_per_row; iii++) {
			var _x1 = grid_x+(grid_size*iii);
			var _y1 = grid_y+(grid_size*ii)
			var _x2 = _x1+grid_size-2;
			var _y2 = _y1+grid_size-2;
			
			if p1_selecting_char == i
			and p2_selecting_char == i {
				draw_set_color(p_color);
			}
			else if p1_selecting_char == i {
				draw_set_color(p1_color);
			}
			else if p2_selecting_char == i {
				draw_set_color(p2_color);
			}
			else {
				draw_set_color(c_black);
			}
			draw_set_alpha(0.75);
			draw_rectangle(_x1,_y1,_x2,_y2,false);
			
			draw_set_alpha(1);
			draw_set_color(c_white);
			draw_rectangle(_x1,_y1,_x2,_y2,true);
			i += 1;
		}
	}
	var i = 0;
	for(var ii = 0; ii < chars_per_column; ii++) {
		for(var iii = 0; iii < chars_per_row; iii++) {
			var _x = grid_x+(grid_size*iii)+(grid_size/2);
			var _y = grid_y+(grid_size*ii)+(grid_size/2);
			if sprite_exists(charselect_icon[i]) {
				draw_sprite(charselect_icon[i],0,_x,_y);
			}
			i += 1;
		}
	}
	draw_set_font(fnt_assists);
	var _margin = 4;
	var text = "";
	if p1_charselect_state == charselectstates.form {
		text = "Selecione a forma."
	}
	else if p1_charselect_state == charselectstates.assist {
		var text = "Assist [";
		if p1_selecting_assist == assist_type.a {
			text += "A";
		}
		else if p1_selecting_assist == assist_type.b {
			text += "B";
		}
		else if p1_selecting_assist == assist_type.c {
			text += "C";
		}
		text += "]: ";
		text += charselect_assist[p1_selecting_char][p1_selecting_form][p1_selecting_assist];
	}
	if text != "" {
		var text_width = string_width(text);
		var text_height = string_height(text);
		var text_x = _w * 0.25;
		var text_y = _h2;
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
	if p2_charselect_state == charselectstates.form {
		text = "Selecione a forma."
	}
	else if p2_charselect_state == charselectstates.assist {
		var text = "Assist [";
		if p2_selecting_assist == assist_type.a {
			text += "A";
		}
		else if p2_selecting_assist == assist_type.b {
			text += "B";
		}
		else if p2_selecting_assist == assist_type.c {
			text += "C";
		}
		text += "]: ";
		text += charselect_assist[p2_selecting_char][p2_selecting_form][p2_selecting_assist];
	}
	if text != "" {
		var text_width = string_width(text);
		var text_height = string_height(text);
		var text_x = _w * 0.75;
		var text_y = _h2;
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
	var _w = display_get_gui_width();
	var _h = display_get_gui_height();
	var _w2 = _w / 2;
	var _h2 = _h / 2;
	var _size = _h / 3;
	var _spacing = _size / 2;
	for(var i = 0; i < max_team_size; i++) {
		var p1_portrait = charselect_portrait[p1_selected_char[i]][p1_selected_form[i]];
		var p2_portrait = charselect_portrait[p2_selected_char[i]][p2_selected_form[i]];
		
		var _x1 = _w2 - _size - (_spacing * -i);
		var _x2 = _w2 + _size + (_spacing * i);
		var _y = _h2 + (_size / 2) + ((_spacing / 2) * i);
		
		var _scale1 = _size / sprite_get_height(p1_portrait);
		var _scale2 = _size / sprite_get_height(p2_portrait);
		
		draw_sprite_ext(p1_portrait,0,_x1,_y,_scale1,_scale1,0,c_white,1);
		draw_sprite_ext(p2_portrait,0,_x2,_y,-_scale2,_scale2,0,c_white,1);
	}
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