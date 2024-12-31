function check_frame(_frame) {
	if (frame != _frame) return false;
	
	if frame_timer < 0 return false;
	if frame_timer >= anim_speed return false;
	
	return true;
}

function loop_anim_middle(_start, _end) {
	if frame > _end {
		frame = _start;
		frame_timer = 1;
	}
}

function loop_anim_middle_timer(_start, _end, _timer) {
	if state_timer < _timer {
		loop_anim_middle(_start, _end);
	}
}

function sprite_sequence(_sprites, _frameduration) {
	for(var i = 0; i < array_length(_sprites) - 1; i++) {
		if sprite == _sprites[i] {
			next_sprite = _sprites[i+1];
			next_sprite_frame_duration = _frameduration;
			next_sprite_anim_loop = false;
			break;
		}
	}
}