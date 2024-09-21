globalvar	max_level, level_scaling,
			transform_min_hp_percent, transform_heal_percent;
			
max_level = 2;
level_scaling = 0;

transform_min_hp_percent = 15;
transform_heal_percent = 80;

function level_up() {
	level++;
	
	max_hp = round(base_hp * ((level*level_scaling)+1));
	
	hp += map_value(transform_heal_percent,0,100,0,max_hp);
	hp = min(round(hp),max_hp);
	
	move_speed = base_movespeed + (level - 1);
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