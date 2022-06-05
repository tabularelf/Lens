#macro __LENS_VERSION "1.1.1"
#macro __LENS_CREDITS "@TabularElf - https://tabelf.link/"
show_debug_message("Lens " + __LENS_VERSION + " initalized! Created by " + __LENS_CREDITS); 

/// @ignore
global.__lens_events = [];

/// @ignore
global.__lens_update = function() {
	var _deltaTime = (delta_time / 1000000) * game_get_speed(gamespeed_fps);
	var _len = array_length(global.__lens_events);
	
	for (var i=0; i<_len; i++) {
		var _event = global.__lens_events[i];
		
		// Check
		if (_event.alive() ) {
			// Execute Event
			if (_event.execute(_deltaTime) )  {
				_event.callback();
				array_delete(global.__lens_events, i, 1);
				_len--;
			}
		}
		else {
			array_delete(global.__lens_events, i, 1);
			_len--;
		}
	}
}

/// @ignore
global.__lens_timesource = time_source_create(time_source_global, 1, time_source_units_frames, global.__lens_update, [], -1);
time_source_start(global.__lens_timesource);