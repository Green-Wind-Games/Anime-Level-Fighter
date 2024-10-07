// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function add_kiblast_state(_maxrepeats,_sprite1,_sprite2,_kiblastsprite) {
	max_kiblasts = _maxrepeats;
	kiblast_count = 0;
	
	kiblast_sprite = _sprite1;
	kiblast_sprite2 = _sprite2;
	kiblast_shot_sprite = _kiblastsprite;
	
	kiblast = new state();
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
			change_state(previous_state);
		}
	}
	kiblast.run = function() {
		if check_frame(3) {
			var _x = sprite_get_bbox_right(sprite) - sprite_get_xoffset(sprite);
			var _y = sprite_get_bbox_top(sprite) - sprite_get_yoffset(sprite);
			create_kiblast(_x,_y,kiblast_shot_sprite);
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
			create_particles(x,y,x,y,explosion_small);
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
	var _scale = random_range(1/3,1/2);
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