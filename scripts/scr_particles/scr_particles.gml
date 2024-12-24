globalvar	particle_system;
				
particle_system = part_system_create();
part_system_depth(particle_system,-99999);
part_system_automatic_update(particle_system,false);
part_system_automatic_draw(particle_system,false);
	
globalvar	hitspark, slashspark, piercespark,
			guardspark, parry_spark,
			special_activate_particle, super_activate_particle, ultimate_activate_particle,
			explosion_small_particle, explosion_medium_particle, explosion_large_particle,
			wall_bang_left_particle, wall_bang_right_particle, floor_bang_particle,
			air_shockwave_particle;
			
hitspark = part_type_create();
part_type_shape(hitspark,pt_shape_line);
part_type_life(hitspark,8,16);
part_type_size(hitspark,1/4,1/2,-1/20,0);
part_type_orientation(hitspark,0,0,0,0,true);
part_type_direction(hitspark,0,360,0,0);
part_type_speed(hitspark,4,8,0,0);
part_type_blend(hitspark,true);
	
slashspark = part_type_create();
part_type_shape(slashspark,pt_shape_line);
part_type_life(slashspark,16,16);
part_type_size(slashspark,1,1,-1/20,0);
part_type_orientation(slashspark,0,0,0,0,true);
part_type_direction(slashspark,0,360,0,0);
part_type_speed(slashspark,5,5,-1/3,0);
part_type_blend(slashspark,true);

piercespark = hitspark;
	
guardspark = part_type_create();
part_type_shape(guardspark,pt_shape_flare);
part_type_life(guardspark,16,16);
part_type_size(guardspark,1,1,-1/20,0);
part_type_orientation(guardspark,0,0,0,0,true);
part_type_direction(guardspark,0,360,0,0);
part_type_speed(guardspark,5,5,-1/3,0);
part_type_blend(guardspark,true);
	
parry_spark = part_type_create();
part_type_shape(parry_spark,pt_shape_ring);
part_type_life(parry_spark,30,30);
part_type_size(parry_spark,1/10,1/10,1/10,0);
part_type_orientation(parry_spark,0,360,0,0,true);
part_type_blend(parry_spark,true);
part_type_color1(parry_spark,make_color_rgb(0,255,128));
	
explosion_small_particle = part_type_create();
part_type_shape(explosion_small_particle,pt_shape_explosion);
part_type_life(explosion_small_particle,30,60);
part_type_size(explosion_small_particle,1/10,1/5,0,0);
part_type_orientation(explosion_small_particle,0,360,0,0,false);
part_type_direction(explosion_small_particle,0,360,0,0);
part_type_speed(explosion_small_particle,1,8,0,0);
part_type_gravity(explosion_small_particle,ygravity/10,90);
part_type_blend(explosion_small_particle,true);
part_type_color3(explosion_small_particle,c_yellow,c_red,c_dkgray);
	
explosion_medium_particle = part_type_create();
part_type_shape(explosion_medium_particle,pt_shape_explosion);
part_type_life(explosion_medium_particle,30,60);
part_type_size(explosion_medium_particle,1/10,1/5,0,0);
part_type_orientation(explosion_medium_particle,0,360,0,0,false);
part_type_direction(explosion_medium_particle,0,360,0,0);
part_type_speed(explosion_medium_particle,1,8,0,0);
part_type_gravity(explosion_medium_particle,ygravity/10,90);
part_type_blend(explosion_medium_particle,true);
part_type_color3(explosion_medium_particle,c_yellow,c_red,c_dkgray);
	
explosion_large_particle = part_type_create();
part_type_shape(explosion_large_particle,pt_shape_explosion);
part_type_life(explosion_large_particle,30,60);
part_type_size(explosion_large_particle,1/10,1/5,0,0);
part_type_orientation(explosion_large_particle,0,360,0,0,false);
part_type_direction(explosion_large_particle,0,360,0,0);
part_type_speed(explosion_large_particle,1,8,0,0);
part_type_gravity(explosion_large_particle,ygravity/10,90);
part_type_blend(explosion_large_particle,true);
part_type_color3(explosion_large_particle,c_yellow,c_red,c_dkgray);

wall_bang_left_particle = part_type_create();
part_type_sprite(wall_bang_left_particle,spr_impact_dust,true,true,false);
part_type_life(wall_bang_left_particle,20,20);
part_type_size(wall_bang_left_particle,0.25,0.25,1/30,0);
part_type_orientation(wall_bang_left_particle,-90,-90,0,0,false);
part_type_blend(wall_bang_left_particle,true);
part_type_alpha3(wall_bang_left_particle,1,1,0);

floor_bang_particle = part_type_create();
part_type_sprite(floor_bang_particle,spr_impact_dust,true,true,false);
part_type_life(floor_bang_particle,20,20);
part_type_size(floor_bang_particle,0.25,0.25,1/30,0);
part_type_orientation(floor_bang_particle,0,0,0,0,false);
part_type_blend(floor_bang_particle,true);
part_type_alpha3(floor_bang_particle,1,1,0);

wall_bang_right_particle = part_type_create();
part_type_sprite(wall_bang_right_particle,spr_impact_dust,true,true,false);
part_type_life(wall_bang_right_particle,20,20);
part_type_size(wall_bang_right_particle,0.25,0.25,1/30,0);
part_type_orientation(wall_bang_right_particle,90,90,0,0,false);
part_type_blend(wall_bang_right_particle,true);
part_type_alpha3(wall_bang_right_particle,1,1,0);

shockwave_particle = part_type_create();
part_type_sprite(shockwave_particle,spr_shockwave,true,true,false);
part_type_life(shockwave_particle,50,50);
part_type_size(shockwave_particle,0.1,0.1,1/5,0);
part_type_orientation(shockwave_particle,0,360,0,0,true);
part_type_blend(shockwave_particle,true);
part_type_alpha3(shockwave_particle,1,1,0);

shockwave_particle = part_type_create();
part_type_sprite(shockwave_particle,spr_shockwave,true,true,false);
part_type_life(shockwave_particle,50,50);
part_type_size(shockwave_particle,0.1,0.1,1/5,0);
part_type_orientation(shockwave_particle,0,360,0,0,true);
part_type_blend(shockwave_particle,true);
part_type_alpha3(shockwave_particle,1,1,0);

jutsu_smoke_particle = part_type_create();
part_type_sprite(jutsu_smoke_particle,spr_jutsu_smoke,true,true,false);
part_type_life(jutsu_smoke_particle,30,30);
part_type_size(jutsu_smoke_particle,0.6,0.6,0,0);
part_type_blend(jutsu_smoke_particle,true);
part_type_alpha3(jutsu_smoke_particle,1,1,0);

super_particle = part_type_create();
part_type_sprite(super_particle,spr_activate_super,true,true,false);
part_type_life(super_particle,30,30);
part_type_size(super_particle,0.5,0.5,0.5/60,0);
part_type_blend(super_particle,true);
part_type_alpha3(super_particle,1,1,0);

ultimate_particle = part_type_create();
part_type_sprite(ultimate_particle,spr_activate_ultimate,true,true,false);
part_type_life(ultimate_particle,30,30);
part_type_size(ultimate_particle,0.5,0.5,0.5/60,0);
part_type_blend(ultimate_particle,true);
part_type_alpha3(ultimate_particle,1,1,0);

function update_particles() {
	part_system_update(particle_system);
}

function create_particles(_x1,_y1,_x2,_y2,_particle,_number = 1) {
	repeat(_number) {
		part_particles_create(
			particle_system,
			irandom_range(_x1,_x2),
			irandom_range(_y1,_y2),
			_particle,
			1
		);
	}
	switch(_particle) {
		case parry_spark:
		play_sound(snd_parry);
		break;
		
		case explosion_small_particle:
		play_sound(snd_explosion_small);
		break;
		
		case explosion_medium_particle:
		play_sound(snd_explosion_medium);
		shake_screen(10,5);
		break;
		
		case explosion_large_particle:
		play_sound(snd_explosion_large);
		shake_screen(20,10);
		break;
		
		case air_shockwave_particle:
		play_sound(snd_shockwave);
		shake_screen(10,10);
		break;
		
		case floor_bang_particle:
		case wall_bang_left_particle:
		case wall_bang_right_particle:
		play_sound(snd_wall_hit_heavy);
		shake_screen(10,10);
		break;
		
		case jutsu_smoke_particle:
		play_sound(snd_jutsu_smoke);
		break;
	}
}

function create_hitspark(_target,_strength,_hiteffect,_guard) {
	var _sound = noone;
	var _volume = 1;
	var _p = 1/3;
	var _x1 = _target.x -						(_target.width_half * _p);
	var _y1 = _target.y - _target.height_half -	(_target.height_half * _p);
	var _x2 = _target.x +						(_target.width_half * _p);
	var _y2 = _target.y - _target.height_half +	(_target.height_half * _p);
	switch(_hiteffect) {
		default:
		if !_guard {
			switch(_hiteffect) {	
				case hiteffects.none:
				//none lol
				break;
				
				default:
				if _strength < attackstrength.medium {
					_sound = snd_punch_hit_light;
					create_particles(_x1,_y1,_x2,_y2,hitspark_light);
				}
				else if _strength < attackstrength.heavy {
					_sound = snd_punch_hit_medium;
					create_particles(_x1,_y1,_x2,_y2,hitspark_medium);
				}
				else if _strength < attackstrength.super {
					_sound = snd_punch_hit_heavy;
					create_particles(_x1,_y1,_x2,_y2,hitspark_heavy);
				}
				else if _strength < attackstrength.ultimate {
					_sound = snd_punch_hit_super;
					create_particles(_x1,_y1,_x2,_y2,hitspark_super);
				}
				else {
					_sound = snd_punch_hit_ultimate;
					create_particles(_x1,_y1,_x2,_y2,hitspark_ultimate);
				}
				break;
				
				case hiteffects.slash:
				create_particles(_x1,_y1,_x2,_y2,slashspark);
				if _strength < attackstrength.medium {
					_sound = snd_slash_hit_light;
				}
				else if _strength < attackstrength.heavy {
					_sound = snd_slash_hit_medium;
				}
				else if _strength < attackstrength.super {
					_sound = snd_slash_hit_heavy;
				}
				else if _strength < attackstrength.ultimate {
					_sound = snd_slash_hit_super;
				}
				else {
					_sound = snd_slash_hit_ultimate;
				}
				break;
			}
			
			if _strength >= attackstrength.super {
				if meme_enabled {
					if random(100) < meme_chance {
						_sound = choose(
							snd_meme_hit_dunk,
							snd_meme_hit_hammer,
							snd_meme_hit_metal_dayum,
							snd_meme_hit_tacobell,
							snd_meme_hit_tf2_critical,
							snd_meme_hit_tf2_fryingpan
						);
						_volume = 3;
					}
				}
			}
		}
		else {
			switch(_hiteffect) {
				default: 
				_sound = snd_punch_guard;
				create_particles(_x1,_y1,_x2,_y2,guardspark);
				break;
			}
		}
		break;
	}
	play_sound(_sound,_volume);
}

function create_specialeffect(_sprite,_x,_y,_xscale = 1,_yscale = 1,_rotation = 0,_rotationspeed = 0,_color = c_white,_alpha = 1,_blend = true) {
	var _effect = instance_create(_x,_y,obj_specialeffect);
	with(_effect) {
		init_sprite(_sprite);
		change_sprite(_sprite,60 / sprite_get_speed(_sprite),false);
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