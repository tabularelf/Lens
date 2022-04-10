if keyboard_check(ord("Q")) {
	cam.AddAngle(-1);	
}

if keyboard_check(ord("E")) {
	cam.AddAngle(1);	
}

cam.AddXY(keyboard_check(ord("A")) - keyboard_check(ord("D")), keyboard_check(ord("W")) - keyboard_check(ord("S")) );

if keyboard_check(ord("P") ) {lens_shake(cam, acShake); }
if keyboard_check(ord("O") ) {lens_zoom_target(cam, acShake, 0, 1, mouse_x, mouse_y, .5); }

lens_follow(cam, "mouse", .5, .5);

