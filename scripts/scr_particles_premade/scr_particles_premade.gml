function create_particle_premade(_x,_y,_particle) {
	switch(_particle) {
		default:
		print("premade particle doesn't exist");
		break;
		
		case hitspark_light:
		create_particles(_x,_y,hitspark_light,30);
		break;
		case hitspark_medium:
		create_particles(_x,_y,hitspark_medium,40);
		break;
		case hitspark_heavy:
		create_particles(_x,_y,hitspark_heavy,50);
		break;
		
		case explosion_light_particle:
		
		break;
	}
}