//! Pen Support (SDL_pen.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// SDL pen instance IDs.
///
/// Zero is used to signify an invalid/null device.
///
/// These show up in pen events when SDL sees input from them. They remain
/// consistent as long as SDL can recognize a tool to be the same pen; but if a
/// pen's digitizer table is physically detached from the computer, it might
/// get a new ID when reconnected, as SDL won't know it's the same device.
///
/// These IDs are only stable within a single run of a program; the next time a
/// program is run, the pen's ID will likely be different, even if the hardware
/// hasn't been disconnected, etc.
pub const PenId = enum(u32) { invalid = 0, _ };

/// The `MouseId` for mouse events simulated with pen input.
pub const pen_mouseid: sdl.MouseId = @fromBackingInt(@intCast(std.math.maxInt(u32) - 1));

/// The `TouchId` for touch events simulated with pen input.
pub const pen_touchid: sdl.TouchId = @fromBackingInt(@intCast(std.math.maxInt(u64) - 1));

/// Pen input flags, as reported by various pen events' `pen_state` field.
pub const PenInputFlags = packed struct(u32) {
    /// pen is pressed down
    down: bool = false,
    /// button 1 is pressed
    button_1: bool = false,
    /// button 2 is pressed
    button_2: bool = false,
    /// button 3 is pressed
    button_3: bool = false,
    /// button 4 is pressed
    button_4: bool = false,
    /// button 5 is pressed
    button_5: bool = false,
    __unused6: u24 = 0,
    /// eraser tip is used
    eraser_tip: bool = false,
    /// pen is in proximity
    in_proximity: bool = false,
};

/// Pen axis indices.
///
/// These are the valid values for the `axis` field in `PenAxisEvent`. All
/// axes are either normalised to 0..1 or report a (positive or negative) angle
/// in degrees, with 0.0 representing the centre. Not all pens/backends support
/// all axes: unsupported axes are always zero.
///
/// To convert angles for tilt and rotation into vector representation, use
/// `sinf` on the XTILT, YTILT, or ROTATION component, for example:
///
/// ``sinf`(xtilt * SDL_PI_F / 180.0)`.
pub const PenAxis = enum(c_int) {
    /// Pen pressure.  Unidirectional: 0 to 1.0
    pressure,
    /// Pen horizontal tilt angle.  Bidirectional: -90.0 to 90.0 (left-to-right).
    xtilt,
    /// Pen vertical tilt angle.  Bidirectional: -90.0 to 90.0 (top-to-down).
    ytilt,
    /// Pen distance to drawing surface.  Unidirectional: 0.0 to 1.0
    distance,
    /// Pen barrel rotation.  Bidirectional: -180 to 179.9 (clockwise, 0 is facing up, -180.0 is facing down).
    rotation,
    /// Pen finger wheel or slider (e.g., Airbrush Pen).  Unidirectional: 0 to 1.0
    slider,
    /// Pressure from squeezing the pen ("barrel pressure").
    tangential_pressure,
    /// Total known pen axis types in this version of SDL. This number may grow in future releases!
    count,
};

/// An enum that describes the type of a pen device.
///
/// A "direct" device is a pen that touches a graphic display (like an Apple
/// Pencil on an iPad's screen). "Indirect" devices touch an external tablet
/// surface that is connected to the machine but is not a display (like a
/// lower-end Wacom tablet connected over USB).
///
/// Apps may use this information to decide if they should draw a cursor; if
/// the pen is touching the screen directly, a cursor doesn't make sense and
/// can be in the way, but becomes necessary for indirect devices to know where
/// on the display they are interacting.
pub const PenDeviceType = enum(c_int) {
    /// Not a valid pen device.
    invalid = -1,
    /// Don't know specifics of this pen.
    unknown,
    /// Pen touches display.
    direct,
    /// Pen touches something that isn't the display.
    indirect,
};

/// Get the device type of the given pen.
///
/// Many platforms do not supply this information, so an app must always be
/// prepared to get an `PenDeviceType.unknown` result.
pub fn getPenDeviceType(instance_id: PenId) Error!PenDeviceType {
    const result = SDL_GetPenDeviceType(instance_id);
    if (result == .invalid) return makeError();
    return result;
}
extern fn SDL_GetPenDeviceType(instance_id: PenId) PenDeviceType;
