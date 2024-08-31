if ai_enabled {
	update_ai();
}
		
var _buffer = input_buffer;
		
input.forward = sign(input.right - input.left) == (facing);
input.back = sign(input.right - input.left) == (-facing);
	
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
	input_buffer_timer = ceil(60 / 5);
}
else {
	if (!hitstop) and (!timestop_active) and (!superfreeze_active) {
		if input_buffer_timer-- <= 0 {
			input_buffer = dir;
			input_buffer_timer = 0;
		}
	}}

if ((superfreeze_active) and (superfreeze_activator != id)) exit;
if ((timestop_active) and (timestop_activator != id)) exit;
if (hitstop--) exit;

run_animation();
run_state();
run_physics();
	
if (!superfreeze_active) and (!timestop_active) {
	decelerate();
	gravitate(ygravity_mod);

	char_script();
	state_timer += 1;
}