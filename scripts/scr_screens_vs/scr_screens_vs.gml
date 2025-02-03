globalvar	vs_fadein_duration, vs_slidein_duration, vs_slidein2_duration, vs_slideout_duration, vs_fadeout_duration,
			vs_fadein_time, vs_slidein_time, vs_slidein2_time, vs_slideout_time, vs_fadeout_time;

vs_fadein_duration = screen_fade_duration;
vs_slidein_duration = 90;
vs_slidein2_duration = 90;
vs_slideout_duration = 90;
vs_fadeout_duration = screen_fade_duration;

vs_fadein_time = vs_fadein_duration;
vs_slidein_time = vs_fadein_time + vs_slidein_duration;
vs_slidein2_time = vs_slidein_time + vs_slidein2_duration;
vs_slideout_time = vs_slidein2_time + vs_slideout_duration;
vs_fadeout_time = vs_slideout_time + vs_fadeout_duration;

function draw_versus() {
	var active_players = 0;
	for(var i = 0; i < max_players; i++) {
		if player_slot[i] != noone {
			active_players++;
		}
	}
	
	var team1_members = ceil(active_players/2);
	var team2_members = floor(active_players/2);
	
	var _w = gui_width;
	var _h = gui_height;
	var _w2 = _w / 2;
	var _h2 = _h / 2;
	
	var _w3 = _w2 / 2;
	
	var _w4_t1 = _w3 / max(1,team1_members);
	var _w4_t2 = _w3 / max(1,team2_members);
	
	var _timer = game_state_timer;
	
	var _t1 = map_value(_timer,0,vs_fadein_time,0,1);
	var _t2 = map_value(_timer,vs_fadein_time,vs_slidein_time,0,1);
	var _t3 = map_value(_timer,vs_slidein_time,vs_slidein2_time,0,1);
	var _t4 = map_value(_timer,vs_slidein2_time,vs_slideout_time,0,1);
	var _t5 = map_value(_timer,vs_slideout_time,vs_fadeout_time,0,1);
	
	_t1 = clamp(_t1,0,1);
	_t2 = clamp(_t2,0,1);
	_t3 = clamp(_t3,0,1);
	_t4 = clamp(_t4,0,1);
	_t5 = clamp(_t5,0,1);
	
	var drawn_players = 0;
	var drawn_team1_players = 0;
	var drawn_team2_players = 0;
	for(var i = 0; i < max_players; i++) {
		if player_slot[i] != noone {
			var _portrait = get_char_portrait(player_char[i]);
			var _yscale = _h / sprite_get_height(_portrait);
			var _xscale = _yscale;
			
			var _portrait_x = 0;
			var _portrait_y = 0;
				
			if drawn_players < team1_members {
				_portrait_x = _w4_t1 * (drawn_team1_players + 1);
			}
			else {
				_portrait_x = _w2 + (_w4_t2 * (drawn_team2_players + 1));
				_xscale *= -1;
			}
			
			var _timer_offset = map_value(drawn_players,0,active_players,0,20);
	
			_portrait_y -= gui_height * power(
				clamp(
					map_value(_timer - _timer_offset,vs_fadein_time,vs_slidein_time,1,0),
					0,
					1
				),
				3
			);
			_portrait_y += gui_height * power(
				clamp(
					map_value(_timer - _timer_offset,vs_slidein2_time,vs_slideout_time,0,1),
					0,
					1
				),
				3
			);
			
			if screen_shake_timer > 0 {
				_portrait_x += sine_wave(screen_shake_timer,4,screen_shake_intensity,0);
				_portrait_y += sine_wave(screen_shake_timer+1,4,screen_shake_intensity,0);
			}
			
			draw_sprite_ext(
				_portrait,
				0,
				_portrait_x,
				_portrait_y,
				_xscale,
				_yscale,
				0,
				c_white,
				1
			);
			
			if drawn_players <= team1_members {
				drawn_team1_players++;
			}
			else {
				drawn_team2_players++;
			}
			drawn_players++;
		}
	}
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_color(c_white);
	
	var vs_scale = (_w / 5) / sprite_get_width(spr_versus);
	var vs_x = _w / 2;
	var vs_y = _h * 0.5;
	vs_y += gui_height * power(1-_t3,3);
	vs_y -= gui_height * power(_t4,3);
	if screen_shake_timer > 0 {
		vs_x += random(screen_shake_intensity) * choose(1,-1);
		vs_y += random(screen_shake_intensity) * choose(1,-1);
	}
	draw_sprite_ext(
		spr_versus,
		game_state_timer / 3,
		vs_x,
		vs_y,
		vs_scale,
		vs_scale,
		0,
		c_white,
		1
	);
}