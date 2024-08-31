function create_helper(_x,_y,_spritename,_aiscript = -1) {
	var me = id;
	var _helper = instance_create(x+(_x * facing),_y,obj_helper);
	with(_helper) {
		owner = me;
		team = me.team;
		facing = me.facing;
		target = me.facing;
		
		init_charsprites(_spritename);
		
		if _aiscript != -1 {
			ai_script = _aiscript;
		}
	}
	return _helper;
}