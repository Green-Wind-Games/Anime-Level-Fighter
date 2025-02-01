function init_enker() {
	init_charsprites("enker");
	init_charaudio("enker");

	name = "enker";
	display_name = "Enker";
	
	theme = mus_dbfz_trunks;
	//theme_pitch = 0.95;
	
	universe = universes.uniforce;
	
	voice_volume_mine = 3;

	max_air_actions = 2;

	greenwind_active = false;
	greenwind_timer = 0;
	greenwind_duration = 30 * 60;
	greenwind_mp_drain = ceil(mp_stock_size / (5 * 60));
	greenwind_buff = 1.25;

	//next_form = obj_enker_sgw;
	transform_aura = spr_aura_dbz_green;
	charge_aura = spr_aura_dbz_green;
	
	add_greenwind_blast_state(
		5,
		spr_enker_special_windblast,
		spr_enker_special_windblast2,
		2,
		spr_glow_green
	);
	
	add_greenwind_push_state(
		spr_enker_special_windblast,
		2
	);
	
	add_super_greenwind_blade(
		spr_enker_special_windblade,
		2,
		4,
		5,
		7
	);
	
	add_myrmidon_slash_state(
		spr_enker_special_slashcombo_charge,
		spr_enker_attack_slash_down,
		spr_enker_attack_slash_upper,
		spr_enker_attack_slash_dash_spin,
	);

	char_script = function() {
		var _greenwind_active = greenwind_active;
		if dead or (mp <= 0) {
			greenwind_timer = 0;
		}
		if greenwind_timer-- > 0 {
			greenwind_active = true;
			mp -= greenwind_mp_drain;
			if greenwind_timer mod 30 == 1 {
				greenwind_swirls();
			}
		}
		else {
			greenwind_active = false;
		}
		if greenwind_active != _greenwind_active {
			if greenwind_active {
				attack_power = greenwind_buff;
				move_speed_buff = greenwind_buff;
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
	//	if greenwind_active {
	//		if target_distance < 50 {
	//			ai_input_move(autocombo[0],100);
	//		}
	//		else {
	//			ai_input_move(dash_state,50);
	//		}
	//	}
	//	else {
	//		ai_input_move(activate_greenwind,10);
	//		ai_input_move(spirit_bomb,10);
	//	}
	//	if target_distance < 20 {
	//		ai_input_move(dragon_fist,10);
	//		ai_input_move(meteor_combo,10);
	//		ai_input_move(kiai_push,10);
	//	}
	//	else if target_distance > 200 {
	//		ai_input_move(wind_ball,10);
	//		ai_input_move(kamehameha,10);
	//		ai_input_move(super_kamehameha,10);
	//	}
	//}

	light_attack = new charstate();
	light_attack.start = function() {
		change_sprite(spr_enker_attack_stab,3,false);
		play_sound(snd_slash_whiff_light);
		play_voiceline(voice_attack,50,false);
	}
	light_attack.run = function() {
		basic_light_attack(2,hiteffects.slash);
	}

	light_attack2 = new charstate();
	light_attack2.start = function() {
		change_sprite(spr_enker_attack_slash_down,3,false);
		play_sound(snd_slash_whiff_medium);
		play_voiceline(voice_attack,50,false);
	}
	light_attack2.run = function() {
		basic_medium_attack(2,hiteffects.slash);
		if check_frame(2) {
			char_specialeffect(spr_slash,16,-32,1/2,1/2);
		}
	}

	light_attack3 = new charstate();
	light_attack3.start = function() {
		change_sprite(spr_enker_attack_slash_upper,3,false);
		play_sound(snd_slash_whiff_heavy);
		play_voiceline(voice_heavyattack,50,false);
	}
	light_attack3.run = function() {
		basic_heavy_lowattack(3,hiteffects.slash);
		if check_frame(3) {
			char_specialeffect(spr_slash2,0,-64,0.75,-0.75);
		}
	}
	
	light_lowattack = new charstate();
	light_lowattack.start = function() {
		change_sprite(spr_enker_attack_stab,4,false);
		play_sound(snd_slash_whiff_light);
		play_voiceline(voice_attack,50,false);
		xspeed = -5 * facing;
	}
	light_lowattack.run = function() {
		basic_light_attack(2,hiteffects.slash);
		xspeed = sine_wave(anim_timer,anim_duration,5,5) * facing;
	}
	
	light_airattack = new charstate();
	light_airattack.start = function() {
		change_sprite(spr_enker_attack_stab,3,false);
		play_sound(snd_slash_whiff_light);
		play_voiceline(voice_attack,50,false);
	}
	light_airattack.run = function() {
		basic_light_airattack(2,hiteffects.slash);
	}
	
	medium_attack = new charstate();
	medium_attack.start = function() {
		change_sprite(spr_enker_attack_slash_side,2,false);
		play_sound(snd_slash_whiff_medium);
		play_voiceline(voice_attack,50,false);
	}
	medium_attack.run = function() {
		basic_medium_lowattack(2,hiteffects.slash);
		if check_frame(2) {
			char_specialeffect(spr_slash2,32,-32,1/2,-1/2);
		}
	}
	
	medium_lowattack = new charstate();
	medium_lowattack.start = function() {
		change_sprite(spr_enker_attack_slash_dash,3,false);
		play_sound(snd_slash_whiff_medium);
		play_voiceline(voice_attack,50,false);
	}
	medium_lowattack.run = function() {
		if check_frame(2) {
			xspeed = 10 * facing;
			yspeed = 0;
		}
		basic_medium_attack(3,hiteffects.slash);
		if check_frame(3) {
			char_specialeffect(spr_slash3,24,-32,1,1);
		}
	}
	
	medium_airattack = new charstate();
	medium_airattack.start = function() {
		change_sprite(spr_enker_attack_slash_dash,3,false);
		play_sound(snd_slash_whiff_medium);
		play_voiceline(voice_attack,50,false);
	}
	medium_airattack.run = function() {
		if check_frame(2) {
			xspeed = 10 * facing;
			yspeed = 0;
		}
		basic_medium_airattack(3,hiteffects.slash);
		if check_frame(3) {
			char_specialeffect(spr_slash3,24,-32,1,1);
		}
	}

	heavy_attack = new charstate();
	heavy_attack.start = function() {
		change_sprite(spr_enker_attack_slash_down,5,false);
		play_sound(snd_slash_whiff_heavy);
		play_voiceline(voice_heavyattack,100,false);
	}
	heavy_attack.run = function() {
		basic_heavy_attack(2,hiteffects.slash);
		if check_frame(2) {
			char_specialeffect(spr_slash,24,-32,0.75,0.75);
		}
	}

	launcher_attack = new charstate();
	launcher_attack.start = function() {
		change_sprite(spr_enker_attack_slash_upper,3,false);
		play_sound(snd_slash_whiff_heavy);
		play_voiceline(voice_heavyattack,50,false);
	}
	launcher_attack.run = function() {
		basic_heavy_lowattack(2,hiteffects.slash);
		if check_frame(2) {
			char_specialeffect(spr_slash2,24,-48,0.75,-0.75);
		}
	}

	heavy_airattack = new charstate();
	heavy_airattack.start = function() {
		change_sprite(spr_enker_attack_slash_down,5,false);
		play_sound(snd_slash_whiff_heavy);
		play_voiceline(voice_heavyattack,50,false);
	}
	heavy_airattack.run = function() {
		basic_heavy_airattack(2,hiteffects.slash);
		if check_frame(2) {
			char_specialeffect(spr_slash,24,-32,0.75,0.75);
		}
	}

	activate_greenwind = new charstate();
	activate_greenwind.start = function() {
		if attempt_super(1,(!greenwind_active)) {
			change_sprite(charge_loop_sprite,3,true);
			flash_sprite();
			
			greenwind_timer = greenwind_duration;
		
			play_sound(snd_dbz_energy_start);
			play_voiceline(voice_powerup);
			
			repeat(20) {
				greenwind_swirls();
			}
		}
		else {
			change_state(idle_state);
		}
	}
	activate_greenwind.run = function() {
		if superfreeze_timer mod 12 == 1 {
			greenwind_swirls();
		}
		xspeed = 0;
		yspeed = 0;
		if !superfreeze_active {
			change_state(idle_state);
		}
	}

	setup_basicmoves();
	
	add_move(greenwind_blast_state,"D");
	add_move(greenwind_push_state,"236D");
	add_move(super_greenwind_blade_state,"214D");
	
	add_move(myrmidon_slash_state,"236AB");
	
	add_ground_move(activate_greenwind,"252C");
	
	signature_move = greenwind_push_state;
	finisher_move = super_greenwind_blade_state;

	victory_state.run = function() {
		greenwind_timer = 0;
		if sound_is_playing(voice) {
			loop_anim_middle(4,6);
		}
	}
	defeat_state.run = function() {
		greenwind_timer = 0;
		if sound_is_playing(voice) {
			loop_anim_middle(4,7);
		}
		loop_anim_middle(8,9);
	}

	draw_script = function() {
		gpu_set_blendmode(bm_normal);
	}
}