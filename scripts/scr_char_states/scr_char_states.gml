// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function init_charstates() {
	idle_state = new charstate();
	idle_state.start = function() {
		face_target();
		reset_cancels();
		can_guard = true;
		can_cancel = true;
		is_hit = false;
		is_guarding = false;
		
		if on_ground {
			change_sprite(idle_sprite,true);
			xspeed = 0;
			yspeed = 0;
			air_actions = 0;
		}
		else {
			change_state(air_state);
		}
	}
	idle_state.run = function() {
		face_target();
		
		if round_state == roundstates.fight {
			can_cancel = true;
			
			if check_charge() {
				change_state(charge_state);
			}
			else if input.down {
				change_state(crouch_state);
			}
			else {
				if sign(input.right-input.left) != 0 {
					xspeed = move_speed * move_speed_mod * move_speed_buff * sign(input.right - input.left);
					change_sprite(walk_sprite,true);
					xscale = abs(xscale) * sign(input.right-input.left) * facing;
					
				}
				else {
					change_sprite(idle_sprite,true);
				}
			}
		}
		else {
			change_sprite(idle_sprite,true);
		}
	}

	crouch_state = new charstate();
	crouch_state.start = function() {
		change_sprite(crouch_sprite,false);
		face_target();
	}
	crouch_state.run = function() {
		face_target();
		if input.down {
			if sprite != crouch_sprite {
				change_sprite(crouch_sprite,false);
			}
		}
		else {
			if sprite != uncrouch_sprite {
				change_sprite(uncrouch_sprite,false);
			}
			anim_finish_idle();
		}
	}

	jump_state = new charstate();
	jump_state.start = function() {
		change_sprite(jumpsquat_sprite,false);
		squash_stretch(1.2,0.8);
		face_target();
	}
	jump_state.run = function() {
		if (state_timer > 3) {
			change_state(air_state);
			squash_stretch(0.8,1.2);
			yspeed = -jump_speed;
			xspeed = move_speed * move_speed_mod * move_speed_buff * sign(input.right - input.left);
			play_sound(snd_dbz_jump);
		}
	}

	superjump_state = new charstate();
	superjump_state.start = function() {
		change_sprite(jumpsquat_sprite,false);
		squash_stretch(1.25,0.75);
		face_target();
	}
	superjump_state.run = function() {
		if (state_timer > 3) {
			change_state(air_state);
			squash_stretch(0.75,1.25);
			yspeed = -jump_speed * 1.5;
			xspeed = move_speed * move_speed_mod * move_speed_buff * sign(input.right - input.left);
			play_sound(snd_dbz_jump,1,0.8);
		}
	}

	air_state = new charstate();
	air_state.start = function() {
		change_sprite(air_peak_sprite,true);
		can_guard = true;
		can_cancel = true;
		is_hit = false;
		is_guarding = false;
		face_target();
		if land() {
			exit;
		}
	}
	air_state.run = function() {
		if land() {
			exit;
		}
		face_target();
		
		var peak_speed = 2;
		if value_in_range(yspeed,-peak_speed,peak_speed) {
			change_sprite(air_peak_sprite,true);
		}
		else if yspeed < 0 {
			change_sprite(air_up_sprite,true);
		}
		else {
			change_sprite(air_down_sprite,true);
		}
	}
	
	airjump_state = new charstate();
	airjump_state.start = function() {
		if air_actions < max_air_actions {
			xspeed = move_speed * move_speed_mod * move_speed_buff * sign(input.right - input.left);
			yspeed = -jump_speed * 0.75;
			air_actions += 1;
			squash_stretch(0.8,1.2);
			play_sound(snd_dbz_jump_air);
		}
		change_state(air_state);
	}
	
	dash_state = new charstate();
	dash_state.start = function() {
		change_sprite(dash_sprite,true);
		yoffset = -height_half;
		xspeed = move_speed * move_speed_mod * move_speed_buff * 2 * facing;
		yspeed = 0;
		play_sound(snd_dbz_dash);
		play_sound(snd_dbz_dash_loop);
		if sprite_get_yoffset(walk_sprite) <= sprite_get_height(walk_sprite) {
			change_sprite(walk_sprite,true);
		}
	}
	dash_state.run = function() {
		can_cancel = true;
		var dash_duration = 10;
		if ((!ai_enabled) and (input.forward)) 
		or ((ai_enabled) and (target_distance_x > 10)){
			dash_duration = 60;
		}
		if state_timer mod 5 == 1 {
			create_specialeffect(spr_dust_dash,x,y,facing * 0.5,0.5);
		}
		
		if state_timer <= dash_duration {
			xspeed = move_speed * move_speed_mod * move_speed_buff * 2 * facing;
			yspeed = 0;
			if sprite == dash_sprite {
				loop_sound(snd_dbz_dash_loop);
			}
			if input.up {
				yspeed = -jump_speed/2;
				change_state(air_state);
				play_sound(snd_dbz_jump);
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
	
	backdash_state = new charstate();
	backdash_state.start = function() {
		change_sprite(air_peak_sprite,true);
		can_cancel = false;
		jump_towards(x - (100 * facing), y, 10);
		dodging_attacks = true;
		dodging_projectiles = true;
		play_sound(snd_dbz_dash);
		create_specialeffect(spr_dust_dash,x,y,-facing * 0.5,0.5);
	}
	backdash_state.run = function() {
		can_cancel = false;
		if on_ground and yspeed > 0 {
			change_state(dash_stop_state);
		}
	}
	backdash_state.stop = function() {
		dodging_attacks = false;
		dodging_projectiles = false;
	}
	
	dash_stop_state = new charstate();
	dash_stop_state.start = function() {
		can_cancel = false;
		change_sprite(uncrouch_sprite,false);
	}
	dash_stop_state.run = function() {
		can_cancel = false;
		decelerate();
		if (state_timer > 10) {
			change_state(idle_state);
		}
	}
	
	airdash_state = new charstate();
	airdash_state.start = function() {
		if air_actions < max_air_actions {
			change_sprite(dash_sprite,true);
			yoffset = -height_half;
			xspeed = move_speed * move_speed_mod * move_speed_buff * 2 * facing;
			yspeed = 0;
			air_actions += 1;
			play_sound(snd_dbz_dash);
		}
		else {
			change_state(air_state);
		}
	}
	airdash_state.run = function() {
		xspeed = move_speed * move_speed_mod * move_speed_buff * 2 * facing;
		yspeed = 0;
		if state_timer >= 10 {
			xspeed = base_movespeed / 2 * facing;
			change_state(air_state);
		}
	}
	
	air_backdash_state = new charstate();
	air_backdash_state.start = function() {
		if air_actions < max_air_actions {
			change_sprite(dash_sprite,true);
			yoffset = -height_half;
			xscale = -1;
			xspeed = move_speed * move_speed_mod * move_speed_buff * 2 * -facing;
			yspeed = 0;
			air_actions += 1;
			play_sound(snd_dbz_dash);
		}
		else {
			change_state(air_state);
		}
	}
	air_backdash_state.run = function() {
		xspeed = -move_speed * move_speed_mod * move_speed_buff * 2 * facing;
		yspeed = 0;
		if state_timer >= 10 {
			xspeed = base_movespeed / 2 * -facing;
			change_state(air_state);
		}
	}
	
	guard_state = new charstate();
	guard_state.start = function() {
		change_sprite(guard_sprite,false);
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
	
	hit_state = new charstate();
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
		
		if ((xspeed < 0) and (on_left_wall)) {
			if (xspeed <= -10) {
				create_particles(
					x - width_half,
					y - height_half,
					wall_bang_left_particle
				);
			}
			xspeed = 0;
		}
		if ((xspeed > 0) and (on_right_wall)) {
			if (xspeed >= 10) {
				create_particles(
					x + width_half,
					y - height_half,
					wall_bang_right_particle
				);
			}
			xspeed = 0;
		}
		
		if (!dead) {
			if state_timer >= hitstun {
				if on_ground {
					change_state(idle_state);
				}
				else {
					change_state(tech_state);
				}
			}
			if (on_ground and (yspeed > 0)) {
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
	hit_state.stop = function() {
		is_hit = false;
	}
	
	grabbed_state = new charstate();
	grabbed_state.start = function() {
		change_sprite(hit_high_sprite,false);
		xspeed = 0;
		yspeed = 0;
		can_cancel = false;
	}
	grabbed_state.run = function() {
		xspeed = 0;
		yspeed = 0;
		can_cancel = false;
		anim_speed = 0;
	}
	
	hard_knockdown_state = new charstate();
	hard_knockdown_state.start = function() {
		is_hit = true;
		can_guard = false;
		can_cancel = false;
	}
	hard_knockdown_state.run = function() {
		if (yspeed > 0) {
			if is_airborne {
				change_sprite(launch_sprite,true);
				yoffset = -height_half;
			}
			else {
				if yspeed > 3 {
					change_sprite(hit_air_sprite,false);
					frame = anim_frames - 2;
				
					if yspeed >= 15 {
						take_damage(noone,abs(yspeed),false);
						create_particles(x,y,floor_bang_particle,1);
					}
					yspeed *= -0.25;
				
					xspeed /= 2;
					
					play_voiceline(voice_hurt,20,false);
				}
				else {
					yspeed = 0;
					change_state(liedown_state);
				}
			}
		}
	}
	
	wall_splat_state = new charstate();
	wall_splat_state.start = function() {
		hit_state.start();
	}
	wall_splat_state.run = function() {
		if ((xspeed < 0) and (on_left_wall)) {
			xspeed = 0;
			create_particles(
				x-width_half,
				y-height_half,
				wall_bang_left_particle
			);
		}
		if ((xspeed > 0) and (on_right_wall)) {
			xspeed = 0;
			create_particles(
				x + width_half,
				y-height_half,
				wall_bang_right_particle
			);
		}
		hit_state.run();
	}
	
	wall_bounce_state = new charstate();
	wall_bounce_state.start = function() {
		change_sprite(launch_sprite,true);
		is_hit = true;
		can_guard = false;
		can_cancel = false;
	}
	wall_bounce_state.run = function() {
		var _x = sign(xspeed);
		xspeed = max(30,abs(xspeed)) * _x;
		if state_timer mod ceil(width / max(1,abs(xspeed))) == 0 {
			create_specialeffect(
				spr_wind_spin,
				x,
				y-height_half,
				1,
				1,
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
					wall_bang_left_particle
				);
			}
			else {
				create_particles(
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
	
	liedown_state = new charstate();
	liedown_state.start = function() {
		change_sprite(liedown_sprite,false);
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
				change_sprite(wakeup_sprite,false);
			}
			anim_finish_idle();
		}
		else {
			change_sprite(liedown_sprite,true);
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
	
	tech_state = new charstate();
	tech_state.start = function() {
		change_sprite(tech_sprite,false);
		flash_sprite();
		yoffset = -height_half;
		xspeed = 5 * sign(input.right - input.left);
		yspeed = -3;
		rotation_speed = (sign(xspeed) == facing) ? -30 : 30;
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
	
	homing_dash_state = new charstate();
	homing_dash_state.start = function() {
		change_sprite(dash_sprite,true);
		yoffset = -height_half;
		xspeed = 0;
		yspeed = 0;
		can_guard = true;
		can_cancel = false;
	}
	homing_dash_state.run = function() {
		if !target_exists() {
			change_state(idle_state);
			exit;
		}
		var _my_x = x + (width_half * facing);
		var _my_y = y - height_half;
		var _target_x = target.x - ((target.width_half - 1) * facing);
		var _target_y = target.y - target.height_half;
		
		if target_distance_y > target_distance_x {
			_target_x = _my_x;
		}
		
		var _direction = point_direction(_my_x,_my_y,_target_x,_target_y);
		var _distance = point_distance(_my_x,_my_y,_target_x,_target_y);
		
		var _speed = 30;
		var _xspeed = lengthdir_x(_speed,_direction);
		var _yspeed = lengthdir_y(_speed,_direction);
		
		face_target();
		basic_attack(frame,10,attackstrength.light,hiteffects.hit);
		
		xspeed = approach(xspeed,_xspeed,2);
		yspeed = approach(yspeed,_yspeed,2);
		rotation = point_direction(0,0,abs(xspeed),yspeed);
		
		if (attack_hits > 0) or (state_timer > 100) {
			xspeed = 3 * facing;
			yspeed = -3;
			change_state(air_state);
		}
	}
	
	substitution_state = new charstate();
	substitution_state.start = function() {
		change_sprite(crouch_sprite,false);
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
				change_sprite(uncrouch_sprite,false);
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
	
	teleport_state = new charstate();
	teleport_state.start = function() {
		if check_tp(1) {
			spend_tp(1);
			change_sprite(crouch_sprite,false);
			reset_sprite();
			timestop();
			play_sound(snd_dbz_teleport);
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
				change_sprite(uncrouch_sprite,false);
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
	
	levelup_state = new charstate();
	levelup_state.start = function() {
		change_sprite(charge_loop_sprite,true);
		flash_sprite();
		aura_sprite = transform_aura;
		superfreeze(120);
		shake_screen(superfreeze_timer,1);
		play_sound(snd_dbz_energy_start);
		can_cancel = false;
		level_up();
	}
	levelup_state.run = function() {
		xspeed = 0;
		yspeed = 0;
		can_cancel = false;
		if !superfreeze_active {
			aura_sprite = noone;
			change_state(idle_state);
		}
	}
	
	levelup_transform_state = new charstate();
	levelup_transform_state.start = function() {
		change_sprite(charge_loop_sprite,true);
		superfreeze(audio_sound_length(voice) * 30);
		shake_screen(superfreeze_timer,1);
		aura_sprite = transform_aura;
		can_cancel = false;
	}
	levelup_transform_state.run = function() {
		xspeed = 0;
		yspeed = 0;
		can_cancel = false;
		loop_sound(snd_dbz_energy_loop);
		if superfreeze_timer <= 1 {
			transform(next_form);
			flash_sprite();
			play_sound(snd_dbz_energy_start);
			change_state(levelup_transform_finish_state);
		}
	}
	
	levelup_transform_finish_state = new charstate();
	levelup_transform_finish_state.start = function() {
		change_sprite(charge_loop_sprite,true);
		flash_sprite();
		aura_sprite = transform_aura;
		superfreeze(120);
		shake_screen(superfreeze_timer,1);
		play_sound(snd_dbz_energy_start);
		can_cancel = false;
		
		level_up();
	}
	levelup_transform_finish_state.run = function() {
		xspeed = 0;
		yspeed = 0;
		can_cancel = false;
		if !superfreeze_active {
			aura_sprite = noone;
			change_state(idle_state);
		}
	}
	
	transform_redo_state = new charstate();
	
	transform_undo_state = new charstate();
	
	charge_state = new charstate();
	charge_state.start = function() {
		if check_charge() {
			change_sprite(charge_start_sprite,false);
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
				change_sprite(charge_loop_sprite,true);
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
				mp += (mp_stock_size / (60*1)) * (state_timer / (60*1));
				if mp >= max_mp {
					aura_sprite = transform_aura;
					xp += (max_xp / (60*10)) * (state_timer / (60*1));
					if xp >= max_xp {
						auto_levelup();
					}
				}
			
				loop_sound(charge_loop_sound);
				
				if screen_shake_timer <= 1 {
					shake_screen(5,1);
				}
			}
			else {
				change_sprite(charge_stop_sprite,false);
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
	
	intro_state = new charstate();
	intro_state.start = function() {
		change_sprite(idle_sprite,true);
		play_voiceline(voice_intro);
	}
	intro_state.run = function() {
		if !audio_is_playing(voice) and anim_finished {
			change_state(idle_state);
		}
	}
	
	enter_state = new charstate();
	enter_state.start = function() {
		change_sprite(air_down_sprite,true);
	}
	enter_state.run = function() {
		if sprite == air_down_sprite {
			if on_ground {
				yspeed = 0;
				change_sprite(crouch_sprite,false);
			}
		}
		else if sprite == crouch_sprite {
			if state_timer > 80 {
				change_sprite(uncrouch_sprite,false);
			}
		}
		else if sprite == uncrouch_sprite {
			if anim_finished {
				change_state(intro_state);
			}
		}
	}
	
	victory_state = new charstate();
	victory_state.start = function() {
		change_sprite(victory_sprite,false);
		play_voiceline(voice_victory);
	}
	defeat_state = new charstate();
	defeat_state.start = function() {
		change_sprite(defeat_sprite,false);
		play_voiceline(voice_defeat);
	}
	
	light_attack = new charstate();
	
	light_attack2 = new charstate();
	
	light_attack3 = new charstate();
	
	medium_attack = new charstate();
	
	medium_attack2 = new charstate();
	medium_attack2.start = function() {
		medium_lowattack.start();
	}
	medium_attack2.run = function() {
		medium_lowattack.run();
	}
	
	medium_attack3 = new charstate();
	medium_attack3.start = function() {
		medium_attack.start();
	}
	medium_attack3.run = function() {
		medium_attack.run();
	}
	
	medium_attack4 = new charstate();
	medium_attack4.start = function() {
		signature_move.start();
		
		if active_state != medium_attack4 {
			change_state(backdash_state);
		}
	}
	medium_attack4.run = function() {
		signature_move.run();
	}
	
	heavy_attack = new charstate();
	
	light_lowattack = new charstate();
	medium_lowattack = new charstate();
	heavy_lowattack = new charstate();
	
	light_airattack = new charstate();
	
	light_airattack2 = new charstate();
	light_airattack2.start = function() {
		medium_airattack.start();
	}
	light_airattack2.run = function() {
		medium_airattack.run();
	}
	
	light_airattack3 = new charstate();
	light_airattack3.start = function() {
		heavy_airattack.start();
	}
	light_airattack3.run = function() {
		heavy_airattack.run();
	}
	
	medium_airattack = new charstate();
	
	heavy_airattack = new charstate();
	
	init_states(idle_state);
	
	signature_move = noone;
	finisher_move = noone;
}

function update_charstate() {
	update_state();
}

function return_to_idle() {
	change_state(idle_state);
}

function anim_finish_idle() {
	if anim_finished {
		return_to_idle();
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