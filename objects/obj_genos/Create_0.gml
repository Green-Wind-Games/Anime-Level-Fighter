/// @description Insert description here
// You can write your code in this editor
event_inherited();

init_charsprites("genos");

name = "Genos";
theme = mus_opm_genos;

move_speed *= 1.5;
max_air_moves = 3;

dropkick_cooldown = 0;
dropkick_cooldown_duration = 100;

incinerate_cooldown = 0;
incinerate_cooldown_duration = 150;

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

char_script = function() {
	incinerate_cooldown -= 1;
	dropkick_cooldown -= 1;
}

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
	check_moves();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_genos_attack_punch_straight,2,true);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	if state_timer mod 5 == 0 {
		repeat(3) {
			with(create_shot(
				0,
				(-height) + random(height_half),
				30,
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
				duration = 10;
			}
		}
	}
	play_sound(snd_punch_whiff_medium);
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
	change_sprite(spr_genos_attack_uppercut,3,false);
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
	check_moves();
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
	check_moves();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_genos_attack_kick_straight,4,false);
	play_sound(snd_punch_whiff_medium);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	basic_attack(2,30,attackstrength.medium,hiteffects.hit);
	return_to_idle();
	check_moves();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_genos_attack_kick_up,2,false);
	play_voiceline(voice_attack,50,false);
	play_sound(snd_punch_whiff_medium);
}
autocombo[i].run = function() {
	basic_attack(2,30,attackstrength.medium,hiteffects.hit);
	return_to_idle();
	if frame >= 10 {
		check_moves();
	}
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
		change_sprite(spr_genos_special_dropkick,8,false);
		dropkick_cooldown = dropkick_cooldown_duration;
		xspeed = 10 * facing;
		yspeed = -10;
	}
	else {
		change_state(previous_state);
	}
}
dropkick.run = function() {
	if check_frame(4) {
		xspeed = 0;
		play_sound(snd_punch_whiff_heavy);
	}
	if check_frame(6) {
		yspeed = 10;
	}
	if on_ground and yspeed > 0 {
		create_shot(width_half,0,1,-2,spr_explosion,1,100,10,-10,attacktype.unblockable,attackstrength.heavy,hiteffects.fire);
		create_shot(-width_half,0,-1,-2,spr_explosion,1,100,10,-10,attacktype.unblockable,attackstrength.heavy,hiteffects.fire);
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
	if state_timer > 60 {
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
		change_sprite(spr_genos_special_incinerate2,5,false);
		activate_super(320);
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
		if frame > 5 {
			frame = 5;
		}
	}
	if state_timer <= 120 {
		if frame > 7 {
			frame = 6;
			frame_timer = 1;
		}
	}
	if value_in_range(frame,6,7) {
		fire_beam(20,-25,spr_incinerate,1,0,10);
		shake_screen(5,3);
	}
	if check_frame(4) {
		play_sound(snd_dbz_beam_charge_long);
	}
	if check_frame(6) {
		play_voiceline(snd_genos_incinerate);
		play_sound(snd_dbz_beam_fire2);
	}
	return_to_idle();
}

setup_autocombo();

add_move(dropkick,"EA");

add_move(fireblast,"B");

add_move(incinerate,"C");

add_move(super_incinerate,"D");

ai_script = function() {
	if target_distance < 50 {
		ai_input_move(meteor_combo,10);
		ai_input_move(kaioken,10);
	}
	else if target_distance > 150 {
		ai_input_move(kiblast,10);
		ai_input_move(incinerate,10);
		ai_input_move(super_incinerate,10);
		ai_input_move(spirit_bomb,10);
	}
}

victory_state.run = function() {
	kaioken_timer = 0;
	if check_frame(4) {
		yspeed = -5;
		squash_stretch(0.9,1.1);
	}
	if on_ground {
		if yspeed > 0 {
			squash_stretch(1.1,0.9);
			yspeed = 0;
			frame = 2;
		}
	}
}

draw_script = function() {
	if sprite == spr_genos_special_ki_blast
	or sprite == spr_genos_special_ki_blast2 {
		gpu_set_blendmode(bm_add);
		if frame == 3 {
			var _x = x + (28 * facing);
			var _y = y - 32;
			var _scale = 1 / 2;
			//draw_sprite_ext(
			//	spr_ki_spark,
			//	frame_timer,
			//	_x,
			//	_y,
			//	facing * _scale,
			//	_scale,
			//	rotation*facing,
			//	c_white,
			//	1
			//);
		}
	}
	if sprite == spr_genos_special_incinerate
	or sprite == spr_genos_special_incinerate_air {
		gpu_set_blendmode(bm_add);
		if value_in_range(frame,3,5) {
			var _x = x - (10 * facing);
			var _y = y - 25;
			var _scale = anim_timer / 120;
			draw_sprite_ext(
				spr_incinerate_charge,
				0,
				_x,
				_y,
				_scale,
				_scale,
				anim_timer * 5,
				c_white,
				1
			);
		}
	}
	gpu_set_blendmode(bm_normal);
}