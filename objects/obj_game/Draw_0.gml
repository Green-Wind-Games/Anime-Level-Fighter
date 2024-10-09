/// @description Insert description here
// You can write your code in this editor

switch(game_state) {
	case gamestates.story_battle:
	case gamestates.arcade_battle:
	case gamestates.versus_battle:
	case gamestates.training:
	draw_ground();
	
	//draw_player_outlines();
	draw_chars();
	draw_shots();
	draw_particles();
	draw_superfreeze();
	
	//draw_hitboxes();

	//with(obj_char) {
	//	draw_set_halign(fa_center);
	//	draw_set_valign(fa_top);
	//	draw_set_color(c_white);
	//	draw_text(x,y,string(dead));
	//}
	break;
	
	case gamestates.story_results:
	case gamestates.arcade_results:
	case gamestates.versus_results:
	draw_chars();
	draw_shots();
	draw_particles();
	break;
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);

with(obj_char) {
	draw_text(x,y,string(can_cancel));
	draw_text(x,y+16,input_buffer);
}