// Inherit the parent event
event_inherited();

input = instance_create(0,0,obj_input);
with(input) {
	type = input_types.ai;
	persistent = false;
}

duration = -1;

helper_script = function() {
	if irandom(3) and (target_distance_x > 10) {
		change_sprite(walk_sprite,4,true);
	}
	else {
		change_sprite(idle_sprite,6,true);
	}
}

helper_attack_script = function() {};

death_script = function() {
	instance_destroy();
}

init_helperstates();