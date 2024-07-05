// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function init_charstates() {
	idle_state = new state();
	idle_state.start = function() {
		if on_ground {
			change_sprite(idle_sprite,6,true);
			face_target();
			reset_cancels();
			yspeed = 0;
			air_moves = 0;
		}
		else {
			change_state(air_state);
		}
		can_block = true;
		can_cancel = true;
		is_hit = false;
		is_blocking = false;
	}
	idle_state.run = function() {
		can_block = true;
		can_cancel = true;
		face_target();
		var walk_anim_speed = round(map_value(sprite_get_number(walk_sprite),4,8,6,3));
		if input_forward {
			change_sprite(walk_sprite,walk_anim_speed,true);
			accelerate(walk_speed * facing);
			xscale = abs(xscale);
		}
		else if input_back {
			change_sprite(walk_sprite,walk_anim_speed,true);
			accelerate(walk_speed * -facing);
			xscale = -abs(xscale);
		}
		else {
			change_sprite(idle_sprite,6,true);
		}
		if input_up {
			change_state(jump_state);
		}
		else if input_down {
			change_state(crouch_state);
		}
		check_moves();
		//if input_c {
		//	if target_distance_x <= 15 {
		//		grab_connect_state = back_throw;
		//		if input_forward {
		//			grab_connect_state = forward_throw;
		//		}
		//		init_grab(id,target);
		//	}
		//}
	}

	crouch_state = new state();
	crouch_state.start = function() {
		change_sprite(crouch_sprite,3,false);
		face_target();
		reset_cancels();
		yspeed = 0;
		air_moves = 0;
		can_block = true;
		can_cancel = true;
	}
	crouch_state.run = function() {
		can_block = true;
		can_cancel = true;
		face_target();
		if input_down {
			if sprite != crouch_sprite {
				change_sprite(crouch_sprite,3,false);
			}
		}
		else {
			if sprite != uncrouch_sprite {
				change_sprite(uncrouch_sprite,3,false);
			}
			if anim_finished {
				change_state(idle_state);
			}
		}
		if input_up {
			change_state(superjump_state);
		}
		check_moves();
	}

	jump_state = new state();
	jump_state.start = function() {
		change_sprite(crouch_sprite,1,false);
		squash_stretch(1.25,0.75);
		face_target();
		reset_cancels();
		xspeed = 0;
		yspeed = 0;
		air_moves = 0;
		can_block = true;
		can_cancel = true;
	}
	jump_state.run = function() {
		can_block = true;
		can_cancel = true;
		if anim_finished {
			change_state(air_state);
			squash_stretch(0.75,1.25);
			yspeed = -jump_speed;
			xspeed = walk_speed * sign(input_right - input_left);
			play_sound(snd_jump);
		}
		check_moves();
	}

	superjump_state = new state();
	superjump_state.start = function() {
		change_sprite(crouch_sprite,1,false);
		squash_stretch(1.25,0.75);
		reset_cancels();
		xspeed = 0;
		yspeed = 0;
		air_moves = 0;
		can_block = true;
		can_cancel = true;
	}
	superjump_state.run = function() {
		can_block = true;
		can_cancel = true;
		if anim_finished {
			change_state(air_state);
			squash_stretch(0.75,1.25);
			yspeed = -jump_speed * 1.5;
			xspeed = walk_speed * sign(input_right - input_left);
			play_sound(snd_jump,1,0.9);
		}
	}

	air_state = new state();
	air_state.start = function() {
		change_sprite(air_peak_sprite,5,true);
		reset_cancels();
		can_block = true;
		can_cancel = true;
	}
	air_state.run = function() {
		can_block = true;
		can_cancel = true;
		if input_up {
			if yspeed >= 0 {
				if air_moves < max_air_moves {
					xspeed = walk_speed * sign(input_right - input_left);
					yspeed = -jump_speed * 0.75;
					air_moves += 1;
					squash_stretch(0.75,1.25);
					play_sound(snd_airjump);
				}
			}
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
			xspeed = dash_speed * facing;
			yspeed = 0;
			play_sound(snd_dash);
			play_sound(snd_dash_loop);
			play_voiceline(voice_chase,20,false);
		}
	}
	dash_state.run = function() {
		xspeed = dash_speed * facing;
		yspeed = 0;
		var dash_duration = 15;
		if input_forward {
			if target.is_airborne or (target.on_ground and target_distance_x > 20)
			dash_duration *= 4;
		}
		if state_timer < dash_duration {
			if !audio_is_playing(snd_dash_loop) {
				play_sound(snd_dash_loop);
			}
		}
		else {
			change_state(dash_stop_state);
		}
		if input_up {
			yspeed = -5;
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
			audio_stop_sound(sound);
		}
	}
	
	backdash_state = new state();
	backdash_state.start = function() {
		if is_airborne {
			change_state(air_backdash_state);
		}
		else {
			change_sprite(air_up_sprite,2,true);
			xspeed = dash_speed * -facing;
			yspeed = -1.5;
			play_sound(snd_dash);
			play_voiceline(voice_retreat,20,false);
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
		if xspeed == 0 {
			change_state(idle_state);
		}
	}
	
	airdash_state = new state();
	airdash_state.start = function() {
		if air_moves < max_air_moves {
			change_sprite(dash_sprite,2,true);
			yoffset = -height_half;
			xspeed = dash_speed * facing;
			yspeed = 0;
			air_moves += 1;
			play_sound(snd_dash);
			play_voiceline(voice_chase,20,false);
		}
		else {
			change_state(air_state);
		}
	}
	airdash_state.run = function() {
		xspeed = dash_speed * facing;
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
			xspeed = dash_speed * -facing;
			yspeed = 0;
			air_moves += 1;
			play_sound(snd_dash);
			play_voiceline(voice_retreat,20,false);
		}
		else {
			change_state(air_state);
		}
	}
	air_backdash_state.run = function() {
		xspeed = dash_speed * -facing;
		yspeed = 0;
		if state_timer >= 15 {
			change_state(air_state);
		}
	}
	
	block_state = new state();
	block_state.start = function() {
		change_sprite(guard_sprite,6,false);
		reset_cancels();
		is_blocking = true;
		can_block = true;
	}
	block_state.run = function() {
		is_blocking = true;
		can_block = true;
		if state_timer < blockstun - anim_duration {
			frame = 0;
			frame_timer = 0;
		}
		if state_timer >= blockstun {
			change_state(idle_state);
		}
	}
	block_state.stop = function() {
		is_blocking = false;
	}
	
	hit_state = new state();
	hit_state.start = function() {
		reset_cancels();
		is_hit = true;
		can_block = false;
	}
	hit_state.run = function() {
		is_hit = true;
		can_block = false;
		if hp > 0 {
			if on_ground {
				if yspeed > 0 {
					change_state(tech_state);
					reset_combo();
				}
			}
			if state_timer >= hitstun {
				if on_ground {
					change_state(idle_state);
				}
				else {
					change_state(tech_state);
				}
				reset_combo();
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
		can_block = false;
	}
	hard_knockdown_state.run = function() {
		if on_ground {
			change_state(liedown_state);
			play_voiceline(voice_hurt,50,true);
			reset_combo();
		}
	}
	
	wall_bounce_state = new state();
	wall_bounce_state.start = function() {
		reset_cancels();
		is_hit = true;
		can_block = false;
	}
	wall_bounce_state.run = function() {
		if yspeed >= 0 {
			yspeed = 0;
		}
		if on_ground {
			y -= 1;
		}
		if on_wall {
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
					if anim_finished {
						change_state(idle_state);
					}
				}
				else {
					dead = true;
					is_hit = false;
				}
			}
			else {
				change_sprite(liedown_sprite,2,false);
			}
		}
		else {
			change_sprite(hurt_sprite,3,false);
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
		xspeed = 5 * sign(input_right - input_left);
		yspeed = -3;
		dodging_attacks = true;
		dodging_projectiles = true;
		combo_hits_taken = 0;
		combo_damage_taken = 0;
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
		play_voiceline(voice_chase,50,false);
	}
	homing_dash_state.run = function() {
		var _speed = 12;
		var _direction = point_direction(x,y,target.x-(width_half*facing),target.y);
		var _xspeed = lengthdir_x(_speed,_direction);
		var _yspeed = lengthdir_y(_speed,_direction);
		face_target();
		xspeed = approach(xspeed,_xspeed,2);
		yspeed = approach(yspeed,_yspeed,2);
		rotation = point_direction(0,0,abs(xspeed),yspeed);
		var stop_distance = width;
		if previous_state == tag_out_state {
			stop_distance *= 2;
			can_block = true;
			can_cancel = true;
			check_moves();
		}
		if target_distance < stop_distance {
			xspeed = 3 * facing;
			yspeed = -3;
			change_state(air_state);
		}
	}
	
	intro_state = new state();
	intro_state.start = function() {
		change_sprite(chant_sprite,10,true);
		play_voiceline(voice_intro);
	}
	intro_state.run = function() {
		if !audio_is_playing(voice) 
		and anim_finished 
		and state_timer > 120 {
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
	
	add_move(dash_state,"656");
	add_move(backdash_state,"454");
	
	add_move(dash_state,"956");
	add_move(backdash_state,"754");
	
	init_states(idle_state);
}

function land() {
	if on_ground and (yspeed > 0) {
		var stretch = map_value(yspeed,0,8,1,1.25);
		var squash = map_value(yspeed,0,8,1,0.75);
		change_state(idle_state);
		squash_stretch(stretch,squash);
	}
}

function get_hit(_attacker, _damage, _xknockback, _yknockback, _attacktype, _hiteffect, _hitanim) {
	var _xspeed = xspeed;
	var _yspeed = yspeed;
	xspeed = _xknockback * _attacker.facing;
	yspeed = _yknockback;
	switch(_attacktype) {
		case attacktype.light:
		hitstun = 15;
		blockstun = 12;
		hitstop = 8;
		break;
		
		case attacktype.medium:
		case attacktype.antiair:
		case attacktype.unblockable:
		hitstun = 20;
		blockstun = 18;
		hitstop = 10;
		break;
		
		case attacktype.heavy:
		case attacktype.hard_knockdown:
		hitstun = 25;
		blockstun = 20;
		hitstop = 12;
		break
		
		case attacktype.ground_bounce:
		case attacktype.launcher:
		case attacktype.slide_knockdown:
		case attacktype.smash:
		case attacktype.wall_bounce:
		case attacktype.wall_splat:
		hitstun = 60;
		blockstun = 20;
		hitstop = 20;
		break;
		
		case attacktype.beam:
		hitstun = 60;
		blockstun = 20;
		hitstop = 0;
		xspeed = abs(_attacker.xspeed);
		yspeed = _attacker.yspeed - 3;
		break;
	}
			
	var blocking =	((input_back or input_down)
					or ((ai_enabled) and (irandom(100) <= map_value(ai_level,1,ai_level_max,10,90)))
					or (is_blocking));
	var block_valid = (can_block) and (!is_hit);
	if _attacktype == attacktype.unblockable
	or _attacktype == attacktype.grab {
		block_valid = false;
	}
	if _attacktype == attacktype.antiair
	and is_airborne {
		block_valid = false;
	}
	if block_valid and blocking {
		change_state(block_state);
		change_sprite(guard_sprite,6,false);
		xspeed *= 2;
		//yspeed /= 2;
		yspeed = _yspeed;
		if on_ground {
			yspeed = 0;
		}
	}
	else {
		var connect = true;
		if invincible {
			connect = false;
		}
		if _attacker.object_index == obj_shot or object_is_ancestor(_attacker.object_index,obj_shot) {
			if immune_to_projectiles {
				connect = false;
			}
		}
		if connect {
			switch(_attacktype) {
				default:
				change_state(hit_state);
				if on_ground and _yknockback >= 0 {
					yspeed = 0;
				}
				else if is_airborne and _yknockback == 0 {
					yspeed = -abs(xspeed) / 2;
				}
				break;
									
				case attacktype.wall_bounce:
				if previous_state != wall_bounce_state {
					change_state(wall_bounce_state);
				}
				else {
					change_state(hit_state);
				}
				break;
									
				case attacktype.hard_knockdown:
				case attacktype.wall_splat:
				case attacktype.smash:
				change_state(hard_knockdown_state);
				break;
									
				case attacktype.slide_knockdown:
				change_state(slide_knockdown_state);
				break;
									
				case attacktype.grab:
				case attacktype.hit_grab:
				with(_attacker) {
					init_grab(id,other);
				}
				break;
			}
			change_sprite(hurt_sprite,3,false);
			if _hitanim == hitanims.spinout {
				change_sprite(spinout_sprite,3,true);
				yoffset = -height_half;
			}
			else if (abs(xspeed) >= 10) or (abs(yspeed) >= 10) {
				change_sprite(launch_sprite,3,true);
				yoffset = -height_half;
			}
			if on_wall and on_ground {
				if object_is_ancestor(_attacker.object_index,obj_char) {
					_attacker.xspeed = xspeed * -0.5;
				}
			}
			
			var _hp = hp;
			var dmg = take_damage(_attacker,_damage,!grabbed);
			
			combo_hits_taken++;
			combo_damage_taken += dmg;
			if team == 1 {
				p2_combo_hits++;
				p2_combo_damage += dmg;
				p2_combo_timer = hitstun + 10;
			}
			else {
				p1_combo_hits++;
				p1_combo_damage += dmg;
				p1_combo_timer = hitstun + 10;
			}
			
			if _attacker.object_index == obj_shot or object_is_ancestor(_attacker.object_index,obj_shot) {
				with(_attacker.owner) {
					combo_hits++;
					combo_damage += dmg;
				}
			}
			else {
				with(_attacker) {
					combo_hits++;
					combo_damage += dmg;
				}
			}
			
			if (_hp > 0) {
				if (hp > 0) {
					var _heavyattack_speed = 10;
					var is_heavyattack = ((abs(xspeed) >= _heavyattack_speed) or (abs(yspeed) >= _heavyattack_speed));
					if on_ground and (yspeed > -10) {
						is_heavyattack = false;
					}
					if is_heavyattack {
						play_voiceline(voice_hurt_heavy,50,true);
					}
					else {
						play_voiceline(voice_hurt,50,true);
					}
				}
				else {
					play_voiceline(voice_dead,100,true);
				}
			}
			
			frame = 0;
			frame_timer = 0;
			facing = -_attacker.facing;
		}
		else {
			xspeed = _xspeed;
			yspeed = _yspeed;
		}
	}
	var mp_gain = _damage;
	var attack_mp_multiplier = 2;
	var defend_mp_multiplier = 1;
	if block_valid {
		mp_gain *= 0.5;
	}
	if team == 1 {
		p1_mp += mp_gain * defend_mp_multiplier;
		if !p2_super_active {
			p2_mp += mp_gain * attack_mp_multiplier;
		}
	}
	else {
		p2_mp += mp_gain * defend_mp_multiplier;
		if !p1_super_active {
			p1_mp += mp_gain * attack_mp_multiplier;
		}
	}
	
	depth = 0;
	_attacker.depth = -1;
	_attacker.hitstop = hitstop;
	_attacker.can_cancel = true;
	create_hitspark(x-width_half,y-(height*0.75),x+width_half,y-(height*0.25),_attacktype,_hiteffect,block_valid && blocking);
}

function init_clash(_char1, _char2) {
	
}

function take_damage(_attacker,_amount,_kill) {
	var dmg = round(_amount);
	
	if object_is_ancestor(_attacker.object_index,obj_char) {
		dmg *= _attacker.attack_power;
	}
	else {
		dmg *= _attacker.owner.attack_power;
	}
	
	dmg /= defense;
	
	var scaling = map_value(combo_damage_taken,0,max_hp*0.25,1,0);
	if id != p1_active_character
	and id != p2_active_character {
		scaling *= 2;
	}
	scaling = clamp(scaling,0.1,1);
	dmg *= scaling;
	
	dmg *= map_value(max_team_size,1,3,0.25,1);
	
	dmg = max(ceil(dmg),1);
	
	hp -= dmg;
	
	if !_kill {
		hp = max(hp,1);
	}
	return dmg;
}

function reset_combo() {
	combo_hits = 0;
	combo_damage = 0;
	combo_hits_taken = 0;
	combo_damage_taken = 0;
}