//lens_update();

if keyboard_check(ord("Q")) {
	cam.AddAngle(-1);	
}

if keyboard_check(ord("E")) {
	cam.AddAngle(1);	
}

cam.AddX(keyboard_check(ord("A")) - keyboard_check(ord("D")));
cam.AddY(keyboard_check(ord("W")) - keyboard_check(ord("S")));

if keyboard_check(ord("P") ) {lens_shake(cam, acLensShake); }
if keyboard_check(ord("O") ) {lens_zoom_target(cam, acLensZoom, 0, 1, mouse_x, mouse_y, 30); }
if keyboard_check(ord("I") ) {lens_rotate_to(cam, acLensZoom); }

