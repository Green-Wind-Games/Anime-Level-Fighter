/// @description Insert description here
// You can write your code in this editor
event_inherited();

init_charsprites("goku_ssj");

name = "Goku Super Saiyajin";
theme = mus_dbfz_goku;

//next_form = obj_goku_ssj3;

char_script = function() {
	kamehameha_cooldown -= 1;
}

var i = 0;
autocombo[i] = new state();
autocombo[i].start = function() {
	if on_ground {
		change_sprite(spr_goku_ssj_jab,3,false);
		play_sound(snd_punch_whiff_light);
		play_voiceline(voice_attack,50,false);
	}
	else {
		change_state(autocombo[5]);
	}
}
autocombo[i].run = function() {
	basic_attack(2,10,attackstrength.light,hiteffects.hit);
	return_to_idle();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_ssj_elbowbash,5,false);
	play_sound(snd_punch_whiff_medium);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	basic_attack(2,20,attackstrength.light,hiteffects.hit);
	if check_frame(2) {
		xspeed = 10 * facing;
		yspeed = 0;
	}
	return_to_idle();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_ssj_kick2,3,false);
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
	change_sprite(spr_goku_ssj_kick,3,false);
	play_sound(snd_punch_whiff_medium);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	basic_attack(3,30,attackstrength.light,hiteffects.hit);
	return_to_idle();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_ssj_backflipkick,5,false);
	play_sound(snd_punch_whiff_heavy);
	play_voiceline(voice_heavyattack,50,false);
}
autocombo[i].run = function() {
	basic_launcher(2,100,hiteffects.hit);
	return_to_idle();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_ssj_jab,2,false);
	play_sound(snd_punch_whiff_light);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	//standard_attack(2,10,attacktype.normal,hiteffects.hit);
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_ssj_doublespinkick,2,false);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	//standard_attack(4,20,attacktype.medium,hiteffects.hit);
	//standard_attack(8,20,attacktype.medium,hiteffects.hit);
	if check_frame(2) or check_frame(6) {
		play_sound(snd_punch_whiff_medium);
	}
	land();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_ssj_kick3,5,false);
	play_sound(snd_punch_whiff_medium);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	//standard_attack(2,30,attacktype.heavy,hiteffects.hit);
	land();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_ssj_kick4,5,false);
	play_sound(snd_punch_whiff_medium);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	//standard_attack(1,30,attacktype.heavy,hiteffects.hit);
	land();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_ssj_triplekick,2,false);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	//standard_attack(3,10,attacktype.normal,hiteffects.hit);
	//standard_attack(5,10,attacktype.normal,hiteffects.hit);
	//standard_attack(7,10,attacktype.normal,hiteffects.hit);
	if check_frame(2) or check_frame(4) or check_frame(6) {
		play_sound(snd_punch_whiff_light);
	}
	land();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_ssj_axehandle,5,false);
	play_sound(snd_punch_whiff_heavy);
	play_voiceline(voice_heavyattack,100,true);
}
autocombo[i].run = function() {
	//standard_smash(2,100,hiteffects.hit);
}
i++;

forward_throw = new state();
forward_throw.start = function() {
	change_sprite(spr_goku_ssj_uppercutkick,8,false);
	with(grabbed) {
		change_sprite(grabbed_sprite,1000,false);
		depth = other.depth + 1;
	}
	xspeed = 0;
	yspeed = 0;
}
forward_throw.run = function() {
	xspeed = 0;
	yspeed = 0;
	if state_timer < 30 {
		frame = 0;
	}
	grab_frame(0,10,0,0,false);
	if check_frame(3) {
		var _hit = grabbed;
		release_grab(2,20,0,0,0);
		with(_hit) {
			get_hit(other,50,1,-10,attacktype.normal,attackstrength.heavy,hiteffects.hit);
		}
	}
	return_to_idle();
}

back_throw = new state();
back_throw.start = function() {
	forward_throw.start();
}
back_throw.run = function() {
	if check_frame(1) facing = -facing;
	forward_throw.run();
}

kiblast = new state();
kiblast.start = function() {
	change_sprite(spr_goku_ssj_kiblast,2,false);
}
kiblast.run = function() {
	if check_frame(3) {
		create_kiblast(spr_kiblast_yellow);
		if is_airborne {
			xspeed = -2 * facing;
			yspeed = -2;
		}
		kiblast_count += 1;
	}
	if frame > 3 {
		if kiblast_count < max_kiblasts {
			if sprite == spr_goku_ssj_kiblast {
				change_sprite(spr_goku_ssj_kiblast2,frame_duration,false);
			}
			else {
				change_sprite(spr_goku_ssj_kiblast,frame_duration,false);
			}
		}
		else {
			if state_timer >= 90 {
				change_state(idle_state);
			}
		}
	}
}
kiblast.stop = function() {
	if next_state != kiblast {
		kiblast_count = 0;
	}
}

kamehameha = new state();
kamehameha.start = function() {
	if kamehameha_cooldown <= 0 {
		if on_ground {
			change_sprite(spr_goku_ssj_kamehameha,4,false);
		}
		else {
			change_sprite(spr_goku_ssj_kamehameha_air,4,false);
		}
		xspeed = 0;
		yspeed = 0;
		kamehameha_cooldown = kamehameha_cooldown_duration;
		play_voiceline(snd_goku_kamehameha);
		play_sound(snd_dbz_beam_charge_short);
	}
	else {
		change_state(previous_state);
	}
}
kamehameha.run = function() {
	xspeed = 0;
	yspeed = 0;
	if check_frame(6) {
		play_sound(snd_dbz_beam_fire,1,1.5);
	}
	if value_in_range(frame,6,9) {
		fire_beam_attack(spr_kamehameha,0.3,1);
	}
	return_to_idle();
}

super_kamehameha = new state();
super_kamehameha.start = function() {
	if kamehameha_cooldown <= 0 and check_mp(2) {
		if on_ground {
			change_sprite(spr_goku_ssj_superkamehameha,4,false);
		}
		else {
			change_sprite(spr_goku_ssj_superkamehameha_air,4,false);
		}
		xspeed = 0;
		yspeed = 0;
		activate_super(320);
		spend_mp(2);
		kamehameha_cooldown = kamehameha_cooldown_duration * 2;
		play_sound(snd_dbz_beam_charge_long);
	}
	else {
		change_state(previous_state);
	}
}
super_kamehameha.run = function() {
	xspeed = 0;
	yspeed = 0;
	if superfreeze_active {
		if frame > 5 {
			frame = 4;
		}
	}
	if state_timer <= 120 {
		if frame >= 9 {
			frame = 6;
			frame_timer = 1;
		}
	}
	if check_frame(6) {
		play_voiceline(snd_goku_kamehameha);
		play_sound(snd_dbz_beam_fire2,1,0.8);
	}
	if value_in_range(frame,6,9) {
		fire_beam_attack(spr_kamehameha,1,3);
	}
	if state_timer >= 150 {
		change_state(idle_state);
	}
}

meteor_combo = new state();
meteor_combo.start = function() {
	if on_ground and check_mp(1) {
		change_sprite(spr_goku_ssj_jab,3,false);
		activate_super();
		spend_mp(1);
	}
	else {
		change_state(previous_state);
	}
}
meteor_combo.run = function() {
	if superfreeze_active {
		frame = 0;
	}
	if sprite == spr_goku_jab //standard_attack(3,40,attacktype.medium,hiteffects.hit);
	if sprite == spr_goku_elbowbash //standard_attack(2,40,attacktype.medium,hiteffects.hit);
	if sprite == spr_goku_kick2 //standard_attack(2,40,attacktype.medium,hiteffects.hit);
	if sprite == spr_goku_kick //standard_attack(1,40,attacktype.medium,hiteffects.hit);
	if sprite == spr_goku_backflipkick //standard_attack(3,40,attacktype.normal,hiteffects.hit);
	if can_cancel {
		sprite_sequence(
			[
				spr_goku_jab,
				spr_goku_elbowbash,
				spr_goku_kick2,
				spr_goku_kick,
				spr_goku_backflipkick,
				spr_goku_kamehameha_air
			],
			2
		);
	}
	if sprite == spr_goku_kamehameha_air {
		frame_duration = 5;
		xspeed = 0;
		yspeed = 0;
		if check_frame(3) {
			y = target.y;
			face_target();
		}
		kamehameha.run();
	}
	else {
		if check_frame(1) {
			face_target();
			xspeed = 12 * facing;
			play_sound(snd_punch_whiff_medium);
		}
	}
}

max_air_moves = 3;

max_kiblasts = 7;
kiblast_count = 0;
setup_autocombo();
add_move(kiblast,"B");
add_move(kamehameha,"236B");
add_move(meteor_combo,"236A");
add_move(meteor_combo,"214A");
add_move(super_kamehameha,"41236B");

ai_script = function() {
	if target_distance_x < 50 {
		ai_input_move(meteor_combo,10);
	}
	if target_distance > 150 {
		ai_input_move(kiblast,1);
		ai_input_move(kamehameha,10);
		ai_input_move(super_kamehameha,10);
	}
}

var i = 0;
voice_attack[i++] = snd_goku_attack;
voice_attack[i++] = snd_goku_attack2;
voice_attack[i++] = snd_goku_attack3;
voice_attack[i++] = snd_goku_attack4;
voice_attack[i++] = snd_goku_attack5;
i = 0;
voice_heavyattack[i++] = snd_goku_heavyattack;
voice_heavyattack[i++] = snd_goku_heavyattack2;
voice_heavyattack[i++] = snd_goku_heavyattack3;
i = 0;
voice_hurt[i++] = snd_goku_hurt;
voice_hurt[i++] = snd_goku_hurt2;
voice_hurt[i++] = snd_goku_hurt3;
voice_hurt[i++] = snd_goku_hurt4;
voice_hurt[i++] = snd_goku_hurt5;
i = 0;
voice_hurt_heavy[i++] = snd_goku_hurt_heavy;
voice_hurt_heavy[i++] = snd_goku_hurt_heavy2;
voice_hurt_heavy[i++] = snd_goku_hurt_heavy3;
voice_hurt_heavy[i++] = snd_goku_hurt_heavy4;
voice_hurt_heavy[i++] = snd_goku_hurt_heavy5;

draw_script = function() {
	if sprite == spr_goku_ssj_kiblast
	or sprite == spr_goku_ssj_kiblast2 {
		gpu_set_blendmode(bm_add);
		if frame == 3 {
			var _x = x + (32 * facing);
			var _y = y - 32;
			var _scale = (frame_timer + 1) / (frame_duration * 1.5);
			draw_sprite_ext(
				spr_ki_spark,
				frame mod 2,
				_x,
				_y,
				facing * _scale,
				_scale,
				rotation*facing,
				c_white,
				1
			);
		}
	}
	if sprite == spr_goku_ssj_kamehameha
	or sprite == spr_goku_ssj_kamehameha_air {
		gpu_set_blendmode(bm_add);
		if value_in_range(frame,3,5) {
			var _x = x - (10 * facing);
			var _y = y - 25;
			var _scale = (frame_timer + 1) / (frame_duration / 1.5);
			draw_sprite_ext(
				spr_kamehameha_charge,
				frame mod 2,
				_x,
				_y,
				facing * _scale,
				_scale,
				rotation*facing,
				c_white,
				1
			);
		}
		if value_in_range(frame,6,9) {
			var _x = x + (20 * facing);
			var _y = y - 25;
			var _scale = (frame_timer + 1) / (frame_duration / 1.5);
			draw_sprite_ext(
				spr_ki_spark,
				frame mod 2,
				_x,
				_y,
				facing * _scale,
				_scale,
				rotation*facing,
				c_white,
				1
			);
			draw_sprite_ext(
				spr_kamehameha_origin,
				frame mod 2,
				_x,
				_y,
				facing,
				1,
				rotation*facing,
				c_white,
				1
			);
		}
	}
	if sprite == spr_goku_ssj_superkamehameha
	or sprite == spr_goku_ssj_superkamehameha_air {
		gpu_set_blendmode(bm_add);
		if value_in_range(frame,3,5) {
			var _x = x - (10 * facing);
			var _y = y - 25;
			var _scale = (frame_timer + 1) / (frame_duration / 1.5);
			draw_sprite_ext(
				spr_kamehameha_charge,
				frame mod 2,
				_x,
				_y,
				facing * _scale,
				_scale,
				rotation*facing,
				c_white,
				1
			);
		}
		if value_in_range(frame,6,9) {
			var _x = x + (25 * facing);
			var _y = y - 25;
			var _scale = (frame_timer + 1) / (frame_duration / 2);
			draw_sprite_ext(
				spr_ki_spark,
				frame mod 2,
				_x,
				_y,
				facing * _scale,
				_scale,
				rotation*facing,
				c_white,
				1
			);
			draw_sprite_ext(
				spr_superkamehameha_origin,
				frame mod 2,
				_x,
				_y,
				facing,
				1,
				rotation*facing,
				c_white,
				1
			);
		}
	}
	gpu_set_blendmode(bm_normal);
}