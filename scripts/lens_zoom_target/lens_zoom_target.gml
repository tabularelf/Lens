/// @param {Struct.Lens} _lens	Lens Struct
/// @param _animCurv	Animation_curve
/// @param _xChannel	Channel index/name (recommended 1 -> 0 -> 1)
/// @param _yChannel	Channel index/name (recommended 1 -> 0 -> 1)
/// @param _xTarget		Position to zoom in
/// @param _yTarget		Position to zoom in
/// @param _duration	Duration of the event
function lens_zoom_target(_lens, _animCurv, _xChannel=0, _yChannel=1, _xTarget, _yTarget, _duration=15) {
	if (!_lens.__zoomEvent) {
		array_push(global.__lens_events, 
			new __LensEvent(_lens, method(_lens, _lens.__EventZoomTarget), _animCurv, _xChannel, _yChannel, _xTarget, _yTarget, _duration)
		);

		_lens.__zoomEvent = true;
		_lens.__zoomW = _lens.__w;
		_lens.__zoomH = _lens.__h;
	}
}


