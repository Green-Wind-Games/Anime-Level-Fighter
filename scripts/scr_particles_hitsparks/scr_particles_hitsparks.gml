globalvar	hitspark_light, hitspark_medium, hitspark_heavy,
			slashspark_light, slashspark_medium, slashspark_heavy,
			piercespark_light, piercespark_medium, piercespark_heavy, 
			guardspark, parry_spark;

hitspark_light = part_type_create();
part_type_shape(hitspark_light,pt_shape_line);
part_type_life(hitspark_light,10,20);
part_type_size(hitspark_light,0.1,0.2,0,0);
part_type_orientation(hitspark_light,0,0,0,0,true);
part_type_direction(hitspark_light,0,360,0,0);
part_type_speed(hitspark_light,2,5,0,0);
part_type_color2(hitspark_light,c_white,make_color_rgb(0,192,255));
part_type_blend(hitspark_light,true);

hitspark_medium = part_type_create();
part_type_shape(hitspark_medium,pt_shape_line);
part_type_life(hitspark_medium,20,30);
part_type_size(hitspark_medium,0.1,0.2,0,0);
part_type_orientation(hitspark_medium,0,0,0,0,true);
part_type_direction(hitspark_medium,0,360,0,0);
part_type_speed(hitspark_medium,2,5,0,0);
part_type_color2(hitspark_medium,c_white,make_color_rgb(255,255,0));
part_type_blend(hitspark_medium,true);

hitspark_heavy = part_type_create();
part_type_shape(hitspark_heavy,pt_shape_line);
part_type_life(hitspark_heavy,30,40);
part_type_size(hitspark_heavy,0.1,0.2,0,0);
part_type_orientation(hitspark_heavy,0,0,0,0,true);
part_type_direction(hitspark_heavy,0,360,0,0);
part_type_speed(hitspark_heavy,2,5,0,0);
part_type_color2(hitspark_heavy,c_white,make_color_rgb(255,128,0));
part_type_blend(hitspark_heavy,true);

slashspark_light = part_type_create();
part_type_sprite(slashspark_light,spr_slashspark,true,true,false);
part_type_life(slashspark_light,10,20);
part_type_size(slashspark_light,0.2,0.3,0,0);
part_type_orientation(slashspark_light,45,45,0,0,true);
part_type_direction(slashspark_light,0,360,0,0);
part_type_speed(slashspark_light,5,5,0,0);
part_type_color2(slashspark_light,c_white,make_color_rgb(0,192,255));
part_type_blend(slashspark_light,true);

slashspark_medium = part_type_create();
part_type_sprite(slashspark_medium,spr_slashspark,true,true,false);
part_type_life(slashspark_medium,10,20);
part_type_size(slashspark_medium,0.2,0.3,0,0);
part_type_orientation(slashspark_medium,45,45,0,0,true);
part_type_direction(slashspark_medium,0,360,0,0);
part_type_speed(slashspark_medium,5,5,0,0);
part_type_color2(slashspark_medium,c_white,make_color_rgb(0,192,255));
part_type_blend(slashspark_medium,true);

slashspark_heavy = part_type_create();
part_type_sprite(slashspark_heavy,spr_slashspark,true,true,false);
part_type_life(slashspark_heavy,10,20);
part_type_size(slashspark_heavy,0.2,0.3,0,0);
part_type_orientation(slashspark_heavy,45,45,0,0,true);
part_type_direction(slashspark_heavy,0,360,0,0);
part_type_speed(slashspark_heavy,5,5,0,0);
part_type_color2(slashspark_heavy,c_white,make_color_rgb(0,192,255));
part_type_blend(slashspark_heavy,true);

piercespark_light = part_type_create();
part_type_shape(piercespark_light,pt_shape_line);
part_type_life(piercespark_light,10,20);
part_type_size(piercespark_light,0.1,0.2,0,0);
part_type_orientation(piercespark_light,0,0,0,0,true);
part_type_direction(piercespark_light,0,360,0,0);
part_type_speed(piercespark_light,2,5,0,0);
part_type_color2(piercespark_light,c_white,make_color_rgb(0,192,255));
part_type_blend(piercespark_light,true);

piercespark_medium = part_type_create();
part_type_shape(piercespark_medium,pt_shape_line);
part_type_life(piercespark_medium,20,30);
part_type_size(piercespark_medium,0.1,0.2,0,0);
part_type_orientation(piercespark_medium,0,0,0,0,true);
part_type_direction(piercespark_medium,0,360,0,0);
part_type_speed(piercespark_medium,2,5,0,0);
part_type_color2(piercespark_medium,c_white,make_color_rgb(255,255,0));
part_type_blend(piercespark_medium,true);

piercespark_heavy = part_type_create();
part_type_shape(piercespark_heavy,pt_shape_line);
part_type_life(piercespark_heavy,30,40);
part_type_size(piercespark_heavy,0.1,0.2,0,0);
part_type_orientation(piercespark_heavy,0,0,0,0,true);
part_type_direction(piercespark_heavy,0,360,0,0);
part_type_speed(piercespark_heavy,2,5,0,0);
part_type_color2(piercespark_heavy,c_white,make_color_rgb(255,128,0));
part_type_blend(piercespark_heavy,true);
	
guardspark = part_type_create();
part_type_shape(guardspark,pt_shape_ring);
part_type_life(guardspark,30,30);
part_type_size(guardspark,0.2,0.2,1/60,0);
part_type_scale(guardspark,0.5,1);
part_type_color2(guardspark,c_white,c_black);
part_type_blend(guardspark,true);
	
parry_spark = part_type_create();
part_type_shape(parry_spark,pt_shape_ring);
part_type_life(parry_spark,30,30);
part_type_size(parry_spark,0.2,0.2,1/30,0);
part_type_orientation(parry_spark,0,360,0,0,true);
part_type_color2(parry_spark,make_color_rgb(0,255,128),c_black);
part_type_blend(parry_spark,true);

function create_hitspark(_hitbox,_hurtbox) {
	var _strength = _hitbox.attack_strength;
	var _hiteffect = _hitbox.hit_effect;
	var _guard = _hurtbox.owner.is_guarding;
	
	var _sound = noone;
	var _volume = 1;
	
	var _x = 0;
	var _y = 0;
	
	with(_hitbox) {
		_x += bbox_left;
		_x += bbox_right;
		_y += bbox_top;
		_y += bbox_bottom;
	}
	with(_hurtbox) {
		_x += bbox_left;
		_x += bbox_right;
		_y += bbox_top;
		_y += bbox_bottom;
	}
	_x /= 4;
	_y /= 4;
	
	_x = clamp(_x,_hurtbox.bbox_left,_hurtbox.bbox_right);
	_y = clamp(_y,_hurtbox.bbox_top,_hurtbox.bbox_bottom);
	
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
					create_particles(_x,_y,hitspark_light,20);
				}
				else if _strength < attackstrength.heavy {
					_sound = snd_punch_hit_medium;
					create_particles(_x,_y,hitspark_medium,30);
				}
				else if _strength < attackstrength.super {
					_sound = snd_punch_hit_heavy;
					create_particles(_x,_y,hitspark_heavy,40);
				}
				else if _strength < attackstrength.ultimate {
					_sound = snd_punch_hit_super;
					create_particles(_x,_y,hitspark_heavy,50);
				}
				else {
					_sound = snd_punch_hit_ultimate;
					create_particles(_x,_y,hitspark_heavy,60);
				}
				break;
				
				case hiteffects.slash:
				if _strength < attackstrength.medium {
					_sound = snd_slash_hit_light;
					create_particles(_x,_y,slashspark_light);
				}
				else if _strength < attackstrength.heavy {
					_sound = snd_slash_hit_medium;
					create_particles(_x,_y,slashspark_medium);
				}
				else if _strength < attackstrength.super {
					_sound = snd_slash_hit_heavy;
					create_particles(_x,_y,slashspark_heavy);
				}
				else if _strength < attackstrength.ultimate {
					_sound = snd_slash_hit_super;
					create_particles(_x,_y,slashspark_heavy);
				}
				else {
					_sound = snd_slash_hit_ultimate;
					create_particles(_x,_y,slashspark_heavy);
				}
				break;
			}
			
			if _strength >= attackstrength.super {
				if meme_enabled and chance(meme_chance) {
					_sound = snd_meme_hit;
					_volume = 2;
				}
			}
		}
		else {
			switch(_hiteffect) {
				default: 
				_sound = snd_punch_guard;
				create_particles(_x,_y,guardspark);
				break;
			}
		}
		break;
	}
	play_sound(_sound,_volume);
}