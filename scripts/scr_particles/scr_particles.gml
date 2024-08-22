// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
globalvar	particle_system,
			hitspark_light, hitspark_medium, hitspark_heavy,
			guardspark,
			slashspark,
			explosion_small, explosion_medium, explosion_large;
				
particle_system = part_system_create();
part_system_depth(particle_system,-9999);
part_system_automatic_update(particle_system,false);
part_system_automatic_draw(particle_system,false);
	
guardspark = part_type_create();
part_type_sprite(guardspark,spr_guardspark,true,true,false);
part_type_life(guardspark,25,25);
part_type_size(guardspark,0.5,0.5,0,0);
part_type_blend(guardspark,true);
	
var _spark_scale = 30 / sprite_get_width(spr_hitspark);
var _spark_increase = (_spark_scale) / 15;
	
hitspark_light = part_type_create();
part_type_sprite(hitspark_light,spr_hitspark,true,true,false);
part_type_life(hitspark_light,15,15);
part_type_size(hitspark_light,_spark_scale,_spark_scale,_spark_increase,0);
part_type_orientation(hitspark_light,0,360,0,0,true);
part_type_blend(hitspark_light,true);
part_type_color1(hitspark_light,c_white);
	
hitspark_medium = part_type_create();
part_type_sprite(hitspark_medium,spr_hitspark,true,true,false);
part_type_life(hitspark_medium,18,18);
part_type_size(hitspark_medium,_spark_scale,_spark_scale,_spark_increase,0);
part_type_orientation(hitspark_medium,0,360,0,0,true);
part_type_blend(hitspark_medium,true);
part_type_color1(hitspark_medium,make_color_rgb(255,255,0));
	
hitspark_heavy = part_type_create();
part_type_sprite(hitspark_heavy,spr_hitspark,true,true,false);
part_type_life(hitspark_heavy,20,20);
part_type_size(hitspark_heavy,_spark_scale,_spark_scale,_spark_increase,0);
part_type_orientation(hitspark_heavy,0,360,0,0,true);
part_type_blend(hitspark_heavy,true);
part_type_color1(hitspark_heavy,make_color_rgb(255,128,0));
	
slashspark = part_type_create();
part_type_sprite(slashspark,spr_slashspark,true,true,false);
part_type_life(slashspark,15,15);
part_type_size(slashspark,0.5,0.5,0,0);
part_type_orientation(slashspark,0,360,0,0,true);
part_type_blend(slashspark,true);
	
explosion_small = part_type_create();
part_type_sprite(explosion_small,spr_explosion,true,true,false);
part_type_life(explosion_small,20,20);
part_type_size(explosion_small,0.2,0.2,0,0);
part_type_orientation(explosion_small,0,360,0,0,true);
part_type_blend(explosion_small,true);
	
explosion_medium = part_type_create();
part_type_sprite(explosion_medium,spr_explosion,true,true,false);
part_type_life(explosion_medium,20,20);
part_type_size(explosion_medium,0.5,0.5,0,0);
part_type_orientation(explosion_medium,0,360,0,0,true);
part_type_blend(explosion_medium,true);
	
explosion_large = part_type_create();
part_type_sprite(explosion_large,spr_explosion,true,true,false);
part_type_life(explosion_large,20,20);
part_type_size(explosion_large,1,1,0,0);
part_type_orientation(explosion_large,0,360,0,0,true);
part_type_blend(explosion_large,true);
	
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
		case explosion_small:
		play_sound(snd_explosion,0.3,2);
		break;
		
		case explosion_medium:
		play_sound(snd_explosion,0.5,1.5);
		break;
		
		case explosion_large:
		play_sound(snd_explosion);
		break;
	}
}

function create_hitspark(_x1,_y1,_x2,_y2,_strength,_hiteffect,_guard) {
	var _sound = noone;
	switch(_hiteffect) {
		default:
		if !_guard {
			switch(_hiteffect) {
				default:
				if _strength < attackstrength.medium {
					_sound = choose(snd_punch_hit_light,snd_punch_hit_light2);
					create_particles(_x1,_y1,_x2,_y2,hitspark_light);
				}
				else if _strength < attackstrength.heavy {
					_sound = choose(snd_punch_hit_medium,snd_punch_hit_medium2);
					create_particles(_x1,_y1,_x2,_y2,hitspark_medium);
				}
				else {
					_sound = choose(snd_punch_hit_heavy,snd_punch_hit_heavy2);
					create_particles(_x1,_y1,_x2,_y2,hitspark_heavy);
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
				else {
					_sound = choose(snd_slash_hit_heavy,snd_slash_hit_heavy2);
				}
				break;
				
			}
		}
		else {
			switch(_hiteffect) {
				default: 
				_sound = snd_punch_block;
				create_particles(_x1,_y1,_x2,_y2,guardspark);
				break;
			}
		}
		break;
	}
	play_sound(_sound);
}