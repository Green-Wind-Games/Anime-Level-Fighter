function init_naruto_baseform() {
	init_charsprites("naruto");

	name = "Naruto";
	
	move_speed_mod = 1.25;
	max_air_moves = 1;

	theme = mus_naruto_clashofninja_qualifiers;

	rasengan_cooldown = 0;
	rasengan_cooldown_duration = 100;
	rasengan_frame = 0;
	
	shadow_clone_jutsu_cooldown = 0;
	shadow_clone_jutsu_cooldown_duration = 300;
	
	rasen_shuriken_explosion = noone;
	
	charge_aura = spr_aura_chakra;
	charge_start_sound = noone;
	charge_loop_sound = snd_chakra_loop;
	charge_stop_sound = noone;
	
	transform_aura = spr_aura_chakra;
	
	set_substitution_jutsu();
	
	init_charaudio("naruto");
	voice_volume_mine = 1.5;

	char_script = function() {
		rasengan_cooldown--;
		if active_state == mini_rasengan {
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
	
	var i = 0;
	autocombo[i] = new state();
	autocombo[i].start = function() {
		if on_ground {
			change_sprite(spr_naruto_attack_punch_straight,3,false);
			play_sound(snd_punch_whiff_light);
			play_voiceline(voice_attack,50,false);
		}
		else {
			change_state(autocombo[6]);
		}
	}
	autocombo[i].run = function() {
		basic_attack(2,10,attackstrength.light,hiteffects.hit);
		return_to_idle();
	}
	i++;

	autocombo[i] = new state();
	autocombo[i].start = function() {
		change_sprite(spr_naruto_attack_dash_punch,3,false);
		play_sound(snd_punch_whiff_medium);
		play_voiceline(voice_attack,50,false);
	}
	autocombo[i].run = function() {
		basic_attack(2,10,attackstrength.light,hiteffects.hit);
		return_to_idle();
	}
	i++;

	autocombo[i] = new state();
	autocombo[i].start = function() {
		change_sprite(spr_naruto_attack_punch_hook,4,false);
		play_sound(snd_punch_whiff_medium);
		play_voiceline(voice_attack,50,false);
	}
	autocombo[i].run = function() {
		basic_attack(2,20,attackstrength.medium,hiteffects.hit);
		return_to_idle();
	}
	i++;

	autocombo[i] = new state();
	autocombo[i].start = function() {
		change_sprite(spr_naruto_attack_spinkick,4,false);
		play_sound(snd_punch_whiff_heavy);
		play_voiceline(voice_attack,50,false);
	}
	autocombo[i].run = function() {
		basic_attack(3,20,attackstrength.medium,hiteffects.hit);
		return_to_idle();
	}
	i++;

	autocombo[i] = new state();
	autocombo[i].start = function() {
		change_sprite(spr_naruto_attack_slash,4,false);
		play_sound(snd_slash_whiff_medium);
		play_voiceline(voice_attack,50,false);
	}
	autocombo[i].run = function() {
		basic_attack(2,30,attackstrength.light,hiteffects.slash);
		if check_frame(2) {
			char_specialeffect(spr_slash,width_half,-height_half,0.5,-0.5,-45);
		}
		return_to_idle();
	}
	i++;

	autocombo[i] = new state();
	autocombo[i].start = function() {
		change_sprite(spr_naruto_attack_slash_up,4,false);
		play_sound(snd_slash_whiff_heavy);
		play_voiceline(voice_heavyattack,50,false);
	}
	autocombo[i].run = function() {
		if check_frame(3) {
			create_hitbox(
				0,
				-height,
				width,
				height,
				50,
				1,
				-5,
				attacktype.hard_knockdown,
				attackstrength.heavy,
				hiteffects.slash
			);
			xspeed = 3 * facing;
			yspeed = -3;
			
			char_specialeffect(spr_slash2,width*0.9,-height*0.75,0.5,-0.5,-45);
		}
		can_cancel = false;
		if on_ground and anim_finished {
			if target.is_hit {
				change_state(uzumaki_barrage_start);
			}
			else {
				change_state(idle_state);
			}
		}
	}
	i++;
	
	autocombo[i] = new state();
	autocombo[i].start = function() {
		change_sprite(spr_naruto_attack_smash_kick,3,false);
		play_sound(snd_punch_whiff_super);
		play_voiceline(voice_heavyattack,50,false);
	}
	autocombo[i].run = function() {
		basic_smash(3,100,hiteffects.hit);
		land();
	}
	i++;

	forward_throw = new state();
	forward_throw.start = function() {
		change_sprite(spr_naruto_spinkick_up,5,false);
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
		if check_frame(2) {
			play_sound(snd_punch_whiff_heavy);
			play_voiceline(voice_heavyattack,100,true);
		}
		if check_frame(4) {
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
	
	uzumaki_barrage_start = new state();
	uzumaki_barrage_start.start = function() {
		change_sprite(spr_naruto_jutsu,3,false);
		play_sound(snd_jutsu_activate);
		play_voiceline(snd_naruto_uzumaki);
		if instance_number(obj_char) <= 2 {
			timestop(60);
		}
		xspeed = -8 * facing;
	}
	uzumaki_barrage_start.run = function() {
		decelerate();
		if (frame > 3) and timestop_active {
			frame = 2;
		}
		if check_frame(4) {
			create_helper(-75,0,init_naruto_baseform_clone_barrage);
			create_helper(235,0,init_naruto_baseform_clone_barrage);
			create_helper(-65,0,init_naruto_baseform_clone_barrage);
			create_helper(225,0,init_naruto_baseform_clone_barrage);
		}
		can_cancel = false;
		if anim_finished {
			if target.is_hit {
				change_state(uzumaki_barrage_flip);
			}
			else {
				change_state(idle_state);
			}
		}
	}

	uzumaki_barrage_flip = new state();
	uzumaki_barrage_flip.start = function() {
		change_sprite(spr_naruto_flip,3,true);
		yoffset = -height_half;
		rotation_speed = -45;
		xspeed = (target_distance_x / 30) * facing;
		yspeed = target.yspeed * 1.05;
	}
	uzumaki_barrage_flip.run = function() {
		if (state_timer mod 5) == 0 {
			play_sound(snd_punch_whiff_light,1.5,1.25);
		}
		if state_timer >= 30 {
			change_state(autocombo[6]);
			play_voiceline(snd_naruto_uzumakibarrage);
		}
	}
	
	shuriken_throw = new state();
	shuriken_throw.start = function() {
		change_sprite(spr_naruto_special_throw_shuriken,5,false);
		play_voiceline(voice_attack,50,false);
	}
	shuriken_throw.run = function() {
		if check_frame(3) {
			shuriken = create_shot(
				10,
				-35,
				12,
				0,
				spr_shuriken,
				1,
				10,
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
				active_script = function() {
					if y >= ground_height {
						homing = false;
						yspeed = 0;
						xspeed /= 2;
						if duration > 10 {
							duration = 10;
						}
					}
				}
				hit_script = function() {
					xspeed /= 2;
					yspeed /= 2;
					homing = false;
					affected_by_gravity = true;
				}
			}
		}
		return_to_idle();
	}
	
	triple_shuriken_throw = new state();
	triple_shuriken_throw.start = function() {
		change_sprite(spr_naruto_special_throw_shuriken,6,false);
		play_voiceline(voice_attack,50,false);
	}
	triple_shuriken_throw.run = function() {
		if check_frame(3) {
			repeat(3) {
				shuriken = create_shot(
					10,
					-35,
					12,
					random_range(-2,1),
					spr_shuriken,
					1,
					5,
					3,
					0,
					attacktype.normal,
					attackstrength.light,
					hiteffects.slash
				);
				with(shuriken) {
					blend = false;
					hit_limit = -1;
					active_script = function() {
						if y >= ground_height {
							homing = false;
							yspeed = 0;
							xspeed /= 2;
							if duration == -1 {
								duration = 20;
							}
						}
					}
					hit_script = function() {
						xspeed /= 2;
						yspeed /= 2;
						homing = false;
						affected_by_gravity = true;
					}
				}
			}
		}
		return_to_idle();
	}
	
	mini_rasengan = new state();
	mini_rasengan.start = function() {
		if check_mp(1) and (!rasengan_cooldown) {
			if on_ground {
				change_sprite(spr_naruto_special_rasengan,3,false);
				activate_super(60);
				spend_mp(1);
				deflecting_projectiles = true;
			}
			else {
				if previous_state == autocombo[6] {
					create_particles(x,y,x,y,jutsu_smoke_particle);
					x = target_x - (100 * facing);
					y = ground_height - 500;
					create_particles(x,y,x,y,jutsu_smoke_particle);
				}
				change_state(rasengan_dive);
			}
		}
		else {
			change_state(previous_state);
		}
	}
	mini_rasengan.run = function() {
		if check_frame(4) {
			play_sound(snd_rasengan_charge);
		}
		if (frame > 6) and (superfreeze_active) {
			frame = 5;
		}
		if check_frame(7) {
			xspeed = 20 * facing;
			play_voiceline(snd_naruto_rasengan);
		}
		if frame > 10 {
			deflecting_projectiles = false;
		}
		if (frame > 12) and (state_timer < 90) and (combo_hits > 0) {
			frame = 11;
		}
		if check_frame(9)
		or check_frame(10)
		or check_frame(11) {
			var _ball = create_shot(
				width*1.5,
				-height_half,
				0,
				0,
				spr_rasengan,
				0.2,
				10,
				0,
				0,
				attacktype.normal,
				attackstrength.light,
				hiteffects.hit
			);
			with(_ball) {
				duration = 3;
				alpha = 0;
			}
		}
		if check_frame(13) {
			if (combo_hits > 0) {
				var _ball = create_shot(
					width*1.5,
					-height_half,
					0,
					0,
					spr_rasengan,
					0.2,
					100,
					15,
					-3,
					attacktype.hard_knockdown,
					attackstrength.super,
					hiteffects.hit
				);
				with(_ball) {
					duration = 3;
					alpha = 0;
				}
			}
			play_sound(snd_explosion_medium,1,1.25);
		}
		if check_frame(4) or check_frame(7) {
			create_particles(
				x-(width*facing),
				y,
				x-(width*facing),
				y,
				jutsu_smoke_particle
			);
		}
		return_to_idle();
	}
	mini_rasengan.stop = function() {
		deflecting_projectiles = false;
	}
	
	rasengan_dive = new state();
	rasengan_dive.start = function() {
		if check_mp(1) and (!rasengan_cooldown) {
			change_sprite(spr_naruto_special_rasengan_dive,3,false);
			activate_super(30);
			spend_mp(1);
			xspeed = 0;
			yspeed = 0;
			play_voiceline(snd_naruto_rasengan);
		}
		else {
			change_state(previous_state);
		}
	}
	rasengan_dive.run = function() {
		var _target_y = target_y - target.height - 10;
		if check_frame(5) {
			play_sound(snd_rasengan_charge,1,1.5);
		}
		if (frame > 7) and (superfreeze_active) {
			frame = 6;
		}
		if (frame == 10) and (y < _target_y) {
			frame = 8;
		}
		if (frame > 11) and (state_timer < 90) and (combo_hits > 0) {
			frame = 10;
		}
		if value_in_range(frame,8,9)  {
			xspeed = 10 * facing;
			yspeed = 15;
		}
		if (frame <= 11) and (target_distance_x <= 10) {
			xspeed = 0;
			x = target_x;
			if value_in_range(y,_target_y,target_y) {
				y = _target_y;
				yspeed = 0;
			}
		}
		if check_frame(10)
		or check_frame(11) {
			var _ball = create_shot(
				-width_half,
				64,
				0,
				0,
				spr_rasengan,
				0.3,
				10,
				0,
				0,
				attacktype.normal,
				attackstrength.light,
				hiteffects.hit
			);
			with(_ball) {
				duration = 3;
				alpha = 0;
			}
		}
		if check_frame(12) {
			if (combo_hits > 0) {
				var _ball = create_shot(
					0,
					64,
					0,
					0,
					spr_rasengan,
					0.3,
					100,
					1,
					15,
					attacktype.hard_knockdown,
					attackstrength.super,
					hiteffects.hit
				);
				with(_ball) {
					duration = 3;
					alpha = 0;
				}
			}
			play_sound(snd_explosion_medium);
			
			xspeed = -5 * facing;
			yspeed = -10;
		}
		if check_frame(4) or check_frame(12) {
			create_particles(
				x-(width_half*facing),
				y,
				x-(width_half*facing),
				y,
				jutsu_smoke_particle
			);
		}
		if anim_finished {
			land();
		}
	}
	
	double_rasengan = new state();
	double_rasengan.start = function() {
		if (on_ground) and check_mp(2) and (!rasengan_cooldown) {
			change_sprite(spr_naruto_special_doublerasengan,3,false);
			activate_super(80);
			spend_mp(2);
		}
		else {
			change_state(previous_state);
		}
	}
	double_rasengan.run = function() {
		if check_frame(4) {
			play_sound(snd_rasengan_charge,1,1.2);
			play_sound(snd_rasengan_charge,1,0.8);
		}
		if (frame > 6) and (superfreeze_active) {
			frame = 5;
		}
		if check_frame(7) {
			xspeed = 20 * facing;
			play_voiceline(snd_naruto_rasengan);
			play_sound(snd_naruto_rasengan,0.75,1.2);
		}
		if (frame > 12) and (state_timer < 120) and (combo_hits > 0) {
			frame = 11;
		}
		if check_frame(9)
		or check_frame(10)
		or check_frame(11) {
			var _ball = create_shot(
				width*1.5,
				-height_half,
				0,
				0,
				spr_rasengan,
				0.2,
				15,
				0,
				0,
				attacktype.normal,
				attackstrength.light,
				hiteffects.hit
			);
			with(_ball) {
				duration = 3;
				alpha = 0;
			}
		}
		if check_frame(13) {
			if (combo_hits > 0) {
				var _ball = create_shot(
					width*1.5,
					-height_half,
					0,
					0,
					spr_rasengan,
					0.2,
					150,
					30,
					-2,
					attacktype.wall_bounce,
					attackstrength.super,
					hiteffects.hit
				);
				with(_ball) {
					duration = 3;
					alpha = 0;
				}
			}
			play_sound(snd_explosion_medium,1.25);
		}
		if check_frame(4) or check_frame(7) {
			create_particles(
				x-(width*facing),
				y,
				x-(width*facing),
				y,
				jutsu_smoke_particle
			);
			create_particles(
				x+(width*facing),
				y,
				x+(width*facing),
				y,
				jutsu_smoke_particle
			);
		}
		return_to_idle();
	}
	
	giant_rasengan = new state();
	giant_rasengan.start = function() {
		if (on_ground) and check_mp(3) and (!rasengan_cooldown) {
			change_sprite(spr_naruto_special_giantrasengan,3,false);
			activate_super(80);
			spend_mp(3);
		}
		else {
			change_state(previous_state);
		}
	}
	giant_rasengan.run = function() {
		if check_frame(4) {
			play_sound(snd_rasengan_charge,1,0.8);
		}
		if (frame > 6) and (superfreeze_active) {
			frame = 5;
		}
		if check_frame(7) {
			xspeed = 20 * facing;
			play_voiceline(snd_naruto_giantrasengan);
		}
		if (frame > 12) and (state_timer < 120) {
			frame = 11;
		}
		if check_frame(10)
		or check_frame(11)
		or check_frame(12) {
			var _ball = create_shot(
				100,
				-30,
				0,
				0,
				spr_rasengan,
				1,
				12,
				0,
				0,
				attacktype.normal,
				attackstrength.light,
				hiteffects.hit
			);
			with(_ball) {
				duration = 3;
				alpha = 0;
			}
		}
		if check_frame(13) {
			var _ball = create_shot(
				100,
				-30,
				0,
				0,
				spr_rasengan,
				1,
				120,
				15,
				-3,
				attacktype.hard_knockdown,
				attackstrength.super,
				hiteffects.hit
			);
			with(_ball) {
				duration = 3;
				alpha = 0;
			}
			play_sound(snd_explosion_medium);
		}
		if check_frame(4) {
			create_particles(
				x-(width*facing),
				y,
				x-(width*facing),
				y,
				jutsu_smoke_particle
			);
		}
		if check_frame(13) {
			create_particles(
				x,
				y,
				x,
				y,
				jutsu_smoke_particle
			);
		}
		return_to_idle();
	}

	shadow_clone_jutsu = new state();
	shadow_clone_jutsu.start = function() {
		if check_mp(2) and (!shadow_clone_jutsu_cooldown) {
			change_sprite(spr_naruto_jutsu,5,false);
			activate_super();
			spend_mp(2);
			play_sound(snd_jutsu_activate);
			play_voiceline(snd_naruto_shadowclonejutsu);
		}
		else {
			change_state(previous_state);
		}
	}
	shadow_clone_jutsu.run = function() {
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
		if superfreeze_active {
			if frame > 5 { 
				frame = 4;
			}
		}
		return_to_idle();
	}
	
	shadow_clone_barrage = new state();
	shadow_clone_barrage.start = function() {
		if check_mp(1) {
			change_sprite(spr_naruto_jutsu,3,false);
			activate_super();
			spend_mp(1);
			play_sound(snd_jutsu_activate);
			play_voiceline(snd_naruto_shadowclonejutsu);
		}
		else {
			change_state(previous_state);
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
					
					affected_by_gravity = true;
					
					blend = false;
					rotation_speed = 0.1;
					rotation = 0;
					
					create_particles(
						x,
						y,
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
							x,
							y,
							jutsu_smoke_particle
						);
					}
					
					play_sound(owner.voice_attack,0.2);
				}
			}
		}
		return_to_idle();
	}
	
	rasen_shuriken = new state();
	rasen_shuriken.start = function() {
		if (on_ground) and check_mp(4) and (!rasengan_cooldown) {
			change_sprite(spr_naruto_special_rasenshuriken,3,false);
			activate_ultimate(150);
			spend_mp(4);
		}
		else {
			change_state(previous_state);
		}
	}
	rasen_shuriken.run = function() {
		if sprite == spr_naruto_special_rasenshuriken {
			if check_frame(4) {
				play_sound(snd_rasen_shuriken_spin);
			}
			if (frame > 6) and (superfreeze_timer > 100) {
				frame = 5;
			}
			if check_frame(7) {
				play_voiceline(snd_naruto_rasenshuriken);
			}
			if (frame > 9) and (superfreeze_active) {
				frame = 8;
			}
			if check_frame(4) or check_frame(7) {
				create_particles(
					x-(width*facing),
					y,
					x-(width*facing),
					y,
					jutsu_smoke_particle
				);
				create_particles(
					x+(width*facing),
					y,
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
					20,
					1,
					-15,
					attacktype.hard_knockdown,
					attackstrength.medium,
					hiteffects.none
				);
				with(_explosion) {
					change_sprite(sprite,1,true);
					blend = true;
					duration = 60 * 3;
					alpha = 0;
					hit_limit = -1;
					active_script = function() {
						y = ground_height - height_half;
						if duration > 30 {
							alpha = approach(alpha,1,1/30);
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
							if alpha == 1 {
								play_sound(snd_rasen_shuriken_end);
							}
							alpha = approach(alpha,0,1/30);
						}
					}
					hit_script = function(_hit) {
						if is_char(_hit) or is_helper(_hit) {
							with(_hit) {
								change_state(hard_knockdown_state);
							}
						}
					}
					play_sound(snd_rasen_shuriken_hit);
				}
				rasen_shuriken_explosion = _explosion;
			}
			if check_frame(16) {
				take_damage(noone,50,false);
				change_sprite(launch_sprite,3,true);
				xspeed = -10 * facing;
				yspeed = -5;
				stop_sound(snd_rasen_shuriken_spin);
				play_voiceline(voice_hurt_heavy);
			}
		}
		else if sprite == launch_sprite {
			if on_ground {
				change_sprite(liedown_sprite,3,true);
			}
		}
		else if sprite == liedown_sprite {
			if !instance_exists(rasen_shuriken_explosion) {
				change_state(liedown_state);
			}
		}
	}

	setup_autocombo();

	add_move(shuriken_throw,"B");
	add_move(triple_shuriken_throw,"2B");
	
	add_move(mini_rasengan,"C");
	add_move(double_rasengan,"2C");
	add_move(giant_rasengan,"EC");
	add_move(rasen_shuriken,"EEC");
	
	add_move(shadow_clone_barrage,"D");
	add_move(shadow_clone_jutsu,"ED");

	//var i = 0;
	//voice_attack[i++] = snd_naruto_attack1;
	//voice_attack[i++] = snd_naruto_attack2;
	//voice_attack[i++] = snd_naruto_attack3;
	//voice_attack[i++] = snd_naruto_attack4;
	//voice_attack[i++] = snd_naruto_attack5;
	//i = 0;
	//voice_heavyattack[i++] = snd_naruto_heavyattack1;
	//voice_heavyattack[i++] = snd_naruto_heavyattack2;
	//voice_heavyattack[i++] = snd_naruto_heavyattack3;
	//i = 0;
	//voice_hurt[i++] = snd_naruto_hurt1;
	//voice_hurt[i++] = snd_naruto_hurt2;
	//voice_hurt[i++] = snd_naruto_hurt3;
	//voice_hurt[i++] = snd_naruto_hurt4;
	//voice_hurt[i++] = snd_naruto_hurt5;
	//i = 0;
	//voice_hurt_heavy[i++] = snd_naruto_hurt_heavy1;
	//voice_hurt_heavy[i++] = snd_naruto_hurt_heavy2;
	//voice_hurt_heavy[i++] = snd_naruto_hurt_heavy3;
	//voice_hurt_heavy[i++] = snd_naruto_hurt_heavy4;
	//voice_hurt_heavy[i++] = snd_naruto_hurt_heavy5;

	victory_state.run = function() {
		if anim_finished {
			if frame >= anim_frames - 1 {
				frame = anim_frames - 4;
			}
		}
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
				draw_sprite_ext(spr_rasengan,rasengan_frame,x-(width*0.75*facing),y-(height*0.69),0.05,0.05,0,c_white,1);
			}
			if value_in_range(frame,7,8) {
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(spr_rasengan,rasengan_frame,x,y-(height*0.69),0.1,0.1,0,c_white,1);
			}
			if value_in_range(frame,9,12) {
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(spr_rasengan,rasengan_frame,x+(width*1.5*facing),y-(height*0.69),0.2,0.2,0,c_white,1);
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
					y-(height*0.69),
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
				draw_sprite_ext(spr_rasengan,rasengan_frame,x-(width*0.5*facing),y-(height*0.8),0.1,0.1,0,c_white,1);
			}
			if value_in_range(frame,8,9) {
				draw_sprite_ext(spr_naruto_clone_rasengan_air,(frame mod 2) + 3,x-(width*facing),y+5,facing,1,0,c_white,1);
				
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(spr_rasengan,rasengan_frame,x-(width_half*facing),y-(height*0.75),0.3,0.3,0,c_white,1);
			}
			if value_in_range(frame,10,11) {
				draw_sprite_ext(spr_naruto_clone_rasengan_air,(frame mod 2) + 5,x-(width*0.75*facing),y,facing,1,0,c_white,1);
				
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(spr_rasengan,rasengan_frame,x-(width*facing/3),y+(height*0.5),0.5,0.5,0,c_white,1);
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
				draw_sprite_ext(spr_rasengan,rasengan_frame,x+(50*facing),y-30,0.5,0.5,0,c_white,1);
				draw_sprite_ext(spr_rasengan,rasengan_frame,x+(45*facing),y-35,0.5,0.5,0,c_white,1);
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
				draw_sprite_ext(spr_rasengan,rasengan_frame,x-(width*0.6*facing),y-(height*0.64),0.2,0.2,0,c_white,1);
			}
			if value_in_range(frame,7,10) {
				draw_sprite_ext(spr_naruto_clone_giantrasengan,(frame mod 4) + 3,x-(width*facing),y,facing,1,0,c_white,1);
				
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(spr_rasengan,rasengan_frame,x,y-(height*0.69),0.3,0.3,0,c_white,1);
			}
			if value_in_range(frame,11,12) {
				draw_sprite_ext(spr_naruto_clone_giantrasengan,(frame mod 2) + 7,x-(width_half*facing),y,facing,1,0,c_white,1);
				
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(spr_rasengan,rasengan_frame,x+(100*facing),y-30,1,1,0,c_white,1);
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
					y-30,
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
				draw_sprite_ext(spr_rasen_shuriken,rasengan_frame,x,y-(height*0.5),0.2,0.2,frame_timer * 30,c_white,1);
			}
			if frame == 7 {
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(spr_rasen_shuriken,rasengan_frame,x-(width*0.25*facing),y-(height*0.75),0.4,0.4,frame_timer * 30,c_white,1);
			}
			if value_in_range(frame,8,9) {
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(spr_rasen_shuriken,rasengan_frame,x,y-(height*1.35),0.6,0.6,frame_timer * 30,c_white,1);
			}
			if value_in_range(frame,10,12) {
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(spr_rasen_shuriken,rasengan_frame,x-(width*0.25*facing),y-(height*0.75),0.8,0.8,frame_timer * 30,c_white,1);
			}
			if value_in_range(frame,13,15) {
				gpu_set_blendmode(bm_add);
				draw_sprite_ext(spr_rasen_shuriken,rasengan_frame,x+(width*1.5*facing),y-(height*0.75),1,1,frame_timer * 30,c_white,1);
			}
		}
		gpu_set_blendmode(bm_normal);
	}
}