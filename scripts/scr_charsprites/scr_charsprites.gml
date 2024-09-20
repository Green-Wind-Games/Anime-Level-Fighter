// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

enum grab_point {
	base,
	head,
	body,
	leg
}

enum grab_frames {
	justgrabbed,
	low,
	mid,
	high,
	air,
	launch,
	liedown
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
	
	grabbed_sprite[grab_point.base] = asset_get_index(prefix + "grabbed_base");
	grabbed_sprite[grab_point.head] = asset_get_index(prefix + "grabbed_head");
	grabbed_sprite[grab_point.body] = asset_get_index(prefix + "grabbed_body");
	grabbed_sprite[grab_point.leg] = asset_get_index(prefix + "grabbed_leg");
	
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