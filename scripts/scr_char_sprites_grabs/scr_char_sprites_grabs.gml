enum grab_anchors {
	base,
	head,
	body,
	leg,
	
	allanchors
}

enum grab_anims {
	stun,
	high,
	mid,
	low,
	air,
	fall,
	
	allanims
}

function init_grab_sprites(_name) {
	var _requiredsprites = grab_anchors.allanchors * grab_anims;
	var _foundsprites = 0;
	for(var i = 0; i < grab_anchors.allanchors; i++) {
		for(var ii = 0; ii < grab_anims.allanims; ii++) {
			var _anchor = "";
			var _anim = "";
			
			switch(i) {
				case grab_anchors.base: _anchor = "base"; break;
				case grab_anchors.head: _anchor = "head"; break;
				case grab_anchors.body: _anchor = "body"; break;
				case grab_anchors.leg: _anchor = "leg"; break;
			}
			switch(ii) {
				case grab_anims.stun: _anim = "stun"; break;
				case grab_anims.high: _anim = "high"; break;
				case grab_anims.mid: _anim = "mid"; break;
				case grab_anims.low: _anim = "low"; break;
				case grab_anims.air: _anim = "air"; break;
				case grab_anims.fall: _anim = "fall"; break;
			}
			
			grabbed_sprite[i][ii] = asset_get_index("spr_" + _name + "_grabbed_" + _anchor + "_" + _anim);
			
			if sprite_exists(grabbed_sprite[i][ii]) {
				_foundsprites++;
			}
			else {
				show_debug_message(_name + " is missing the " + _anchor + " " + _anim + " grab sprite");
			}
		}
	}
	show_debug_message("required grab sprites = " + string(_requiredsprites));
	show_debug_message("found grab sprites (" + _name + ") = " + string(_foundsprites));
	if _foundsprites < _requiredsprites {
		show_debug_message(_name + " is missing " + string(_requiredsprites - _foundsprites) + " grabsprites");
	}
}