/// @param {Struct.Lens} _lens
/// @param {Function} _method
/// @param {Mixed} _arg0
/// @param {Mixed} _arg1
/// @param {Mixed} _arg2
/// @param {Mixed} _arg3
/// @param {Mixed} _arg4
/// @param {Mixed} _arg5
/// @param {Mixed} _arg6
/// @param {Function} _callback
/// @ignore
function __LensEvent(_lens, _method, _arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _callback) constructor {
	// Reference
	id = weak_ref_create(_lens);
	
	// Execute event
	event = _method;
	arg0 = _arg0;
	arg1 = _arg1;
	arg2 = _arg2;
	arg3 = _arg3;
	arg4 = _arg4;
	arg5 = _arg5;
	arg6 = _arg6;
	
	// Executes a function when the event ends
	callback = _callback ?? function() {};
}
