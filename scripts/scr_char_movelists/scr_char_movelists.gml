function setup_basicmoves() {
	add_ground_move(dash_state,"66");
	add_ground_move(backdash_state,"44");
	add_air_move(airdash_state,"66");
	add_air_move(air_backdash_state,"44");
	
	add_air_move(airdash_state,"956");
	add_air_move(air_backdash_state,"754");
	
	//add_move(teleport_state,"F");
	
	add_ground_move(light_attack,"A");
	add_ground_move(light_attack2,"A");
	
	//add_ground_move(light_lowattack,"2A");
	
	add_ground_move(medium_lowattack,"2B");
	
	add_ground_move(medium_attack,"B");
	add_ground_move(medium_attack2,"B");
	add_ground_move(medium_attack3,"B");
	
	add_ground_move(heavy_attack,"C");
	add_ground_move(heavy_lowattack,"2C");
	
	add_ground_move(light_attack3,"A");
	
	add_ground_move(medium_attack4,"B");
	
	add_air_move(light_airattack,"A");
	add_air_move(light_airattack2,"A");
	add_air_move(light_airattack3,"A");
	
	add_air_move(medium_airattack,"B");
	
	add_air_move(light_airattack_repeat,"A");
	add_air_move(light_airattack_repeat2,"A");
	
	add_air_move(heavy_airattack,"C");
	add_air_move(heavy_air_launcher,"8C");
}

function init_goku_baseform_movelist() {
	setup_basicmoves();
	
	add_move(kiblast,"D");
	
	add_ground_move(kiai_push,"236A");
	add_ground_move(kiai_push,"236B");
	add_ground_move(kiai_push,"236C");
	
	add_move(kamehameha,"236D");
	add_move(super_kamehameha,"214D");
	
	add_ground_move(activate_kaioken,"252C");
	
	add_move(super_spirit_bomb,"258C");
	
	signature_move = super_kamehameha;
	finisher_move = super_spirit_bomb;
}