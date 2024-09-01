if round_state == roundstates.pause exit;
if ((superfreeze_active) and (superfreeze_activator != id)) exit;
if ((timestop_active) and (timestop_activator != id)) exit;
if sprite_exists(aura_sprite) {
	aura_frame += 0.35;
	if aura_frame >= sprite_get_number(aura_sprite) {
		aura_frame = 0;
	}
}
if (hitstop--) exit;

run_animation();

run_state();
if is_char(id) {
	if round_state == roundstates.fight {
		if can_cancel and (!is_hit) and (!is_guarding) {
			check_moves();
		}
	}
}

run_physics();
	
if (!superfreeze_active) and (!timestop_active) {
	decelerate();
	gravitate(ygravity_mod);

	char_script();
	state_timer += 1;
}