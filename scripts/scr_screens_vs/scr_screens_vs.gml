globalvar	vs_fadein_duration, vs_slidein_duration, vs_slidein2_duration, vs_slideout_duration, vs_fadeout_duration,
			vs_fadein_time, vs_slidein_time, vs_slidein2_time, vs_slideout_time, vs_fadeout_time;

vs_fadein_duration = screen_fade_duration;
vs_slidein_duration = 90;
vs_slidein2_duration = 90;
vs_slideout_duration = 90;
vs_fadeout_duration = screen_fade_duration;

vs_fadein_time = vs_fadein_duration;
vs_slidein_time = vs_fadein_time + vs_slidein_duration;
vs_slidein2_time = vs_slidein_time + vs_slidein2_duration;
vs_slideout_time = vs_slidein2_time + vs_slideout_duration;
vs_fadeout_time = vs_slideout_time + vs_fadeout_duration;