function set_substitution_jutsu() {
	substitution_state.start = function() {
		change_sprite(air_peak_sprite,3,false);
		reset_sprite();
		timestop();
		can_cancel = false;
		alpha = 0;
		create_particles(x,y,x,y,jutsu_smoke_particle);
	}
	substitution_state.run = function() {
		xspeed = 0;
		yspeed = 0;
		face_target();
		if timestop_timer == 10 {
			substitution_teleport();
			create_particles(x,y,x,y,jutsu_smoke_particle);
			reset_sprite(true,false);
		}
		if !timestop_active {
			change_state(idle_state);
		}
	}
}

function rasengan_script(_chargeframe1, _chargeframe2, _hitframe1, _hitframe2, _direction, _scale, _holdtime, _loopdamage, _enddamage) {
	if (frame > _chargeframe2) and (superfreeze_active) {
		frame = _chargeframe1;
	}
	
	if check_frame(_chargeframe2+1) {
		xspeed = lengthdir_x(20,_direction) * facing;
		xspeed = lengthdir_y(20,_direction);
	}
	
	var _x1 = lengthdir_x(width_half,_direction);
	var _y1 = -height_half + lengthdir_y(height_half,_direction);
	var _x2 = _x1 + lengthdir_x(sprite_get_width(spr_rasengan) * (_scale / 2),_direction);
	var _y2 = _y1 + lengthdir_y(sprite_get_width(spr_rasengan) * (_scale / 2),_direction);
	
	if value_in_range(frame,_hitframe1,_hitframe2) and check_frame(frame) {
		var _ball = create_shot(
			_x2,
			_y2,
			0,
			0,
			spr_rasengan,
			_scale,
			_loopdamage,
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
	if (frame > _hitframe2) and (state_timer < _holdtime) and (combo_hits > 0) {
		frame = _hitframe1;
	}
	
	if check_frame(_hitframe2+1) {
		var _ball = create_shot(
			_x2,
			_y2,
			0,
			0,
			spr_rasengan,
			_scale,
			_enddamage,
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
		play_sound(snd_explosion_small,1,1);
	}
}