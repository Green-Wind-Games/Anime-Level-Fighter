if round_state == roundstates.pause exit;
if ((superfreeze_active) and (superfreeze_activator != id)) exit;
if ((timestop_active) and (timestop_activator != id)) exit;

hitstop -= game_speed;
if hitstop exit;

update_charsprite();

if value_in_range(
	round_state_timer - floor(round_state_timer),
	0,
	game_speed - 0.001
) {
	update_charstate();
}

update_charphysics();

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
	
	if (round_state_timer mod 1 >= 0)
	and (round_state_timer mod 1 < game_speed) {
		char_script();
	}
	
	state_timer += game_speed;
}