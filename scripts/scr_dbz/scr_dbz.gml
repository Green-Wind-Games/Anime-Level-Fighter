// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function create_kiblast(_sprite = spr_kiblast_blue,_damage = 10) {
	with(create_shot(width*1.75,-height*0.70,20,random_range(-2,2),_sprite,_damage,attacktype.light,hiteffects.fire)) {
		blend = true;
		hit_script = function() {
			create_particles(x,y,x,y,explosion_small);
		}
	}
	play_sound(snd_kiblast_fire);
}