//! Camera (SDL_camera.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// This is a unique ID for a camera device for the time it is connected to the
/// system, and is never reused for the lifetime of the application.
///
/// If the device is disconnected and reconnected, it will get a new ID.
///
/// The value 0 is an invalid ID.
pub const CameraId = enum(u32) { invalid = 0, _ };

/// The opaque structure used to identify an opened SDL camera.
pub const Camera = opaque {
    pub const open = openCamera;
    pub const getPermissionState = getCameraPermissionState;
    pub const getId = getCameraId;
    pub const getProperties = getCameraProperties;
    pub const getFormat = getCameraFormat;
    pub const acquireFrame = acquireCameraFrame;
    pub const releaseFrame = releaseCameraFrame;
    pub const close = closeCamera;
};

/// The details of an output format for a camera device.
///
/// Cameras often support multiple formats; each one will be encapsulated in
/// this struct.
pub const CameraSpec = extern struct {
    /// Frame format
    format: sdl.PixelFormat,
    /// Frame colorspace
    colorspace: sdl.Colorspace,
    /// Frame width
    width: c_int,
    /// Frame height
    height: c_int,
    /// Frame rate numerator ((num / denom) == FPS, (denom / num) == duration in seconds)
    framerate_numerator: c_int,
    /// Frame rate denominator ((num / denom) == FPS, (denom / num) == duration in seconds)
    framerate_denominator: c_int,
};

/// The current state of a request for camera access.
pub const CameraPermissionState = enum(c_int) {
    /// The user denied access to the camera.
    denied = -1,
    /// Still waiting for the user to respond.
    pending = 0,
    /// The camera is approved for use.
    approved = 1,
    _,
};

/// The position of camera in relation to system device.
pub const CameraPosition = enum(c_int) {
    unknown,
    front_facing,
    back_facing,
};

/// Use this function to get the number of built-in camera drivers.
///
/// This function returns a hardcoded number. This never returns a negative
/// value; if there are no drivers compiled into this build of SDL, this
/// function returns zero. The presence of a driver in this list does not mean
/// it will function, it just means SDL is capable of interacting with that
/// interface. For example, a build of SDL might have v4l2 support, but if
/// there's no kernel support available, SDL's v4l2 driver would fail if used.
///
/// By default, SDL tries all drivers, in its preferred order, until one is
/// found to be usable.
pub const getNumCameraDrivers = SDL_GetNumCameraDrivers;
extern fn SDL_GetNumCameraDrivers() c_int;

/// Use this function to get the name of a built in camera driver.
///
/// The list of camera drivers is given in the order that they are normally
/// initialized by default; the drivers that seem more reasonable to choose
/// first (as far as the SDL developers believe) are earlier in the list.
///
/// The names of drivers are all simple, low-ASCII identifiers, like "v4l2",
/// "coremedia" or "android". These never have Unicode characters, and are not
/// meant to be proper names.
pub fn getCameraDriver(index: c_int) ?[:0]const u8 {
    const str = SDL_GetCameraDriver(index) orelse return null;
    return std.mem.span(str);
}
extern fn SDL_GetCameraDriver(index: c_int) ?[*:0]const u8;

/// Get the name of the current camera driver.
///
/// The names of drivers are all simple, low-ASCII identifiers, like "v4l2",
/// "coremedia" or "android". These never have Unicode characters, and are not
/// meant to be proper names.
pub fn getCurrentCameraDriver() ?[:0]const u8 {
    const str = SDL_GetCurrentCameraDriver() orelse return null;
    return std.mem.span(str);
}
extern fn SDL_GetCurrentCameraDriver() ?[*:0]const u8;

/// Get a list of currently connected camera devices.
///
/// The returned value should be freed with `free` when it is no longer needed.
pub fn getCameras() Error![]CameraId {
    var count: c_int = undefined;
    const ptr = SDL_GetCameras(&count) orelse return makeError();
    return ptr[0..@intCast(count)];
}
extern fn SDL_GetCameras(count: ?*c_int) ?[*]CameraId;

/// Get the list of native formats/sizes a camera supports.
///
/// This returns a list of all formats and frame sizes that a specific camera
/// can offer. This is useful if your app can accept a variety of image formats
/// and sizes and so want to find the optimal spec that doesn't require
/// conversion.
///
/// This function isn't strictly required; if you call `openCamera` with a
/// null spec, SDL will choose a native format for you, and if you instead
/// specify a desired format, it will transparently convert to the requested
/// format on your behalf.
///
/// If `count` is not null, it will be filled with the number of elements in
/// the returned array.
///
/// Note that it's legal for a camera to supply an empty list. This is what
/// will happen on Emscripten builds, since that platform won't tell _anything_
/// about available cameras until you've opened one, and won't even tell if
/// there _is_ a camera until the user has given you permission to check
/// through a scary warning popup.
///
/// The returned value should be freed with `free` when it is no longer needed.
pub fn getCameraSupportedFormats(instance_id: CameraId) Error![]*CameraSpec {
    var count: c_int = undefined;
    const ptr = SDL_GetCameraSupportedFormats(instance_id, &count) orelse return makeError();
    return ptr[0..@intCast(count)];
}
extern fn SDL_GetCameraSupportedFormats(instance_id: CameraId, count: ?*c_int) ?[*]*CameraSpec;

/// Get the human-readable device name for a camera.
pub fn getCameraName(instance_id: CameraId) Error![:0]const u8 {
    const str = SDL_GetCameraName(instance_id) orelse return makeError();
    return std.mem.span(str);
}
extern fn SDL_GetCameraName(instance_id: CameraId) ?[*:0]const u8;

/// Get the position of the camera in relation to the system.
///
/// Most platforms will report UNKNOWN, but mobile devices, like phones, can
/// often make a distinction between cameras on the front of the device (that
/// points towards the user, for taking "selfies") and cameras on the back (for
/// filming in the direction the user is facing).
pub const getCameraPosition = SDL_GetCameraPosition;
extern fn SDL_GetCameraPosition(instance_id: CameraId) CameraPosition;

/// Open a video recording device (a "camera").
///
/// You can open the device with any reasonable spec, and if the hardware can't
/// directly support it, it will convert data seamlessly to the requested
/// format. This might incur overhead, including scaling of image data.
///
/// If you would rather accept whatever format the device offers, you can pass
/// a null spec here and it will choose one for you (and you can use
/// `Surface`'s conversion/scaling functions directly if necessary).
///
/// You can call `getCameraFormat` to get the actual data format if passing
/// a null spec here. You can see the exact specs a device can support without
/// conversion with `getCameraSupportedFormats`.
///
/// SDL will not attempt to emulate framerate; it will try to set the hardware
/// to the rate closest to the requested speed, but it won't attempt to limit
/// or duplicate frames artificially; call `getCameraFormat` to see the
/// actual framerate of the opened the device, and check your timestamps if
/// this is crucial to your app!
///
/// Note that the camera is not usable until the user approves its use! On some
/// platforms, the operating system will prompt the user to permit access to
/// the camera, and they can choose Yes or No at that point. Until they do, the
/// camera will not be usable. The app should either wait for an
/// `EventType.camera_device_approved` (or `EventType.camera_device_denied`) event,
/// or poll `getCameraPermissionState` occasionally until it returns
/// non-zero. On platforms that don't require explicit user approval (and
/// perhaps in places where the user previously permitted access), the approval
/// event might come immediately, but it might come seconds, minutes, or hours
/// later!
pub fn openCamera(instance_id: CameraId, spec: ?*const CameraSpec) Error!*Camera {
    return SDL_OpenCamera(instance_id, spec) orelse makeError();
}
extern fn SDL_OpenCamera(instance_id: CameraId, spec: ?*const CameraSpec) ?*Camera;

/// Query if camera access has been approved by the user.
///
/// Cameras will not function between when the device is opened by the app and
/// when the user permits access to the hardware. On some platforms, this
/// presents as a popup dialog where the user has to explicitly approve access;
/// on others the approval might be implicit and not alert the user at all.
///
/// This function can be used to check the status of that approval. It will
/// return `CameraPermissionState.pending` if waiting for user response,
/// `CameraPermissionState.approved` if the camera is approved for use, and
/// `CameraPermissionState.denied` if the user denied access.
///
/// Instead of polling with this function, you can wait for a
/// `EventType.camera_device_approved` (or `EventType.camera_device_denied`) event
/// in the standard SDL event loop, which is guaranteed to be sent once when
/// permission to use the camera is decided.
///
/// If a camera is declined, there's nothing to be done but call
/// `closeCamera` to dispose of it.
pub const getCameraPermissionState = SDL_GetCameraPermissionState;
extern fn SDL_GetCameraPermissionState(camera: *Camera) CameraPermissionState;

/// Get the instance ID of an opened camera.
pub fn getCameraId(camera: *Camera) Error!CameraId {
    const result = SDL_GetCameraID(camera);
    if (@backingInt(result) == 0) return makeError();
    return result;
}
extern fn SDL_GetCameraID(camera: *Camera) CameraId;

/// Get the properties associated with an opened camera.
pub fn getCameraProperties(camera: *Camera) Error!sdl.PropertiesId {
    const result = SDL_GetCameraProperties(camera);
    if (@backingInt(result) == 0) return makeError();
    return result;
}
extern fn SDL_GetCameraProperties(camera: *Camera) sdl.PropertiesId;

/// Get the spec that a camera is using when generating images.
///
/// Note that this might not be the native format of the hardware, as SDL might
/// be converting to this format behind the scenes.
///
/// If the system is waiting for the user to approve access to the camera, as
/// some platforms require, this will return false, but this isn't necessarily
/// a fatal error; you should either wait for an
/// `EventType.camera_device_approved` (or `EventType.camera_device_denied`) event,
/// or poll `getCameraPermissionState` occasionally until it returns
/// non-zero.
pub fn getCameraFormat(camera: *Camera) Error!CameraSpec {
    var spec: CameraSpec = undefined;
    if (!SDL_GetCameraFormat(camera, &spec)) return makeError();
    return spec;
}
extern fn SDL_GetCameraFormat(camera: *Camera, spec: *CameraSpec) bool;

/// Acquire a frame.
///
/// The frame is a memory pointer to the image data, whose size and format are
/// given by the spec requested when opening the device.
///
/// This is a non blocking API. If there is a frame available, a non-null
/// surface is returned, and timestampNS will be filled with a non-zero value.
///
/// Note that an error case can also return null, but a null by itself is
/// normal and just signifies that a new frame is not yet available. Note that
/// even if a camera device fails outright (a USB camera is unplugged while in
/// use, etc), SDL will send an event separately to notify the app, but
/// continue to provide blank frames at ongoing intervals until
/// `closeCamera` is called, so real failure here is almost always an out
/// of memory condition.
///
/// After use, the frame should be released with `releaseCameraFrame`. If
/// you don't do this, the system may stop providing more video!
///
/// Do not call `destroySurface` on the returned surface! It must be given
/// back to the camera subsystem with `releaseCameraFrame`!
///
/// If the system is waiting for the user to approve access to the camera, as
/// some platforms require, this will return null (no frames available); you
/// should either wait for an `EventType.camera_device_approved` (or
/// `EventType.camera_device_denied`) event, or poll
/// `getCameraPermissionState` occasionally until it returns non-zero.
///
/// Returns null if no new frame is currently available.
pub fn acquireCameraFrame(camera: *Camera) ?struct { frame: *sdl.Surface, timestamp_ns: u64 } {
    var timestamp_ns: u64 = undefined;
    const frame = SDL_AcquireCameraFrame(camera, &timestamp_ns) orelse return null;
    return .{ .frame = frame, .timestamp_ns = timestamp_ns };
}
extern fn SDL_AcquireCameraFrame(camera: *Camera, timestampNS: ?*u64) ?*sdl.Surface;

/// Release a frame of video acquired from a camera.
///
/// Let the back-end re-use the internal buffer for camera.
///
/// This function _must_ be called only on surface objects returned by
/// `acquireCameraFrame`. This function should be called as quickly as
/// possible after acquisition, as SDL keeps a small FIFO queue of surfaces for
/// video frames; if surfaces aren't released in a timely manner, SDL may drop
/// upcoming video frames from the camera.
///
/// If the app needs to keep the surface for a significant time, they should
/// make a copy of it and release the original.
///
/// The app should not use the surface again after calling this function;
/// assume the surface is freed and the pointer is invalid.
pub const releaseCameraFrame = SDL_ReleaseCameraFrame;
extern fn SDL_ReleaseCameraFrame(camera: *Camera, frame: *sdl.Surface) void;

/// Use this function to shut down camera processing and close the camera
/// device.
pub const closeCamera = SDL_CloseCamera;
extern fn SDL_CloseCamera(camera: *Camera) void;
