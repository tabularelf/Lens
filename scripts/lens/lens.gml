#macro __LENS_VERSION "1.1.1"
#macro __LENS_CREDITS "@TabularElf - https://tabelf.link/"
show_debug_message("Lens " + __LENS_VERSION + " initalized! Created by " + __LENS_CREDITS); 

global.__lens_events = [];

/// @desc Need to be called every step in a controller object
function lens_update() {
	for (var i=0, len=array_length(global.__lens_events); i<len; i++) {
		var _lens = global.__lens_events[i];
		if (weak_ref_alive(_lens.id) ) {
			var _ready = _lens.event(_lens.arg0, _lens.arg1, _lens.arg2, _lens.arg3, _lens.arg4, _lens.arg5, _lens.arg6);
			if (_ready) {
				array_delete(global.__lens_events, i, 1);
				len--;					
			}
		}
		else {
			array_delete(global.__lens_events, i, 1);
			len--;
		}
	}
}

/// @param lens_id
/// @param animation_curve
/// @param [channel_x]
/// @param [channel_y]
/// @param [distance_x]
/// @param [distance_y]
/// @param [time]
/// @param [force]
function lens_shake(_lens, _anim, _channel_x=0, _channel_y=1, _dist_x, _dist_y, _time, _force) {
	if (!_lens.__shake_event) {
		// Agregar a la lista de eventos
		array_push(global.__lens_events, {
			id: weak_ref_create(_lens), event: method(_lens, _lens.__EventShake),
			arg0: _anim,   arg1: _channel_x, arg2: _channel_y,
			arg3: _dist_x, arg4: _dist_y,
			arg5:   _time, arg6:  _force
		});
		
		_lens.__shake_event = true;
	}
}

/// @param lens_id
/// @param targets
/// @param amount_x
/// @param amount_y
/// @param [div_x]
/// @param [div_y]
function lens_follow(_lens, _targets, _amount_x, _amount_y, _xdiv=2, _ydiv=2) {
	if (!_lens.__follow_event) {
		array_push(global.__lens_events, {
			id: weak_ref_create(_lens), event: method(_lens, _lens.__EventFollow),
			arg0: _amount_x, arg1: _amount_y,
			arg2: _xdiv,	 arg3: _ydiv,
			arg4: undefined, arg5: undefined, arg6: undefined
		});
		
		_lens.__follow_event = true;
		
		if (is_array(_targets) ) {
			_lens.__follow_targets = _targets;
		}
		else {
			_lens.__follow_targets = [_targets];
		}
	}
}

/// @param lens_id
/// @param instance
function lens_follow_add(_lens, _instance) {
	array_push(_lens.__follow_targets, _instance);
}

/// @param lens_id
/// @param animation_curve
/// @param [channel_x]
/// @param [channel_y]
/// @param [focus_x]
/// @param [focus_y]
/// @param [time]
function lens_zoom_target(_lens, _anim, _channel_x=0, _channel_y=1, _fx, _fy, _time) {
	if (!_lens.__zoom_event) {
		array_push(global.__lens_events, {
			id: weak_ref_create(_lens), event: method(_lens, _lens.__EventZoomTarget),
			arg0: _anim,		arg1: _channel_x,
			arg2: _channel_y,	arg3: _fx,
			arg4: _fy,			arg5: _time, arg6: undefined
		});	
			
		_lens.__zoom_event = true;
		_lens.__zoom_w = _lens. __width;
		_lens.__zoom_h = _lens.__height;
	}
}

/// @func lens([view_camera], [x], [y], [width], [height])
/// @param [view_camera]
/// @param [x]
/// @param [y]
/// @param [width]
/// @param [height]
function Lens(_view = -1, _x = 0, _y = 0, _width = room_width, _height = room_height) constructor {
	#region PRIVATE
	__camID = camera_create();
	__currentView = -1;
	__x = _x;
	__y = _y;
	__width = _width;
	__height = _height;
	__angle = 0;
	__xspeed = 0;
	__yspeed = 0;
	
	// -- shake event
	__shake_event = false;
	__shake_time  = 0;	// The time to end the shake event

	// -- follow event
	__follow_event  = false;
	__follow_enable = true;
	__follow_targets = [];
	
	// -- zoom event
	__zoom_event = false;
	__zoom_time = 0;
	
	__zoom_force = 1;
	__zoom_w =  __width;
	__zoom_h = __height;
	
	
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
		__width = _w;
		__height = _h;
		camera_set_view_size(__camID, __width, __height);
		return self;
	}	

	/// @param width	
	static SetViewW = function(_w) {
		__width = _w;	
		camera_set_view_size(__camID, __width, __height);
		return self;
	}
	
	/// @param height
	static SetViewH = function(_h) {
		__height = _h;	
		camera_set_view_size(__camID, __width, __height);
		return self;
	}
	
	/// @param width
	static AddViewW = function(_w) {
		__width += _w;
		camera_set_view_size(__camID, __width, __height);
		return self;			
	}
	
	/// @param height
	static AddViewH = function(_h) { 
		__height += _h;
		camera_set_view_size(__camID, __width, __height);
		return self;		
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
	/// @param channel_X
	/// @param channel_y
	/// @param distance_x
	/// @param distance_y
	/// @param time=.5
	/// @param force=1
	static __EventShake  = function(_anim, _channel_x, _channel_y, _dist_x=5, _dist_y=5, _time=.5, _force=120) { 
		var _x = _dist_x;
		var _y = _dist_y;
		
		__shake_time = lerp(__shake_time, 1, 1 / (_time * game_get_speed(gamespeed_fps) ) );
		// Paradoja de tor
		if (__shake_time >= .9999) __shake_time = 1;
		
		var _chanx = animcurve_get_channel(_anim, _channel_x);	
		var _chany = animcurve_get_channel(_anim, _channel_y);
		
		var _xoff = animcurve_channel_evaluate(_chanx, __shake_time);
		var _yoff = animcurve_channel_evaluate(_chany, __shake_time);
		
		_x += _xoff * _force
		_y += _xoff * _force
		
		AddViewXY(_x, _y);
		
		// less force
		if (__shake_time >= 1) {
			__shake_event = false;
			__shake_time  = 0;
			
			show_debug_message("Shake Ready");
			
			return true;
		}

		return false;
	}

	/// @param [amount_x]
	/// @param [amount_y]
	/// @param [div_x]
	/// @param [div_y]
	static __EventFollow = function(_amount_x=.5, _amount_y=.5, _xdiv=2, _ydiv=2) {
		// Disable follow
		if (!__follow_enable) return true;
		
		var _camX=__x, _camY=__y, _x=0, _y=0;
		
		var _len = array_length(__follow_targets);
		var i = 0; repeat(_len) {
			var in = __follow_targets[i++];
			
			if (is_string(in) && in=="mouse") {
				_x += window_mouse_get_x();
				_y += window_mouse_get_y();
			}
			else {	// Normal
				if (instance_exists(in) ) {
					_x += in.x;
					_y += in.y;
				}
				else array_delete(__follow_targets, i--, 1);
			}
		}
		
		var _tx = (_x / _len) - (__width  / _xdiv);
		var _ty = (_y / _len) - (__height / _ydiv);
		
		_x = clamp(_tx, 0, room_width  -  __width);
		_y = clamp(_ty, 0, room_height - __height);
	
		_camX = lerp(_camX, _x, _amount_x);
		_camY = lerp(_camY, _y, _amount_y);

		SetViewPos(_camX, _camY);
	}

	/// @param animation_curve
	/// @param channel_X
	/// @param channel_y
	/// @param target_x
	/// @param target_y
	/// @param time=.5
	static __EventZoomTarget = function(_anim, _channel_x, _channel_y, _tx, _ty, _time) {
		var _chanx = animcurve_get_channel(_anim, _channel_x);
		var _chany = animcurve_get_channel(_anim, _channel_y);
		
		var _xabs = _tx - __x;
		var _yabs = _ty - __y;
		
		__zoom_time = lerp(__zoom_time, 1, 1 / (_time * game_get_speed(gamespeed_fps) ) );
		// Paradoja de tor
		if (__zoom_time >= .9999) __zoom_time = 1;
		
		var _newW = __zoom_w * animcurve_channel_evaluate(_chanx, __zoom_time);
		var _newH = __zoom_h * animcurve_channel_evaluate(_chany, __zoom_time);
		 
		var _px = _tx /  __width;
		var _py = _ty / __height;
		
		SetViewSize(_newW, _newH);
		
		// Calculate what the new distance from the target to the origin should be.
		var _xnew = _px *  __width;
		var _ynew = _py * __height;
	
		// Set the origin based on where the object should be.
		SetViewPos(_tx - _xnew, _ty - _ynew);
		
		// less force
		if (__zoom_time >= 1) {
			__zoom_event = false;
			__zoom_time  = 0;
			
			show_debug_message("Zoom Target Ready");
			
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
	
	#endregion

	// Force visibility
	if !(view_enabled) view_enabled = true;	
	if (_view >= 0) SetViewCamera(_view);
	
	SetViewPos(_x, _y);
	SetViewSize(_width, _height);	
}



