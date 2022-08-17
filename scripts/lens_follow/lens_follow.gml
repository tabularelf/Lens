// Feather ignore all
/// @param	{Struct.Lens}			lens			Lens Struct
/// @param	{Array, Id.Instance}	targets			Target(s) to follow it will obtain the media of the points		
/// @param	{Real}					x_amount		Interpolate value (how fast it goes to the point)	
/// @param	{Real}					y_amount		Interpolate value (how fast it goes to the point)
/// @param	{Real}					[x_division]	Division of the screen (The center of the camera recommended 2 to half width of camera)	
/// @param	{Real}					[y_division]	Division of the screen (The center of the camera recommended 2 to half height of camera)	
function lens_follow(_lens, _targets, _xAmount=.5, _yAmount=_xAmount, _xDivision=2, _yDivision=_xDivision) 
{
	if (!_lens.isFollowing() ) 
	{
		var _event = new __LensEvent(
			_lens,
			method(_lens, _lens.__eventFollow),
			[_xAmount, _yAmount, _xDivision, _yDivision]
		);
		
		array_push(global.__lens_events, _event);
		_lens.__followEvent   = true;
		
		if (!is_undefined(_targets) ) 
		{
			if (!is_array(_targets) ) 
			{
				array_push(_lens.__followTargets, _targets);
			}
			else 
			{
				var i=0; repeat(array_length(_targets) ) 
				{
					array_push(_lens.__followTargets, _targets[i++] );	
				}
			}
		}
		
		return (_event);
	}
}