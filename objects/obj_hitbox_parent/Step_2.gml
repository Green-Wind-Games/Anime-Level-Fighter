if !instance_exists(owner) {
	instance_destroy();
	exit;
}

facing = owner.facing;
x = owner.x + lengthdir_x(xoffset * facing,image_angle) + lengthdir_y(yoffset, image_angle);
y = owner.y + lengthdir_x(yoffset,image_angle) + lengthdir_y(xoffset * facing, image_angle);
image_xscale = abs(image_xscale) * facing;
image_yscale = abs(image_yscale);