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