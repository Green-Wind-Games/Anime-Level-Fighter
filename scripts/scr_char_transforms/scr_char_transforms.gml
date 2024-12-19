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
	
	max_hp = base_hp;
	//max_hp = round(max_hp * ((level*level_scaling)+1));
	
	hp = map_value(_hp,0,100,0,max_hp);
	
	//hp += _heal;
	hp = min(round(hp),max_hp);
	
	move_speed = map_value(level,1,max_level,base_movespeed,base_movespeed+5);
	
	reset_combo();
}
			
function transform(_form) {
	var _level = level;
	var _maxhp = max_hp;
	var _hp = hp;
	var _mp = mp;
	var _tp = tp;
	var _team = team;
	var _target = target;
	var _input = input;
	
	array_delete(ground_movelist,0,array_length(ground_movelist));
	array_delete(air_movelist,0,array_length(air_movelist));
	
	instance_change(_form,true);
	
	level = _level;
	max_hp = _maxhp;
	hp = map_value(_hp,0,_maxhp,0,max_hp);
	mp = _mp;
	tp = _tp;
	xp = 0;
	team = _team;
	target = _target;
	input = _input;
	
	face_target();
	change_state(levelup_state);
}

function auto_levelup() {
	if !is_char(id) return false;
	if !target_exists() return false;
	
	if level >= max_level return false;
	
	if xp < max_xp return false;
	
	if next_form == -1 {
		change_state(levelup_state);
		play_voiceline(voice_powerup);
		play_chartheme(theme);
		xp = 0;
	}
	else {
		change_state(transform_state);
		var _nextform = instance_create(0,0,next_form);
		play_chartheme(_nextform.theme);
		instance_destroy(_nextform);
	}
	can_cancel = false;
	return true;
}