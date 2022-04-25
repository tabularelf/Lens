/// @param {Struct.Lens} _lens	Lens Struct
/// @param _animCurv			Animation_curve
/// @param _xChannel			Channel index/name (recommended -1 to 1)
/// @param _yChannel			Channel index/name (recommended -1 to 1)
/// @param _xAmount				Force of the shake (horizontal)
/// @param _yAmount				Force of the shake (vertical)
/// @param _duration			Duration of the shake (in seconds)
function lens_shake(_lens, _animCurv, _xChannel=0, _yChannel=1, _xAmount=32, _yAmount=_xAmount, _duration=15) {
	// No execute 2 shake events at the same time.
	if (!_lens.__shakeEvent) {
		// Add to the event list
		array_push(global.__lens_events, 
			new __LensEvent(_lens, method(_lens, _lens.__EventShake), _animCurv, _xChannel, _yChannel, _xAmount, _yAmount, _duration)
		);
		
		_lens.__shakeEvent = true;
	}
}



