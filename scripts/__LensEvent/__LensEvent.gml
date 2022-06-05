/// @param {Struct.Lens}	lens
/// @param {Function}		method
/// @param {Array}			arguments
/// @param {Function}		[end_callback]
/// @param {Array}			[end_arguments]
/// @return {Struct.__LensEvent}
/// @ignore
function __LensEvent(_lens, _method, _args=[], _callback=function() {}, _callback_args=[]) constructor 
{
	#region PRIVATE
	// Reference
	__lens = weak_ref_create(_lens);
	// Execute event
	__event = _method;
	__args  = _args;

	// Executes a function when the event ends
	__callback = _callback;
	__callback_args = _callback_args;
	#endregion
	
	#region METHOD
	/// @return {Bool}
	static alive = function() {
		return (weak_ref_alive(__lens) );
	}
	
	/// @returns {Struct.Lens}
	static get = function() {
		return (__lens.ref);	
	}
	
	/// @return {Mixed}
	static execute = function(_delta) {
		// Update local delta time.
		get().__deltaTime = _delta;
		return (__event(__args) );
	}
	
	/// @return {Mixed}
	static callback = function() {
		return (__callback(__callback_args) );
	}
	
	#endregion
}