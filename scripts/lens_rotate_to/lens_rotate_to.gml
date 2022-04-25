/// @param {Struct.Lens} _lens	Lens Struct
/// @param _animCurv	Animation_curve
/// @param _channel		Channel index/name (recommended 0 -> 1)
/// @param _angleTo		Angle to go
/// @param _duration	Duration of the event (in seconds)
function lens_rotate_to(_lens, _animCurv, _channel=0, _angleTo=90, _duration=15) {
	if (!_lens.__rotateEvent) {
		array_push(global.__lens_events, 
			new __LensEvent(_lens, method(_lens, _lens.__EventRotate), _animCurv, _channel, _angleTo, _duration)
		);

		_lens.__rotateEvent = true;
		_lens.__rotateAngle = _lens.__angle + _angleTo;
	}
}


