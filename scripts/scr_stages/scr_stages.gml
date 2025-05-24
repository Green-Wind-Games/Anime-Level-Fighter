globalvar	stage,
			stage_width, stage_height,
			ground_height,
			battle_x, battle_y, left_wall, right_wall,
			stage_transition_top, stage_transition_wall, stage_transition_floor;

left_wall = 0;
right_wall = room_width;
ground_height = room_height;
battle_x = room_width / 2;
battle_y = ground_height;
ground_sprite = noone;

for(var i = 0; i <= room_last; i++) {
	var _stage_size = game_width * 1.25;
	var _stage_width = round(_stage_size);
	var _stage_height = round(_stage_size / (16/9));
	var _menu_size = game_width;
	var _menu_width = round(_menu_size);
	var _menu_height = round(_menu_size);
	if i >= rm_training {
		room_set_width(i,_stage_width);
		room_set_height(i,_stage_height);
	}
	else if i != rm_start {
		room_set_width(i,_menu_width);
		room_set_height(i,_menu_height);
	}
}