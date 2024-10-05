if round_state == roundstates.pause exit;

if facing == 0 {
	facing = 1;
}

if sprite == spinout_sprite 
or sprite == launch_sprite {
	yoffset = -height_half;
	rotation = point_direction(0,0,abs(xspeed),-yspeed);
}

//if sprite == spinout_sprite {
//	if state_timer mod ceil(width / max(1,abs(xspeed))) == 0 {
//		char_specialeffect(
//			spr_launch_wind_spin,
//			0,
//			-height_half,
//			1/3,
//			1/3,
//			point_direction(0,0,abs(xspeed),yspeed)
//		)
//	}
//}

with(obj_char) {
	if grabbed or other.grabbed continue;
	if dead or other.dead continue;
	if team == other.team continue;
	if is_helper(id) {
		if duration != -1 continue;
	}
	if is_helper(other) {
		if other.duration != -1 continue;
	}
			
	if !rectangle_in_rectangle(
		x-width_half,
		y-height,
		x+width_half,
		y,
		other.x-other.width_half,
		other.y-other.height,
		other.x+other.width_half,
		other.y,
	) continue;
			
	var _dist = abs(x-other.x);
	_dist -= width_half;
	_dist -= other.width_half;
	if _dist >= 0 continue;
	
	var pushme = true;
	var pushthem = true;
	
	if is_char(id) {
		if is_helper(other) {
			pushme = false;
			pushthem = true;
		}
	}
	else if is_helper(id) {
		if is_char(other) {
			pushme = true;
			pushthem = false;
		}
	}
	
	if !(pushme or pushthem) {
		pushme = true;
		pushthem = true;
	}
			
	var _push = -sign(x-other.x);
	//if _push == 0 then _push = sign(on_left_wall - on_right_wall) * sign(y - other.y);
	if _push == 0 then _push = facing;
	if _push == 0 then _push = 1;
	_push *= 0.5;
	
	var i = 0;
	while(_dist < 0) {
		if pushme {
			x = clamp(x-_push, left_wall, right_wall);
		}
		if pushthem {
			other.x = clamp(other.x+_push, left_wall, right_wall);
		}
		_dist = point_distance(x,0,other.x,0) - (width_half + other.width_half);
		if i++ >= 20 break;
	}
}

if active_state == super_state {
	super_active = true;
}
else {
	super_state = noone;
	super_active = false;
}

if hitstop < 0 then hitstop = 0;

if (!hitstop) and (!timestop_active) and (!superfreeze_active) {
	tp += 1;
	if combo_timer-- <= 0 {
		reset_combo();
	}
}

if level >= max_level {
	 xp = 0;
}

hp = clamp(round(hp),0,max_hp);
mp = clamp(round(mp),0,max_mp);
tp = clamp(round(tp),0,max_tp);
xp = clamp(round(xp),0,max_xp);
		
mp_stocks = floor(mp/mp_stock_size);
tp_stocks = floor(tp/tp_stock_size);
		
dead = hp <= 0;
		
hp_percent = (hp/max_hp)*100;
mp_percent = (mp/max_mp)*100;
tp_percent = (tp/max_tp)*100;
xp_percent = (xp/max_xp)*100;
dmg_percent = (combo_damage_taken / max_hp) * 100;

hp_percent_visible = lerp(hp_percent_visible,hp_percent,0.5);
mp_percent_visible = lerp(mp_percent_visible,mp_percent,0.5);
tp_percent_visible = lerp(tp_percent_visible,tp_percent,0.5);
xp_percent_visible = lerp(xp_percent_visible,xp_percent,0.5);
dmg_percent_visible = lerp(dmg_percent_visible, dmg_percent, 0.5);

dmg_percent_visible = max(
	dmg_percent_visible,
	map_value(
		hp_percent_visible,
		hp_percent + dmg_percent,
		hp_percent,
		0,
		dmg_percent
	)
);

if (!is_hit) {
	previous_hp = approach(previous_hp,hp,100);
}

//if !value_in_range(hp_percent_visible,0.1,99.9) { hp_percent_visible = round(hp_percent_visible); }
//if !value_in_range(mp_percent_visible,0.1,99.9) { mp_percent_visible = round(mp_percent_visible); }
//if !value_in_range(tp_percent_visible,0.1,99.9) { tp_percent_visible = round(tp_percent_visible); }
//if !value_in_range(xp_percent_visible,0.1,99.9) { xp_percent_visible = round(xp_percent_visible); }
//if !value_in_range(dmg_percent_visible,0.1,99.9) { dmg_percent_visible = round(dmg_percent_visible); }

if dead {
	if death_timer++ >= hitstun {
		death_script();
	}
}
else {
	death_timer = 0;
}