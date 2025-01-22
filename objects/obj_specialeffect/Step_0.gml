if round_state == roundstates.pause exit;

if !instance_exists(owner) {
	owner = noone;
	x += xspeed;
	y += yspeed;
	gravitate(ygravity_mod);
}
else {
	x = owner.x;
	y = owner.y;
	//xoffset = owner.xoffset;
	//yoffset = owner.yoffset;
}

update_sprite();

if anim_finished {
	instance_destroy();
}