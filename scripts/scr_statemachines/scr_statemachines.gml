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

function update_state() {
	active_state.run();
}

function change_state(_state) {
	next_state = _state;
	active_state.stop();
	
	if object_is_ancestor(object_index,obj_char) {
		change_charstate();
	}
	
	previous_state = active_state;
	active_state = next_state;
	next_state = noone;
	active_state.start();
	state_timer = 0;
}