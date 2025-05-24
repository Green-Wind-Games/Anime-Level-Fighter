/// @description Insert description here
// You can write your code in this editor

draw_ground();
draw_chars();
draw_shots();
draw_superfreeze();
draw_particles();
//draw_hitboxes();

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);

//with(obj_char) {
//	//draw_text(x,y,string(anim_speed));
//	draw_text(x,y,string(frame_timer));
//	draw_text(x,y+16,string(frame_duration / anim_speed));
//}

//with(obj_specialeffect) {
//	draw_text(x,y+20,string(frame_duration));
//	draw_text(x,y+30,string(frame_timer));
//}