// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function approach(_start,_end,_speed) {
	if _start > _end {
		return max(_start - _speed, _end);
	}
	else {
		return min(_start + _speed, _end);
	}
}

function map_value(_value, _current_lower_bound, _current_upper_bound, _desired_lowered_bound, _desired_upper_bound) {
	return (((_value - _current_lower_bound) / (_current_upper_bound - _current_lower_bound)) * (_desired_upper_bound - _desired_lowered_bound)) + _desired_lowered_bound;
}

function value_in_range(_value, _min, _max) {
	return (_value >= _min) and (_value <= _max);
}