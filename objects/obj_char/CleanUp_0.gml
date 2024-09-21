/// @description Insert description here
// You can write your code in this editor

ds_list_destroy(cancelable_moves);

with(obj_hitbox_parent) {
	if owner == other {
		instance_destroy();
	}
}