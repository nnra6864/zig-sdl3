//! Assertions (SDL_assert.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");

/// Possible outcomes from a triggered assertion.
///
/// When an enabled assertion triggers, it may call the assertion handler
/// (possibly one provided by the app via `setAssertionHandler`), which will
/// return one of these values, possibly after asking the user.
///
/// Then SDL will respond based on this outcome (loop around to retry the
/// condition, try to break in a debugger, kill the program, or ignore the
/// problem).
pub const AssertState = enum(c_int) {
    /// Retry the assert immediately.
    retry,
    /// Make the debugger trigger a breakpoint.
    @"break",
    /// Terminate the program.
    abort,
    /// Ignore the assert.
    ignore,
    /// Ignore the assert from now on.
    always_ignore,
};

/// Information about an assertion failure.
///
/// This structure is filled in with information about a triggered assertion,
/// used by the assertion handler, then added to the assertion report. This is
/// returned as a linked list from `getAssertionReport`.
pub const AssertData = extern struct {
    /// true if app should always continue when assertion is triggered.
    always_ignore: bool,
    /// Number of times this assertion has been triggered.
    trigger_count: c_uint,
    /// A string of this assert's test code.
    condition: ?[*:0]const u8,
    /// The source file where this assert lives.
    filename: ?[*:0]const u8,
    /// The line in `filename` where this assert lives.
    linenum: c_int,
    /// The name of the function where this assert lives.
    function: ?[*:0]const u8,
    /// next item in the linked list.
    next: ?*const AssertData,
};

/// Never call this directly.
///
/// This is what the C `SDL_assert` macros call into, exposed for completeness.
pub fn reportAssertion(data: *AssertData, func: [:0]const u8, file: [:0]const u8, line: c_int) AssertState {
    return SDL_ReportAssertion(data, func.ptr, file.ptr, line);
}
extern fn SDL_ReportAssertion(data: *AssertData, func: [*:0]const u8, file: [*:0]const u8, line: c_int) AssertState;

/// A callback that fires when an SDL assertion fails.
pub const AssertionHandler = *const fn (data: *const AssertData, userdata: ?*anyopaque) callconv(.c) AssertState;

/// Set an application-defined assertion handler.
///
/// This function allows an application to show its own assertion UI and/or
/// force the response to an assertion failure. If the application doesn't
/// provide this, SDL will try to do the right thing, popping up a
/// system-specific GUI dialog, and probably minimizing any fullscreen windows.
///
/// This callback may fire from any thread, but it runs wrapped in a mutex, so
/// it will only fire from one thread at a time.
///
/// This callback is NOT reset to SDL's internal handler upon `quit`!
pub const setAssertionHandler = SDL_SetAssertionHandler;
extern fn SDL_SetAssertionHandler(handler: ?AssertionHandler, userdata: ?*anyopaque) void;

/// Get the default assertion handler.
///
/// This returns the function pointer that is called by default when an
/// assertion is triggered. This is an internal function provided by SDL, that
/// is used for assertions when `setAssertionHandler` hasn't been used to
/// provide a different function.
pub const getDefaultAssertionHandler = SDL_GetDefaultAssertionHandler;
extern fn SDL_GetDefaultAssertionHandler() AssertionHandler;

/// Get the current assertion handler.
///
/// This returns the function pointer that is called when an assertion is
/// triggered. This is either the value last passed to
/// `setAssertionHandler`, or if no application-specified function is set,
/// is equivalent to calling `getDefaultAssertionHandler`.
///
/// The parameter `puserdata` is a pointer to a void*, which will store the
/// "userdata" pointer that was passed to `setAssertionHandler`. This value
/// will always be null for the default handler. If you don't care about this
/// data, it is safe to pass a null pointer to this function to ignore it.
pub fn getAssertionHandler() struct { handler: AssertionHandler, userdata: ?*anyopaque } {
    var userdata: ?*anyopaque = undefined;
    const handler = SDL_GetAssertionHandler(&userdata);
    return .{ .handler = handler, .userdata = userdata };
}
extern fn SDL_GetAssertionHandler(puserdata: ?*?*anyopaque) AssertionHandler;

/// Get a list of all assertion failures.
///
/// This function gets all assertions triggered since the last call to
/// `resetAssertionReport`, or the start of the program.
///
/// The proper way to examine this data looks something like this:
///
/// ```c
/// const SDL_AssertData *item = SDL_GetAssertionReport();
/// while (item) {
///    printf("'%s', %s (%s:%d), triggered %u times, always ignore: %s.\\n",
///           item->condition, item->function, item->filename,
///           item->linenum, item->trigger_count,
///           item->always_ignore ? "yes" : "no");
///    item = item->next;
/// }
/// ```
pub const getAssertionReport = SDL_GetAssertionReport;
extern fn SDL_GetAssertionReport() ?*const AssertData;

/// Clear the list of all assertion failures.
///
/// This function will clear the list of all assertions triggered up to that
/// point. Immediately following this call, `getAssertionReport` will return
/// no items. In addition, any previously-triggered assertions will be reset to
/// a trigger_count of zero, and their always_ignore state will be false.
pub const resetAssertionReport = SDL_ResetAssertionReport;
extern fn SDL_ResetAssertionReport() void;
