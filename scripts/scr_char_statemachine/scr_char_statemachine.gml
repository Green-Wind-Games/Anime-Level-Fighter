function charstate() : state() constructor {
	framedata = {
		startup: 0,
		activeframes: 0,
		recovery: 0,
		duration: 0,
		
		min_startup: 0,
		min_activeframes: 0,
		min_recovery: 0,
		min_duration: 0,
		
		max_startup: 0,
		max_activeframes: 0,
		max_recovery: 0,
		max_duration: 0,
		
		advantage_hit: 0,
		advantage_block: 0,
	}
	
	is_attack = false;
	
	is_normalattack = false;
	is_command_normal = false;
	
	is_special = false;
	is_super = false;
	is_ultimate = false;
	
	is_hitstate = false;
	is_guardstate = false;
}