//! Message Boxes (SDL_messagebox.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// Message box flags.
///
/// If supported will display warning icon, etc.
pub const MessageBoxFlags = packed struct(u32) {
    __unused0: u4 = 0,
    /// error dialog
    @"error": bool = false,
    /// warning dialog
    warning: bool = false,
    /// informational dialog
    information: bool = false,
    /// buttons placed left to right
    buttons_left_to_right: bool = false,
    /// buttons placed right to left
    buttons_right_to_left: bool = false,
    __unused9: u23 = 0,
};

/// `MessageBoxButtonData` flags.
pub const MessageBoxButtonFlags = packed struct(u32) {
    /// Marks the default button when return is hit
    returnkey_default: bool = false,
    /// Marks the default button when escape is hit
    escapekey_default: bool = false,
    __unused2: u30 = 0,
};

/// Individual button data.
pub const MessageBoxButtonData = extern struct {
    flags: MessageBoxButtonFlags,
    /// User defined button id (value returned via `showMessageBox`)
    buttonID: c_int,
    /// The UTF-8 button text
    text: ?[*:0]const u8,
};

/// RGB value used in a message box color scheme
pub const MessageBoxColor = extern struct {
    r: u8,
    g: u8,
    b: u8,
};

/// An enumeration of indices inside the colors array of
/// `MessageBoxColorScheme`.
pub const MessageBoxColorType = enum(c_int) {
    background,
    text,
    button_border,
    button_background,
    button_selected,
    /// Size of the colors array of `MessageBoxColorScheme`.
    count,
};

/// A set of colors to use for message box dialogs
pub const MessageBoxColorScheme = extern struct {
    colors: [@backingInt(MessageBoxColorType.count)]MessageBoxColor,
};

/// MessageBox structure containing title, text, window, etc.
pub const MessageBoxData = extern struct {
    flags: MessageBoxFlags,
    /// Parent window, can be null
    window: ?*sdl.Window,
    /// UTF-8 title
    title: ?[*:0]const u8,
    /// UTF-8 message text
    message: ?[*:0]const u8,
    numbuttons: c_int,
    buttons: ?[*]const MessageBoxButtonData,
    /// `MessageBoxColorScheme`, can be null to use system settings
    colorScheme: ?*const MessageBoxColorScheme,
};

/// Create a modal message box.
///
/// If your needs aren't complex, it might be easier to use
/// `showSimpleMessageBox`.
///
/// This function should be called on the thread that created the parent
/// window, or on the main thread if the messagebox has no parent. It will
/// block execution of that thread until the user clicks a button or closes the
/// messagebox.
///
/// This function may be called at any time, even before `init`. This makes
/// it useful for reporting errors like a failure to create a renderer or
/// OpenGL context.
///
/// On X11, SDL rolls its own dialog box with X11 primitives instead of a
/// formal toolkit like GTK+ or Qt.
///
/// Note that if `init` would fail because there isn't any available video
/// target, this function is likely to fail for the same reasons. If this is a
/// concern, check the return value from this function and fall back to writing
/// to stderr if you can.
///
/// Returns the id of the button the user pressed, or -1 if the dialog was
/// closed without pressing a button.
pub fn showMessageBox(messageboxdata: *const MessageBoxData) Error!c_int {
    var buttonid: c_int = undefined;
    if (!SDL_ShowMessageBox(messageboxdata, &buttonid)) return makeError();
    return buttonid;
}
extern fn SDL_ShowMessageBox(messageboxdata: *const MessageBoxData, buttonid: *c_int) bool;

/// Display a simple modal message box.
///
/// If your needs aren't complex, this function is preferred over
/// `showMessageBox`.
///
/// `flags` may be any of the following:
///
/// - `MessageBoxFlags.@"error"`: error dialog
/// - `MessageBoxFlags.warning`: warning dialog
/// - `MessageBoxFlags.information`: informational dialog
///
/// This function should be called on the thread that created the parent
/// window, or on the main thread if the messagebox has no parent. It will
/// block execution of that thread until the user clicks a button or closes the
/// messagebox.
///
/// This function may be called at any time, even before `init`. This makes
/// it useful for reporting errors like a failure to create a renderer or
/// OpenGL context.
///
/// On X11, SDL rolls its own dialog box with X11 primitives instead of a
/// formal toolkit like GTK+ or Qt.
///
/// Note that if `init` would fail because there isn't any available video
/// target, this function is likely to fail for the same reasons. If this is a
/// concern, check the return value from this function and fall back to writing
/// to stderr if you can.
pub fn showSimpleMessageBox(flags: MessageBoxFlags, title: ?[:0]const u8, message: ?[:0]const u8, window: ?*sdl.Window) Error!void {
    if (!SDL_ShowSimpleMessageBox(flags, if (title) |s| s.ptr else null, if (message) |s| s.ptr else null, window)) return makeError();
}
extern fn SDL_ShowSimpleMessageBox(flags: MessageBoxFlags, title: ?[*:0]const u8, message: ?[*:0]const u8, window: ?*sdl.Window) bool;
