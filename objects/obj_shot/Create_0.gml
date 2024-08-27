/// @description Insert description here
// You can write your code in this editor

init_physics();

hit_limit = 1;
hit_count = 0;

affected_by_gravity = false;
bounce = false;
homing = false;
homing_speed = 1;
homing_max_turn = 10;
duration = -1;

target = noone;
active_state = 0;

active_script = function() {};
hit_script = function() {};
expire_script = function() {};

blend = true;

hitstop = 0;