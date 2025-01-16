if facing == 0 {
	facing = 1;
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

combo_hits_visible = lerp(combo_hits_visible,combo_hits_counter,0.5);
combo_damage_visible = lerp(combo_damage_visible,combo_damage_counter,0.5);

if (!is_hit) {
	previous_hp = approach(previous_hp,hp,100);
}

switch(active_state) {
	default:
	if (active_state == idle_state)
	or ((is_hit) or (is_guarding)) {
		deactivate_super();
		attack_hits = 0;
	}
	if state_timer < 2 {
		attack_hits = 0;
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

if round_state == roundstates.pause exit;
if ((superfreeze_active) and (superfreeze_activator != id)) exit;
if ((timestop_active) and (timestop_activator != id)) exit;
if hitstop <= 0 then hitstop = 0; else exit;

tp += game_speed * 1;
combo_timer -= game_speed;
if combo_timer <= 0 {
	reset_combo();
}
if combo_timer <= -30 {
	reset_combo_counter();
}

if dead {
	death_timer += game_speed;
	death_script();
}
else {
	death_timer = 0;
	alive_script();
}