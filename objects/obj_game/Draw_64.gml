/// @description Insert description here
// You can write your code in this editor

//draw_text(0,0,"X " + string(camera_get_view_x(camera)) + " / Y " + string(camera_get_view_y(camera)));

var _w = gui_width;
var _h = gui_height;

switch(game_state) {
	case gamestates.story_select:
	case gamestates.versus_select:
	case gamestates.training_select:
	draw_charselect();
	break;
	
	case gamestates.story_vs:
	case gamestates.arcade_vs:
	case gamestates.versus_vs:
	draw_versus();
	break;
	
	case gamestates.story_battle:
	case gamestates.arcade_battle:
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

var _fps = game_get_speed(gamespeed_fps);
var _speed = _fps / 60;

if _fps != 60 {
	draw_text(32,32,"Game Speed: x" + string(_speed));
}

//for(var i = 0; i < max_players; i++) {
//	var _x = 32 * (i+1);
//	var _y = 32;
//	draw_text_outlined(_x,_y,string(player_slot[i]),c_black,c_white);
//}