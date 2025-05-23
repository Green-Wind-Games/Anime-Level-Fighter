function setup_basicmoves() {
	//add_ground_move(light_attack,"A");
	
	add_ground_move(medium_lowattack,"2B");
	
	add_ground_move(medium_attack,"B");
	add_ground_move(medium_attack2,"B");
	add_ground_move(medium_attack3,"B");
	
	add_ground_move(heavy_attack,"C");
	add_ground_move(heavy_lowattack,"2C");
	
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
	
	add_ground_move(kiai_push,"236A");
	add_ground_move(kiai_push,"236B");
	add_ground_move(kiai_push,"236C");
	
	add_move(kiblast,"D");
	
	add_move(kamehameha,"236D");
	
	add_ground_move(activate_kaioken,"214AB");
	add_move(super_kamehameha,"236AB");
	
	add_move(super_spirit_bomb,"236CD");
	
	signature_move = super_kamehameha;
	finisher_move = super_spirit_bomb;
}

function init_goku_ssj_movelist() {
	setup_basicmoves();
	
	add_ground_move(ki_blast_cannon,"236A");
	add_ground_move(ki_blast_cannon,"236B");
	add_ground_move(ki_blast_cannon,"236C");
	
	add_move(kiblast,"D");
	
	add_move(kamehameha,"236D");
	
	add_ground_move(activate_ssj2,"214AB");
	add_move(super_kamehameha,"236AB");
	
	add_move(angry_kamehameha,"236CD");
	
	signature_move = super_kamehameha;
	finisher_move = angry_kamehameha;
}

function init_naruto_baseform_movelist() {
	setup_basicmoves();
	
	add_air_move(divekick,"2B");

	add_move(shuriken_throw,"D");
	add_move(triple_shuriken_throw,"2D");
	
	add_ground_move(mini_rasengan,"236A");
	add_ground_move(double_rasengan,"236B");
	add_ground_move(giant_rasengan,"236C");
	
	add_air_move(rasengan_dive,"236A");
	add_air_move(rasengan_dive,"236B");
	add_air_move(rasengan_dive,"236C");
	
	add_ground_move(uzumaki_barrage_start,"214A");
	add_ground_move(uzumaki_barrage_start,"214B");
	add_ground_move(uzumaki_barrage_start,"214C");
	
	add_move(shadow_clone_barrage,"236AB");
	add_ground_move(shadow_clone_jutsu,"214AB");
	
	add_ground_move(rasen_shuriken,"236CD");
	
	signature_move = double_rasengan;
	finisher_move = rasen_shuriken;
}

function init_genos_baseform_movelist() {
	setup_basicmoves();
	
	add_move(fireblast,"D");
	
	add_ground_move(machinegun_blows,"236A");
	add_ground_move(machinegun_blows,"236B");
	add_ground_move(machinegun_blows,"236C");
	
	add_move(dropkick,"214A");
	add_move(dropkick,"214B");
	add_move(dropkick,"214C");
	
	add_move(incinerate,"236D");
	
	add_move(super_incinerate,"236AB");
	
	signature_move = super_incinerate;
	finisher_move = super_incinerate;
}