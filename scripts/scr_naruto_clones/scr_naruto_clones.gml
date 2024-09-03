function init_naruto_baseform_clone() {
	init_charsprites("naruto");
	
	create_particles(x,y,x,y,jutsu_smoke_particle);
	
	max_hp = 1;
	hp = max_hp;

	helper_attack_script = function() {
		if (target_distance < 20) {
			change_state(
				choose(
					choose(punch,punch2),
					choose(slash,slash2),
					jump_state
				)
			);
		}
		else if target_distance > 100 {
			change_state(choose(shuriken_throw,jump_state));
		}
	}
	
	death_script = function() {
		create_particles(x,y,x,y,jutsu_smoke_particle);
		instance_destroy();
	}
	
	punch = new state();
	punch.start = function() {
		change_sprite(spr_naruto_attack_punch_straight,3,false);
		play_sound(snd_punch_whiff_light);
		play_voiceline(voice_attack,50,false);
	}
	punch.run = function() {
		basic_attack(2,10,attackstrength.light,hiteffects.hit);
		if anim_finished {
			if can_cancel and choose(true,false) {
				change_state(punch2);
			}
			else {
				return_to_idle();
			}
		}
	}
	punch2 = new state();
	punch2.start = function() {
		change_sprite(spr_naruto_attack_punch_hook,5,false);
		play_sound(snd_punch_whiff_medium);
		play_voiceline(voice_attack,50,false);
	}
	punch2.run = function() {
		basic_attack(2,20,attackstrength.light,hiteffects.hit);
		return_to_idle();
	}
	
	slash = new state();
	slash.start = function() {
		change_sprite(spr_naruto_attack_slash,3,false);
		play_sound(snd_slash_whiff_light);
		play_voiceline(voice_attack,50,false);
	}
	slash.run = function() {
		basic_attack(2,20,attackstrength.light,hiteffects.slash);
		if anim_finished {
			if can_cancel and choose(true,false) {
				change_state(slash2);
			}
			else {
				return_to_idle();
			}
		}
	}
	slash2 = new state();
	slash2.start = function() {
		change_sprite(spr_naruto_attack_slash_up,5,false);
		play_sound(snd_slash_whiff_medium);
		play_voiceline(voice_attack,50,false);
	}
	slash2.run = function() {
		if check_frame(3) {
			xspeed = 3 * facing;
			yspeed = -5;
			create_hitbox(
				0,
				-height,
				width,
				height,
				30,
				1,
				-6,
				attacktype.normal,
				attackstrength.medium,
				hiteffects.slash
			);
		}
		if anim_finished {
			land();
		}
	}
	
	shuriken_throw = new state();
	shuriken_throw.start = function() {
		change_sprite(spr_naruto_special_throw_shuriken,3,false);
	}
	shuriken_throw.run = function() {
		if check_frame(3) {
			shuriken = create_shot(
				10,
				-35,
				8,
				random_range(2,-2),
				spr_shuriken,
				1,
				30,
				3,
				0,
				attacktype.normal,
				attackstrength.light,
				hiteffects.slash
			);
			with(shuriken) {
				blend = false;
				duration = -1;
				active_script = function() {
					if y >= ground_height {
						yspeed = 0;
						xspeed /= 2;
						if duration > 10 {
							duration = 10;
						}
					}
				}
				hit_script = function() {
					xspeed /= 2;
					yspeed /= 2;
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

	barrage_kick = new state();
	barrage_kick.start = function() {
		change_sprite(spr_naruto_attack_slide_kick_up,8,false);
		xoffset = width / 3;
		face_target();
		xspeed = 15 * facing;
	}
	barrage_kick.run = function() {
		if check_frame(1) {
			face_target();
			create_hitbox(
				0,
				-height_half,
				width,
				height_half,
				50,
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