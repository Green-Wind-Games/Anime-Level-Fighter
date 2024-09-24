function create_helper(_x,_y,_charscript) {
	var me = id;
	var _helper = instance_create(x+(_x * facing),y+_y,obj_helper);
	with(_helper) {
		owner = me;
		team = me.team;
		facing = me.facing;
		target = me.target;
		
		_charscript();
		
		max_hp = round(owner.max_hp / 50);
		
		face_target();
	}
	return _helper;
}

function init_helperstates() {
	idle_state.start = function() {
		if on_ground {
			change_sprite(idle_sprite,6,true);
			face_target();
			yspeed = 0;
			if ((target.is_hit) or (target.is_guarding) or (combo_timer > -20)) {
				change_state(jump_back_state);
			}
		}
		else {
			change_state(air_state);
		}
	}
	idle_state.run = function() {
		face_target();
		if round_state == roundstates.fight {
			if owner.combo_hits == 0 {
				helper_attack_script();
				if active_state == idle_state {
					if (state_timer mod 30) == 1 {
						helper_script();
					}
				}
			}
			else {
				change_sprite(idle_sprite,6,true);
			}
		}
		else {
			change_sprite(idle_sprite,6,true);
		}
		if sprite == walk_sprite {
			accelerate(move_speed * move_speed_mod * facing * xscale);
		}
	}
	
	jump_forward_state = new state();
	jump_forward_state.start = function() {
		change_sprite(jumpsquat_sprite,2,false);
		squash_stretch(1.2,0.8);
		face_target();
	}
	jump_forward_state.run = function() {
		if state_timer > 5 {
			change_state(air_state);
			squash_stretch(0.8,1.2);
			yspeed = -5;
			xspeed = move_speed * move_speed_mod * facing;
			play_sound(snd_jump);
		}
	}
	
	jump_back_state = new state();
	jump_back_state.start = function() {
		change_sprite(jumpsquat_sprite,2,false);
		squash_stretch(1.2,0.8);
		face_target();
	}
	jump_back_state.run = function() {
		if state_timer > 5 {
			change_state(air_state);
			squash_stretch(0.8,1.2);
			yspeed = -5;
			xspeed = -move_speed * move_speed_mod * facing;
			play_sound(snd_jump);
		}
	}

	air_state.start = function() {
		change_sprite(air_peak_sprite,5,true);
	}
	air_state.run = function() {
		var peak_speed = 2;
		if yspeed < -peak_speed {
			change_sprite(air_up_sprite,5,true);
		}
		else if yspeed <= peak_speed {
			change_sprite(air_peak_sprite,5,true);
		}
		else {
			change_sprite(air_down_sprite,5,true);
		}
		land();
	}

	tech_state.start = function() {
		change_sprite(tech_sprite,6,false);
		flash_sprite();
		yoffset = -height_half;
		rotation_speed = 45;
		xspeed = -5 * facing;
		yspeed = -3;
		dodging_attacks = true;
		dodging_projectiles = true;
		reset_combo();
	}
	tech_state.run = function() {
		if state_timer > 10 {
			change_state(idle_state);
		}
	}
	tech_state.stop = function() {
		dodging_attacks = false;
		dodging_projectiles = false;
	}
}