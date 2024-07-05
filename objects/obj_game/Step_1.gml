///// @description Insert description here
//// You can write your code in this editor

//with(obj_char) {
//	input_up = false;
//	input_down = false;
//	input_left = false;
//	input_right = false;
	
//	input_a = false;
//	input_b = false;
//	input_c = false;
//	input_d = false;
//}

//with(p1_active_character) {
//	if p1_up input_up = true;
//	if p1_down input_down = true;
//	if p1_left input_left = true;
//	if p1_right input_right = true;
	
//	if p1_attack input_a = true;
//	if p1_projectile input_d = true;
//	if p1_grab input_c = true;
//	if p1_special input_b = true;
//}

//with(p2_active_character) {
//	if p2_up input_up = true;
//	if p2_down input_down = true;
//	if p2_left input_left = true;
//	if p2_right input_right = true;
	
//	if p2_attack input_a = true;
//	if p2_projectile input_d = true;
//	if p2_grab input_c = true;
//	if p2_special input_b = true;
//}

//with(obj_char) {
//	if facing == 1 {
//		input_forward = input_right;
//		input_back = input_left;
//	}
//	else {
//		input_forward = input_left;
//		input_back = input_right;
//	}
	
//	var _buffer = input_buffer;
	
//	var hor = sign(input_forward - input_back);
//	var ver = sign(input_up - input_down);
//	var dir = string(5 + hor + (ver * 3));
	
//	if !string_ends_with(string_digits(input_buffer),dir) {
//		input_buffer += dir;
//	}
	
//	if input_a {
//		input_buffer += "A";
//	}
//	if input_d {
//		input_buffer += "P";
//	}
//	if input_c {
//		input_buffer += "G";
//	}
//	if input_b {
//		input_buffer += "S";
//	}
	
//	if input_buffer != _buffer {
//		input_buffer_timer = 10;
//	}
//	else {
//		input_buffer_timer -= (!hitstop);
//		if input_buffer_timer <= 0 {
//			input_buffer = "";
//			input_buffer_timer = 0;
//		}
//	}
//}

//p1_forward = p1_active_character.input_forward;
//p1_back = p1_active_character.input_back;

//p2_forward = p2_active_character.input_forward;
//p2_back = p2_active_character.input_back;

//if p1_assist1 {
//	if !p1_is_hit and !p1_is_blocking {
//		var called_number = 1;
//		var called_char = p1_char[1];
//		if p1_active_character == p1_char[1] {
//			called_char = p1_char[0];
//			called_number = 0;
//		}
//		if p1_char_assist_timer[called_number] <= 0 {
//			with(called_char) {
//				x = p1_active_character.x;
//				y = ground_height;
//				xspeed = 0;
//				yspeed = 0;
//				if p1_char_assist_type[called_number] == assist_type.a {
//					p1_char_assist_timer[called_number] = assist_a_cooldown;
//					change_state(assist_a_state);
//				}
//				else if p1_char_assist_type[called_number] == assist_type.b {
//					p1_char_assist_timer[called_number] = assist_b_cooldown;
//					change_state(assist_b_state);
//				}
//				else {
//					p1_char_assist_timer[called_number] = assist_c_cooldown;
//					change_state(assist_c_state);
//				}
//			}
//		}
//	}
//}

//if p1_assist2 {
//	if !p1_is_hit and !p1_is_blocking {
//		var called_number = 2;
//		var called_char = p1_char[2];
//		if p1_active_character == p1_char[2] {
//			called_char = p1_char[0];
//			called_number = 0;
//		}
//		if p1_char_assist_timer[called_number] <= 0 {
//			with(called_char) {
//				x = p1_active_character.x;
//				y = ground_height;
//				xspeed = 0;
//				yspeed = 0;
//				if p1_char_assist_type[called_number] == assist_type.a {
//					p1_char_assist_timer[called_number] = assist_a_cooldown;
//					change_state(assist_a_state);
//				}
//				else if p1_char_assist_type[called_number] == assist_type.b {
//					p1_char_assist_timer[called_number] = assist_b_cooldown;
//					change_state(assist_b_state);
//				}
//				else {
//					p1_char_assist_timer[called_number] = assist_c_cooldown;
//					change_state(assist_c_state);
//				}
//			}
//		}
//	}
//}

//if p2_assist1 {
//	if !p2_is_hit and !p2_is_blocking {
//		var called_number = 1;
//		var called_char = p2_char[1];
//		if p2_active_character == p2_char[1] {
//			called_char = p2_char[0];
//			called_number = 0;
//		}
//		if p2_char_assist_timer[called_number] <= 0 {
//			with(called_char) {
//				x = p2_active_character.x;
//				y = ground_height;
//				xspeed = 0;
//				yspeed = 0;
//				if p2_char_assist_type[called_number] == assist_type.a {
//					p2_char_assist_timer[called_number] = assist_a_cooldown;
//					change_state(assist_a_state);
//				}
//				else if p2_char_assist_type[called_number] == assist_type.b {
//					p2_char_assist_timer[called_number] = assist_b_cooldown;
//					change_state(assist_b_state);
//				}
//				else {
//					p2_char_assist_timer[called_number] = assist_c_cooldown;
//					change_state(assist_c_state);
//				}
//			}
//		}
//	}
//}

//if p2_assist2 {
//	if !p2_is_hit and !p2_is_blocking {
//		var called_number = 2;
//		var called_char = p2_char[2];
//		if p2_active_character == p2_char[2] {
//			called_char = p2_char[0];
//			called_number = 0;
//		}
//		if p2_char_assist_timer[called_number] <= 0 {
//			with(called_char) {
//				x = p2_active_character.x;
//				y = ground_height;
//				xspeed = 0;
//				yspeed = 0;
//				if p2_char_assist_type[called_number] == assist_type.a {
//					p2_char_assist_timer[called_number] = assist_a_cooldown;
//					change_state(assist_a_state);
//				}
//				else if p2_char_assist_type[called_number] == assist_type.b {
//					p2_char_assist_timer[called_number] = assist_b_cooldown;
//					change_state(assist_b_state);
//				}
//				else {
//					p2_char_assist_timer[called_number] = assist_c_cooldown;
//					change_state(assist_c_state);
//				}
//			}
//		}
//	}
//}

//for(var i = 0; i < max_team_size; i++) {
//	with(p1_char[i]) {
//		team = 1;
//		target = p2_active_character;
//		if active_state == tag_out_state {
//			p1_char_assist_timer[i] -= 1;
//		}
//		p1_char_facing[i] = facing;
//		p1_char_hp[i] = hp;
//		p1_char_hp_percent[i] = hp_percent;
//		p1_char_x[i] = x;
//		p1_char_y[i] = y;
//	}
//	with(p2_char[i]) {
//		team = 2;
//		target = p1_active_character;
//		if active_state == tag_out_state {
//			p2_char_assist_timer[i] -= 1;
//		}
//		p2_char_facing[i] = facing;
//		p2_char_hp[i] = hp;
//		p2_char_hp_percent[i] = hp_percent;
//		p2_char_x[i] = x;
//		p2_char_y[i] = y;
//	}
//}

//with(obj_shot) {
//	target = owner.target;
//}