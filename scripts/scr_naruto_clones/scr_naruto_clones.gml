function init_naruto_baseform_clone() {
	init_charsprites("naruto");
	init_charaudio("naruto");
	voice_volume_mine = owner.voice_volume_mine;
	
	create_particles(x,y,jutsu_smoke_particle);
	
	max_hp = 1;
	hp = max_hp;

	helper_attack_script = function() {
		if (target_distance < 20) {
			change_state(choose(punch,punch2,slash,slash2));
		}
		else if (target_distance > 150) {
			if chance(30) {
				change_state(shuriken_throw);
			}
		}
	}
	
	death_script = function() {
		create_particles(x,y,jutsu_smoke_particle);
		instance_destroy();
	}
	
	punch = new charstate();
	punch.start = function() {
		change_sprite(spr_naruto_attack_punch_straight,3,false);
		play_sound(snd_punch_whiff_light);
		play_voiceline(voice_attack,50,false);
	}
	punch.run = function() {
		basic_light_attack(2,hiteffects.hit);
		if anim_finished {
			if can_cancel and choose(true,false) {
				change_state(punch2);
			}
			else {
				change_state(idle_state);
			}
		}
	}
	punch2 = new charstate();
	punch2.start = function() {
		change_sprite(spr_naruto_attack_punch_hook,5,false);
		play_sound(snd_punch_whiff_medium);
		play_voiceline(voice_attack,50,false);
	}
	punch2.run = function() {
		basic_medium_attack(2,hiteffects.hit);
		if anim_finished {
			change_state(idle_state);
		}
	}
	
	slash = new charstate();
	slash.start = function() {
		change_sprite(spr_naruto_attack_slash,3,false);
		play_sound(snd_slash_whiff_light);
		play_voiceline(voice_attack,50,false);
	}
	slash.run = function() {
		basic_light_attack(2,hiteffects.slash);
		if check_frame(2) {
			char_specialeffect(spr_slash,width_half,-height_half,0.5,-0.5,-45);
		}
		if anim_finished {
			if can_cancel and choose(true,false) {
				change_state(slash2);
			}
			else {
				change_state(idle_state);
			}
		}
	}
	slash2 = new charstate();
	slash2.start = function() {
		change_sprite(spr_naruto_attack_slash_up,5,false);
		play_sound(snd_slash_whiff_medium);
		play_voiceline(voice_heavyattack,50,false);
	}
	slash2.run = function() {
		if check_frame(3) {
			xspeed = 3 * facing;
			yspeed = -5;
			basic_medium_lowattack(3,hiteffects.slash);
			
			char_specialeffect(spr_slash2,width*0.9,-height*0.75,0.5,-0.5,-45);
		}
		if anim_finished and on_ground {
			change_state(idle_state);
		}
	}
	
	shuriken_throw = new charstate();
	shuriken_throw.start = function() {
		change_sprite(spr_naruto_special_throw_shuriken,7,false);
		play_voiceline(voice_attack,20,false);
	}
	shuriken_throw.run = function() {
		if check_frame(3) {
			shuriken = create_shot(
				10,
				-35,
				12,
				0,
				spr_shuriken,
				1,
				10,
				3,
				0,
				attacktype.normal,
				attackstrength.light,
				hiteffects.slash
			);
			with(shuriken) {
				blend = false;
				hit_limit = -1;
				duration = 100;
				rotation_speed = -30;
				active_script = function() {
					if y >= ground_height {
						homing = false;
						yspeed = 0;
						xspeed /= 2;
						if duration > 10 {
							duration = 10;
						}
					}
					else {
						loop_sound(snd_slash_whiff_light,0.5,2);
					}
				}
				hit_script = function() {
					xspeed /= 2;
					yspeed /= 2;
					homing = false;
					affected_by_gravity = true;
				}
			}
		}
		return_to_idle();
	}
}

function init_naruto_baseform_clone_barrage() {
	init_naruto_baseform_clone();
	
	duration = 60;

	barrage_kick = new charstate();
	barrage_kick.start = function() {
		change_sprite(spr_naruto_attack_slide_kick_up,8,false);
		xoffset = width / 3;
		face_target();
		xspeed = 20 * facing;
	}
	barrage_kick.run = function() {
		if check_frame(1) {
			create_hitbox(
				0,
				-height_half,
				width,
				height_half,
				100,
				0,
				-12,
				attacktype.hard_knockdown,
				attackstrength.medium,
				hiteffects.hit
			);
			xspeed = 0;
		}
	}
	
	change_state(barrage_kick);
}