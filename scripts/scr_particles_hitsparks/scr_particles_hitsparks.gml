globalvar	hitspark_light, hitspark_medium, hitspark_heavy,
			slashspark_light, slashspark_medium, slashspark_heavy,
			piercespark_light, piercespark_medium, piercespark_heavy, 
			guardspark, parry_spark;

hitspark_light = part_type_create();
part_type_shape(hitspark_light,pt_shape_line);
part_type_life(hitspark_light,10,15);
part_type_size(hitspark_light,0.1,0.2,-1/20,0);
part_type_orientation(hitspark_light,0,0,0,0,true);
part_type_direction(hitspark_light,0,360,0,0);
part_type_speed(hitspark_light,2,10,0,0);
part_type_color2(hitspark_light,c_white,make_color_rgb(0,192,255));
part_type_alpha3(hitspark_light,1,1,0);
part_type_blend(hitspark_light,true);

hitspark_medium = part_type_create();
part_type_shape(hitspark_medium,pt_shape_line);
part_type_life(hitspark_medium,15,20);
part_type_size(hitspark_medium,0.2,0.3,-1/20,0);
part_type_orientation(hitspark_medium,0,0,0,0,true);
part_type_direction(hitspark_medium,0,360,0,0);
part_type_speed(hitspark_medium,2,10,0,0);
part_type_color2(hitspark_medium,c_white,make_color_rgb(255,255,0));
part_type_alpha3(hitspark_medium,1,1,0);
part_type_blend(hitspark_medium,true);

hitspark_heavy = part_type_create();
part_type_shape(hitspark_heavy,pt_shape_line);
part_type_life(hitspark_heavy,20,25);
part_type_size(hitspark_heavy,0.3,0.4,-1/20,0);
part_type_orientation(hitspark_heavy,0,0,0,0,true);
part_type_direction(hitspark_heavy,0,360,0,0);
part_type_speed(hitspark_heavy,2,10,0,0);
part_type_color2(hitspark_heavy,c_white,make_color_rgb(255,128,0));
part_type_alpha3(hitspark_heavy,1,1,0);
part_type_blend(hitspark_heavy,true);

slashspark_light = part_type_create();
part_type_sprite(slashspark_light,spr_slashspark,true,true,false);
part_type_life(slashspark_light,10,15);
part_type_size(slashspark_light,0.3,0.3,-1/20,0);
part_type_orientation(slashspark_light,0,0,0,0,true);
part_type_direction(slashspark_light,0,360,0,0);
part_type_speed(slashspark_light,5,5,0,0);
part_type_color2(slashspark_light,c_white,make_color_rgb(0,192,255));
part_type_alpha3(slashspark_light,1,1,0);
part_type_blend(slashspark_light,true);

piercespark_light = part_type_create();
part_type_shape(piercespark_light,pt_shape_line);
part_type_life(piercespark_light,10,15);
part_type_size(piercespark_light,0.1,0.2,-1/20,0);
part_type_orientation(piercespark_light,0,0,0,0,true);
part_type_direction(piercespark_light,0,360,0,0);
part_type_speed(piercespark_light,2,10,0,0);
part_type_color2(piercespark_light,c_white,make_color_rgb(0,192,255));
part_type_alpha3(piercespark_light,1,1,0);
part_type_blend(piercespark_light,true);

piercespark_medium = part_type_create();
part_type_shape(piercespark_medium,pt_shape_line);
part_type_life(piercespark_medium,15,20);
part_type_size(piercespark_medium,0.2,0.3,-1/20,0);
part_type_orientation(piercespark_medium,0,0,0,0,true);
part_type_direction(piercespark_medium,0,360,0,0);
part_type_speed(piercespark_medium,2,10,0,0);
part_type_color2(piercespark_medium,c_white,make_color_rgb(255,255,0));
part_type_alpha3(piercespark_medium,1,1,0);
part_type_blend(piercespark_medium,true);

piercespark_heavy = part_type_create();
part_type_shape(piercespark_heavy,pt_shape_line);
part_type_life(piercespark_heavy,20,25);
part_type_size(piercespark_heavy,0.3,0.4,-1/20,0);
part_type_orientation(piercespark_heavy,0,0,0,0,true);
part_type_direction(piercespark_heavy,0,360,0,0);
part_type_speed(piercespark_heavy,2,10,0,0);
part_type_color2(piercespark_heavy,c_white,make_color_rgb(255,128,0));
part_type_alpha3(piercespark_heavy,1,1,0);
part_type_blend(piercespark_heavy,true);
	
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
part_type_size(parry_spark,1/10,1/10,1/5,0);
part_type_orientation(parry_spark,0,360,0,0,true);
part_type_color1(parry_spark,make_color_rgb(0,255,128));
part_type_blend(parry_spark,true);

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
					create_particles(_x1,_y1,_x2,_y2,hitspark,20);
				}
				else if _strength < attackstrength.heavy {
					_sound = snd_punch_hit_medium;
					create_particles(_x1,_y1,_x2,_y2,hitspark,40);
				}
				else if _strength < attackstrength.super {
					_sound = snd_punch_hit_heavy;
					create_particles(_x1,_y1,_x2,_y2,hitspark,60);
				}
				else if _strength < attackstrength.ultimate {
					_sound = snd_punch_hit_super;
					create_particles(_x1,_y1,_x2,_y2,hitspark,80);
				}
				else {
					_sound = snd_punch_hit_ultimate;
					create_particles(_x1,_y1,_x2,_y2,hitspark,100);
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
					if chance(meme_chance) {
						_sound = choose(
							snd_meme_hit_dunk,
							snd_meme_hit_hammer,
							snd_meme_hit_metal_dayum,
							snd_meme_hit_tacobell,
							snd_meme_hit_tf2_critical,
							snd_meme_hit_tf2_fryingpan
						);
						_volume = 2;
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