/// @description Insert description here
// You can write your code in this editor
event_inherited();

init_charsprites("goku");

name = "Goku";

theme = mus_dbfz_goku;

kamehameha_cooldown = 0;
kamehameha_cooldown_duration = 200;
kaioken_active = false;
kaioken_timer = 0;
kaioken_duration = 5 * 60;
kaioken_buff = 2;

spirit_bomb = noone;

char_script = function() {
	kamehameha_cooldown -= 1;
	
	var _kaioken_active = kaioken_active;
	var kaioken_color = make_color_rgb(255,128,128);
	if kaioken_timer-- > 0 {
		kaioken_active = true;
		if kaioken_timer mod 10 == 0 {
			hp -= 1;
		}
		color = kaioken_color;
	}
	else {
		kaioken_active = false;
	}
	if kaioken_active != _kaioken_active {
		if kaioken_active {
			attack_power *= kaioken_buff;
		}
		else {
			flash_sprite();
			attack_power /= kaioken_buff;
			if color == kaioken_color {
				color = c_white;
			}
		}
	}
}

var i = 0;
autocombo[i] = new state();
autocombo[i].start = function() {
	if on_ground {
		change_sprite(spr_goku_jab,3,false);
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
	change_sprite(spr_goku_elbowbash,4,false);
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
	change_sprite(spr_goku_kick2,5,false);
	play_sound(snd_punch_whiff_medium);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	basic_attack(2,30,attackstrength.light,hiteffects.hit);
	return_to_idle();
	check_moves();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_backflipkick,3,false);
	play_sound(snd_punch_whiff_heavy);
	play_voiceline(voice_heavyattack,50,false);
}
autocombo[i].run = function() {
	basic_launcher(3,50,hiteffects.hit);
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_jab,3,false);
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
	change_sprite(spr_goku_elbowbash,3,false);
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
	change_sprite(spr_goku_kick,4,false);
	play_sound(snd_punch_whiff_medium);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	basic_attack(2,40,attackstrength.medium,hiteffects.hit);
	return_to_idle();
	check_moves();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_doublespinkick,2,false);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	if check_frame(2) or check_frame(6) {
		play_sound(snd_punch_whiff_medium);
	}
	basic_attack(4,30,attackstrength.medium,hiteffects.hit);
	basic_attack(8,30,attackstrength.medium,hiteffects.hit);
	return_to_idle();
	if frame >= 10 {
		check_moves();
	}
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_triplekick,2,false);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	if check_frame(2) or check_frame(4) or check_frame(6) {
		play_sound(snd_punch_whiff_light);
	}
	basic_attack(3,20,attackstrength.light,hiteffects.hit);
	basic_attack(5,20,attackstrength.light,hiteffects.hit);
	basic_attack(7,20,attackstrength.light,hiteffects.hit);
	return_to_idle();
	if frame >= 8 {
		check_moves();
	}
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_axehandle,4,false);
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
	change_sprite(spr_goku_genkidama,4,false);
	with(grabbed) {
		change_sprite(grabbed_body_sprite,1000,false);
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

kaioken = new state();
kaioken.start = function() {
	if check_mp(1) and (!kaioken_timer) {
		spend_mp(1);
		kaioken_timer = kaioken_duration;
		play_sound(snd_activate_super);
	}
	change_state(idle_state);
}

kiblast = new state();
kiblast.start = function() {
	change_sprite(spr_goku_kiblast,2,false);
}
kiblast.run = function() {
	if check_frame(3) {
		create_kiblast(20,-35,spr_kiblast_blue);
		if is_airborne {
			xspeed = -2 * facing;
			yspeed = -2;
		}
		kiblast_count += 1;
	}
	if frame > 3 {
		if kiblast_count < max_kiblasts {
			if sprite == spr_goku_kiblast {
				change_sprite(spr_goku_kiblast2,frame_duration,false);
			}
			else {
				change_sprite(spr_goku_kiblast,frame_duration,false);
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
			change_sprite(spr_goku_kamehameha,4,false);
		}
		else {
			change_sprite(spr_goku_kamehameha_air,4,false);
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
		play_sound(snd_dbz_beam_fire);
	}
	if value_in_range(frame,6,9) {
		fire_beam_attack(spr_kamehameha,0.5,3);
	}
	return_to_idle();
}

super_kamehameha = new state();
super_kamehameha.start = function() {
	if kamehameha_cooldown <= 0 and check_mp(2) {
		change_sprite(spr_goku_kamehameha,2,false);
		if is_airborne {
			change_sprite(spr_goku_kamehameha_air,frame_duration,false);
		}
		superfreeze(6 * 60);
		spend_mp(2);
		xspeed = 0;
		yspeed = 0;
		kamehameha_cooldown = kamehameha_cooldown_duration * 2;
		play_sound(snd_activate_super);
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
	if check_frame(3) {
		play_voiceline(snd_goku_kamehameha_charge);
		play_sound(snd_dbz_beam_charge_long);
	}
	if check_frame(6) {
		play_voiceline(snd_goku_kamehameha_fire);
		play_sound(snd_dbz_beam_fire2);
	}
	if value_in_range(frame,6,9) {
		fire_beam_attack(spr_kamehameha,1,1);
	}
	return_to_idle();
}
super_kamehameha.stop = function() {
	deactivate_super();
}

genkidama = new state();
genkidama.start = function() {
	if check_mp(4) {
		change_sprite(spr_goku_genkidama,5,false);
		superfreeze();
		spend_mp(4);
		xspeed = 0;
		yspeed = 0;
		y = target_y - (game_height * 0.75);
		play_sound(snd_activate_ultimate);
	}
	else {
		change_state(previous_state);
	}
}
genkidama.run = function() {
	xspeed = 0;
	yspeed = 0;
	if superfreeze_active {
		if frame > 5 {
			frame = 2;
			frame_timer = 1;
		}
	}
	if check_frame(2) {
		spirit_bomb = create_shot(0,-200,0,0,spr_genkidama,1,0,0,0,attacktype.normal,attackstrength.heavy,hiteffects.hit)
		with(spirit_bomb) {
			duration = -1;
			hit_limit = -1;
			active_script = function() {
				if owner.sprite == spr_goku_genkidama and owner.frame >= 9 {
					xspeed += 0.1 * owner.facing;
					yspeed += 0.1;
				}
				if owner.is_hit {
					duration = 0;
				}
				for(var i = 0; i < ds_list_size(hitbox.hit_list); i++) {
					with(ds_list_find_value(hitbox.hit_list,i)) {
						x = other.x;
						y = other.y;
						hitstun = 60;
						change_state(hit_state);
					}
				}
				if y >= ground_height {
					duration = 0;
					for(var i = 0; i < ds_list_size(hitbox.hit_list); i++) {
						with(ds_list_find_value(hitbox.hit_list,i)) {
							get_hit(other,500,0,-12,attacktype.hard_knockdown,attackstrength.ultimate,hiteffects.hit,hitanims.spinout);
							x = other.x;
							y = ground_height - 1;
						}
					}
					create_particles(x,y,x,y,explosion_large);
				}
			}
		}
	}
	if frame > 11 {
		if instance_exists(spirit_bomb) {
			frame = 10;
			frame_timer = 0;
		}
	}
	return_to_idle();
}
genkidama.stop = function() {
	deactivate_super();
}

meteor_combo = new state();
meteor_combo.start = function() {
	if on_ground and check_mp(1) {
		change_sprite(spr_goku_jab,3,false);
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
			frame_duration
		);
	}
	if sprite == spr_goku_kamehameha_air {
		frame_duration = 8;
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

max_air_moves = 3;

max_kiblasts = 7;
kiblast_count = 0;
setup_autocombo();

add_move(kiblast,"B");
add_move(kamehameha,"6B");
add_move(kamehameha,"4B");

add_move(super_kamehameha,"C");
add_move(meteor_combo,"6C");
add_move(kaioken,"2C");

add_move(genkidama,"D");

ai_script = function() {
	ai_input_move(kaioken,1);
	if target_distance_x < 50 {
		ai_input_move(meteor_combo,10);
	}
	if target_distance > 150 {
		ai_input_move(kiblast,1);
		ai_input_move(kamehameha,10);
		ai_input_move(super_kamehameha,10);
		ai_input_move(genkidama,10);
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

victory_state.run = function() {
	kaioken_timer = 0;
	if check_frame(4) {
		yspeed = -jump_speed / 2;
		squash_stretch(0.9,1.1);
	}
	if on_ground {
		if yspeed > 0 {
			squash_stretch(1.1,0.9);
			yspeed = 0;
			frame = 2;
			frame_timer = 0;
		}
	}
}

draw_script = function() {
	if sprite == spr_goku_kiblast
	or sprite == spr_goku_kiblast2 {
		gpu_set_blendmode(bm_add);
		if frame == 3 {
			var _x = x + (32 * facing);
			var _y = y - 32;
			var _scale = 1;
			draw_sprite_ext(
				spr_ki_spark,
				frame_timer,
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
	if sprite == spr_goku_kamehameha
	or sprite == spr_goku_kamehameha_air {
		gpu_set_blendmode(bm_add);
		if value_in_range(frame,3,5) {
			var _x = x - (10 * facing);
			var _y = y - 25;
			var _scale = anim_timer / 50;
			draw_sprite_ext(
				spr_kamehameha_charge,
				state_timer,
				_x,
				_y,
				_scale,
				_scale,
				rotation*facing,
				c_white,
				1
			);
		}
	}
	gpu_set_blendmode(bm_normal);
}