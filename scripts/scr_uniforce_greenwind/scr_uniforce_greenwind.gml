globalvar greenwind_color;
greenwind_color = make_color_rgb(128,255,128);

function greenwind_swirls() {
	char_specialeffect(
		spr_wind_spin,
		random_range(-width_half,width_half),
		-random(height),
		0.25,
		0.25,
		random(360),
		random(20),
		greenwind_color
	);
	play_sound(snd_naruto_chakra_loop,0.5,1.5);
}

function add_greenwind_blast_state(_maxrepeats,_sprite1,_sprite2,_fireframe,_ballsprite) {
	max_windblasts = _maxrepeats;
	windblast_count = 0;
	
	windblast_sprite = _sprite1;
	windblast_sprite2 = _sprite2;
	windblast_shot_sprite = _ballsprite;
	
	windblast_fire_frame = _fireframe;
	
	greenwind_blast_state = new charstate();
	greenwind_blast_state.start = function() {
		if attempt_special(1/max_windblasts) and (windblast_count < max_windblasts) {
			change_sprite(
				sprite == windblast_sprite ? windblast_sprite2 : windblast_sprite,
				false
			);
			windblast_count++;
		}
		else {
			change_state(idle_state);
		}
	}
	greenwind_blast_state.run = function() {
		if check_frame(windblast_fire_frame) {
			var _ball = create_shot(
				width_half,
				-height_half,
				20,
				sine_wave(windblast_count,max_windblasts/2,1,0),
				windblast_shot_sprite,
				32 / sprite_get_height(windblast_shot_sprite),
				100,
				3,
				-3,
				attacktype.normal,
				attackstrength.light,
				hiteffects.wind
			);
			with(_ball) {
				play_sound(snd_kiblast_fire,1,1.5);
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
						color = greenwind_color;
						duration = anim_duration;
						active_script = function() {
							if duration mod 4 == 0 {
								with(hitbox) {
									ds_list_clear(hit_list);
								}
							}
							loop_sound(snd_slash_whiff_light,1,1.5);
						}
					}
				}
			}
			if is_airborne {
				xspeed = -2 * facing;
				yspeed = -2;
			}
			
			add_cancel(greenwind_blast_state);
			can_cancel = (windblast_count < max_windblasts) and (check_mp(1/max_windblasts));
		}
		if state_timer >= 50 {
			change_state(idle_state);
		}
	}
	greenwind_blast_state.stop = function() {
		if next_state != greenwind_blast_state {
			windblast_count = 0;
		}
	}
}

function add_greenwind_push_state(_sprite,_fireframe) {
	greenwind_push_sprite = _sprite;
	
	greenwind_push_fire_frame = _fireframe;

	greenwind_push_state = new charstate();
	greenwind_push_state.start = function() {
		if attempt_special(1) {
			change_sprite(greenwind_push_sprite,false);
		}
		else {
			change_state(idle_state);
		}
	}
	greenwind_push_state.run = function() {
		if superfreeze_active {
			frame = 0;
		}
		if check_frame(2) {
			with(create_shot(
				width_half,
				-height_half,
				level*2,
				0,
				spr_wind_spin,
				1,
				1000,
				30,
				-2,
				attacktype.wall_bounce,
				attackstrength.super,
				hiteffects.wind
			)) {
				duration = anim_duration;
				hit_limit = -1;
				color = greenwind_color;
				play_sound(snd_dbz_beam_fire,1,1.5);
			}
			if is_airborne {
				jump_towards(x - (50 * facing),y,10);
			}
		}
		if state_timer > 60 {
			anim_finish_idle();
		}
	}
}

function add_super_greenwind_blade(_sprite,_raiseframe,_lowerframe,_fireframe,_holdframe) {
	super_greenwind_blade_sprite = _sprite;
	super_greenwind_blade_frame_raise = _raiseframe;
	super_greenwind_blade_frame_lower = _lowerframe;
	super_greenwind_blade_frame_fire = _fireframe;
	super_greenwind_blade_frame_hold = _holdframe;
	
	wind_blade_shot = noone;
	
	super_greenwind_blade_state = new charstate();
	super_greenwind_blade_state.start = function() {
		if attempt_super(2) {
			change_sprite(super_greenwind_blade_sprite,false);
			play_sound(snd_dbz_beam_charge_short,1,1);
			superfreeze(50);
		}
		else {
			change_state(idle_state);
		}
	}
	super_greenwind_blade_state.run = function() {
		if sprite_timer < 30 {
			loop_anim_middle(
				super_greenwind_blade_frame_raise,
				super_greenwind_blade_frame_raise
			);
		}
		if superfreeze_active {
			loop_anim_middle(
				super_greenwind_blade_frame_lower,
				super_greenwind_blade_frame_lower
			);
			with(wind_blade_shot) {
				ystretch = approach(ystretch,1,0.1);
			}
		}
		loop_anim_middle_timer(
			super_greenwind_blade_frame_hold,
			super_greenwind_blade_frame_hold,
			30 * (1 + (attack_hits > 0))
		);
		if check_frame(4) {
			wind_blade_shot = create_shot(
				0,
				-height_half,
				20,
				0,
				spr_wind_blade,
				2,
				1000,
				3,
				-3,
				attacktype.normal,
				attackstrength.heavy,
				hiteffects.slash
			);
			with(wind_blade_shot) {
				ystretch = 0;
				play_sound(snd_dbz_beam_fire,0.5,1.5);
				hit_script = function() {
					play_sound(snd_launch,1,1.25);
					var _blades = 10;
					for(var i = 0; i < _blades; i++) {
						var _dir = map_value(i,0,_blades-1,0,360);
						var _speed = 10;
						var _smallblade = create_shot(
							0,
							0,
							lengthdir_x(_speed,_dir),
							lengthdir_y(_speed,_dir),
							spr_wind_blade,
							0.5,
							10,
							3,
							-3,
							attacktype.normal,
							attackstrength.light,
							hiteffects.slash
						);
						with(_smallblade) {
							homing = true;
							duration = 60 - i;
							hit_limit = -1;
							homing_max_turn = 20 + i;
							homing_speed = 20 + i;
							active_script = function() {
								if duration mod 10 == 1 {
									with(hitbox) {
										ds_list_clear(hit_list);
									}
								}
							}
							expire_script = function() {
								play_sound(snd_dbz_energy_stop,0.2,1.5);
							}
						}
					}
				}
			}
		}
		anim_finish_idle();
	}
}