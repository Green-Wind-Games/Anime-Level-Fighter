/// @description Insert description here
// You can write your code in this editor
event_inherited();

init_charsprites("genos");

name = "Genos";
theme = mus_opm_genos;

dropkick_cooldown = 0;
dropkick_cooldown_duration = 100;

char_script = function() {
	if active_state != dropkick {
		dropkick_cooldown -= 1;
	}
}

var i = 0;
autocombo[i] = new state();
autocombo[i].start = function() {
	if on_ground {
		change_sprite(spr_genos_jab,3,false);
		play_sound(snd_punch_whiff_light);
		play_voiceline(voice_attack,50,false);
	}
	else {
		change_state(autocombo[4]);
	}
}
autocombo[i].run = function() {
	basic_attack(2,10,attackstrength.light,hiteffects.hit);
	return_to_idle();
	check_moves();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_genos_uppercut,4,false);
	play_sound(snd_punch_whiff_medium);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	basic_attack(2,20,attackstrength.medium,hiteffects.hit);
	return_to_idle();
	check_moves();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_genos_kick2,6,false);
	play_sound(snd_punch_whiff_medium);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	//standard_attack(2,30,attacktype.medium,hiteffects.hit);
	check_moves();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_genos_kick,6,false);
	play_sound(snd_punch_whiff_heavy);
	play_voiceline(voice_heavyattack,50,false);
}
autocombo[i].run = function() {
	//standard_launcher(1,50,hiteffects.hit);
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_genos_jab,3,false);
	play_sound(snd_punch_whiff_light2);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	//standard_attack(2,20,attacktype.normal,hiteffects.hit);
	check_moves();
	land();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_genos_uppercut,6,false);
	play_sound(snd_punch_whiff_medium);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	//standard_attack(2,30,attacktype.medium,hiteffects.hit);
	check_moves();
	land();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_genos_kick,6,false);
	play_sound(snd_punch_whiff_medium);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	//standard_attack(1,40,attacktype.medium,hiteffects.hit);
	check_moves();
	land();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_genos_kick2,5,false);
	play_sound(snd_punch_whiff_medium);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	//standard_attack(2,50,attacktype.medium,hiteffects.hit);
	check_moves();
	land();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_genos_dunk,5,false);
	play_sound(snd_punch_whiff_heavy);
	play_voiceline(voice_heavyattack,100,true);
}
autocombo[i].run = function() {
	//standard_smash(2,100,hiteffects.hit);
}
i++;

forward_throw = new state();
forward_throw.start = function() {
	change_sprite(spr_genos_uppercut,8,false);
	with(grabbed) {
		change_sprite(grabbed_head_sprite,1000,false);
		yoffset = -40;
		depth = other.depth + 1;
	}
	xspeed = 0;
	yspeed = 0;
}
forward_throw.run = function() {
	xspeed = 0;
	yspeed = 0;
	if state_timer < 20 {
		frame = 0;
	}
	grab_frame(0,10,0,0,false);
	if check_frame(1) {
		play_sound(snd_punch_whiff_heavy);
		play_voiceline(voice_heavyattack,100,true);
	}
	if check_frame(2) {
		var _hit = grabbed;
		release_grab(0,20,0,0,0);
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

dash_attack = new state();
dash_attack.start = function() {
	change_sprite(spr_genos_flyingkick,5,false);
	xspeed = move_speed * 2 * facing;
	yspeed = 0;
	play_sound(snd_punch_whiff_heavy);
	play_voiceline(voice_heavyattack,100,true);
}
dash_attack.run = function() {
	xspeed = move_speed * 2 * facing;
	yspeed = 0;
	//standard_attack(2,10,attacktype.normal,hiteffects.hit);
	//standard_attack(3,20,attacktype.medium,hiteffects.hit);
	//standard_attack(4,50,attacktype.wall_bounce,hiteffects.hit);
	return_to_idle();
}

dropkick = new state();
dropkick.start = function() {
	if dropkick_cooldown <= 0 {
		change_sprite(spr_genos_dropkick,3,false);
		xspeed = 5 * facing;
		yspeed = -10;
		dropkick_cooldown = dropkick_cooldown_duration;
		play_sound(snd_punch_whiff_heavy);
		play_voiceline(voice_heavyattack,100,true);
	}
	else {
		change_state(previous_state);
	}
}
dropkick.run = function() {
	if frame < 5 {
		xspeed = 5 * facing;
		yspeed = -10;
	}
	else if frame >= 6 {
		xspeed = 0;
		yspeed = 30;
	}
	if (frame >= 8) and (frame_timer >= frame_duration - 1) {
		 frame -= 1;
	}
	//standard_smash(7,100,hiteffects.hit);
	//standard_smash(8,100,hiteffects.hit);
	if on_ground {
		with(create_shot(0,0,5,0,spr_explosion_floor,1,100,5,-5,attacktype.normal,attackstrength.heavy,hiteffects.fire)) {
			hit_limit = -1;
			duration = anim_duration;
		}
		with(create_shot(0,0,-5,0,spr_explosion_floor,1,100,-5,-5,attacktype.normal,attackstrength.heavy,hiteffects.fire)) {
			hit_limit = -1;
			duration = anim_duration;
		}
		play_sound(snd_explosion,1,1.5);
		land();
	}
}

fireshot = new state();
fireshot.start = function() {
	change_sprite(spr_genos_blast,5,false);
}
fireshot.run = function() {
	if check_frame(2) {
		with(create_shot(40,-40,15,0,spr_fireball_small,1,50,10,-3,attacktype.wall_splat,attackstrength.heavy)) {
			blend = true;
			play_sound(snd_kiblast_fire,1,0.8);
			hit_script = function() {
				create_particles(x,y,x,y,explosion_medium);
			}
		}
	}
	if state_timer > 60 {
		change_state(idle_state);
	}
}

fireshot_up = new state();
fireshot_up.start = function() {
	change_sprite(spr_genos_blast_up,5,false);
}
fireshot_up.run = function() {
	if check_frame(2) {
		with(create_shot(15,-50,5,-15,spr_fireball_small,1,100,10,-10,attacktype.wall_bounce,attackstrength.heavy)) {
			blend = true;
			play_sound(snd_kiblast_fire,1,0.8);
			hit_script = function() {
				create_particles(x,y,x,y,explosion_medium);
			}
		}
	}
	if state_timer > 60 {
		change_state(idle_state);
	}
}

fireshot_down = new state();
fireshot_down.start = function() {
	change_sprite(spr_genos_blast_down,5,false);
}
fireshot_down.run = function() {
	if check_frame(2) {
		with(create_shot(15,-10,5,15,spr_fireball_small,1,50,1,0,attacktype.hard_knockdown,attackstrength.heavy)) {
			blend = true;
			hit_limit = -1;
			active_script = function() {
				if on_ground {
					with(create_shot(0,0,1,0,spr_explosion_floor,1,50,1,-10,attacktype.normal,attackstrength.heavy)) {
						duration = anim_duration;
						hit_limit = -1;
						play_sound(snd_explosion,1,2);
					}
					duration = 0;
				}
			}
			play_sound(snd_kiblast_fire,1,0.8);
		}
	}
	if state_timer > 60 {
		change_state(idle_state);
	}
}

incinerate = new state();
incinerate.start = function() {
	if check_mp(2) {
		change_sprite(spr_genos_incinerate,5,false);
		activate_super();
		spend_mp(2);
		xspeed = 0;
		yspeed = 0;
		play_voiceline(snd_genos_incinerate);
	}
	else {
		change_state(previous_state);
	}
}
incinerate.run = function() {
	xspeed = 0;
	yspeed = 0;
	if superfreeze_active {
		if frame >= 4 {
			frame = 4;
		}
	}
	if state_timer <= 120 {
		if frame >= 6 {
			frame = 5;
			frame_timer = 1;
		}
	}
	if state_timer <= 150 {
		if frame >= anim_frames - 1 {
			frame -= 1;
		}
	}
	if check_frame(5) {
		play_sound(snd_dbz_beam_fire);
	}
	if value_in_range(frame,5,6) {
		fire_beam_attack(spr_incinerate,0.3,1);
	}
	return_to_idle();
}

super_incinerate = new state();
super_incinerate.start = function() {
	if check_mp(3) {
		change_sprite(spr_genos_incinerate2,5,false);
		activate_super();
		spend_mp(3);
		xspeed = 0;
		yspeed = 0;
		play_voiceline(snd_genos_incinerate);
	}
	else {
		change_state(previous_state);
	}
}
super_incinerate.run = function() {
	xspeed = 0;
	yspeed = 0;
	if superfreeze_active {
		if frame >= 4 {
			frame = 4;
		}
	}
	if state_timer <= 120 {
		if frame >= 6 {
			frame = 5;
			frame_timer = 1;
		}
	}
	if state_timer <= 150 {
		if frame >= anim_frames - 1 {
			frame -= 1;
		}
	}
	if check_frame(5) {
		play_sound(snd_dbz_beam_fire,1,0.8);
	}
	if value_in_range(frame,5,6) {
		fire_beam_attack(spr_incinerate,1,1);
	}
	return_to_idle();
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
			change_sprite(spr_genos_blast,3,false);
		}
	}
	else {
		fireshot.run();
	}
}
assist_a_state.stop = function() {
	fireshot.stop();
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
			change_sprite(spr_genos_flyingkick,3,false);
		}
	}
	else {
		dash_attack.run();
	}
}

assist_c_state = new state();
assist_c_state.start = function() {
	x += (20 * facing);
}
assist_c_state.run = function() {
	if sprite == air_down_sprite {
		if on_ground {
			yspeed = 0;
			change_sprite(spr_genos_incinerate,5,false);
		}
	}
	else {
		incinerate.run();
		if state_timer > 60 {
			change_state(tag_out_state);
		}
	}
}

max_air_moves = 3;

setup_autocombo();
add_move(dropkick,"D");
add_move(fireshot,"B");
add_move(fireshot_up,"4B");
add_move(fireshot_down,"2B");
add_move(incinerate,"236B");
add_move(incinerate,"214B");
add_move(super_incinerate,"41236B");
add_move(super_incinerate,"63214B");

ai_script = function() {
	if target_distance < 100 {
		ai_input_move(dropkick,10);
	}
	if target_distance > 150 {
		ai_input_move(fireshot,1);
		ai_input_move(incinerate,10);
		ai_input_move(super_incinerate,10);
	}
}

var i = 0;
voice_attack[i++] = snd_genos_attack1;
voice_attack[i++] = snd_genos_attack2;
voice_attack[i++] = snd_genos_attack3;
i = 0;
voice_heavyattack[i++] = snd_genos_heavyattack1;
voice_heavyattack[i++] = snd_genos_heavyattack2;
i = 0;
voice_hurt[i++] = snd_genos_hurt1;
voice_hurt[i++] = snd_genos_hurt2;
voice_hurt[i++] = snd_genos_hurt3;
i = 0;
voice_hurt_heavy[i++] = snd_genos_hurt_heavy1;
voice_hurt_heavy[i++] = snd_genos_hurt_heavy2;
voice_hurt_heavy[i++] = snd_genos_hurt_heavy3;
i = 0;
voice_grabbed[i++] = snd_genos_grabbed1;

draw_script = function() {
	if sprite == spr_genos_blast {
		gpu_set_blendmode(bm_add);
		if frame == 2 {
			var _x = x + (lengthdir_x(24,rotation*facing) * facing);
			var _y = y - 40;
			var _scale = (frame_timer + 1) / (frame_duration * 1.5);
			draw_sprite_ext(
				spr_fire_spark,
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
	if sprite == spr_genos_blast_up {
		gpu_set_blendmode(bm_add);
		if frame == 2 {
			var _x = x + (lengthdir_x(16,rotation*facing) * facing);
			var _y = y - 45;
			var _scale = (frame_timer + 1) / (frame_duration * 1.5);
			draw_sprite_ext(
				spr_fire_spark,
				frame mod 2,
				_x,
				_y,
				facing * _scale,
				_scale,
				(rotation+45)*facing,
				c_white,
				1
			);
		}
	}
	if sprite == spr_genos_blast_down {
		gpu_set_blendmode(bm_add);
		if frame == 2 {
			var _x = x + (lengthdir_x(24,rotation*facing) * facing);
			var _y = y - 24;
			var _scale = (frame_timer + 1) / (frame_duration * 1.5);
			draw_sprite_ext(
				spr_fire_spark,
				frame mod 2,
				_x,
				_y,
				facing * _scale,
				_scale,
				(rotation-45)*facing,
				c_white,
				1
			);
		}
	}
	if sprite == spr_genos_incinerate {
		gpu_set_blendmode(bm_add);
		if value_in_range(frame,5,6) {
			var _x = x + (10 * facing);
			var _y = y - 30;
			var _scale = (frame_timer + 1) / (frame_duration / 1.5);
			draw_sprite_ext(
				spr_fire_spark,
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
				spr_incinerate_origin,
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
	if sprite == spr_genos_incinerate2 {
		gpu_set_blendmode(bm_add);
		if value_in_range(frame,5,6) {
			var _x = x + (15 * facing);
			var _y = y - 30;
			var _scale = (frame_timer + 1) / (frame_duration / 2);
			draw_sprite_ext(
				spr_fire_spark,
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
				spr_incinerate2_origin,
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