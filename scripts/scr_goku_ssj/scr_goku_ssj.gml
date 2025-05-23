function init_goku_ssj() {
	init_charsprites("goku_ssj");
	init_charaudio("goku");

	name = "goku";
	form_name = "ssj";
	display_name = "Goku";
	form_display_name = "Super Saiyan";
	theme = mus_dbfz_space;
	universe = universes.dragonball;
	
	voice_volume_mine = 1.25;

	max_air_actions = 3;

	ssj2_active = false;
	ssj2_timer = 0;
	ssj2_duration = 30 * 60;
	ssj2_mp_drain = ceil(mp_stock_size / (5 * 60))
	ssj2_buff = 1.10;

	//next_form = obj_goku_ssj3;
	transform_aura = spr_aura_dbz_yellow;
	charge_aura = spr_aura_dbz_yellow;
	
	add_kiblast_state(
		spr_goku_ssj_special_kiblast,
		spr_goku_ssj_special_kiblast2,
		spr_glow_yellow,
		2,
		7
	);
	
	add_kamehameha_state(
		spr_goku_ssj_special_kamehameha,
		spr_goku_ssj_special_kamehameha_air,
		3,
		4,
		6,
		8,
		vc_goku_kamehameha
	);
	
	add_superkamehameha_state(
		spr_goku_ssj_special_kamehameha,
		spr_goku_ssj_special_kamehameha_air,
		3,
		4,
		6,
		8,
		vc_goku_kamehame,
		vc_goku_kamehame_ha
	);

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
				play_sound(snd_dbz_energy_stop);
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

	add_basic_light_attack_state(spr_goku_ssj_attack_punch,2,attackstrength.light,hiteffects.hit);
	add_basic_light_attack_state(spr_goku_ssj_attack_kick,2,attackstrength.medium,hiteffects.hit);
	add_basic_light_attack_state(spr_goku_ssj_attack_elbow_bash,2,attackstrength.heavy,hiteffects.hit);
	add_basic_light_attack_state(spr_goku_ssj_attack_punch,2,attackstrength.light,hiteffects.hit);
	add_basic_light_attack_launcher_state(spr_goku_ssj_attack_knee,2,hiteffects.hit);
	
	add_basic_medium_attack_state(spr_goku_ssj_attack_elbow_bash,2,hiteffects.hit);
	add_basic_medium_sweep_state(spr_goku_ssj_attack_spin_kick,3,hiteffects.hit);
	
	add_basic_heavy_attack_state(spr_goku_ssj_attack_kick_side,2,hiteffects.hit);
	add_basic_heavy_launcher_state(spr_goku_ssj_attack_backflip_kick,2,hiteffects.hit);
	
	add_basic_heavy_airattack_state(spr_goku_ssj_attack_smash,2,hiteffects.hit);
	add_basic_heavy_air_launcher_state(spr_goku_ssj_attack_kick_lift,2,hiteffects.hit);
	
	light_airattack = new charstate();
	light_airattack.start = function() {
		change_sprite(spr_goku_ssj_attack_triple_kick,false);
		play_voiceline(voice_attack,50,false);
	}
	light_airattack.run = function() {
		basic_attack_frame_speed(
			1,
			6,
			lightattack_startup,
			lightattack_recovery
		);
		if check_frame(1) or check_frame(3) or check_frame(5) {
			play_sound(snd_punch_whiff_light);
		}
		basic_attack_stepforward(2);
		basic_attack_stepforward(4);
		basic_attack_stepforward(6);
		basic_multihit_attack(2,80,attackstrength.light,hiteffects.hit);
		basic_multihit_attack(4,80,attackstrength.light,hiteffects.hit);
		basic_multihit_attack(6,80,attackstrength.light,hiteffects.hit);
		anim_finish_idle();
		land();
	}
	
	medium_airattack = new charstate();
	medium_airattack.start = function() {
		change_sprite(spr_goku_ssj_attack_spin_kick_double,false);
		play_voiceline(voice_attack,50,false);
	}
	medium_airattack.run = function() {
		basic_attack_frame_speed(
			2,
			8,
			mediumattack_startup,
			mediumattack_recovery
		);
		if check_frame(2) or check_frame(6) {
			play_sound(snd_punch_whiff_medium);
		}
		basic_attack_stepforward(3);
		basic_attack_stepforward(5);
		basic_multihit_attack(3,200,attackstrength.medium,hiteffects.hit);
		basic_multihit_attack(7,200,attackstrength.medium,hiteffects.hit);
		anim_finish_idle();
		land();
	}

	dragon_fist = new charstate();
	dragon_fist.start = function() {
		if attempt_super(1) {
			change_sprite(spr_goku_ssj_attack_punch,false);
		}
		else {
			change_state(idle_state);
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
			anim_finish_idle();
		}
	}

	ki_blast_cannon = new charstate();
	ki_blast_cannon.start = function() {
		if attempt_super(1) {
			change_sprite(spr_goku_ssj_special_kiblast,false);
		}
		else {
			change_state(idle_state)
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
				1125,
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
			anim_finish_idle();
		}
	}

	angry_kamehameha = new charstate();
	angry_kamehameha.start = function() {
		if attempt_ultimate(5,(!ssj2_active)) {
			change_sprite(spr_goku_ssj_special_kiblast,false);
			xspeed = 0;
			yspeed = 0;
			kamehameha_cooldown = kamehameha_cooldown_duration * 2;
		}
		else {
			change_state(idle_state);
		}
	}
	angry_kamehameha.run = function() {
		xspeed = 0;
		yspeed = 0;
		if superfreeze_active {
			loop_anim_middle(0,0);
		}
		loop_anim_middle_timer(2,3,120);
		if value_in_range(frame,2,3) {
			fire_beam(spr_kamehameha_gold,2,0,50);
			shake_screen(10,2);
		}
		if check_frame(2) {
			play_voiceline(vc_goku_kamehame_ha);
			play_sound(snd_dbz_beam_fire);
		}
		anim_finish_idle();
	}

	activate_ssj2 = new charstate();
	activate_ssj2.start = function() {
		if attempt_super(1,(!ssj2_timer)) {
			change_sprite(charge_loop_sprite,true);
			flash_sprite();
			
			superfreeze(60);
			
			ssj2_timer = ssj2_duration;
		
			play_sound(snd_dbz_energy_start);
			play_voiceline(voice_powerup);
			
			repeat(20) {
				ssj2_sparks();
			}
		}
		else {
			change_state(idle_state);
		}
	}
	activate_ssj2.run = function() {
		if superfreeze_timer mod 5 == 0 {
			ssj2_sparks();
		}
		xspeed = 0;
		yspeed = 0;
		if !superfreeze_active {
			change_state(idle_state);
		}
	}
	
	victory_state.run = function() {
		ssj2_timer = 0;
		if sound_is_playing(voice) {
			loop_anim_middle(1,3);
		}
		loop_anim_middle(3,4);
	}
	defeat_state.run = function() {
		ssj2_timer = 0;
		if sound_is_playing(voice) {
			loop_anim_middle(1,3);
		}
		loop_anim_middle(3,4);
	}
	
	init_goku_ssj_movelist();

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