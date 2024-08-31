if ((superfreeze_active) and (superfreeze_activator != id)) exit;
if ((timestop_active) and (timestop_activator != id)) exit;

target = target_front_enemy();
if !target_exists() {
	target = target_closest_enemy();
}
if target_exists() {
	target_x = target.x;
	target_y = target.y;
	target_distance_x = max(abs(x-target_x) - (width_half+target.width_half),0);
	target_distance_y = abs(target_y - y);
	target_distance = abs(target_distance_x) + abs(target_distance_y);
	target_direction = point_direction(x,y-height_half,target_x,target_y-target.height_half);
}