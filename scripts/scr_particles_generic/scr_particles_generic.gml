globalvar	explosion_small_particle, explosion_medium_particle, explosion_large_particle,
			air_shockwave_particle;

explosion_small_particle = part_type_create();
part_type_shape(explosion_small_particle,pt_shape_explosion);
part_type_life(explosion_small_particle,30,60);
part_type_size(explosion_small_particle,1/10,1/5,0,0);
part_type_orientation(explosion_small_particle,0,360,0,0,false);
part_type_direction(explosion_small_particle,0,360,0,0);
part_type_speed(explosion_small_particle,1,8,0,0);
part_type_gravity(explosion_small_particle,-0.1,90);
part_type_blend(explosion_small_particle,true);
part_type_color3(explosion_small_particle,c_yellow,c_red,c_dkgray);
	
explosion_medium_particle = part_type_create();
part_type_shape(explosion_medium_particle,pt_shape_explosion);
part_type_life(explosion_medium_particle,30,60);
part_type_size(explosion_medium_particle,1/10,1/5,0,0);
part_type_orientation(explosion_medium_particle,0,360,0,0,false);
part_type_direction(explosion_medium_particle,0,360,0,0);
part_type_speed(explosion_medium_particle,1,8,0,0);
part_type_gravity(explosion_medium_particle,-0.1,90);
part_type_blend(explosion_medium_particle,true);
part_type_color3(explosion_medium_particle,c_yellow,c_red,c_dkgray);
	
explosion_large_particle = part_type_create();
part_type_shape(explosion_large_particle,pt_shape_explosion);
part_type_life(explosion_large_particle,30,60);
part_type_size(explosion_large_particle,1/10,1/5,0,0);
part_type_orientation(explosion_large_particle,0,360,0,0,false);
part_type_direction(explosion_large_particle,0,360,0,0);
part_type_speed(explosion_large_particle,1,8,0,0);
part_type_gravity(explosion_large_particle,-0.1,90);
part_type_blend(explosion_large_particle,true);
part_type_color3(explosion_large_particle,c_yellow,c_red,c_dkgray);