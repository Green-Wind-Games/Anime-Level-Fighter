function basic_attack(_hitframe,_damage,_attacktype,_strength,_hiteffect) {
	var _hitframe_time = _hitframe * frame_duration;
	if state_timer == _hitframe_time {
		var _w = sprite_get_bbox_right(sprite) - sprite_get_xoffset(sprite);
		var _h = sprite_get_height(sprite) * 0.65;
		var _x = 2;
		var _y = -_h;
		create_hitbox(_x,_y,_w,_h,_damage,3,0,_attacktype,_strength,_hiteffect);
	}
}