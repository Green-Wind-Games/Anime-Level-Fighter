randomize();

function update_fight() {
	round_state_timer += 1;
	var _roundstate = round_state;
	if round_state == roundstates.intro {
		var finished = round_state_timer > 60;
		with(obj_char) {
			if active_state != idle_state { finished = false; }
			if audio_is_playing(voice) { finished = false; }
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
	}
	else if round_state == roundstates.time_over or round_state == roundstates.knockout {
		var ready = round_state_timer > 60;
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
		var ready = round_state_timer > 120;
		with(obj_char) {
			if active_state == victory_state {
				if !anim_finished { ready = false; }
				if audio_is_playing(voice) { ready = false; }
			}
		}
		if ready {
			game_state = gamestates.versus_select;
		}
	}
	if round_state != _roundstate {
		round_state_timer = 0;
	}
		
	chars_update_targeting();
		
	update_charinputs();
		
	update_shots();
		
	run_charanimations();
	run_charstates();
	run_charphysics();
	
	chars_update_stats();
	
	chars_update_targeting();
		
	update_hitboxes();
	
	update_combo();
	
	check_deaths();
	
	if superfreeze_timer > 0 {
		superfreeze_active = true;
		superfreeze_timer -= 1;
	}
	else {
		superfreeze_active = false;
		superfreeze_activator = noone;
		superfreeze_timer = 0;
	}
	
	if gamefreeze_timer > 0 {
		gamefreeze_active = true;
		gamefreeze_timer -= 1;
	}
	else {
		gamefreeze_active = false;
		gamefreeze_activator = noone;
		gamefreeze_timer = 0;
	}
}

function chars_update_stats() {
	with(obj_char) {
		hp = clamp(round(hp),0,max_hp);
		mp = clamp(round(mp),0,max_mp);
		tp = clamp(round(tp),0,max_tp);
		
		hp_percent = (hp/max_hp)*100;
		mp_percent = (mp/max_mp)*100;
		tp_percent = (tp/max_tp)*100;
		
		mp_stocks = floor(mp/mp_stock_size);
		tp_stocks = floor(tp/tp_stock_size);
		
		dead = (hp <= 0);
	}
}

function run_charstates() {
	with(obj_char) {
		if (!superfreeze_active) or ((superfreeze_active) and (superfreeze_activator == id)) {
			if (!hitstop) {
				run_state();
			}
			else {
				hitstop -= 1;
			}
		}
		if (!superfreeze_active) and (!hitstop) {
			char_script();
			state_timer += 1;
			tp++;
		}
		if facing == 0 {
			facing = 1;
		}
	}
}

function run_charphysics() {
	var border = 16;
	var _x1 = room_width;
	var _y1 = room_height;
	var _x2 = 0;
	var _y2 = 0;
	with(obj_char) {
		if !dead {
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
	with(obj_char) {
		if (!superfreeze_active) or ((superfreeze_active) and (superfreeze_activator == id)) {
			if (!hitstop) {
				run_physics();
				decelerate();
				gravitate(ygravity_mod);
			}
		}
		if (!dead) and (xspeed != 0) {
			x = clamp(x, left_wall, right_wall);
		}
		y = min(y,ground_height);
		
		//x = round(x);
		//y = round(y);
	}
	if (!superfreeze_active) and (!gamefreeze_active) {
		with(obj_char) {
			with(obj_char) {
				if grabbed or other.grabbed continue;
				if dead or other.dead continue;
				if team == other.team continue;
			
				if !rectangle_in_rectangle(
					x-width_half,
					y-height,
					x+width_half,
					y,
					other.x-other.width_half,
					other.y-other.height,
					other.x+other.width_half,
					other.y,
				) continue;
			
				var _dist = abs(x-other.x);
				_dist -= width_half;
				_dist -= other.width_half;
				if _dist >= 0 continue;
			
				var _push = -sign(x-other.x);
				//if _push == 0 then _push = sign(on_left_wall - on_right_wall) * sign(y - other.y);
				if _push == 0 then _push = facing;
				if _push == 0 then _push = 1;
				_push *= 0.5;
				var i = 0;
				while(_dist < 0) {
					x = clamp(x-_push, left_wall, right_wall);
					other.x = clamp(other.x+_push, left_wall, right_wall);
					_dist = point_distance(x,0,other.x,0) - (width_half + other.width_half);
					if i++ > 20 break;
				}
			}
		}
	}
}

function run_charanimations() {
	with(obj_char) {
		if (!superfreeze_active) or ((superfreeze_active) and (superfreeze_activator == id)) {
			if (!hitstop) {
				run_animation();
			}
		}
		if sprite == spinout_sprite
		or sprite == launch_sprite {
			rotation = point_direction(0,0,abs(xspeed),-yspeed);
		}
		if (!is_hit) and (!is_blocking) {
			previous_hp = approach(previous_hp,hp,100);
		}
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
			if !p1_is_hit and !p1_is_blocking {
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
			if !p1_is_hit and !p1_is_blocking {
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
			if !p2_is_hit and !p2_is_blocking {
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
			if !p2_is_hit and !p2_is_blocking {
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
//		{ call: [p1_button5, p1_button6], back: sign(p1_right - p1_left) == -p1_active_character.facing, ai: p1_active_character.ai_enabled, is_hit: p1_is_hit, is_blocking: p1_is_blocking, char: p1_char, char_assist_timer: p1_char_assist_timer, char_hp: p1_char_hp, char_assist_type: p1_char_assist_type, change_active_char: change_p1_active_char },
//		{ call: [p2_button5, p2_button6], back: sign(p2_right - p2_left) == -p2_active_character.facing, ai: p2_active_character.ai_enabled, is_hit: p2_is_hit, is_blocking: p2_is_blocking, char: p2_char, char_assist_timer: p2_char_assist_timer, char_hp: p2_char_hp, char_assist_type: p2_char_assist_type, change_active_char: change_p2_active_char }
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
//				if (assists[i].call[j] && !assists[i].is_hit && !assists[i].is_blocking) {
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

function check_deaths() {
	var alldead = true;
	with(obj_char) {
		if target_exists() {
			alldead = false;
		}
	}
	if alldead {
		if round_state != roundstates.knockout && round_state != roundstates.victory {
			round_state = roundstates.knockout;
			play_sound(snd_knockout);
		}
	}
}

function update_shots() {
	if (!superfreeze_active) and (!gamefreeze_active) {
		with(obj_shot) {
			gravitate(affected_by_gravity);
			if bounce {
				if x <= left_wall {
					xspeed = abs(xspeed);
				}
				if x >= right_wall {
					xspeed = -abs(xspeed);
				}
				if y >= ground_height {
					yspeed = -abs(yspeed);
				}
			}
			if homing {
				if target_exists() {
					target_x = target.x;
					target_y = target.y-target.height_half;
					target_direction = point_direction(x,y,target_x,target_y);
					var _direction = point_direction(0,0,xspeed,yspeed);
					if homing_max_turn > 0 {
						var turn = angle_difference(target_direction,_direction);
						turn = clamp(turn,-homing_max_turn,homing_max_turn);
						_direction += turn;
					}
					else {
						_direction = target_direction;
					}
					xspeed = lengthdir_x(homing_speed,_direction);
					yspeed = lengthdir_y(homing_speed,_direction);
				}
			}
		
			run_animation();

			active_script();
		
			rotation = point_direction(0,0,xspeed,yspeed);

			if xspeed > 0 {
				facing = 1;
			}
			else if xspeed < 0 {
				facing = -1;
			}
		
			run_physics();
		
			var active = true;

			if !value_in_range(x,-room_width,room_width*2) {
				active = false;
			}
			if duration != -1 {
				duration -= 1;
				if duration <= 0 {
					active = false
				}
			}
			if hit_limit != -1 {
				if hit_count >= hit_limit {
					active = false;
				}
			}
		
			if !active {
				expire_script();
				instance_destroy();
			}
		}
	}
}

function update_hitboxes() {
	with(obj_hitbox_parent) {
		if instance_exists(owner) {
			x = owner.x + (xoffset * owner.facing);
			y = owner.y + yoffset;
			if facing != owner.facing {
				image_xscale *= -1;
				facing = owner.facing;
			}
		}
		else {
			instance_destroy();
		}
	}
	with(obj_hitbox) {
		var active = true;
		if instance_exists(owner) {
			if owner.active_state != my_state {
				active = false;
			}
		}
		else {
			active = false;
		}
		if duration != -1 {
			duration -= 1;
			if duration <= 0 {
				active = false;
			}
		}
		if active {
			if (!superfreeze_active) and (!gamefreeze_active) {
				check_hit();
			}
		}
		else {
			instance_destroy();
		}
	}
}

function update_combo() {
	with(obj_char) {
		if !hitstop {
			if combo_timer-- <= 0 {
				reset_combo();
			}
		}
	}
}