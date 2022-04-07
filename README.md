# Lens v1.1.1
Camera Constructor wrapper for GameMaker Studio 2.3.2+.

This is just a drop in for most of the `camera_*` functions presented in GameMaker Studio 2 as methods via a constructor, as `.camelCase()`.
<br>It also outright removes having to supply a cameraID for every method. Leaving it down to just providing the arguments.
<br>Most of the methods are chainable as well.

## Use case:
```gml
// Creates a new Lens instance. Each instance carries its own cameraID.
cam = new lens();
cam.setViewCam(0).setViewPos(32,32).setViewSize(1280,720).apply();
```
  
# Methods

While most of it is pretty much plug in play (without having to supply CameraID), there's a few extra methods included.

## `.getViewSpeed()`

Returns: an array that contains the results from `.getViewSpeedX()` and `.getViewSpeedY()`

## `.getCameraID()`

Returns: CameraID

## `.setViewCamera(view_camera)`

Basically the same as `view_camera[view_num] = camID`. but internally tracks the cameraID for when `.free()` is called.

## `.free()`

Frees the internal cameraID.

## `.getCameraRect()`

Returns an array with ViewX, ViewY, ViewX + ViewW, ViewY + ViewH.
