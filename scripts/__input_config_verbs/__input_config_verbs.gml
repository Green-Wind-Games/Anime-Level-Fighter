// Feather disable all

//This script contains the default profiles, and hence the default bindings and verbs, for your game
//
//  Please edit this macro to meet the needs of your game!
//
//The struct return by this script contains the names of each default profile.
//Default profiles then contain the names of verbs. Each verb should be given a binding that is
//appropriate for the profile. You can create bindings by calling one of the input_binding_*()
//functions, such as input_binding_key() for keyboard keys and input_binding_mouse() for
//mouse buttons

function __input_config_verbs()
{
	return {
		keyboard_wasd:
		{
			up:				input_binding_key("W"),
			down:			input_binding_key("S"),
			left:			input_binding_key("A"),
			right:			input_binding_key("D"),
			
			confirm:		input_binding_key("N"),
			cancel:			input_binding_key("M"),
			
			light_attack:	input_binding_key("B"),
			medium_attack:	input_binding_key("N"),
			heavy_attack:	input_binding_key("M"),
			special_attack:	input_binding_key("G"),
			mp_charge:		input_binding_key("H"),
			tp_tech:		input_binding_key("J"),
			
			taunt:			input_binding_key("T"),
			
			pause:			input_binding_key(vk_escape),
		},
		
		keyboard_numpad:
		{
			up:				input_binding_key(vk_up),
			down:			input_binding_key(vk_down),
			left:			input_binding_key(vk_left),
			right:			input_binding_key(vk_right),
			
			confirm:		input_binding_key(vk_numpad1),
			cancel:			input_binding_key(vk_numpad2),
			
			light_attack:	input_binding_key(vk_numpad1),
			medium_attack:	input_binding_key(vk_numpad2),
			heavy_attack:	input_binding_key(vk_numpad3),
			special_attack:	input_binding_key(vk_numpad4),
			mp_charge:		input_binding_key(vk_numpad5),
			tp_tech:		input_binding_key(vk_numpad6),
			
			taunt:			input_binding_key(vk_numpad9),
			
			pause:			input_binding_key(vk_enter),
		},
		
		gamepad:
		{
			up:				[input_binding_gamepad_axis(gp_axislv, true),  input_binding_gamepad_button(gp_padu)],
			down:			[input_binding_gamepad_axis(gp_axislv, false), input_binding_gamepad_button(gp_padd)],
			left:			[input_binding_gamepad_axis(gp_axislh, true),  input_binding_gamepad_button(gp_padl)],
			right:			[input_binding_gamepad_axis(gp_axislh, false), input_binding_gamepad_button(gp_padr)],
			
			confirm:		input_binding_gamepad_button(gp_face1),
			cancel:			input_binding_gamepad_button(gp_face2),
			
			light_attack:	input_binding_gamepad_button(gp_face3),
			medium_attack:	input_binding_gamepad_button(gp_face4),
			heavy_attack:	input_binding_gamepad_button(gp_face2),
			special_attack:	input_binding_gamepad_button(gp_face1),
			mp_charge:		input_binding_gamepad_button(gp_shoulderl),
			tp_tech:		input_binding_gamepad_button(gp_shoulderr),
			
			taunt:			input_binding_gamepad_button(gp_select),
			
			pause:			input_binding_gamepad_button(gp_start),
		},
		
		touch:
		{
			up:				input_binding_virtual_button(),
			down:			input_binding_virtual_button(),
			left:			input_binding_virtual_button(),
			right:			input_binding_virtual_button(),
			
			confirm:		input_binding_virtual_button(),
			cancel:			input_binding_virtual_button(),
			
			light_attack:	input_binding_virtual_button(),
			medium_attack:	input_binding_virtual_button(),
			heavy_attack:	input_binding_virtual_button(),
			special_attack:	input_binding_virtual_button(),
			mp_charge:		input_binding_virtual_button(),
			tp_tech:		input_binding_virtual_button(),
			
			taunt:			input_binding_virtual_button(),
			
			pause:			input_binding_virtual_button(),
		}
	};
}