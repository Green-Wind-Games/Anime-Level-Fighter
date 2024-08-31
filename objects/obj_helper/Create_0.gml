// Inherit the parent event
event_inherited();

input = instance_create(0,0,obj_input);
with(input) {
	type = input_types.ai;
	persistent = false;
}

helper_script = function() {
	if irandom(3) == 1 {
		change_state(jump_state);
	}
	else if irandom(3) == 1 {
		change_sprite(walk_sprite,map_value(sprite_get_number(walk_sprite),4,8,6,3),true);
	}
	else {
		change_sprite(idle_sprite,6,true);
	}
}

helper_attack_script = function() {
	if (target_distance < 10) {
		change_state(choose(melee_state,melee_state_alt));
	}
	else if (target_distance > 100) {
		change_state(shoot_state);
	}
}

death_script = function() {
	if death_timer >= hitstun {
		instance_destroy();
	}
}

init_helperstates();