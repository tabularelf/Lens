//Feather ignore all
/// @param {Real} [view]
/// @param {Real} [x]
/// @param {Real} [y]
/// @param {Real} [width]
/// @param {Real} [height]
/// @returns {Struct.Lens}
function Lens(_view=-1, _x=0, _y=0, _width=room_width, _height=room_height) constructor 
{
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
	__xSpeed = 0;
	/// @ignore
	__ySpeed = 0;
	/// @ignore Local delta time
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
	
	static free = function() 
	{
		setCamera(-1);
		camera_destroy(__camera);
	}
	
	/// @returns {Id.Camera}
	static getCamera = function() 
	{
		return __camera;	
	}
	
	/// @param {Real}	view_index
	/// @returns {Struct.Lens}
	static setCamera = function(_view_index) 
	{
		__view = _view_index;
		// Check
		if (__view <= -1) 
		{
			view_camera [__view] = undefined;	
			view_visible[__view] = false;
		}
		else
		{
			view_camera [_view_index] = __camera;
			view_visible[_view_index] = true;
		}
		
		return self;
	}
	
	/// @returns {Struct.Lens}
	static apply = function() 
	{
		camera_apply(__camera);	
		return self;
	}
	
	/// @param	{Array}	matrix
	/// @returns {Struct.Lens}
	static setMatrix = function(_matrix) 
	{
		camera_set_view_mat(__camera, _matrix);
		return self;
	}	

	/// @param	{Array}	matrix
	/// @returns {Struct.Lens}
	static setProjection = function(_matrix) 
	{
		camera_set_proj_mat(__camera, _matrix);
		return self;
	}	
	
	/// @param {Function}	begin_function
	/// @returns {Struct.Lens}	
	static setBeginScript = function(_script) 
	{
		camera_set_begin_script(__camera, _script);
		return self;
	}	
	
	/// @param {Function}	update_function
	/// @returns {Struct.Lens}	
	static setUpdateScript = function(_script) 
	{
		camera_set_update_script(__camera, _script);
		return self;
	}	

	/// @param {Function}	end_function
	/// @returns {Struct.Lens}	
	static setEndScript = function(_script) 
	{
		camera_set_end_script(__camera, _script);
		return self;
	}	
	
	#region Position
	/// @param {Real}	x
	/// @param {Real}	[y]	default to y=x
	/// @returns {Struct.Lens}	
	static setXY = function(_x, _y=_x) 
	{
		__x = _x;
		__y = _y;
		camera_set_view_pos(__camera, _x, _y);
		return self;
	}	

	/// @param {Real}	x
	/// @returns {Struct.Lens}	
	static setX = function(_x) 
	{
		__x = _x;
		camera_set_view_pos(__camera, __x, __y);
		return self;
	}

	/// @param {Real}	y
	/// @returns {Struct.Lens}		
	static setY = function(_y) 
	{
		__y = _y;
		camera_set_view_pos(__camera, __x, __y);
		return self; 
	}
	
	/// @param {Real}	add_x	
	/// @param {Real}	[add_y]	default to y=x
	/// @returns {Struct.Lens}	
	static addXY = function(_x, _y=_x) 
	{
		__x += _x;
		__y += _y;
		
		camera_set_view_pos(__camera, __x, __y);		
		return self;
	}
	
	/// @param	{Real}	add_x
	/// @returns {Struct.Lens}	
	static addX = function(_x) 
	{
		__x += _x;
		camera_set_view_pos(__camera, __x, __y);
		return self;
	}	
	
	/// @param	{Real}	add_y
	/// @returns {Struct.Lens}	
	static addY = function(_y) 
	{
		__y += _y;
		camera_set_view_pos(__camera, __x, __y);
		return self;
	}	

	#endregion

	#region Size
	/// @param {Real}	width	
	/// @param {Real}	[height] default to height=width
	/// @returns {Struct.Lens}	
	static setWH = function(_w, _h=_w) 
	{
		__w = _w;
		__h = _h;
		__relation = (__w / __h);
		
		camera_set_view_size(__camera, __w, __h);
		
		return self;
	}
	
	/// @param {Real}	width
	/// @returns {Struct.Lens}	
	static setW = function(_w) 
	{
		__w = _w;
		
		__relation = (__w / __h);
		camera_set_view_size(__camera, __w, __h);
		
		return self;
	}
	
	/// @param {Real}	height
	/// @returns {Struct.Lens}	
	static setH = function(_h) 
	{
		__h = _h;
		
		__relation = (__w / __h);
		camera_set_view_size(__camera, __w, __h);
		
		return self;
	}
	
	/// @param {Real}	add_width	
	/// @param {Real}	[add_height] default to height=width	
	/// @returns {Struct.Lens}
	static addWH = function(_w, _h=_w) 
	{
		__w += _w;
		__h += _h;
		__relation = (__w / __h);
		
		camera_set_view_size(__camera, __w, __h);
		
		return self;
	}
	
	/// @param {Real}	add_width
	/// @returns {Struct.Lens}
	static addW = function(_w) 
	{
		__w += _w;
		
		__relation = (__w / __h);
		camera_set_view_size(__camera, __w, __h);
		
		return self;
	}
	
	/// @param {Real}	add_height
	/// @returns {Struct.Lens}
	static addH = function(_h) 
	{ 
		__h += _h;
		
		__relation = (__w / __h);	
		camera_set_view_size(__camera, __w, __h);
		
		return self;
	}
	
	#endregion
	
	/// @param	{Real}	x_speed
	/// @param	{Real}	y_speed
	/// @returns {Struct.Lens}
	static setSpeed = function(_x_speed, _y_speed) 
	{
		__xSpeed = _x_speed;
		__ySpeed = _y_speed;
		camera_set_view_speed(__camera, __xSpeed, __ySpeed);
		return self;
	}	

	/// @param	{Real}	x_speed
	/// @returns {Struct.Lens}	
	static addSpeedX = function(_x_speed) 
	{
		__xSpeed += _x_speed;
		camera_set_view_speed(__camera, __xSpeed, __ySpeed);
		return self;
	}	

	/// @param	{Real}	y_speed
	/// @returns {Struct.Lens}	
	static addSpeedY = function(_y_speed) 
	{
		__ySpeed += _y_speed;
		camera_set_view_speed(__camera, __xSpeed, __ySpeed);
		return self;
	}	

	/// @param	{Real}	x_border
	/// @param	{Real}	y_border	
	/// @returns {Struct.Lens}
	static setBorder = function(_x_border, _y_border) 
	{
		camera_set_view_border(__camera, _x_border, _y_border);
		return self;
	}	

	/// @param	{Real}	angle
	/// @returns {Struct.Lens}	
	static setAngle = function(_angle) 
	{
		__angle = _angle;
		camera_set_view_angle(__camera, _angle);
		return self;
	}	

	/// @param	{Real}	angle
	/// @returns {Struct.Lens}
	static addAngle = function(_angle) 
	{
		__angle += _angle;
		camera_set_view_angle(__camera, __angle);
		return self;
	}	

	/// @param	{Id.Instance}	instance_id
	/// @returns {Struct.Lens}
	static SetTarget = function(_id) 
	{
		camera_set_view_target(__camera, _id);
		return self;
	}
	
	#region Events
	
		#region Shake
		/// @ignore
		/// @param {Array}	arguments
		/// @desc	arguments values:
		///			* animcurve
		///			* x_channel, y_channel
		///			* x_amount , y_amount
		///			* duration
		/// @return {Bool}
		static __eventShake = function(_args) 
		{	
			__update();
			//Feather ignore GM1061 once
			var _animcurve = _args[0];	
			__shakeTime += _args[5] * __deltaTime;
				
			var _chanX = animcurve_get_channel(_animcurve, _args[1] );	
			var _chanY = animcurve_get_channel(_animcurve, _args[2] );
		
			var _shX = animcurve_channel_evaluate(_chanX, __shakeTime) * _args[3];
			var _shY = animcurve_channel_evaluate(_chanY, __shakeTime) * _args[4];
	
			// Shake view
			addXY(_shX, _shY);
			
			// Ready
			if (__shakeTime >= 1) 
			{
				__shakeEvent = false;
				__shakeTime  = 0;
				
				if (LENS_DEBUG) show_debug_message("Lens Event: Shake Ready");
			
				return true;
			}

			return false;
		}
	
		/// @return {Bool}
		static isShaking = function() 
		{
			return (__shakeEvent);
		}
		
		#endregion
		
		#region Follow Event Simple
		/// @ignore
		/// @param	{Array}	arguments
		/// @desc	arguments values:
		///			* x_amount  , y_amount
		///			* x_division, y_division
		static __eventFollow = function(_args) 
		{
			//Feather ignore GM1061 once
			// Disable follow
			if (!__followEnable) return true;
			
			__update();
			var _x_amount = _args[0];
			var _y_amount = _args[1];
			
			var _x_division = _args[2];
			var _y_division = _args[3];
			
			var _camX = 0;
			var _camY = 0;
		
			__followX = 0;
			__followY = 0;
		
			#region Get Average
			var len = array_length(__followTargets);
			for (var i=0; i<len; i++) 
			{
				var ins = __followTargets[i];
				
				if (is_string(ins) ) 
				{
					#region Special cases
					switch (ins) 
					{
						case "mouse":
						#region Mouse
							if (len == 1) 
							{
								var _ww = window_get_width();
								var _wh = window_get_height();
								var _mx = window_mouse_get_x();
								var _my = window_mouse_get_y();

								var _inBorders =    ( _mx < 128)
												 || ( _mx > _ww - 128)
						 
												 || ( _my < 128)
												 || ( _my > _wh - 128);
								
								// Only mouse
								if (!_inBorders) continue;				
								var _dir = point_direction(_ww / 2, _wh / 2, _mx, _my);

								__followX += lengthdir_x(32, _dir);
								__followY += lengthdir_y(32, _dir);						
							}
							else 
							{
								// with other targets
								__followX = mouse_x - (__w / _x_division);
								__followY = mouse_y - (__h / _y_division);
							}
						#endregion	
						break;
					}
					#endregion
				}
				else 
				{
					#region Instances and Other Lens
					if (instance_exists(ins) ) 
					{
						__followX += ins.x - (__w / _x_division);
						__followY += ins.y - (__h / _y_division);
					}
					else 
					{
						if (is_lens(ins) )
						{
							__followX += ins.__x - (__w / _x_division);
							__followY += ins.__y - (__h / _y_division);		
						}
						else
						{
							array_delete(__followTargets, i, 1);
							len--;
						}
					}
					
					#endregion
				}
			}
			
			// Media
			__followX /= len;
			__followY /= len;

			#endregion
			
			// Depende si se usan los limites
			if (__followBoundUseX) __followX = clamp(__followX, 0, __followBoundX - __w);
			if (__followBoundUseY) __followY = clamp(__followY, 0, __followBoundY - __h);

			_camX = lerp(__x, __followX, _x_amount * __deltaTime);
			_camY = lerp(__y, __followY, _y_amount * __deltaTime);

			setXY(round(_camX), round(_camY) );
		}

		/// @param {Real} x_bound
		/// @param {Real} y_bound	
		/// @desc Set which limits the Follow event cannot go (default room_width, room_height)
		/// @returns {Struct.Lens}
		static setFollowBounds = function(_x_bound, _y_bound) 
		{
			__followBoundX = _x_bound;
			__followBoundY = _y_bound;
			return self;
		}
	
		/// @param {Bool} use_x_bound
		/// @param {Bool} use_y_bound	
		/// @desc Choose which follow event limits to use (default __followBoundX and __followBoundY) 		
		/// @returns {Struct.Lens}
		static setFollowBoundsUse = function(_x_bound, _y_bound) 
		{
			__followBoundUseX = _x_bound;
			__followBoundUseY = _y_bound;
			return self;
		}
	
		/// @param {Id.Instance, String} ins...
		/// @returns {Struct.Lens}	
		static addFollowTarget = function(_ins) 
		{
			if (argument_count > 1) 
			{
				var i=0; repeat(argument_count) addFollowTarget(argument[i++] );
			}
			else 
			{
				array_push(__followTargets, argument0);
			}
		
			return self;
		}
	
		/// @return {Bool}
		static isFollowing = function() 
		{
			return (__followEvent)			
		}
	
		#endregion
	
		#region Zoom
		/// @ignore
		/// @param arguments
		/// @desc	arguments values:
		///			* animcurve
		///			* x_channel, y_channel
		///			* x_target , y_target
		///			* duration
		/// @return {Bool}	
		static __eventZoomTarget = function(_args) 
		{
			var _chanx = animcurve_get_channel(_args[0], _args[1] );
			var _chany = animcurve_get_channel(_args[0], _args[2] );
			__zoomTime += 1 / (_args[5] * __deltaTime);
		
			var _xAbs = _args[3] - __x;
			var _yAbs = _args[4] - __y;
			var _newW = __zoomW * animcurve_channel_evaluate(_chanx, __zoomTime);
			var _newH = __zoomH * animcurve_channel_evaluate(_chany, __zoomTime);
		 
			var _px = _xAbs / __w;
			var _py = _yAbs / __h;
		
			setWH(_newW, _newH);
		
			// Calculate what the new distance from the target to the origin should be.
			var _xNew = _px * __w;
			var _yNew = _py * __h;
	
			// Set the origin based on where the object should be.
			setXY(_args[3] - _xNew, _args[4] - _yNew);
		
			// less force
			if (__zoomTime >= 1) 
			{
				__zoomEvent = false;
				__zoomTime  = 0;
				if (LENS_DEBUG) show_debug_message("Lens Event: Zoom Target Ready");
				
				return true;
			}

			return false;		
		}		
		
		static isZooming = function() 
		{
			return (__zoomEvent );
		}
		
		#endregion
		
		#region Rotate		
		/// @ignore
		/// @param arguments
		/// @desc	arguments values:
		///			* animcurve
		///			* channel, angle_to
		///			* duration
		/// @return {Bool}
		static __eventRotate = function(_args) 
		{
			var _chanA = animcurve_get_channel(_args[0], _args[1] );
			__rotateTime += 1 / (_args[3] * __deltaTime);

			var _inter = animcurve_channel_evaluate(_chanA, __rotateTime);
			var _angle = __rotateAngle * _inter;
		
			setAngle(_angle);
	
			if (__rotateTime >= 1) 
			{
				__rotateEvent = false;
				__rotateTime = 0;
				if (LENS_DEBUG) show_debug_message("Lens Event: Rotate ready");

				return true;
			}
		
			return false;
		}
		
		/// @return {Bool}
		static isRotating = function()
		{
			return (__rotateEvent);	
		}
		
		#endregion
		
	#endregion
	
	#region Get
	static getMatrix = function() 
	{
		return camera_get_view_mat(__camera);	
	}
	
	static getProjection = function() 
	{
		return camera_get_proj_mat(__camera);	
	}

	static getBeginScript  = function() 
	{
		return camera_get_begin_script(__camera);	
	}

	static getUpdateScript = function() 
	{
		return camera_get_update_script(__camera);	
	}

	static getEndScript = function() 
	{
		return camera_get_end_script(__camera);	
	}
	
	/// @return {Real}
	static getX = function() 
	{
		return __x;
	}

	/// @return {Real}
	static getY = function() 
	{
		return __y;	
	}
	
	/// @return {Real}
	static getWidth = function() 
	{
		return __w;
	}
	
	/// @return {Real}
	static getHeight = function() 
	{
		return __h;	
	}
	
	static getSpeedX = function() 
	{
		return __xspeed;	
	}
	
	static getSpeedY = function() 
	{
		return __yspeed;	
	}
	
	static getSpeed = function() 
	{
		return [getSpeedX(), getSpeedY()];
	}
	
	static getBorderX = function() 
	{
		return camera_get_view_border_x(__camera);	
	}
	
	static getBorderY = function() 
	{
		return camera_get_view_border_y(__camera);	
	}
	
	static getAngle = function() 
	{
		return __angle;
	}
	
	static getTarget = function() 
	{
		return camera_get_view_target(__camera);	
	}
	
	static getRectangle = function() 
	{
		var _w = GetWidth ();
		var _h = GetHeight();
		return {
			x1: other.__x,	
			y1: other.__y,
			
			x2: self.x1 + _w,
			y2: self.y1 + _h,
			
			width : _w,
			height: _h
		}
	}
	
	#endregion
	
	#region Misq
	/// @return {String}
	static toString = function() 
	{
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
	
	static __update = function()
	{
		setCamera(__view);
		return self;
	}
	
	#endregion
	
	#endregion

	// Force visibility
	if !(view_enabled) {
		/// @ignore
		view_enabled = true;	
	}
	
	if (_view >= 0) setCamera(_view);
	
	setXY(_x, _y);
	setWH(_width, _height);
	
	window_center();
}