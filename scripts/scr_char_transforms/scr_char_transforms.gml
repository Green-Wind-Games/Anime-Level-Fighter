function level_up() {
	var level_difference = target.level - level;
	var _hp = (hp / max_hp) * 100;
	
	level++;
	
	var _heal = map_value(
		transform_heal_percent + (transform_late_heal_percent_increase * max(0,level_difference)),
		0,
		100,
		0,
		max_hp
	);
	
	//max_hp = base_max_hp;
	//max_hp = round(max_hp * (1 + ((level-1) * level_scaling)));
	
	hp = map_value(_hp,0,100,0,max_hp);
	
	//hp += _heal;
	//hp = min(round(hp),max_hp);
	
	mp += mp_stock_size;
	tp += tp_stock_size;
	
	max_xp = base_max_xp * (level * level);
	xp = 0;
	
	move_speed = map_value(level,1,max_level,base_movespeed,base_movespeed+5);
	
	reset_combo();
}
			
function transform(_form) {
	var _level = level;
	var _maxhp = max_hp;
	var _maxxp = max_xp;
	var _hp = hp;
	var _mp = mp;
	var _tp = tp;
	var _xp = xp;
	var _hp_p = hp_percent;
	var _mp_p = mp_percent;
	var _tp_p = tp_percent;
	var _xp_p = xp_percent;
	var _hp_pv = hp_percent_visible;
	var _mp_pv = mp_percent_visible;
	var _tp_pv = tp_percent_visible;
	var _xp_pv = xp_percent_visible;
	var _team = team;
	var _target = target;
	var _input = input;
	
	array_delete(ground_movelist,0,array_length(ground_movelist));
	array_delete(air_movelist,0,array_length(air_movelist));
	
	instance_change(_form,true);
	
	level = _level;
	
	max_hp = _maxhp;
	max_xp = _maxxp;
	
	hp = map_value(_hp,0,_maxhp,0,max_hp);
	mp = _mp;
	tp = _tp;
	xp = 0;
	
	hp_percent = _hp_p;
	mp_percent = _mp_p;
	tp_percent = _tp_p;
	xp_percent = _xp_p;
	
	hp_percent_visible = _hp_pv;
	mp_percent_visible = _mp_pv;
	tp_percent_visible = _tp_pv;
	xp_percent_visible = _xp_pv;
	
	team = _team;
	target = _target;
	input = _input;
	
	face_target();
	change_state(levelup_state);
}

function auto_levelup() {
	if xp < max_xp return false;
	if level >= max_level return false;
	
	if !is_char(id) return false;
	if !target_exists() return false;
	
	if is_hit return false;
	if is_guarding return false;
	//if !can_cancel return false;
	
	if object_exists(next_form) {
		var _nextform = instance_create(0,0,next_form);
		play_chartheme(_nextform);
		instance_destroy(_nextform);
		change_state(transform_state);
	}
	else {
		change_state(levelup_state);
		xp = 0;
		play_voiceline(voice_powerup);
		play_chartheme(id);
	}
	can_cancel = false;
	return true;
}