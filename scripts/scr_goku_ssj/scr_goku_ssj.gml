function init_goku_ssj() {
	init_charsprites("goku_ssj");

	name = "goku";
	form_name = "ssj";
	display_name = "Goku";
	form_display_name = "Super Saiyan";
	theme = mus_dbfz_space;
	universe = universes.dragonball;

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
		spr_goku_ssj_special_kiblast,
		spr_goku_ssj_special_kiblast2,
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

	light_attack = new charstate();
	light_attack.start = function() {
		change_sprite(spr_goku_ssj_attack_punch_straight,3,false);
		play_sound(snd_punch_whiff_light);
		play_voiceline(voice_attack,50,false);
	}
	light_attack.run = function() {
		basic_light_attack(2,hiteffects.hit);
	}

	light_attack2 = new charstate();
	light_attack2.start = function() {
		change_sprite(spr_goku_ssj_attack_kick_side,3,false);
		play_sound(snd_punch_whiff_medium);
		play_voiceline(voice_attack,50,false);
	}
	light_attack2.run = function() {
		basic_medium_attack(2,hiteffects.hit);
	}

	light_attack3 = new charstate();
	light_attack3.start = function() {
		change_sprite(spr_goku_ssj_attack_kick_lift,3,false);
		play_voiceline(voice_heavyattack,50,false);
	}
	light_attack3.run = function() {
		basic_heavy_lowattack(3,hiteffects.hit);
	}
	
	light_lowattack = new charstate();
	light_lowattack.start = function() {
		change_sprite(spr_goku_ssj_attack_triple_kick,2,false);
		play_voiceline(voice_attack,50,false);
	}
	light_lowattack.run = function() {
		if check_frame(2) or check_frame(4) or check_frame(6) {
			play_sound(snd_punch_whiff_light);
		}
		basic_light_airattack(3,hiteffects.hit);
		basic_light_airattack(5,hiteffects.hit);
		basic_light_airattack(7,hiteffects.hit);
	}
	
	light_airattack = new charstate();
	light_airattack.start = function() {
		change_sprite(spr_goku_ssj_attack_triple_kick,2,false);
		play_voiceline(voice_attack,50,false);
	}
	light_airattack.run = function() {
		if frame <= 8 {
			xspeed = 5 * facing;
			yspeed = -1;
		}
		if check_frame(2) or check_frame(4) or check_frame(6) {
			play_sound(snd_punch_whiff_light);
		}
		basic_light_airattack(3,hiteffects.hit);
		basic_light_airattack(5,hiteffects.hit);
		basic_light_airattack(7,hiteffects.hit);
	}
	
	medium_attack = new charstate();
	medium_attack.start = function() {
		change_sprite(spr_goku_ssj_attack_elbow_bash,3,false);
		play_sound(snd_punch_whiff_medium);
		play_voiceline(voice_attack,50,false);
	}
	medium_attack.run = function() {
		basic_medium_attack(2,hiteffects.hit);
		if check_frame(2) {
			xspeed = 10 * facing;
			yspeed = 0;
		}
	}
	
	medium_lowattack = new charstate();
	medium_lowattack.start = function() {
		change_sprite(spr_goku_ssj_attack_spin_kick,2,false);
		play_sound(snd_punch_whiff_medium);
		play_voiceline(voice_attack,50,false);
	}
	medium_lowattack.run = function() {
		basic_medium_lowattack(4,hiteffects.hit);
	}
	
	medium_airattack = new charstate();
	medium_airattack.start = function() {
		change_sprite(spr_goku_ssj_attack_spin_kick_double,2,false);
		play_voiceline(voice_attack,50,false);
	}
	medium_airattack.run = function() {
		if check_frame(2) or check_frame(6) {
			play_sound(snd_punch_whiff_medium);
		}
		basic_medium_airattack(4,hiteffects.hit);
		basic_medium_airattack(8,hiteffects.hit);
	}

	heavy_attack = new charstate();
	heavy_attack.start = function() {
		change_sprite(spr_goku_ssj_attack_kick_back,5,false);
		play_sound(snd_punch_whiff_super);
		play_voiceline(voice_heavyattack,100,true);
	}
	heavy_attack.run = function() {
		basic_heavy_attack(2,hiteffects.hit);
	}

	launcher_attack = new charstate();
	launcher_attack.start = function() {
		change_sprite(spr_goku_ssj_attack_backflip_kick,3,false);
		play_sound(snd_punch_whiff_super);
		play_voiceline(voice_heavyattack,100,true);
	}
	launcher_attack.run = function() {
		basic_heavy_lowattack(3,hiteffects.hit);
	}

	heavy_airattack = new charstate();
	heavy_airattack.start = function() {
		change_sprite(spr_goku_ssj_attack_smash,5,false);
		play_sound(snd_punch_whiff_super);
		play_voiceline(voice_heavyattack,100,true);
	}
	heavy_airattack.run = function() {
		basic_heavy_airattack(2,hiteffects.hit);
	}

	dragon_fist = new charstate();
	dragon_fist.start = function() {
		if attempt_super(1) {
			change_sprite(spr_goku_ssj_attack_punch_straight,8,false);
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
			return_to_idle();
		}
	}

	ki_blast_cannon = new charstate();
	ki_blast_cannon.start = function() {
		if attempt_super(1) {
			change_sprite(spr_goku_ssj_special_kiblast,3,false);
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
			return_to_idle();
		}
	}

	kamehameha = new charstate();
	kamehameha.start = function() {
		if attempt_special(1) {
			change_sprite(spr_goku_ssj_special_kamehameha,5,false);
			if is_airborne {
				change_sprite(spr_goku_ssj_special_kamehameha_air,frame_duration,false);
			}
			xspeed = 0;
			yspeed = 0;
			kamehameha_cooldown = kamehameha_cooldown_duration;
			play_voiceline(snd_goku_superkamehameha);
			play_sound(snd_dbz_beam_charge_short);
		}
		else {
			change_state(idle_state);
		}
	}
	kamehameha.run = function() {
		xspeed = 0;
		yspeed = 0;
		if check_frame(6) {
			play_sound(snd_dbz_beam_fire);
		}
		if value_in_range(frame,6,9) {
			//var _beam = create_shot(
			//	30,
			//	-25,
			//	20,
			//	0,
			//	spr_glow_blue,
			//	1/4,
			//	200,
			//	3,
			//	-3,
			//	attacktype.beam,
			//	attackstrength.heavy,
			//	hiteffects.none
			//);
			//with(_beam) {
			//	hit_limit = -1;
			//}
			fire_beam(20,-25,spr_kamehameha,1,0,50);
		}
		return_to_idle();
	}

	super_kamehameha = new charstate();
	super_kamehameha.start = function() {
		if attempt_super(2,(kamehameha_cooldown <= 0)) {
			change_sprite(spr_goku_ssj_special_kamehameha,5,false);
			if is_airborne {
				change_sprite(spr_goku_ssj_special_kamehameha_air,frame_duration,false);
			}
			xspeed = 0;
			yspeed = 0;
			kamehameha_cooldown = kamehameha_cooldown_duration * 1.5;
			activate_super(60);
			play_voiceline(snd_goku_kamehame);
			//if combo_timer <= 0 {
			//	superfreeze(200);
			//	play_voiceline(snd_goku_kamehameha_charge);
			//}
		}
		else {
			change_state(idle_state);
		}
	}
	super_kamehameha.run = function() {
		xspeed = 0;
		yspeed = 0;
		if superfreeze_active {
			loop_anim_middle(4,5);
			if superfreeze_timer == 15 {
				if (input.forward) and check_tp(1) {
					spend_tp(2);
					play_sound(snd_dbz_teleport_long);
					teleport(target_x + ((width + target.width) * facing), target_y);
					face_target();
				
					var _frame = frame;
					change_sprite(spr_goku_ssj_special_kamehameha_air,frame_duration,false);
					frame = _frame;
				}
			}
		}
		loop_anim_middle_timer(6,9,120);
		if value_in_range(frame,6,9) {
			//var _beam = create_shot(
			//	30,
			//	-25,
			//	20,
			//	0,
			//	spr_glow_blue,
			//	3/4,
			//	25,
			//	3,
			//	-3,
			//	attacktype.beam,
			//	attackstrength.heavy,
			//	hiteffects.none
			//);
			//with(_beam) {
			//	hit_limit = -1;
			//}
			fire_beam(20,-25,spr_kamehameha,2,0,50);
		}
		if check_frame(3) {
			if superfreeze_timer > 60 {
				play_sound(snd_dbz_beam_charge_long);
			}
			else {
				play_sound(snd_dbz_beam_charge_short);
			}
		}
		if check_frame(6) {
			play_voiceline(snd_goku_kamehameha_fire);
			play_sound(snd_dbz_beam_fire);
			shake_screen(120,1);
		}
		return_to_idle();
	}

	angry_kamehameha = new charstate();
	angry_kamehameha.start = function() {
		if attempt_ultimate(5,(!ssj2_active)) {
			change_sprite(spr_goku_ssj_special_kiblast,5,false);
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
		if check_frame(2) {
			play_voiceline(snd_goku_kamehameha_fire);
			play_sound(snd_dbz_beam_fire);
			shake_screen(120,1);
		}
		loop_anim_middle_timer(3,3,120);
		if value_in_range(frame,3,3) {
			//var _beam = create_shot(
			//	30,
			//	-25,
			//	20,
			//	0,
			//	spr_glow_yellow,
			//	3/4,
			//	50,
			//	3,
			//	-3,
			//	attacktype.beam,
			//	attackstrength.heavy,
			//	hiteffects.none
			//);
			//with(_beam) {
			//	hit_limit = -1;
			//}
			fire_beam(20,-25,spr_kamehameha_gold,2,0,50);
		}
		return_to_idle();
	}

	activate_ssj2 = new charstate();
	activate_ssj2.start = function() {
		if attempt_super(1,(!ssj2_timer)) {
			change_sprite(charge_loop_sprite,3,true);
			flash_sprite();
			
			superfreeze(60);
			
			ssj2_timer = ssj2_duration;
		
			play_sound(snd_energy_start);
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

	setup_basicmoves();
	
	add_move(kiblast,"D");
	
	add_move(kamehameha,"236D");
	add_move(super_kamehameha,"214D");
	add_move(angry_kamehameha,"41236D");
	
	add_ground_move(ki_blast_cannon,"236A");
	add_ground_move(ki_blast_cannon,"236B");
	add_ground_move(ki_blast_cannon,"236C");
	
	add_ground_move(activate_ssj2,"2D");
	
	signature_move = super_kamehameha;
	finisher_move = angry_kamehameha;

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