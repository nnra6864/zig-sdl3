//! Clipboard Handling (SDL_clipboard.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// Put UTF-8 text into the clipboard.
pub fn setClipboardText(text: [:0]const u8) Error!void {
    if (!SDL_SetClipboardText(text.ptr)) return makeError();
}
extern fn SDL_SetClipboardText(text: [*:0]const u8) bool;

/// Get UTF-8 text from the clipboard.
///
/// This function returns an empty string if there is not enough memory left
/// for a copy of the clipboard's content.
///
/// The returned value should be freed with `free` when it is no longer needed.
///
/// Returns an empty string on failure. The returned string should be freed
/// with `free` when it is no longer needed.
pub fn getClipboardText() [:0]u8 {
    const str = SDL_GetClipboardText();
    return std.mem.span(str);
}
extern fn SDL_GetClipboardText() [*:0]u8;

/// Query whether the clipboard exists and contains a non-empty text string.
pub const hasClipboardText = SDL_HasClipboardText;
extern fn SDL_HasClipboardText() bool;

/// Put UTF-8 text into the primary selection.
pub fn setPrimarySelectionText(text: [:0]const u8) Error!void {
    if (!SDL_SetPrimarySelectionText(text.ptr)) return makeError();
}
extern fn SDL_SetPrimarySelectionText(text: [*:0]const u8) bool;

/// Get UTF-8 text from the primary selection.
///
/// This function returns an empty string if there is not enough memory left
/// for a copy of the primary selection's content.
///
/// The returned value should be freed with `free` when it is no longer needed.
///
/// Returns an empty string on failure. The returned string should be freed
/// with `free` when it is no longer needed.
pub fn getPrimarySelectionText() [:0]u8 {
    const str = SDL_GetPrimarySelectionText();
    return std.mem.span(str);
}
extern fn SDL_GetPrimarySelectionText() [*:0]u8;

/// Query whether the primary selection exists and contains a non-empty text
/// string.
pub const hasPrimarySelectionText = SDL_HasPrimarySelectionText;
extern fn SDL_HasPrimarySelectionText() bool;

/// Callback function that will be called when data for the specified mime-type
/// is requested by the OS.
///
/// The callback function is called with null as the mime_type when the
/// clipboard is cleared or new data is set. The clipboard is automatically
/// cleared in `quit`.
pub const ClipboardDataCallback = *const fn (userdata: ?*anyopaque, mime_type: ?[*:0]const u8, size: *usize) callconv(.c) ?*const anyopaque;

/// Callback function that will be called when the clipboard is cleared, or
/// when new data is set.
pub const ClipboardCleanupCallback = *const fn (userdata: ?*anyopaque) callconv(.c) void;

/// Offer clipboard data to the OS.
///
/// Tell the operating system that the application is offering clipboard data
/// for each of the provided mime-types. Once another application requests the
/// data the callback function will be called, allowing it to generate and
/// respond with the data for the requested mime-type.
///
/// The size of text data does not include any terminator, and the text does
/// not need to be null-terminated (e.g., you can directly copy a portion of a
/// document).
pub fn setClipboardData(callback: ClipboardDataCallback, cleanup: ?ClipboardCleanupCallback, userdata: ?*anyopaque, mime_types: []const [*:0]const u8) Error!void {
    if (!SDL_SetClipboardData(callback, cleanup, userdata, mime_types.ptr, mime_types.len)) return makeError();
}
extern fn SDL_SetClipboardData(callback: ClipboardDataCallback, cleanup: ?ClipboardCleanupCallback, userdata: ?*anyopaque, mime_types: [*]const [*:0]const u8, num_mime_types: usize) bool;

/// Clear the clipboard data.
pub fn clearClipboardData() Error!void {
    if (!SDL_ClearClipboardData()) return makeError();
}
extern fn SDL_ClearClipboardData() bool;

/// Get the data from the clipboard for a given mime type.
///
/// The size of text data does not include the terminator, but the text is
/// guaranteed to be null-terminated.
///
/// The returned value should be freed with `free` when it is no longer needed.
pub fn getClipboardData(mime_type: [:0]const u8) Error![]u8 {
    var size: usize = undefined;
    const ptr = SDL_GetClipboardData(mime_type.ptr, &size) orelse return makeError();
    return @as([*]u8, @ptrCast(ptr))[0..size];
}
extern fn SDL_GetClipboardData(mime_type: [*:0]const u8, size: *usize) ?*anyopaque;

/// Query whether there is data in the clipboard for the provided mime type.
pub fn hasClipboardData(mime_type: [:0]const u8) bool {
    return SDL_HasClipboardData(mime_type.ptr);
}
extern fn SDL_HasClipboardData(mime_type: [*:0]const u8) bool;

/// Retrieve the list of mime types available in the clipboard.
///
/// The returned value should be freed with `free` when it is no longer needed.
pub fn getClipboardMimeTypes() Error![][*:0]u8 {
    var num_mime_types: usize = undefined;
    const ptr = SDL_GetClipboardMimeTypes(&num_mime_types) orelse return makeError();
    return ptr[0..num_mime_types];
}
extern fn SDL_GetClipboardMimeTypes(num_mime_types: ?*usize) ?[*][*:0]u8;
