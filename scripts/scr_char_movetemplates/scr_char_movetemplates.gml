function basic_light_shot(_x,_y,_xspeed,_yspeed,_sprite,_scale,_hiteffect) {
	var shot = create_shot(
		_x,
		_y,
		_xspeed,
		_yspeed,
		_sprite,
		_scale,
		100,
		3,
		0,
		attacktype.normal,
		attackstrength.light,
		_hiteffect
	);
	return shot;
}

function add_temporary_powerup_state(_duration,_boost) {
	temporary_powerup_active = false;
	temporary_powerup_timer = 0;
	temporary_powerup_duration = _duration * 60;
	temporary_powerup_boost = _boost;
	
	temporary_powerup_state = new charstate();
	temporary_powerup_state.start = function() {
		if attempt_super(ceil(temporary_powerup_boost-1),!temporary_powerup_active) {
			change_sprite(charge_start_sprite,false);
			superfreeze(20);
		}
		else {
			change_state(idle_state);
		}
	}
	temporary_powerup_state.run = function() {
		xspeed = 0;
		yspeed = 0;
		if sprite == charge_start_sprite {
			if superfreeze_timer <= 5 {
				change_sprite(charge_loop_sprite,true);
				flash_sprite();
				play_voiceline(voice_powerup);
				superfreeze(30);
				shake_screen(5,2);
				temporary_powerup_timer = temporary_powerup_duration;
			}
		}
		else if sprite == charge_loop_sprite {
			shake_screen(5,1);
			aura_sprite = charge_aura;
			if superfreeze_timer <= 5 {
				change_sprite(charge_stop_sprite,false);
				superfreeze(10);
			}
		}
		else {
			aura_sprite = none;
			if !superfreeze_active {
				change_state(idle_state);
			}
		}
	}
	
	update_temporary_powerup = function() {
		var _temporary_powerup_active = temporary_powerup_active;
		if temporary_powerup_timer > 0 {
			temporary_powerup_active = true;
			temporary_powerup_timer -= !super_active;
		}
		else {
			temporary_powerup_active = false;
		}
		if temporary_powerup_active != _temporary_powerup_active {
			if temporary_powerup_active {
				attack_power = temporary_powerup_buff;
				move_speed_buff = temporary_powerup_buff;
				return 2;
			}
			else {
				attack_power = 1;
				move_speed_buff = 1;
				
				flash_sprite();
				return -1;
			}
		}
		return temporary_powerup_active;
	}
}