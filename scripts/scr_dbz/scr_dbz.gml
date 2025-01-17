function add_kiblast_state(_maxrepeats,_sprite1,_sprite2,_fireframe,_kiblastsprite) {
	max_kiblasts = _maxrepeats;
	kiblast_count = 0;
	
	kiblast_sprite = _sprite1;
	kiblast_sprite2 = _sprite2;
	kiblast_shot_sprite = _kiblastsprite;
	
	kiblast_fire_frame = _fireframe;
	
	kiblast = new charstate();
	kiblast.start = function() {
		if attempt_special(1/max_kiblasts) {
			change_sprite(
				sprite == kiblast_sprite2 ? kiblast_sprite : kiblast_sprite2,
				2,
				false
			);
		}
		else {
			change_state(idle_state);
		}
	}
	kiblast.run = function() {
		if check_frame(kiblast_fire_frame) {
			var _x = sprite_get_bbox_right(sprite) - sprite_get_xoffset(sprite);
			var _y = sprite_get_bbox_top(sprite) - sprite_get_yoffset(sprite);
			create_kiblast(_x,_y,kiblast_shot_sprite);
			if is_airborne {
				xspeed = -2 * facing;
				yspeed = -2;
			}
			kiblast_count += 1;
		}
		if frame > 3 {
			add_cancel(kiblast);
			can_cancel = (kiblast_count < max_kiblasts) and (check_mp(1/max_kiblasts));
		}
		if state_timer >= 50 {
			change_state(idle_state);
		}
	}
	kiblast.stop = function() {
		if next_state != kiblast {
			kiblast_count = 0;
		}
	}
}

function add_kamehameha_state(_groundsprite,_airsprite,_chargeframe1,_chargeframe2,_fireframe1,_fireframe2,_voiceline) {
	kamehameha_ground_sprite = _groundsprite;
	kamehameha_air_sprite = _airsprite;
	
	kamehameha_charge_frame1 = _chargeframe1;
	kamehameha_charge_frame2 = _chargeframe2;
	
	kamehameha_fire_frame1 = _fireframe1;
	kamehameha_fire_frame2 = _fireframe2;
	
	voice_kamehameha = _voiceline;
	
	kamehameha = new charstate();
	kamehameha.start = function() {
		if attempt_special(1) {
			change_sprite(
				on_ground ? kamehameha_ground_sprite : kamehameha_air_sprite,
				3,
				false
			);
			xspeed = 0;
			yspeed = 0;
			kamehameha_cooldown = kamehameha_cooldown_duration;
			play_voiceline(voice_kamehameha);
			play_sound(snd_dbz_beam_charge_short);
		}
		else {
			change_state(idle_state);
		}
	}
	kamehameha.run = function() {
		xspeed = 0;
		yspeed = 0;
		if check_frame(kamehameha_fire_frame1) {
			play_sound(snd_dbz_beam_fire);
		}
		if value_in_range(attack_hits,1,30) {
			loop_anim_middle(kamehameha_fire_frame1,kamehameha_fire_frame2);
		}
		if value_in_range(frame,kamehameha_fire_frame1,kamehameha_fire_frame2) {
			fire_beam(width*0.6,-height_half,spr_kamehameha,1,0,50);
		}
		return_to_idle();
	}
}

function add_superkamehameha_state(_groundsprite,_airsprite,_chargeframe1,_chargeframe2,_fireframe1,_fireframe2,_voice_charge,_voice_fire) {
	kamehameha_ground_sprite = _groundsprite;
	kamehameha_air_sprite = _airsprite;
	
	kamehameha_charge_frame1 = _chargeframe1;
	kamehameha_charge_frame2 = _chargeframe2;
	
	kamehameha_fire_frame1 = _fireframe1;
	kamehameha_fire_frame2 = _fireframe2;
	
	voice_superkamehameha_charge = _voice_charge;
	voice_superkamehameha_fire = _voice_fire;
	
	kamehameha_cooldown = 0;
	kamehameha_cooldown_duration = 100;
	
	super_kamehameha = new charstate();
	super_kamehameha.start = function() {
		if attempt_super(2,(kamehameha_cooldown <= 0)) {
			change_sprite(
				on_ground ? kamehameha_ground_sprite : kamehameha_air_sprite,
				3,
				false
			);
			xspeed = 0;
			yspeed = 0;
			kamehameha_cooldown = kamehameha_cooldown_duration * 1.5;
			activate_super(60);
			play_voiceline(voice_superkamehameha_charge);
			play_sound(snd_energy_start);
			play_sound(snd_dbz_beam_charge_short,1.5,0.8);
		}
		else {
			change_state(idle_state);
		}
	}
	super_kamehameha.run = function() {
		xspeed = 0;
		yspeed = 0;
		if superfreeze_active {
			loop_anim_middle(4,5);
			if superfreeze_timer == 15 {
				if (input.forward) and check_tp(1) {
					spend_tp(1);
					play_sound(snd_dbz_teleport_long);
					teleport(target_x + ((width + target.width) * facing), target_y);
					face_target();
				
					var _frame = frame;
					change_sprite(
						on_ground ? kamehameha_ground_sprite : kamehameha_air_sprite,
						3,
						false
					);
					frame = _frame;
				}
			}
		}
		if check_frame(kamehameha_fire_frame1) {
			play_sound(snd_dbz_beam_fire);
			play_voiceline(voice_superkamehameha_fire);
		}
		loop_anim_middle_timer(kamehameha_fire_frame1,kamehameha_fire_frame2,100);
		if value_in_range(frame,kamehameha_fire_frame1,kamehameha_fire_frame2) {
			fire_beam(width*0.6,-height_half,spr_kamehameha,1,0,50);
			shake_screen(5);
		}
		return_to_idle();
	}
}

function create_kiblast(_x,_y,_sprite) {
	with(create_shot(
		_x,
		_y,
		20,
		sine_wave(kiblast_count,max_kiblasts/2,2,0),
		_sprite,
		32 / sprite_get_height(_sprite),
		100,
		3,
		-3,
		attacktype.normal,
		attackstrength.light,
		hiteffects.fire
	)) {
		blend = true;
		hit_script = function() {
			create_particles(x,y,explosion_small_particle);
		}
		active_script = function() {
			if y >= ground_height {
				hit_script();
				instance_destroy();
			}
		}
		play_sound(snd_kiblast_fire);
		return id;
	}
}

function ssj2_sparks() {
	var _scale = random_range(0.3,0.8);
	var _spark = create_specialeffect(
		spr_electric_spark,
		random(width*0.25) * choose(1,-1),
		random_range(height*0.25,height*0.75) * -1,
		choose(_scale,-_scale),
		choose(_scale,-_scale),
		random(360),
	);
	with(_spark) {
		play_sound(
			snd_electric_spark,
			random_range(1,0.5),
			random_range(0.8,1.2)
		);
	}
}