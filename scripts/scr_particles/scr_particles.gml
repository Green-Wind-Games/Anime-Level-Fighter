// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
globalvar	particle_system,
			hitspark_light, hitspark_medium, hitspark_heavy,
			hitspark_super,
			slashspark,
			guardspark,
			deflect_spark,
			explosion_small, explosion_medium, explosion_large,
			left_wall_bang_particle, floor_bang_particle, right_wall_bang_particle,
			shockwave_particle,
			jutsu_smoke_particle;
				
particle_system = part_system_create();
part_system_depth(particle_system,-9999);
part_system_automatic_update(particle_system,false);
part_system_automatic_draw(particle_system,false);
	
hitspark_light = part_type_create();
part_type_sprite(hitspark_light,spr_hitspark,true,true,false);
part_type_life(hitspark_light,12,12);
part_type_size(hitspark_light,1/5,1/5,1/60,0);
part_type_orientation(hitspark_light,0,360,0,0,true);
part_type_blend(hitspark_light,true);
part_type_color1(hitspark_light,c_white);
	
hitspark_medium = part_type_create();
part_type_sprite(hitspark_medium,spr_hitspark,true,true,false);
part_type_life(hitspark_medium,16,16);
part_type_size(hitspark_medium,1/5,1/5,1/50,0);
part_type_orientation(hitspark_medium,0,360,0,0,true);
part_type_blend(hitspark_medium,true);
part_type_color1(hitspark_medium,make_color_rgb(255,255,0));
	
hitspark_heavy = part_type_create();
part_type_sprite(hitspark_heavy,spr_hitspark,true,true,false);
part_type_life(hitspark_heavy,20,20);
part_type_size(hitspark_heavy,1/5,1/5,1/40,0);
part_type_orientation(hitspark_heavy,0,360,0,0,true);
part_type_blend(hitspark_heavy,true);
part_type_color1(hitspark_heavy,make_color_rgb(255,128,0));
	
hitspark_super = part_type_create();
part_type_sprite(hitspark_super,spr_hitspark,true,true,false);
part_type_life(hitspark_super,24,24);
part_type_size(hitspark_super,1/5,1/5,1/30,0);
part_type_orientation(hitspark_super,0,360,0,0,true);
part_type_blend(hitspark_super,true);
part_type_color1(hitspark_super,make_color_rgb(255,64,0));
	
slashspark = part_type_create();
part_type_sprite(slashspark,spr_slashspark,true,true,false);
part_type_life(slashspark,15,15);
part_type_size(slashspark,0.5,0.5,0,0);
part_type_orientation(slashspark,0,360,0,0,true);
part_type_blend(slashspark,true);
	
guardspark = part_type_create();
part_type_sprite(guardspark,spr_guardspark,true,true,false);
part_type_life(guardspark,25,25);
part_type_size(guardspark,0.5,0.5,0,0);
part_type_blend(guardspark,true);
	
deflect_spark = part_type_create();
part_type_sprite(deflect_spark,spr_hitspark,true,true,false);
part_type_life(deflect_spark,20,20);
part_type_size(deflect_spark,1/5,1/5,1/40,0);
part_type_orientation(deflect_spark,0,360,0,0,true);
part_type_blend(deflect_spark,true);
part_type_color1(deflect_spark,make_color_rgb(128,255,128));
	
explosion_small = part_type_create();
part_type_sprite(explosion_small,spr_explosion,true,true,false);
part_type_life(explosion_small,12,12);
part_type_size(explosion_small,0.25,0.25,1/50,0);
part_type_orientation(explosion_small,0,360,0,0,true);
part_type_blend(explosion_small,true);
	
explosion_medium = part_type_create();
part_type_sprite(explosion_medium,spr_explosion,true,true,false);
part_type_life(explosion_medium,16,16);
part_type_size(explosion_medium,1,1,1/50,0);
part_type_orientation(explosion_medium,0,360,0,0,true);
part_type_blend(explosion_medium,true);
	
explosion_large = part_type_create();
part_type_sprite(explosion_large,spr_explosion,true,true,false);
part_type_life(explosion_large,20,20);
part_type_size(explosion_large,2,2,1/50,0);
part_type_orientation(explosion_large,0,360,0,0,true);
part_type_blend(explosion_large,true);

left_wall_bang_particle = part_type_create();
part_type_sprite(left_wall_bang_particle,spr_impact_dust,true,true,false);
part_type_life(left_wall_bang_particle,20,20);
part_type_size(left_wall_bang_particle,0.25,0.25,1/30,0);
part_type_orientation(left_wall_bang_particle,-90,-90,0,0,false);
part_type_blend(left_wall_bang_particle,true);
part_type_alpha3(left_wall_bang_particle,1,1,0);

floor_bang_particle = part_type_create();
part_type_sprite(floor_bang_particle,spr_impact_dust,true,true,false);
part_type_life(floor_bang_particle,20,20);
part_type_size(floor_bang_particle,0.25,0.25,1/30,0);
part_type_orientation(floor_bang_particle,0,0,0,0,false);
part_type_blend(floor_bang_particle,true);
part_type_alpha3(floor_bang_particle,1,1,0);

right_wall_bang_particle = part_type_create();
part_type_sprite(right_wall_bang_particle,spr_impact_dust,true,true,false);
part_type_life(right_wall_bang_particle,20,20);
part_type_size(right_wall_bang_particle,0.25,0.25,1/30,0);
part_type_orientation(right_wall_bang_particle,90,90,0,0,false);
part_type_blend(right_wall_bang_particle,true);
part_type_alpha3(right_wall_bang_particle,1,1,0);

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
		case deflect_spark:
		play_sound(snd_parry_sf3);
		break;
		
		case explosion_small:
		play_sound(snd_explosion_small);
		break;
		
		case explosion_medium:
		play_sound(snd_explosion_medium);
		shake_screen(10,5);
		break;
		
		case explosion_large:
		play_sound(snd_explosion_large);
		shake_screen(20,10);
		break;
		
		case shockwave_particle:
		play_sound(snd_shockwave);
		shake_screen(10,10);
		break;
		
		case floor_bang_particle:
		case left_wall_bang_particle:
		case right_wall_bang_particle:
		play_sound(snd_wall_hit_heavy);
		shake_screen(10,10);
		break;
		
		case jutsu_smoke_particle:
		play_sound(choose(snd_jutsu_smoke,snd_jutsu_smoke2));
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
					_sound = choose(snd_punch_hit_light,snd_punch_hit_light2);
					create_particles(_x1,_y1,_x2,_y2,hitspark_light);
				}
				else if _strength < attackstrength.heavy {
					_sound = choose(snd_punch_hit_medium,snd_punch_hit_medium2);
					create_particles(_x1,_y1,_x2,_y2,hitspark_medium);
				}
				else if _strength < attackstrength.super {
					_sound = choose(snd_punch_hit_heavy,snd_punch_hit_heavy2);
					create_particles(_x1,_y1,_x2,_y2,hitspark_heavy);
				}
				else {
					_sound = choose(snd_punch_hit_super);
					create_particles(_x1,_y1,_x2,_y2,hitspark_super);
				}
				break;
				
				case hiteffects.slash:
				create_particles(_x1,_y1,_x2,_y2,slashspark);
				if _strength < attackstrength.medium {
					_sound = choose(snd_slash_hit_light,snd_slash_hit_light2);
				}
				else if _strength < attackstrength.heavy {
					_sound = choose(snd_slash_hit_medium);
				}
				else if _strength < attackstrength.super {
					_sound = choose(snd_slash_hit_heavy,snd_slash_hit_heavy2);
				}
				else if _strength < attackstrength.super {
					_sound = choose(snd_slash_hit_super);
				}
				break;
			}
			
			if _strength >= attackstrength.heavy {
				if meme_enabled {
					if random(100) < meme_chance {
						_sound = choose(snd_meme_hit_fryingpan);
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