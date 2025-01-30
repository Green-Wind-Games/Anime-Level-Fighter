update_gamestate();
update_game_substate();

if round_state != roundstates.pause {
	update_particles();
}

update_music();
update_announcer();

update_view();