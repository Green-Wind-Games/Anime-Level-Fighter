function update_fight() {
	round_state_timer += game_speed;
	var _roundstate = round_state;
	switch(round_state) {
		case roundstates.intro:
		var ready = round_state_timer > 100;
		with(obj_char) {
			if active_state != idle_state { ready = false; }
			if sound_is_playing(voice) { ready = false; }
			//if state_timer < 100 { ready = false; }
		}
		if ready {
			round_state = roundstates.countdown;
		}
		break;
		
		case roundstates.countdown:
		if round_state_timer >= (round_ready_countdown_duration + round_ready_fight_duration) {
			round_state = roundstates.fight;
		}
		break;
		
		case roundstates.fight:
		if (!superfreeze_active) and (!timestop_active) {
			round_timer -= game_speed;
		}
		if round_timer <= 0 {
			round_state = roundstates.time_over;
		}
		var alldead = instance_number(obj_char) - instance_number(obj_helper);
		with(obj_char) {
			if !dead {
				alldead -= is_char(id);
				if game_state == gamestates.training {
					if combo_timer <= -60 {
						hp = max_hp;
						mp = max_mp;
					}
				}
			}
		}
		if alldead {
			if (!superfreeze_active) and (!timestop_active) {
				timestop(60);
				round_state = roundstates.knockout;
			}
		}
		break;
		
		case roundstates.time_over:
		case roundstates.knockout:
		var ready = round_state_timer > 100;
		with(obj_char) {
			if dead {
				if active_state != liedown_state { ready = false; }
			}
			else {
				if active_state != idle_state { ready = false; }
			}
			//if state_timer < 100 { ready = false; }
		}
		if ready {
			if game_state == gamestates.training {
				change_gamestate(gamestates.training);
			}
			round_state = roundstates.victory;
		}
		break;
		
		case roundstates.victory:
		var team1_score = get_team_score(1);
		var team2_score = get_team_score(2);
		var ready = round_state_timer > 100;
		with(obj_char) {
			if active_state == idle_state {
				if ((team == 1) and (team1_score > team2_score))
				or ((team == 2) and (team2_score > team1_score)) {
					change_state(victory_state);
				}
				else {
					change_state(defeat_state);
				}
			}
			if !dead {
				if (active_state != victory_state)
				and (active_state != defeat_state) {
					ready = false;
				}
				//if !anim_finished { ready = false; }
				if sound_is_playing(voice) { ready = false; }
				//if sprite_timer < (anim_duration * 2) { ready = false; }
			}
		}
		if ready {
			if next_game_state == -1 {
				change_gamestate(game_state+1);
				if next_game_state == gamestates.training + 1 {
					change_gamestate(gamestates.training);
				}
			}
		}
		break;
	}
	if round_state != _roundstate {
		round_state_timer = 0;
	}
	
	var border = 16;
	var _x1 = room_width;
	var _y1 = room_height;
	var _x2 = 0;
	var _y2 = 0;
	with(obj_char) {
		if (!dead) and (!is_helper(id)) {
			_x1 = min(_x1,x);
			_y1 = min(_y1,y);
			_x2 = max(_x2,x);
			_y2 = max(_y2,y);
		}
	}
	battle_x = mean(_x1,_x2);
	battle_y = mean(_y1,_y2);
	var battle_size = 640;
	left_wall = clamp(battle_x - (battle_size / 2),0,room_width-game_width) + border;
	right_wall = clamp(battle_x + (battle_size / 2),game_width,room_width) - border;
	
	if superfreeze_timer > 0 {
		superfreeze_active = true;
		superfreeze_timer -= game_speed;
	}
	else {
		superfreeze_active = false;
		superfreeze_activator = noone;
		superfreeze_timer = 0;
	}
	
	if timestop_timer > 0 {
		timestop_active = true;
		timestop_timer -= game_speed;
	}
	else {
		timestop_active = false;
		timestop_activator = noone;
		timestop_timer = 0;
	}
}