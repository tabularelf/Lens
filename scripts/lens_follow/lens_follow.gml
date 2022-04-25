/// @param {Struct.Lens} _lens				Lens Struct
/// @param {Array|Id.Instance} _targets		Target(s) to follow it will obtain the media of the points		
/// @param _xAmount			Interpolate value (how fast it goes to the point)	
/// @param _yAmount			Interpolate value (how fast it goes to the point)
/// @param _xDivision		Division of the screen (The center of the camera recommended 2 to half width of camera)	
/// @param _yDivision		Division of the screen (The center of the camera recommended 2 to half height of camera)	
function lens_follow(_lens, _targets, _xAmount=.5, _yAmount=_xAmount, _xDivision=2, _yDivision=_xDivision) {
	if (!_lens.__followEvent) {
		array_push(global.__lens_events, 
			new __LensEvent(_lens, method(_lens, _lens.__EventFollow), _xAmount, _yAmount, _xDivision, _yDivision)
		);
		
		_lens.__followEvent   = true;
		if (!is_undefined(_targets) ) {
			if (!is_array(_targets) ) {
				array_push(_lens.__followTargets, _targets);
			}
			else {
				var i=0; repeat(array_length(_targets) ) array_push(_lens.__followTargets, _targets[i++] );	
			}
		}
	}
}



