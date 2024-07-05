randomize();

function update_input() {
	gamepad_set_axis_deadzone(0,0.5);
	gamepad_set_axis_deadzone(1,0.5);
	gamepad_set_axis_deadzone(4,0.5);
	gamepad_set_axis_deadzone(5,0.5);
	
	var _p1_up = keyboard_check(ord("W")) or (gamepad_axis_value(0,gp_axislv) < 0) or (gamepad_axis_value(4,gp_axislv) < 0);
	var _p1_down = keyboard_check(ord("S")) or (gamepad_axis_value(0,gp_axislv) > 0) or (gamepad_axis_value(4,gp_axislv) > 0);
	var _p1_left = keyboard_check(ord("A")) or (gamepad_axis_value(0,gp_axislh) < 0) or (gamepad_axis_value(4,gp_axislh) < 0);
	var _p1_right = keyboard_check(ord("D")) or (gamepad_axis_value(0,gp_axislh) > 0) or (gamepad_axis_value(4,gp_axislh) > 0);
	
	var _p1_button1 = keyboard_check(ord("B")) or (gamepad_button_check(0,gp_face1)) or (gamepad_button_check(4,gp_face1));
	var _p1_button2 = keyboard_check(ord("N")) or (gamepad_button_check(0,gp_face2)) or (gamepad_button_check(4,gp_face2));
	var _p1_button3 = keyboard_check(ord("M")) or (gamepad_button_check(0,gp_face3)) or (gamepad_button_check(4,gp_face3));
	var _p1_button4 = keyboard_check(ord("G")) or (gamepad_button_check(0,gp_face4)) or (gamepad_button_check(4,gp_face4));
	var _p1_button5 = keyboard_check(ord("H")) or (gamepad_button_check(0,gp_shoulderl)) or (gamepad_button_check(4,gp_shoulderl));
	var _p1_button6 = keyboard_check(ord("J")) or (gamepad_button_check(0,gp_shoulderr)) or (gamepad_button_check(4,gp_shoulderr));

	var _p2_up = keyboard_check(vk_up) or (gamepad_axis_value(1,gp_axislv) < 0) or (gamepad_axis_value(5,gp_axislv) < 0);
	var _p2_down = keyboard_check(vk_down) or (gamepad_axis_value(1,gp_axislv) > 0) or (gamepad_axis_value(5,gp_axislv) > 0);
	var _p2_left = keyboard_check(vk_left) or (gamepad_axis_value(1,gp_axislh) < 0) or (gamepad_axis_value(5,gp_axislh) < 0);
	var _p2_right = keyboard_check(vk_right) or (gamepad_axis_value(1,gp_axislh) > 0) or (gamepad_axis_value(5,gp_axislh) > 0);
	
	var _p2_button1 = keyboard_check(vk_numpad1) or (gamepad_button_check(1,gp_face1)) or (gamepad_button_check(5,gp_face1));
	var _p2_button2 = keyboard_check(vk_numpad2) or (gamepad_button_check(1,gp_face2)) or (gamepad_button_check(5,gp_face2));
	var _p2_button3 = keyboard_check(vk_numpad3) or (gamepad_button_check(1,gp_face3)) or (gamepad_button_check(5,gp_face3));
	var _p2_button4 = keyboard_check(vk_numpad4) or (gamepad_button_check(1,gp_face4)) or (gamepad_button_check(5,gp_face4));
	var _p2_button5 = keyboard_check(vk_numpad5) or (gamepad_button_check(1,gp_shoulderl)) or (gamepad_button_check(5,gp_shoulderl));
	var _p2_button6 = keyboard_check(vk_numpad6) or (gamepad_button_check(1,gp_shoulderr)) or (gamepad_button_check(5,gp_shoulderr));
	
	if _p1_up p1_up += 1; else p1_up = false;
	if _p1_down p1_down += 1; else p1_down = false;
	if _p1_left p1_left += 1; else p1_left = false;
	if _p1_right p1_right += 1; else p1_right = false;
	
	if _p1_button1 p1_button1_held += 1; else p1_button1_held = false;
	if _p1_button2 p1_button2_held += 1; else p1_button2_held = false;
	if _p1_button3 p1_button3_held += 1; else p1_button3_held = false;
	if _p1_button4 p1_button4_held += 1; else p1_button4_held = false;
	if _p1_button5 p1_button5_held += 1; else p1_button5_held = false;
	if _p1_button6 p1_button6_held += 1; else p1_button6_held = false;
	
	p1_up_pressed = p1_up == 1;
	p1_down_pressed = p1_down == 1;
	p1_left_pressed = p1_left == 1;
	p1_right_pressed = p1_right == 1;
	
	p1_button1 = p1_button1_held == 1;
	p1_button2 = p1_button2_held == 1;
	p1_button3 = p1_button3_held == 1;
	p1_button4 = p1_button4_held == 1;
	p1_button5 = p1_button5_held == 1;
	p1_button6 = p1_button6_held == 1;

	if _p2_up p2_up += 1; else p2_up = false;
	if _p2_down p2_down += 1; else p2_down = false;
	if _p2_left p2_left += 1; else p2_left = false;
	if _p2_right p2_right += 1; else p2_right = false;
	
	if _p2_button1 p2_button1_held += 1; else p2_button1_held = false;
	if _p2_button2 p2_button2_held += 1; else p2_button2_held = false;
	if _p2_button3 p2_button3_held += 1; else p2_button3_held = false;
	if _p2_button4 p2_button4_held += 1; else p2_button4_held = false;
	if _p2_button5 p2_button5_held += 1; else p2_button5_held = false;
	if _p2_button6 p2_button6_held += 1; else p2_button6_held = false;
	
	p2_up_pressed = p2_up == 1;
	p2_down_pressed = p2_down == 1;
	p2_left_pressed = p2_left == 1;
	p2_right_pressed = p2_right == 1;
	
	p2_button1 = p2_button1_held == 1;
	p2_button2 = p2_button2_held == 1;
	p2_button3 = p2_button3_held == 1;
	p2_button4 = p2_button4_held == 1;
	p2_button5 = p2_button5_held == 1;
	p2_button6 = p2_button6_held == 1;
}

function update_fight() {
	round_state_timer += 1;
	var _roundstate = round_state;
	if round_state == roundstates.intro {
		var finished = true;
		with(p1_active_character) {
			if active_state != idle_state {
				finished = false;
			}
		}
		with(p2_active_character) {
			if active_state != idle_state {
				finished = false;
			}
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
		var ready = true;
		with(obj_char) {
			if !dead {
				if active_state != idle_state {
					ready = false;
				}
			}
			if state_timer < 60 {
				ready = false;
			}
		}
		if ready {
			round_state = roundstates.victory;
		}
	}
	else if round_state == roundstates.victory {
		var ready = true;
		with(obj_char) {
			if active_state == victory_state {
				if !anim_finished {
					ready = false;
				}
				if audio_is_playing(voice) {
					ready = false;
				}
				if state_timer < 120 {
					ready = false;
				}
			}
		}
		if ready {
			game_state = gamestates.versus_select;
		}
	}
	if round_state != _roundstate {
		round_state_timer = 0;
	}
		
	update_charinputs();
		
	update_teamstats();
		
	chars_update_targeting();
		
	update_shots();
		
	check_assists();
		
	run_charanimations();
	run_charphysics();
	run_charstates();
		
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
}

function update_charinputs() {
	with(obj_char) {
		if !ai_enabled {
			input_up = false;
			input_down = false;
			input_left = false;
			input_right = false;
			input_forward = false;
			input_back = false;
		}
		input_a = false;
		input_b = false;
		input_c = false;
		input_d = false;
	}
	var _input_enabled = round_state == roundstates.fight;
	if _input_enabled {
		with(p1_active_character) {
			if !ai_enabled {
				var p1_forward = (facing == sign(obj_game.p1_right-obj_game.p1_left));
				var p1_back = (-facing == sign(obj_game.p1_right-obj_game.p1_left));
		
				if obj_game.p1_up input_up = true;
				if obj_game.p1_down input_down = true;
				if obj_game.p1_left input_left = true;
				if obj_game.p1_right input_right = true;
				if p1_forward input_forward = true;
				if p1_back input_back = true;
	
				if obj_game.p1_button1 input_a = true;
				if obj_game.p1_button2 input_b = true;
				if obj_game.p1_button3 input_c = true;
				if obj_game.p1_button4 input_d = true;
			}
			else {
				update_ai();
			}
		}

		with(p2_active_character) {
			if !ai_enabled {
				var p2_forward = (facing == sign(obj_game.p2_right-obj_game.p2_left));
				var p2_back = (-facing == sign(obj_game.p2_right-obj_game.p2_left));
		
				if obj_game.p2_up input_up = true;
				if obj_game.p2_down input_down = true;
				if obj_game.p2_left input_left = true;
				if obj_game.p2_right input_right = true;
				if p2_forward input_forward = true;
				if p2_back input_back = true;
	
				if obj_game.p2_button1 input_a = true;
				if obj_game.p2_button2 input_b = true;
				if obj_game.p2_button3 input_c = true;
				if obj_game.p2_button4 input_d = true;
			}
			else {
				update_ai();
			}
		}
	}
	
	with(obj_char) {
		var _buffer = input_buffer;
	
		var hor = sign(input_forward - input_back);
		var ver = sign(input_up - input_down);
		var dir = string(5 + hor + (ver * 3));
	
		if !string_ends_with(string_digits(input_buffer),dir) {
			input_buffer += dir;
		}
		
		var command = "";
		if input_a {
			command += "A";
		}
		if input_b {
			command += "B";
		}
		if input_c {
			command += "C";
		}
		if input_d {
			command += "D";
		}
		
		input_buffer += command;
	
		if input_buffer != _buffer {
			input_buffer_timer = 10;
		}
		else {
			input_buffer_timer -= (!hitstop);
			if input_buffer_timer <= 0 {
				input_buffer = "";
				input_buffer_timer = 0;
			}
		}
	}
}

function run_charstates() {
	with(obj_char) {
		if (!superfreeze_active) or ((superfreeze_active) and (superfreeze_activator == id)) {
			if (!hitstop) {
				run_state();
				if id != p1_active_character
				and id != p2_active_character {
					if active_state == idle_state {
						change_state(tag_out_state);
					}
				}
				else {
					if round_state == roundstates.victory {
						if active_state == idle_state {
							var p1_sum = 0;
							var p2_sum = 0;
							for(var i = 0; i < max_team_size; i++) {
								p1_sum += p1_char_hp_percent[i];
								p2_sum += p2_char_hp_percent[i];
							}
							if p1_sum > p2_sum {
								if team == 1 {
									change_state(victory_state);
								}
								else {
									change_state(defeat_state);
								}
							}
							else if p1_sum < p2_sum {
								if team == 1 {
									change_state(defeat_state);
								}
								else {
									change_state(victory_state);
								}
							}
							else {
								change_state(defeat_state);
							}
						}
					}
				}
			}
			else {
				hitstop -= 1;
			}
		}
		if (!superfreeze_active) and (!hitstop) {
			char_script();
			state_timer += 1;
		}
		if facing == 0 {
			facing = 1;
		}
	}
}

function run_charphysics() {
	var border = 16;
	battle_x = mean(p1_active_character.x,p2_active_character.x);
	battle_y = mean(p1_active_character.y,p2_active_character.y);
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
		if id == p1_active_character
		or id == p2_active_character {
	        x = clamp(x, left_wall, right_wall);
		}
		y = min(y,ground_height);
		
		//x = round(x);
		//y = round(y);

		with(obj_char) {
			if grabbed continue;
			if other.grabbed continue;
			if dead  continue;
			if other.dead continue;
			if active_state == tag_out_state continue;
			if other.active_state == tag_out_state continue;
			if team == other.team continue;
			if !place_meeting(x, y, other) continue;
			
			var _push = -sign(x-other.x);
			if _push == 0 then _push = sign(on_left_wall - on_right_wall) * sign(y - other.y);
			if _push == 0 then _push = facing;
			var i = 0;
			while(place_meeting(x, y, other)) {
				x = clamp(x-_push, left_wall, right_wall);
				other.x = clamp(other.x+_push, left_wall, right_wall);
				if i++ > 10 break;
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
//    var assist_y = ground_height - 30;
//    var ai_assist_odds = 500;
//    var ai_tagout_odds = 50;

//    var assists = [
//        { call: [p1_button5, p1_button6], back: sign(p1_right - p1_left) == -p1_active_character.facing, ai: p1_active_character.ai_enabled, is_hit: p1_is_hit, is_blocking: p1_is_blocking, char: p1_char, char_assist_timer: p1_char_assist_timer, char_hp: p1_char_hp, char_assist_type: p1_char_assist_type, change_active_char: change_p1_active_char },
//        { call: [p2_button5, p2_button6], back: sign(p2_right - p2_left) == -p2_active_character.facing, ai: p2_active_character.ai_enabled, is_hit: p2_is_hit, is_blocking: p2_is_blocking, char: p2_char, char_assist_timer: p2_char_assist_timer, char_hp: p2_char_hp, char_assist_type: p2_char_assist_type, change_active_char: change_p2_active_char }
//    ];

//    if (round_state != roundstates.fight || superfreeze_active || p1_grabbed || p2_grabbed) {
//        for (var i = 0; i < array_length(assists); i++) {
//            assists[i].call[0] = false;
//            assists[i].call[1] = false;
//        }
//    } else {
//        for (var i = 0; i < array_length(assists); i++) {
//            if (assists[i].ai) {
//                assists[i].call[0] = irandom(ai_assist_odds) == 1;
//                assists[i].call[1] = irandom(ai_assist_odds) == 1;
//                assists[i].back = irandom(ai_tagout_odds) > assists[i].char[0].hp_percent;
//            }

//            for (var j = 0; j < 2; j++) {
//                if (assists[i].call[j] && !assists[i].is_hit && !assists[i].is_blocking) {
//                    var called_number = j + 1;
//                    var called_char = assists[i].char[called_number];
//                    if (assists[i].char[0] == called_char) {
//                        called_char = assists[i].char[0];
//                        called_number = 0;
//                    }
//                    if (assists[i].char_assist_timer[called_number] <= 0 && assists[i].char_hp[called_number] > 0) {
//                        with (called_char) {
//                            x = assists[i].char[0].x;
//                            y = assist_y;
//                            xspeed = 0;
//                            yspeed = 0;
//                            change_sprite(air_down_sprite, 6, false);
//                            face_target();
//                            if (assists[i].back) {
//                                assists[i].char_assist_timer[0] = assist_a_cooldown;
//                                assists[i].char_assist_timer[called_number] = assist_a_cooldown;
//                                assists[i].change_active_char(called_char);
//                            } else if (assists[i].char_assist_type[called_number] == assist_type.a) {
//                                assists[i].char_assist_timer[called_number] = assist_a_cooldown;
//                                change_state(assist_a_state);
//                            } else if (assists[i].char_assist_type[called_number] == assist_type.b) {
//                                assists[i].char_assist_timer[called_number] = assist_b_cooldown;
//                                change_state(assist_b_state);
//                            } else {
//                                assists[i].char_assist_timer[called_number] = assist_c_cooldown;
//                                change_state(assist_c_state);
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
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
    check_death_for_team(p1_active_character, 1, change_p1_active_char);
    check_death_for_team(p2_active_character, 2, change_p2_active_char);

    if (p1_remaining_chars <= 0 || p2_remaining_chars <= 0) {
        if round_state != roundstates.knockout && round_state != roundstates.victory {
            round_state = roundstates.knockout;
            play_sound(snd_knockout);
        }
    }
}

function check_death_for_team(active_character, _team, change_active_char_func) {
    with (active_character) {
        if (dead and active_state == liedown_state and state_timer >= 100) {
            with (obj_char) {
                if (team == _team && !dead && active_state == tag_out_state && state_timer >= 120) {
                    change_active_char_func(id);
                    play_chartheme(theme);
                    break;
                }
            }
        }
    }
}

function change_p1_active_char(_char) {
    switch_active_character(_char, p1_active_character, left_wall, right_wall);
    p1_active_character = _char.id;
}

function change_p2_active_char(_char) {
    switch_active_character(_char, p2_active_character, left_wall, right_wall);
    p2_active_character = _char.id;
}

function switch_active_character(_char, current_active_char, left_wall, right_wall) {
    with (_char) {
        if (active_state == tag_out_state) {
            if (current_active_char.facing == 1) {
                x = left_wall;
            } else {
                x = right_wall;
            }
            y = target_y;
            face_target();
            change_state(homing_dash_state);
        }
    }
}


function update_teamstats() {
	p1_remaining_chars = 0;
	p2_remaining_chars = 0;
	
	p1_mp = clamp(p1_mp,0,max_mp);
	p1_mp_percent = map_value(p1_mp,0,max_mp,0,100);
	p1_mp_stocks = floor(p1_mp / mp_stock_size);
	
	p1_tp = clamp(p1_tp,0,max_tp);
	p1_tp_percent = map_value(p1_tp,0,max_tp,0,100);
	p1_tp_stocks = floor(p1_tp / tp_stock_size);
	
	p1_sp = clamp(p1_sp,0,max_sp);
	p1_sp_percent = map_value(p1_sp,0,max_sp,0,100);
	p1_sp_stocks = floor(p1_sp / sp_stock_size);
	
	p2_mp = clamp(p2_mp,0,max_mp);
	p2_mp_percent = map_value(p2_mp,0,max_mp,0,100);
	p2_mp_stocks = floor(p2_mp / mp_stock_size);
	
	p2_tp = clamp(p2_tp,0,max_tp);
	p2_tp_percent = map_value(p2_tp,0,max_tp,0,100);
	p2_tp_stocks = floor(p2_tp / tp_stock_size);
	
	p2_sp = clamp(p2_sp,0,max_sp);
	p2_sp_percent = map_value(p2_sp,0,max_sp,0,100);
	p2_sp_stocks = floor(p2_sp / sp_stock_size);
	
	for(var i = 0; i < max_team_size; i++) {
		p1_char_hp[i] = 0;
		p1_char_hp_percent[i] = 0;
		with(p1_char[i]) {
			if active_state == tag_out_state {
				p1_char_assist_timer[i] -= 1;
			}
			hp = clamp(hp,0,max_hp);
			hp_percent = map_value(hp,0,max_hp,0,100);
			team = 1;
			target = p2_active_character;
			p1_char_facing[i] = facing;
			p1_char_hp[i] = hp;
			p1_char_hp_percent[i] = hp_percent;
			p1_char_x[i] = x;
			p1_char_y[i] = y;
			p1_remaining_chars += hp > 0;
		}
		with(p2_char[i]) {
			if active_state == tag_out_state {
				p2_char_assist_timer[i] -= 1;
			}
			hp = clamp(hp,0,max_hp);
			hp_percent = map_value(hp,0,max_hp,0,100);
			team = 2;
			target = p1_active_character;
			p2_char_facing[i] = facing;
			p2_char_hp[i] = hp;
			p2_char_hp_percent[i] = hp_percent;
			p2_char_x[i] = x;
			p2_char_y[i] = y;
			p2_remaining_chars += hp > 0;
		}
	}
	with(p1_active_character) {
		p1_is_airborne = is_airborne;
		p1_is_blocking = is_blocking;
		p1_is_hit = is_hit;
		p1_on_ground = on_ground;
		p1_blockstun = blockstun;
		p1_hitstun = hitstun;
		p1_grabbed = grabbed;
	}
	with(p2_active_character) {
		p2_is_airborne = is_airborne;
		p2_is_blocking = is_blocking;
		p2_is_hit = is_hit;
		p2_on_ground = on_ground;
		p2_blockstun = blockstun;
		p2_hitstun = hitstun;
		p2_grabbed = grabbed;
	}
}

function update_shots() {
	if !superfreeze_active {
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
			check_hit();
		}
		else {
			instance_destroy();
		}
	}
}

function update_combo() {
	p1_combo_timer -= 1;
	p2_combo_timer -= 1;
	if p1_combo_timer <= 0 {
		p1_combo_hits = 0;
		p1_combo_damage = 0;
		for(var i = 0; i < max_team_size; i++) {
			p1_char[i].combo_hits = 0;
			p1_char[i].combo_damage = 0;
		}
	}
	if p2_combo_timer <= 0 {
		p2_combo_hits = 0;
		p2_combo_damage = 0;
		for(var i = 0; i < max_team_size; i++) {
			p2_char[i].combo_hits = 0;
			p2_char[i].combo_damage = 0;
		}
	}
}