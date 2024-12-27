globalvar jutsu_smoke_particle;

jutsu_smoke_particle = part_type_create();
part_type_sprite(jutsu_smoke_particle,spr_jutsu_smoke,true,true,false);
part_type_life(jutsu_smoke_particle,30,30);
part_type_size(jutsu_smoke_particle,0.6,0.6,0,0);
part_type_blend(jutsu_smoke_particle,true);
part_type_alpha3(jutsu_smoke_particle,1,1,0);

function set_substitution_jutsu() {
	substitution_state.start = function() {
		change_sprite(air_peak_sprite,3,false);
		reset_sprite();
		timestop();
		can_cancel = false;
		alpha = 0;
		create_particles(x,y,jutsu_smoke_particle);
	}
	substitution_state.run = function() {
		xspeed = 0;
		yspeed = 0;
		face_target();
		if timestop_timer == 10 {
			substitution_teleport();
			create_particles(x,y,jutsu_smoke_particle);
			reset_sprite(true,false);
		}
		if !timestop_active {
			change_state(idle_state);
		}
	}
}

function rasengan_script(_chargeframe1, _chargeframe2, _hitframe1, _hitframe2, _direction, _scale, _holdtime, _loopdamage, _enddamage) {
	if superfreeze_active {
		loop_anim_middle(_chargeframe1,_chargeframe2);
	}
	
	if check_frame(_chargeframe2+1) {
		xspeed = lengthdir_x(25,_direction) * facing;
		xspeed = lengthdir_y(25,_direction);
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
	if (combo_hits > 0) {
		loop_anim_middle_timer(_hitframe1,_hitframe2,100);
	}
	
	if check_frame(_hitframe2+1) {
		var _ball = create_shot(
			_x2,
			_y2,
			0,
			0,
			spr_rasengan,
			_scale * 1.5,
			_enddamage,
			lengthdir_x(10,_direction),
			lengthdir_y(10,_direction)-3,
			attacktype.hard_knockdown,
			attackstrength.heavy,
			hiteffects.hit
		);
		with(_ball) {
			duration = 3;
			alpha = 0;
		}
		play_sound(snd_explosion_small,1,1);
	}
}