//ai_enabled = true;

mp = 0;
tp = 0;
mp_stocks = 0;
tp_stocks = 0;

// Inherit the parent event
event_inherited();

if round_state == roundstates.pause exit;
if superfreeze_active exit;
if timestop_active exit;
if hitstop exit;

if duration != -1 {
	duration -= game_speed;
	if duration <= 0 {
		death_script();
		instance_destroy();
	}
}