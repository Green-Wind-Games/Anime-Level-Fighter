// Inherit the parent event
event_inherited();

input = instance_create(0,0,obj_input);
with(input) {
	type = input_types.ai;
	persistent = false;
}

death_script = function() {
	if death_timer >= hitstun {
		instance_destroy();
	}
}
	
idle_state = new state();
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
		if state_timer mod 10 == 0 {
			if irandom(3) == 1 {
				change_sprite(idle_sprite,3,true);
			}
			else {
				change_sprite(walk_sprite,6,true);
			}
			if irandom(10) == 1 {
				change_state(jump_state);
			}
			if (irandom(2) == 1) {
				if (target_distance < 10) {
					change_state(melee_state);
				}
				else if (target_distance > 100) {
					change_state(shoot_state);
				}
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

jump_state = new state();
jump_state.start = function() {
	change_sprite(crouch_sprite,2,false);
	squash_stretch(1.2,0.8);
	face_target();
}
jump_state.run = function() {
	if state_timer > 5 {
		yspeed = -5;
		xspeed = move_speed * choose(1,-1);
		change_state(air_state);
		squash_stretch(0.8,1.2);
		play_sound(snd_jump);
	}
}

air_state = new state();
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
	
tech_state = new state();
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