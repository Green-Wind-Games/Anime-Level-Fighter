// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function init_sprite(_sprite = sprite_index) {
	sprite = _sprite;
	
	previous_sprite = -1;
	previous_sprite_frame_duration = -1;
	previous_sprite_loop_count = 0;
	
	next_sprite = -1;
	next_sprite_frame_duration = -1;
	next_sprite_anim_loop = false;
	
	frame = 0;
	frame_timer = 0;
	frame_duration = 5;
	
	anim_frames = sprite_get_number(sprite);
	
	anim_timer = 0;
	
	anim_loop = true;
	anim_loop_count = 0;
	
	anim_finished = false;
	
	anim_duration = anim_frames * frame_duration;
	anim_progress = map_value(
		anim_timer,
		0,
		anim_duration - 1,
		0,
		1
	);
	
	xoffset = 0;
	yoffset = 0;
	
	facing = 1;
	
	xscale = 1;
	yscale = 1;
	xstretch = 1;
	ystretch = 1;
	
	rotation = 0;
	rotation_speed = 0;
	
	color = c_white;
	
	alpha = 1;
	
	flash = 0;
	flash_color = c_white;
	
	var _scale = 0.9;
	width = floor(sprite_get_width(sprite) * _scale);
	height = floor(sprite_get_height(sprite) * _scale);
	
	width_half = floor(width/2);
	height_half = floor(height/2);
	
	change_sprite(_sprite,5,true);
	reset_sprite();
}

function change_sprite(_sprite,_frameduration, _loop) {
	if sprite != _sprite {
		previous_sprite_frame_duration = frame_duration;
		previous_sprite_loop_count = anim_loop_count;
		previous_sprite = sprite;
		
		if _sprite == next_sprite {
			_loop = next_sprite_anim_loop;
			_frameduration = next_sprite_frame_duration;
		}
		
		sprite = _sprite;
		
		next_sprite = -1;
		
		frame = -1;
		frame_timer = 0;
		anim_finished = false;
		
		reset_sprite(true,true);
	}
	if !_loop {
		frame = 0;
		frame_timer = 0;
	}
	frame_duration = max(_frameduration,2);
	anim_loop = _loop;
	
	anim_frames = sprite_get_number(sprite);
	
	anim_timer = frame_timer + (frame * frame_duration);
	anim_duration = anim_frames * frame_duration;
	anim_progress = map_value(anim_timer,0,anim_duration-1,0,1);
}

function reset_sprite(_keep_color = false, _keep_alpha = false) {
	xoffset = 0;
	yoffset = 0;
	xscale = 1;
	yscale = 1;
	rotation = 0;
	rotation_speed = 0;
	if !_keep_color {
		color = c_white;
	}
	if !_keep_alpha {
		alpha = 1;
	}
}

function update_sprite() {
	update_sprite_animation();
	update_sprite_flash();
	update_sprite_rotation();
	update_sprite_squash_stretch();
}

function update_sprite_animation() {
	frame_timer++;
	if frame_timer >= frame_duration {
		frame += 1;
		frame_timer = 0;
		if frame >= anim_frames {
			if anim_loop {
				frame = 0;
			}
			else {
				if next_sprite == -1 {
					frame = anim_frames - 1;
					frame_timer = frame_duration - 1;
				}
				else {
				}
			}
			anim_finished = true;
		}
	}
	anim_timer = frame_timer + (frame * frame_duration);
	anim_progress = map_value(anim_timer,0,anim_duration-1,0,1);
}

function flash_sprite(_duration = 6,_color = c_white) {
	flash = _duration;
	flash_color = _color;
}

function squash_stretch(_x,_y) {
	xstretch = _x;
	ystretch = _y;
}

function update_sprite_flash() {
	flash--;
}

function update_sprite_squash_stretch() {
	xstretch = approach(xstretch,1,1/30);
	ystretch = approach(ystretch,1,1/30);
}

function update_sprite_rotation() {
	rotation += rotation_speed;
	if rotation >= 360 {
		rotation -= 360;
	}
	if rotation < 0 {
		rotation += 360;
	}
}