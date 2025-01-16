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

function change_charstate() {
	state_change_script();
	
	attack_whiff_script = function() {};
	attack_dodge_script = function() {};
	attack_connect_script = function() {};
	attack_hit_script = function() {};
	attack_block_script = function() {};
	attack_parry_script = function() {};
	
	defense_whiff_script = function() {};
	defense_dodge_script = function() {};
	defense_connect_script = function() {};
	defense_hit_script = function() {};
	defense_block_script = function() {};
	defense_parry_script = function() {};
	
	anim_end_script = function() {};
}