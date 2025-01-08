globalvar timeskip_active;

timeskip_active = false;

function timeskip(_frames) {
	if !timeskip_active {
		timeskip_active = true;
		repeat(_frames) {
			with(all) {
				event_perform(ev_step, ev_step_begin);
			}
			with(all) {
				event_perform(ev_step, ev_step_normal);
			}
			with(all) {
				event_perform(ev_step, ev_step_end);
			}
			audio_stop_all();
		}
		timeskip_active = false;
	}
}