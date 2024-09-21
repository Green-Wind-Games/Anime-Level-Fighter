// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function init_charstates() {
	idle_state = new state();
	idle_state.start = function() {
		face_target();
		can_guard = true;
		can_cancel = true;
		is_hit = false;
		is_guarding = false;
		reset_cancels();
		
		if auto_levelup() {
			exit;
		}
		
		if on_ground {
			yspeed = 0;
			air_moves = 0;
			
			if input != noone {
				idle_state.run();
			}
			else {
				change_sprite(idle_sprite,6,true);
			}
		}
		else {
			change_state(air_state);
		}
	}
	idle_state.run = function() {
		if round_state == roundstates.fight {
			var walk_anim_speed = width / max(0.1,abs(xspeed));
			walk_anim_speed /= sprite_get_number(walk_sprite) / 4;
			walk_anim_speed = max(1,round(walk_anim_speed));
			face_target();
			if check_charge() {
				change_state(charge_state);
			}
			else if input.up {
				change_state(jump_state);
			}
			else if input.down {
				change_state(crouch_state);
			}
			else if input.forward {
				change_sprite(walk_sprite,walk_anim_speed,true);
				accelerate(move_speed * facing);
				xscale = abs(xscale);
			}
			else if input.back {
				change_sprite(walk_sprite,walk_anim_speed,true);
				accelerate(move_speed * -facing);
				xscale = -abs(xscale);
			}
			else {
				change_sprite(idle_sprite,6,true);
			}
		}
		else {
			change_sprite(idle_sprite,6,true);
			face_target();
		}
	}

	crouch_state = new state();
	crouch_state.start = function() {
		change_sprite(crouch_sprite,2,false);
		face_target();
	}
	crouch_state.run = function() {
		face_target();
		if input.down {
			if sprite != crouch_sprite {
				change_sprite(crouch_sprite,frame_duration,false);
			}
		}
		else if input.up {
			change_state(superjump_state);
		}
		else {
			if sprite != uncrouch_sprite {
				change_sprite(uncrouch_sprite,frame_duration,false);
			}
			return_to_idle();
		}
	}

	jump_state = new state();
	jump_state.start = function() {
		change_sprite(jumpsquat_sprite,2,false);
		squash_stretch(1.2,0.8);
		face_target();
	}
	jump_state.run = function() {
		if state_timer > 5 {
			change_state(air_state);
			squash_stretch(0.8,1.2);
			yspeed = -jump_speed;
			xspeed = move_speed * sign(input.right - input.left);
			play_sound(snd_jump);
		}
	}

	superjump_state = new state();
	superjump_state.start = function() {
		change_sprite(jumpsquat_sprite,2,false);
		squash_stretch(1.25,0.75);
		face_target();
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
		can_guard = true;
		can_cancel = true;
		is_hit = false;
		is_guarding = false;
		if land() {
			exit;
		}
	}
	air_state.run = function() {
		if land() {
			exit;
		}
		
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
			else if input.down {
				if yspeed < move_speed {
					yspeed = move_speed;
				}
			}
		}
		
		var peak_speed = 2;
		if value_in_range(yspeed,-peak_speed,peak_speed) {
			change_sprite(air_peak_sprite,5,true);
		}
		else if yspeed < 0 {
			change_sprite(air_up_sprite,5,true);
		}
		else {
			change_sprite(air_down_sprite,5,true);
		}
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
		var dash_duration = 15;
		can_cancel = true;
		if input.forward {
			if (target.is_airborne) or (target.on_ground and target_distance_x > 10) {
				dash_duration = abs(left_wall-right_wall) / abs(xspeed);
			}
		}
		
		if state_timer <= dash_duration {
			xspeed = move_speed * 2 * facing;
			yspeed = 0;
			loop_sound(snd_dash_loop);
			if input.up {
				yspeed = -jump_speed/2;
				change_state(air_state);
				play_sound(snd_jump);
			}
		}
		else {
			change_state(dash_stop_state);
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
			can_cancel = false;
			change_sprite(air_up_sprite,2,true);
			xspeed = move_speed * 2 * -facing;
			yspeed = -1.5;
			play_sound(snd_dash);
		}
	}
	backdash_state.run = function() {
		can_cancel = false;
		if on_ground {
			change_state(dash_stop_state);
		}
	}
	
	dash_stop_state = new state();
	dash_stop_state.start = function() {
		can_cancel = false;
		change_sprite(uncrouch_sprite,3,false);
	}
	dash_stop_state.run = function() {
		can_cancel = false;
		face_target();
		if (state_timer > 15) {
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
			change_state(idle_state);
		}
	}
	airdash_state.run = function() {
		xspeed = move_speed * 2 * facing;
		yspeed = 0;
		if state_timer >= 15 {
			change_state(idle_state);
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
			change_state(idle_state);
		}
	}
	air_backdash_state.run = function() {
		xspeed = -move_speed * 2 * facing;
		yspeed = 0;
		if state_timer >= 15 {
			change_state(idle_state);
		}
	}
	
	guard_state = new state();
	guard_state.start = function() {
		change_sprite(guard_sprite,6,false);
		is_guarding = true;
		can_guard = true;
		can_cancel = false;
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
		is_hit = true;
		can_guard = false;
		can_cancel = false;
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
			if on_ground and (yspeed >= 0) {
				if state_timer >= hitstun {
					change_state(liedown_state);
					xspeed = -1 * facing;
					yspeed = -5;
				}
			}
			else {
				change_state(hard_knockdown_state);
			}
		}
	}
	hit_state.stop = function() {
		is_hit = false;
	}
	
	grabbed_state = new state();
	grabbed_state.start = function() {
		change_sprite(grabbed_sprite,1000,false);
		xspeed = 0;
		yspeed = 0;
		can_cancel = false;
	}
	grabbed_state.run = function() {
		xspeed = 0;
		yspeed = 0;
	}
	
	hard_knockdown_state = new state();
	hard_knockdown_state.start = function() {
		is_hit = true;
		can_guard = false;
		can_cancel = false;
	}
	hard_knockdown_state.run = function() {
		if on_ground and (yspeed > 0) {
			if yspeed > 3 {
				change_sprite(hit_air_sprite,3,false);
				frame = anim_frames - 2;
				yoffset = height / 2;
				
				if yspeed >= 12 {
					take_damage(noone,abs(yspeed / 2),true);
					create_particles(x,y,x,y,floor_bang_particle,1);
					yspeed /= -2;
				}
				else {
					yspeed /= -4;
				}
				
				xspeed /= 2;
			}
			else {
				yspeed = 0;
				play_voiceline(voice_hurt,50,true);
				change_state(liedown_state);
			}
		}
	}
	
	wall_bounce_state = new state();
	wall_bounce_state.start = function() {
		change_sprite(launch_sprite,3,true);
		is_hit = true;
		can_guard = false;
		can_cancel = false;
	}
	wall_bounce_state.run = function() {
		if yspeed >= 0 {
			yspeed = 0;
		}
		if on_wall {
			take_damage(noone,abs(xspeed / 2),true);
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
		dodging_attacks = true;
		dodging_projectiles = true;
		can_cancel = false;
		yspeed = 0;
		with(hurtbox) {
			xoffset *= 2;
			yoffset /= 2;
			image_xscale *= 2;
			image_yscale /= 2;
		}
	}
	liedown_state.run = function() {
		if state_timer >= 40 {
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
		can_cancel = false;
		reset_combo();
	}
	tech_state.run = function() {
		if state_timer > 10 {
			change_state(idle_state);
		}
	}
	tech_state.stop = function() {
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
		can_cancel = false;
	}
	homing_dash_state.run = function() {
		
		var stop_distance = max(target.width_half, width_half) + 2;
		var _target_x = target_x - (stop_distance * facing);
		var _target_y = target_y;
		var _direction = point_direction(x,y,_target_x,_target_y);
		var _distance = point_distance(x,y,_target_x,_target_y);
		
		var _speed = move_speed * 2;
		var _xspeed = lengthdir_x(_speed,_direction);
		var _yspeed = lengthdir_y(_speed,_direction);
		 
		face_target();
		xspeed = _xspeed;
		yspeed = _yspeed;
		rotation = point_direction(0,0,abs(xspeed),yspeed);
		if _distance <= stop_distance {
			xspeed /= 2;
			yspeed /= 2;
			change_state(idle_state);
		}
	}
	
	substitution_state = new state();
	substitution_state.start = function() {
		change_sprite(crouch_sprite,3,false);
		reset_sprite();
		timestop();
		can_cancel = false;
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
			can_cancel = false;
		}
		else {
			change_state(previous_state);
		}
	}
	teleport_state.run = function() {
		xspeed = 0;
		yspeed = 0;
		face_target();
		timestop(20);
		if sprite == crouch_sprite {
			alpha -= 0.1;
			if alpha <= 0 {
				change_sprite(uncrouch_sprite,frame_duration,false);
				reset_sprite();
				alpha = 0;
				color = c_black;
				
				var dist = (game_width / 3);
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
			alpha += 0.1;
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
		aura_sprite = spr_aura_dbz_white;
		superfreeze(3 * 60);
		play_sound(snd_energy_start);
		play_voiceline(voice_powerup);
		level_up();
		can_cancel = false;
	}
	levelup_state.run = function() {
		shake_screen(5,2);
		if !superfreeze_active {
			aura_sprite = noone;
			change_state(idle_state);
		}
	}
	
	transform_state = new state();
	transform_state.start = function() {
		change_sprite(charge_loop_sprite,3,true);
		superfreeze(2 * 60);
		play_voiceline(voice_transform);
		can_cancel = false;
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
			can_cancel = false;
			can_guard = false;
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
				play_voiceline(voice_powerup);
				play_sound(snd_energy_start);
			}
		}
		else if sprite == charge_loop_sprite {
			deflecting_projectiles = true;
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
	charge_state.stop = function() {
		aura_sprite = noone;
		deflecting_projectiles = false;
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
		return true;
	}
	return false;
}