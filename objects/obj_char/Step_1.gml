if round_state == roundstates.pause exit;

input.forward = sign(input.right - input.left) == (facing);
input.back = sign(input.right - input.left) == (-facing);

var _buffer = input_buffer;
	
var hor = sign(input.forward - input.back);
var ver = sign(input.up - input.down);
var dir = string(5 + hor + (ver * 3));
	
if !string_ends_with(string_digits(input_buffer),dir) {
	input_buffer += dir;
}
		
var command = "";
if input.button1 { command += "A"; }
if input.button2 { command += "B"; }
if input.button3 { command += "C"; }
if input.button4 { command += "D"; }
if input.button5 { command += "E"; }
if input.button6 { command += "F"; }
		
input_buffer += command;
	
if input_buffer != _buffer {
	input_buffer_timer = 12;
}
else {
	if (!hitstop) and (!timestop_active) and (!superfreeze_active) {
		if input_buffer_timer-- <= 0 {
			input_buffer = dir;
			input_buffer_timer = 0;
		}
	}
}
	
target = target_closest_enemy();
if target_exists() {
	target_x = target.x;
	target_y = target.y;
	target_distance_x = max(abs(x-target_x) - (width_half+target.width_half),0);
	target_distance_y = abs(target_y - y);
	target_distance = abs(target_distance_x) + abs(target_distance_y);
	target_direction = point_direction(x,y-height_half,target_x,target_y-target.height_half);
}
		
if ai_enabled {
	update_ai();
}