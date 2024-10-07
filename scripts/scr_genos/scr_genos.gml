function init_genos_baseform() {
	init_charsprites("genos");

	name = "Genos";
	theme = mus_opm_genos;

	move_speed_mod = 1.35;
	max_air_moves = 3;

	dropkick_cooldown = 0;
	dropkick_cooldown_duration = 100;

	incinerate_cooldown = 0;
	incinerate_cooldown_duration = 150;
	
	init_charaudio("genos");
	voice_volume_mine = 3.5;

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

	light_attack = new state();
	light_attack.start = function() {
		if on_ground {
			change_sprite(spr_genos_attack_punch_straight,3,false);
			play_sound(snd_punch_whiff_light);
			play_voiceline(voice_attack,50,false);
		}
		else {
			change_state(light_airattack);
		}
	}
	light_attack.run = function() {
		basic_attack(2,100,attackstrength.light,hiteffects.hit);
		return_to_idle();
	}

	medium_attack = new state();
	medium_attack.start = function() {
		if on_ground {
			change_sprite(spr_genos_attack_kick_straight,5,false);
			play_sound(snd_punch_whiff_medium);
			play_voiceline(voice_attack,50,false);
		}
		else {
			change_state(medium_airattack);
		}
	}
	medium_attack.run = function() {
		basic_attack(2,200,attackstrength.medium,hiteffects.hit);
		return_to_idle();
	}

	heavy_attack = new state();
	heavy_attack.start = function() {
		if on_ground {
			change_sprite(spr_genos_attack_uppercut,4,false);
			play_sound(snd_punch_whiff_heavy);
			play_voiceline(voice_heavyattack,50,false);
		}
		else {
			change_state(heavy_airattack);
		}
	}
	heavy_attack.run = function() {
		basic_launcher(2,300,hiteffects.hit);
	}
	
	light_airattack = new state();
	light_airattack.start = function() {
		change_sprite(spr_genos_attack_punch_straight,3,false);
		play_sound(snd_punch_whiff_light);
		play_voiceline(voice_attack,50,false);
	}
	light_attack.run = function() {
		basic_attack(2,150,attackstrength.light,hiteffects.hit);
		return_to_idle();
	}

	medium_airattack = new state();
	medium_airattack.start = function() {
		change_sprite(spr_genos_attack_kick_up,5,false);
		play_sound(snd_punch_whiff_medium);
		play_voiceline(voice_attack,50,false);
	}
	medium_airattack.run = function() {
		basic_attack(2,250,attackstrength.medium,hiteffects.hit);
		return_to_idle();
	}

	heavy_airattack = new state();
	heavy_airattack.start = function() {
		change_sprite(spr_genos_attack_smash,4,false);
		play_sound(snd_punch_whiff_super);
		play_voiceline(voice_heavyattack,100,true);
	}
	heavy_airattack.run = function() {
		basic_smash(2,500,hiteffects.hit);
		land();
	}
	i++;

	forward_throw = new state();
	forward_throw.start = function() {
		change_sprite(spr_genos_special_spiritbomb,4,false);
		with(grabbed) {
			change_sprite(grabbed_body_sprite,100,false);
			yoffset = -height / 2;
			depth = other.depth - 1;
		}
		xspeed = 0;
		yspeed = 0;
		play_voiceline(voice_attack);
	}
	forward_throw.run = function() {
		xspeed = 0;
		yspeed = 0;
		grab_frame(0,10,0,0,false);
		grab_frame(1,0,-30,-45,false);
		grab_frame(2,0,-40,-90,false);
		grab_frame(6,-5,-35,-100,false);
		grab_frame(7,-10,-30,-120,false);
		grab_frame(8,-20,-20,-135,false);
		release_grab(9,10,-60,2,30);
		if check_frame(6) {
			play_voiceline(voice_attack);
		}
		return_to_idle();
	}

	back_throw = new state();
	back_throw.start = function() {
		forward_throw.start();
	}
	back_throw.run = function() {
		if check_frame(4) facing = -facing;
		forward_throw.run();
	}

	dropkick = new state();
	dropkick.start = function() {
		if !dropkick_cooldown {
			change_sprite(spr_genos_special_dropkick,2,false);
			dropkick_cooldown = dropkick_cooldown_duration;
			xspeed = 10 * facing;
			yspeed = -20;
		}
		else {
			change_state(previous_state);
		}
	}
	dropkick.run = function() {
		if target_distance_x < 10 {
			xspeed = 0;
		}
		if check_frame(4) {
			play_sound(snd_punch_whiff_ultimate);
		}
		if check_frame(6) {
			yspeed = 20;
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
				100,
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

	fireblast = new state();
	fireblast.start = function() {
		if check_mp(1/2) {
			change_sprite(spr_genos_special_blast,2,false);
		}
		else {
			change_state(previous_state);
		}
	}
	fireblast.run = function() {
		if check_frame(3) {
			repeat(4) {
				create_kiblast(20,-35,spr_fireball);
			}
			spend_mp(1/2);
			if is_airborne {
				xspeed = -2 * facing;
				yspeed = -2;
			}
		}
		if state_timer > 50 {
			return_to_idle();
		}
	}

	incinerate = new state();
	incinerate.start = function() {
		if !incinerate_cooldown {
			change_sprite(spr_genos_special_incinerate,8,false);
			xspeed = 0;
			yspeed = 0;
			incinerate_cooldown = incinerate_cooldown_duration;
			play_voiceline(snd_genos_incinerate);
			play_sound(snd_dbz_beam_charge_short);
		}
		else {
			change_state(previous_state);
		}
	}
	incinerate.run = function() {
		xspeed = 0;
		yspeed = 0;
		if check_frame(3) {
			play_sound(snd_dbz_beam_fire);
		}
		if value_in_range(frame,3,4) {
			fire_beam(5,-25,spr_incinerate,0.8,0,5);
		}
		return_to_idle();
	}

	machinegun_blows = new state();
	machinegun_blows.start = function() {
		change_sprite(spr_genos_attack_punch_straight,2,true);
		play_voiceline(voice_attack,50,false);
	}
	machinegun_blows.run = function() {
		if state_timer mod 6 == 1 {
			play_sound(snd_punch_whiff_medium);
			repeat(2) {
				with(create_shot(
					-random(15),
					-random_range(height*0.8,height_half),
					10,
					0,
					spr_genos_blur_fist,
					1,
					1,
					1,
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
		if state_timer > 50 {
			change_state(idle_state);
		}
	}
	i++;

	super_incinerate = new state();
	super_incinerate.start = function() {
		if (!incinerate_cooldown) and check_mp(2) {
			change_sprite(spr_genos_special_incinerate2,10,false);
			activate_super(60);
			spend_mp(2);
			xspeed = 0;
			yspeed = 0;
			incinerate_cooldown = incinerate_cooldown_duration * 1.5;
		}
		else {
			change_state(previous_state);
		}
	}
	super_incinerate.run = function() {
		xspeed = 0;
		yspeed = 0;
		if superfreeze_active {
			if frame > 4 {
				frame = 4;
			}
		}
		if state_timer <= 120 {
			if frame > 6 {
				frame = 5;
				frame_timer = 1;
			}
		}
		if value_in_range(frame,5,6) {
			fire_beam(10,-25,spr_incinerate,1,0,5);
			shake_screen(5,3);
		}
		if check_frame(3) {
			play_voiceline(snd_genos_incinerate);
			play_sound(snd_dbz_beam_charge_short);
		}
		if check_frame(5) {
			play_sound(snd_dbz_beam_fire);
		}
		return_to_idle();
	}

	setup_basicmoves();

	add_move(dropkick,"B");
	add_move(fireblast,"C");

	add_move(incinerate,"D");
	add_move(super_incinerate,"ED");
}