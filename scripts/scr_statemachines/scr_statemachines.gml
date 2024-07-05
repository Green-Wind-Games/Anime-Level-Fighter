// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function init_states(_state) {
	active_state = _state;
	previous_state = noone;
	next_state = noone;
	state_timer = 0;
	active_state.start();
}

function state() constructor {
	start = function() {};
	run = function() {};
	stop = function() {};
}

function run_state() {
	active_state.run();
}

function change_state(_state) {
	next_state = _state;
	active_state.stop();
	previous_state = active_state;
	active_state = next_state;
	active_state.start();
	next_state = noone;
	state_timer = 0;
}