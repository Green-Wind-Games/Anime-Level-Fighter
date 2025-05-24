function init_naruto_baseform() {
	init_charsprites("naruto");
	init_charaudio("naruto");

	name = "naruto";
	display_name = "Naruto";
	theme = mus_naruto_strongandstrike;
	universe = universes.narutoshippuden;
	
	voice_volume_mine = 1.5;
	
	move_speed_mod = 1.25;
	max_air_actions = 1;

	rasengan_cooldown = 0;
	rasengan_cooldown_duration = 100;
	rasengan_frame = 0;
	
	shadow_clone_jutsu_cooldown = 0;
	shadow_clone_jutsu_cooldown_duration = 300;
	
	rasen_shuriken_explosion = noone;
	
	charge_aura = spr_aura_chakra;
	charge_start_sound = noone;
	charge_loop_sound = snd_naruto_chakra_loop;
	charge_stop_sound = noone;
	
	transform_aura = spr_aura_chakra;
	
	set_substitution_jutsu();

	char_script = function() {
		rasengan_cooldown--;
		if active_state == mini_rasengan
		or active_state == double_rasengan
		or active_state == giant_rasengan {
			rasengan_cooldown = rasengan_cooldown_duration;
		}
		shadow_clone_jutsu_cooldown--;
		var me = id;
		with(obj_helper) {
			if owner == me {
				if duration == -1 {
					with(me) {
						shadow_clone_jutsu_cooldown = shadow_clone_jutsu_cooldown_duration;
					}
				}
			}
		}
	}
	
	add_basic_light_attack_state(spr_naruto_attack_punch,2,hiteffects.hit);
	add_basic_light_attack_state(spr_naruto_attack_dash_punch,2,hiteffects.hit);
	add_basic_light_attack_state(spr_naruto_attack_punch,2,hiteffects.hit);
	add_basic_light_attack_state(spr_naruto_attack_punch_hook,2,hiteffects.hit);
	add_basic_light_attack_launcher_state(spr_naruto_attack_uppercut,3,hiteffects.hit);
	
	add_basic_medium_attack_state(spr_naruto_attack_punch_hook,2,hiteffects.hit);
	add_basic_medium_sweep_state(spr_naruto_attack_spinkick,3,hiteffects.hit);
	
	add_basic_heavy_attack_state(spr_naruto_attack_slash,2,hiteffects.slash);
	add_basic_heavy_launcher_state(spr_naruto_attack_slash_up,3,hiteffects.slash);
	
	heavy_attack.unique_script = function() {
		if check_frame(2) {
			char_specialeffect(spr_slash,width_half,-height_half,0.5,-0.5,-45);
		}
	}
	heavy_launcher.unique_script = function() {
		if check_frame(3) {
			char_specialeffect(spr_slash2,width_half,-height*0.75,0.5,-0.5,-45);
		}
	}
	
	add_basic_light_airattack_state(spr_naruto_attack_back_kick_air,1,hiteffects.hit);
	add_basic_medium_airattack_state(spr_naruto_attack_spinkick,3,hiteffects.hit);
	add_basic_heavy_airattack_state(spr_naruto_attack_smash_kick,3,hiteffects.hit);
	
	add_basic_heavy_air_launcher_state(spr_naruto_attack_spinkick_up,4,hiteffects.hit);
	
	divekick = new charstate();
	divekick.start = function() {
		change_sprite(
			choose(spr_naruto_attack_divekick,spr_naruto_attack_divekick2),
			true
		);
		play_sound(snd_punch_whiff_medium);
		play_voiceline(voice_attack,50,false);
	}
	divekick.run = function() {
		if check_frame(frame) {
			create_hitbox(
				0,
				-height_half,
				width_half * 1.5,
				height_half * 1.5,
				100,
				3,
				1,
				attacktype.multihit,
				attackstrength.medium,
				hiteffects.hit
			);
		}
		xspeed = 8 * facing;
		yspeed = 16;
		if on_ground {
			change_state(crouch_state);
		}
	}
	
	uzumaki_barrage_start = new charstate();
	uzumaki_barrage_start.start = function() {
		if attempt_special(1) {
			change_sprite(spr_naruto_jutsu,false);
			play_sound(snd_naruto_jutsu_activate);
			play_voiceline(vc_naruto_uzumaki);
			if (instance_number(obj_char) <= 2) and (combo_timer > 0) {
				timestop(60);
			}
			xspeed = -8 * facing;
		}
	}
	uzumaki_barrage_start.run = function() {
		decelerate();
		if timestop_active {
			loop_anim_middle(2,3);
		}
		if check_frame(4) {
			create_helper(-75,0,init_naruto_baseform_clone_barrage);
			create_helper(235,0,init_naruto_baseform_clone_barrage);
			create_helper(-65,0,init_naruto_baseform_clone_barrage);
			create_helper(225,0,init_naruto_baseform_clone_barrage);
		}
		can_cancel = false;
		if anim_finished {
			if combo_timer > 20 {
				change_state(uzumaki_barrage_flip);
			}
			else {
				change_state(idle_state);
			}
		}
	}

	uzumaki_barrage_flip = new charstate();
	uzumaki_barrage_flip.start = function() {
		change_sprite(spr_naruto_flip,true);
		yoffset = -height_half;
		rotation_speed = -45;
		jump_towards_x(target_x - (width * facing), 30);
		yspeed = target.yspeed * 1.05;
	}
	uzumaki_barrage_flip.run = function() {
		if (state_timer mod 5) == 0 {
			play_sound(snd_punch_whiff_light,1.5,1.25);
		}
		if state_timer >= 30 {
			change_state(heavy_airattack);
			play_voiceline(vc_naruto_uzumakibarrage);
		}
	}
	
	shuriken_throw = new charstate();
	shuriken_throw.start = function() {
		change_sprite(spr_naruto_special_throw_shuriken,false);
		play_voiceline(voice_attack,50,false);
	}
	shuriken_throw.run = function() {
		loop_anim_middle_timer(1,1,15);
		if check_frame(3) {
			shuriken = create_shot(
				15,
				-30,
				12,
				is_airborne * 5,
				spr_shuriken,
				1,
				100,
				3,
				0,
				attacktype.normal,
				attackstrength.light,
				hiteffects.slash
			);
			with(shuriken) {
				blend = false;
				homing = true;
				homing_max_turn = 1;
				hit_limit = -1;
				duration = 100;
				rotation_speed = -30;
				active_script = function() {
					if y >= ground_height {
						homing = false;
						yspeed = 0;
						xspeed /= 2;
						if duration > 10 {
							duration = 10;
						}
					}
					else {
						loop_sound(snd_slash_whiff_light,1,2);
					}
				}
				hit_script = function() {
					xspeed /= 2;
					yspeed /= 2;
					homing = false;
					ygravity_mod = true;
				}
			}
		}
		anim_finish_idle();
	}
	
	triple_shuriken_throw = new charstate();
	triple_shuriken_throw.start = function() {
		change_sprite(spr_naruto_special_throw_shuriken,false);
		play_voiceline(voice_attack,50,false);
	}
	triple_shuriken_throw.run = function() {
		loop_anim_middle_timer(1,1,20);
		if check_frame(3) {
			var i = 0;
			repeat(3) {
				shuriken = create_shot(
					15 - i,
					-30,
					12,
					2 - (i * 1.5) - (on_ground) + (is_airborne * 5),
					spr_shuriken,
					1,
					50,
					3,
					0,
					attacktype.normal,
					attackstrength.light,
					hiteffects.slash
				);
				with(shuriken) {
					blend = false;
					hit_limit = -1;
					rotation_speed = -30;
					active_script = function() {
						if y >= ground_height {
							homing = false;
							yspeed = 0;
							xspeed /= 2;
							if duration == -1 {
								duration = 20;
							}
						}
						else {
							loop_sound(snd_slash_whiff_light,0.5,2);
						}
					}
					hit_script = function() {
						xspeed /= 2;
						yspeed /= 2;
						homing = false;
						ygravity_mod = true;
					}
				}
				i++;
			}
		}
		anim_finish_idle();
	}
	
	mini_rasengan = new charstate();
	mini_rasengan.start = function() {
		if attempt_special(1,(!rasengan_cooldown)) {
			change_sprite(spr_naruto_special_rasengan,false);
		}
		else {
			change_state(idle_state);
		}
	}
	mini_rasengan.run = function() {
		rasengan_script(5,6,11,12,0,0.5,100,1000,attacktype.hard_knockdown);
		
		if check_frame(4) {
			play_sound(snd_naruto_rasengan_charge);
		}
		if check_frame(7) {
			play_voiceline(vc_naruto_rasengan);
		}
		if check_frame(4) or check_frame(7) {
			create_particles(
				x-(width*facing),
				y,
				jutsu_smoke_particle
			);
		}
		anim_finish_idle();
	}
	
	rasengan_dive = new charstate();
	rasengan_dive.start = function() {
		if attempt_special(1,(!rasengan_cooldown)) {
			change_sprite(spr_naruto_special_rasengan_dive,false);
			xspeed = 0;
			yspeed = 0;
			play_voiceline(vc_naruto_rasengan);
		}
		else {
			change_state(idle_state);
		}
	}
	rasengan_dive.run = function() {
		var _target_y = target_y - target.height - 10;
		if (frame <= 11) {
			if frame < 8 {
				xspeed = 0;
				yspeed = 0;
			}
			if (y < _target_y) {
				loop_anim_middle(8,9);
			}
			if value_in_range(frame,8,9)  {
				xspeed = 15 * facing;
				yspeed = 15;
			}
			if value_in_range(y,_target_y,target_y) and (target_distance_x <= 10) {
				xspeed = 0;
				yspeed = 0;
				x = target_x;
				y = _target_y;
			}
		}
		
		if (attack_hits > 0) {
			loop_anim_middle_timer(10,11,60+(frame_duration*10));
		}
		if value_in_range(frame,10,11) {
			if check_frame(frame) {
				var _ball = create_shot(
					0,
					sprite_get_height(spr_rasengan) / 2,
					0,
					0,
					spr_rasengan,
					1,
					100,
					0,
					0,
					attacktype.otg,
					attackstrength.light,
					hiteffects.hit
				);
				with(_ball) {
					duration = 3;
					alpha = 0;
				}
			}
		}
		if check_frame(12) {
			with(target) {
				y -= 1;
			}
			var _ball = create_shot(
				0,
				sprite_get_height(spr_rasengan) / 2,
				0,
				0,
				spr_rasengan,
				1.5,
				1600,
				5,
				-5,
				attacktype.normal,
				attackstrength.heavy,
				hiteffects.hit
			);
			with(_ball) {
				duration = 3;
				alpha = 0;
			}
			play_sound(snd_explosion_small,1,1);
		}
		if check_frame(12) {
			xspeed = -5 * facing;
			yspeed = -10;
		}
		if check_frame(4) or check_frame(12) {
			create_particles(
				x-(width_half*facing),
				y,
				jutsu_smoke_particle
			);
		}
		if check_frame(5) {
			play_sound(snd_naruto_rasengan_charge,1,1.5);
		}
		if anim_finished {
			land();
		}
	}
	
	double_rasengan = new charstate();
	double_rasengan.start = function() {
		if attempt_super(2,(!rasengan_cooldown)) {
			change_sprite(spr_naruto_special_doublerasengan,false);
		}
		else {
			change_state(idle_state);
		}
	}
	double_rasengan.run = function() {
		repeat(2) {
			rasengan_script(5,6,11,12,0,1,150,1500,attacktype.hard_knockdown);
		}
		
		if check_frame(4) {
			play_sound(snd_naruto_rasengan_charge,1,1.25);
			play_sound(snd_naruto_rasengan_charge,1,0.75);
		}
		if check_frame(7) {
			play_voiceline(vc_naruto_rasengan);
			play_sound(vc_naruto_rasengan,1,1.25);
		}
		if check_frame(4) or check_frame(7) {
			create_particles(
				x-(width*facing),
				y,
				jutsu_smoke_particle
			);
			create_particles(
				x+(width*facing),
				y,
				jutsu_smoke_particle
			);
		}
		anim_finish_idle();
	}
	
	giant_rasengan = new charstate();
	giant_rasengan.start = function() {
		if attempt_super(3,(!rasengan_cooldown)) {
			change_sprite(spr_naruto_special_giantrasengan,false);
		}
		else {
			change_state(idle_state);
		}
	}
	giant_rasengan.run = function() {
		rasengan_script(5,6,11,12,0,2,200,2000,attacktype.hard_knockdown);
		
		if check_frame(4) {
			play_sound(snd_naruto_rasengan_charge,1,0.8);
		}
		if check_frame(7) {
			play_voiceline(vc_naruto_giantrasengan);
		}
		if check_frame(4) {
			create_particles(
				x-(width*facing),
				y,
				jutsu_smoke_particle
			);
		}
		if check_frame(13) {
			create_particles(
				x,
				y,
				jutsu_smoke_particle
			);
		}
		anim_finish_idle();
	}

	shadow_clone_jutsu = new charstate();
	shadow_clone_jutsu.start = function() {
		if attempt_special(2,(!shadow_clone_jutsu_cooldown)) {
			change_sprite(spr_naruto_jutsu,false);
			play_sound(snd_naruto_jutsu_activate);
			play_voiceline(vc_naruto_shadowclonejutsu);
		}
		else {
			change_state(idle_state);
		}
	}
	shadow_clone_jutsu.run = function() {
		if superfreeze_active {
			loop_anim_middle(4,5);
		}
		if check_frame(3) {
			create_helper(
				-width,
				0,
				init_naruto_baseform_clone
			);
			create_helper(
				width,
				0,
				init_naruto_baseform_clone
			);
		}
		anim_finish_idle();
	}
	
	shadow_clone_barrage = new charstate();
	shadow_clone_barrage.start = function() {
		if attempt_super(1.5,(!shadow_clone_jutsu_cooldown)) {
			change_sprite(spr_naruto_jutsu,false);
			play_sound(snd_naruto_jutsu_activate);
			play_voiceline(vc_naruto_shadowclonejutsu);
		}
		else {
			change_state(idle_state);
		}
	}
	shadow_clone_barrage.run = function() {
		xspeed = 0;
		yspeed = 0;
		if (frame > 3) and (superfreeze_active) {
			frame = 2;
		}
		if (frame > 5) and (state_timer < 100) {
			frame = 4;
		}
		if check_frame(4) {
			repeat(3) {
				var _clone = create_shot(
					random_range(-64,128),
					-random_range(64,128),
					random_range(10,20),
					random_range(10,20),
					choose(spr_naruto_attack_divekick,spr_naruto_attack_divekick2),
					1,
					5,
					3,
					-3,
					attacktype.normal,
					attackstrength.medium,
					hiteffects.hit
				);
				with(_clone) {
					hit_limit = -1;
					
					ygravity_mod = true;
					
					blend = false;
					rotation_speed = 0.1;
					rotation = 0;
					
					create_particles(
						x,
						y,
						jutsu_smoke_particle
					);
					
					active_script = function() {
						rotation = 0;
						if y >= ground_height {
							expire_script();
							instance_destroy();
						}
					}
					
					expire_script = function() {
						create_particles(
							x,
							y,
							jutsu_smoke_particle
						);
					}
					
					play_sound(owner.voice_attack,0.2);
				}
			}
		}
		anim_finish_idle();
	}
	
	rasen_shuriken = new charstate();
	rasen_shuriken.start = function() {
		if attempt_ultimate(7,(!rasengan_cooldown)) {
			change_sprite(spr_naruto_special_rasenshuriken,false);
			superfreeze(150);
		}
		else {
			change_state(idle_state);
		}
	}
	rasen_shuriken.run = function() {
		if sprite == spr_naruto_special_rasenshuriken {
			if check_frame(5) {
				play_sound(snd_naruto_rasenshuriken_ult_spin);
			}
			if (frame > 6) and (superfreeze_timer > 100) {
				frame = 5;
			}
			if check_frame(7) {
				play_voiceline(vc_naruto_rasenshuriken);
			}
			if (frame > 9) and (superfreeze_active) {
				frame = 8;
			}
			if check_frame(4) or check_frame(7) {
				create_particles(
					x-(width*facing),
					y,
					jutsu_smoke_particle
				);
				create_particles(
					x+(width*facing),
					y,
					jutsu_smoke_particle
				);
			}
			if check_frame(11) {
				xspeed = 20 * facing;
			}
			if check_frame(15) and (target_distance < 256) {
				var _explosion = create_shot(
					width*2,
					-height_half,
					1/100,
					0,
					spr_rasen_shuriken_explosion,
					2,
					100,
					1,
					-9,
					attacktype.hard_knockdown,
					attackstrength.ultimate,
					hiteffects.none
				);
				with(_explosion) {
					change_sprite(sprite,true);
					blend = true;
					duration = 60 * 3;
					alpha = 0;
					hit_limit = -1;
					active_script = function() {
						y = ground_height - height_half;
						if duration > 30 {
							alpha = approach(alpha,1,1/30);
							if ds_list_size(hitbox.hit_list) > 0 {
								for(var i = 0; i < ds_list_size(hitbox.hit_list); i++) {
									var _hit = ds_list_find_value(hitbox.hit_list,i);
									if instance_exists(_hit) {
										with(_hit) {
											x = other.x;
											y = other.y + height_half;
										}
									}
								}
								with(hitbox) {
									ds_list_clear(hit_list);
								}
							}
							else {
								duration -= 10;
							}
						}
						else {
							if alpha == 1 {
								play_sound(snd_naruto_rasenshuriken_ult_end);
							}
							alpha = map_value(duration,30,0,1,0);
						}
					}
					hit_script = function(_hit) {
						if is_char(_hit) or is_helper(_hit) {
							with(_hit) {
								change_state(hard_knockdown_state);
							}
						}
					}
					play_sound(snd_naruto_rasenshuriken_ult_hit);
				}
				rasen_shuriken_explosion = _explosion;
			}
			if check_frame(16) {
				take_damage(noone,10,false);
				change_sprite(launch_sprite,true);
				yoffset = -height_half;
				xspeed = -10 * facing;
				yspeed = -5;
				stop_sound(snd_naruto_rasenshuriken_ult_spin);
				play_voiceline(voice_hurt_heavy);
			}
		}
		else if sprite == launch_sprite {
			if on_ground {
				change_sprite(liedown_sprite,true);
			}
		}
		else if sprite == liedown_sprite {
			if !instance_exists(rasen_shuriken_explosion) {
				change_state(liedown_state);
			}
		}
	}
	
	init_naruto_baseform_movelist();

	victory_state.run = function() {
		if sound_is_playing(voice) {
			loop_anim_middle(1,3);
		}
		loop_anim_middle(6,8);
	}
	defeat_state.run = function() {
		if sound_is_playing(voice) {
			loop_anim_middle(1,3);
		}
		loop_anim_middle(6,8);
	}

	draw_script = function() {
		rasengan_frame += 1/2;
		if rasengan_frame >= sprite_get_number(spr_rasengan) {
			rasengan_frame = 0;
		}
		if sprite == spr_naruto_special_rasengan {
			if value_in_range(frame,4,6) {
				draw_sprite_ext(spr_naruto_clone_rasengan_charge,frame mod 2,x-(width*1.5*facing),y,facing,1,0,c_white,1);
				
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(spr_rasengan,rasengan_frame,x-(width*0.75*facing),y-(25),0.05,0.05,0,c_white,1);
			}
			if value_in_range(frame,7,8) {
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(spr_rasengan,rasengan_frame,x,y-(30),0.1,0.1,0,c_white,1);
			}
			if value_in_range(frame,9,12) {
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(spr_rasengan,rasengan_frame,x+(width*1.5*facing),y-(30),0.2,0.2,0,c_white,1);
			}
			if frame >= 13 {
				gpu_set_blendmode(bm_add);
				var _scale = map_value(
					anim_timer,
					frame_duration * 13,
					frame_duration * anim_frames,
					0.2,
					0.5
				);
				var _alpha = map_value(
					anim_timer,
					frame_duration * 13,
					frame_duration * anim_frames,
					1,
					0
				);
				var _rotation = -anim_timer / 100 * facing;
				draw_sprite_ext(
					spr_rasengan,
					rasengan_frame,
					x+(width*1.5*facing),
					y-35,
					_scale,
					_scale,
					_rotation,
					c_white,
					_alpha
				);
			}
		}
		if sprite == spr_naruto_special_rasengan_dive {
			if value_in_range(frame,4,5) {
				draw_sprite_ext(spr_naruto_clone_rasengan_air,0,x-(width*1.5*facing),y,facing,1,0,c_white,1);
			}
			if value_in_range(frame,6,7) {
				draw_sprite_ext(spr_naruto_clone_rasengan_air,(frame mod 2) + 1,x-(width*facing),y,facing,1,0,c_white,1);
				
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(spr_rasengan,rasengan_frame,x-(width*0.5*facing),y-40,0.1,0.1,0,c_white,1);
			}
			if value_in_range(frame,8,9) {
				draw_sprite_ext(spr_naruto_clone_rasengan_air,(frame mod 2) + 3,x-(width*facing),y+5,facing,1,0,c_white,1);
				
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(spr_rasengan,rasengan_frame,x-(width_half*facing),y-(40),0.3,0.3,0,c_white,1);
			}
			if value_in_range(frame,10,11) {
				draw_sprite_ext(spr_naruto_clone_rasengan_air,(frame mod 2) + 5,x-(width*0.75*facing),y,facing,1,0,c_white,1);
				
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(spr_rasengan,rasengan_frame,x-(width*facing/3),y+(50),0.5,0.5,0,c_white,1);
			}
			if frame >= 12 {
				gpu_set_blendmode(bm_add);
				var _scale = map_value(
					anim_timer,
					frame_duration * 12,
					frame_duration * 13,
					1/2,
					1
				);
				var _alpha = map_value(
					anim_timer,
					frame_duration * 12,
					frame_duration * 13,
					1,
					0
				);
				var _rotation = -anim_timer / 100 * facing;
				draw_sprite_ext(
					spr_rasengan,
					rasengan_frame,
					x,
					y + 64,
					_scale,
					_scale,
					_rotation,
					c_white,
					_alpha
				);
			}
		}
		if sprite == spr_naruto_special_doublerasengan {
			if value_in_range(frame,4,6) {
				draw_sprite_ext(spr_naruto_clone_rasengan_charge,frame mod 2,x+(width*facing),y,-facing,1,0,c_white,1);
				draw_sprite_ext(spr_naruto_clone_rasengan_charge,frame mod 2,x-(width*facing),y,facing,1,0,c_white,1);
				
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(spr_rasengan,rasengan_frame,x+(width*0.25*facing),y-(height*0.5),0.1,0.1,0,c_white,1);
				draw_sprite_ext(spr_rasengan,rasengan_frame,x-(width*0.25*facing),y-(height*0.5),0.1,0.1,0,c_white,1);
			}
			if value_in_range(frame,7,10) {
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(spr_rasengan,rasengan_frame,x-(width_half*facing),y-(height*0.69),0.2,0.2,0,c_white,1);
				draw_sprite_ext(spr_rasengan,rasengan_frame,x-(width_half*facing),y-(height*0.666),0.2,0.2,0,c_white,1);
			}
			if value_in_range(frame,11,12) {
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(spr_rasengan,rasengan_frame,x+(64*facing),y-48,0.5,0.5,0,c_white,1);
				draw_sprite_ext(spr_rasengan,rasengan_frame,x+(48*facing),y-32,0.5,0.5,0,c_white,1);
			}
			if frame >= 13 {
				gpu_set_blendmode(bm_add);
				var _scale = map_value(
					anim_timer,
					frame_duration * 13,
					frame_duration * 14,
					0.5,
					1
				);
				var _alpha = map_value(
					anim_timer,
					frame_duration * 13,
					frame_duration * 14,
					1,
					0
				);
				var _rotation = -anim_timer / 100 * facing;
				draw_sprite_ext(
					spr_rasengan,
					rasengan_frame,
					x+(50*facing),
					y-30,
					_scale,
					_scale,
					_rotation,
					c_white,
					_alpha
				);
				draw_sprite_ext(
					spr_rasengan,
					rasengan_frame,
					x+(45*facing),
					y-35,
					_scale,
					_scale,
					_rotation,
					c_white,
					_alpha
				);
			}
		}
		if sprite == spr_naruto_special_giantrasengan {
			if frame == 4 {
				draw_sprite_ext(spr_naruto_clone_giantrasengan,0,x-(width*1.5*facing),y,facing,1,0,c_white,1);
			}
			if value_in_range(frame,5,6) {
				draw_sprite_ext(spr_naruto_clone_giantrasengan,(frame mod 2) + 1,x-(width*1.5*facing),y,facing,1,0,c_white,1);
				
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(spr_rasengan,rasengan_frame,x-(width*0.6*facing),y-(25),0.2,0.2,0,c_white,1);
			}
			if value_in_range(frame,7,10) {
				draw_sprite_ext(spr_naruto_clone_giantrasengan,(frame mod 4) + 3,x-(width*facing),y,facing,1,0,c_white,1);
				
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(spr_rasengan,rasengan_frame,x,y-(30),0.3,0.3,0,c_white,1);
			}
			if value_in_range(frame,11,12) {
				draw_sprite_ext(spr_naruto_clone_giantrasengan,(frame mod 2) + 7,x-(width_half*facing),y,facing,1,0,c_white,1);
				
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(spr_rasengan,rasengan_frame,x+(100*facing),y-50,1,1,0,c_white,1);
			}
			if frame >= 13 {
				gpu_set_blendmode(bm_add);
				var _scale = map_value(
					anim_timer,
					frame_duration * 13,
					frame_duration * 14,
					1,
					2
				);
				var _alpha = map_value(
					anim_timer,
					frame_duration * 13,
					frame_duration * 14,
					1,
					0
				);
				var _rotation = -anim_timer / 100 * facing;
				draw_sprite_ext(
					spr_rasengan,
					rasengan_frame,
					x+(100*facing),
					y-35,
					_scale,
					_scale,
					_rotation,
					c_white,
					_alpha
				);
			}
		}
		if sprite == spr_naruto_special_rasenshuriken {
			if value_in_range(frame,4,6) {
				draw_sprite_ext(spr_naruto_clone_rasengan_charge,frame mod 2,x+(width*0.75*facing),y,-facing,1,0,c_white,1);
				draw_sprite_ext(spr_naruto_clone_rasengan_charge,frame mod 2,x-(width*0.75*facing),y,facing,1,0,c_white,1);
				
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(spr_rasen_shuriken,rasengan_frame,x,y-20,0.2,0.2,frame_timer * 30,c_white,1);
			}
			if frame == 7 {
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(spr_rasen_shuriken,rasengan_frame,x-(width*0.25*facing),y-35,0.4,0.4,frame_timer * 30,c_white,1);
			}
			if value_in_range(frame,8,9) {
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(spr_rasen_shuriken,rasengan_frame,x,y-(64),0.6,0.6,frame_timer * 30,c_white,1);
			}
			if value_in_range(frame,10,12) {
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(spr_rasen_shuriken,rasengan_frame,x-(width*0.25*facing),y-(35),0.8,0.8,frame_timer * 30,c_white,1);
			}
			if value_in_range(frame,13,15) {
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(spr_rasen_shuriken,rasengan_frame,x+(width*1.5*facing),y-(35),1,1,frame_timer * 30,c_white,1);
			}
		}
		gpu_set_blendmode(bm_normal);
	}
}