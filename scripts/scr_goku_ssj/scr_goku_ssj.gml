function init_goku_ssj() {
	init_charsprites("goku_ssj");

	name = "Goku Super Saiyajin";
	theme = mus_dbfz_space;

	max_air_moves = 3;
	
	kamehameha_cooldown = 0;
	kamehameha_cooldown_duration = 150;

	ssj2_active = false;
	ssj2_timer = 0;
	ssj2_duration = 30 * 60;
	ssj2_mp_drain = ceil(mp_stock_size / (5 * 60))
	ssj2_buff = 1.10;

	//next_form = obj_goku_ssj3;
	transform_aura = spr_aura_dbz_yellow;
	charge_aura = spr_aura_dbz_yellow;
	
	add_kiblast_state(
		7,
		spr_goku_ssj_special_ki_blast,
		spr_goku_ssj_special_ki_blast2,
		spr_kiblast_yellow
	);
	
	init_charaudio("goku");

	char_script = function() {
		kamehameha_cooldown -= 1;
		var _ssj2_active = ssj2_active;
		if dead or (mp <= 0) {
			ssj2_timer = 0;
		}
		if ssj2_timer-- > 0 {
			ssj2_active = true;
			mp -= ssj2_mp_drain;
			if ssj2_timer mod 30 == 1 {
				ssj2_sparks();
			}
		}
		else {
			ssj2_active = false;
		}
		if ssj2_active != _ssj2_active {
			if ssj2_active {
				attack_power = ssj2_buff;
				move_speed_buff = ssj2_buff;
			}
			else {
				flash_sprite();
				play_sound(snd_energy_stop);
				attack_power = 1;
				move_speed_buff = 1;
				aura_sprite = noone;
			}
		}
	}

	//ai_script = function() {
	//	if ssj2_active {
	//		if target_distance < 50 {
	//			ai_input_move(autocombo[0],100);
	//		}
	//		else {
	//			ai_input_move(dash_state,50);
	//		}
	//	}
	//	else {
	//		ai_input_move(activate_ssj2,10);
	//		ai_input_move(spirit_bomb,10);
	//	}
	//	if target_distance < 20 {
	//		ai_input_move(dragon_fist,10);
	//		ai_input_move(meteor_combo,10);
	//		ai_input_move(kiai_push,10);
	//	}
	//	else if target_distance > 200 {
	//		ai_input_move(kiblast,10);
	//		ai_input_move(kamehameha,10);
	//		ai_input_move(super_kamehameha,10);
	//	}
	//}

	light_attack = new state();
	light_attack.start = function() {
		if on_ground {
			change_sprite(spr_goku_ssj_attack_punch_straight,2,false);
			play_sound(snd_punch_whiff_light);
			play_voiceline(voice_attack,50,false);
		}
		else {
			change_state(light_airattack);
		}
	}
	light_attack.run = function() {
		basic_light_attack(2,hiteffects.hit);
	}

	medium_attack = new state();
	medium_attack.start = function() {
		if on_ground {
			change_sprite(spr_goku_ssj_attack_elbow_bash,4,false);
			play_sound(snd_punch_whiff_medium);
			play_voiceline(voice_attack,50,false);
		}
		else {
			change_state(medium_airattack);
		}
	}
	medium_attack.run = function() {
		basic_medium_attack(2,hiteffects.hit);
	}

	heavy_attack = new state();
	heavy_attack.start = function() {
		if on_ground {
			change_sprite(spr_goku_ssj_attack_kick_side,5,false);
			play_sound(snd_punch_whiff_heavy);
			play_voiceline(voice_heavyattack,50,false);
		}
		else {
			change_state(heavy_airattack);
		}
	}
	heavy_attack.run = function() {
		basic_heavy_attack(2,hiteffects.hit);
	}
	
	light_lowattack = new state();
	light_lowattack.start = function() {
		if on_ground {
			change_sprite(spr_goku_ssj_attack_kick_air,2,false);
			xspeed = 5 * facing;
			yspeed = -8;
			play_sound(snd_punch_whiff_light);
			play_voiceline(voice_attack,50,false);
		}
		else {
			change_state(light_airattack);
		}
	}
	light_lowattack.run = function() {
		basic_light_airattack(2,hiteffects.hit)
	}

	medium_lowattack = new state();
	medium_lowattack.start = function() {
		if on_ground {
			change_sprite(spr_goku_ssj_attack_spin_kick_double,5,false);
			play_sound(snd_punch_whiff_medium);
			play_voiceline(voice_attack,50,false);
		}
		else {
			change_state(medium_airattack);
		}
	}
	medium_lowattack.run = function() {
		basic_medium_attack(4,hiteffects.hit);
		basic_medium_lowattack(8,hiteffects.hit);
	}

	heavy_lowattack = new state();
	heavy_lowattack.start = function() {
		if on_ground {
			change_sprite(spr_goku_ssj_attack_backflip_kick,3,false);
			play_sound(snd_punch_whiff_heavy);
			play_voiceline(voice_heavyattack,50,false);
		}
		else {
			change_state(heavy_airattack);
		}
	}
	heavy_lowattack.run = function() {
		basic_heavy_lowattack(3,hiteffects.hit);
	}
	
	light_airattack = new state();
	light_airattack.start = function() {
		change_sprite(spr_goku_ssj_attack_triple_kick,2,false);
		play_sound(snd_punch_whiff_light);
		play_voiceline(voice_attack,50,false);
	}
	light_attack.run = function() {
		basic_light_airattack(3,hiteffects.hit);
		basic_light_airattack(5,hiteffects.hit);
		basic_light_airattack(7,hiteffects.hit);
	}

	medium_airattack = new state();
	medium_airattack.start = function() {
		change_sprite(spr_goku_ssj_attack_spin_kick,2,false);
		play_sound(snd_punch_whiff_medium);
		play_voiceline(voice_attack,50,false);
	}
	medium_airattack.run = function() {
		basic_medium_airattack(4,hiteffects.hit);
	}

	heavy_airattack = new state();
	heavy_airattack.start = function() {
		change_sprite(spr_goku_ssj_attack_smash,5,false);
		play_sound(snd_punch_whiff_super);
		play_voiceline(voice_heavyattack,100,true);
	}
	heavy_airattack.run = function() {
		basic_heavy_airattack(2,hiteffects.hit);
	}

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
			change_sprite(spr_goku_ssj_attack_punch_straight,8,false);
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
			xspeed = 20 * facing;
			play_sound(snd_punch_whiff_ultimate);
		}
		if check_frame(2) {
			create_hitbox(0,-height_half,width,height_half,150,40,-2,attacktype.wall_bounce,attackstrength.super,hiteffects.hit);
		}
		if check_frame(3) {
			xspeed /= 10;
		}
		if (state_timer > 50) {
			return_to_idle();
		}
	}

	ki_blast_cannon = new state();
	ki_blast_cannon.start = function() {
		if check_mp(1) {
			activate_super();
			spend_mp(1);
			change_sprite(spr_goku_ssj_special_ki_blast,3,false);
		}
		else {
			change_state(previous_state)
		}
	}
	ki_blast_cannon.run = function() {
		if superfreeze_active {
			frame = 0;
		}
		if check_frame(3) {
			var _blast = create_shot(
				25,
				-35,
				1,
				0,
				spr_kiblast_cannon,
				1,
				100,
				30,
				-2,
				attacktype.hard_knockdown,
				attackstrength.super,
				hiteffects.fire
			);
			with(_blast) {
				duration = anim_duration;
				hit_limit = -1;
				play_sound(snd_dbz_beam_fire);
			}
		}
		if state_timer > 60 {
			return_to_idle();
		}
	}

	kamehameha_light = new state();
	kamehameha_light.start = function() {
		if kamehameha_cooldown <= 0 {
			change_sprite(spr_goku_ssj_special_kamehameha,5,false);
			if is_airborne {
				change_sprite(spr_goku_ssj_special_kamehameha_air,frame_duration,false);
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
	kamehameha_light.run = function() {
		xspeed = 0;
		yspeed = 0;
		if check_frame(6) {
			play_sound(snd_dbz_beam_fire);
		}
		if value_in_range(frame,6,9) {
			fire_beam(20,-25,spr_kamehameha,1,0,50);
		}
		return_to_idle();
	}
	
	kamehameha_medium = new state();
	kamehameha_medium.start = function() {
		kamehameha_light.start();
		if active_state == kamehameha_medium {
			change_sprite(sprite,frame_duration + 2,false);
		}
	}
	kamehameha_medium.start = function() {
		kamehameha_light.run();
	}
	
	kamehameha_heavy = new state();
	kamehameha_heavy.start = function() {
		kamehameha_light.start();
		if active_state == kamehameha_heavy {
			change_sprite(sprite,frame_duration + 3,false);
		}
	}
	kamehameha_heavy.start = function() {
		kamehameha_light.run();
	}
	
	super_kamehameha = new state();
	super_kamehameha.start = function() {
		if kamehameha_cooldown <= 0 and check_mp(2) {
			change_sprite(spr_goku_ssj_special_kamehameha,5,false);
			if is_airborne {
				change_sprite(spr_goku_ssj_special_kamehameha_air,frame_duration,false);
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
				if (input.forward) and check_tp(2) {
					spend_tp(2);
					play_sound(snd_dbz_teleport_long);
					teleport(target_x + ((width + target.width) * facing), target_y);
					face_target();
				
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
			fire_beam(20,-25,spr_kamehameha,2,0,50);
			shake_screen(5,3);
		}
		if check_frame(3) {
			play_voiceline(snd_goku_kamehameha_charge);
			play_sound(snd_dbz_beam_charge_long);
		}
		if check_frame(6) {
			play_voiceline(snd_goku_kamehameha_fire);
			play_sound(snd_dbz_beam_fire);
		}
		return_to_idle();
	}


	angry_kamehameha = new state();
	angry_kamehameha.start = function() {
		if kamehameha_cooldown <= 0 and check_mp(3) {
			change_sprite(spr_goku_ssj_special_ki_blast,5,false);
			activate_ultimate(60);
			spend_mp(3);
			xspeed = 0;
			yspeed = 0;
			kamehameha_cooldown = kamehameha_cooldown_duration * 1.5;
		}
		else {
			change_state(previous_state);
		}
	}
	angry_kamehameha.run = function() {
		xspeed = 0;
		yspeed = 0;
		if superfreeze_active {
			frame = 0;
		}
		if state_timer <= 120 {
			if frame > 3 {
				frame = 3;
				frame_timer = 1;
			}
		}
		if check_frame(3) {
			play_voiceline(snd_goku_kamehameha_fire);
			play_sound(snd_dbz_beam_fire);
		}
		if frame == 3 {
			fire_beam(20,-25,spr_kamehameha,2,0,80);
			shake_screen(5,10);
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
		if combo_hits > 0 {
			sprite_sequence(
				[
					spr_goku_ssj_attack_punch_straight,
					spr_goku_ssj_attack_elbow_bash,
					spr_goku_ssj_attack_kick_side,
					spr_goku_ssj_attack_kick_straight,
					spr_goku_ssj_attack_backflip_kick,
					spr_goku_ssj_special_kamehameha_air
				],
				frame_duration
			);
		}
		if sprite == spr_goku_special_kamehameha_air {
			if check_frame(1) {
				teleport(target_x - (100 * facing), target_y - 50);
				face_target();
				play_sound(snd_dbz_teleport_short);
			}
			kamehameha.run();
		}
		else {
			if sprite == spr_goku_attack_backflip_kick {
				if check_frame(3) {
					create_hitbox(0,-height,width,height,40,3,-10,attacktype.normal,attackstrength.super,hiteffects.hit);
				}
				if check_frame(2) {
					xspeed = 3 * facing;
					yspeed = -5;
					play_sound(snd_punch_whiff_super);
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

	activate_ssj2 = new state();
	activate_ssj2.start = function() {
		if check_mp(1) and (!ssj2_timer) {
			change_sprite(charge_loop_sprite,3,true);
			flash_sprite();
		
			activate_super(100);
			spend_mp(1);
			ssj2_timer = ssj2_duration;
		
			play_sound(snd_energy_start);
			play_voiceline(voice_powerup);
			
			repeat(20) {
				ssj2_sparks();
			}
		}
		else {
			change_state(previous_state);
		}
	}
	activate_ssj2.run = function() {
		if superfreeze_timer mod 10 == 1 {
			ssj2_sparks();
		}
		xspeed = 0;
		yspeed = 0;
		if !superfreeze_active {
			change_state(idle_state);
		}
	}

	setup_basicmoves();
	
	add_move(kiblast,"D");
	add_move(ki_blast_cannon,"236D");

	//add_move(dragon_fist,"");
	//add_move(meteor_combo,"EEA");

	add_move(kamehameha_light,"236A");
	add_move(kamehameha_medium,"236B");
	add_move(kamehameha_heavy,"236C");
	
	add_move(super_kamehameha,"214A");
	add_move(super_kamehameha,"214B");
	
	add_move(angry_kamehameha,"214C");
	
	add_move(activate_ssj2,"2D");

	victory_state.run = function() {
		ssj2_timer = 0;
		if anim_timer >= (anim_duration - 2) {
			frame = anim_frames - 2;
		}
	}

	draw_script = function() {
		if sprite == spr_goku_ssj_special_kamehameha
		or sprite == spr_goku_ssj_special_kamehameha_air {
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
}