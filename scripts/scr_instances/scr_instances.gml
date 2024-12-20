// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function instance_create(_x,_y,obj) {
	return instance_create_depth(_x,_y,0,obj);
}

function is_char(_obj) {
	with(_obj) {
		return object_is_ancestor(object_index,obj_char) and (!is_helper(id));
	}
}

function is_helper(_obj) {
	with(_obj) {
		return object_index == obj_helper or object_is_ancestor(object_index,obj_helper);
	}
}

function is_shot(_obj) {
	with(_obj) {
		return (object_index == obj_shot) or object_is_ancestor(object_index,obj_shot);
	}
}

function is_beam(_obj) {
	with(_obj) {
		return is_shot(_obj) and (_obj == owner.beam);
	}
}