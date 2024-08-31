randomize();

function update_fight() {
	round_state_timer += 1;
	var _roundstate = round_state;
	if round_state == roundstates.intro {
		var finished = round_state_timer > 60;
		with(obj_char) {
			if active_state != idle_state { finished = false; }
			if sound_is_playing(voice) { finished = false; }
		}
		if finished {
			round_state = roundstates.countdown;
		}
	}
	else if round_state == roundstates.countdown {
		if round_state_timer >= round_countdown_duration {
			round_state = roundstates.fight;
		}
	}
	else if round_state == roundstates.fight {
		round_timer -= 1;
		if round_timer <= 0 {
			round_state = roundstates.time_over;
		}
		
		var alldead = true;
		with(obj_char) {
			if !dead {
				if target_exists() {
					alldead = false;
				}
			}
		}
		if alldead {
			round_state = roundstates.knockout;
			play_sound(snd_knockout);
		}
	}
	else if round_state == roundstates.time_over or round_state == roundstates.knockout {
		var ready = round_state_timer > 100;
		with(obj_char) {
			if !dead {
				if active_state != idle_state { ready = false; }
			}
		}
		if ready {
			round_state = roundstates.victory;
		}
	}
	else if round_state == roundstates.victory {
		var ready = round_state_timer > 200;
		with(obj_char) {
			if active_state == victory_state {
				if !anim_finished { ready = false; }
				if sound_is_playing(voice) { ready = false; }
			}
			else {
				change_state(victory_state);
			}
		}
		if ready {
			game_state = gamestates.versus_select;
		}
	}
	if round_state != _roundstate {
		round_state_timer = 0;
	}
	
	var border = 16;
	var _x1 = room_width;
	var _y1 = room_height;
	var _x2 = 0;
	var _y2 = 0;
	with(obj_char) {
		if (!dead) {
			_x1 = min(_x1,x);
			_y1 = min(_y1,y);
			_x2 = max(_x2,x);
			_y2 = max(_y2,y);
		}
	}
	battle_x = mean(_x1,_x2);
	battle_y = mean(_y1,_y2);
	var battle_size = game_width * 1.25;
	left_wall = clamp(battle_x - (battle_size / 2),0,room_width-game_width) + border;
	right_wall = clamp(battle_x + (battle_size / 2),game_width,room_width) - border;
	
	if superfreeze_timer > 0 {
		superfreeze_active = true;
		superfreeze_timer -= 1;
	}
	else {
		superfreeze_active = false;
		superfreeze_activator = noone;
		superfreeze_timer = 0;
	}
	
	if timestop_timer > 0 {
		timestop_active = true;
		timestop_timer -= 1;
	}
	else {
		timestop_active = false;
		timestop_activator = noone;
		timestop_timer = 0;
	}
}

function check_assists() {
	if max_team_size > 1 {
		var assist_y = ground_height - 30;
	
		var p1_call1 = p1_button5;
		var p1_call2 = p1_button6;
		var p1_back = sign(p1_right - p1_left) == -p1_active_character.facing;
	
		var p2_call1 = p2_button5;
		var p2_call2 = p2_button6;
		var p2_back = sign(p2_right - p2_left) == -p2_active_character.facing;
	
		var ai_assist_odds = 300;
		var ai_tagout_odds = 50;
	
		if p1_active_character.ai_enabled {
			p1_call1 = false;
			p1_call2 = false;
			p1_back = false;
		
			if irandom(ai_assist_odds) == 1 { p1_call1 = true; }
			if irandom(ai_assist_odds) == 1 { p1_call2 = true; }
			if irandom(ai_tagout_odds) > p1_active_character.hp_percent { p1_back = true; }
		}
	
		if p2_active_character.ai_enabled {
			p2_call1 = false;
			p2_call2 = false;
			p2_back = false;
		
			if irandom(ai_assist_odds) == 1 { p2_call1 = true; }
			if irandom(ai_assist_odds) == 1 { p2_call2 = true; }
			if irandom(ai_tagout_odds) > p2_active_character.hp_percent { p2_back = true; }
		}
	
		if round_state != roundstates.fight
		or superfreeze_active 
		or p1_grabbed
		or p2_grabbed {
			p1_call1 = false;
			p1_call2 = false;
			p2_call1 = false;
			p2_call2 = false;
		}
	
		if p1_call1 {
			if !p1_is_hit and !p1_is_guarding {
				var called_number = 1;
				var called_char = p1_char[1];
				if p1_active_character == p1_char[1] {
					called_char = p1_char[0];
					called_number = 0;
				}
				if p1_char_assist_timer[called_number] <= 0 {
					if p1_char_hp[called_number] > 0 {
						with(called_char) {
							x = p1_active_character.x;
							y = assist_y;
							xspeed = 0;
							yspeed = 0;
							change_sprite(air_down_sprite,6,false);
							face_target();
							if p1_back {
								p1_char_assist_timer[0] = assist_a_cooldown;
								p1_char_assist_timer[1] = assist_a_cooldown;
								change_p1_active_char(called_char);
							}
							else if p1_char_assist_type[called_number] == assist_type.a {
								p1_char_assist_timer[called_number] = assist_a_cooldown;
								change_state(assist_a_state);
							}
							else if p1_char_assist_type[called_number] == assist_type.b {
								p1_char_assist_timer[called_number] = assist_b_cooldown;
								change_state(assist_b_state);
							}
							else {
								p1_char_assist_timer[called_number] = assist_c_cooldown;
								change_state(assist_c_state);
							}
						}
					}
				}
			}
		}

		if p1_call2 {
			if !p1_is_hit and !p1_is_guarding {
				var called_number = 2;
				var called_char = p1_char[2];
				if p1_active_character == p1_char[2] {
					called_char = p1_char[0];
					called_number = 0;
				}
				if p1_char_assist_timer[called_number] <= 0 {
					if p1_char_hp[called_number] > 0 {
						with(called_char) {
							x = p1_active_character.x;
							y = assist_y;
							xspeed = 0;
							yspeed = 0;
							change_sprite(air_down_sprite,6,false);
							face_target();
							if p1_back {
								p1_char_assist_timer[0] = assist_a_cooldown;
								p1_char_assist_timer[2] = assist_a_cooldown;
								change_p1_active_char(called_char);
							}
							else if p1_char_assist_type[called_number] == assist_type.a {
								p1_char_assist_timer[called_number] = assist_a_cooldown;
								change_state(assist_a_state);
							}
							else if p1_char_assist_type[called_number] == assist_type.b {
								p1_char_assist_timer[called_number] = assist_b_cooldown;
								change_state(assist_b_state);
							}
							else {
								p1_char_assist_timer[called_number] = assist_c_cooldown;
								change_state(assist_c_state);
							}
						}
					}
				}
			}
		}

		if p2_call1 {
			if !p2_is_hit and !p2_is_guarding {
				var called_number = 1;
				var called_char = p2_char[1];
				if p2_active_character == p2_char[1] {
					called_char = p2_char[0];
					called_number = 0;
				}
				if p2_char_assist_timer[called_number] <= 0 {
					if p2_char_hp[called_number] > 0 {
						with(called_char) {
							x = p2_active_character.x;
							y = assist_y;
							xspeed = 0;
							yspeed = 0;
							change_sprite(air_down_sprite,6,false);
							face_target();
							if p2_back {
								p2_char_assist_timer[0] = assist_a_cooldown;
								p2_char_assist_timer[1] = assist_a_cooldown;
								change_p2_active_char(called_char);
							}
							else if p2_char_assist_type[called_number] == assist_type.a {
								p2_char_assist_timer[called_number] = assist_a_cooldown;
								change_state(assist_a_state);
							}
							else if p2_char_assist_type[called_number] == assist_type.b {
								p2_char_assist_timer[called_number] = assist_b_cooldown;
								change_state(assist_b_state);
							}
							else {
								p2_char_assist_timer[called_number] = assist_c_cooldown;
								change_state(assist_c_state);
							}
						}
					}
				}
			}
		}

		if p2_call2 {
			if !p2_is_hit and !p2_is_guarding {
				var called_number = 2;
				var called_char = p2_char[2];
				if p2_active_character == p2_char[2] {
					called_char = p2_char[0];
					called_number = 0;
				}
				if p2_char_assist_timer[called_number] <= 0 {
					if p2_char_hp[called_number] > 0 {
						with(called_char) {
							x = p2_active_character.x;
							y = assist_y;
							xspeed = 0;
							yspeed = 0;
							change_sprite(air_down_sprite,6,false);
							face_target();
							if p2_back {
								p2_char_assist_timer[0] = assist_a_cooldown;
								p2_char_assist_timer[2] = assist_a_cooldown;
								change_p2_active_char(called_char);
							}
							else if p2_char_assist_type[called_number] == assist_type.a {
								p2_char_assist_timer[called_number] = assist_a_cooldown;
								change_state(assist_a_state);
							}
							else if p2_char_assist_type[called_number] == assist_type.b {
								p2_char_assist_timer[called_number] = assist_b_cooldown;
								change_state(assist_b_state);
							}
							else {
								p2_char_assist_timer[called_number] = assist_c_cooldown;
								change_state(assist_c_state);
							}
						}
					}
				}
			}
		}
	}
}

//function check_assists() {
//	var assist_y = ground_height - 30;
//	var ai_assist_odds = 500;
//	var ai_tagout_odds = 50;

//	var assists = [
//		{ call: [p1_button5, p1_button6], back: sign(p1_right - p1_left) == -p1_active_character.facing, ai: p1_active_character.ai_enabled, is_hit: p1_is_hit, is_guarding: p1_is_guarding, char: p1_char, char_assist_timer: p1_char_assist_timer, char_hp: p1_char_hp, char_assist_type: p1_char_assist_type, change_active_char: change_p1_active_char },
//		{ call: [p2_button5, p2_button6], back: sign(p2_right - p2_left) == -p2_active_character.facing, ai: p2_active_character.ai_enabled, is_hit: p2_is_hit, is_guarding: p2_is_guarding, char: p2_char, char_assist_timer: p2_char_assist_timer, char_hp: p2_char_hp, char_assist_type: p2_char_assist_type, change_active_char: change_p2_active_char }
//	];

//	if (round_state != roundstates.fight || superfreeze_active || p1_grabbed || p2_grabbed) {
//		for (var i = 0; i < array_length(assists); i++) {
//			assists[i].call[0] = false;
//			assists[i].call[1] = false;
//		}
//	} else {
//		for (var i = 0; i < array_length(assists); i++) {
//			if (assists[i].ai) {
//				assists[i].call[0] = irandom(ai_assist_odds) == 1;
//				assists[i].call[1] = irandom(ai_assist_odds) == 1;
//				assists[i].back = irandom(ai_tagout_odds) > assists[i].char[0].hp_percent;
//			}

//			for (var j = 0; j < 2; j++) {
//				if (assists[i].call[j] && !assists[i].is_hit && !assists[i].is_guarding) {
//					var called_number = j + 1;
//					var called_char = assists[i].char[called_number];
//					if (assists[i].char[0] == called_char) {
//						called_char = assists[i].char[0];
//						called_number = 0;
//					}
//					if (assists[i].char_assist_timer[called_number] <= 0 && assists[i].char_hp[called_number] > 0) {
//						with (called_char) {
//							x = assists[i].char[0].x;
//							y = assist_y;
//							xspeed = 0;
//							yspeed = 0;
//							change_sprite(air_down_sprite, 6, false);
//							face_target();
//							if (assists[i].back) {
//								assists[i].char_assist_timer[0] = assist_a_cooldown;
//								assists[i].char_assist_timer[called_number] = assist_a_cooldown;
//								assists[i].change_active_char(called_char);
//							} else if (assists[i].char_assist_type[called_number] == assist_type.a) {
//								assists[i].char_assist_timer[called_number] = assist_a_cooldown;
//								change_state(assist_a_state);
//							} else if (assists[i].char_assist_type[called_number] == assist_type.b) {
//								assists[i].char_assist_timer[called_number] = assist_b_cooldown;
//								change_state(assist_b_state);
//							} else {
//								assists[i].char_assist_timer[called_number] = assist_c_cooldown;
//								change_state(assist_c_state);
//							}
//						}
//					}
//				}
//			}
//		}
//	}
//}

//function check_deaths() {
//	with(p1_active_character) {
//		if dead
//		and active_state == liedown_state 
//		and state_timer >= 100 {
//			with(obj_char) {
//				if team == 1 {
//					if !dead 
//					and active_state == tag_out_state 
//					and state_timer >= 100 {
//						change_p1_active_char(id);
//						play_chartheme(theme);
//						break;
//					}
//				}
//			}
//		}
//	}
//	with(p2_active_character) {
//		if dead
//		and active_state == liedown_state 
//		and state_timer >= 100 {
//			with(obj_char) {
//				if team == 2 {
//					if !dead 
//					and active_state == tag_out_state 
//					and state_timer >= 100 {
//						change_p2_active_char(id);
//						play_chartheme(theme);
//						break;
//					}
//				}
//			}
//		}
//	}
//	if (p1_remaining_chars <= 0) or (p2_remaining_chars <= 0) {
//		if round_state != roundstates.knockout and round_state != roundstates.victory {
//			round_state = roundstates.knockout;
//			round_timer = 60;
//			play_sound(snd_knockout);
//		}
//	}
//}

//function change_p1_active_char(_char) {
//	with(_char) {
//		if active_state == tag_out_state {
//			if p1_active_character.facing == 1 {
//				x = left_wall;
//			}
//			else {
//				x = right_wall;
//			}
//			y = target_y;
//			face_target();
//			change_state(homing_dash_state);
//		}
//		p1_active_character = id;
//	}
//}
//function change_p2_active_char(_char) {
//	with(_char) {
//		if active_state == tag_out_state {
//			if p2_active_character.facing == 1 {
//				x = left_wall;
//			}
//			else {
//				x = right_wall;
//			}
//			y = target_y;
//			face_target();
//			change_state(homing_dash_state);
//		}
//		p2_active_character = id;
//	}
//}