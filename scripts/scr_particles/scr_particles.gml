globalvar	particle_system;
				
particle_system = part_system_create();
part_system_depth(particle_system,-99999);
part_system_automatic_update(particle_system,false);
part_system_automatic_draw(particle_system,false);
	
globalvar	special_activate_particle, super_activate_particle, ultimate_activate_particle,
			wall_bang_left_particle, wall_bang_right_particle, floor_bang_particle;

wall_bang_left_particle = part_type_create();
part_type_sprite(wall_bang_left_particle,spr_impact_dust,true,true,false);
part_type_life(wall_bang_left_particle,20,20);
part_type_size(wall_bang_left_particle,0.5,0.5,1/30,0);
part_type_orientation(wall_bang_left_particle,-90,-90,0,0,false);
part_type_blend(wall_bang_left_particle,true);
part_type_alpha3(wall_bang_left_particle,1,1,0);

floor_bang_particle = part_type_create();
part_type_sprite(floor_bang_particle,spr_impact_dust,true,true,false);
part_type_life(floor_bang_particle,20,20);
part_type_size(floor_bang_particle,0.5,0.5,1/30,0);
part_type_orientation(floor_bang_particle,0,0,0,0,false);
part_type_blend(floor_bang_particle,true);
part_type_alpha3(floor_bang_particle,1,1,0);

wall_bang_right_particle = part_type_create();
part_type_sprite(wall_bang_right_particle,spr_impact_dust,true,true,false);
part_type_life(wall_bang_right_particle,20,20);
part_type_size(wall_bang_right_particle,0.5,0.5,1/30,0);
part_type_orientation(wall_bang_right_particle,90,90,0,0,false);
part_type_blend(wall_bang_right_particle,true);
part_type_alpha3(wall_bang_right_particle,1,1,0);

super_activate_particle = part_type_create();
part_type_sprite(super_activate_particle,spr_activate_super,true,true,false);
part_type_life(super_activate_particle,30,30);
part_type_size(super_activate_particle,0.5,0.5,0.5/60,0);
part_type_blend(super_activate_particle,true);
part_type_alpha3(super_activate_particle,1,1,0);

ultimate_activate_particle = part_type_create();
part_type_sprite(ultimate_activate_particle,spr_activate_ultimate,true,true,false);
part_type_life(ultimate_activate_particle,30,30);
part_type_size(ultimate_activate_particle,0.5,0.5,0.5/60,0);
part_type_blend(ultimate_activate_particle,true);
part_type_alpha3(ultimate_activate_particle,1,1,0);

function update_particles() {
	part_system_update(particle_system);
}

function create_particles(_x,_y,_particle,_number = 1) {
	part_particles_create(
		particle_system,
		_x,
		_y,
		_particle,
		_number
	);
	switch(_particle) {
		case parry_spark:
		play_sound(snd_parry);
		break;
		
		case explosion_light_particle:
		play_sound(snd_explosion_light);
		shake_screen(10,1);
		break;
		
		case explosion_medium_particle:
		play_sound(snd_explosion_medium);
		shake_screen(20,2);
		break;
		
		case explosion_heavy_particle:
		play_sound(snd_explosion_heavy);
		shake_screen(30,3);
		break;
		
		case shockwave_light_particle:
		play_sound(snd_dbz_shockwave,1,1.25);
		break;
		
		case shockwave_medium_particle:
		play_sound(snd_dbz_shockwave);
		shake_screen(10,1);
		break;
		
		case shockwave_heavy_particle:
		play_sound(snd_dbz_shockwave,1,0.75);
		shake_screen(20,2);
		break;
		
		case floor_bang_particle:
		case wall_bang_left_particle:
		case wall_bang_right_particle:
		play_sound(snd_wall_hit_heavy);
		shake_screen(10,1);
		break;
		
		case jutsu_smoke_particle:
		play_sound(snd_naruto_jutsu_smoke);
		break;
	}
}

function create_specialeffect(_sprite,_x,_y,_xscale = 1,_yscale = 1,_rotation = 0,_rotationspeed = 0,_color = c_white,_alpha = 1,_blend = true) {
	var _effect = instance_create(_x,_y,obj_specialeffect);
	with(_effect) {
		init_sprite(_sprite);
		change_sprite(_sprite,false);
		xscale = _xscale;
		yscale = _yscale;
		rotation = _rotation;
		rotation_speed = _rotationspeed;
		color = _color;
		alpha = _alpha;
		blend = _blend;
	}
	return _effect;
}

function char_specialeffect(_sprite,_x = 0,_y = -height_half,_xscale = 1,_yscale = 1,_rotation = 0,_rotationspeed = 0,_color = c_white,_alpha = 1,_blend = true) {
	var _effect = create_specialeffect(
		_sprite,
		x,
		y,
		_xscale * facing,
		_yscale,
		_rotation,
		_rotationspeed,
		_color,
		_alpha,
		_blend
	);
	with(_effect) {
		owner = other;
		xoffset = _x * other.facing;
		yoffset = _y;
	}
	return _effect;
}