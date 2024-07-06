/// @description Insert description here
// You can write your code in this editor
event_inherited();

init_charsprites("goku_ssj1");

theme = mus_goku;

kamehameha_cooldown = 0;
kamehameha_cooldown_duration = 100;

attack_power = 1.2;

char_script = function() {
	if active_state != kamehameha {
		kamehameha_cooldown -= 1;
	}
}

var i = 0;
autocombo[i] = new state();
autocombo[i].start = function() {
	if on_ground {
		change_sprite(spr_goku_ssj1_jab,3,false);
		play_sound(snd_punch_whiff_light);
		play_voiceline(voice_attack,50,false);
	}
	else {
		change_state(autocombo[5]);
	}
}
autocombo[i].run = function() {
	standard_attack(2,10,attacktype.light,hiteffects.punch);
	check_moves();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_ssj1_elbowbash,5,false);
	play_sound(snd_punch_whiff_medium);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	standard_attack(2,20,attacktype.medium,hiteffects.punch);
	if check_frame(2) {
		xspeed = 10 * facing;
		yspeed = 0;
	}
	check_moves();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_ssj1_kick2,3,false);
	play_sound(snd_punch_whiff_light);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	standard_attack(2,30,attacktype.light,hiteffects.punch);
	check_moves();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_ssj1_kick,3,false);
	play_sound(snd_punch_whiff_medium);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	standard_attack(3,30,attacktype.light,hiteffects.punch);
	check_moves();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_ssj1_backflipkick,5,false);
	play_sound(snd_punch_whiff_heavy);
	play_voiceline(voice_heavyattack,50,false);
}
autocombo[i].run = function() {
	standard_launcher(3,50,hiteffects.punch);
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_ssj1_jab,2,false);
	play_sound(snd_punch_whiff_light);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	standard_attack(2,10,attacktype.light,hiteffects.punch);
	check_moves();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_ssj1_doublespinkick,2,false);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	standard_attack(4,20,attacktype.medium,hiteffects.punch);
	standard_attack(8,20,attacktype.medium,hiteffects.punch);
	if check_frame(2) or check_frame(6) {
		play_sound(snd_punch_whiff_medium);
	}
	if frame > 8 {
		check_moves();
	}
	land();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_ssj1_kick3,5,false);
	play_sound(snd_punch_whiff_medium);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	standard_attack(2,30,attacktype.heavy,hiteffects.punch);
	check_moves();
	land();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_ssj1_kick4,5,false);
	play_sound(snd_punch_whiff_medium);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	standard_attack(1,30,attacktype.heavy,hiteffects.punch);
	check_moves();
	land();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_ssj1_triplekick,2,false);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	standard_attack(3,10,attacktype.light,hiteffects.punch);
	standard_attack(5,10,attacktype.light,hiteffects.punch);
	standard_attack(7,10,attacktype.light,hiteffects.punch);
	if check_frame(2) or check_frame(4) or check_frame(6) {
		play_sound(snd_punch_whiff_light);
	}
	if frame > 8 {
		check_moves();
	}
	land();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_ssj1_axehandle,5,false);
	play_sound(snd_punch_whiff_heavy);
	play_voiceline(voice_heavyattack,100,true);
}
autocombo[i].run = function() {
	standard_smash(2,100,hiteffects.punch);
}
i++;

forward_throw = new state();
forward_throw.start = function() {
	change_sprite(spr_goku_ssj1_uppercutkick,8,false);
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
		frame_timer = 0;
	}
	grab_frame(0,10,0,0,false);
	if check_frame(3) {
		var _hit = grabbed;
		release_grab(2,20,0,0,0);
		with(_hit) {
			get_hit(other,attacktype.launcher,20,hiteffects.punch,hitanims.normal);
		}
	}
	if anim_finished {
		change_state(idle_state);
	}
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
	change_sprite(spr_goku_ssj1_kiblast,2,false);
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
			if sprite == spr_goku_ssj1_kiblast {
				change_sprite(spr_goku_ssj1_kiblast2,frame_duration,false);
			}
			else {
				change_sprite(spr_goku_ssj1_kiblast,frame_duration,false);
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
			change_sprite(spr_goku_ssj1_kamehameha,4,false);
		}
		else {
			change_sprite(spr_goku_ssj1_kamehameha_air,4,false);
		}
		xspeed = 0;
		yspeed = 0;
		kamehameha_cooldown = kamehameha_cooldown_duration;
		play_voiceline(snd_goku_kamehameha);
		play_sound(snd_kamehameha_start,1,1.5);
	}
	else {
		change_state(previous_state);
	}
}
kamehameha.run = function() {
	xspeed = 0;
	yspeed = 0;
	if check_frame(6) {
		play_sound(snd_kamehameha_fire,1,1.5);
	}
	if value_in_range(frame,6,9) {
		fire_beam_attack(30,-25,20,spr_kamehameha_beam,attacktype.beam,hiteffects.light);
	}
	if anim_finished {
		change_state(idle_state);
	}
}

super_kamehameha = new state();
super_kamehameha.start = function() {
	if kamehameha_cooldown <= 0 and check_mp(2) {
		if on_ground {
			change_sprite(spr_goku_ssj1_superkamehameha,4,false);
		}
		else {
			change_sprite(spr_goku_ssj1_superkamehameha_air,4,false);
		}
		xspeed = 0;
		yspeed = 0;
		superfreeze();
		spend_mp(2);
		kamehameha_cooldown = kamehameha_cooldown_duration * 2;
		play_sound(snd_activate_super);
		play_sound(snd_kamehameha_start);
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
			frame_timer = 0;
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
		play_sound(snd_kamehameha_fire,1,0.8);
	}
	if value_in_range(frame,6,9) {
		fire_beam_attack(30,-25,20,spr_superkamehameha_beam,attacktype.beam,hiteffects.light);
	}
	if anim_finished {
		if state_timer >= 150 {
			change_state(idle_state);
		}
	}
}
super_kamehameha.stop = function() {
	deactivate_super();
}

meteor_combo = new state();
meteor_combo.start = function() {
	if on_ground and check_mp(1) {
		change_sprite(spr_goku_ssj1_jab,3,false);
		superfreeze();
		spend_mp(1);
		play_sound(snd_activate_super);
	}
	else {
		change_state(previous_state);
	}
}
meteor_combo.run = function() {
	if superfreeze_active {
		frame = 0;
		frame_timer = 0;
	}
	if sprite == spr_goku_jab standard_attack(3,40,attacktype.medium,hiteffects.punch);
	if sprite == spr_goku_elbowbash standard_attack(2,40,attacktype.medium,hiteffects.punch);
	if sprite == spr_goku_kick2 standard_attack(2,40,attacktype.medium,hiteffects.punch);
	if sprite == spr_goku_kick standard_attack(1,40,attacktype.medium,hiteffects.punch);
	if sprite == spr_goku_backflipkick standard_attack(3,40,attacktype.launcher,hiteffects.punch);
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
meteor_combo.stop = function() {
	deactivate_super();
}

assist_a_state = new state();
assist_a_state.start = function() {
	change_sprite(air_down_sprite,6,false);
	face_target();
	x -= (50 * facing);
}
assist_a_state.run = function() {
	if sprite == air_down_sprite {
		if on_ground {
			yspeed = 0;
			change_sprite(spr_goku_ssj1_kiblast,2,false);
		}
	}
	else {
		kiblast.run();
	}
}
assist_a_state.stop = function() {
	kiblast.stop();
}

assist_b_state = new state();
assist_b_state.start = function() {
	change_sprite(air_down_sprite,6,false);
	face_target();
	x = target_x - (50 * facing);
}
assist_b_state.run = function() {
	if sprite == air_down_sprite {
		if on_ground {
			yspeed = 0;
			change_sprite(spr_goku_ssj1_triplekick,2,false);
		}
	}
	else {
		standard_attack(3,10,attacktype.light,hiteffects.punch);
		standard_attack(5,10,attacktype.light,hiteffects.punch);
		standard_attack(7,10,attacktype.light,hiteffects.punch);
		if anim_finished {
			change_state(tag_out_state);
		}
	}
}

assist_c_state = new state();
assist_c_state.start = function() {
	change_sprite(air_down_sprite,6,false);
	face_target();
	x += (20 * facing);
}
assist_c_state.run = function() {
	if sprite == air_down_sprite {
		if on_ground {
			yspeed = 0;
			change_sprite(spr_goku_ssj1_kamehameha,5,false);
		}
	}
	else {
		kamehameha.run();
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
voice_hurt[i++] = snd_goku_hurt1;
voice_hurt[i++] = snd_goku_hurt2;
voice_hurt[i++] = snd_goku_hurt3;
voice_hurt[i++] = snd_goku_hurt4;
voice_hurt[i++] = snd_goku_hurt5;
i = 0;
voice_hurt_heavy[i++] = snd_goku_hurt_heavy1;
voice_hurt_heavy[i++] = snd_goku_hurt_heavy2;
voice_hurt_heavy[i++] = snd_goku_hurt_heavy3;
voice_hurt_heavy[i++] = snd_goku_hurt_heavy4;
voice_hurt_heavy[i++] = snd_goku_hurt_heavy5;

draw_script = function() {
	if sprite == spr_goku_ssj1_kiblast
	or sprite == spr_goku_ssj1_kiblast2 {
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
	if sprite == spr_goku_ssj1_kamehameha
	or sprite == spr_goku_ssj1_kamehameha_air {
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
	if sprite == spr_goku_ssj1_superkamehameha
	or sprite == spr_goku_ssj1_superkamehameha_air {
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