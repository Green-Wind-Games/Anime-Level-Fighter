if round_state == roundstates.pause exit;
if ((superfreeze_active) and (superfreeze_activator != id)) exit;
if ((timestop_active) and (timestop_activator != id)) exit;

if (hitstop--) exit;

update_sprite();

update_state();

update_physics();

if (round_state == roundstates.fight) and (is_char(id)) {
	switch(active_state) {
		case idle_state:
		case air_state:
		check_moves();
		break;
		
		default:
		if (can_cancel) and (!is_hit) and (!is_guarding) {
			check_moves();
		}
		break;
	}
}

var stay_in = true;
if (is_helper(id) and (duration != -1)) stay_in = false;

if stay_in {
	x = clamp(x, left_wall, right_wall);
}
y = min(y,ground_height);
	
if (!superfreeze_active) and (!timestop_active) {
	if on_ground {
		decelerate();
	}
	else {
		gravitate(ygravity_mod);
	}

	char_script();
	state_timer += 1;
}