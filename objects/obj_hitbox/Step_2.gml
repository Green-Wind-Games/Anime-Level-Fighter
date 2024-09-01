event_inherited();
if round_state == roundstates.pause exit;

var active = true;
if instance_exists(owner) {
	if owner.active_state != my_state {
		active = false;
	}
}
else {
	active = false;
}
if duration != -1 {
	duration -= (!owner.hitstop) and (!superfreeze_active) and (!timestop_active);
	if duration <= 0 {
		active = false;
	}
}
if !active {
	instance_destroy();
	exit;
}
	
if (!superfreeze_active) and (!timestop_active) {
	check_hit();
}