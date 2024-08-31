function init_naruto_baseform_clone() {
	init_charsprites("naruto");
	
	create_particles(x,y,x,y,jutsu_smoke_particle);
	
	max_hp = 1;
	hp = max_hp;

	helper_attack_script = function() {
		if (target_distance < 20) {
			change_state(choose(punch,punch2));
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
				change_state(jump_state);
			}
		}
	}
	punch2 = new state();
	punch2.start = function() {
		change_sprite(spr_naruto_attack_punch_hook,3,false);
		play_sound(snd_punch_whiff_medium);
		play_voiceline(voice_attack,50,false);
	}
	punch2.run = function() {
		basic_attack(2,20,attackstrength.light,hiteffects.hit);
		if anim_finished {
			change_state(jump_state);
		}
	}
}