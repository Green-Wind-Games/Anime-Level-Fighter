function set_substitution_jutsu() {
	substitution_state.start = function() {
		change_sprite(air_peak_sprite,3,false);
		reset_sprite();
		timestop();
		can_cancel = false;
		alpha = 0;
		create_particles(x,y,x,y,jutsu_smoke_particle);
	}
	substitution_state.run = function() {
		xspeed = 0;
		yspeed = 0;
		face_target();
		if timestop_timer == 10 {
			substitution_teleport();
			create_particles(x,y,x,y,jutsu_smoke_particle);
			reset_sprite(true,false);
		}
		if !timestop_active {
			change_state(idle_state);
		}
	}
}