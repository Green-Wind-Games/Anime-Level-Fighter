if round_state == roundstates.pause exit;
if !instance_exists(owner) {
	instance_destroy();
	exit;
}

facing = owner.facing;

var _xoffset = lengthdir_x(xoffset * facing,image_angle) + lengthdir_y(yoffset, image_angle);
var _yoffset = lengthdir_x(yoffset,image_angle) + lengthdir_y(xoffset * facing, image_angle);
var _width = width * facing;
var _height = height;

_xoffset *= owner.xscale;
_yoffset *= owner.yscale;
_width *= owner.xscale;
_height *= owner.yscale;

x = owner.x + _xoffset;
y = owner.y + _yoffset;
image_xscale = _width / sprite_get_width(sprite_index);
image_yscale = _height / sprite_get_height(sprite_index);