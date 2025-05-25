function ai_combo() {
	if ds_list_size(combo_moves) > 0 {
		get_ai_combo_list(object_index);
		var _move_id = ds_list_size(combo_moves)-1;
		var _shuffle = array_shuffle(ai_combo_list);
		for(var i = 0; i < array_length(_shuffle); i++) {
			var _combo_length = array_length(_shuffle[i]);
			
			if _move_id >= _combo_length - 1 continue;
			if active_state != _shuffle[i][_move_id] continue;
			
			ai_input_move(
				_shuffle[i][_move_id+1],
				100
			);
			print("combo");
		}
	}
}

function get_ai_combo_list(_obj) {
	var _combo_list = array_create(0);
	array_push(
		_combo_list,
		[
			medium_sweep,
			medium_attack,
			medium_airattack,
			light_airattack_repeat,
			light_airattack_repeat2,
			heavy_air_launcher,
			homing_dash_state,
			medium_airattack,
			light_airattack_repeat,
			light_airattack_repeat2,
			heavy_air_launcher,
			light_airattack,
			light_airattack2,
			light_airattack3
		]
	);
	switch(_obj) {
		case obj_naruto:
		array_push(
			_combo_list[0],
			divekick,
			light_airattack,
			light_airattack2,
			light_airattack3,
			divekick
		);
		array_push(
			_combo_list,
			[
				medium_sweep,
				medium_attack,
				medium_airattack,
				light_airattack_repeat,
				light_airattack_repeat2,
				heavy_air_launcher,
				homing_dash_state,
				medium_airattack,
				light_airattack_repeat,
				light_airattack_repeat2,
				heavy_air_launcher,
				light_airattack,
				light_airattack2,
				light_airattack3,
				rasengan_dive
			]
		);
		break;
	}
	
	ai_combo_list = _combo_list;
}