/// @description Insert description here
// You can write your code in this editor

switch(game_state) {
	case gamestates.story_battle:
	case gamestates.arcade_battle:
	case gamestates.versus_battle:
	case gamestates.training:
	draw_ground();
	
	draw_chars();
	draw_shots();
	draw_superfreeze();
	draw_particles();
	
	//draw_hitboxes();
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

//with(obj_char) {
//	draw_text(x,y,string(frame_timer));
//	draw_text(x,y+16,string(frame_duration));
//}

//with(obj_specialeffect) {
//	draw_text(x,y+20,string(frame_duration));
//	draw_text(x,y+30,string(frame_timer));
//}