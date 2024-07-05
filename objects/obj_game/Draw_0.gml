/// @description Insert description here
// You can write your code in this editor

switch(game_state) {
	case gamestates.story_battle:
	case gamestates.versus_battle:
	case gamestates.training:
	draw_ground();
	//draw_player_outlines();
	draw_chars();
	draw_shots();
	
	draw_superfreeze();
	
	draw_particles();

	//draw_hitboxes();

	//with(obj_char) {
	//	draw_set_halign(fa_center);
	//	draw_set_valign(fa_top);
	//	draw_set_color(c_white);
	//	draw_text(x,y,string(input_forward-input_back));
	//	draw_text(x,y,string(hp)+"/"+string(max_hp)+" HP");
	//}
	break;
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);