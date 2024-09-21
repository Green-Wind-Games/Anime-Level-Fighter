function init_genos_baseform() {
	init_charsprites("genos");

	name = "Genos";
	theme = mus_opm_genos;

	move_speed *= 1.5;
	max_air_moves = 3;

	dropkick_cooldown = 0;
	dropkick_cooldown_duration = 100;

	incinerate_cooldown = 0;
	incinerate_cooldown_duration = 150;

	char_script = function() {
		incinerate_cooldown -= 1;
		dropkick_cooldown -= 1;
	}
	
	ai_script = function() {
		if target_distance < 100 {
			ai_input_move(dropkick,10);
		}
		else if target_distance > 200 {
			ai_input_move(fireblast,10);
			ai_input_move(incinerate,10);
			ai_input_move(super_incinerate,10);
		}
	}

	var i = 0;
	voice_attack[i++] = snd_genos_attack;
	voice_attack[i++] = snd_genos_attack2;
	voice_attack[i++] = snd_genos_attack3;
	i = 0;
	voice_heavyattack[i++] = snd_genos_heavyattack;
	voice_heavyattack[i++] = snd_genos_heavyattack2;
	i = 0;
	voice_hurt[i++] = snd_genos_hurt;
	voice_hurt[i++] = snd_genos_hurt2;
	voice_hurt[i++] = snd_genos_hurt3;
	i = 0;
	voice_hurt_heavy[i++] = snd_genos_hurt_heavy;
	voice_hurt_heavy[i++] = snd_genos_hurt_heavy2;
	voice_hurt_heavy[i++] = snd_genos_hurt_heavy3;
	//i = 0;
	//voice_powerup[i++] = snd_genos_powerup;

	var i = 0;
	autocombo[i] = new state();
	autocombo[i].start = function() {
		if on_ground {
			change_sprite(spr_genos_attack_punch_straight,3,false);
			play_sound(snd_punch_whiff_light);
			play_voiceline(voice_attack,50,false);
		}
		else {
			change_state(autocombo[3]);
		}
	}
	autocombo[i].run = function() {
		basic_attack(2,10,attackstrength.light,hiteffects.hit);
		return_to_idle();
	}
	i++;

	autocombo[i] = new state();
	autocombo[i].start = function() {
		change_sprite(spr_genos_attack_punch_straight,2,true);
		play_voiceline(voice_attack,50,false);
	}
	autocombo[i].run = function() {
		if state_timer mod 5 == 0 {
			play_sound(snd_punch_whiff_medium);
			repeat(3) {
				with(create_shot(
					0,
					(-height) + random(height_half),
					10,
					0,
					spr_genos_blur_fist,
					1,
					10,
					1,
					0,
					attacktype.normal,
					attackstrength.light,
					hiteffects.hit
				)) {
					blend = false;
					duration = 5;
					hit_limit = 2;
				}
			}
		}
		if state_timer > 60 {
			if combo_hits > 0 {
				change_state(autocombo[2]);
			}
			else {
				change_state(idle_state);
			}
		}
	}
	i++;

	autocombo[i] = new state();
	autocombo[i].start = function() {
		change_sprite(spr_genos_attack_uppercut,5,false);
		play_sound(snd_punch_whiff_heavy);
		play_voiceline(voice_heavyattack,50,false);
	}
	autocombo[i].run = function() {
		basic_launcher(3,50,hiteffects.hit);
	}
	i++;

	autocombo[i] = new state();
	autocombo[i].start = function() {
		change_sprite(spr_genos_attack_punch_straight,3,false);
		play_sound(snd_punch_whiff_light);
		play_voiceline(voice_attack,50,false);
	}
	autocombo[i].run = function() {
		basic_attack(2,20,attackstrength.light,hiteffects.hit);
		return_to_idle();
	}
	i++;

	autocombo[i] = new state();
	autocombo[i].start = function() {
		change_sprite(spr_genos_attack_uppercut,3,false);
		play_sound(snd_punch_whiff_medium);
		play_voiceline(voice_attack,50,false);
	}
	autocombo[i].run = function() {
		basic_attack(2,30,attackstrength.medium,hiteffects.hit);
		return_to_idle();
	}
	i++;

	autocombo[i] = new state();
	autocombo[i].start = function() {
		change_sprite(spr_genos_attack_kick_straight,3,false);
		play_sound(snd_punch_whiff_medium);
		play_voiceline(voice_attack,50,false);
	}
	autocombo[i].run = function() {
		basic_attack(2,30,attackstrength.medium,hiteffects.hit);
		return_to_idle();
	}
	i++;

	autocombo[i] = new state();
	autocombo[i].start = function() {
		change_sprite(spr_genos_attack_kick_up,3,false);
		play_voiceline(voice_attack,50,false);
		play_sound(snd_punch_whiff_medium);
	}
	autocombo[i].run = function() {
		basic_attack(2,30,attackstrength.medium,hiteffects.hit);
		return_to_idle();
	}
	i++;

	autocombo[i] = new state();
	autocombo[i].start = function() {
		change_sprite(spr_genos_attack_smash,4,false);
		play_sound(snd_punch_whiff_heavy);
		play_voiceline(voice_heavyattack,100,true);
	}
	autocombo[i].run = function() {
		basic_smash(2,100,hiteffects.hit);
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
			play_sound(snd_punch_whiff_heavy);
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
		change_sprite(spr_genos_special_blast,2,false);
	}
	fireblast.run = function() {
		if check_frame(3) {
			repeat(4) {
				create_kiblast(20,-35,spr_fireball);
			}
			if is_airborne {
				xspeed = -2 * facing;
				yspeed = -2;
			}
		}
		if state_timer > 45 {
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
			fire_beam(20,-25,spr_incinerate,0.8,0,10);
		}
		return_to_idle();
	}

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
			fire_beam(20,-25,spr_incinerate,1,0,10);
			shake_screen(5,3);
		}
		if check_frame(3) {
			play_voiceline(snd_genos_incinerate);
			play_sound(snd_dbz_beam_charge_short);
		}
		if check_frame(5) {
			play_sound(snd_dbz_beam_fire2);
		}
		return_to_idle();
	}

	setup_autocombo();

	add_move(dropkick,"B");
	add_move(fireblast,"C");

	add_move(incinerate,"D");
	add_move(super_incinerate,"ED");
}