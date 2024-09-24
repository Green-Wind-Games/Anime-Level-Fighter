globalvar	max_level, level_scaling,
			transform_min_hp_percent, transform_heal_percent,
			transform_late_hp_percent_increase, transform_late_heal_percent_increase;
			
max_level = 2;
level_scaling = 1/4;

transform_min_hp_percent = 20;
transform_heal_percent = 60;

transform_late_hp_percent_increase = 20;
transform_late_heal_percent_increase = 20;

function level_up() {
	level++;
	
	var level_difference = target.level - level;
	
	max_hp = round(base_hp * ((level*level_scaling)+1));
	
	var _heal = map_value(
		transform_heal_percent + (transform_late_heal_percent_increase * max(0,level_difference)),
		0,
		100,
		0,
		max_hp
	);
	
	hp += _heal;
	hp = min(round(hp),max_hp);
	
	move_speed = base_movespeed + (level - 1);
}
			
function transform(_form) {
	var _level = level;
	var _maxhp = max_hp;
	var _hp = hp;
	var _mp = mp;
	var _tp = tp;
	var _target = target;
	
	instance_change(_form,true);
	
	level = _level;
	max_hp = _maxhp;
	hp = map_value(_hp,0,_maxhp,0,max_hp);
	mp = _mp;
	tp = _tp;
	target = _target;
	
	face_target();
	change_state(levelup_state);
}

function auto_levelup() {
	if !is_char(id) return false;
	if !target_exists() return false;
	
	if level >= max_level return false;
	
	var _required_pct = transform_min_hp_percent + (transform_late_hp_percent_increase * max(0,target.level-level));
	if hp_percent > _required_pct return false;
	
	if next_form == noone {
		change_state(levelup_state);
		play_voiceline(voice_powerup);
	}
	else {
		change_state(transform_state);
	}
	can_cancel = false;
	return true;
}