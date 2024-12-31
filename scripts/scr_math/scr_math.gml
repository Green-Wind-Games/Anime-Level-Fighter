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
	if _value < min(_min,_max) return false;
	if _value > max(_min,_max) return false;
	return true;
}

function keep_value_out(_value,_min,_max) {
	var _mid = mean(_min,_max);
	var _min2 = min(_min,_max) - 1;
	var _max2 = max(_min,_max) + 1;
	if value_in_range(_value,_min2,_max2) {
		if _value < _mid {
			_value = _min2;
		}
		else {
			_value = _max2;
		}
	}
	return _value;
}

function chance(_percent) {
	return random(100) < _percent;
}

function sine_wave(_time, _period, _amplitude, _midpoint) {
    return sin(_time * 2 * pi / _period) * _amplitude + _midpoint;
}

function sine_between(_time, _period, _minimum, _maximum) {
    var _midpoint = mean(_minimum, _maximum);
    var _amplitude = _maximum - _midpoint;
    return sine_wave(_time, _period, _amplitude, _midpoint);
}

function get_team_score(_team = team) {
	var team_score = 0;
	var team_score_divider = 0;
	with(obj_char) {
		if team == _team {
			team_score += clamp(hp_percent,0,100);
			if dead {
				team_score -= 100;
			}
			team_score_divider++;
		}
	}
	if team_score_divider > 0 {
		if team_score > 0 {
			team_score /= team_score_divider;
		}
	}
	return team_score;
}