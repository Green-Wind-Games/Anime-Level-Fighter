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
	play_sound(snd_chakra_loop,0.75,2);
}

function add_greenwind_blast_state(_maxrepeats,_sprite1,_sprite2,_fireframe,_ballsprite) {
	max_windblasts = _maxrepeats;
	windblast_count = 0;
	
	windblast_sprite = _sprite1;
	windblast_sprite2 = _sprite2;
	windblast_shot_sprite = _ballsprite;
	
	windblast_fire_frame = _fireframe;
	
	greenwind_blast = new charstate();
	greenwind_blast.start = function() {
		if attempt_special(1/max_windblasts) and (windblast_count < max_windblasts) {
			change_sprite(
				sprite == windblast_sprite ? windblast_sprite2 : windblast_sprite,
				2,
				false
			);
			windblast_count++;
		}
		else {
			change_state(idle_state);
		}
	}
	greenwind_blast.run = function() {
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
							if duration mod 3 == 0 {
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
			
			add_cancel(greenwind_blast);
			can_cancel = (windblast_count < max_windblasts) and (check_mp(1/max_windblasts));
		}
		if state_timer >= 50 {
			change_state(idle_state);
		}
	}
	greenwind_blast.stop = function() {
		if next_state != greenwind_blast {
			windblast_count = 0;
		}
	}
}

function add_greenwind_push_state(_sprite,_fireframe) {
	greenwind_push_sprite = _sprite;
	
	greenwind_push_fire_frame = _fireframe;

	greenwind_push = new charstate();
	greenwind_push.start = function() {
		if attempt_special(1) {
			change_sprite(windblast_sprite,3,false);
		}
		else {
			change_state(idle_state)
		}
	}
	greenwind_push.run = function() {
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
			return_to_idle();
		}
	}
}