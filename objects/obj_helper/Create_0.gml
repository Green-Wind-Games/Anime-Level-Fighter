// Inherit the parent event
event_inherited();

input = instance_create(0,0,obj_input);
with(input) {
	type = input_types.ai;
	persistent = false;
}

ai_enabled = true;

ai_script = function() {
	input.forward = true;
	
	if target_distance < 50 {
		ai_input_command(choose("A","B"),100);
	}
}

death_script = function() {
	if death_timer >= hitstun {
		instance_destroy();
	}
}