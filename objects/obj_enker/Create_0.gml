/// @description Insert description here
// You can write your code in this editor

event_inherited();

init_charsprites("enker");
weapon_sprite = spr_sword_green;

badugi_cooldown_timer = 0;
badugi_cooldown = 2*60;

char_script = function() {
	badugi_cooldown_timer--;
}

theme = mus_dbfz_trunks;

ground_a = new state();
ground_a.start = function() {
	if on_ground {
		change_sprite(thrust_sprite,4,false);
		weapon_enabled = false;
	
		add_cancel(ground_a2);
		add_cancel(ground_b);
	
		play_sound(snd_punch_whiff_light);
		play_voiceline(voice_attack,50,false);
	}
	else {
		change_state(air_a);
	}
}
ground_a.run = function() {
	if check_frame(1) {
		create_hitbox(width_half,-height_half,width_half/2,height/5,10,3,0,attacktype.light,hiteffects.punch);
	}
	if anim_finished {
		change_state(idle_state);
	}
	check_moves();
}

ground_a2 = new state();
ground_a2.start = function() {
	change_sprite(thrust_sprite,8,false);
	weapon_enabled = false;
	
	add_cancel(ground_a3);
	add_cancel(ground_b);
	
	xspeed = 3 * facing;

	play_sound(snd_punch_whiff_light2);
	play_voiceline(voice_attack,50,false);
}
ground_a2.run = function() {
	if check_frame(1) {
		create_hitbox(width_half,-height_half,width_half/2,height/5,20,3,0,attacktype.light,hiteffects.punch);
	}
	if anim_finished {
		change_state(idle_state);
	}
	check_moves();
}

ground_a3 = new state();
ground_a3.start = function() {
	change_sprite(spr_enker_uppercut,8,false);
	weapon_enabled = false;
	
	add_cancel(air_a);
	add_cancel(air_b);
	
	xspeed = 3 * facing;
	
	play_sound(snd_punch_whiff_light);
	play_voiceline(voice_heavyattack,50,false);
}
ground_a3.run = function() {
	if check_frame(1) {
		create_hitbox(width_half,-height,width_half/2,height,20,7,-7,attacktype.medium,hiteffects.punch);
	}
	if anim_finished {
		change_state(idle_state);
	}
	if check_moves() {
		xspeed = 8 * facing;
		yspeed = -8;
	}
}

ground_b = new state();
ground_b.start = function() {
	if on_ground {
		change_sprite(swing_sprite,8,false);
		weapon_enabled = true;
	
		add_cancel(ground_a3);
		add_cancel(ground_b2);

		play_sound(snd_slash_whiff_medium);
		play_voiceline(voice_attack,50,false);
	}
	else {
		change_state(air_b);
	}
}
ground_b.run = function() {
	if check_frame(1) {
		create_hitbox(width_half,-height,width,height*0.75,30,5,0,attacktype.light,hiteffects.slash);
	}
	if anim_finished {
		change_state(idle_state);
	}
	if check_moves() {
		xspeed = 8 * facing;
	}
}

ground_b2 = new state();
ground_b2.start = function() {
	change_sprite(swing_sprite,8,false);
	weapon_enabled = true;
	
	add_cancel(ground_a3);
	
	xspeed = 3 * facing;
	
	play_sound(snd_slash_whiff_medium);
	play_voiceline(voice_attack,50,false);
}
ground_b2.run = function() {
	if check_frame(1) {
		create_hitbox(width_half,-height,width,height*0.75,40,5,0,attacktype.light,hiteffects.slash);
	}
	if anim_finished {
		change_state(idle_state);
	}
	if check_moves() {
		xspeed = 8 * facing;
	}
}

air_a = new state();
air_a.start = function() {
	change_sprite(thrust_sprite,4,false);
	weapon_enabled = false;
	
	add_cancel(air_a2);
	add_cancel(air_b);
	
	play_sound(snd_punch_whiff_light2);
	play_voiceline(voice_attack,50,false);
}
air_a.run = function() {
	if check_frame(1) {
		create_hitbox(width_half,-height_half,width_half/2,height/5,30,4,-4,attacktype.light,hiteffects.punch);
	}
	if anim_finished {
		change_state(idle_state);
	}
	land();
	
	if ai_enabled {
		ai_input_move(choose(ground_a,ground_b),100);
	}
	check_moves();
}

air_a2 = new state();
air_a2.start = function() {
	change_sprite(thrust_sprite,8,false);
	weapon_enabled = false;
	rotation = -45;
	xspeed = 5 * facing;
	yspeed = -5;
	play_sound(snd_punch_whiff_heavy);
	play_voiceline(voice_heavyattack,50,false);
}
air_a2.run = function() {
	if check_frame(1) {
		xspeed *= -0.5;
		create_hitbox(width_half,-height_half,width_half/2,height,100,5,10,attacktype.smash,hiteffects.punch);
	}
	land();
}

air_b = new state();
air_b.start = function() {
	change_sprite(swing_sprite,8,false);
	weapon_enabled = true;
	
	add_cancel(air_a2);
	add_cancel(air_b2);
	
	play_sound(snd_slash_whiff_medium);
	play_voiceline(voice_attack,50,false);
}
air_b.run = function() {
	if check_frame(1) {
		create_hitbox(width_half,-height,width,height*0.75,40,5,0,attacktype.light,hiteffects.slash);
	}
	if anim_finished {
		change_state(idle_state);
	}
	land();
	check_moves();
}

air_b2 = new state();
air_b2.start = function() {
	change_sprite(swing_sprite,8,false);
	weapon_enabled = true;
	
	add_cancel(air_a2);
	
	play_sound(snd_slash_whiff_medium);
	play_voiceline(voice_attack,50,false);
}
air_b2.run = function() {
	if check_frame(1) {
		create_hitbox(width_half,-height,width,height*0.75,50,5,0,attacktype.light,hiteffects.slash);
	}
	if anim_finished {
		change_state(idle_state);
	}
	land();
	check_moves();
}

badugi = new state();
badugi.start = function() {
	if !badugi_cooldown_timer {
		change_sprite(cast_sprite,5,false);	
		badugi_cooldown_timer = badugi_cooldown;
		play_voiceline(snd_enker_badugi);
	}
	else {
		change_state(previous_state);
	}
}
badugi.run = function() {
	if check_frame(1) {
		if is_airborne {
			xspeed = -5 * facing;
			yspeed = -3;
		}
		with(create_shot(width,-height_half,10,0,spr_badugi,0.25,50,9,0,attacktype.medium,hiteffects.wind)) {
			blend = true;
			play_sound(snd_kiblast_fire,1,0.9);
			hit_script = function(_hit) {
				x = _hit.x;
				with(create_shot(0,0,0,-0.2,spr_greenwind,1,20,3,-9,attacktype.light,hiteffects.slash)) {
					hit_limit = 10;
					hit_timer = 0;
					duration = anim_duration;
					active_script = function() {
						if hit_timer-- <= 0 {
							ds_list_clear(hitbox.hit_list);
							hit_timer = 2;
						}
					}
				}
			}
		}
	}
	if state_timer > 45 {
		change_state(idle_state);
	}
}

amektugen = new state();
amektugen.start = function() {
	if check_mp(1) {
		change_sprite(thrust_sprite,2,true);
		weapon_enabled = false;
		spend_mp(1);
		superfreeze();
		play_sound(snd_activate_super);
	}
	else {
		change_state(previous_state);
	}
}
amektugen.run = function() {
	yspeed = 0;
	if superfreeze_active {
		frame = 0;
		frame_timer = 0;
	}
	else {
		if state_timer == 2 {
			play_voiceline(snd_enker_punchrush,100,true);
		}
		xspeed = 1 * facing;
		if check_frame(1) {
			repeat(1) {
				var _punch = create_shot(
					random(width_half),
					-random(height),
					8,
					0,
					spr_glove_green,
					1,
					20,
					1,
					0,
					attacktype.light,
					hiteffects.punch
				);
				with(_punch) {
					blend = false;
					hit_limit = 5;
					duration = 5;
				}
			}
		}
	}
	if state_timer > 150 {
		change_state(amektugen_finish);
	}
}
amektugen.stop = function() {
	deactivate_super();
}
amektugen_finish = new state();
amektugen_finish.start = function() {
	change_sprite(thrust_sprite,5,false);
	superfreeze(0);
	weapon_enabled = false;
	rotation = -45;
	xspeed = 5 * facing;
	yspeed = -5;
	play_sound(snd_punch_whiff_heavy);
	play_voiceline(voice_heavyattack,100,true);
}
amektugen_finish.run = function() {
	if check_frame(1) {
		xspeed = -2 * facing;
		yspeed = -5;
		create_hitbox(width_half,-height_half,width_half/2,height,100,30,-3,attacktype.wall_bounce,hiteffects.punch);
	}
	land();
}
amektugen_finish.stop = function() {
	deactivate_super();
}

big_swing = new state();
big_swing.start = function() {
	change_sprite(shoot_sprite,5,true);
	weapon_enabled = false;
	with(grabbed) {
		change_sprite(grabbed_sprite,100,false);
		yoffset = -height_half;
	}
}
big_swing.run = function() {
	xspeed = 0;
	yspeed = 0;
	var spin_angle = (state_timer * 2) mod 360;
	var spin_angle2 = point_direction(0,0,lengthdir_x(2,spin_angle),lengthdir_x(1,spin_angle));
	if value_in_range(spin_angle,90,270) {
		xscale = -1;
	}
	else {
		xscale = 1;
	}
	grab_frame(0,0,0,spin_angle2,spin_angle < 180);
	if state_timer > 120 and value_in_range(spin_angle,90,180) {
		release_grab(0,1,0,-10,-5,50,attacktype.hard_knockdown,hiteffects.wind,hitanims.spinout);
		change_state(idle_state);
	}
}

add_move(ground_a,"A");
add_move(ground_a2,"A");
add_move(ground_a3,"A");
add_move(ground_b,"B");
add_move(ground_b2,"B");

add_move(air_a,"A");
add_move(air_a2,"A");
add_move(air_b,"B");
add_move(air_b2,"B");

add_move(badugi,"C");
add_move(badugi,"236A");
add_move(badugi,"236B");

add_move(amektugen,"D");
add_move(amektugen,"214A");
add_move(amektugen,"214B");

var i = 0;
voice_attack[i++] = snd_enker_attack1;
voice_attack[i++] = snd_enker_attack2;
voice_attack[i++] = snd_enker_attack3;
i = 0;
voice_heavyattack[i++] = snd_enker_attack4;
voice_heavyattack[i++] = snd_enker_attack5;
voice_heavyattack[i++] = snd_enker_attack6;
i = 0;
voice_hurt[i++] = snd_enker_hurt1;
voice_hurt[i++] = snd_enker_hurt2;
voice_hurt[i++] = snd_enker_hurt3;
i = 0;
voice_hurt_heavy[i++] = snd_enker_hurt4;
voice_hurt_heavy[i++] = snd_enker_hurt5;
voice_hurt_heavy[i++] = snd_enker_hurt6;
i = 0;
voice_dead[i++] = snd_enker_hurt4;
voice_dead[i++] = snd_enker_hurt5;