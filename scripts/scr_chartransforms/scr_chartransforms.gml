globalvar	max_level, level_scaling,
			transform_min_hp_percent, transform_heal_percent;
			
max_level = 2;
level_scaling = 2;

transform_min_hp_percent = 10;
transform_heal_percent = 69.420;

function level_up() {
	level++;
	
	max_hp = round(max_hp * level_scaling);
	
	hp += map_value(transform_heal_percent,0,100,0,max_hp);
	hp = min(round(hp),max_hp);
}
			
function transform(_form) {
	var _level = level;
	var _maxhp = max_hp;
	var _hp = hp;
	var _mp = mp;
	var _target = target;
	
	instance_change(_form,true);
	
	level = _level;
	max_hp = _maxhp;
	hp = map_value(_hp,0,_maxhp,0,max_hp);
	mp = _mp;
	target = _target;
	
	face_target();
	change_state(levelup_state);
}

function auto_levelup() {
	if !is_char(id) return false;
	
	if level >= max_level return false;
	if hp_percent > transform_min_hp_percent return false;
	
	if next_form == noone {
		change_state(levelup_state);
		play_voiceline(voice_powerup);
	}
	else {
		change_state(transform_state);
	}
	return true;
}