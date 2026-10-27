//! GUIDs (SDL_guid.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");

/// A `GUID` is a 128-bit identifier for an input device that identifies
/// that device across runs of SDL programs on the same platform.
///
/// If the device is detached and then re-attached to a different port, or if
/// the base system is rebooted, the device should still report the same GUID.
///
/// GUIDs are as precise as possible but are not guaranteed to distinguish
/// physically distinct but equivalent devices. For example, two game
/// controllers from the same vendor with the same product ID and revision may
/// have the same GUID.
///
/// GUIDs may be platform-dependent (i.e., the same device may report different
/// GUIDs on different operating systems).
pub const GUID = extern struct {
    data: [16]u8,
};

/// Get an ASCII string representation for a given `GUID`.
///
/// `buf` should be at least 33 bytes long to hold the whole string.
pub fn guidToString(guid: GUID, buf: []u8) [:0]u8 {
    SDL_GUIDToString(guid, buf.ptr, @intCast(buf.len));
    return std.mem.sliceTo(buf[0 .. buf.len - 1 :0], 0);
}
extern fn SDL_GUIDToString(guid: GUID, pszGUID: [*]u8, cbGUID: c_int) void;

/// Convert a GUID string into a `GUID` structure.
///
/// Performs no error checking. If this function is given a string containing
/// an invalid GUID, the function will silently succeed, but the GUID generated
/// will not be useful.
pub fn stringToGUID(pchGUID: [:0]const u8) GUID {
    return SDL_StringToGUID(pchGUID.ptr);
}
extern fn SDL_StringToGUID(pchGUID: [*:0]const u8) GUID;
