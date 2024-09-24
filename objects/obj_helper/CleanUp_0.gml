// Inherit the parent event
event_inherited();

if instance_exists(input) {
	if !input.persistent {
		instance_destroy(input);
	}
}