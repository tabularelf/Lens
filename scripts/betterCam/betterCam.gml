/// @func betterCam([view_camera])
/// @param [view_camera]

function betterCam(_view = -1) constructor {
	camID = camera_create();
	currentView = -1;
	
	if (_view != -1) {
		setViewCam(_view);	
	}
	
	static free = function() {
		setViewCam(-1);
		camera_destroy(camID);
	}
	
	static getCamID = function() {
		return camID;	
	}
	
	static setViewCam = function(_view) {
		if (currentView != -1) {
			view_camera[currentView] = -1;	
		}
		
		currentView = _view;
		view_camera[_view] = camID;	
		return self;
	}
	
	static apply = function() {
		camera_apply(camID);	
		return self;
	}
	
	static setViewMat = function(_matrix) {
		camera_set_view_mat(camID, _matrix);
		return self;
	}	
	
	static setProjMat = function(_matrix) {
		camera_set_proj_mat(camID, _matrix);
		return self;
	}	
	
	static setUpdateScript = function(_script) {
		camera_set_update_script(camID, _script);
		return self;
	}	
	
	static setBeginScript = function(_script) {
		camera_set_begin_script(camID, _script);
		return self;
	}	
	
	static setEndScript = function(_script) {
		camera_set_end_script(camID, _script);
		return self;
	}	
	
	static setViewPos = function(_x, _y) {
		camera_set_view_pos(camID, _x, _y);
		return self;
	}	
	
	static setViewSize = function(_x, _y) {
		camera_set_view_size(camID, _x, _y);
		return self;
	}	
	
	static setViewSpeed = function(_xSpeed, _ySpeed) {
		camera_set_view_speed(camID, _xSpeed, _ySpeed);
		return self;
	}	
	
	static setViewBorder = function(_xBorder, _yBorder) {
		camera_set_view_border(camID, _xBorder, _yBorder);
		return self;
	}	
	
	static setViewAngle = function(_angle) {
		camera_set_view_angle(camID, _angle);
		return self;
	}	
	
	static setViewTarget = function(_id) {
		camera_set_view_target(camID, _id);
		return self;
	}
	
	static getViewMat = function() {
		return camera_get_view_mat(camID);	
	}
	
	static getProjMat = function() {
		return camera_get_proj_mat(camID);	
	}
	
	static getUpdateScript = function() {
		return camera_get_update_script(camID);	
	}
	
	static getBeginScript = function() {
		return camera_get_begin_script(camID);	
	}
	
	static getEndScript = function() {
		return camera_get_end_script(camID);	
	}
	
	static getViewX = function() {
		return camera_get_view_x(camID);	
	}
	
	static getViewY = function() {
		return camera_get_view_y(camID);	
	}
	
	static getViewWidth = function() {
		return camera_get_view_width(camID);	
	}
	
	static getViewHeight = function() {
		return camera_get_view_height(camID);	
	}
	
	static getViewSpeedX = function() {
		return camera_get_view_speed_x(camID);	
	}
	
	static getViewSpeedY = function() {
		return camera_get_view_speed_y(camID);	
	}
	
	static getViewSpeed = function() {
		return [getViewXSpeed(), getViewYSpeed()];
	}
	
	static getViewBorderX = function() {
		return camera_get_view_border_x(camID);	
	}
	
	static getViewBorderY = function() {
		return camera_get_view_border_y(camID);	
	}
	
	static getViewAngle = function() {
		return camera_get_view_angle(camID);	
	}
	
	static getViewTarget = function() {
		return camera_get_view_target(camID);	
	}
	
	static getCameraRect = function() {
		return [getViewX(), getViewY(), getViewBorderX(), getViewBorderY()];
	}
}