// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function init_charstates() {
	idle_state = new state();
	idle_state.start = function() {
		if on_ground {
			if input != noone {
				if input.forward {
					change_sprite(walk_sprite,6,true);
					accelerate(move_speed * facing);
					xscale = abs(xscale);
				}
				else if input.back {
					change_sprite(walk_sprite,6,true);
					accelerate(move_speed * -facing);
					xscale = -abs(xscale);
				}
				else {
					change_sprite(idle_sprite,6,true);
				}
			}
			else {
				change_sprite(idle_sprite,6,true);
			}
			face_target();
			reset_cancels();
			yspeed = 0;
			air_moves = 0;
			
			auto_levelup();
		}
		else {
			change_state(air_state);
		}
		can_guard = true;
		can_cancel = true;
		is_hit = false;
		is_guarding = false;
		deactivate_super();
	}
	idle_state.run = function() {
		if round_state == roundstates.fight {
			var walk_anim_speed = round(map_value(sprite_get_number(walk_sprite),4,8,6,3));
			if input.forward {
				change_sprite(walk_sprite,walk_anim_speed,true);
				accelerate(move_speed * facing);
				xscale = abs(xscale);
			}
			else if input.back {
				change_sprite(walk_sprite,walk_anim_speed,true);
				accelerate(move_speed * -facing);
				xscale = -abs(xscale);
				
				//facing = -facing;
				//if target_front_enemy() == noone {
				//	facing = -facing;
				//}
				//else {
				//	xscale = abs(xscale);
				//	target = target_front_enemy();
				//}
			}
			else {
				change_sprite(idle_sprite,6,true);
				face_target();
			}
			if input.up {
				change_state(jump_state);
			}
			else if input.down {
				change_state(crouch_state);
			}
			else if check_charge() {
				change_state(charge_state);
			}
			check_moves();
		}
		else {
			change_sprite(idle_sprite,6,true);
			face_target();
		}
	}

	crouch_state = new state();
	crouch_state.start = function() {
		change_sprite(crouch_sprite,3,false);
		face_target();
		reset_cancels();
		yspeed = 0;
		air_moves = 0;
		can_guard = true;
		can_cancel = true;
	}
	crouch_state.run = function() {
		face_target();
		if input.down {
			if sprite != crouch_sprite {
				change_sprite(crouch_sprite,frame_duration,false);
			}
		}
		else {
			if sprite != uncrouch_sprite {
				change_sprite(uncrouch_sprite,frame_duration,false);
			}
			return_to_idle();
		}
		if input.up {
			change_state(superjump_state);
		}
		else if input.back {
			facing = -facing;
			if target_front_enemy() == noone {
				facing = -facing;
			}
			else {
				target = target_front_enemy();
			}
		}
		check_moves();
	}

	jump_state = new state();
	jump_state.start = function() {
		change_sprite(crouch_sprite,2,false);
		squash_stretch(1.2,0.8);
		face_target();
		reset_cancels();
		xspeed = 0;
		yspeed = 0;
		air_moves = 0;
		can_guard = true;
		can_cancel = true;
	}
	jump_state.run = function() {
		if state_timer > 5 {
			change_state(air_state);
			squash_stretch(0.8,1.2);
			yspeed = -jump_speed;
			xspeed = move_speed * sign(input.right - input.left);
			play_sound(snd_jump);
		}
		else if input.back {
			facing = -facing;
			if target_front_enemy() == noone {
				facing = -facing;
			}
			else {
				target = target_front_enemy();
			}
		}
	}

	superjump_state = new state();
	superjump_state.start = function() {
		change_sprite(crouch_sprite,2,false);
		squash_stretch(1.25,0.75);
		reset_cancels();
		xspeed = 0;
		yspeed = 0;
		air_moves = 0;
		can_guard = true;
		can_cancel = true;
	}
	superjump_state.run = function() {
		if state_timer > 5 {
			change_state(air_state);
			squash_stretch(0.75,1.25);
			yspeed = -jump_speed * 1.5;
			xspeed = move_speed * sign(input.right - input.left);
			play_sound(snd_jump,1,0.8);
		}
	}

	air_state = new state();
	air_state.start = function() {
		change_sprite(air_peak_sprite,5,true);
		reset_cancels();
		can_guard = true;
		can_cancel = true;
	}
	air_state.run = function() {
		if yspeed >= 0 {
			if input.up {
				if air_moves < max_air_moves {
					xspeed = move_speed * sign(input.right - input.left);
					yspeed = -jump_speed * 0.75;
					air_moves += 1;
					squash_stretch(0.8,1.2);
					play_sound(snd_airjump);
				}
			}
			//else if input.down {
			//	if yspeed < 5 {
			//		yspeed = 5;
			//	}
			//}
		}
		var peak_speed = 2;
		if yspeed < -peak_speed {
			change_sprite(air_up_sprite,5,true);
		}
		else if yspeed <= peak_speed {
			change_sprite(air_peak_sprite,5,true);
		}
		else {
			change_sprite(air_down_sprite,5,true);
		}
		land();
		check_moves();
	}
	
	dash_state = new state();
	dash_state.start = function() {
		if is_airborne {
			change_state(airdash_state);
		}
		else {
			change_sprite(dash_sprite,2,true);
			yoffset = -height_half;
			xspeed = move_speed * 2 * facing;
			yspeed = 0;
			play_sound(snd_dash);
			play_sound(snd_dash_loop);
		}
	}
	dash_state.run = function() {
		xspeed = move_speed * 2 * facing;
		yspeed = 0;
		var dash_duration = 10;
		if input.forward {
			if target.is_airborne or (target.on_ground and target_distance_x > 20)
			dash_duration = abs(left_wall-right_wall) / abs(xspeed);
		}
		if state_timer < dash_duration {
			loop_sound(snd_dash_loop);
		}
		else {
			change_state(dash_stop_state);
		}
		if input.up {
			yspeed = -jump_speed/2;
			change_state(air_state);
			play_sound(snd_jump);
		}
		else {
			can_cancel = true;
			check_moves();
		}
	}
	dash_state.stop = function() {
		if next_state != airdash_state {
			stop_sound(sound);
		}
	}
	
	backdash_state = new state();
	backdash_state.start = function() {
		if is_airborne {
			change_state(air_backdash_state);
		}
		else {
			change_sprite(air_up_sprite,2,true);
			xspeed = move_speed * 2 * -facing;
			yspeed = -1.5;
			play_sound(snd_dash);
		}
	}
	backdash_state.run = function() {
		if on_ground {
			change_state(dash_stop_state);
		}
	}
	
	dash_stop_state = new state();
	dash_stop_state.start = function() {
		change_sprite(uncrouch_sprite,3,false);
	}
	dash_stop_state.run = function() {
		if state_timer > 8 {
			change_state(idle_state);
		}
	}
	
	airdash_state = new state();
	airdash_state.start = function() {
		if air_moves < max_air_moves {
			change_sprite(dash_sprite,2,true);
			yoffset = -height_half;
			xspeed = move_speed * 2 * facing;
			yspeed = 0;
			air_moves += 1;
			play_sound(snd_dash);
		}
		else {
			change_state(air_state);
		}
	}
	airdash_state.run = function() {
		xspeed = move_speed * 2 * facing;
		yspeed = 0;
		if state_timer >= 15 {
			change_state(air_state);
		}
	}
	
	air_backdash_state = new state();
	air_backdash_state.start = function() {
		if air_moves < max_air_moves {
			change_sprite(dash_sprite,2,true);
			yoffset = -height_half;
			xscale = -1;
			xspeed = move_speed * 2 * -facing;
			yspeed = 0;
			air_moves += 1;
			play_sound(snd_dash);
		}
		else {
			change_state(air_state);
		}
	}
	air_backdash_state.run = function() {
		xspeed = move_speed * 2 * -facing;
		yspeed = 0;
		if state_timer >= 15 {
			change_state(air_state);
		}
	}
	
	guard_state = new state();
	guard_state.start = function() {
		change_sprite(guard_sprite,6,false);
		reset_cancels();
		is_guarding = true;
		can_guard = true;
	}
	guard_state.run = function() {
		is_guarding = true;
		can_guard = true;
		if state_timer < blockstun - anim_duration {
			frame = 0;
		}
		if state_timer >= blockstun {
			change_state(idle_state);
		}
	}
	guard_state.stop = function() {
		is_guarding = false;
	}
	
	hit_state = new state();
	hit_state.start = function() {
		reset_cancels();
		is_hit = true;
		can_guard = false;
	}
	hit_state.run = function() {
		is_hit = true;
		can_guard = false;
		if hp > 0 {
			if on_ground {
				if yspeed > 0 {
					change_state(tech_state);
				}
			}
			if state_timer >= hitstun {
				if on_ground {
					change_state(idle_state);
				}
				else {
					change_state(tech_state);
				}
			}
		}
		else {
			if on_ground {
				if yspeed == 0 {
					if state_timer >= hitstun {
						change_state(liedown_state);
						yspeed = -2;
					}
				}
				else {
					change_state(liedown_state);
				}
			}
		}
	}
	hit_state.stop = function() {
		is_hit = false;
	}
	
	grabbed_state = new state();
	grabbed_state.start = function() {
		xspeed = 0;
		yspeed = 0;
		change_sprite(grabbed_sprite,1000,false);
	}
	grabbed_state.run = function() {
		xspeed = 0;
		yspeed = 0;
	}
	
	hard_knockdown_state = new state();
	hard_knockdown_state.start = function() {
		reset_cancels();
		is_hit = true;
		can_guard = false;
	}
	hard_knockdown_state.run = function() {
		if on_ground {
			change_state(liedown_state);
			play_voiceline(voice_hurt,50,true);
		}
	}
	
	wall_bounce_state = new state();
	wall_bounce_state.start = function() {
		change_sprite(launch_sprite,3,true);
		reset_cancels();
		is_hit = true;
		can_guard = false;
	}
	wall_bounce_state.run = function() {
		if yspeed >= 0 {
			yspeed = 0;
		}
		if on_ground {
			y -= 1;
		}
		if on_wall {
			take_damage(noone,abs(xspeed),true);
			if xspeed < 0 {
				create_particles(left_wall,y-height_half,left_wall,y-height_half,left_wall_bang_particle,1);
			}
			else {
				create_particles(right_wall,y-height_half,right_wall,y-height_half,right_wall_bang_particle,1);
			}
			xspeed *= -0.25;
			yspeed = -5;
			change_state(hard_knockdown_state);
		}
	}
	
	liedown_state = new state();
	liedown_state.start = function() {
		change_sprite(liedown_sprite,2,false);
		xspeed *= 0.25;
		yspeed *= -0.25;
		dodging_attacks = true;
		dodging_projectiles = true;
		with(hurtbox) {
			xoffset *= 2;
			yoffset /= 2;
			image_xscale *= 2;
			image_yscale /= 2;
		}
	}
	liedown_state.run = function() {
		if on_ground {
			if state_timer >= 60 {
				if hp > 0 {
					if sprite != wakeup_sprite {
						change_sprite(wakeup_sprite,5,false);
					}
					return_to_idle();
				}
				else {
					dead = true;
					is_hit = false;
					change_state(dead_state);
				}
			}
			else {
				change_sprite(liedown_sprite,2,false);
			}
		}
		else {
			change_sprite(hit_air_sprite,3,false);
		}
	}
	liedown_state.stop = function() {
		with(hurtbox) {
			xoffset /= 2;
			yoffset *= 2;
			image_xscale /= 2;
			image_yscale *= 2;
		}
		dodging_attacks = false;
		dodging_projectiles = false;
	}
	
	tech_state = new state();
	tech_state.start = function() {
		change_sprite(tech_sprite,6,false);
		flash_sprite();
		yoffset = -height_half;
		rotation_speed = 36;
		xspeed = 5 * sign(input.right - input.left);
		yspeed = -3;
		dodging_attacks = true;
		dodging_projectiles = true;
		reset_combo();
	}
	tech_state.run = function() {
		if state_timer > 10 {
			change_state(air_state);
		}
	}
	tech_state.stop = function() {
		dodging_attacks = false;
		dodging_projectiles = false;
	}
	
	tag_out_state = new state();
	tag_out_state.start = function() {
		change_sprite(crouch_sprite,3,false);
		reset_cancels();
		face_target();
		invincible = true;
		dodging_attacks = true;
		dodging_projectiles = true;
	}
	tag_out_state.run = function() {
		if sprite == crouch_sprite {
			if anim_finished {
				change_sprite(air_up_sprite,3,true);
				xspeed = -15 * facing;
				yspeed = -15;
			}
		}
		else {
			gravitate();
			if on_ground {
				yspeed = -15;
			}
			if !value_in_range(x,-width,room_width+width) {
				invincible = true;
				dodging_attacks = true;
				dodging_projectiles = true;
				if team == 1 {
					x = -room_width;
				}
				else {
					x = room_width * 2;
				}
				y = -room_height;
				
				if state_timer > 180 {
					if hp_percent < 90 {
						if state_timer mod 6 == 0 {
							hp++;
						}
					}
				}
			}
		}
	}
	tag_out_state.stop = function() {
		alpha = 1;
		invincible = false;
		dodging_attacks = false;
		dodging_projectiles = false;
	}
	
	homing_dash_state = new state();
	homing_dash_state.start = function() {
		change_sprite(dash_sprite,2,true);
		yoffset = -height_half;
		xspeed = 0;
		yspeed = 0;
		can_guard = true;
		can_cancel = true;
	}
	homing_dash_state.run = function() {
		var _speed = move_speed * 2.5;
		var _direction = point_direction(x,y,target.x-(width_half*facing),target.y);
		var _xspeed = lengthdir_x(_speed,_direction);
		var _yspeed = lengthdir_y(_speed,_direction);
		face_target();
		//xspeed = approach(xspeed,_xspeed,2);
		//yspeed = approach(yspeed,_yspeed,2);
		xspeed = _xspeed;
		yspeed = _yspeed;
		rotation = point_direction(0,0,abs(xspeed),yspeed);
		var stop_distance = 5;
		if previous_state == tag_out_state {
			stop_distance *= 2;
		}
		if target_distance <= stop_distance {
			xspeed = 3 * facing;
			yspeed = -5;
			change_state(air_state);
			check_moves();
		}
	}
	
	substitution_state = new state();
	substitution_state.start = function() {
		change_sprite(crouch_sprite,3,false);
		reset_sprite();
		timestop();
	}
	substitution_state.run = function() {
		xspeed = 0;
		yspeed = 0;
		face_target();
		timestop(10);
		if sprite == crouch_sprite {
			xspeed = facing;
			
			alpha -= 0.1;
			if alpha <= 0 {
				change_sprite(uncrouch_sprite,frame_duration,false);
				reset_sprite();
				alpha = 0;
				color = c_black;
				x = target_x + (100 * facing);
				y = target_y;
				
				if !value_in_range(x,left_wall,right_wall) {
					x = target_x;
					y = target_y - 100;
				}
			}
		}
		else {
			alpha += 0.1;
			if alpha >= 1 {
				reset_sprite();
				timestop(0);
				change_state(idle_state);
			}
		}
	}
	
	teleport_state = new state();
	teleport_state.start = function() {
		if check_tp(1) {
			spend_tp(1);
			change_sprite(crouch_sprite,3,false);
			reset_sprite();
			timestop();
			play_sound(snd_dbz_teleport_short);
		}
		else {
			change_state(previous_state);
		}
	}
	teleport_state.run = function() {
		xspeed = 0;
		yspeed = 0;
		face_target();
		timestop(10);
		if sprite == crouch_sprite {
			alpha -= 0.2;
			if alpha <= 0 {
				change_sprite(uncrouch_sprite,frame_duration,false);
				reset_sprite();
				alpha = 0;
				color = c_black;
				
				var dist = (game_width / 3)
				x += dist * sign(input.right-input.left);
				y += dist * sign(input.down-input.up);
				
				if !input.left
				and !input.right
				and !input.up
				and !input.down {
					x += dist * facing;
				}
				
				face_target();
				if !value_in_range(x,left_wall,right_wall) {
					x = clamp(x,left_wall,right_wall);
					if target_x <= left_wall
					or target_x >= right_wall {
						target_x += width * facing;
					}
				}
				if y > ground_height {
					y = ground_height;
				}
			}
		}
		else {
			alpha += 0.2;
			if alpha >= 1 {
				reset_sprite();
				timestop(0);
				change_state(idle_state);
			}
		}
	}
	
	levelup_state = new state();
	levelup_state.start = function() {
		change_sprite(charge_loop_sprite,3,true);
		flash_sprite();
		superfreeze(3 * 60);
		play_sound(snd_energy_start);
		play_voiceline(voice_powerup);
		level_up();
	}
	levelup_state.run = function() {
		shake_screen(5,2);
		if !superfreeze_active {
			change_state(idle_state);
		}
	}
	
	transform_state = new state();
	transform_state.start = function() {
		change_sprite(charge_loop_sprite,3,true);
		superfreeze(2 * 60);
		play_voiceline(voice_transform);
	}
	transform_state.run = function() {
		shake_screen(5,2);
		loop_sound(snd_energy_loop);
		if superfreeze_timer <= 5 {
			transform(next_form);
		}
	}
	
	charge_state = new state();
	charge_state.start = function() {
		if check_charge() {
			change_sprite(charge_start_sprite,3,false);
			play_voiceline(voice_powerup);
		}
		else {
			change_state(previous_state);
		}
	}
	charge_state.run = function() {
		if sprite == charge_start_sprite {
			if anim_finished {
				change_sprite(charge_loop_sprite,3,true)
				flash_sprite();
				play_sound(snd_energy_start);
			}
		}
		else if sprite == charge_loop_sprite {
			if check_charge() or state_timer < 30 {
				mp += ceil((mp_stock_size / 60) / 1.5);
			
				loop_sound(snd_energy_loop);
			
				shake_screen(5,2);
				aura_sprite = spr_aura_dbz_white;
			}
			else {
				change_sprite(charge_stop_sprite,3,false);
				flash_sprite();
				play_sound(snd_energy_stop);
				stop_sound(voice);
				aura_sprite = noone;
			}
		}
		else {
			if anim_finished {
				change_state(idle_state);
			}
		}
	}
	
	intro_state = new state();
	intro_state.start = function() {
		change_sprite(idle_sprite,6,true);
		play_voiceline(voice_intro);
	}
	intro_state.run = function() {
		if !sound_is_playing(voice) 
		and anim_finished {
			change_state(idle_state);
		}
	}
	
	victory_state = new state();
	victory_state.start = function() {
		change_sprite(victory_sprite,6,false);
		play_voiceline(voice_victory);
	}
	defeat_state = new state();
	defeat_state.start = function() {
		change_sprite(defeat_sprite,6,false);
		play_voiceline(voice_defeat);
	}
	
	dead_state = new state();
	dead_state.start = function() {
		change_sprite(liedown_sprite,10,true);
	}
	dead_state.run = function() {
		if hp > 0 {
			change_state(liedown_state);
		}
	}
	
	add_move(dash_state,"656");
	add_move(backdash_state,"454");
	
	add_move(dash_state,"956");
	add_move(backdash_state,"754");
	
	add_move(teleport_state,"F");
	
	init_states(idle_state);
}

function return_to_idle() {
	if anim_finished {
		change_state(idle_state);
	}
}

function land() {
	if on_ground and (yspeed > 0) {
		var stretch = map_value(yspeed,0,8,1,1.25);
		var squash = map_value(yspeed,0,8,1,0.75);
		change_state(idle_state);
		squash_stretch(stretch,squash);
	}
}