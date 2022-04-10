#macro __LENS_VERSION "1.1.0"
#macro __LENS_CREDITS "@TabularElf - https://tabelf.link/"
show_debug_message("Lens " + __LENS_VERSION + " initalized! Created by " + __LENS_CREDITS); 

global.__lens_event = ds_list_create();

function __lens_check()  {
	if (!layer_exists("__lyrLens") ) {
		layer_script_end(layer_create(42, "__lyrLens"), __lens_update);
		show_debug_message("Layer create");
	}
}

function __lens_update() {
    if (event_type == ev_draw) {
		if (event_number == 0) {		
			for (var i=0, _size=ds_list_size(global.__lens_event); i < _size; i++) {
				var _lens = global.__lens_event[| i];
		
				// Exists reference execute event method
				if (weak_ref_alive(_lens.id) ) {
					var _ready = _lens.event(_lens.arg0, _lens.arg1, _lens.arg2, _lens.arg3, _lens.arg4, _lens.arg5, _lens.arg6);
					if (_ready) {
						ds_list_delete(global.__lens_event, i);
						_size--;				
					}
				}
				else {	// Clean
					ds_list_delete(global.__lens_event, i);
					_size--;
				}
			}	
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
	// Comprobar si existe la función de update
	__lens_check();
	
	if (!_lens.__shake_event) {
		// Agregar a la lista de eventos
		ds_list_add(global.__lens_event, {
			id: weak_ref_create(_lens), event: method(_lens, _lens.__EventShake),
			arg0: _anim,   arg1: _channel_x, arg2: _channel_y,
			arg3: _dist_x, arg4: _dist_y,
			arg5:   _time, arg6:  _force
		});
		
		_lens.__shake_event = true;
	}
}

function lens_follow(_lens, _targets, _amount_x, _amount_y, _xdiv=2, _ydiv=2) {
	// Comprobar si existe la función de update	
	__lens_check();
	
	if (!_lens.__follow_event) {
		ds_list_add(global.__lens_event, {
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
/// @param animation_curve
/// @param [channel_x]
/// @param [channel_y]
/// @param [focus_x]
/// @param [focus_y]
/// @param [time]
function lens_zoom_target(_lens, _anim, _channel_x=0, _channel_y=1, _fx, _fy, _time) {
	// Comprobar si existe la función de update	
	__lens_check();
	
	if (!_lens.__zoom_event) {
		ds_list_add(global.__lens_event, {
			id: weak_ref_create(_lens), event: method(_lens, _lens.__EventZoomTarget),
			arg0: _anim,		arg1: _channel_x,
			arg2: _channel_y,	arg2: _fx,
			arg3: _fy,			arg4: _time
		});	
			
		_lens.__zoom_event = true;	
	}
}

/// @func Lens([view_camera], [x], [y], [width], [height])
/// @param view_camera
/// @param x=0
/// @param y=0
/// @param [width]
/// @param [height]
function Lens(_view = -1, _x = 0, _y = 0, _w = room_width, _h = room_height) constructor {
	#region Private
	__camera = camera_create();
	__view   = -1;
	
	__xspeed = 0;
	__yspeed = 0;
	__angle = 0;
	
	__xborder = 0;
	__yborder = 0;
	
	__clamp = true;
	__event = false;
	
	__rel = 0;
	
	#region Shake Event
	__shake_event = false;
	__shake_time  = 0;	// The time to end the shake event
	
	#endregion
	
	#region Follow Event
	__follow_event = false;
	__follow_targets = [];
	
	#endregion
	
	#region Zoom Event
	__zoom_event = false;
	__zoom_time = 0;
	
	__zoom_force = 1;
	
	#endregion
	
	#endregion
	 
	#region Public
	// Position
	x = _x;
	y = _y;
	
	// Size
	w = _w;
	h = _h;
	
	#endregion
	
	#region Methods
	
		#region Camera
	static Apply = function() {
		camera_apply(__camera);	
		return self;
	}
	
	static Free = function() {
		SetViewCamera(-1);
		camera_destroy(__camera);
	}

	/// @param [view]
	static SetCamera = function(_view=-1) {
		if (__view <= -1) {
			view_camera [__view] = noone;	
			view_visible[__view] = false;
		}
		
		__view = _view;
		if (_view >= 0) {
			view_camera [_view] = __camera;
			view_visible[_view] = true;
		}
		
		return self;
	}
	
	/// @returns {camera}	
	static GetCamera = function() {
		return __camera;	
	}

	#endregion

	static SetMat = function(_matrix) {
		camera_set_view_mat(__camera, _matrix);
		return self;
	}	
	
	static SetProj = function(_matrix) {
		camera_set_proj_mat(__camera, _matrix);
		return self;
	}	

	static SetViewTarget = function(_id) {
		camera_set_view_target(__camera, _id);
		return self;
	}
	
		#region Scripts
	
	static SetUpdateScript = function(_script) {
		camera_set_update_script(__camera, _script);
		return self;
	}	
	
	static SetBeginScript = function(_script) {
		camera_set_begin_script(__camera, _script);
		return self;
	}	
	
	static SetEndScript = function(_script) {
		camera_set_end_script(__camera, _script);
		return self;
	}	

	/// @returns {script}
	static GetUpdateScript = function() {return (camera_get_update_script(__camera) ); }
	/// @returns {script}
	static GetBeginScript  = function() {return (camera_get_begin_script(__camera) ); }
	/// @returns {script}
	static GetEndScript = function() {return (camera_get_end_script(__camera) ); }
	
	#endregion
	
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
		
		AddXY(_x, _y);
		
		// less force
		if (__shake_time >= 1) {
			__shake_event = false;
			__shake_time  = 0;

			return true;
		}

		return false;
	}

	/// @param [amount_x]
	/// @param [amount_y]
	/// @param [div_x]
	/// @param [div_y]
	static __EventFollow = function(_amount_x=.5, _amount_y=.5, _xdiv=2, _ydiv=2) {
		var _camX=x, _camY=y, _x=0, _y=0;
		
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
		
		var _tx = (_x / _len) - (w / _xdiv);
		var _ty = (_y / _len) - (h / _ydiv);
		
		_x = clamp(_tx, 0, room_width  - w);
		_y = clamp(_ty, 0, room_height - h);
	
		_camX = lerp(_camX, _x, _amount_x);
		_camY = lerp(_camY, _y, _amount_y);

		SetXY(_camX, _camY);
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
		
		var _xabs = _tx - x;
		var _yabs = _ty - y;
		
		__zoom_time = lerp(__zoom_time, 1, 1 / _time / game_get_speed(gamespeed_fps) );
		
		var _wrel = animcurve_channel_evaluate(_chanx, __zoom_time);
		var _hrel = animcurve_channel_evaluate(_chany, __zoom_time);
		 
		var _xr = _xabs / _wrel;
		var _yr = _yabs / _hrel;
		
		SetWH(w * __zoom_time, h * __zoom_time);
		
		// Calculate what the new distance from the target to the origin should be.
		var _xnew = _wrel * _xr;
		var _ynew = _hrel * _yr;
	
		// Set the origin based on where the object should be.
		SetXY(_x - _xnew, _y - _ynew);
		
		// less force
		if (__zoom_time >= 1) {
			__zoom_event = false;
			__zoom_time  = 0;

			return true;
		}

		return false;		
	}
	
	#endregion
	
		#region XY
	/// @param x
	/// @param y
	static SetXY = function(_x, _y=_x) {
		x = _x ?? x;
		y = _y ?? y;
		camera_set_view_pos(__camera, x, y);
		
		return self;
	}	

	/// @param x
	/// @param y
	static AddXY = function(_x=0, _y=_x) {
		x += _x;
		y += _y;
		camera_set_view_pos(__camera, x, y);
		return self;
	}

	/// @returns {array}
	static GetXY = function() {return [x, y]; }
	
	#endregion
	
		#region Size
	/// @param {number} [width]
	/// @param {number} [height]
	static SetWH = function(_w, _h=_w) {
		w = _w ?? w;
		h = _h ?? h;
		
		__rel = (w / h);
	
		camera_set_view_size(__camera, w, h);
		return self;
	}	

	/// @param {number} [width]
	/// @param {number} [height]	
	static AddWH = function(_w=0, _h=_w) {
		w += _w;
		h += _h;
		
		__rel = (w / h);
		
		camera_set_view_size(__camera, w, h);
		return self;			
	}

	/// @returns {array}
	static GetWH = function() {return [w, h]; }

	#endregion
	
		#region Speed
	/// @param {number} xspeed
	/// @param {number} yspeed
	static SetSpeed = function(_x, _y=_x) {
		__xspeed = _x;
		__yspeed = _y;
		camera_set_view_speed(__camera, __xspeed, __yspeed);
		return self;
	}	
	
	/// @param {number} xspeed
	/// @param {number} yspeed
	static AddSpeed = function(_x=0, _y=_x) {
		__xspeed += _x;
		__yspeed += _y;
		camera_set_view_speed(__camera, __xspeed, __yspeed);
		return self;			
	}

	/// @returns {array}
	static GetSpeed = function() {return [__xspeed, __yspeed]; }
	
	#endregion

		#region Angle
	/// @param {number} angle
	static SetAngle = function(_angle) {
		__angle = _angle ?? __angle;
		camera_set_view_angle(__camera, __angle);
		return self;
	}	
	
	/// @param {number} angle
	static AddAngle = function(_angle=0) {
		__angle += _angle;
		camera_set_view_angle(__camera, __angle);
		return self;
	}	
		
	/// @returns {number}
	static GetAngle = function() {return (__angle ); }
	
	#endregion

		#region Border
	/// @param {number} xborder
	/// @param {number} yborder
	static SetBorder = function(_xBorder, _yBorder) {
		__xborder = _xBorder;
		__yborder = _yBorder;
		
		camera_set_view_border(__camera, __xborder, __yborder);
		return self;
	}	
	
	/// @returns {array}
	static GetBorder = function() {return [__xborder, __yborder]; }
		
	#endregion
	
		#region Getters
	static GetMat  = function() {
		return (camera_get_view_mat(__camera) );	
	}
	
	static GetProj = function() {
		return (camera_get_proj_mat(__camera) );	
	}

	static GetViewTarget = function() {
		return camera_get_view_target(__camera);	
	}
	
	/// @returns {struct}
	static GetRectangle = function() {
		return {x1: x, y1: y, x2: x + w, y2: y + h}
	}
	
	#endregion
	
	#endregion
	
	#region Start
	// Force visibility
	if !(view_enabled) view_enabled = true;	
	if ((_view >= 0) ) {
		SetCamera(_view);
	}

	SetXY(_x, _y);
	SetWH(_w, _h);
	
	#endregion
}










