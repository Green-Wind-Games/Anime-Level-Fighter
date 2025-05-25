for(var i = 0; i < max_players; i++) {
	if player[i] == id {
		if input == player_input[player_slot[i]] {
			input = player_input[i+11];
		}
		else {
			input = player_input[player_slot[i]];
		}
	}
}