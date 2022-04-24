lens_update();

if keyboard_check(ord("Q")) {
	cam.AddViewAngle(-1);	
}

if keyboard_check(ord("E")) {
	cam.AddViewAngle(1);	
}

cam.AddViewX(keyboard_check(ord("A")) - keyboard_check(ord("D")));
cam.AddViewY(keyboard_check(ord("W")) - keyboard_check(ord("S")));

if keyboard_check(ord("P") ) {lens_shake(cam, acShake); }
if keyboard_check(ord("O") ) {lens_zoom_target(cam, acZoom, 0, 1, mouse_x, mouse_y, 1); }

lens_follow(cam, "mouse", .5, .5);