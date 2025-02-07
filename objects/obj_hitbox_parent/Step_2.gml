if round_state == roundstates.pause exit;
if !instance_exists(owner) {
	instance_destroy();
	exit;
}

var _xscale = owner.xscale * owner.xstretch * owner.facing;
var _yscale = owner.yscale * owner.ystretch;
var _rotation = owner.rotation * owner.facing;

x = owner.x;
y = owner.y;

var _xoffset = xoffset * _xscale;
var _yoffset = yoffset * _yscale;

x += lengthdir_x(_xoffset, _rotation) + lengthdir_x(_yoffset, _rotation - 90);
y += lengthdir_y(_xoffset, _rotation) + lengthdir_y(_yoffset, _rotation - 90);

image_xscale = width * _xscale / sprite_get_width(sprite_index);
image_yscale = height * _yscale / sprite_get_height(sprite_index);

image_angle = _rotation;
