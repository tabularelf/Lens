/// @param {Struct.Lens}		lens			Lens Struct
/// @param {Struct.AnimCurve}	animation_curve	Animation_curve
/// @param {Real, String}		x_channel		Channel index/name (recommended -1 to 1)
/// @param {Real, String}		y_channel		Channel index/name (recommended -1 to 1)
/// @param {Real}				[x_amount]		Force of the shake (horizontal)
/// @param {Real}				[y_amount]		Force of the shake (vertical)
/// @param {Real}				[duration]		Duration of the shake (in seconds)
function lens_shake(_lens, _animcurv, _xChannel=0, _yChannel=1, _xAmount=32, _yAmount=_xAmount, _duration=15) 
{
	// No execute 2 shake events at the same time.
	if (!_lens.IsShaking() ) {
		var _event = new __LensEvent(
			_lens, 
			method(_lens, _lens.__EventShake), 
			[_animcurv, _xChannel, _yChannel, _xAmount, _yAmount, _duration] 
		); 

		// Add to the event list
		array_push(global.__lens_events, _event);
		_lens.__shakeEvent = true;
		
		return _event;
	}
}