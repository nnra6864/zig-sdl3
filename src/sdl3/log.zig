//! Log Handling (SDL_log.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// The maximum size of a log message prior to SDL 3.0.0 (and of messages
/// formatted by these bindings).
pub const max_log_message = 4096;

/// The predefined log categories
///
/// By default the application and gpu categories are enabled at the INFO
/// level, the assert category is enabled at the WARN level, test is enabled at
/// the VERBOSE level and all other categories are enabled at the ERROR level.
///
/// Values from `custom` onwards are free to use for application-defined
/// categories, e.g. `@enumFromInt(@intFromEnum(LogCategory.custom) + 1)`.
pub const LogCategory = enum(c_int) {
    application,
    @"error",
    assert,
    system,
    audio,
    video,
    render,
    input,
    @"test",
    gpu,

    // Reserved for future SDL library use
    reserved2,
    reserved3,
    reserved4,
    reserved5,
    reserved6,
    reserved7,
    reserved8,
    reserved9,
    reserved10,

    /// Beyond this point is reserved for application use.
    custom,
    _,
};

/// The predefined log priorities
pub const LogPriority = enum(c_int) {
    invalid,
    trace,
    verbose,
    debug,
    info,
    warn,
    @"error",
    critical,
};

/// Set the priority of all log categories.
pub const setLogPriorities = SDL_SetLogPriorities;
extern fn SDL_SetLogPriorities(priority: LogPriority) void;

/// Set the priority of a particular log category.
pub const setLogPriority = SDL_SetLogPriority;
extern fn SDL_SetLogPriority(category: LogCategory, priority: LogPriority) void;

/// Get the priority of a particular log category.
pub const getLogPriority = SDL_GetLogPriority;
extern fn SDL_GetLogPriority(category: LogCategory) LogPriority;

/// Reset all priorities to default.
///
/// This is called by `quit`.
pub const resetLogPriorities = SDL_ResetLogPriorities;
extern fn SDL_ResetLogPriorities() void;

/// Set the text prepended to log messages of a given priority.
///
/// By default `LogPriority.info` and below have no prefix, and
/// `LogPriority.warn` and higher have a prefix showing their priority, e.g.
/// "WARNING: ".
///
/// This function makes a copy of its string argument, `prefix`, so it is not
/// necessary to keep the value of `prefix` alive after the call returns.
pub fn setLogPriorityPrefix(priority: LogPriority, prefix: ?[:0]const u8) Error!void {
    if (!SDL_SetLogPriorityPrefix(priority, if (prefix) |s| s.ptr else null)) return makeError();
}
extern fn SDL_SetLogPriorityPrefix(priority: LogPriority, prefix: ?[*:0]const u8) bool;

/// Formats `fmt` with `std.fmt` into `buf`, truncating messages that don't fit.
fn formatMessage(buf: *[max_log_message]u8, comptime fmt: []const u8, args: anytype) [:0]const u8 {
    return std.fmt.bufPrintSentinel(buf, fmt, args, 0) catch {
        buf[buf.len - 1] = 0;
        return buf[0 .. buf.len - 1 :0];
    };
}

/// Log a message with `LogCategory.application` and `LogPriority.info`.
///
/// The message is formatted with `std.fmt`. Messages longer than
/// `max_log_message` bytes are truncated.
pub fn log(comptime fmt: []const u8, args: anytype) void {
    var buf: [max_log_message]u8 = undefined;
    SDL_Log("%s", formatMessage(&buf, fmt, args).ptr);
}
extern fn SDL_Log(fmt: [*:0]const u8, ...) void;

/// Log a message with `LogPriority.trace`.
pub fn logTrace(category: LogCategory, comptime fmt: []const u8, args: anytype) void {
    var buf: [max_log_message]u8 = undefined;
    SDL_LogTrace(category, "%s", formatMessage(&buf, fmt, args).ptr);
}
extern fn SDL_LogTrace(category: LogCategory, fmt: [*:0]const u8, ...) void;

/// Log a message with `LogPriority.verbose`.
pub fn logVerbose(category: LogCategory, comptime fmt: []const u8, args: anytype) void {
    var buf: [max_log_message]u8 = undefined;
    SDL_LogVerbose(category, "%s", formatMessage(&buf, fmt, args).ptr);
}
extern fn SDL_LogVerbose(category: LogCategory, fmt: [*:0]const u8, ...) void;

/// Log a message with `LogPriority.debug`.
pub fn logDebug(category: LogCategory, comptime fmt: []const u8, args: anytype) void {
    var buf: [max_log_message]u8 = undefined;
    SDL_LogDebug(category, "%s", formatMessage(&buf, fmt, args).ptr);
}
extern fn SDL_LogDebug(category: LogCategory, fmt: [*:0]const u8, ...) void;

/// Log a message with `LogPriority.info`.
pub fn logInfo(category: LogCategory, comptime fmt: []const u8, args: anytype) void {
    var buf: [max_log_message]u8 = undefined;
    SDL_LogInfo(category, "%s", formatMessage(&buf, fmt, args).ptr);
}
extern fn SDL_LogInfo(category: LogCategory, fmt: [*:0]const u8, ...) void;

/// Log a message with `LogPriority.warn`.
pub fn logWarn(category: LogCategory, comptime fmt: []const u8, args: anytype) void {
    var buf: [max_log_message]u8 = undefined;
    SDL_LogWarn(category, "%s", formatMessage(&buf, fmt, args).ptr);
}
extern fn SDL_LogWarn(category: LogCategory, fmt: [*:0]const u8, ...) void;

/// Log a message with `LogPriority.error`.
pub fn logError(category: LogCategory, comptime fmt: []const u8, args: anytype) void {
    var buf: [max_log_message]u8 = undefined;
    SDL_LogError(category, "%s", formatMessage(&buf, fmt, args).ptr);
}
extern fn SDL_LogError(category: LogCategory, fmt: [*:0]const u8, ...) void;

/// Log a message with `LogPriority.critical`.
pub fn logCritical(category: LogCategory, comptime fmt: []const u8, args: anytype) void {
    var buf: [max_log_message]u8 = undefined;
    SDL_LogCritical(category, "%s", formatMessage(&buf, fmt, args).ptr);
}
extern fn SDL_LogCritical(category: LogCategory, fmt: [*:0]const u8, ...) void;

/// Log a message with the specified category and priority.
pub fn logMessage(category: LogCategory, priority: LogPriority, comptime fmt: []const u8, args: anytype) void {
    var buf: [max_log_message]u8 = undefined;
    SDL_LogMessage(category, priority, "%s", formatMessage(&buf, fmt, args).ptr);
}
extern fn SDL_LogMessage(category: LogCategory, priority: LogPriority, fmt: [*:0]const u8, ...) void;

/// The prototype for the log output callback function.
///
/// This function is called by SDL when there is new text to be logged. A mutex
/// is held so that this function is never called by more than one thread at
/// once.
pub const LogOutputFunction = *const fn (
    userdata: ?*anyopaque,
    category: LogCategory,
    priority: LogPriority,
    message: [*:0]const u8,
) callconv(.c) void;

/// Get the default log output function.
pub const getDefaultLogOutputFunction = SDL_GetDefaultLogOutputFunction;
extern fn SDL_GetDefaultLogOutputFunction() LogOutputFunction;

/// Get the current log output function.
pub fn getLogOutputFunction() struct { callback: LogOutputFunction, userdata: ?*anyopaque } {
    var callback: LogOutputFunction = undefined;
    var userdata: ?*anyopaque = undefined;
    SDL_GetLogOutputFunction(&callback, &userdata);
    return .{ .callback = callback, .userdata = userdata };
}
extern fn SDL_GetLogOutputFunction(callback: ?*LogOutputFunction, userdata: ?*?*anyopaque) void;

/// Replace the default log output function with one of your own.
pub const setLogOutputFunction = SDL_SetLogOutputFunction;
extern fn SDL_SetLogOutputFunction(callback: LogOutputFunction, userdata: ?*anyopaque) void;
