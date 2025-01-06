if facing == 0 {
	facing = 1;
}

if round_state == roundstates.pause exit;

switch(sprite) {
	case idle_sprite:
	case crouch_sprite:
	case uncrouch_sprite:
	if anim_frames == 1 {
		xstretch += sine_wave(state_timer,100,0.02,0);
		ystretch -= sine_wave(state_timer,100,0.02,0);
	}
	if sprite_get_yoffset(sprite) > sprite_get_height(sprite) {
		yoffset = sine_wave(state_timer,100,2,0);
	}
	break;
	
	case walk_sprite:
	case dash_sprite:
	if sprite_get_yoffset(sprite) > sprite_get_height(sprite) {
		yoffset = sine_wave(state_timer,60,2,0);
	}
	break;
	
	case air_up_sprite:
	case air_peak_sprite:
	case air_down_sprite:
	var _stretch = clamp(max(ygravity,abs(yspeed)) / 200,0,0.2);
	xstretch = 1 - _stretch;
	ystretch = 1 + _stretch;
	break;
	
	case launch_sprite:
	yoffset = -height_half;
	rotation = point_direction(0,0,abs(xspeed),-yspeed);
	break;
	
	case spinout_sprite:
	yoffset = -height_half;
	rotation = point_direction(0,0,abs(xspeed),-yspeed);
	if anim_timer mod 15 == 1 {
		char_specialeffect(
			spr_wind_spin,
			x,
			y-height_half,
			1/4,
			1/4,
			point_direction(0,0,xspeed,yspeed)
		);
	}
	break;
}

if sprite_exists(aura_sprite) {
	aura_frame += sprite_get_speed(aura_sprite) / 60;
	if aura_frame >= sprite_get_number(aura_sprite) {
		aura_frame = 0;
	}
}

switch(active_state) {
	default:
	if (active_state == idle_state)
	or ((is_hit) or (is_guarding)) {
		deactivate_super();
	}
	break;
	
	case special_state:
	special_active = true;
	break;
	
	case super_state:
	super_active = true;
	break;
	
	case ultimate_state:
	ultimate_active = true;
	break;
}

if hitstop < 0 then hitstop = 0;

if (!hitstop) and (!timestop_active) and (!superfreeze_active) {
	tp += game_speed * 1;
	combo_timer -= game_speed;
	if combo_timer <= 0 {
		reset_combo();
	}
}

if level >= max_level {
	 xp = 0;
}

hp = clamp(round(hp),0,max_hp);
mp = clamp(round(mp),0,max_mp);
tp = clamp(round(tp),0,max_tp);
xp = clamp(round(xp),0,max_xp);
		
mp_stocks = floor(mp/mp_stock_size);
tp_stocks = floor(tp/tp_stock_size);
		
dead = hp <= 0;
		
hp_percent = (hp/max_hp)*100;
mp_percent = (mp/max_mp)*100;
tp_percent = (tp/max_tp)*100;
xp_percent = (xp/max_xp)*100;
dmg_percent = (combo_damage_taken / max_hp) * 100;

hp_percent_visible = lerp(hp_percent_visible,hp_percent,0.5);
mp_percent_visible = lerp(mp_percent_visible,mp_percent,0.5);
tp_percent_visible = lerp(tp_percent_visible,tp_percent,0.5);
xp_percent_visible = lerp(xp_percent_visible,xp_percent,0.5);
dmg_percent_visible = lerp(dmg_percent_visible, dmg_percent, 0.5);

dmg_percent_visible = max(
	dmg_percent_visible,
	map_value(
		hp_percent_visible,
		hp_percent + dmg_percent,
		hp_percent,
		0,
		dmg_percent
	)
);

dmg_percent_visible = median(dmg_percent_visible,0,hp_percent_visible-100);

if (!is_hit) {
	previous_hp = approach(previous_hp,hp,100);
}

//if !value_in_range(hp_percent_visible,0.1,99.9) { hp_percent_visible = round(hp_percent_visible); }
//if !value_in_range(mp_percent_visible,0.1,99.9) { mp_percent_visible = round(mp_percent_visible); }
//if !value_in_range(tp_percent_visible,0.1,99.9) { tp_percent_visible = round(tp_percent_visible); }
//if !value_in_range(xp_percent_visible,0.1,99.9) { xp_percent_visible = round(xp_percent_visible); }
//if !value_in_range(dmg_percent_visible,0.1,99.9) { dmg_percent_visible = round(dmg_percent_visible); }

if dead {
	death_timer += game_speed;
	if death_timer >= hitstun {
		death_script();
	}
}
else {
	death_timer = 0;
}