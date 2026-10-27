//! Platform Detection (SDL_platform.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");

/// Get the name of the platform.
///
/// Here are the names returned for some (but not all) supported platforms:
///
/// - "Windows"
/// - "macOS"
/// - "Linux"
/// - "iOS"
/// - "Android"
pub fn getPlatform() [:0]const u8 {
    const str = SDL_GetPlatform();
    return std.mem.span(str);
}
extern fn SDL_GetPlatform() [*:0]const u8;
