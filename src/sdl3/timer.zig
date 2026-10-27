//! Timer Support (SDL_timer.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// Number of milliseconds in a second.
///
/// This is always 1000.
pub const ms_per_second: u64 = 1000;

/// Number of microseconds in a second.
///
/// This is always 1000000.
pub const us_per_second: u64 = 1000000;

/// Number of nanoseconds in a second.
///
/// This is always 1000000000.
pub const ns_per_second: u64 = 1000000000;

/// Number of nanoseconds in a millisecond.
///
/// This is always 1000000.
pub const ns_per_ms: u64 = 1000000;

/// Number of nanoseconds in a microsecond.
///
/// This is always 1000.
pub const ns_per_us: u64 = 1000;

/// Convert seconds to nanoseconds.
///
/// This only converts whole numbers, not fractional seconds.
pub fn secondsToNS(s: u64) u64 {
    return s * ns_per_second;
}

/// Convert nanoseconds to seconds.
///
/// This performs a division, so the results can be dramatically different if
/// `ns` is an integer or floating point value.
pub fn nsToSeconds(ns: u64) u64 {
    return ns / ns_per_second;
}

/// Convert milliseconds to nanoseconds.
///
/// This only converts whole numbers, not fractional milliseconds.
pub fn msToNS(ms: u64) u64 {
    return ms * ns_per_ms;
}

/// Convert nanoseconds to milliseconds.
pub fn nsToMS(ns: u64) u64 {
    return ns / ns_per_ms;
}

/// Convert microseconds to nanoseconds.
///
/// This only converts whole numbers, not fractional microseconds.
pub fn usToNS(us: u64) u64 {
    return us * ns_per_us;
}

/// Convert nanoseconds to microseconds.
pub fn nsToUS(ns: u64) u64 {
    return ns / ns_per_us;
}

/// Get the number of milliseconds that have elapsed since the SDL library
/// initialization.
pub const getTicks = SDL_GetTicks;
extern fn SDL_GetTicks() u64;

/// Get the number of nanoseconds since SDL library initialization.
pub const getTicksNS = SDL_GetTicksNS;
extern fn SDL_GetTicksNS() u64;

/// Get the current value of the high resolution counter.
///
/// This function is typically used for profiling.
///
/// The counter values are only meaningful relative to each other. Differences
/// between values can be converted to times by using
/// `getPerformanceFrequency`.
pub const getPerformanceCounter = SDL_GetPerformanceCounter;
extern fn SDL_GetPerformanceCounter() u64;

/// Get the count per second of the high resolution counter.
pub const getPerformanceFrequency = SDL_GetPerformanceFrequency;
extern fn SDL_GetPerformanceFrequency() u64;

/// Wait a specified number of milliseconds before returning.
///
/// This function waits a specified number of milliseconds before returning. It
/// waits at least the specified time, but possibly longer due to OS
/// scheduling.
pub const delay = SDL_Delay;
extern fn SDL_Delay(ms: u32) void;

/// Wait a specified number of nanoseconds before returning.
///
/// This function waits a specified number of nanoseconds before returning. It
/// waits at least the specified time, but possibly longer due to OS
/// scheduling.
pub const delayNS = SDL_DelayNS;
extern fn SDL_DelayNS(ns: u64) void;

/// Wait a specified number of nanoseconds before returning.
///
/// This function waits a specified number of nanoseconds before returning. It
/// will attempt to wait as close to the requested time as possible, busy
/// waiting if necessary, but could return later due to OS scheduling.
pub const delayPrecise = SDL_DelayPrecise;
extern fn SDL_DelayPrecise(ns: u64) void;

/// Definition of the timer ID type.
pub const TimerId = enum(u32) { invalid = 0, _ };

/// Function prototype for the millisecond timer callback function.
///
/// The callback function is passed the current timer interval and returns the
/// next timer interval, in milliseconds. If the returned value is the same as
/// the one passed in, the periodic alarm continues, otherwise a new alarm is
/// scheduled. If the callback returns 0, the periodic alarm is canceled and
/// will be removed.
pub const TimerCallback = *const fn (userdata: ?*anyopaque, timerID: TimerId, interval: u32) callconv(.c) u32;

/// Call a callback function at a future time.
///
/// The callback function is passed the current timer interval and the user
/// supplied parameter from the `addTimer` call and should return the next
/// timer interval. If the value returned from the callback is 0, the timer is
/// canceled and will be removed.
///
/// The callback is run on a separate thread, and for short timeouts can
/// potentially be called before this function returns.
///
/// Timers take into account the amount of time it took to execute the
/// callback. For example, if the callback took 250 ms to execute and returned
/// 1000 (ms), the timer would only wait another 750 ms before its next
/// iteration.
///
/// Timing may be inexact due to OS scheduling. Be sure to note the current
/// time with `getTicksNS` or `getPerformanceCounter` in case your
/// callback needs to adjust for variances.
pub fn addTimer(interval: u32, callback: TimerCallback, userdata: ?*anyopaque) Error!TimerId {
    const result = SDL_AddTimer(interval, callback, userdata);
    if (@backingInt(result) == 0) return makeError();
    return result;
}
extern fn SDL_AddTimer(interval: u32, callback: TimerCallback, userdata: ?*anyopaque) TimerId;

/// Function prototype for the nanosecond timer callback function.
///
/// The callback function is passed the current timer interval and returns the
/// next timer interval, in nanoseconds. If the returned value is the same as
/// the one passed in, the periodic alarm continues, otherwise a new alarm is
/// scheduled. If the callback returns 0, the periodic alarm is canceled and
/// will be removed.
pub const NSTimerCallback = *const fn (userdata: ?*anyopaque, timerID: TimerId, interval: u64) callconv(.c) u64;

/// Call a callback function at a future time.
///
/// The callback function is passed the current timer interval and the user
/// supplied parameter from the `addTimerNS` call and should return the
/// next timer interval. If the value returned from the callback is 0, the
/// timer is canceled and will be removed.
///
/// The callback is run on a separate thread, and for short timeouts can
/// potentially be called before this function returns.
///
/// Timers take into account the amount of time it took to execute the
/// callback. For example, if the callback took 250 ns to execute and returned
/// 1000 (ns), the timer would only wait another 750 ns before its next
/// iteration.
///
/// Timing may be inexact due to OS scheduling. Be sure to note the current
/// time with `getTicksNS` or `getPerformanceCounter` in case your
/// callback needs to adjust for variances.
pub fn addTimerNS(interval: u64, callback: NSTimerCallback, userdata: ?*anyopaque) Error!TimerId {
    const result = SDL_AddTimerNS(interval, callback, userdata);
    if (@backingInt(result) == 0) return makeError();
    return result;
}
extern fn SDL_AddTimerNS(interval: u64, callback: NSTimerCallback, userdata: ?*anyopaque) TimerId;

/// Remove a timer created with `addTimer`.
pub fn removeTimer(id: TimerId) Error!void {
    if (!SDL_RemoveTimer(id)) return makeError();
}
extern fn SDL_RemoveTimer(id: TimerId) bool;
