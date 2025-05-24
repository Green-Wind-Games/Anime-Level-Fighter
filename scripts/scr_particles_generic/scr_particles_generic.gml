globalvar	explosion_light_particle, explosion_medium_particle, explosion_heavy_particle,
			shockwave_light_particle, shockwave_medium_particle, shockwave_heavy_particle;

explosion_light_particle = part_type_create();
part_type_sprite(explosion_light_particle,spr_explosion,true,true,false);
part_type_life(explosion_light_particle,30,60);
part_type_size(explosion_light_particle,1/10,1/10,1/60,0);
part_type_orientation(explosion_light_particle,0,360,0,0,false);
part_type_blend(explosion_light_particle,true);
	
explosion_medium_particle = part_type_create();
part_type_sprite(explosion_medium_particle,spr_explosion,true,true,false);
part_type_life(explosion_medium_particle,30,60);
part_type_size(explosion_medium_particle,1/2,1/2,1/60,0);
part_type_orientation(explosion_medium_particle,0,360,0,0,false);
part_type_blend(explosion_medium_particle,true);
	
explosion_heavy_particle = part_type_create();
part_type_sprite(explosion_heavy_particle,spr_explosion,true,true,false);
part_type_life(explosion_heavy_particle,30,60);
part_type_size(explosion_heavy_particle,1,1,1/60,0);
part_type_orientation(explosion_heavy_particle,0,360,0,0,false);
part_type_blend(explosion_heavy_particle,true);

shockwave_light_particle = part_type_create();
part_type_shape(shockwave_light_particle,pt_shape_ring);
part_type_life(shockwave_light_particle,60,60);
part_type_size(shockwave_light_particle,0.1,0.1,1/30,0);
part_type_orientation(shockwave_light_particle,0,360,0,0,true);
part_type_blend(shockwave_light_particle,true);
part_type_alpha3(shockwave_light_particle,1,1,0);

shockwave_medium_particle = part_type_create();
part_type_shape(shockwave_medium_particle,pt_shape_ring);
part_type_life(shockwave_medium_particle,60,60);
part_type_size(shockwave_medium_particle,0.1,0.1,1/20,0);
part_type_orientation(shockwave_medium_particle,0,360,0,0,true);
part_type_blend(shockwave_medium_particle,true);
part_type_alpha3(shockwave_medium_particle,1,1,0);

shockwave_heavy_particle = part_type_create();
part_type_shape(shockwave_heavy_particle,pt_shape_ring);
part_type_life(shockwave_heavy_particle,60,60);
part_type_size(shockwave_heavy_particle,0.1,0.1,1/10,0);
part_type_orientation(shockwave_heavy_particle,0,360,0,0,true);
part_type_blend(shockwave_heavy_particle,true);
part_type_alpha3(shockwave_heavy_particle,1,1,0);