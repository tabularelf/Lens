# Lens v1.1.1
Camera Constructor wrapper for GameMaker Studio 2.3.2+.

This is just a drop in for most of the `camera_*` functions presented in GameMaker Studio 2 as methods via a constructor, as `.PascalCase()`.
<br>It also outright removes having to supply a cameraID for every method. Leaving it down to just providing the arguments.
<br>Most of the methods are chainable as well.

## Use case:
```gml
// Creates a new Lens instance. Each instance carries its own cameraID.
cam = new Lens();
cam.SetViewCam(0).SetViewPos(32,32).SetViewSize(1280,720).Apply();
```
  
# Methods

While most of it is pretty much plug in play (without having to supply CameraID), there's a few extra methods included.

## `.GetViewSpeed()`

Returns: an array that contains the results from `.GetViewSpeedX()` and `.GetViewSpeedY()`

## `.GetCameraID()`

Returns: CameraID

## `.SetViewCamera(view_camera)`

Basically the same as `view_camera[view_num] = camID`. but internally tracks the cameraID for when `.free()` is called.

## `.Free()`

Frees the internal cameraID.

## `.GetCameraRect()`

Returns an array with ViewX, ViewY, ViewX + ViewW, ViewY + ViewH.
