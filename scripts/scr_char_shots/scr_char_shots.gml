function create_shot(_x,_y,_xspeed,_yspeed,_sprite,_scale,_damage,_xknockback,_yknockback,_attacktype,_strength,_hiteffect) {
	var _me = id;
	var _shot = instance_create(x+(_x*facing),y+_y,obj_shot);
	with(_shot) {
		owner = get_true_owner(_me);
		init_sprite(_sprite);
		change_sprite(sprite,max(1,round(60/sprite_get_speed(_sprite))),true);
		var _true_scale = _scale / 2;
		xscale = _scale;
		yscale = _scale;
		width = sprite_get_width(sprite) * _true_scale;
		height = sprite_get_height(sprite) * _true_scale;
		width_half = floor(width / 2);
		height_half = floor(height / 2);
		
		var _xoffset = -sprite_get_xoffset(sprite) * _true_scale;
		var _yoffset = -sprite_get_yoffset(sprite) * _true_scale;
		
		hitbox = create_hitbox(
			_xoffset,
			_yoffset,
			width,
			height,
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
		facing = owner.facing;
		target = owner.target;
		
		homing_speed = max(abs(xspeed),abs(yspeed));
		
		rotation = point_direction(0,0,xspeed,yspeed);

		if xspeed > 0 {
			facing = 1;
		}
		else if xspeed < 0 {
			facing = -1;
		}
	}
	return _shot;
}



function fire_beam(_x,_y,_sprite,_scale,_angle,_damage) {
	var _xlength = lengthdir_x(1,_angle);
	var _ylength = lengthdir_y(1,_angle);
	if !instance_exists(beam) {
		beam = create_shot(
			_x,
			_y,
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
				xoffset = 0;
				
				var hitbox_scale = 1/3;
				
				image_yscale = (sprite_get_height(other.sprite) / sprite_get_height(spr_hitbox));
				image_yscale *= hitbox_scale * _scale;
				yoffset = -(image_yscale * sprite_get_height(spr_hitbox)) / 2;
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
		alpha = 1;
		duration = 12;
		
		xspeed = _xlength * other.facing;
		yspeed = _ylength;
		
		ygravity_mod = false;
		
		x = owner.x + (_x * other.facing);
		y = owner.y + _y;
		
		//x += lengthdir_x(sprite_get_xoffset(sprite)*xscale,_angle) * facing;
		//y += lengthdir_y(sprite_get_xoffset(sprite)*xscale,_angle);
		
		with(hitbox) {
			xknockback = _xlength * 8;
			yknockback = _ylength * 8;
			if yknockback == 0 then yknockback -= 0.1;
		}
	}
}