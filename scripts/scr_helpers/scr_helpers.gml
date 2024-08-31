function create_helper(_x,_y,_charscript,_aiscript) {
	var me = id;
	var _helper = instance_create(x+(_x * facing),y+_y,obj_helper);
	with(_helper) {
		_charscript();
		
		owner = me;
		team = me.team;
		facing = me.facing;
		target = me.target;
		ai_script = _aiscript;
		
		max_hp = round(owner.max_hp / 50);
	}
	return _helper;
}

function init_helperstates() {
	idle_state.start = function() {
		if on_ground {
			change_sprite(idle_sprite,6,true);
			face_target();
			yspeed = 0;
		}
		else {
			change_state(air_state);
		}
	}
	idle_state.run = function() {
		face_target();
		if round_state == roundstates.fight {
			if (state_timer mod 20) == 1 {
				if choose(true,false) {
					helper_attack_script();
				}
				if active_state == idle_state {
					helper_script();
				}
			}
		}
		else {
			change_sprite(idle_sprite,6,true);
		}
		if sprite == walk_sprite {
			accelerate(move_speed * facing * xscale);
		}
	}

	jump_state.start = function() {
		change_sprite(crouch_sprite,2,false);
		squash_stretch(1.2,0.8);
		face_target();
	}
	jump_state.run = function() {
		if state_timer > 5 {
			change_state(air_state);
			squash_stretch(0.8,1.2);
			yspeed = -5;
			xspeed = move_speed * facing;
			if target_distance_x < 30 {
				xspeed = -xspeed;
			}
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
			change_state(air_state);
		}
	}
	tech_state.stop = function() {
		dodging_attacks = false;
		dodging_projectiles = false;
	}
}