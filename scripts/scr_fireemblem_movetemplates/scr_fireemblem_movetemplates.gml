function add_myrmidon_slash_state(_chargesprite,_sprite1,_sprite2,_sprite3) {
	myrmidon_slash_sprite_charge = _chargesprite;
	myrmidon_slash_sprite1 = _sprite1;
	myrmidon_slash_sprite2 = _sprite2;
	myrmidon_slash_sprite3 = _sprite3;
	
	myrmidon_slash_state = new charstate();
	myrmidon_slash_state.start = function() {
		if attempt_super(3) {
			change_sprite(tech_sprite,3,false);
			yoffset = -height_half;
			face_target();
			
			var _fliptime = superfreeze_timer/2;
			jump_towards(
				x - (50 * facing),
				ground_height,
				_fliptime
			)
			
			rotation_speed = (360 / _fliptime);
			if sign(xspeed) == facing {
				rotation_speed *= -1;
			}
		}
		else {
			change_state(idle_state);
		}
	}
	myrmidon_slash_state.run = function() {
		if sprite == tech_sprite {
			gravitate(1);
			if on_ground and yspeed > 0 {
				change_sprite(myrmidon_slash_sprite_charge,3,false);
				xspeed = 0;
				yspeed = 0;
			}
		}
		else if sprite == myrmidon_slash_sprite_charge {
			if !superfreeze_active {
				change_sprite(myrmidon_slash_sprite3,5,false);
				alpha = 0;
				
				var _slash1 = create_shot(
					0,
					-height,
					30,
					5,
					myrmidon_slash_sprite1,
					1,
					500,
					0,
					0,
					attacktype.normal,
					attackstrength.heavy,
					hiteffects.slash
				);
				var _slash2 = create_shot(
					0,
					height,
					25,
					-5,
					myrmidon_slash_sprite2,
					1,
					500,
					0,
					0,
					attacktype.normal,
					attackstrength.heavy,
					hiteffects.slash
				);
				var _slash3 = create_shot(
					-width * 2,
					0,
					20,
					0,
					myrmidon_slash_sprite1,
					1,
					500,
					0,
					0,
					attacktype.normal,
					attackstrength.heavy,
					hiteffects.slash
				);
				with(_slash1) {
					change_sprite(sprite,3,false);
					blend = false;
					hit_limit = -1;
				}
				with(_slash2) {
					change_sprite(sprite,4,false);
					blend = false;
					hit_limit = -1;
				}
				with(_slash3) {
					change_sprite(sprite,5,false);
					blend = false;
					hit_limit = -1;
				}
			}
		}
		else {
			if check_frame(2) {
				alpha = 1;
				xspeed = 30 * facing;
			}
			if check_frame(4) {
				hitbox = create_hitbox(
					0,
					-height,
					width*2,
					height,
					2000,
					0,
					-10,
					attacktype.hard_knockdown,
					attackstrength.super,
					hiteffects.slash
				);
			}
		}
		if state_timer > 60 {
			change_state(idle_state);
		}
	}
}