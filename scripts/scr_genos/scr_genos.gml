function init_genos_baseform() {
	init_charsprites("genos");
	
	init_charaudio("genos");

	name = "genos";
	display_name = "Genos";
	theme = mus_opm_genos;
	universe = universes.onepunchman;
	voice_volume_mine = 4;

	move_speed_mod = 1.25;
	max_air_actions = 3;

	dropkick_cooldown = 0;
	dropkick_cooldown_duration = 100;

	incinerate_cooldown = 0;
	incinerate_cooldown_duration = 150;

	char_script = function() {
		incinerate_cooldown -= 1;
		dropkick_cooldown -= 1;
	}
	
	//ai_script = function() {
	//	if target_distance < 100 {
	//		ai_input_move(dropkick,10);
	//	}
	//	else if target_distance > 200 {
	//		ai_input_move(fireblast,10);
	//		ai_input_move(incinerate,10);
	//		ai_input_move(super_incinerate,10);
	//	}
	//}
	
	add_basic_light_attack_state(spr_genos_attack_punch,2,hiteffects.hit);
	add_basic_light_attack2_state(spr_genos_attack_kick,2,hiteffects.hit);
	add_basic_light_attack3_state(spr_genos_attack_uppercut,2,hiteffects.hit);
	
	add_basic_medium_attack_state(spr_genos_attack_uppercut,2,hiteffects.hit);
	add_basic_heavy_attack_state(spr_genos_attack_kick,2,hiteffects.hit);
	
	add_basic_light_lowattack_state(spr_genos_attack_punch,2,hiteffects.hit);
	add_basic_medium_lowattack_state(spr_genos_attack_kick_up,2,hiteffects.hit);
	add_basic_heavy_lowattack_state(spr_genos_attack_uppercut,2,hiteffects.hit);
	
	add_basic_light_airattack_state(spr_genos_attack_punch,2,hiteffects.hit);
	add_basic_medium_airattack_state(spr_genos_attack_kick,2,hiteffects.hit);
	add_basic_heavy_airattack_state(spr_genos_attack_smash,2,hiteffects.hit);
	
	add_basic_heavy_air_launcher_state(spr_genos_attack_kick_up,2,hiteffects.hit);

	fireblast = new charstate();
	fireblast.start = function() {
		if attempt_special(1/2) {
			change_sprite(spr_genos_special_blast,false);
		}
	}
	fireblast.run = function() {
		if check_frame(2) {
			var _shots = 1 + level;
			for(var i = 0; i < _shots; i++) {
				with(create_shot(
					20,
					-35,
					20 + i,
					((-_shots / 2) + i),
					spr_glow_orange,
					0.25,
					80,
					3,
					-3,
					attacktype.normal,
					attackstrength.light,
					hiteffects.fire
				)) {
					blend = true;
					hit_script = function() {
						create_particles(x,y,explosion_small_particle);
					}
					active_script = function() {
						if y >= ground_height {
							hit_script();
							instance_destroy();
						}
					}
					play_sound(snd_dbz_kiblast_fire);
				}
			}
			if is_airborne {
				xspeed = -2 * facing;
				yspeed = -2;
			}
		}
		if state_timer > 50 {
			anim_finish_idle();
		}
	}

	dropkick = new charstate();
	dropkick.start = function() {
		if attempt_special(1/2,(!dropkick_cooldown)) {
			change_sprite(spr_genos_special_dropkick,false);
			dropkick_cooldown = dropkick_cooldown_duration;
			xspeed = (10 + (level * 3)) * facing;
			yspeed = -20;
		}
		else {
			change_state(idle_state);
		}
	}
	dropkick.run = function() {
		if xspeed != 0 {
			if target_distance_x < abs(xspeed) {
				x = target_x-facing;
				xspeed = 0;
			}
		}
		if check_frame(4) {
			play_sound(snd_punch_whiff_ultimate);
		}
		if check_frame(6) {
			yspeed = 20 + (level * 2);
		}
		if on_ground and yspeed > 0 {
			xspeed = 0;
			with(create_shot(
				0,
				0,
				0,
				-1,
				spr_explosion,
				1,
				1000,
				10,
				-10,
				attacktype.unblockable,
				attackstrength.heavy,
				hiteffects.fire
			)) {
				duration = anim_duration;
				hit_limit = -1;
				play_sound(snd_explosion_large);
			};
			land();
		}
	}

	machinegun_blows = new charstate();
	machinegun_blows.start = function() {
		if attempt_special(1/2) {
			change_sprite(spr_genos_attack_punch,true);
			play_voiceline(voice_attack,50,false);
		}
	}
	machinegun_blows.run = function() {
		xspeed = 1 * facing;
		yspeed = 0;
		if state_timer mod 3 == 1 {
			play_sound(snd_punch_whiff_medium);
			var _punches = 2;
			for(var i = 0; i < _punches; i++) {
				with(create_shot(
					-10,
					-sine_between(state_timer+i,5,height*0.4,height*0.8),
					10,
					0,
					spr_genos_blur_fist,
					1,
					10,
					0,
					0,
					attacktype.normal,
					attackstrength.light,
					hiteffects.hit
				)) {
					blend = false;
					duration = 5;
					hit_limit = -1;
				}
			}
		}
		if state_timer > (120 * (level / 3)) {
			if combo_timer > 0 {
				if on_ground {
					change_state(heavy_lowattack);
				}
				else {
					change_state(heavy_airattack);
				}
			}
			else {
				if on_ground {
					change_state(backdash_state);
				}
				else {
					change_state(air_state);
				}
			}
		}
	}

	incinerate = new charstate();
	incinerate.start = function() {
		if attempt_special(1,(!incinerate_cooldown)) {
			change_sprite(spr_genos_special_incinerate,false);
			xspeed = 0;
			yspeed = 0;
			incinerate_cooldown = incinerate_cooldown_duration;
			play_voiceline(vc_genos_incinerate);
			play_sound(snd_dbz_beam_charge_short);
		}
		else {
			change_state(idle_state);
		}
	}
	incinerate.run = function() {
		xspeed = 0;
		yspeed = 0;
		if check_frame(3) {
			play_sound(snd_dbz_beam_fire);
		}
		loop_anim_middle_timer(3,4,30);
		if value_in_range(frame,3,4) {
			fire_beam(spr_incinerate,0.75+(level / 4),0,50);
		}
		anim_finish_idle();
	}
	
	incinerate_medium = new charstate();
	incinerate_medium.start = function() {
		incinerate_light.start();
		if active_state == incinerate_medium {
			anim_speed = 0.8;
		}
	}
	incinerate_medium.run = function() {
		incinerate_light.run();
	}
	
	incinerate_heavy = new charstate();
	incinerate_heavy.start = function() {
		incinerate_light.start();
		if active_state == incinerate_heavy {
			anim_speed = 0.6;
		}
	}
	incinerate_heavy.run = function() {
		incinerate_light.run();
	}

	super_incinerate = new charstate();
	super_incinerate.start = function() {
		if attempt_special(2,(!incinerate_cooldown)) {
			change_sprite(spr_genos_special_incinerate2,false);
			xspeed = 0;
			yspeed = 0;
			incinerate_cooldown = incinerate_cooldown_duration * 1.5;
		}
		else {
			change_state(idle_state);
		}
	}
	super_incinerate.run = function() {
		xspeed = 0;
		yspeed = 0;
		if superfreeze_active {
			loop_anim_middle(4,4);
		}
		loop_anim_middle_timer(5,6,60);
		if value_in_range(frame,5,6) {
			fire_beam(spr_incinerate,1+(level / 3),0,100);
			shake_screen(5,1);
		}
		if check_frame(3) {
			play_voiceline(vc_genos_incinerate);
			play_sound(snd_dbz_beam_charge_short);
		}
		if check_frame(5) {
			play_sound(snd_dbz_beam_fire);
			shake_screen(20,1);
		}
		anim_finish_idle();
	}

	setup_basicmoves();
	
	add_move(fireblast,"D");
	
	add_ground_move(machinegun_blows,"236A");
	add_move(dropkick,"236B");
	add_move(dropkick,"236C");
	
	add_move(incinerate,"236D");
	add_move(super_incinerate,"214D");
	
	signature_move = super_incinerate;
	finisher_move = super_incinerate;
	
	victory_state.run = function() {
		if sound_is_playing(voice) {
			loop_anim_middle(3,5);
		}
	}
	defeat_state.run = function() {
		if sound_is_playing(voice) {
			loop_anim_middle(3,5);
		}
		loop_anim_middle(6,7);
	}
}