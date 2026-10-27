//! Mouse Support (SDL_mouse.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// This is a unique ID for a mouse for the time it is connected to the system,
/// and is never reused for the lifetime of the application.
///
/// If the mouse is disconnected and reconnected, it will get a new ID.
///
/// The value 0 is an invalid ID.
pub const MouseId = enum(u32) { invalid = 0, _ };

/// The structure used to identify an SDL cursor.
///
/// This is opaque data.
pub const Cursor = opaque {
    pub const create = createCursor;
    pub const createColor = createColorCursor;
    pub const createAnimated = createAnimatedCursor;
    pub const createSystem = createSystemCursor;
    pub const set = setCursor;
    pub const get = getCursor;
    pub const getDefault = getDefaultCursor;
    pub const destroy = destroyCursor;
};

/// Cursor types for `createSystemCursor`.
pub const SystemCursor = enum(c_int) {
    /// Default cursor. Usually an arrow.
    default,
    /// Text selection. Usually an I-beam.
    text,
    /// Wait. Usually an hourglass or watch or spinning ball.
    wait,
    /// Crosshair.
    crosshair,
    /// Program is busy but still interactive. Usually it's WAIT with an arrow.
    progress,
    /// Double arrow pointing northwest and southeast.
    nwse_resize,
    /// Double arrow pointing northeast and southwest.
    nesw_resize,
    /// Double arrow pointing west and east.
    ew_resize,
    /// Double arrow pointing north and south.
    ns_resize,
    /// Four pointed arrow pointing north, south, east, and west.
    move,
    /// Not permitted. Usually a slashed circle or crossbones.
    not_allowed,
    /// Pointer that indicates a link. Usually a pointing hand.
    pointer,
    /// Window resize top-left. This may be a single arrow or a double arrow like NWSE_RESIZE.
    nw_resize,
    /// Window resize top. May be NS_RESIZE.
    n_resize,
    /// Window resize top-right. May be NESW_RESIZE.
    ne_resize,
    /// Window resize right. May be EW_RESIZE.
    e_resize,
    /// Window resize bottom-right. May be NWSE_RESIZE.
    se_resize,
    /// Window resize bottom. May be NS_RESIZE.
    s_resize,
    /// Window resize bottom-left. May be NESW_RESIZE.
    sw_resize,
    /// Window resize left. May be EW_RESIZE.
    w_resize,
    count,
};

/// Scroll direction types for the Scroll event
pub const MouseWheelDirection = enum(c_int) {
    /// The scroll direction is normal
    normal,
    /// The scroll direction is flipped / natural
    flipped,
};

/// Animated cursor frame info.
pub const CursorFrameInfo = extern struct {
    /// The surface data for this frame
    surface: ?*sdl.Surface,
    /// The frame duration in milliseconds (a duration of 0 is infinite)
    duration: u32,
};

/// A bitmask of pressed mouse buttons, as reported by `getMouseState`, etc.
///
/// - Button 1: Left mouse button
/// - Button 2: Middle mouse button
/// - Button 3: Right mouse button
/// - Button 4: Side mouse button 1
/// - Button 5: Side mouse button 2
pub const MouseButtonFlags = packed struct(u32) {
    left: bool = false,
    middle: bool = false,
    right: bool = false,
    x1: bool = false,
    x2: bool = false,
    __unused5: u27 = 0,
};

/// Left mouse button index, as found in `MouseButtonEvent.button`.
pub const button_left = 1;
/// Middle mouse button index, as found in `MouseButtonEvent.button`.
pub const button_middle = 2;
/// Right mouse button index, as found in `MouseButtonEvent.button`.
pub const button_right = 3;
/// Side mouse button 1 index, as found in `MouseButtonEvent.button`.
pub const button_x1 = 4;
/// Side mouse button 2 index, as found in `MouseButtonEvent.button`.
pub const button_x2 = 5;

/// A function to convert a button index (`button_left`, ...) to its
/// `MouseButtonFlags` mask.
pub fn buttonMask(button: u8) MouseButtonFlags {
    return @bitCast(@as(u32, 1) << @intCast(button - 1));
}

/// A callback used to transform mouse motion delta from raw values.
///
/// This is called during SDL's handling of platform mouse events to scale the
/// values of the resulting motion delta.
pub const MouseMotionTransformCallback = *const fn (userdata: ?*anyopaque, timestamp: u64, window: ?*sdl.Window, mouseID: MouseId, x: *f32, y: *f32) callconv(.c) void;

/// Return whether a mouse is currently connected.
pub const hasMouse = SDL_HasMouse;
extern fn SDL_HasMouse() bool;

/// Get a list of currently connected mice.
///
/// Note that this will include any device or virtual driver that includes
/// mouse functionality, including some game controllers, KVM switches, etc.
/// You should wait for input from a device before you consider it actively in
/// use.
///
/// The returned value should be freed with `free` when it is no longer needed.
pub fn getMice() Error![]MouseId {
    var count: c_int = undefined;
    const ptr = SDL_GetMice(&count) orelse return makeError();
    return ptr[0..@intCast(count)];
}
extern fn SDL_GetMice(count: ?*c_int) ?[*]MouseId;

/// Get the name of a mouse.
///
/// This function returns "" if the mouse doesn't have a name.
pub fn getMouseNameForId(instance_id: MouseId) Error![:0]const u8 {
    const str = SDL_GetMouseNameForID(instance_id) orelse return makeError();
    return std.mem.span(str);
}
extern fn SDL_GetMouseNameForID(instance_id: MouseId) ?[*:0]const u8;

/// Get the window which currently has mouse focus.
pub const getMouseFocus = SDL_GetMouseFocus;
extern fn SDL_GetMouseFocus() ?*sdl.Window;

/// Query SDL's cache for the synchronous mouse button state and the
/// window-relative SDL-cursor position.
///
/// This function returns the cached synchronous state as SDL understands it
/// from the last pump of the event queue.
///
/// To query the platform for immediate asynchronous state, use
/// `getGlobalMouseState`.
///
/// Passing non-null pointers to `x` or `y` will write the destination with
/// respective x or y coordinates relative to the focused window.
///
/// In Relative Mode, the SDL-cursor's position usually contradicts the
/// platform-cursor's position as manually calculated from
/// `getGlobalMouseState` and `getWindowPosition`.
pub const getMouseState = SDL_GetMouseState;
extern fn SDL_GetMouseState(x: ?*f32, y: ?*f32) MouseButtonFlags;

/// Query the platform for the asynchronous mouse button state and the
/// desktop-relative platform-cursor position.
///
/// This function immediately queries the platform for the most recent
/// asynchronous state, more costly than retrieving SDL's cached state in
/// `getMouseState`.
///
/// Passing non-null pointers to `x` or `y` will write the destination with
/// respective x or y coordinates relative to the desktop.
///
/// In Relative Mode, the platform-cursor's position usually contradicts the
/// SDL-cursor's position as manually calculated from `getMouseState` and
/// `getWindowPosition`.
///
/// This function can be useful if you need to track the mouse outside of a
/// specific window and `captureMouse` doesn't fit your needs. For example,
/// it could be useful if you need to track the mouse while dragging a window,
/// where coordinates relative to a window might not be in sync at all times.
pub const getGlobalMouseState = SDL_GetGlobalMouseState;
extern fn SDL_GetGlobalMouseState(x: ?*f32, y: ?*f32) MouseButtonFlags;

/// Query SDL's cache for the synchronous mouse button state and accumulated
/// mouse delta since last call.
///
/// This function returns the cached synchronous state as SDL understands it
/// from the last pump of the event queue.
///
/// To query the platform for immediate asynchronous state, use
/// `getGlobalMouseState`.
///
/// Passing non-null pointers to `x` or `y` will write the destination with
/// respective x or y deltas accumulated since the last call to this function
/// (or since event initialization).
///
/// This function is useful for reducing overhead by processing relative mouse
/// inputs in one go per-frame instead of individually per-event, at the
/// expense of losing the order between events within the frame (e.g. quickly
/// pressing and releasing a button within the same frame).
pub const getRelativeMouseState = SDL_GetRelativeMouseState;
extern fn SDL_GetRelativeMouseState(x: ?*f32, y: ?*f32) MouseButtonFlags;

/// Move the mouse cursor to the given position within the window.
///
/// This function generates a mouse motion event if relative mode is not
/// enabled. If relative mode is enabled, you can force mouse events for the
/// warp by setting the `hint_mouse_relative_warp_motion` hint.
///
/// Note that this function will appear to succeed, but not actually move the
/// mouse when used over Microsoft Remote Desktop.
pub const warpMouseInWindow = SDL_WarpMouseInWindow;
extern fn SDL_WarpMouseInWindow(window: ?*sdl.Window, x: f32, y: f32) void;

/// Move the mouse to the given position in global screen space.
///
/// This function generates a mouse motion event.
///
/// A failure of this function usually means that it is unsupported by a
/// platform.
///
/// Note that this function will appear to succeed, but not actually move the
/// mouse when used over Microsoft Remote Desktop.
pub fn warpMouseGlobal(x: f32, y: f32) Error!void {
    if (!SDL_WarpMouseGlobal(x, y)) return makeError();
}
extern fn SDL_WarpMouseGlobal(x: f32, y: f32) bool;

/// Set a user-defined function by which to transform relative mouse inputs.
///
/// This overrides the relative system scale and relative speed scale hints.
/// Should be called prior to enabling relative mouse mode, fails otherwise.
pub fn setRelativeMouseTransform(callback: ?MouseMotionTransformCallback, userdata: ?*anyopaque) Error!void {
    if (!SDL_SetRelativeMouseTransform(callback, userdata)) return makeError();
}
extern fn SDL_SetRelativeMouseTransform(callback: ?MouseMotionTransformCallback, userdata: ?*anyopaque) bool;

/// Set relative mouse mode for a window.
///
/// While the window has focus and relative mouse mode is enabled, the cursor
/// is hidden, the mouse position is constrained to the window, and SDL will
/// report continuous relative mouse motion even if the mouse is at the edge of
/// the window.
///
/// If you'd like to keep the mouse position fixed while in relative mode you
/// can use `setWindowMouseRect`. If you'd like the cursor to be at a
/// specific location when relative mode ends, you should use
/// `warpMouseInWindow` before disabling relative mode.
///
/// This function will flush any pending mouse motion for this window.
pub fn setWindowRelativeMouseMode(window: *sdl.Window, enabled: bool) Error!void {
    if (!SDL_SetWindowRelativeMouseMode(window, enabled)) return makeError();
}
extern fn SDL_SetWindowRelativeMouseMode(window: *sdl.Window, enabled: bool) bool;

/// Query whether relative mouse mode is enabled for a window.
pub const getWindowRelativeMouseMode = SDL_GetWindowRelativeMouseMode;
extern fn SDL_GetWindowRelativeMouseMode(window: *sdl.Window) bool;

/// Capture the mouse and to track input outside an SDL window.
///
/// Capturing enables your app to obtain mouse events globally, instead of just
/// within your window. Not all video targets support this function. When
/// capturing is enabled, the current window will get all mouse events, but
/// unlike relative mode, no change is made to the cursor and it is not
/// restrained to your window.
///
/// This function may also deny mouse input to other windows--both those in
/// your application and others on the system--so you should use this function
/// sparingly, and in small bursts. For example, you might want to track the
/// mouse while the user is dragging something, until the user releases a mouse
/// button. It is not recommended that you capture the mouse for long periods
/// of time, such as the entire time your app is running. For that, you should
/// probably use `setWindowRelativeMouseMode` or `setWindowMouseGrab`,
/// depending on your goals.
///
/// While captured, mouse events still report coordinates relative to the
/// current (foreground) window, but those coordinates may be outside the
/// bounds of the window (including negative values). Capturing is only allowed
/// for the foreground window. If the window loses focus while capturing, the
/// capture will be disabled automatically.
///
/// While capturing is enabled, the current window will have the
/// `WindowFlags.mouse_capture` flag set.
///
/// Please note that SDL will attempt to "auto capture" the mouse while the
/// user is pressing a button; this is to try and make mouse behavior more
/// consistent between platforms, and deal with the common case of a user
/// dragging the mouse outside of the window. This means that if you are
/// calling `captureMouse` only to deal with this situation, you do not
/// have to (although it is safe to do so). If this causes problems for your
/// app, you can disable auto capture by setting the
/// `hint_mouse_auto_capture` hint to zero.
pub fn captureMouse(enabled: bool) Error!void {
    if (!SDL_CaptureMouse(enabled)) return makeError();
}
extern fn SDL_CaptureMouse(enabled: bool) bool;

/// Create a cursor using the specified bitmap data and mask (in MSB format).
///
/// `mask` has to be in MSB (Most Significant Bit) format.
///
/// The cursor width (`w`) must be a multiple of 8 bits.
///
/// The cursor is created in black and white according to the following:
///
/// - data=0, mask=1: white
/// - data=1, mask=1: black
/// - data=0, mask=0: transparent
/// - data=1, mask=0: inverted color if possible, black if not.
///
/// Cursors created with this function must be freed with `destroyCursor`.
///
/// If you want to have a color cursor, or create your cursor from an
/// `Surface`, you should use `createColorCursor`. Alternately, you can
/// hide the cursor and draw your own as part of your game's rendering, but it
/// will be bound to the framerate.
///
/// Also, `createSystemCursor` is available, which provides several
/// readily-available system cursors to pick from.
pub fn createCursor(data: [*]const u8, mask: [*]const u8, w: c_int, h: c_int, hot_x: c_int, hot_y: c_int) Error!*Cursor {
    return SDL_CreateCursor(data, mask, w, h, hot_x, hot_y) orelse makeError();
}
extern fn SDL_CreateCursor(data: [*]const u8, mask: [*]const u8, w: c_int, h: c_int, hot_x: c_int, hot_y: c_int) ?*Cursor;

/// Create a color cursor.
///
/// If this function is passed a surface with alternate representations added
/// with `addSurfaceAlternateImage`, the surface will be interpreted as the
/// content to be used for 100% display scale, and the alternate
/// representations will be used for high DPI situations if
/// `hint_mouse_dpi_scale_cursors` is enabled. For example, if the original
/// surface is 32x32, then on a 2x macOS display or 200% display scale on
/// Windows, a 64x64 version of the image will be used, if available. If a
/// matching version of the image isn't available, the closest larger size
/// image will be downscaled to the appropriate size and be used instead, if
/// available. Otherwise, the closest smaller image will be upscaled and be
/// used instead.
pub fn createColorCursor(surface: *sdl.Surface, hot_x: c_int, hot_y: c_int) Error!*Cursor {
    return SDL_CreateColorCursor(surface, hot_x, hot_y) orelse makeError();
}
extern fn SDL_CreateColorCursor(surface: *sdl.Surface, hot_x: c_int, hot_y: c_int) ?*Cursor;

/// Create an animated color cursor.
///
/// Animated cursors are composed of a sequential array of frames, specified as
/// surfaces and durations in an array of `CursorFrameInfo` structs. The hot
/// spot coordinates are universal to all frames, and all frames must have the
/// same dimensions.
///
/// Frame durations are specified in milliseconds. A duration of 0 implies an
/// infinite frame time, and the animation will stop on that frame. To create a
/// one-shot animation, set the duration of the last frame in the sequence to
/// 0.
///
/// If this function is passed surfaces with alternate representations added
/// with `addSurfaceAlternateImage`, the surfaces will be interpreted as
/// the content to be used for 100% display scale, and the alternate
/// representations will be used for high DPI situations. For example, if the
/// original surfaces are 32x32, then on a 2x macOS display or 200% display
/// scale on Windows, a 64x64 version of the image will be used, if available.
/// If a matching version of the image isn't available, the closest larger size
/// image will be downscaled to the appropriate size and be used instead, if
/// available. Otherwise, the closest smaller image will be upscaled and be
/// used instead.
///
/// If the underlying platform does not support animated cursors, this function
/// will fall back to creating a static color cursor using the first frame in
/// the sequence.
pub fn createAnimatedCursor(frames: []const CursorFrameInfo, hot_x: c_int, hot_y: c_int) Error!*Cursor {
    return SDL_CreateAnimatedCursor(frames.ptr, @intCast(frames.len), hot_x, hot_y) orelse makeError();
}
extern fn SDL_CreateAnimatedCursor(frames: [*]const CursorFrameInfo, frame_count: c_int, hot_x: c_int, hot_y: c_int) ?*Cursor;

/// Create a system cursor.
pub fn createSystemCursor(id: SystemCursor) Error!*Cursor {
    return SDL_CreateSystemCursor(id) orelse makeError();
}
extern fn SDL_CreateSystemCursor(id: SystemCursor) ?*Cursor;

/// Set the active cursor.
///
/// This function sets the currently active cursor to the specified one. If the
/// cursor is currently visible, the change will be immediately represented on
/// the display. `setCursor`(null) can be used to force cursor redraw, if
/// this is desired for any reason.
pub fn setCursor(cursor: ?*Cursor) Error!void {
    if (!SDL_SetCursor(cursor)) return makeError();
}
extern fn SDL_SetCursor(cursor: ?*Cursor) bool;

/// Get the active cursor.
///
/// This function returns a pointer to the current cursor which is owned by the
/// library. It is not necessary to free the cursor with `destroyCursor`.
pub const getCursor = SDL_GetCursor;
extern fn SDL_GetCursor() ?*Cursor;

/// Get the default cursor.
///
/// You do not have to call `destroyCursor` on the return value, but it is
/// safe to do so.
pub fn getDefaultCursor() Error!*Cursor {
    return SDL_GetDefaultCursor() orelse makeError();
}
extern fn SDL_GetDefaultCursor() ?*Cursor;

/// Free a previously-created cursor.
///
/// Use this function to free cursor resources created with `createCursor`,
/// `createColorCursor` or `createSystemCursor`.
pub const destroyCursor = SDL_DestroyCursor;
extern fn SDL_DestroyCursor(cursor: *Cursor) void;

/// Show the cursor.
pub fn showCursor() Error!void {
    if (!SDL_ShowCursor()) return makeError();
}
extern fn SDL_ShowCursor() bool;

/// Hide the cursor.
pub fn hideCursor() Error!void {
    if (!SDL_HideCursor()) return makeError();
}
extern fn SDL_HideCursor() bool;

/// Return whether the cursor is currently being shown.
pub const cursorVisible = SDL_CursorVisible;
extern fn SDL_CursorVisible() bool;
