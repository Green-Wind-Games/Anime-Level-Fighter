function create_helper(_x,_y,_charscript) {
	var me = id;
	var _helper = instance_create(x+(_x * facing),y+_y,obj_helper);
	with(_helper) {
		owner = me;
		team = me.team;
		facing = me.facing;
		target = me.target;
		
		max_hp = max(1,round(owner.max_hp / 50));
		
		face_target();
		
		_charscript();
	}
	return _helper;
}

function init_helperstates() {
	idle_state.start = function() {
		if on_ground {
			change_sprite(idle_sprite,true);
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
			var _aitime = 15;
			if ((state_timer mod _aitime) == floor(_aitime / 2)) {
				change_sprite(idle_sprite,true);
				helper_script();
				if (!target.is_guarding) {
					if (owner.combo_hits == 0) {
						helper_attack_script();
					}
				}
				else {
					if target_distance_x < 30 {
						change_state(jump_back_state);
					}
				}
			}
		}
		else {
			change_sprite(idle_sprite,true);
		}
		if sprite == walk_sprite {
			accelerate(move_speed * move_speed_mod * move_speed_buff * facing * xscale);
		}
	}
	
	jump_forward_state = new charstate();
	jump_forward_state.start = function() {
		change_sprite(jumpsquat_sprite,false);
		squash_stretch(1.2,0.8);
		face_target();
	}
	jump_forward_state.run = function() {
		if state_timer > 5 {
			change_state(air_state);
			squash_stretch(0.8,1.2);
			yspeed = -5;
			xspeed = move_speed * move_speed_mod * move_speed_buff * facing;
			play_sound(snd_jump);
		}
	}
	
	jump_back_state = new charstate();
	jump_back_state.start = function() {
		change_sprite(jumpsquat_sprite,false);
		squash_stretch(1.2,0.8);
		face_target();
	}
	jump_back_state.run = function() {
		if state_timer > 5 {
			change_state(air_state);
			squash_stretch(0.8,1.2);
			yspeed = -5;
			xspeed = -move_speed * move_speed_mod * move_speed_buff * facing;
			play_sound(snd_jump);
		}
	}

	air_state.start = function() {
		change_sprite(air_peak_sprite,true);
	}
	air_state.run = function() {
		var peak_speed = 2;
		if yspeed < -peak_speed {
			change_sprite(air_up_sprite,true);
		}
		else if yspeed <= peak_speed {
			change_sprite(air_peak_sprite,true);
		}
		else {
			change_sprite(air_down_sprite,true);
		}
		land();
	}

	tech_state.start = function() {
		change_sprite(tech_sprite,false);
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