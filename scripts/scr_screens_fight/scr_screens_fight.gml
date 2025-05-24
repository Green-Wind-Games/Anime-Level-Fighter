function toggle_pause() {
	if round_state == roundstates.fight {
		pause_game();
	}
	else if round_state == roundstates.pause {
		unpause_game();
	}
}

function pause_game() {
	round_state = roundstates.pause;
	var _options = [
		[
			["Resume",unpause_game],
			//["Settings",-1],
			["Quit Match",goto_versus_select]
		],
	];
	if game_state == gamestates.training {
		_options = [
			["Resume",unpause_game],
			["Reset Training",goto_training],
			["Quit Match",goto_versus_select]
		];
	}
		open_menu(
			gui_width/2,
			gui_height/2,
			[
				["Resume",unpause_game],
				//["Settings",-1],
				["Quit Match",goto_versus_select]
			],
			"Pause Menu"
		);
}

function unpause_game() {
	instance_destroy(obj_menu);
	round_state = roundstates.fight;
}