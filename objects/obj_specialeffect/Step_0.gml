if round_state == roundstates.pause exit;

x += xspeed;
y += yspeed;

yspeed += ygravity * affected_by_gravity;

run_animation();

if anim_finished {
	instance_destroy();
}