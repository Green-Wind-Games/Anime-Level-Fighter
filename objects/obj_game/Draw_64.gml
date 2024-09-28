/// @description Insert description here
// You can write your code in this editor

//draw_text(0,0,"X " + string(camera_get_view_x(view)) + " / Y " + string(camera_get_view_y(view)));

var _w = gui_width;
var _h = gui_height;

switch(game_state) {
	case gamestates.story_select:
	case gamestates.versus_select:
	case gamestates.training_select:
	draw_charselect();
	break;
	
	case gamestates.versus_intro:
	draw_versus();
	break;
	
	case gamestates.story_battle:
	case gamestates.versus_battle:
	case gamestates.training:
	draw_hud();
	if round_state == roundstates.pause {
		draw_pause();
	}
	else if round_state == roundstates.countdown {
		draw_countdown();
	}
	else if round_state == roundstates.knockout {
		draw_knockout();
	}
	else if round_state == roundstates.time_over {
		draw_timeover();
	}
	break;
	
	case gamestates.versus_results:
	draw_versus_results();
	break;
}

draw_menu();

draw_screenfade();

draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);