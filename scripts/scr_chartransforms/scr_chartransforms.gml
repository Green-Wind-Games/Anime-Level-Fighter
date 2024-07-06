globalvar	max_level, level_scaling,
			transform_min_hp_percent, transform_heal_percent;
			
max_level = 5;
level_scaling = 0.5;

transform_min_hp_percent = 25;
transform_heal_percent = 80;

function level_up() {
	level++;
	
	max_hp = ceil(max_hp * (1 + level_scaling));
	
	hp += map_value(transform_heal_percent,0,100,0,max_hp);
	hp = min(ceil(hp),max_hp);
	
	change_state(levelup_state);
}
			
function transform(_form) {
	var _level = level;
	var _maxhp = max_hp;
	var _hp = hp;
	var _mp = mp;
	
	instance_change(_form,true);
	
	level = _level;
	max_hp = _maxhp;
	hp = map_value(_hp,0,_maxhp,0,max_hp);
	mp = _mp;
	
	level_up();
}

function auto_levelup() {
	if level < max_level {
		if hp_percent <= transform_min_hp_percent {
			if next_form == noone {
				level_up();
			}
			else {
				change_state(transform_state);
			}
		}
	}
}