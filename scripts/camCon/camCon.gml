function camCon() constructor {
	camID = camera_create();
	
	static getCamID = function() {
		return camID;	
	}
	
	static apply = function() {
		camera_apply(camID);	
	}
	
	static setViewMat = function() {
		
	}	
}