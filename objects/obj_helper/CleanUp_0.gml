// Inherit the parent event
event_inherited();

if instance_exists(input) {
	instance_destroy(input);
}