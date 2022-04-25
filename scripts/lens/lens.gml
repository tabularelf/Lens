#macro __LENS_VERSION "1.1.1"
#macro __LENS_CREDITS "@TabularElf - https://tabelf.link/"
show_debug_message("Lens " + __LENS_VERSION + " initalized! Created by " + __LENS_CREDITS); 

global.__lens_events = [];

/// @param [_view]
/// @param [_x]
/// @param [_y]
/// @param [_width]
/// @param [_height]
/// @returns {Struct.Lens}
function Lens(_view = -1, _x = 0, _y = 0, _width = room_width, _height = room_height) constructor {
	#region PRIVATE
	__camID = camera_create();
	__currentView = -1;
	
	__x = _x;
	__y = _y;
	__w =  _width;
	__h = _height;
	__relation = (__w / __h);
	
	__angle = 0;
	__xspeed = 0;
	__yspeed = 0;
	
	__deltaTime = (delta_time / 1000000) * game_get_speed(gamespeed_fps);
	
	// -- shake event
	__shakeEvent = false;
	__shakeTime  = 0;	// The time to end the shake event

	// -- follow event
	__followEvent  = false;
	__followEnable = true;
	__followTargets = [];
	
	__followBoundX =  room_width;
	__followBoundY = room_height;
	__followBoundUseX = true;
	__followBoundUseY = true;
	
	__followX = 0;
	__followY = 0;
	
	// -- zoom event
	__zoomEvent = false;
	__zoomTime = 0;
	
	__zoomForce = 1;
	__zoomW = __w;
	__zoomH = __h;
	
	// -- rotate event
	__rotateEvent = false;
	__rotateTime  = 0;
	__rotateAngle = __angle; 
	
	#endregion

	#region METHODS
	static Free = function() {
		SetViewCamera(-1);
		camera_destroy(__camID);
	}
	
	/// @returns {camera}
	static GetCameraID = function() {
		return __camID;	
	}
	
	/// @param view_index
	static SetViewCamera = function(_view) {
		if (__currentView <= -1) {
			view_camera [__currentView] = -1;	
			view_visible[__currentView] = false;
		}
		
		__currentView = _view;
		if (_view >= 0) {
			view_camera [_view] = __camID;
			view_visible[_view] = true;
		}
		return self;
	}
	
	static Apply = function() {
		camera_apply(__camID);	
		return self;
	}
	
	static SetViewMat = function(_matrix) {
		camera_set_view_mat(__camID, _matrix);
		return self;
	}	
	
	static SetProjMat = function(_matrix) {
		camera_set_proj_mat(__camID, _matrix);
		return self;
	}	
	
	static SetUpdateScript = function(_script) {
		camera_set_update_script(__camID, _script);
		return self;
	}	
	
	static SetBeginScript = function(_script) {
		camera_set_begin_script(__camID, _script);
		return self;
	}	
	
	static SetEndScript = function(_script) {
		camera_set_end_script(__camID, _script);
		return self;
	}	
	
	#region Position
	/// @param x
	/// @param y
	static SetViewPos = function(_x, _y=_x) {
		__x = _x;
		__y = _y;
		camera_set_view_pos(__camID, _x, _y);
		return self;
	}	
	
	/// @param x
	/// @param y
	static AddViewXY = function(_x, _y=_x) {
		__x += _x;
		__y += _y;
		
		camera_set_view_pos(__camID, __x, __y);		
		return self;
	}
	
	/// @param x
	static AddViewX = function(_x) {
		__x += _x;
		camera_set_view_pos(__camID, __x, __y);
		return self;
	}	
	
	/// @param y
	static AddViewY = function(_y) {
		__y += _y;
		camera_set_view_pos(__camID, __x, __y);
		return self;
	}	

	#endregion

	#region Size
	/// @param width	
	/// @param height
	static SetViewSize = function(_w, _h=_w) {
		__w = _w;
		__h = _h;
		__relation = (__w / __h);
		
		camera_set_view_size(__camID, __w, __h);
		
		return self;
	}	

	/// @param width	
	static SetViewW = function(_w) {
		return (SetViewSize(_w, __h) );
	}
	
	/// @param height
	static SetViewH = function(_h) {
		return (SetViewSize(__w, _h) );
	}
	
	/// @param width
	static AddViewW = function(_w) {
		return (SetViewSize(__w + _w, __h) );
	}
	
	/// @param height
	static AddViewH = function(_h) { 
		return (SetViewSize(__w, __h + _h) );
	}
	
	#endregion
	
	static SetViewSpeed = function(_xSpeed, _ySpeed) {
		__xspeed = _xSpeed;
		__yspeed = _ySpeed;
		camera_set_view_speed(__camID, __xspeed, __yspeed);
		return self;
	}	
	
	static AddViewXSpeed = function(_xSpeed) {
		__xspeed += _xSpeed;
		camera_set_view_speed(__camID, __xspeed, __yspeed);
		return self;
	}	
	
	static AddViewYSpeed = function(_ySpeed) {
		__yspeed += _ySpeed;
		camera_set_view_speed(__camID, __xspeed, __yspeed);
		return self;
	}	
	
	static SetViewBorder = function(_xBorder, _yBorder) {
		camera_set_view_border(__camID, _xBorder, _yBorder);
		return self;
	}	
	
	static SetViewAngle = function(_angle) {
		__angle = _angle;
		camera_set_view_angle(__camID, _angle);
		return self;
	}	
	
	static AddViewAngle = function(_angle) {
		__angle += _angle;
		camera_set_view_angle(__camID, __angle);
		return self;
	}	
	
	static SetViewTarget = function(_id) {
		camera_set_view_target(__camID, _id);
		return self;
	}
	
		#region Events
	/// @param animation_curve
	/// @param channel_x
	/// @param channel_y
	/// @param amount_x
	/// @param amount_y
	/// @param duration
	static __EventShake  = function(_animCurv, _xChannel=0, _yChannel=1, _xAmount=32, _yAmount=_xAmount, _duration=15) { 
		__shakeTime = lerp(__shakeTime, 1, 1 / (_duration * __deltaTime) );
		// Aquiles and the turtle
		if (__shakeTime >= .9999) __shakeTime = 1;
		
		var _chanX = animcurve_get_channel(_animCurv, _xChannel);	
		var _chanY = animcurve_get_channel(_animCurv, _yChannel);
		
		var _shX = animcurve_channel_evaluate(_chanX, __shakeTime) * _xAmount;
		var _shY = animcurve_channel_evaluate(_chanY, __shakeTime) * _yAmount;
	
		// Move view
		AddViewXY(_shX, _shY);
		
		// Ready
		if (__shakeTime >= 1) {
			__shakeEvent = false;
			__shakeTime  = 0;
			
			show_debug_message("Shake Ready");
			
			return true;
		}

		return false;
	}

		#region Follow Event Simple
	/// @param amount_x
	/// @param amount_y
	/// @param division_x
	/// @param division_y
	static __EventFollow = function(_xAmount=.5, _yAmount=_xAmount, _xDivision=2, _yDivision=_xDivision) {
		// Disable follow
		if (!__followEnable) return true;
		
		var _camX = 0;
		var _camY = 0;
		
		__followX = 0;
		__followY = 0;
		
		#region Get Average
		var len = array_length(__followTargets);
			
		var _ww = window_get_width();
		var _wh = window_get_height();
		var _mx = window_mouse_get_x();
		var _my = window_mouse_get_y();

		var _inBorders =    ( _mx < 128)
						 || ( _mx > _ww - 128)
						 
						 || ( _my < 128)
						 || ( _my > _wh - 128);
		
		for (var i=0; i<len; i++) {
			var ins = __followTargets[i];
			if (is_string(ins) ) {
				switch (ins) {
					case "mouse":
						if (len == 1) {
							// Only mouse
							if (!_inBorders) continue;				
							var _dir = point_direction(_ww / 2, _wh / 2, _mx, _my);

							__followX += lengthdir_x(32, _dir);
							__followY += lengthdir_y(32, _dir);						
						}
						else {
							// with other targets
							__followX = mouse_x - (__w / _xDivision);
							__followY = mouse_y - (__h / _yDivision);
						}
						
						break;
				}
			}
			else {
				if (instance_exists(ins) ) {
					__followX += ins.x - (__w / _xDivision);
					__followY += ins.y - (__h / _yDivision);
				} else {
					array_delete(__followTargets, i, 1);
					len--;
				}
			}
		}
		
		__followX /= len;
		__followY /= len;

		#endregion

		if (__followBoundUseX) __followX = clamp(__followX, 0, __followBoundX - __w);
		if (__followBoundUseY) __followY = clamp(__followY, 0, __followBoundY - __h);

		_camX = lerp(__x, __followX, _xAmount * __deltaTime);
		_camY = lerp(__y, __followY, _yAmount * __deltaTime);

		SetViewPos(round(_camX), round(_camY) );
	}

	/// @param _xBound
	/// @param _yBound
	/// @desc Set which limits the Follow event cannot go (default room_width, room_height)
	static SetFollowBounds = function(_xBound, _yBound) {
		__followBoundX = _xBound;
		__followBoundY = _yBound;
		return self;
	}
	
	/// @param _xBound
	/// @param _yBound	
	/// @desc Choose which follow event limits to use (default xBound and yBound) 		
	static SetFollowBoundsUse = function(_xBound, _yBound) {
		__followBoundUseX = _xBound;
		__followBoundUseY = _yBound;
		return self;
	}
	
	/// @param {Id.Instance} _ins
	static AddFollowTarget = function() {
		if (argument_count > 1) {
			var i=0; repeat(argument_count) AddFollowTarget(argument[i++] );
		}
		else {
			array_push(__followTargets, argument0);
		}
		
		return self;
	}
	
	#endregion
	
	/// @param animation_curve
	/// @param channel_X
	/// @param channel_y
	/// @param target_x
	/// @param target_y
	/// @param duration
	static __EventZoomTarget = function(_animCurv, _xChannel=0, _yChannel=1, _xTarget, _yTarget, _duration=15) {
		var _chanx = animcurve_get_channel(_animCurv, _xChannel);
		var _chany = animcurve_get_channel(_animCurv, _yChannel);
		
		var _xAbs = _xTarget - __x;
		var _yAbs = _yTarget - __y;
		
		__zoomTime = lerp(__zoomTime, 1, 1 / (_duration * __deltaTime) );
		// Aquiles and the turtle
		if (__zoomTime >= .9999) __zoomTime = 1;
		
		var _newW = __zoomW * animcurve_channel_evaluate(_chanx, __zoomTime);
		var _newH = __zoomH * animcurve_channel_evaluate(_chany, __zoomTime);
		 
		var _px = _xAbs / __w;
		var _py = _yAbs / __h;
		
		SetViewSize(_newW, _newH);
		
		// Calculate what the new distance from the target to the origin should be.
		var _xNew = _px * __w;
		var _yNew = _py * __h;
	
		// Set the origin based on where the object should be.
		SetViewPos(_xTarget - _xNew, _yTarget - _yNew);
		
		// less force
		if (__zoomTime >= 1) {
			__zoomEvent = false;
			__zoomTime  = 0;
			
			show_debug_message("Zoom Target Ready");
			
			return true;
		}

		return false;		
	}

	/// @param animation_curve
	/// @param channel
	/// @param angleTo
	/// @param duration
	static __EventRotate = function(_animCurv, _channel, _angleTo, _duration) {
		var _chanA = animcurve_get_channel(_animCurv, _channel);
		__rotateTime = lerp(__rotateTime, 1, 1 / (_duration * __deltaTime) );
		// Aquiles and the turtle
		if (__rotateTime >= .9999) __rotateTime = 1;
		
		var _inter = animcurve_channel_evaluate(_chanA, __rotateTime);
		var _angle = __rotateAngle * _inter;
		
		SetViewAngle(_angle);
	
		if (__rotateTime >= 1) {
			__rotateEvent = false;
			__rotateTime = 0;
			
			show_debug_message("Rotate ready");
			
			return true;
		}
		
		return false;
	}
	
	#endregion
	
		#region Get
	static GetViewMat = function() {
		return camera_get_view_mat(__camID);	
	}
	
	static GetProjMat = function() {
		return camera_get_proj_mat(__camID);	
	}
	
	static GetUpdateScript = function() {
		return camera_get_update_script(__camID);	
	}
	
	static GetBeginScript = function() {
		return camera_get_begin_script(__camID);	
	}
	
	static GetEndScript = function() {
		return camera_get_end_script(__camID);	
	}
	
	static GetViewX = function() {
		return __x;
	}
	
	static GetViewY = function() {
		return __y;	
	}
	
	static GetViewWidth = function() {
		return __width;
	}
	
	static GetViewHeight = function() {
		return __height;	
	}
	
	static GetViewSpeedX = function() {
		return __xspeed;	
	}
	
	static GetViewSpeedY = function() {
		return __yspeed;	
	}
	
	static GetViewSpeed = function() {
		return [GetViewSpeedX(), GetViewSpeedY()];
	}
	
	static GetViewBorderX = function() {
		return camera_get_view_border_x(__camID);	
	}
	
	static GetViewBorderY = function() {
		return camera_get_view_border_y(__camID);	
	}
	
	static GetViewAngle = function() {
		return __angle;
	}
	
	static GetViewTarget = function() {
		return camera_get_view_target(__camID);	
	}
	
	static GetCameraRect = function() {
		return [GetViewX(), GetViewY(), GetViewX() + GetViewWidth(), GetViewY() + GetViewHeight()];
	}
	
	#endregion
	
	/// @return {String}
	static toString = function() {
		var _always = "delta: "+ string(__deltaTime) + "\nx: " + string(__x) + "\ny: " + string(__y) + "\nw: " + string(__w) + "\nh: " + string(__h) +
					  "\nangle: "+ string(__angle);
		
		if (__followEvent) {
			_always +=  
				"\nfollowBoundX: " + string(__followBoundX) +
				"\nfollowBoundY: " + string(__followBoundY) + 
				"\nfollowBoundXUse: " + string(__followBoundUseX) +
				"\nfollowBoundYUse: " + string(__followBoundUseY) +
				"\nfollowTargets: "   + string(__followTargets);
		}
		
		if (__shakeEvent) {
			_always += 
				"\nshakeTime: " + string(__shakeTime);
		}
		
		if (__zoomEvent) {
			_always +=
				"\nzoomTime: "  +  string(__zoomTime) +
				"\nzoomForce: " + string(__zoomForce) +
				"\nzoomW: " + string(__zoomW) +
				"\nzoomH: " + string(__zoomH);
		}
		
		if (__rotateEvent) {
			_always += "\nrotateTime: " + string(__rotateTime);	
		}
		
		return _always;
	}
	
	#endregion

	// Force visibility
	if !(view_enabled) view_enabled = true;	
	if (_view >= 0) SetViewCamera(_view);
	
	SetViewPos(_x, _y);
	SetViewSize(_width, _height);
	
	window_center();
}






