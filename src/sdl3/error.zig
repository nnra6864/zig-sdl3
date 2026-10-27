//! Error Handling (SDL_error.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;

/// Set the SDL error message for the current thread.
///
/// Calling this function will replace any previous error message that was set.
///
/// The message is formatted with `std.fmt`. Messages longer than
/// `sdl.max_log_message` bytes are truncated.
///
/// This function always returns `error.SdlError`, since SDL frequently uses
/// false to signify a failing result, leading to this idiom:
///
/// ```zig
/// if (error_code != 0) {
///     return sdl.setError("This operation has failed: {d}", .{error_code});
/// }
/// ```
pub fn setError(comptime fmt: []const u8, args: anytype) Error {
    var buf: [sdl.max_log_message]u8 = undefined;
    const message = std.fmt.bufPrintSentinel(&buf, fmt, args, 0) catch blk: {
        buf[buf.len - 1] = 0;
        break :blk buf[0 .. buf.len - 1 :0];
    };
    _ = SDL_SetError("%s", message.ptr);
    return error.SdlError;
}
extern fn SDL_SetError(fmt: [*:0]const u8, ...) bool;

/// Set an error indicating that memory allocation failed.
///
/// This function does not do any memory allocation.
///
/// This function always returns `error.SdlError`.
pub fn outOfMemory() Error {
    _ = SDL_OutOfMemory();
    return error.SdlError;
}
extern fn SDL_OutOfMemory() bool;

/// Retrieve a message about the last error that occurred on the current
/// thread.
///
/// It is possible for multiple errors to occur before calling `getError`.
/// Only the last error is returned.
///
/// The message is only applicable when an SDL function has signaled an error.
/// You must check the return values of SDL function calls to determine when to
/// appropriately call `getError`. You should *not* use the results of
/// `getError` to decide if an error has occurred! Sometimes SDL will set
/// an error string even when reporting success.
///
/// SDL will *not* clear the error string for successful API calls. You *must*
/// check return values for failure cases before you can assume the error
/// string applies.
///
/// Error strings are set per-thread, so an error set in a different thread
/// will not interfere with the current thread's operation.
///
/// The returned value is a thread-local string which will remain valid until
/// the current thread's error string is changed. The caller should make a copy
/// if the value is needed after the next SDL API call.
///
/// Returns an empty string if there hasn't been an error message set since
/// the last call to `clearError`.
pub fn getError() [:0]const u8 {
    return std.mem.span(SDL_GetError());
}
extern fn SDL_GetError() [*:0]const u8;

/// Clear any previous error message for this thread.
pub fn clearError() void {
    _ = SDL_ClearError();
}
extern fn SDL_ClearError() bool;
