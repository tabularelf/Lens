/// @param	{Struct.Lens}		lens				Lens Struct
/// @param	{Struct.AnimCurve}	animation_curve		Animation_curve
/// @param	{Real, String}		channel				Channel index/name (recommended values: 0 -> 1)
/// @param	{Real}				angle_to			Angle to go
/// @param	{Real}				duration			Duration of the event (in seconds)
function lens_rotate_to(_lens, _animCurv, _channel=0, _angleTo=90, _duration=15) 
{
	if (!_lens.IsRotating() ) {
		var _event = new __LensEvent(
			_lens,
			method(_lens, _lens.__EventRotate),
			[_animCurv, _channel, _angleTo, _duration]
		);

		_lens.__rotateEvent = true;
		_lens.__rotateAngle = _lens.__angle + _angleTo;
		
		return (_event ); 
	}
}