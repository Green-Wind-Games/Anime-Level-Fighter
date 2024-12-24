// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function init_charstates() {
	idle_state = new state();
	idle_state.start = function() {
		face_target();
		reset_cancels();
		can_guard = true;
		can_cancel = true;
		is_hit = false;
		is_guarding = false;
		
		if on_ground {
			change_sprite(idle_sprite,6,true);
			xspeed = 0;
			yspeed = 0;
			air_moves = 0;
		}
		else {
			change_state(air_state);
		}
	}
	idle_state.run = function() {
		face_target();
		
		if round_state == roundstates.fight {
			can_cancel = true;
			
			if auto_levelup() {
				exit;
			}
			
			if check_charge() {
				change_state(charge_state);
			}
			else if input.up {
				change_state(jump_state);
			}
			else if input.down {
				change_state(crouch_state);
			}
			else {
				if input.left or input.right {
					accelerate(move_speed * move_speed_mod * move_speed_buff * sign(input.right - input.left));
					var walk_anim_speed = width / abs(xspeed);
					walk_anim_speed /= max(1,sprite_get_number(walk_sprite) / 6);
					walk_anim_speed = max(3,round(walk_anim_speed));
					change_sprite(walk_sprite,walk_anim_speed,true);
					xscale = abs(xscale) * sign(input.right-input.left) * facing;
				}
				else {
					change_sprite(idle_sprite,6,true);
				}
			}
		}
		else {
			change_sprite(idle_sprite,6,true);
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
			xspeed = move_speed * move_speed_mod * move_speed_buff * sign(input.right - input.left);
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
			xspeed = move_speed * move_speed_mod * move_speed_buff * sign(input.right - input.left);
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
		
		if previous_state == airdash_state
		or previous_state == air_backdash_state {
			if abs(xspeed) > (base_movespeed / 2) {
				decelerate(1);
			}
			can_cancel = state_timer > 10;
		}
		
		if yspeed >= 0 {
			if input.up {
				if air_moves < max_air_moves {
					xspeed = move_speed * move_speed_mod * move_speed_buff * sign(input.right - input.left);
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
		change_sprite(dash_sprite,2,true);
		yoffset = -height_half;
		xspeed = move_speed * move_speed_mod * move_speed_buff * 2 * facing;
		yspeed = 0;
		play_sound(snd_dash);
		play_sound(snd_dash_loop);
		if sprite_get_yoffset(walk_sprite) <= sprite_get_height(walk_sprite) {
			change_sprite(walk_sprite,frame_duration,true);
		}
	}
	dash_state.run = function() {
		can_cancel = true;
		var dash_duration = 10;
		if ((!ai_enabled) and (input.forward)) 
		or ((ai_enabled) and (target_distance_x > 20)){
			dash_duration = 60;
		}
		if state_timer mod 5 == 1 {
			create_specialeffect(spr_dust_dash,x,y,facing * 0.5,0.5);
		}
		
		if state_timer <= dash_duration {
			xspeed = move_speed * move_speed_mod * move_speed_buff * 2 * facing;
			yspeed = 0;
			if sprite == dash_sprite {
				loop_sound(snd_dash_loop);
			}
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
		change_sprite(air_up_sprite,2,true);
		can_cancel = false;
		xspeed = move_speed * move_speed_mod * move_speed_buff * 2 * -facing;
		yspeed = -1.5;
		play_sound(snd_dash);
		create_specialeffect(spr_dust_dash,x,y,-facing * 0.5,0.5);
	}
	backdash_state.run = function() {
		can_cancel = false;
		if on_ground and state_timer > 5 {
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
		decelerate(1);
		if (state_timer > 10) or (xspeed == 0) {
			change_state(idle_state);
		}
	}
	
	airdash_state = new state();
	airdash_state.start = function() {
		if air_moves < max_air_moves {
			change_sprite(dash_sprite,2,true);
			yoffset = -height_half;
			xspeed = move_speed * move_speed_mod * move_speed_buff * 2 * facing;
			yspeed = 0;
			air_moves += 1;
			play_sound(snd_dash);
		}
		else {
			change_state(air_state);
		}
	}
	airdash_state.run = function() {
		xspeed = move_speed * move_speed_mod * move_speed_buff * 2 * facing;
		yspeed = 0;
		if state_timer >= 6 {
			change_state(air_state);
		}
	}
	
	air_backdash_state = new state();
	air_backdash_state.start = function() {
		if air_moves < max_air_moves {
			change_sprite(dash_sprite,2,true);
			yoffset = -height_half;
			xscale = -1;
			xspeed = move_speed * move_speed_mod * move_speed_buff * 2 * -facing;
			yspeed = 0;
			air_moves += 1;
			play_sound(snd_dash);
		}
		else {
			change_state(air_state);
		}
	}
	air_backdash_state.run = function() {
		xspeed = -move_speed * move_speed_mod * move_speed_buff * 2 * facing;
		yspeed = 0;
		if state_timer >= 6 {
			change_state(air_state);
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
		if dead {
			change_state(hard_knockdown_state);
		}
	}
	hit_state.run = function() {
		is_hit = true;
		can_guard = false;
		if state_timer >= hitstun {
			if !dead {
				if on_ground {
					change_state(idle_state);
				}
				else {
					change_state(tech_state);
				}
			}
			else {
				if on_ground {
					xspeed = -1 * facing;
					yspeed = -5;
				}
				change_state(hard_knockdown_state);
			}
		}
		if on_ground and (yspeed > 0) and (!dead) {
			change_state(tech_state);
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
		if (yspeed > 0) {
			if is_airborne {
				change_sprite(launch_sprite,3,true);
				yoffset = -height_half;
			}
			else {
				if yspeed > 3 {
					change_sprite(hit_air_sprite,3,false);
					frame = anim_frames - 2;
				
					if yspeed >= 15 {
						take_damage(noone,abs(yspeed),false);
						create_particles(x,y,x,y,floor_bang_particle,1);
					}
					yspeed *= -0.25;
				
					xspeed /= 2;
				}
				else {
					yspeed = 0;
					change_state(liedown_state);
				}
				if !dead {
					play_voiceline(voice_hurt,50,true);
				}
			}
		}
	}
	
	wall_splat_state = new state();
	wall_splat_state.start = function() {
		hit_state.start();
	}
	wall_splat_state.run = function() {
		if ((xspeed < 0) and (on_left_wall)) {
			xspeed = 0;
			create_particles(
				left_wall,
				y-height_half,
				left_wall,
				y-height_half,
				wall_bang_left_particle
			);
		}
		if ((xspeed > 0) and (on_right_wall)) {
			xspeed = 0;
			create_particles(
				right_wall,
				y-height_half,
				right_wall,
				y-height_half,
				wall_bang_right_particle
			);
		}
		hit_state.run();
	}
	
	wall_bounce_state = new state();
	wall_bounce_state.start = function() {
		change_sprite(launch_sprite,3,true);
		is_hit = true;
		can_guard = false;
		can_cancel = false;
	}
	wall_bounce_state.run = function() {
		var _x = sign(xspeed);
		xspeed = max(30,abs(xspeed)) * _x;
		if state_timer mod ceil(width / max(1,abs(xspeed))) == 0 {
			create_specialeffect(
				spr_launch_wind_spin,
				x,
				y-height_half,
				1/3,
				1/3,
				point_direction(0,0,abs(xspeed),yspeed)
			)
		}
		if yspeed >= 0 {
			yspeed = 0;
		}
		if on_wall {
			take_damage(noone,abs(xspeed / 2),true);
			if on_left_wall {
				create_particles(
					left_wall,
					y-height_half,
					left_wall,
					y-height_half,
					wall_bang_left_particle
				);
			}
			else {
				create_particles(
					right_wall,
					y-height_half,
					right_wall,
					y-height_half,
					wall_bang_right_particle,
				);
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
		if (state_timer >= 30) and (!dead) {
			if sprite != wakeup_sprite {
				change_sprite(wakeup_sprite,6,false);
			}
			return_to_idle();
		}
		else {
			if sprite != liedown_sprite {
				change_sprite(liedown_sprite,6,true);
			}
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
		homing_dash_state.run();
	}
	homing_dash_state.run = function() {
		if !target_exists() {
			change_state(idle_state);
			exit;
		}
		var stop_distance = 10;
		var _my_x = x + (width_half * facing);
		var _my_y = y - height_half;
		var _target_x = target.x - (target.width_half * facing);
		var _target_y = target.y - target.height_half;
		var _direction = point_direction(_my_x,_my_y,_target_x,_target_y);
		var _distance = point_distance(_my_x,_my_y,_target_x,_target_y);
		
		var _speed = 12;
		var _xspeed = lengthdir_x(_speed,_direction);
		var _yspeed = lengthdir_y(_speed,_direction);
		 
		face_target();
		xspeed = approach(xspeed,_xspeed,2);
		yspeed = approach(yspeed,_yspeed,2);
		rotation = point_direction(0,0,abs(xspeed),yspeed);
		if _distance <= stop_distance {
			xspeed /= 2;
			yspeed = -_speed / 2;
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
		color = c_black;
		if sprite == crouch_sprite {
			xspeed = facing;
			
			alpha -= 0.1;
			if alpha <= 0 {
				change_sprite(uncrouch_sprite,frame_duration,false);
				reset_sprite();
				alpha = 0;
				substitution_teleport()
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
			change_state(idle_state);
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
				var _x = x;
				var _y = y;
				_x += dist * sign(input.right-input.left);
				_y += dist * sign(input.down-input.up);
				
				if !input.left
				and !input.right
				and !input.up
				and !input.down {
					_x += dist * facing;
				}
				
				teleport(_x,_y);
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
		aura_sprite = transform_aura;
		superfreeze(3 * 60);
		play_sound(snd_energy_start);
		level_up();
		can_cancel = false;
	}
	levelup_state.run = function() {
		xspeed = 0;
		yspeed = 0;
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
		aura_sprite = transform_aura;
	}
	transform_state.run = function() {
		xspeed = 0;
		yspeed = 0;
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
			change_state(idle_state);
		}
	}
	charge_state.run = function() {
		if sprite == charge_start_sprite {
			if anim_finished {
				change_sprite(charge_loop_sprite,3,true);
				play_voiceline(voice_powerup);
				if charge_start_sound != noone {
					flash_sprite();
					play_sound(charge_start_sound);
				}
			}
		}
		else if sprite == charge_loop_sprite {
			if check_charge() {
				aura_sprite = charge_aura;
				mp += max(1,round(mp_stock_size / 60));
				if mp >= max_mp {
					aura_sprite = transform_aura;
					xp += max(1,round(max_xp / (5 * 60)));
					if xp >= max_xp {
						auto_levelup();
					}
				}
			
				loop_sound(charge_loop_sound);
			
				shake_screen(5,2);
			}
			else {
				change_sprite(charge_stop_sprite,3,false);
				stop_sound(sound);
				stop_sound(voice);
				if charge_stop_sound != noone {
					flash_sprite();
					play_sound(charge_stop_sound);
				}
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
		stop_sound(sound);
		stop_sound(voice);
	}
	
	intro_state = new state();
	intro_state.start = function() {
		change_sprite(idle_sprite,6,true);
		play_voiceline(voice_intro);
	}
	intro_state.run = function() {
		if !audio_is_playing(voice) and anim_finished {
			change_state(idle_state);
		}
	}
	
	enter_state = new state();
	enter_state.start = function() {
		change_sprite(air_down_sprite,3,true);
	}
	enter_state.run = function() {
		if sprite == air_down_sprite {
			if on_ground {
				yspeed = 0;
				change_sprite(crouch_sprite,3,false);
			}
		}
		else if sprite == crouch_sprite {
			if state_timer > 80 {
				change_sprite(uncrouch_sprite,3,false);
			}
		}
		else if sprite == uncrouch_sprite {
			if anim_finished {
				change_state(intro_state);
			}
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
	
	init_states(idle_state);
	
	signature_move = noone;
	finisher_move = noone;
}

function return_to_idle() {
	if anim_finished {
		change_state(idle_state);
	}
}

function land() {
	if on_ground and (yspeed > 0) {
		var stretch = 1.2;
		var squash = 0.8;
		change_state(idle_state);
		squash_stretch(stretch,squash);
		return true;
	}
	return false;
}

function substitution_teleport() {
	var _dist = 100;
	teleport(target_x + (_dist * facing),target_y - 30);
}