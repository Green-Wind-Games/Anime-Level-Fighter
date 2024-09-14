if round_state == roundstates.pause exit;

x += xspeed;
y += yspeed;

run_animation();

if anim_finished {
	instance_destroy();
}