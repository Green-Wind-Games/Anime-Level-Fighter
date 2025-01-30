function update_announcer() {
	switch(game_state) {
		case gamestates.versus_battle:
		switch(round_state) {
			case roundstates.countdown:
			if round_state_timer == 1 {
				play_voiceline(vc_announcer_round_start_ready);
			}
			else if round_state_timer == round_ready_countdown_duration + 1 {
				play_voiceline(vc_announcer_round_start_fight);
			}
			break;
			
			case roundstates.knockout:
			if round_state_timer == 1 {
				play_voiceline(vc_announcer_round_end_knockout);
			}
			break;
		}
		break;
	}
}