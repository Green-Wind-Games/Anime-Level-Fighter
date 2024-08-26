// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

enum grab_sprites {
	hold,
	low,
	mid,
	high,
	hanging,
	pushed,
	liedown
}

function init_charsprites(_name) {
	var prefix = "spr_" + _name + "_";
	
	idle_sprite = asset_get_index(prefix + "idle");
	walk_sprite = asset_get_index(prefix + "walk");
	
	crouch_sprite = asset_get_index(prefix + "crouch");
	uncrouch_sprite = asset_get_index(prefix + "uncrouch");
	
	air_up_sprite = asset_get_index(prefix + "air_up");
	air_peak_sprite = asset_get_index(prefix + "air_peak");
	air_down_sprite = asset_get_index(prefix + "air_down");
	
	dash_sprite = asset_get_index(prefix + "dash");
	
	guard_sprite = asset_get_index(prefix + "guard");
	
	hit_high_sprite = asset_get_index(prefix + "hit_high");
	hit_low_sprite = asset_get_index(prefix + "hit_low");
	hit_air_sprite = asset_get_index(prefix + "hit_air");
	
	launch_sprite = asset_get_index(prefix + "hit_launch");
	spinout_sprite = asset_get_index(prefix + "hit_spinout");
	liedown_sprite = asset_get_index(prefix + "liedown");
	wakeup_sprite = asset_get_index(prefix + "wakeup");
	tech_sprite = asset_get_index(prefix + "air_recover");
	
	grabbed_sprite = asset_get_index(prefix + "grabbed");
	grabbed_head_sprite = asset_get_index(prefix + "grabbed_head");
	grabbed_body_sprite = asset_get_index(prefix + "grabbed_body");
	grabbed_leg_sprite = asset_get_index(prefix + "grabbed_leg");
	
	intro_sprite = asset_get_index(prefix + "intro");
	victory_sprite = asset_get_index(prefix + "victory");
	defeat_sprite = asset_get_index(prefix + "defeat");
	
	charge_sprite = asset_get_index(prefix + "energy_charge");
	
	icon = asset_get_index(prefix + "icon");
	
	init_sprite(idle_sprite);
	
	var _scale = 0.8;
	width = floor(sprite_get_width(sprite) * _scale);
	height = floor(sprite_get_height(sprite) * _scale);
	
	width_half = floor(width/2);
	height_half = floor(height/2);
	
	var _w = max(30,width);
	var _h = max(40,height);
	
	create_hurtbox(-_w/2,-_h,_w,_h);
}

function apply_hiteffect(_hiteffect,_strength,_guarding) {
	switch(_hiteffect) {
		case hiteffects.fire:
		if !_guarding {
			flash_sprite(10,make_color_rgb(255,irandom(100),0));
		}
		break;
	}
}