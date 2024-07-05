// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function init_physics() {
	xspeed = 0;
	yspeed = 0;
	walk_speed = 5;
	dash_speed = walk_speed * 2;
	jump_speed = 8;
	on_ground = y >= ground_height and yspeed >= 0;
	is_airborne = !on_ground;
	on_left_wall = x <= left_wall;
	on_right_wall = x >= right_wall;
	on_wall = on_left_wall or on_right_wall;
}

function run_physics() {
	x += xspeed;
	y += yspeed;
	on_left_wall = x <= left_wall;
	on_right_wall = x >= right_wall;
	on_wall = on_left_wall or on_right_wall;
	on_ground = y >= ground_height and yspeed >= 0;
	is_airborne = !on_ground;
}

function gravitate(_multiplier = 1) {
	if is_airborne {
		yspeed += ygravity * _multiplier;
	}
}

function accelerate(_desired_speed, _speed = 2) {
	xspeed = approach(xspeed,_desired_speed,_speed);
}

function decelerate(_speed = 1) {
	if on_ground {
		xspeed = approach(xspeed,0,_speed);
	}
}

function bounce_off_wall() {
	if on_left_wall {
		xspeed = abs(xspeed);
	}
	else if on_right_wall {
		xspeed = -abs(xspeed);
	}
}