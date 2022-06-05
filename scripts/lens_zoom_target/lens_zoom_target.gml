/// @param	{Struct.Lens}		lens				Lens Struct
/// @param	{Struct.AnimCurve}	animation_curve		Animation_curve
/// @param	{Real, String}		x_channel			Channel index/name (recommended 1 -> 0 -> 1)
/// @param	{Real, String}		y_channel			Channel index/name (recommended 1 -> 0 -> 1)
/// @param	{Real}				x_target			Position to zoom in
/// @param	{Real}				y_target			Position to zoom in
/// @param	{Real}				duration			Duration of the event
function lens_zoom_target(_lens, _animCurv, _xChannel=0, _yChannel=1, _xTarget, _yTarget, _duration=15) 
{
	if (!_lens.IsZooming() ) {
		var _event = new __LensEvent(
			_lens,
			method(_lens, _lens.__EventZoomTarget),
			[_animCurv, _xChannel, _yChannel, _xTarget, _yTarget, _duration]
		);
		
		_lens.__zoomEvent = true;
		_lens.__zoomW = _lens.__w;
		_lens.__zoomH = _lens.__h;
		
		return (_event);
	}
}