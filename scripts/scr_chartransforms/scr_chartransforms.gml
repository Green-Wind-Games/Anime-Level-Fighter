globalvar	max_level, level_scaling,
			transform_min_hp_percent, transform_heal_percent;
			
max_level = 5;
level_scaling = 1.5;

transform_min_hp_percent = 25;
transform_heal_percent = 100 - transform_min_hp_percent - 10;
			
function transform(_form) {
	var _maxhp = max_hp;
	var _hp = hp;
	var _level = level;
	
	instance_change(_form,true);
	
	max_hp = _maxhp * (level * level_scaling);
	hp = map_value(_hp,0,_maxhp,0,max_hp);
	level++;
	
	hp += map_value(transform_heal_percent,0,100,0,max_hp);
	
	max_hp = ceil(max_hp);
	hp = min(ceil(hp),max_hp);
	
	change_state(transform_finish_state);
}