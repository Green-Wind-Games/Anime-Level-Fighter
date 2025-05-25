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

with(obj_char) {
	draw_text(x,y,input_buffer);
	draw_text(x,y+16,input_buffer_timer);
}

//with(obj_specialeffect) {
//	draw_text(x,y+20,string(frame_duration));
//	draw_text(x,y+30,string(frame_timer));
//}