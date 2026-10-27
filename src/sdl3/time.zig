//! Date and Time (SDL_time.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// A structure holding a calendar date and time broken down into its
/// components.
pub const DateTime = extern struct {
    /// Year
    year: c_int,
    /// Month [01-12]
    month: c_int,
    /// Day of the month [01-31]
    day: c_int,
    /// Hour [0-23]
    hour: c_int,
    /// Minute [0-59]
    minute: c_int,
    /// Seconds [0-60]
    second: c_int,
    /// Nanoseconds [0-999999999]
    nanosecond: c_int,
    /// Day of the week [0-6] (0 being Sunday)
    day_of_week: c_int,
    /// Seconds east of UTC
    utc_offset: c_int,
};

/// The preferred date format of the current system locale.
pub const DateFormat = enum(c_int) {
    /// Year/Month/Day
    yyyymmdd = 0,
    /// Day/Month/Year
    ddmmyyyy = 1,
    /// Month/Day/Year
    mmddyyyy = 2,
};

/// The preferred time format of the current system locale.
pub const TimeFormat = enum(c_int) {
    /// 24 hour time
    @"24hr" = 0,
    /// 12 hour time
    @"12hr" = 1,
};

/// Gets the current preferred date and time format for the system locale.
///
/// This might be a "slow" call that has to query the operating system. It's
/// best to ask for this once and save the results. However, the preferred
/// formats can change, usually because the user has changed a system
/// preference outside of your program.
pub fn getDateTimeLocalePreferences() Error!struct { date_format: DateFormat, time_format: TimeFormat } {
    var date_format: DateFormat = undefined;
    var time_format: TimeFormat = undefined;
    if (!SDL_GetDateTimeLocalePreferences(&date_format, &time_format)) return makeError();
    return .{ .date_format = date_format, .time_format = time_format };
}
extern fn SDL_GetDateTimeLocalePreferences(dateFormat: ?*DateFormat, timeFormat: ?*TimeFormat) bool;

/// Gets the current value of the system realtime clock in nanoseconds since
/// Jan 1, 1970 in Universal Coordinated Time (UTC).
pub fn getCurrentTime() Error!sdl.Time {
    var ticks: sdl.Time = undefined;
    if (!SDL_GetCurrentTime(&ticks)) return makeError();
    return ticks;
}
extern fn SDL_GetCurrentTime(ticks: *sdl.Time) bool;

/// Converts a `Time` in nanoseconds since the epoch to a calendar time in
/// the `DateTime` format.
pub fn timeToDateTime(ticks: sdl.Time, localTime: bool) Error!DateTime {
    var dt: DateTime = undefined;
    if (!SDL_TimeToDateTime(ticks, &dt, localTime)) return makeError();
    return dt;
}
extern fn SDL_TimeToDateTime(ticks: sdl.Time, dt: *DateTime, localTime: bool) bool;

/// Converts a calendar time to a `Time` in nanoseconds since the epoch.
///
/// This function ignores the day_of_week member of the `DateTime` struct, so
/// it may remain unset.
pub fn dateTimeToTime(dt: *const DateTime) Error!sdl.Time {
    var ticks: sdl.Time = undefined;
    if (!SDL_DateTimeToTime(dt, &ticks)) return makeError();
    return ticks;
}
extern fn SDL_DateTimeToTime(dt: *const DateTime, ticks: *sdl.Time) bool;

/// Converts an SDL time into a Windows FILETIME (100-nanosecond intervals
/// since January 1, 1601).
///
/// This function fills in the two 32-bit values of the FILETIME structure.
pub const timeToWindows = SDL_TimeToWindows;
extern fn SDL_TimeToWindows(ticks: sdl.Time, dwLowDateTime: *u32, dwHighDateTime: *u32) void;

/// Converts a Windows FILETIME (100-nanosecond intervals since January 1,
/// 1601) to an SDL time.
///
/// This function takes the two 32-bit values of the FILETIME structure as
/// parameters.
pub const timeFromWindows = SDL_TimeFromWindows;
extern fn SDL_TimeFromWindows(dwLowDateTime: u32, dwHighDateTime: u32) sdl.Time;

/// Get the number of days in a month for a given year.
pub fn getDaysInMonth(year: c_int, month: c_int) Error!c_int {
    const result = SDL_GetDaysInMonth(year, month);
    if (result < 0) return makeError();
    return result;
}
extern fn SDL_GetDaysInMonth(year: c_int, month: c_int) c_int;

/// Get the day of year for a calendar date.
pub fn getDayOfYear(year: c_int, month: c_int, day: c_int) Error!c_int {
    const result = SDL_GetDayOfYear(year, month, day);
    if (result < 0) return makeError();
    return result;
}
extern fn SDL_GetDayOfYear(year: c_int, month: c_int, day: c_int) c_int;

/// Get the day of week for a calendar date.
pub fn getDayOfWeek(year: c_int, month: c_int, day: c_int) Error!c_int {
    const result = SDL_GetDayOfWeek(year, month, day);
    if (result < 0) return makeError();
    return result;
}
extern fn SDL_GetDayOfWeek(year: c_int, month: c_int, day: c_int) c_int;
