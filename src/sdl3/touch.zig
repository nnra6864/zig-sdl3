//! Touch Support (SDL_touch.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// A unique ID for a touch device.
///
/// This ID is valid for the time the device is connected to the system, and is
/// never reused for the lifetime of the application.
///
/// The value 0 is an invalid ID.
pub const TouchId = enum(u64) { invalid = 0, _ };

/// A unique ID for a single finger on a touch device.
///
/// This ID is valid for the time the finger (stylus, etc) is touching and will
/// be unique for all fingers currently in contact, so this ID tracks the
/// lifetime of a single continuous touch. This value may represent an index, a
/// pointer, or some other unique ID, depending on the platform.
///
/// The value 0 is an invalid ID.
pub const FingerId = enum(u64) { invalid = 0, _ };

/// An enum that describes the type of a touch device.
pub const TouchDeviceType = enum(c_int) {
    invalid = -1,
    /// touch screen with window-relative coordinates
    direct,
    /// trackpad with absolute device coordinates
    indirect_absolute,
    /// trackpad with screen cursor-relative coordinates
    indirect_relative,
};

/// Data about a single finger in a multitouch event.
///
/// Each touch event is a collection of fingers that are simultaneously in
/// contact with the touch device (so a "touch" can be a "multitouch," in
/// reality), and this struct reports details of the specific fingers.
pub const Finger = extern struct {
    /// the finger ID
    id: FingerId,
    /// the x-axis location of the touch event, normalized (0...1)
    x: f32,
    /// the y-axis location of the touch event, normalized (0...1)
    y: f32,
    /// the quantity of pressure applied, normalized (0...1)
    pressure: f32,
};

/// The `MouseId` for mouse events simulated with touch input.
pub const touch_mouseid: sdl.MouseId = @fromBackingInt(@intCast(std.math.maxInt(u32)));

/// The `TouchId` for touch events simulated with mouse input.
pub const mouse_touchid: TouchId = @fromBackingInt(@intCast(std.math.maxInt(u64)));

/// Get a list of registered touch devices.
///
/// On some platforms SDL first sees the touch device if it was actually used.
/// Therefore the returned list might be empty, although devices are available.
/// After using all devices at least once the number will be correct.
///
/// The returned value should be freed with `free` when it is no longer needed.
pub fn getTouchDevices() Error![]TouchId {
    var count: c_int = undefined;
    const ptr = SDL_GetTouchDevices(&count) orelse return makeError();
    return ptr[0..@intCast(count)];
}
extern fn SDL_GetTouchDevices(count: ?*c_int) ?[*]TouchId;

/// Get the touch device name as reported from the driver.
pub fn getTouchDeviceName(touchID: TouchId) Error![:0]const u8 {
    const str = SDL_GetTouchDeviceName(touchID) orelse return makeError();
    return std.mem.span(str);
}
extern fn SDL_GetTouchDeviceName(touchID: TouchId) ?[*:0]const u8;

/// Get the type of the given touch device.
pub const getTouchDeviceType = SDL_GetTouchDeviceType;
extern fn SDL_GetTouchDeviceType(touchID: TouchId) TouchDeviceType;

/// Get a list of active fingers for a given touch device.
///
/// The returned value should be freed with `free` when it is no longer needed.
pub fn getTouchFingers(touchID: TouchId) Error![]*Finger {
    var count: c_int = undefined;
    const ptr = SDL_GetTouchFingers(touchID, &count) orelse return makeError();
    return ptr[0..@intCast(count)];
}
extern fn SDL_GetTouchFingers(touchID: TouchId, count: ?*c_int) ?[*]*Finger;
