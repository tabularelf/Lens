if keyboard_check(ord("Q")) {
	cam.AddViewAngle(-1);	
}

if keyboard_check(ord("E")) {
	cam.AddViewAngle(1);	
}

cam.AddViewX(keyboard_check(ord("A")) - keyboard_check(ord("D")));
cam.AddViewY(keyboard_check(ord("W")) - keyboard_check(ord("S")));
