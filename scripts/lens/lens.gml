#macro __LENS_VERSION "1.1.1"
#macro __LENS_CREDITS "@TabularElf - https://tabelf.link/"
show_debug_message("Lens " + __LENS_VERSION + " initalized! Created by " + __LENS_CREDITS); 

/// @ignore
global.__lens_events = [];

/// @param {Real} [_view]
/// @param {Real} [_x]
/// @param {Real} [_y]
/// @param {Real} [_width]
/// @param {Real} [_height]
/// @returns {Struct.Lens}
function Lens(_view=-1, _x=0, _y=0, _width=room_width, _height=room_height) constructor {
	#region PRIVATE
	/// @ignore
	__camera = camera_create();
	/// @ignore
	__view = -1;
	/// @ignore
	__x = _x;
	/// @ignore
	__y = _y;
	/// @ignore
	__w =  _width;
	/// @ignore
	__h = _height;
	/// @ignore
	__relation = (__w / __h);
	/// @ignore
	__angle = 0;
	/// @ignore
	__xspeed = 0;
	/// @ignore
	__yspeed = 0;
	/// @ignore
	__deltaTime = (delta_time / 1000000) * game_get_speed(gamespeed_fps);
	
	#region Shake Event
	/// @ignore
	__shakeEvent = false;
	/// @ignore
	__shakeTime  = 0;	// The time to end the shake event

	#endregion

	#region Follow Event
	/// @ignore
	__followEvent  = false;
	/// @ignore
	__followEnable = true;
	/// @ignore
	__followTargets = [];
	/// @ignore
	__followBoundX = room_width;
	/// @ignore
	__followBoundY = room_height;
	/// @ignore
	__followBoundUseX = true;
	/// @ignore
	__followBoundUseY = true;
	/// @ignore
	__followX = 0;
	/// @ignore
	__followY = 0;
	
	#endregion
	
	#region Zoom Event
	/// @ignore
	__zoomEvent = false;
	/// @ignore
	__zoomTime = 0;
	/// @ignore
	__zoomForce = 1;
	/// @ignore
	__zoomW = __w;
	/// @ignore
	__zoomH = __h;
	
	#endregion
	
	#region Rotate Event
	/// @ignore
	__rotateEvent = false;
	/// @ignore
	__rotateTime  = 0;
	/// @ignore
	__rotateAngle = __angle; 
	
	#endregion
	
	#endregion

	#region METHODS
	
	static Free = function() {
		SetViewCamera(-1);
		camera_destroy(__camera);
	}
	
	/// @returns {Id.Camera}
	static GetCamera = function() {
		return __camera;	
	}
	
	/// @param _view_index
	/// @returns {Struct.Lens}
	static SetCamera = function(_view_index) {
		// Check
		if (__view <= -1) {
			view_camera [__view] = -1;	
			view_visible[__view] = false;
		}
		
		// Set
		__view = _view_index;
		if (_view_index >= 0) {
			view_camera [_view_index] = __camera;
			view_visible[_view_index] = true;
		}
		
		return self;
	}
	
	/// @returns {Struct.Lens}
	static Apply = function() {
		camera_apply(__camera);	
		return self;
	}
	
	/// @param _matrix
	/// @returns {Struct.Lens}
	static SetViewMat = function(_matrix) {
		camera_set_view_mat(__camera, _matrix);
		return self;
	}	

	/// @param _matrix
	/// @returns {Struct.Lens}
	static SetProjMat = function(_matrix) {
		camera_set_proj_mat(__camera, _matrix);
		return self;
	}	
	
	/// @param {Function} _script
	/// @returns {Struct.Lens}	
	static SetUpdateScript = function(_script) {
		camera_set_update_script(__camera, _script);
		return self;
	}	
	
	/// @param {Function} _script
	/// @returns {Struct.Lens}	
	static SetBeginScript = function(_script) {
		camera_set_begin_script(__camera, _script);
		return self;
	}	
	
	/// @param {Function} _script
	/// @returns {Struct.Lens}	
	static SetEndScript = function(_script) {
		camera_set_end_script(__camera, _script);
		return self;
	}	
	
	#region Position
	/// @param {Real} _x
	/// @param {Real} [_y]
	/// @returns {Struct.Lens}	
	static SetXY = function(_x, _y=_x) {
		__x = _x;
		__y = _y;
		camera_set_view_pos(__camera, _x, _y);
		return self;
	}	
	
	/// @param {Real} _x
	/// @param {Real} [_y]
	/// @returns {Struct.Lens}	
	static AddXY = function(_x, _y=_x) {
		__x += _x;
		__y += _y;
		
		camera_set_view_pos(__camera, __x, __y);		
		return self;
	}
	
	/// @param _x
	/// @returns {Struct.Lens}	
	static AddX = function(_x) {
		__x += _x;
		camera_set_view_pos(__camera, __x, __y);
		return self;
	}	
	
	/// @param _y
	/// @returns {Struct.Lens}	
	static AddY = function(_y) {
		__y += _y;
		camera_set_view_pos(__camera, __x, __y);
		return self;
	}	

	#endregion

	#region Size
	/// @param {Real} _w	
	/// @param {Real} [_h]
	/// @returns {Struct.Lens}	
	static SetWH = function(_w, _h=_w) {
		__w = _w;
		__h = _h;
		__relation = (__w / __h);
		
		camera_set_view_size(__camera, __w, __h);
		
		return self;
	}
	
	/// @param {Real} _w
	/// @returns {Struct.Lens}	
	static SetW = function(_w) {
		return (SetViewSize(_w, __h) );
	}
	
	/// @param {Real} _h
	/// @returns {Struct.Lens}	
	static SetH = function(_h) {
		return (SetViewSize(__w, _h) );
	}
	
	/// @param {Real} _w
	/// @param {Real} _h	
	/// @returns {Struct.Lens}
	static AddWH = function(_w, _h=_w) {
		return (SetWH(__w + _w, __h + _h) );
	}
	
	/// @param {Real} _w
	/// @returns {Struct.Lens}
	static AddW = function(_w) {
		return (SetWH(__w + _w, __h) );
	}
	
	/// @param {Real} _h
	/// @returns {Struct.Lens}
	static AddH = function(_h) { 
		return (SetWH(__w, __h + _h) );
	}
	
	#endregion
	
	/// @param {Real} _x_speed
	/// @param {Real} _y_speed
	/// @returns {Struct.Lens}
	static SetSpeed = function(_x_speed, _y_speed) {
		__xspeed = _x_speed;
		__yspeed = _y_speed;
		camera_set_view_speed(__camera, __xspeed, __yspeed);
		return self;
	}	

	/// @param {Real} _x_speed
	/// @returns {Struct.Lens}	
	static AddSpeedX = function(_x_speed) {
		__xspeed += _x_speed;
		camera_set_view_speed(__camera, __xspeed, __yspeed);
		return self;
	}	

	/// @param {Real} _y_speed
	/// @returns {Struct.Lens}	
	static AddSpeedY = function(_y_speed) {
		__yspeed += _y_speed;
		camera_set_view_speed(__camera, __xspeed, __yspeed);
		return self;
	}	

	/// @param {Real} _x_border
	/// @param {Real} _y_border	
	/// @returns {Struct.Lens}
	static SetBorder = function(_x_border, _y_border) {
		camera_set_view_border(__camera, _x_border, _y_border);
		return self;
	}	

	/// @param {Real} _angle
	/// @returns {Struct.Lens}	
	static SetAngle = function(_angle) {
		__angle = _angle;
		camera_set_view_angle(__camera, _angle);
		return self;
	}	

	/// @param {Real} _angle
	/// @returns {Struct.Lens}
	static AddAngle = function(_angle) {
		__angle += _angle;
		camera_set_view_angle(__camera, __angle);
		return self;
	}	

	/// @param {Id.Instance} _id
	/// @returns {Struct.Lens}
	static SetTarget = function(_id) {
		camera_set_view_target(__camera, _id);
		return self;
	}
	
		#region Events
	/// @ignore
	/// @param _anim_curve
	/// @param {Real, String} _x_channel
	/// @param {Real, String} _y_channel
	/// @param {Real} _x_amount
	/// @param {Real} _y_amount
	/// @param {Real} _duration
	/// @return {Bool}
	static __EventShake  = function(_anim_curve, _x_channel=0, _y_channel=1, _x_amount=32, _y_amount=_x_amount, _duration=15) { 
		__shakeTime = lerp(__shakeTime, 1, 1 / (_duration * __deltaTime) );
		// Aquiles and the turtle
		if (__shakeTime >= .9999) __shakeTime = 1;
		
		var _chanX = animcurve_get_channel(_anim_curve, _x_channel);	
		var _chanY = animcurve_get_channel(_anim_curve, _y_channel);
		
		var _shX = animcurve_channel_evaluate(_chanX, __shakeTime) * _x_amount;
		var _shY = animcurve_channel_evaluate(_chanY, __shakeTime) * _y_amount;
	
		// Move view
		AddXY(_shX, _shY);
		
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
	/// @ignore
	/// @param {Real} _x_amount
	/// @param {Real} _y_amount
	/// @param {Real} _x_division
	/// @param {Real} _y_division
	static __EventFollow = function(_x_amount=.5, _y_amount=_x_amount, _x_division=2, _y_division=_x_division) {
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
							__followX = mouse_x - (__w / _x_division);
							__followY = mouse_y - (__h / _y_division);
						}
						
						break;
				}
			}
			else {
				if (instance_exists(ins) ) {
					__followX += ins.x - (__w / _x_division);
					__followY += ins.y - (__h / _y_division);
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

		_camX = lerp(__x, __followX, _x_amount * __deltaTime);
		_camY = lerp(__y, __followY, _y_amount * __deltaTime);

		SetXY(round(_camX), round(_camY) );
	}

	/// @param {Real} _x_bound
	/// @param {Real} _y_bound	
	/// @desc Set which limits the Follow event cannot go (default room_width, room_height)
	/// @returns {Struct.Lens}
	static SetFollowBounds = function(_x_bound, _y_bound) {
		__followBoundX = _x_bound;
		__followBoundY = _y_bound;
		return self;
	}
	
	/// @param {Real} _x_bound
	/// @param {Real} _y_bound	
	/// @desc Choose which follow event limits to use (default __followBoundX and __followBoundY) 		
	/// @returns {Struct.Lens}
	static SetFollowBoundsUse = function(_x_bound, _y_bound) {
		__followBoundUseX = _x_bound;
		__followBoundUseY = _y_bound;
		return self;
	}
	
	/// @param {Id.Instance, String} _ins...
	/// @returns {Struct.Lens}	
	static AddFollowTarget = function(_ins) {
		if (argument_count > 1) {
			var i=0; repeat(argument_count) AddFollowTarget(argument[i++] );
		}
		else {
			array_push(__followTargets, argument0);
		}
		
		return self;
	}
	
	#endregion
	
	/// @ignore
	/// @param _anim_curve
	/// @param {Real} _x_channel
	/// @param {Real} _y_channel
	/// @param {Real} _x_target
	/// @param {Real} _y_target
	/// @param {Real} _duration
	/// @return {Bool}	
	static __EventZoomTarget = function(_anim_curve, _x_channel=0, _y_channel=1, _x_target, _y_target, _duration=15) {
		var _chanx = animcurve_get_channel(_anim_curve, _x_channel);
		var _chany = animcurve_get_channel(_anim_curve, _y_channel);
		
		var _xAbs = _x_target - __x;
		var _yAbs = _y_target - __y;
		
		__zoomTime = lerp(__zoomTime, 1, 1 / (_duration * __deltaTime) );
		// Aquiles and the turtle
		if (__zoomTime >= .9999) __zoomTime = 1;
		
		var _newW = __zoomW * animcurve_channel_evaluate(_chanx, __zoomTime);
		var _newH = __zoomH * animcurve_channel_evaluate(_chany, __zoomTime);
		 
		var _px = _xAbs / __w;
		var _py = _yAbs / __h;
		
		SetWH(_newW, _newH);
		
		// Calculate what the new distance from the target to the origin should be.
		var _xNew = _px * __w;
		var _yNew = _py * __h;
	
		// Set the origin based on where the object should be.
		SetXY(_x_target - _xNew, _y_target - _yNew);
		
		// less force
		if (__zoomTime >= 1) {
			__zoomEvent = false;
			__zoomTime  = 0;
			
			show_debug_message("Zoom Target Ready");
			
			return true;
		}

		return false;		
	}

	/// @ignore
	/// @param _anim_curve
	/// @param {Real} _channel
	/// @param {Real} _angle_to
	/// @param {Real} _duration
	/// @return {Bool}
	static __EventRotate = function(_anim_curve, _channel, _angle_to, _duration) {
		var _chanA = animcurve_get_channel(_anim_curve, _channel);
		__rotateTime = lerp(__rotateTime, 1, 1 / (_duration * __deltaTime) );
		// Aquiles and the turtle
		if (__rotateTime >= .9999) __rotateTime = 1;
		
		var _inter = animcurve_channel_evaluate(_chanA, __rotateTime);
		var _angle = __rotateAngle * _inter;
		
		SetAngle(_angle);
	
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
		return camera_get_view_mat(__camera);	
	}
	
	static GetProjMat = function() {
		return camera_get_proj_mat(__camera);	
	}
	
	static GetUpdateScript = function() {
		return camera_get_update_script(__camera);	
	}
	
	static GetBeginScript = function() {
		return camera_get_begin_script(__camera);	
	}
	
	static GetEndScript = function() {
		return camera_get_end_script(__camera);	
	}
	
	/// @return {Real}
	static GetX = function() {
		return __x;
	}

	/// @return {Real}
	static GetY = function() {
		return __y;	
	}
	
	/// @return {Real}
	static GetWidth = function() {
		return __w;
	}
	
	/// @return {Real}
	static GetHight = function() {
		return __h;	
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
		return camera_get_view_border_x(__camera);	
	}
	
	static GetViewBorderY = function() {
		return camera_get_view_border_y(__camera);	
	}
	
	static GetViewAngle = function() {
		return __angle;
	}
	
	static GetViewTarget = function() {
		return camera_get_view_target(__camera);	
	}
	
	/// @return {Array<Real>}
	static GetRectangle = function() {
		return [
			GetX(), 
			GetY(), 
			GetX() + GetWidth(), 
			GetY() + GetHight()
		];
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
	if !(view_enabled) {
		/// @ignore
		view_enabled = true;	
	}
	
	if (_view >= 0) SetCamera(_view);
	
	SetXY(_x, _y);
	SetWH(_width, _height);
	
	window_center();
}
	
/// @ignore
/// @desc Need to be called every step in a controller object
global.__lens_update = function() {
	var _deltaTime = (delta_time / 1000000) * game_get_speed(gamespeed_fps);
	var _len = array_length(global.__lens_events);
	
	for (var i=0; i<_len; i++) {
		var _event = global.__lens_events[i];
		
		// Check
		if (_event.alive() ) {
			// Execute Event
			if (_event.execute(_deltaTime) )  {
				_event.callback();
				array_delete(global.__lens_events, i, 1);
				_len--;
			}
		}
		else {
			array_delete(global.__lens_events, i, 1);
			_len--;
		}
	}
}

/// @ignore
global.__lens_timesource = time_source_create(time_source_global, 1, time_source_units_frames, global.__lens_update, [], -1);
time_source_start(global.__lens_timesource);