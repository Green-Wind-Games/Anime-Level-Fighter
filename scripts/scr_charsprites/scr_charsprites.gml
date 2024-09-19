// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

enum grab_point {
	base,
	head,
	body,
	leg
}

enum grab_type {
	hit,
	tilt_back,
	tilt_forward,
	liedown,
	hang,
	fall
}

function init_charsprites(_name) {
	var prefix = "spr_" + _name + "_";
	
	idle_sprite = asset_get_index(prefix + "idle");
	
	crouch_sprite = asset_get_index(prefix + "crouch");
	uncrouch_sprite = asset_get_index(prefix + "uncrouch");
	
	walk_sprite = asset_get_index(prefix + "walk");
	
	jumpsquat_sprite = crouch_sprite;
	
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
	
	grab_sprite[grab_type.hit][grab_point.base] = asset_get_index(prefix + "grab_hit_base");
	grab_sprite[grab_type.hit][grab_point.head] = asset_get_index(prefix + "grab_hit_head");
	grab_sprite[grab_type.hit][grab_point.body] = asset_get_index(prefix + "grab_hit_body");
	grab_sprite[grab_type.hit][grab_point.leg] = asset_get_index(prefix + "grab_hit_leg");
	
	grab_sprite[grab_type.tilt_back][grab_point.base] = asset_get_index(prefix + "grab_tilt_back_base");
	grab_sprite[grab_type.tilt_back][grab_point.head] = asset_get_index(prefix + "grab_tilt_back_head");
	grab_sprite[grab_type.tilt_back][grab_point.body] = asset_get_index(prefix + "grab_tilt_back_body");
	grab_sprite[grab_type.tilt_back][grab_point.leg] = asset_get_index(prefix + "grab_tilt_back_leg");
	
	grab_sprite[grab_type.tilt_forward][grab_point.base] = asset_get_index(prefix + "grab_tilt_forward_base");
	grab_sprite[grab_type.tilt_forward][grab_point.head] = asset_get_index(prefix + "grab_tilt_forward_head");
	grab_sprite[grab_type.tilt_forward][grab_point.body] = asset_get_index(prefix + "grab_tilt_forward_body");
	grab_sprite[grab_type.tilt_forward][grab_point.leg] = asset_get_index(prefix + "grab_tilt_forward_leg");
	
	grab_sprite[grab_type.liedown][grab_point.base] = asset_get_index(prefix + "grab_liedown_base");
	grab_sprite[grab_type.liedown][grab_point.head] = asset_get_index(prefix + "grab_liedown_head");
	grab_sprite[grab_type.liedown][grab_point.body] = asset_get_index(prefix + "grab_liedown_body");
	grab_sprite[grab_type.liedown][grab_point.leg] = asset_get_index(prefix + "grab_liedown_leg");
	
	grab_sprite[grab_type.hang][grab_point.base] = asset_get_index(prefix + "grab_hang_base");
	grab_sprite[grab_type.hang][grab_point.head] = asset_get_index(prefix + "grab_hang_head");
	grab_sprite[grab_type.hang][grab_point.body] = asset_get_index(prefix + "grab_hang_body");
	grab_sprite[grab_type.hang][grab_point.leg] = asset_get_index(prefix + "grab_hang_leg");
	
	grab_sprite[grab_type.fall][grab_point.base] = asset_get_index(prefix + "grab_fall_base");
	grab_sprite[grab_type.fall][grab_point.head] = asset_get_index(prefix + "grab_fall_head");
	grab_sprite[grab_type.fall][grab_point.body] = asset_get_index(prefix + "grab_fall_body");
	grab_sprite[grab_type.fall][grab_point.leg] = asset_get_index(prefix + "grab_fall_leg");
	
	intro_sprite = asset_get_index(prefix + "intro");
	victory_sprite = asset_get_index(prefix + "victory");
	defeat_sprite = asset_get_index(prefix + "defeat");
	
	charge_start_sprite = asset_get_index(prefix + "energy_charge_start");
	charge_loop_sprite = asset_get_index(prefix + "energy_charge_loop");
	charge_stop_sprite = asset_get_index(prefix + "energy_charge_stop");
	
	aura_sprite = noone;
	aura_frame = 0;
	
	icon = asset_get_index(prefix + "icon");
	
	init_sprite(idle_sprite);
	
	var _w = max(32,width);
	var _h = max(48,height);
	
	create_hurtbox(-_w/2,-_h,_w,_h);
}

function apply_hiteffect(_hiteffect,_strength,_guarding) {
	switch(_hiteffect) {
		case hiteffects.fire:
		if !_guarding {
			flash_sprite(10,make_color_rgb(255,64,0));
		}
		break;
	}
}