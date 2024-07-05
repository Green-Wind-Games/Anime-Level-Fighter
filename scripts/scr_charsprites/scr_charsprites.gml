// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function init_charsprites(_name) {
	var prefix = "spr_" + _name + "_";
	
	idle_sprite = asset_get_index(prefix + "idle");
	walk_sprite = asset_get_index(prefix + "walk");
	
	crouch_sprite = asset_get_index(prefix + "crouch");
	uncrouch_sprite = asset_get_index(prefix + "uncrouch");
	
	dash_sprite = asset_get_index(prefix + "dash");
	
	air_up_sprite = asset_get_index(prefix + "air_up");
	air_peak_sprite = asset_get_index(prefix + "air_peak");
	air_down_sprite = asset_get_index(prefix + "air_down");
	
	swing_sprite = asset_get_index(prefix + "swing");
	thrust_sprite = asset_get_index(prefix + "thrust");
	shoot_sprite = asset_get_index(prefix + "shoot");
	
	chant_sprite = asset_get_index(prefix + "chant");
	cast_sprite = asset_get_index(prefix + "cast");
	
	guard_sprite = asset_get_index(prefix + "guard");
	
	hurt_sprite = asset_get_index(prefix + "hurt");
	launch_sprite = asset_get_index(prefix + "launch");
	spinout_sprite = asset_get_index(prefix + "spinout");
	
	grabbed_sprite = asset_get_index(prefix + "grabbed");
	grabbed_head_sprite = asset_get_index(prefix + "grabbed_head");
	grabbed_body_sprite = asset_get_index(prefix + "grabbed_body");
	
	liedown_sprite = asset_get_index(prefix + "liedown");
	wakeup_sprite = asset_get_index(prefix + "wakeup");
	tech_sprite = asset_get_index(prefix + "tech");
	
	victory_sprite = asset_get_index(prefix + "victory");
	defeat_sprite = asset_get_index(prefix + "defeat");
	
	icon = asset_get_index(prefix + "icon");
	
	init_sprite(idle_sprite);
	
	width = sprite_get_bbox_right(sprite) - sprite_get_bbox_left(sprite);
	height = sprite_get_bbox_bottom(sprite) - sprite_get_bbox_top(sprite);
	
	var _scale = 0.75;
	width = floor(width * _scale);
	height = floor(height * _scale);
	
	width_half = floor(width / 2);
	height_half = floor(height / 2);
	
	var _w = max(20,width);
	var _h = max(30,height);
	
	create_hurtbox(-_w/2,-_h,_w,_h);
}