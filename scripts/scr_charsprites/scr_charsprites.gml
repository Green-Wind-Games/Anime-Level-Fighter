// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

enum grab_point {
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
	
	grab_sprite[grab_point.head][grab_type.hit] = asset_get_index(prefix + "grab_head_hit");
	grab_sprite[grab_point.body][grab_type.hit] = asset_get_index(prefix + "grab_body_hit");
	grab_sprite[grab_point.leg][grab_type.hit] = asset_get_index(prefix + "grab_leg_hit");
	
	grab_sprite[grab_point.head][grab_type.tilt_back] = asset_get_index(prefix + "grab_head_tilt_back");
	grab_sprite[grab_point.body][grab_type.tilt_back] = asset_get_index(prefix + "grab_body_tilt_back");
	grab_sprite[grab_point.leg][grab_type.tilt_back] = asset_get_index(prefix + "grab_leg_tilt_back");
	
	grab_sprite[grab_point.head][grab_type.tilt_forward] = asset_get_index(prefix + "grab_head_tilt_forward");
	grab_sprite[grab_point.body][grab_type.tilt_forward] = asset_get_index(prefix + "grab_body_tilt_forward");
	grab_sprite[grab_point.leg][grab_type.tilt_forward] = asset_get_index(prefix + "grab_leg_tilt_forward");
	
	grab_sprite[grab_point.head][grab_type.liedown] = asset_get_index(prefix + "grab_head_liedown");
	grab_sprite[grab_point.body][grab_type.liedown] = asset_get_index(prefix + "grab_body_liedown");
	grab_sprite[grab_point.leg][grab_type.liedown] = asset_get_index(prefix + "grab_leg_liedown");
	
	grab_sprite[grab_point.head][grab_type.hang] = asset_get_index(prefix + "grab_head_hang");
	grab_sprite[grab_point.body][grab_type.hang] = asset_get_index(prefix + "grab_body_hang");
	grab_sprite[grab_point.leg][grab_type.hang] = asset_get_index(prefix + "grab_leg_hang");
	
	grab_sprite[grab_point.head][grab_type.fall] = asset_get_index(prefix + "grab_head_fall");
	grab_sprite[grab_point.body][grab_type.fall] = asset_get_index(prefix + "grab_body_fall");
	grab_sprite[grab_point.leg][grab_type.fall] = asset_get_index(prefix + "grab_leg_fall");
	
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
	
	var _w = max(30,width);
	var _h = max(40,height);
	
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