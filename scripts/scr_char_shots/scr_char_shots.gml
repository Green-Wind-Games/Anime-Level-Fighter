function create_shot(_x,_y,_xspeed,_yspeed,_sprite,_scale,_damage,_xknockback,_yknockback,_attacktype,_strength,_hiteffect) {
	var _me = id;
	var _shot = instance_create(x+(_x*facing),y+(_y),obj_shot);
	with(_shot) {
		owner = get_true_owner(_me);
		init_sprite(_sprite);
		change_sprite(sprite,true);
		var _true_scale = 0.5;
		xscale = _scale;
		yscale = _scale;
		width = sprite_get_width(sprite) * _true_scale * _scale;
		height = sprite_get_height(sprite) * _true_scale * _scale;
		width_half = floor(width / 2);
		height_half = floor(height / 2);
		
		var _width = sprite_get_width(sprite) * _true_scale;
		var _height = sprite_get_height(sprite) * _true_scale;
		var _xoffset = ((sprite_get_width(sprite) - _width) / 2) - sprite_get_xoffset(sprite);
		var _yoffset = ((sprite_get_height(sprite) - _height) / 2) - sprite_get_yoffset(sprite);
		
		hitbox = create_hitbox(
			_xoffset,
			_yoffset,
			_width,
			_height,
			_damage,
			_xknockback,
			_yknockback,
			_attacktype,
			_strength,
			_hiteffect
		);
		hitbox.duration = -1;
		attack_power = owner.attack_power;
		
		xspeed = _xspeed * owner.facing;
		yspeed = _yspeed;
		team = owner.team;
		target = owner.target;
		
		homing_speed = max(abs(xspeed),abs(yspeed));
		
		rotation = point_direction(0,0,abs(xspeed),yspeed);

		if xspeed != 0 {
			facing = sign(xspeed);
		}
		else {
			facing = owner.facing;
		}
	}
	return _shot;
}

function fire_beam(_sprite,_scale,_angle,_damage) {
	var _xlength = lengthdir_x(1,_angle);
	var _ylength = lengthdir_y(1,_angle);
	if !instance_exists(beam) {
		beam = create_shot(
			width_half,
			height_half,
			_xlength,
			_ylength,
			_sprite,
			_scale,
			_damage,
			_xlength * 9,
			_ylength * 9,
			attacktype.hard_knockdown,
			attackstrength.light,
			hiteffects.none
		);
		with(beam) {
			rotation = _angle;
			blend = true;
			hit_limit = -1;
			duration = 10;
			xscale = 100 / sprite_get_width(sprite);
			with(hitbox) {
				width = sprite_get_width(owner.sprite);
				height = sprite_get_height(owner.sprite) / 2;
				xoffset = 0;
				yoffset = -height / 2;
			}
			active_script = function() {
				xscale += 50 / sprite_get_width(sprite);
				alpha = duration / 10;
				with(hitbox) {
					image_angle = point_direction(0,0,abs(other.xspeed),other.yspeed);
					image_xscale = ((sprite_get_width(other.sprite) * other.xscale) / sprite_get_width(spr_hitbox)) * other.facing;
				}
			}
			hit_script = function(_hit) {
				if is_beam(_hit) {
					var _x = mean(x, _hit.x);
					var _y = mean(y, _hit.y);
					if height >= _hit.height {
						xscale = point_distance(x,y,_x,_y) / sprite_get_width(sprite);
					}
					if _hit.height >= height {
						with(_hit) {
							xscale = point_distance(x,y,_x,_y) / sprite_get_width(sprite);
						}
					}
				}
				else if is_char(_hit) or is_helper(_hit) {
					with(_hit) {
						hitstop = 1;
						x = clamp(x+other.xspeed,left_wall,right_wall);
						y = min(y+other.yspeed,ground_height);
					}
				}
			}
		}
	}
	with(beam) {
		ds_list_clear(hitbox.hit_list);
		rotation = _angle;
		alpha = 1;
		duration = 12;
		
		xspeed = _xlength * other.facing;
		yspeed = _ylength;
		
		ygravity_mod = false;
		
		x = owner.x;
		y = owner.y;
		y -= owner.height_half * owner.yscale * owner.ystretch;
		
		var _xoffset = sprite_get_width(owner.sprite) - sprite_get_xoffset(owner.sprite) - 5;
		var _yoffset = 0;
		
		_xoffset *= owner.xscale * owner.xstretch * owner.facing;
		_yoffset *= owner.yscale * owner.ystretch;
		
		x += lengthdir_x(_xoffset, _angle) + lengthdir_x(_yoffset, _angle - 90);	
		y += lengthdir_y(_xoffset, _angle) + lengthdir_y(_yoffset, _angle - 90);
		
		with(hitbox) {
			xknockback = _xlength * 8;
			yknockback = _ylength * 8;
			if yknockback == 0 then yknockback -= 0.01;
		}
	}
}