if keyboard_check(ord("Q")) {
	cam.AddAngle(-1);	
}

if keyboard_check(ord("E")) {
	cam.AddAngle(1);	
}

cam.AddX(keyboard_check(ord("A")) - keyboard_check(ord("D")));
cam.AddY(keyboard_check(ord("W")) - keyboard_check(ord("S")));


if keyboard_check(ord("P") ) {	
	lens_shake(cam, acShake);
}

lens_follow(cam, "mouse", .1, .1);
