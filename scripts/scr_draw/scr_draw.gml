function draw_chars() {
	var draw_order = ds_priority_create();
	with(obj_char) {
		ds_priority_add(draw_order,id,depth);
	}
	while(!ds_priority_empty(draw_order)) {
		with(ds_priority_find_max(draw_order)) {
			var _x = x + (xoffset*facing);
			var _y = y + yoffset;
			_x += hitstop_shake();
			_y += hitstop_shake() * is_airborne;
			
			if hue != 0 {
				shader_set(sha_hue_shift); //Change this to whatever name you gave your shader.
				shader_set_uniform_f(u_hue, (-hue/255)*(pi*2));
			}
			
			if sprite_exists(sprite) {
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
			}
			
			if id != superfreeze_activator {
				draw_script();
			}
			
			shader_reset();
			
			if flash_alpha > 0 {
				shader_set(sha_flash);
				if sprite_exists(sprite) {
					draw_sprite_ext(
						sprite,
						frame,
						_x,
						_y,
						xscale*xstretch*facing,
						yscale*ystretch,
						rotation*facing*sign(xscale)*sign(xstretch),
						flash_color,
						flash_alpha
					);
				}
			}
			
			shader_reset();
			
			draw_aura();
		}
		ds_priority_delete_max(draw_order);
	}
	ds_priority_destroy(draw_order);
	
	draw_playerindicators();
}

function hitstop_shake() {
	var _shake = hitstop;
	_shake /= get_attack_hitstop(attackstrength.light) / 2;
	_shake = random(_shake);
	_shake *= hitstop mod 2 == 0 ? -1 : 1;
	return _shake;
}

function draw_char_shadows() {
	var _shadow_scale = -0.25;
	var _shadow_alpha = 0.5;
	with(obj_char) {
		var _distance_to_ground = ground_height - (y + yoffset);
		var _x = x + (xoffset*facing);
		var _y = ground_height - 2;
		_y -= _distance_to_ground * _shadow_scale;
		_x += hitstop_shake();
		_y += hitstop_shake() * is_airborne;
		
		draw_sprite_ext(
			sprite,
			frame,
			_x,
			_y,
			xscale*xstretch*facing,
			yscale*ystretch*_shadow_scale,
			0,
			c_black,
			alpha * _shadow_alpha
		);
	}
}

function draw_text_outlined(_x,_y,_text,_outlinecolor,_text_color,_scale = 1) {
	draw_set_color(_outlinecolor);
	draw_text_transformed(_x-_scale,_y,_text,_scale,_scale,0);
	draw_text_transformed(_x+_scale,_y,_text,_scale,_scale,0);
	draw_text_transformed(_x,_y-_scale,_text,_scale,_scale,0);
	draw_text_transformed(_x,_y+_scale,_text,_scale,_scale,0);
	
	draw_set_color(_text_color);
	draw_text_transformed(_x,_y,_text,_scale,_scale,0);
}

function draw_text_announcer(_x,_y,_text) {
	draw_set_font(fnt_announcer);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_alpha(0.5);
	draw_set_color(c_black);
	draw_text(_x + 10, _y + 15,_text);
	draw_set_alpha(1);
	draw_set_color(make_color_rgb(192,0,0));
	draw_text(_x + 3, _y + 3,_text);
	draw_set_color(c_white);
	draw_text(_x,_y,_text);
}

function draw_ground() {
	if sprite_exists(ground_sprite) {
		var ground_w = room_width * 1.5;
		var ground_h = (room_height-ground_height)*1.5;
		var ground_x = -ground_w / 3;
		var ground_y = ground_height-sprite_get_yoffset(ground_sprite);
		draw_sprite_stretched(ground_sprite,0,ground_x,ground_y,ground_w,ground_h);
	}
	draw_char_shadows();
}

function draw_playerindicators() {
	for(var i = 0; i < max_players; i++) {
		with(obj_helper) {
			if owner == player[i] {
				draw_my_playerindicator(i);
			}
		}
		with(player[i]) {
			//draw_my_playerindicator(i);
		}
	}
}

function draw_my_playerindicator(_playerid = 0) {
	draw_set_font(fnt_playerindicator);
	draw_set_halign(fa_center);
	draw_set_valign(fa_bottom);
	
	var _scale = 1/camera_zoom;
	var _border = string_height("[]") * _scale;
	
	var _height = sprite_get_height(idle_sprite);
	var indicator_x = x;
	var indicator_y = y - _height - 5;
	repeat(2) {
		if indicator_y > y - _height {
			indicator_y = y + _border + 5;
		}
		
		indicator_y = clamp(
			indicator_y,
			camera_get_view_y(camera)+(hud_height*_scale)+_border,
			camera_get_view_y(camera)+camera_get_view_height(camera)
		);
	}
	
	var text = "[P"+string(_playerid+1)+"]";
	draw_text_outlined(indicator_x,indicator_y,text,c_black,player_color[_playerid],_scale);
}

function draw_aura() {
	if sprite_exists(aura_sprite) {
		gpu_set_blendmode(bm_add);
		var _scale = mean(
			width / sprite_get_width(aura_sprite),
			height / sprite_get_height(aura_sprite)
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
			xscale*xstretch*facing,
			yscale*ystretch,
			rotation*facing,
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
		var _x1 = camera_get_view_x(camera);
		var _y1 = camera_get_view_y(camera);
		var _x2 = _x1 + camera_get_view_width(camera);
		var _y2 = _y1 + camera_get_view_height(camera);
		draw_rectangle(_x1,_y1,_x2,_y2,false);
		draw_set_alpha(1);
		draw_set_color(c_white);
		with(superfreeze_activator) {
			var _x = x + (xoffset*facing);
			var _y = y + yoffset;
		
			if hue != 0 {
				shader_set(sha_hue_shift); //Change this to whatever name you gave your shader.
				shader_set_uniform_f(u_hue, (-hue/255)*(pi*2));
			}
			
			if sprite_exists(sprite) {
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
			}
			
			draw_script();
			
			shader_reset();
			
			if flash_alpha > 0 {
				shader_set(sha_flash);
				if sprite_exists(sprite) {
					draw_sprite_ext(
						sprite,
						frame,
						_x,
						_y,
						xscale*xstretch*facing,
						yscale*ystretch,
						rotation*facing*sign(xscale)*sign(xstretch),
						flash_color,
						flash_alpha
					);
				}
			}
			
			shader_reset();
			
			draw_aura();
		}
	}
}

function draw_particles() {
	part_system_drawit(particle_system);
	
	with(obj_specialeffect) {
		if blend {
			gpu_set_blendmode(bm_add);
		}
		var _x = x + (xoffset*facing);
		var _y = y + yoffset;
		draw_sprite_ext(
			sprite,
			frame,
			_x,
			_y,
			xscale*xstretch,
			yscale*ystretch,
			rotation*facing*sign(xscale)*sign(xstretch),
			color,
			alpha
		);
		gpu_set_blendmode(bm_normal);
	}
}

function draw_screenfade() {
	var _w = gui_width;
	var _h = gui_height;
	var _w2 = _w / 2;
	var _h2 = _h / 2;
	
	var fade_in_time1 = 0;
	var fade_in_time2 = screen_fade_duration;
	var fade_out_time1 = game_state_duration - screen_fade_duration;
	var fade_out_time2 = game_state_duration;
	
	var fade_in = (game_state_timer < fade_in_time2);
	var fade_out = ((next_game_state != -1) and (game_state_timer > fade_out_time1));
	
	var _fade = 0;
	if fade_in {
		_fade = map_value(game_state_timer,fade_in_time1,fade_in_time2,2,0);
	}
	if fade_out {
		_fade = map_value(game_state_timer,fade_out_time1,fade_out_time2,0,2);
	}
	_fade = clamp(_fade,0,1);
	
	if fade_in or fade_out {
		draw_set_color(screen_fade_color);
		switch(screen_fade_type) {
			default:
			draw_set_alpha(clamp(_fade,0,1));
			draw_rectangle(0,0,_w,_h,false);
			break;
			
			case fade_types.bottom:
			gpu_set_blendmode(bm_subtract);
			if fade_out {
				var _y = map_value(_fade,0,1,_h,-_h);
				draw_sprite_stretched(spr_fade_bottom,0,0,_y,_w,_h*2);
			}
			else {
				var _y = map_value(_fade,1,0,0,-_h*2);
				draw_sprite_stretched(spr_fade_top,0,0,_y,_w,_h*2);
			}
			gpu_set_blendmode(bm_normal);
			break;
		}
	}
	draw_set_alpha(1);
	//draw_text_outlined(32,32,string(game_state_timer-fade_in_time2),c_black,c_white);
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
	
	var _spacing = 8;
	
	var icon_size = average_char_icon_height;
	var icon_scale = 1;
	var icon_w = (icon_size * icon_scale);
	var icon_h = icon_w;
	var icon_w2 = icon_w / 2;
	var icon_h2 = icon_h / 2;
	
	var active_players = 0;
	for (var i = 0; i < max_players; i++) {
		if player_slot[i] != noone {
			active_players++;
		}
	}
	
	var team1_members = ceil(active_players/2);
	var team2_members = floor(active_players/2);
	
	var hud_w = _w2;
	var hud_h = 0;
	var hud_x = 0;
	var hud_y = 0;

	var hp_border_width = ((hud_w) - (_spacing * 2));
	var mp_border_width = (hp_border_width * 0.8);
	var tp_border_width = (hp_border_width * 0.2);
	var xp_border_width = (tp_border_width);
	var hp_xscale = hp_border_width / sprite_get_width(spr_bar_hp_border);
	var mp_xscale = mp_border_width / sprite_get_width(spr_bar_mp_border);
	var tp_xscale = tp_border_width / sprite_get_width(spr_bar_tp_border);
	var xp_xscale = xp_border_width / sprite_get_width(spr_bar_xp_border);
	
	var hud_yscale = min(1,1.5 / max(team1_members,team2_members));
	
	var hp_border_height = 20 * hud_yscale;
	var mp_border_height = 15 * hud_yscale;
	var tp_border_height = 10;
	var xp_border_height = tp_border_height;
	var hp_yscale = hp_border_height / sprite_get_height(spr_bar_hp_border);
	var mp_yscale = mp_border_height / sprite_get_height(spr_bar_mp_border);
	var tp_yscale = tp_border_height / sprite_get_height(spr_bar_tp_border);
	var xp_yscale = xp_border_height / sprite_get_height(spr_bar_xp_border);
	
	//var hp_yscale = 1.4 * hud_yscale;
	//var mp_yscale = 1.3 * hud_yscale;
	//var tp_yscale = 1.2 * hud_yscale;
	//var xp_yscale = 1.1 * hud_yscale;
	//var hp_border_height = (sprite_get_height(spr_bar_hp_border) * hp_yscale);
	//var mp_border_height = (sprite_get_height(spr_bar_mp_border) * mp_yscale);
	//var tp_border_height = (sprite_get_height(spr_bar_tp_border) * tp_yscale);
	//var xp_border_height = (sprite_get_height(spr_bar_xp_border) * xp_yscale);
	
	var hp_border_xoffset = _spacing;
	var hp_border_yoffset = _spacing;
	var mp_border_xoffset = _spacing;
	var mp_border_yoffset = _h - _spacing - mp_border_height;
	var tp_border_xoffset = hp_border_xoffset + (hp_border_width / 2) - tp_border_width;
	var tp_border_yoffset = hp_border_yoffset + hp_border_height;
	var xp_border_xoffset = hp_border_xoffset + (hp_border_width / 2);
	var xp_border_yoffset = hp_border_yoffset + hp_border_height;
	
	var hp_bar_xoffset = 3;
	var hp_bar_yoffset = 3;
	var mp_bar_xoffset = 3;
	var mp_bar_yoffset = 3;
	var tp_bar_xoffset = 2;
	var tp_bar_yoffset = 2;
	var xp_bar_xoffset = 3;
	var xp_bar_yoffset = 3;
	
	var hp_bar_width = (hp_border_width - (hp_bar_xoffset * 2));
	var mp_bar_width = (mp_border_width - (mp_bar_xoffset * 2));
	var tp_bar_width = (tp_border_width - (tp_bar_xoffset * 2));
	var xp_bar_width = (xp_border_width - (xp_bar_xoffset * 2));
	
	var hp_bar_height = (hp_border_height - (hp_bar_yoffset * 2));
	var mp_bar_height = (mp_border_height - (mp_bar_yoffset * 2));
	var tp_bar_height = (tp_border_height - (tp_bar_yoffset * 2));
	var xp_bar_height = (xp_border_height - (xp_bar_yoffset * 2));
	
	var mp_stock_scale = mp_border_height / sprite_get_height(spr_bar_mp_stocks);
	var mp_stock_width = sprite_get_width(spr_bar_mp_stocks) * mp_stock_scale;
	var mp_stock_height = sprite_get_height(spr_bar_mp_stocks) * mp_stock_scale;
	var mp_stock_xoffset = -mp_stock_width / 2;
	
	mp_border_xoffset += mp_stock_width / 2;
	
	draw_set_font(fnt_hud);
	var playertext = "Player N: Anime Character";
	var playertext_width = string_width(playertext);
	var playertext_height = string_height(playertext);
	
	var drawn_players = 0;
	var drawn_t1_players = 0;
	var drawn_t2_players = 0;

	for (var i = 0; i < max_players; i++) {
		var _right = drawn_players >= team1_members;
		var hp_border_x1, hp_border_x2, hp_border_y1, hp_border_y2;
		var mp_border_x1, mp_border_x2, mp_border_y1, mp_border_y2;
		var tp_border_x1, tp_border_x2, tp_border_y1, tp_border_y2;
		var xp_border_x1, xp_border_x2, xp_border_y1, xp_border_y2;
		
		var hp_bar_x1, hp_bar_x2, hp_bar_y1, hp_bar_y2;
		var mp_bar_x1, mp_bar_x2, mp_bar_y1, mp_bar_y2;
		var tp_bar_x1, tp_bar_x2, tp_bar_y1, tp_bar_y2;
		var xp_bar_x1, xp_bar_x2, xp_bar_y1, xp_bar_y2;

		if (!_right) {
			hp_border_x1 = hud_x + hp_border_xoffset;
			hp_border_x2 = hp_border_x1 + hp_border_width;
			
			mp_border_x1 = hud_x + mp_border_xoffset;
			mp_border_x2 = mp_border_x1 + mp_border_width;

			tp_border_x1 = hud_x + tp_border_xoffset;
			tp_border_x2 = tp_border_x1 + tp_border_width;

			xp_border_x1 = hud_x + xp_border_xoffset;
			xp_border_x2 = xp_border_x1 + xp_border_width;
		} 
		else {
			hp_border_x2 = hud_x + hud_w - hp_border_xoffset;
			hp_border_x1 = hp_border_x2 - hp_border_width;
			
			mp_border_x2 = hud_x + hud_w - mp_border_xoffset;
			mp_border_x1 = mp_border_x2 - mp_border_width;
			
			tp_border_x2 = hud_x + hud_w - tp_border_xoffset;
			tp_border_x1 = tp_border_x2 - tp_border_width;
			
			xp_border_x2 = hud_x + hud_w - xp_border_xoffset;
			xp_border_x1 = xp_border_x2 - xp_border_width;
		}

		hp_border_y1 = hud_y + hp_border_yoffset;
		hp_border_y2 = hp_border_y1 + hp_border_height;

		mp_border_y1 = hud_y + mp_border_yoffset;
		mp_border_y2 = mp_border_y1 + mp_border_height;
		
		tp_border_y1 = hud_y + tp_border_yoffset;
		tp_border_y2 = tp_border_y1 + tp_border_height;
		
		xp_border_y1 = hud_y + xp_border_yoffset;
		xp_border_y2 = xp_border_y1 + xp_border_height;
			
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
				
		xp_bar_x1 = xp_border_x1 + xp_bar_xoffset;
		xp_bar_x2 = xp_bar_x1 + xp_bar_width;
		xp_bar_y1 = xp_border_y1 + xp_bar_yoffset;
		xp_bar_y2 = xp_bar_y1 + xp_bar_height;
				
		var _alpha = 1;

		with(player[i]) {
			if (hp_percent_visible > 0) {
				var _hp_w = map_value(hp_percent_visible, 0, 100, 0, hp_bar_width);
				var _hp_h = hp_bar_y2 - hp_bar_y1;
				draw_sprite_stretched(
					spr_bar_hp_bar,
					0,
					_right ? hp_bar_x2 - _hp_w : hp_bar_x1,
					hp_bar_y1,
					_hp_w,
					_hp_h
				);
					
				if (dmg_percent_visible > 0) {
					var _dmg_w = map_value(dmg_percent_visible, 0, 100, 0, hp_bar_width);
					draw_sprite_stretched(
						spr_bar_hp_bar_damage,
						0,
						
						_right ? hp_bar_x2 - _hp_w - _dmg_w : hp_bar_x1 + _hp_w + _dmg_w,
						hp_bar_y1,
						_dmg_w,
						_hp_h
					);
				}
			}

			if (mp_percent_visible > 0) {
				var _mp_w = map_value(mp_percent_visible, 0, 100, 0, mp_bar_width);
				var _mp_h = mp_bar_y2 - mp_bar_y1;
				draw_sprite_stretched(
					spr_bar_mp_bar,
					0,
					_right ? mp_bar_x2 - _mp_w : mp_bar_x1,
					mp_bar_y1,
					_mp_w,
					_mp_h
				);
			}
				
			if (tp_percent_visible > 0) {
				var _tp_w = map_value(tp_percent_visible, 0, 100, 0, tp_bar_width);
				var _tp_h = tp_bar_y2 - tp_bar_y1;
				draw_sprite_stretched(
					spr_bar_tp_bar,
					0,
					_right ? tp_bar_x2 - _tp_w : tp_bar_x1,
					tp_bar_y1,
					_tp_w,
					_tp_h
				);
			}
				
			if (xp_percent_visible > 0) {
				var _xp_w = map_value(xp_percent_visible, 0, 100, 0, xp_bar_width);
				var _xp_h = xp_bar_y2 - xp_bar_y1;
				draw_sprite_stretched(
					spr_bar_xp_bar,
					0,
					_right ? xp_bar_x2 - _xp_w : xp_bar_x1,
					xp_bar_y1,
					_xp_w,
					_xp_h
				);
			}
				
			draw_sprite_ext(spr_bar_hp_border,0,hp_border_x1,hp_border_y1,hp_xscale,hp_yscale,0,c_white,_alpha);
			draw_sprite_ext(spr_bar_mp_border,0,mp_border_x1,mp_border_y1,mp_xscale,mp_yscale,0,c_white,_alpha);
			draw_sprite_ext(spr_bar_tp_border,0,tp_border_x1,tp_border_y1,tp_xscale,tp_yscale,0,c_white,_alpha);
			draw_sprite_ext(spr_bar_xp_border,0,xp_border_x1,xp_border_y1,xp_xscale,xp_yscale,0,c_white,_alpha);
				
			draw_sprite_ext(
				spr_bar_mp_stocks,
				0,
				_right ? mp_border_x2 + mp_stock_xoffset : mp_border_x1 + mp_stock_xoffset,
				mp_border_y1,
				mp_stock_scale,
				mp_stock_scale,
				0,
				c_white,
				_alpha
			);
			
			
			var hp_segments = max_level;
			var mp_segments = max_mp_stocks;
			var tp_segments = max_tp_stocks;
			var xp_segments = 4;
			for(var ii = 1; ii < hp_segments; ii++) {
				var hp_segment_x = map_value(ii,0,hp_segments,hp_bar_x1,hp_bar_x2);
				draw_set_color(c_black);
				draw_set_alpha(_alpha/2);
				draw_rectangle(hp_segment_x-1,hp_bar_y1,hp_segment_x,hp_bar_y2,false);
			}
			for(var ii = 1; ii < mp_segments; ii++) {
				var mp_segment_x = map_value(ii,0,mp_segments,mp_bar_x1,mp_bar_x2);
				draw_set_color(c_black);
				draw_set_alpha(_alpha/2);
				draw_rectangle(mp_segment_x-1,mp_bar_y1,mp_segment_x,mp_bar_y2,false);
			}
			for(var ii = 1; ii < tp_segments; ii++) {
				var tp_segment_x = map_value(ii,0,tp_segments,tp_bar_x1,tp_bar_x2);
				draw_set_color(c_white);
				draw_set_alpha(_alpha/2);
				draw_rectangle(tp_segment_x-1,tp_bar_y1,tp_segment_x,tp_bar_y2,false);
			}
			for(var ii = 1; ii < xp_segments; ii++) {
				var xp_segment_x = map_value(ii,0,xp_segments,xp_bar_x1,xp_bar_x2);
				draw_set_color(c_black);
				draw_set_alpha(_alpha/2);
				draw_rectangle(xp_segment_x-1,xp_bar_y1,xp_segment_x,xp_bar_y2,false);
			}
			
			var icon_x = _right ? hp_border_x2 - icon_w2: hp_border_x1 + icon_w2;
			var icon_y = xp_border_y2 + icon_h;
			
			draw_sprite_ext(
				icon,
				0,
				icon_x,
				icon_y,
				_right ? -icon_scale : icon_scale,
				icon_scale,
				0,
				c_white,
				1
			);
			
			draw_set_font(fnt_hud);
			draw_set_halign(fa_left);
			draw_set_valign(fa_top);
			var playertext = display_name; //"P" + string(i+1) + ": " + display_name;
			if form_name != "base" {
				playertext += " (" + form_display_name + ")";
			}
			//playertext += "\n";
			//playertext += " (Level " + string(level) + ")"; 
			var playertext_scale = (hp_bar_height - 2) / string_height(playertext);
			var playertext_width = string_width(playertext) * playertext_scale;
			var playertext_height = string_height(playertext) * playertext_scale;
			var playertext_x1 = icon_x + icon_w;
			var playertext_y1 = (icon_y - icon_h2) - (playertext_height / 2);
			var playertext_x2 = playertext_x1 + playertext_width;
			var playertext_y2 = playertext_y1 + playertext_height;
			
			if _right {
				playertext_x2 = icon_x - icon_w;
				playertext_x1 = playertext_x2 - playertext_width;
			}
			
			draw_set_alpha(_alpha);
			draw_text_outlined(
				playertext_x1,
				playertext_y1,
				playertext,
				c_black,
				player_color[i],
				playertext_scale
			);
			
			draw_set_halign(fa_center);
			draw_set_valign(fa_middle);
			var mp_text = string(mp_stocks);
			var mp_text_x = mp_border_x1 + mp_stock_xoffset + (mp_stock_width / 2);
			if _right {
				mp_text_x = mp_border_x2 - mp_stock_xoffset - (mp_stock_width / 2);
			}
			var mp_text_y = mp_border_y1 + (mp_stock_height / 2);
			draw_text_outlined(
				mp_text_x,
				mp_text_y,
				mp_text,
				make_color_rgb(0,128,0),
				make_color_rgb(255,255,128),
				(mp_stock_height / 2) / string_height(mp_text)
			)
			
			hud_h = (_spacing * 2) + hp_border_height + mp_border_height + tp_border_height + playertext_height;
			
			hud_y += hud_h - _spacing;
			
			if drawn_players <= team1_members {
				drawn_t1_players++;
				if drawn_t1_players == team1_members {
					hud_x += hud_w;
					hud_y = 0;
				}
			}
			else {
				drawn_t2_players++;
			}
			drawn_players++;
			
			draw_set_alpha(1);
		}
	}
	
	draw_combo_counters();
	
	hud_height = hud_h * ceil(active_players / 2);
}

function draw_timer() {
	draw_set_font(fnt_timer);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	
	draw_set_color(c_white);
	
	var _timer_sprite = spr_timer;
	var _timer_x = gui_width/2;
	var _timer_y = gui_height - (sprite_get_height(_timer_sprite) - sprite_get_yoffset(_timer_sprite)) + 1;
	var _timer_text = string(ceil(map_value(round_timer,0,round_timer_max,0,round_timer_visible_max)));
	
	draw_sprite(_timer_sprite,0,_timer_x,_timer_y);
	
	draw_set_color(c_white);
	draw_text(
		_timer_x,
		_timer_y,
		_timer_text
	);
	
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_color(c_white);
}

function draw_combo_counters() {
	var active_players = 0;
	var _p1 = noone;
	var _p2 = noone;
	var _p1_color = noone;
	var _p2_color = noone;
	for(var i = 0; i < max_players; i++) {
		if player_slot[i] != noone {
			active_players++;
			if active_players == 1 {
				_p1 = player[i];
				_p1_color = player_color[i];
			}
			else if active_players == 2 {
				_p2 = player[i];
				_p2_color = player_color[i];
			}
		}
	}
	
	if !value_in_range(active_players,1,2) {
		exit;
	}
	
	var _w = gui_width;
	var _h = gui_height;
	var _w2 = _w / 4;
	var _h2 = _h / 2;
	
	var _x1 = _w2;
	var _y1 = hud_height + 5;
	var _x2 = _w - _w2;
	var _y2  = _y1;
	
	with(_p1) {
		draw_my_combo_counter(_x1,_y1,_p1_color);
	}
	with(_p2) {
		draw_my_combo_counter(_x2,_y2,_p2_color);
	}
}

function draw_my_combo_counter(_x,_y,_color) {
	if (combo_hits_counter > 0) {
		draw_set_halign(fa_center);
		draw_set_valign(fa_top);
		draw_set_font(fnt_combo);
				
		var _text = string(round(combo_hits_visible)) + " ";
		_text += (combo_hits_visible > 1) ? "hits" : "hit";
		_text += "!";
		_text += "\n" + string(round(combo_damage_visible)) + " damage!";
				
		if (round_state != roundstates.pause) {
			_x += hitstop_shake();
			_y += hitstop_shake();
		}
				
		draw_text_outlined(
			_x,
			_y,
			_text,
			c_black,
			merge_color(_color,c_white,0.5),
			1
		);
	}
}

function draw_hitboxes() {
	with(obj_char) {
		var _x1 = x - width_half;
		var _y1 = y - height;
		var _x2 = x + width_half;
		var _y2 = y;
		
		var _w = _x2 - _x1;
		var _h = _y2 - _y1;
		
		draw_sprite_stretched_ext(mask_index,0,_x1,_y1,_w,_h,c_white,1/2);
	}
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

function draw_pause() {
	draw_set_alpha(0.5);
	draw_set_color(c_black);
	draw_rectangle(0,0,gui_width,gui_height,false);
	draw_set_alpha(1);
	draw_set_color(c_white);
	//draw_set_font(fnt_hud);
	//draw_set_halign(fa_center);
	//draw_set_valign(fa_middle);
	//draw_text(gui_width/2,gui_height/2,"Pause!");
}

function draw_countdown() {
	var text_x = gui_width/2;
	var text_y = gui_height/2;
	//var _number = 3 - floor((round_state_timer / round_ready_countdown_duration) * 3);
	var _number = max(1, 1 + floor((1 - (round_state_timer / round_ready_countdown_duration)) * 3));
	_number = clamp(_number,1,3);
	var text = string(_number) + "...";
	if round_state_timer > round_ready_countdown_duration {
		text = "LET IT RIP!";
		var _shake_t1 = round_ready_countdown_duration;
		var _shake_t2 = _shake_t1 + 10;
		if value_in_range(round_state_timer,_shake_t1,_shake_t2) {
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

function draw_versus_results() {
	var _text = "";
	var _text_color = c_white;
	if instance_number(obj_char) == 2 {
		with(obj_char) {
			if active_state == victory_state {
				_text = display_name;
				if form_name != "base" {
					_text += form_display_name;
				}
				_text += " wins!";
				for(var i = 0; i < max_players; i++) {
					if id == player[i] {
						_text_color = player_color[i];
						break;
					}
				}
				break;
			}
		}
	}
	else {
		var team_victory = 0;
		with(obj_char) {
			if active_state == victory_state {
				team_victory = team;
				break;
			}
		}
		if team_victory != 0 {
			_text = "Time " + string(team_victory) + " venceu!";
			_text_color = player_color[team_victory*round(array_length(player_color)/2)];
		}
	}
	if _text == "" {
		_text = "Empate...";
		_text_color = make_color_rgb(64,64,64);
	}
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_font(fnt_announcer);
	
	draw_text_outlined(
		gui_width / 2,
		gui_height * 0.8,
		_text,
		c_black,
		_text_color,
		(gui_height * 0.1) / (string_height(_text))
	);
}