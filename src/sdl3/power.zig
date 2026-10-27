//! Power Management Status (SDL_power.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// The basic state for the system's power supply.
///
/// These are results returned by `getPowerInfo`.
pub const PowerState = enum(c_int) {
    /// error determining power status
    @"error" = -1,
    /// cannot determine power status
    unknown,
    /// Not plugged in, running on the battery
    on_battery,
    /// Plugged in, no battery available
    no_battery,
    /// Plugged in, charging battery
    charging,
    /// Plugged in, battery charged
    charged,
};

/// Get the current power supply details.
///
/// You should never take a battery status as absolute truth. Batteries
/// (especially failing batteries) are delicate hardware, and the values
/// reported here are best estimates based on what that hardware reports. It's
/// not uncommon for older batteries to lose stored power much faster than it
/// reports, or completely drain when reporting it has 20 percent left, etc.
///
/// Battery status can change at any time; if you are concerned with power
/// state, you should call this function frequently, and perhaps ignore changes
/// until they seem to be stable for a few seconds.
///
/// It's possible a platform can only report battery percentage or time left
/// but not both.
///
/// On some platforms, retrieving power supply details might be expensive. If
/// you want to display continuous status you could call this function every
/// minute or so.
///
/// `seconds` and `percent` are -1 if they can't be determined.
pub fn getPowerInfo() Error!struct { state: PowerState, seconds: c_int, percent: c_int } {
    var seconds: c_int = undefined;
    var percent: c_int = undefined;
    const state = SDL_GetPowerInfo(&seconds, &percent);
    if (state == .@"error") return makeError();
    return .{ .state = state, .seconds = seconds, .percent = percent };
}
extern fn SDL_GetPowerInfo(seconds: ?*c_int, percent: ?*c_int) PowerState;
