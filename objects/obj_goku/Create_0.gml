/// @description Insert description here
// You can write your code in this editor
event_inherited();

init_charsprites("goku");

name = "Goku";
theme = mus_dbfz_goku;

max_air_moves = 3;

max_kiblasts = 7;
kiblast_count = 0;

kamehameha_cooldown = 0;
kamehameha_cooldown_duration = 150;

kaioken_active = false;
kaioken_timer = 0;
kaioken_duration = 10 * 60;
kaioken_buff = 1.25;
kaioken_color = make_color_rgb(255,128,128);

spirit_bomb = noone;

next_form = obj_goku_ssj;

char_script = function() {
	kamehameha_cooldown -= 1;
	
	var _kaioken_active = kaioken_active;
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
			attack_power += kaioken_buff;
		}
		else {
			flash_sprite();
			attack_power -= kaioken_buff;
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
		change_sprite(spr_goku_attack_punch_straight,3,false);
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
	check_moves();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_attack_elbow_bash,4,false);
	play_sound(snd_punch_whiff_medium);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	basic_attack(2,30,attackstrength.medium,hiteffects.hit);
	if check_frame(2) {
		xspeed = 5 * facing;
		yspeed = 0;
	}
	return_to_idle();
	check_moves();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_attack_kick_side,5,false);
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
	change_sprite(spr_goku_attack_spin_kick,2,false);
	play_sound(snd_punch_whiff_medium);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	basic_attack(4,30,attackstrength.medium,hiteffects.hit);
	return_to_idle();
	check_moves();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_attack_backflip_kick,3,false);
	play_sound(snd_punch_whiff_heavy);
	play_voiceline(voice_heavyattack,50,false);
}
autocombo[i].run = function() {
	basic_launcher(3,50,hiteffects.hit);
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_attack_punch_straight,3,false);
	play_sound(snd_punch_whiff_light);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	basic_attack(2,10,attackstrength.light,hiteffects.hit);
	return_to_idle();
	check_moves();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_attack_elbow_bash,3,false);
	play_sound(snd_punch_whiff_medium);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	basic_attack(2,30,attackstrength.medium,hiteffects.hit);
	if check_frame(2) {
		xspeed = 5 * facing;
		yspeed = 0;
	}
	return_to_idle();
	check_moves();
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_attack_kick_arc,4,false);
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
	change_sprite(spr_goku_attack_spin_kick_double,2,false);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	if check_frame(2) or check_frame(6) {
		play_sound(snd_punch_whiff_medium);
	}
	basic_attack(4,20,attackstrength.medium,hiteffects.hit);
	basic_attack(8,20,attackstrength.medium,hiteffects.hit);
	return_to_idle();
	if frame >= 10 {
		check_moves();
	}
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_attack_triple_kick,2,false);
	play_voiceline(voice_attack,50,false);
}
autocombo[i].run = function() {
	if check_frame(2) or check_frame(4) or check_frame(6) {
		play_sound(snd_punch_whiff_light);
	}
	basic_attack(3,10,attackstrength.light,hiteffects.hit);
	basic_attack(5,10,attackstrength.light,hiteffects.hit);
	basic_attack(7,10,attackstrength.light,hiteffects.hit);
	return_to_idle();
	if frame >= 8 {
		check_moves();
	}
}
i++;

autocombo[i] = new state();
autocombo[i].start = function() {
	change_sprite(spr_goku_attack_smash,4,false);
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
	change_sprite(spr_goku_special_spiritbomb,4,false);
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

dragon_fist = new state();
dragon_fist.start = function() {
	if check_mp(1) {
		change_sprite(spr_goku_attack_punch_gut,8,false);
		activate_super();
		spend_mp(1);
	}
	else {
		change_state(previous_state);
	}
}
dragon_fist.run = function() {
	if superfreeze_active {
		frame = 0;
	}
	if check_frame(1) {
		xspeed = -5 * facing;
	}
	if check_frame(2) {
		xspeed = 0;
		play_sound(snd_punch_whiff_heavy);
	}
	if check_frame(3) {
		xspeed = 30 * facing;
		create_hitbox(0,-height_half,width,height_half,50,0,0,attacktype.unblockable,attackstrength.super,hiteffects.hit);
	}
	if check_frame(4) {
		xspeed /= 10;
		if can_cancel {
			create_hitbox(0,-height_half,width,height_half,100,20,-2,attacktype.hard_knockdown,attackstrength.super,hiteffects.none);
		}
	}
	if (state_timer > 60) {
		return_to_idle();
	}
}

kiblast = new state();
kiblast.start = function() {
	change_sprite(spr_goku_special_ki_blast,2,false);
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
			if sprite == spr_goku_special_ki_blast {
				change_sprite(spr_goku_special_ki_blast2,frame_duration,false);
			}
			else {
				change_sprite(spr_goku_special_ki_blast,frame_duration,false);
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

kiai_push = new state();
kiai_push.start = function() {
	if check_mp(1) {
		activate_super();
		spend_mp(1);
		change_sprite(spr_goku_special_ki_blast,3,false);
	}
	else {
		change_state(previous_state)
	}
}
kiai_push.run = function() {
	if superfreeze_active {
		frame = 0;
	}
	if check_frame(3) {
		create_particles(x,y-height_half,x,y-height_half,shockwave_particle);
		create_hitbox(-50,-150,200,200,100,20,-5,attacktype.hard_knockdown,attackstrength.light,hiteffects.none);
	}
	if state_timer > 60 {
		return_to_idle();
	}
}

kamehameha = new state();
kamehameha.start = function() {
	if kamehameha_cooldown <= 0 {
		change_sprite(spr_goku_special_kamehameha,5,false);
		if is_airborne {
			change_sprite(spr_goku_special_kamehameha_air,frame_duration,false);
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
		fire_beam(20,-25,spr_kamehameha,0.5,0,10);
	}
	return_to_idle();
}

super_kamehameha = new state();
super_kamehameha.start = function() {
	if kamehameha_cooldown <= 0 and check_mp(2) {
		change_sprite(spr_goku_special_kamehameha,5,false);
		if is_airborne {
			change_sprite(spr_goku_special_kamehameha_air,frame_duration,false);
		}
		activate_super(320);
		spend_mp(2);
		xspeed = 0;
		yspeed = 0;
		kamehameha_cooldown = kamehameha_cooldown_duration * 1.5;
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
		if superfreeze_timer == 15 {
			if input.forward {
				play_sound(snd_dbz_teleport_long);
				x = target_x + ((width + target.width) * facing);
				y = target_y;
				face_target();
				if target.on_wall {
					with(target) {
						x += (width * other.facing);
					}
				}
				
				var _frame = frame;
				change_sprite(spr_goku_special_kamehameha_air,frame_duration,false);
				frame = _frame;
			}
		}
	}
	if state_timer <= 120 {
		if frame >= 9 {
			frame = 6;
			frame_timer = 1;
		}
	}
	if value_in_range(frame,6,9) {
		fire_beam(20,-25,spr_kamehameha,1,0,10);
		shake_screen(5,3);
	}
	if check_frame(3) {
		play_voiceline(snd_goku_kamehameha_charge);
		play_sound(snd_dbz_beam_charge_long);
	}
	if check_frame(6) {
		play_voiceline(snd_goku_kamehameha_fire);
		play_sound(snd_dbz_beam_fire2);
	}
	return_to_idle();
}

meteor_combo = new state();
meteor_combo.start = function() {
	if on_ground and check_mp(1) {
		change_sprite(spr_goku_attack_punch_straight,3,false);
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
	if can_cancel {
		sprite_sequence(
			[
				spr_goku_attack_punch_straight,
				spr_goku_attack_elbow_bash,
				spr_goku_attack_kick_side,
				spr_goku_attack_kick_arc,
				spr_goku_attack_backflip_kick,
				spr_goku_special_kamehameha_air
			],
			frame_duration
		);
	}
	if sprite == spr_goku_special_kamehameha_air {
		if check_frame(1) {
			play_sound(snd_dbz_teleport_short);
			x = target_x - (100 * facing);
			y = target_y - 50;
		}
		kamehameha.run();
	}
	else {
		if sprite == spr_goku_attack_backflip_kick {
			if check_frame(3) {
				create_hitbox(0,-height,width,height,40,3,-10,attacktype.normal,attackstrength.heavy,hiteffects.hit);
			}
			if check_frame(2) {
				xspeed = 3 * facing;
				yspeed = -5;
				play_sound(snd_punch_whiff_heavy2);
			}
		}
		else {
			basic_attack(2,40,attackstrength.medium,hiteffects.hit);
			if check_frame(1) {
				xspeed = 10 * facing;
				play_sound(snd_punch_whiff_medium);
			}
		}
	}
	return_to_idle();
}

kaioken = new state();
kaioken.start = function() {
	if check_mp(1) and (!kaioken_timer) {
		change_sprite(charge_sprite,3,true);
		flash_sprite();
		color = kaioken_color;
		
		activate_super(100);
		spend_mp(1);
		kaioken_timer = kaioken_duration;
		
		play_sound(snd_energy_surge);
		play_voiceline(snd_goku_kaioken);
	}
	else {
		change_state(previous_state);
	}
}
kaioken.run = function() {
	xspeed = 0;
	yspeed = 0;
	if !superfreeze_active {
		change_state(idle_state);
	}
}

genkidama = new state();
genkidama.start = function() {
	if check_mp(4) and !kaioken_active {
		change_sprite(spr_goku_special_spiritbomb,5,false);
		activate_ultimate();
		spend_mp(4);
		xspeed = 0;
		yspeed = 0;
		y = target_y - 200;
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
		spirit_bomb = create_shot(0,-200,0,0,spr_genkidama,0.5,0,0,0,attacktype.unblockable,attackstrength.heavy,hiteffects.none)
		with(spirit_bomb) {
			play_sound(snd_activate_super,1,2);
			duration = -1;
			hit_limit = -1;
			active_script = function() {
				if owner.sprite == spr_goku_special_spiritbomb and owner.frame >= 9 {
					xspeed += 1/15 * owner.facing;
					yspeed = abs(xspeed);
				}
				if owner.is_hit {
					duration = 0;
				}
				for(var i = 0; i < ds_list_size(hitbox.hit_list); i++) {
					with(ds_list_find_value(hitbox.hit_list,i)) {
						hitstop = 10;
						x = lerp(x,other.x,0.5);
						y = lerp(y,other.y + height_half,0.5);
					}
				}
				x = clamp(x, left_wall, right_wall);
				if y >= ground_height {
					duration = 0;
					for(var i = 0; i < ds_list_size(hitbox.hit_list); i++) {
						with(ds_list_find_value(hitbox.hit_list,i)) {
							get_hit(other,520,1,-12,attacktype.hard_knockdown,attackstrength.ultimate,hiteffects.none);
							x = other.x;
							y = ground_height - 1;
							shake_screen(20,5);
						}
					}
					create_particles(x,y,x,y,explosion_large);
				}
			}
		}
	}
	if check_frame(6) {
		play_voiceline(snd_goku_spiritbomb);
	}
	if frame > 11 {
		if instance_exists(spirit_bomb) {
			frame = 10;
		}
	}
	return_to_idle();
}

setup_autocombo();

add_move(dragon_fist,"EA");
add_move(meteor_combo,"EEA");

add_move(kiblast,"B");
add_move(kiai_push,"EB");

add_move(kamehameha,"C");
add_move(super_kamehameha,"EC");

add_move(kaioken,"D");
add_move(genkidama,"ED");

ai_script = function() {
	if target_distance < 50 {
		ai_input_move(meteor_combo,10);
		ai_input_move(kaioken,10);
	}
	else if target_distance > 150 {
		ai_input_move(kiblast,10);
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
i = 0;
voice_powerup[i++] = snd_goku_powerup;

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
	if sprite == spr_goku_special_ki_blast
	or sprite == spr_goku_special_ki_blast2 {
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
	if sprite == spr_goku_special_kamehameha
	or sprite == spr_goku_special_kamehameha_air {
		gpu_set_blendmode(bm_add);
		if value_in_range(frame,3,5) {
			var _x = x - (10 * facing);
			var _y = y - 25;
			var _scale = anim_timer / 120;
			draw_sprite_ext(
				spr_kamehameha_charge,
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