globalvar	explosion_small_particle, explosion_medium_particle, explosion_large_particle,
			air_shockwave_particle;

explosion_small_particle = part_type_create();
part_type_sprite(explosion_small_particle,spr_explosion,true,true,false);
part_type_life(explosion_small_particle,30,60);
part_type_size(explosion_small_particle,1/10,1/10,1/60,0);
part_type_orientation(explosion_small_particle,0,360,0,0,false);
part_type_blend(explosion_small_particle,true);
	
explosion_medium_particle = part_type_create();
part_type_sprite(explosion_medium_particle,spr_explosion,true,true,false);
part_type_life(explosion_medium_particle,30,60);
part_type_size(explosion_medium_particle,1/2,1/2,1/60,0);
part_type_orientation(explosion_medium_particle,0,360,0,0,false);
part_type_blend(explosion_medium_particle,true);
	
explosion_large_particle = part_type_create();
part_type_sprite(explosion_large_particle,spr_explosion,true,true,false);
part_type_life(explosion_large_particle,30,60);
part_type_size(explosion_large_particle,1,1,1/60,0);
part_type_orientation(explosion_large_particle,0,360,0,0,false);
part_type_blend(explosion_large_particle,true);