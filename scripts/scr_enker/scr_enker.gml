function init_enker() {
	init_charsprites("enker");
	init_charaudio("enker");

	name = "enker";
	display_name = "Enker";
	
	theme = mus_dbfz_trunks;
	theme_pitch = 1.1;
	
	universe = universes.uniforce;

	max_air_moves = 2;
	
	kazedama_cooldown = 0;
	kazedama_cooldown_duration = 100;

	greenwind_active = false;
	greenwind_timer = 0;
	greenwind_duration = 30 * 60;
	greenwind_mp_drain = ceil(mp_stock_size / (5 * 60))
	greenwind_buff = 1.10;
	greenwind_color = make_color_rgb(128,255,128);

	//next_form = obj_enker_sgw;
	transform_aura = spr_aura_dbz_green;
	charge_aura = spr_aura_dbz_green;
	
	max_windblasts = 5;
	windblast_count = 0;
	
	windblast_sprite = spr_enker_special_windblast;
	windblast_sprite2 = spr_enker_special_windblast2;
	windblast_shot_sprite = spr_glow_green;

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
				play_sound(snd_energy_stop);
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
	//		ai_input_move(wind_blast,10);
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
		if check_frame(1) {
			xspeed = 10 * facing;
		}
		if check_frame(3) {
			xspeed = -5 * facing;
		}
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
	
	wind_blast = new charstate();
	wind_blast.start = function() {
		if attempt_special(1/max_windblasts) {
			change_sprite(
				sprite == windblast_sprite2 ? windblast_sprite : windblast_sprite2,
				2,
				false
			);
		}
		else {
			change_state(idle_state);
		}
	}
	wind_blast.run = function() {
		if check_frame(2) {
			with(create_shot(
				25,
				-35,
				20,
				sine_wave(windblast_count,max_windblasts/2,2,0),
				windblast_shot_sprite,
				32 / sprite_get_height(windblast_shot_sprite),
				100,
				3,
				-3,
				attacktype.normal,
				attackstrength.light,
				hiteffects.wind
			)) {
				greenwind_color = owner.greenwind_color;
				blend = true;
				active_script = function() {
					create_specialeffect(
						spr_wind_spin,
						0,
						0,
						0.5,
						0.5,
						point_direction(0,0,abs(xspeed),yspeed),
						0,
						greenwind_color
					);
				}
				hit_script = function() {
					var _dir = point_direction(0,0,abs(xspeed),yspeed);
					var _xspeed = lengthdir_x(1,_dir);
					var _yspeed = lengthdir_y(1,_dir);
					with(create_shot(
						0,
						0,
						_xspeed,
						_yspeed,
						spr_wind_spin,
						0.5,
						5,
						1,
						-1,
						attacktype.normal,
						attackstrength.light,
						hiteffects.slash
					)) {
						blend = true;
						hit_limit = -1;
						color = owner.greenwind_color;
						duration = anim_duration;
						active_script = function() {
							with(hitbox) {
								ds_list_clear(hit_list);
							}
							loop_sound(snd_punch_whiff_light,0.5,1.5);
						}
					}
				}
				play_sound(snd_dbz_beam_fire,0.5,1.5);
			}
			if is_airborne {
				xspeed = -2 * facing;
				yspeed = -2;
			}
			windblast_count++;
			
			add_cancel(wind_blast);
			can_cancel = (windblast_count < max_windblasts) and (check_mp(1/max_windblasts));
		}
		if state_timer >= 50 {
			change_state(idle_state);
		}
	}
	wind_blast.stop = function() {
		if next_state != wind_blast {
			windblast_count = 0;
		}
	}

	wind_blast_cannon = new charstate();
	wind_blast_cannon.start = function() {
		if attempt_super(1) {
			change_sprite(spr_enker_special_windblast,3,false);
		}
		else {
			change_state(idle_state)
		}
	}
	wind_blast_cannon.run = function() {
		if superfreeze_active {
			frame = 0;
		}
		if check_frame(2) {
			with(create_shot(
				25,
				-height_half,
				1,
				0,
				spr_wind_spin,
				1,
				500,
				30,
				-2,
				attacktype.wall_bounce,
				attackstrength.super,
				hiteffects.wind
			)) {
				duration = anim_duration;
				hit_limit = -1;
				color = other.greenwind_color;
				play_sound(snd_dbz_beam_fire,1,1.5);
			}
		}
		if state_timer > 60 {
			return_to_idle();
		}
	}

	activate_greenwind = new charstate();
	activate_greenwind.start = function() {
		if attempt_super(1,(!greenwind_active)) {
			change_sprite(charge_loop_sprite,3,true);
			flash_sprite();
			
			greenwind_timer = greenwind_duration;
		
			play_sound(snd_energy_start);
			play_voiceline(voice_powerup);
			
			repeat(20) {
				greenwind_sparks();
			}
		}
		else {
			change_state(idle_state);
		}
	}
	activate_greenwind.run = function() {
		if superfreeze_timer mod 10 == 1 {
			greenwind_sparks();
		}
		xspeed = 0;
		yspeed = 0;
		if !superfreeze_active {
			change_state(idle_state);
		}
	}

	setup_basicmoves();
	
	add_move(wind_blast,"D");
	
	add_move(wind_blast_cannon,"236D");
	
	add_ground_move(activate_greenwind,"2D");
	
	signature_move = wind_blast_cannon;
	finisher_move = wind_blast_cannon;

	victory_state.run = function() {
		greenwind_timer = 0;
		if anim_timer >= (anim_duration - 2) {
			frame = anim_frames - 2;
		}
	}

	draw_script = function() {
		gpu_set_blendmode(bm_normal);
	}
}

function greenwind_swirls() {
	char_specialeffect(
		spr_wind_spin,
		random_range(-width_half,width_half),
		-random(height),
		random(1),
		random(1),
		random(360),
		random(20),
		greenwind_color
	);
	play_sound(snd_chakra_loop,1,1.5);
}