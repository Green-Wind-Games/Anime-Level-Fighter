if round_state == roundstates.pause exit;

if facing == 0 {
	facing = 1;
}

if sprite == spinout_sprite 
or sprite == launch_sprite {
	yoffset = -height_half;
	rotation = point_direction(0,0,abs(xspeed),-yspeed);
}

with(obj_char) {
	if grabbed or other.grabbed continue;
	if dead or other.dead continue;
	if team == other.team continue;
	if is_helper(id) or is_helper(other) continue;
			
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
			
	var _push = -sign(x-other.x);
	//if _push == 0 then _push = sign(on_left_wall - on_right_wall) * sign(y - other.y);
	if _push == 0 then _push = facing;
	if _push == 0 then _push = 1;
	_push *= 0.5;
	var i = 0;
	while(_dist < 0) {
		x = clamp(x-_push, left_wall, right_wall);
		other.x = clamp(other.x+_push, left_wall, right_wall);
		_dist = point_distance(x,0,other.x,0) - (width_half + other.width_half);
		if i++ > 20 break;
	}
}

if hitstop < 0 then hitstop = 0;

hp = clamp(round(hp),0,max_hp);
mp = clamp(round(mp),0,max_mp);
tp = clamp(round(tp+1),0,max_tp);
		
hp_percent = (hp/max_hp)*100;
mp_percent = (mp/max_mp)*100;
tp_percent = (tp/max_tp)*100;
		
mp_stocks = floor(mp/mp_stock_size);
tp_stocks = floor(tp/tp_stock_size);
		
dead = (hp <= 0);

if (!hitstop) and (!timestop_active) and (!superfreeze_active) {
	if combo_timer-- <= 0 {
		reset_combo();
	}
}
		
if (!is_hit) and (!is_guarding) {
	previous_hp = approach(previous_hp,hp,100);
}

if active_state == super_state {
	super_active = true;
}
else {
	super_state = noone;
	super_active = false;
}

if dead {
	if death_timer++ >= hitstun {
		death_script();
	}
}
else {
	death_timer = 0;
}

var stay_in = true;
if (is_helper(id) and (duration != -1)) stay_in = false;

if stay_in {
	x = clamp(x, left_wall, right_wall);
}
y = min(y,ground_height);