//globalvar	flame_particle;

//flame_particle = part_type_create();
//part_type_shape(flame_particle,pt_shape_explosion);
//part_type_life(flame_particle,50,60);
//part_type_size(flame_particle,0.2,0.2,1/30,0);
//part_type_orientation(flame_particle,0,360,0,0,true);
//part_type_direction(flame_particle,0,360,0,0);
//part_type_color3(flame_particle,make_color_rgb(255,128,0),make_color_rgb(255,0,0),c_black);
//part_type_alpha2(flame_particle,1,0);
//part_type_blend(flame_particle,false);
			
//function shoot_flame_particles(_x1,_y1,_x2,_y2,_number = 1) {
//	repeat(_number) {
//		var _dir = point_direction(_x1,_y1,_x2,_y2);
//		var _dist = point_distance(_x1,_y1,_x2,_y2);
//		var _time = 30;
//		var _grav = 0.5;
//		var _decel = random(_grav);
//		var _speed = sqrt(2 * _decel * _dist) * 1.25;
//		part_type_gravity(
//			flame_particle,
//			_grav,
//			90
//		);
//		part_type_speed(
//			flame_particle,
//			_speed/2,
//			_speed,
//			-_decel,
//			0
//		);
//		part_type_direction(
//			flame_particle,
//			_dir,
//			_dir,
//			0,
//			0
//		);
//		create_particles(_x1,_y1,flame_particle);
//	}
//}