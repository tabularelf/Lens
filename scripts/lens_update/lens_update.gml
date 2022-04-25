/// @desc Need to be called every step in a controller object
function lens_update() {
	var _deltaTime = (delta_time / 1000000) * game_get_speed(gamespeed_fps);
	//show_debug_message(string(_deltaTime) );
	
	for (var i=0, len=array_length(global.__lens_events); i<len; i++) {
		var _lens = global.__lens_events[i];
		
		// Check
		if (weak_ref_alive(_lens.id) ) {
			// Update Delta Time
			_lens.id.ref.__deltaTime = _deltaTime;
			
			var _ready = _lens.event(_lens.arg0, _lens.arg1, _lens.arg2, _lens.arg3, _lens.arg4, _lens.arg5, _lens.arg6);
			
			if (_ready) {
				_lens.callback();
				array_delete(global.__lens_events, i, 1);
				len--;					
			}
		}
		else {
			array_delete(global.__lens_events, i, 1);
			len--;
		}
	}
}

