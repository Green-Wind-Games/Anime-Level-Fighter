function get_char_transform_tree() {
	switch(object_index) {
		case obj_goku:
		return [
			obj_goku,
			obj_goku_ssj,
			//obj_goku_ssj3,
			//[obj_goku_ss_god, obj_goku_ss_blue],
			//obj_goku_mui
		];
		break;
		
		case obj_naruto:
		return [
			obj_naruto,
			//obj_naruto_sagemode,
			//obj_naruto_kuramachakra,
			//obj_naruto_tailedbeast,
			//obj_naruto_sixpaths
		];
		break;
		
		default:
		return [object_index];
		break;
	}
}