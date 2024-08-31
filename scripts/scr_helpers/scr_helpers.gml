function create_helper(_x,_y,_charscript,_aiscript) {
	var me = id;
	var _helper = instance_create(x+(_x * facing),y+_y,obj_helper);
	with(_helper) {
		_charscript();
		
		owner = me;
		team = me.team;
		facing = me.facing;
		target = me.target;
		ai_script = _aiscript;
		
		max_hp = round(owner.max_hp / 50);
	}
	return _helper;
}