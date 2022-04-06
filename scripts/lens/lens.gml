#macro __LENS_VERSION "1.1.0"
#macro __LENS_CREDITS "@TabularElf - https://tabelf.link/"
show_debug_message("Lens " + __LENS_VERSION + " initalized! Created by " + __LENS_CREDITS); 

/// @func lens([view_camera], [x], [y], [width], [height])
/// @param [view_camera]
/// @param [x]
/// @param [y]
/// @param [width]
/// @param [height]
function Lens(_view = -1, _x = 0, _y = 0, _width = room_width, _height = room_height) constructor {
	__camID = camera_create();
	__currentView = -1;
	__x = _x;
	__y = _y;
	__width = _width;
	__height = _height;
	__angle = 0;
	__xspeed = 0;
	__yspeed = 0;
	
	// Force visibility
	if !(view_enabled) {
		view_enabled = true;	
	}
	
	if (_view >= 0) {
		SetViewCamera(_view);	
	}
	
	SetViewPos(_x, _y);
	SetViewSize(_width, _height);
	
	static Free = function() {
		SetViewCamera(-1);
		camera_destroy(__camID);
	}
	
	static GetCameraID = function() {
		return __camID;	
	}
	
	static SetViewCamera = function(_view) {
		if (__currentView != -1) {
			view_camera[__currentView] = -1;	
		}
		
		__currentView = _view;
		if (_view >= 0) {
			view_camera[_view] = __camID;
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
	
	static SetViewPos = function(_x, _y) {
		__x = _x;
		__y = _y;
		camera_set_view_pos(__camID, _x, _y);
		return self;
	}	
	
	static AddViewX = function(_x) {
		__x += _x;
		camera_set_view_pos(__camID, __x, __y);
		return self;
	}	
	
	static AddViewY = function(_y) {
		__y += _y;
		camera_set_view_pos(__camID, __x, __y);
		return self;
	}	
	
	static SetViewSize = function(_w, _h) {
		__width = _w;
		__height = _h;
		camera_set_view_size(__camID, __width, __height);
		return self;
	}	
	
	static SetViewWidth = function(_w) {
		__width = _w;	
		camera_set_view_size(__camID, __width, __height);
		return self;
	}
	
	static SetViewHeight = function(_w) {
		__width = _w;	
		camera_set_view_size(__camID, __width, __height);
		return self;
	}
	
	static SetViewSpeed = function(_xSpeed, _ySpeed) {
		__xspeed = _xSpeed;
		__yspeed = _ySpeed;
		camera_set_view_speed(__camID, __xspeed, __yspeed);
		return self;
	}	
	
	static AddViewXSpeed = function(_xSpeed) {
		__xspeed = _xSpeed;
		camera_set_view_speed(__camID, __xspeed, __yspeed);
		return self;
	}	
	
	static AddViewYSpeed = function(_ySpeed) {
		__yspeed = _ySpeed;
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
		return [GetViewXSpeed(), GetViewYSpeed()];
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
}
