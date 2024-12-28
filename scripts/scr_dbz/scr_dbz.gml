//globalvar	kiblast_blue_particle, kiblast_yellow_particle, kiblast_purple_particle, kiblast_green_particle,
//			kamehameha_particle, kamehameha_spread_particle;

//kiblast_blue_particle = part_type_create();
//part_type_blend(kiblast_blue_particle,true);
//part_type_color3(kiblast_blue_particle,c_white,make_color_rgb(0,192,255),c_black);
//part_type_life(kiblast_blue_particle,10,10);
//part_type_shape(kiblast_blue_particle,pt_shape_flare)
//part_type_size(kiblast_blue_particle,0.5,0.5,1/50,0);

//kiblast_yellow_particle = part_type_create();
//part_type_blend(kiblast_yellow_particle,true);
//part_type_color3(kiblast_yellow_particle,c_white,make_color_rgb(255,255,0),c_black);
//part_type_life(kiblast_yellow_particle,10,10);
//part_type_shape(kiblast_yellow_particle,pt_shape_flare)
//part_type_size(kiblast_yellow_particle,0.5,0.5,1/50,0);

//kiblast_purple_particle = part_type_create();
//part_type_blend(kiblast_purple_particle,true);
//part_type_color3(kiblast_purple_particle,c_white,make_color_rgb(128,0,255),c_black);
//part_type_life(kiblast_purple_particle,10,10);
//part_type_shape(kiblast_purple_particle,pt_shape_flare)
//part_type_size(kiblast_purple_particle,0.5,0.5,1/50,0);

//kiblast_green_particle = part_type_create();
//part_type_blend(kiblast_green_particle,true);
//part_type_color3(kiblast_green_particle,c_white,make_color_rgb(0,192,255),c_black);
//part_type_life(kiblast_green_particle,10,10);
//part_type_shape(kiblast_green_particle,pt_shape_flare)
//part_type_size(kiblast_green_particle,0.5,0.5,1/50,0);

//kamehameha_particle = part_type_create();
//part_type_blend(kamehameha_particle,true);
//part_type_color3(kamehameha_particle,c_white,make_color_rgb(0,192,255),c_black);
//part_type_life(kamehameha_particle,20,20);
//part_type_shape(kamehameha_particle,pt_shape_flare)
//part_type_size(kamehameha_particle,1,1,1/50,0);

//kamehameha_spread_particle = part_type_create();
//part_type_blend(kamehameha_spread_particle,true);
//part_type_color2(kamehameha_spread_particle,c_white,make_color_rgb(0,192,255));
//part_type_life(kamehameha_spread_particle,10,15);
//part_type_shape(kamehameha_spread_particle,pt_shape_line)
//part_type_size(kamehameha_spread_particle,0.1,0.3,-1/100,0);
//part_type_direction(kamehameha_spread_particle,-60,60,0,0);
//part_type_orientation(kamehameha_spread_particle,0,0,0,0,true);
//part_type_speed(kamehameha_spread_particle,5,10);

function add_kiblast_state(_maxrepeats,_sprite1,_sprite2,_kiblastsprite) {
	max_kiblasts = _maxrepeats;
	kiblast_count = 0;
	
	kiblast_sprite = _sprite1;
	kiblast_sprite2 = _sprite2;
	kiblast_shot_sprite = _kiblastsprite;
	
	kiblast = new charstate();
	kiblast.start = function() {
		if check_mp(1/max_kiblasts) {
			if sprite == kiblast_sprite {
				change_sprite(kiblast_sprite2,frame_duration,false);
			}
			else {
				change_sprite(kiblast_sprite,2,false);
			}
		}
		else {
			change_state(idle_state);
		}
	}
	kiblast.run = function() {
		if check_frame(3) {
			var _x = sprite_get_bbox_right(sprite) - sprite_get_xoffset(sprite);
			var _y = sprite_get_bbox_top(sprite) - sprite_get_yoffset(sprite);
			create_kiblast(_x,_y,kiblast_particle);
			if is_airborne {
				xspeed = -2 * facing;
				yspeed = -2;
			}
			kiblast_count += 1;
			spend_mp(1/max_kiblasts);
		}
		if frame > 3 {
			add_cancel(kiblast);
			can_cancel = (kiblast_count < max_kiblasts) and (check_mp(1/max_kiblasts));
		}
		if state_timer >= 50 {
			change_state(idle_state);
		}
	}
	kiblast.stop = function() {
		if next_state != kiblast {
			kiblast_count = 0;
		}
	}
}

function create_kiblast(_x,_y,_sprite) {
	with(create_shot(
		_x,
		_y,
		20,
		random_range(-2,2),
		_sprite,
		32 / sprite_get_height(_sprite),
		100,
		3,
		-3,
		attacktype.normal,
		attackstrength.light,
		hiteffects.fire
	)) {
		blend = true;
		hit_script = function() {
			create_particles(x,y,explosion_small_particle);
		}
		active_script = function() {
			if y >= ground_height {
				hit_script();
				instance_destroy();
			}
		}
		play_sound(snd_kiblast_fire);
		return id;
	}
}

function ssj2_sparks() {
	var _scale = random(0.75);
	var _spark = char_specialeffect(
		spr_electric_spark,
		random(width*0.25) * choose(1,-1),
		random_range(height*0.25,height*0.75) * -1,
		choose(_scale,-_scale),
		choose(_scale,-_scale),
		random(360),
	);
	with(_spark) {
		play_sound(
			snd_electric_spark,
			random_range(1,0.5),
			random_range(0.8,1.2)
		);
	}
}