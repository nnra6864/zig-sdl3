//! Keyboard Support (SDL_keyboard.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// This is a unique ID for a keyboard for the time it is connected to the
/// system, and is never reused for the lifetime of the application.
///
/// If the keyboard is disconnected and reconnected, it will get a new ID.
///
/// The value 0 is an invalid ID.
pub const KeyboardId = enum(u32) { invalid = 0, _ };

/// Return whether a keyboard is currently connected.
pub const hasKeyboard = SDL_HasKeyboard;
extern fn SDL_HasKeyboard() bool;

/// Get a list of currently connected keyboards.
///
/// Note that this will include any device or virtual driver that includes
/// keyboard functionality, including some mice, KVM switches, motherboard
/// power buttons, etc. You should wait for input from a device before you
/// consider it actively in use.
///
/// The returned value should be freed with `free` when it is no longer needed.
pub fn getKeyboards() Error![]KeyboardId {
    var count: c_int = undefined;
    const ptr = SDL_GetKeyboards(&count) orelse return makeError();
    return ptr[0..@intCast(count)];
}
extern fn SDL_GetKeyboards(count: ?*c_int) ?[*]KeyboardId;

/// Get the name of a keyboard.
///
/// This function returns "" if the keyboard doesn't have a name.
pub fn getKeyboardNameForId(instance_id: KeyboardId) Error![:0]const u8 {
    const str = SDL_GetKeyboardNameForID(instance_id) orelse return makeError();
    return std.mem.span(str);
}
extern fn SDL_GetKeyboardNameForID(instance_id: KeyboardId) ?[*:0]const u8;

/// Query the window which currently has keyboard focus.
pub const getKeyboardFocus = SDL_GetKeyboardFocus;
extern fn SDL_GetKeyboardFocus() ?*sdl.Window;

/// Get a snapshot of the current state of the keyboard.
///
/// The pointer returned is a pointer to an internal SDL array. It will be
/// valid for the whole lifetime of the application and should not be freed by
/// the caller.
///
/// A array element with a value of true means that the key is pressed and a
/// value of false means that it is not. Indexes into this array are obtained
/// by using `Scancode` values.
///
/// Use `pumpEvents` to update the state array.
///
/// This function gives you the current state after all events have been
/// processed, so if a key or button has been pressed and released before you
/// process events, then the pressed state will never show up in the
/// `getKeyboardState` calls.
///
/// Note: This function doesn't take into account whether shift has been
/// pressed or not.
pub fn getKeyboardState() []const bool {
    var numkeys: c_int = undefined;
    const ptr = SDL_GetKeyboardState(&numkeys) orelse return &.{};
    return ptr[0..@intCast(numkeys)];
}
extern fn SDL_GetKeyboardState(numkeys: ?*c_int) ?[*]const bool;

/// Clear the state of the keyboard.
///
/// This function will generate key up events for all pressed keys.
pub const resetKeyboard = SDL_ResetKeyboard;
extern fn SDL_ResetKeyboard() void;

/// Get the current key modifier state for the keyboard.
pub const getModState = SDL_GetModState;
extern fn SDL_GetModState() sdl.Keymod;

/// Set the current key modifier state for the keyboard.
///
/// The inverse of `getModState`, `setModState` allows you to impose
/// modifier key states on your application. Simply pass your desired modifier
/// states into `modstate`. This value may be a bitwise, OR'd combination of
/// `Keymod` values.
///
/// This does not change the keyboard state, only the key modifier flags that
/// SDL reports.
pub const setModState = SDL_SetModState;
extern fn SDL_SetModState(modstate: sdl.Keymod) void;

/// Get the key code corresponding to the given scancode according to the
/// current keyboard layout.
///
/// If you want to get the keycode as it would be delivered in key events,
/// including options specified in `hint_keycode_options`, then you should
/// pass `key_event` as true. Otherwise this function simply translates the
/// scancode based on the given modifier state.
pub const getKeyFromScancode = SDL_GetKeyFromScancode;
extern fn SDL_GetKeyFromScancode(scancode: sdl.Scancode, modstate: sdl.Keymod, key_event: bool) sdl.Keycode;

/// Get the scancode corresponding to the given key code according to the
/// current keyboard layout.
///
/// Note that there may be multiple scancode+modifier states that can generate
/// this keycode, this will just return the first one found.
pub const getScancodeFromKey = SDL_GetScancodeFromKey;
extern fn SDL_GetScancodeFromKey(key: sdl.Keycode, modstate: ?*sdl.Keymod) sdl.Scancode;

/// Set a human-readable name for a scancode.
pub fn setScancodeName(scancode: sdl.Scancode, name: [:0]const u8) Error!void {
    if (!SDL_SetScancodeName(scancode, name.ptr)) return makeError();
}
extern fn SDL_SetScancodeName(scancode: sdl.Scancode, name: [*:0]const u8) bool;

/// Get a human-readable name for a scancode.
///
/// **Warning**: The returned name is by design not stable across platforms,
/// e.g. the name for `Scancode.lgui` is "Left GUI" under Linux but "Left
/// Windows" under Microsoft Windows, and some scancodes like
/// `Scancode.nonusbackslash` don't have any name at all. There are even
/// scancodes that share names, e.g. `Scancode.@"return"` and
/// `Scancode.return2` (both called "Return"). This function is therefore
/// unsuitable for creating a stable cross-platform two-way mapping between
/// strings and scancodes.
pub fn getScancodeName(scancode: sdl.Scancode) [:0]const u8 {
    const str = SDL_GetScancodeName(scancode);
    return std.mem.span(str);
}
extern fn SDL_GetScancodeName(scancode: sdl.Scancode) [*:0]const u8;

/// Get a scancode from a human-readable name.
pub fn getScancodeFromName(name: [:0]const u8) sdl.Scancode {
    return SDL_GetScancodeFromName(name.ptr);
}
extern fn SDL_GetScancodeFromName(name: [*:0]const u8) sdl.Scancode;

/// Get a human-readable name for a key.
///
/// If the key doesn't have a name, this function returns an empty string ("").
///
/// Letters will be presented in their uppercase form, if applicable.
pub fn getKeyName(key: sdl.Keycode) [:0]const u8 {
    const str = SDL_GetKeyName(key);
    return std.mem.span(str);
}
extern fn SDL_GetKeyName(key: sdl.Keycode) [*:0]const u8;

/// Get a key code from a human-readable name.
pub fn getKeyFromName(name: [:0]const u8) sdl.Keycode {
    return SDL_GetKeyFromName(name.ptr);
}
extern fn SDL_GetKeyFromName(name: [*:0]const u8) sdl.Keycode;

/// Start accepting Unicode text input events in a window.
///
/// This function will enable text input (`EventType.text_input` and
/// `EventType.text_editing` events) in the specified window. Please use this
/// function paired with `stopTextInput`.
///
/// Text input events are not received by default.
///
/// On some platforms using this function shows the screen keyboard and/or
/// activates an IME, which can prevent some key press events from being passed
/// through.
pub fn startTextInput(window: *sdl.Window) Error!void {
    if (!SDL_StartTextInput(window)) return makeError();
}
extern fn SDL_StartTextInput(window: *sdl.Window) bool;

/// Text input type.
///
/// These are the valid values for `TextInputType.Properties.number`. Not every
/// value is valid on every platform, but where a value isn't supported, a
/// reasonable fallback will be used.
pub const TextInputType = enum(c_int) {
    /// The input is text
    text,
    /// The input is a person's name
    text_name,
    /// The input is an e-mail address
    text_email,
    /// The input is a username
    text_username,
    /// The input is a secure password that is hidden
    text_password_hidden,
    /// The input is a secure password that is visible
    text_password_visible,
    /// The input is a number
    number,
    /// The input is a secure PIN that is hidden
    number_password_hidden,
    /// The input is a secure PIN that is visible
    number_password_visible,
};

/// Auto capitalization type.
///
/// These are the valid values for `prop_textinput_capitalization_number`.
/// Not every value is valid on every platform, but where a value isn't
/// supported, a reasonable fallback will be used.
pub const Capitalization = enum(c_int) {
    /// No auto-capitalization will be done
    none,
    /// The first letter of sentences will be capitalized
    sentences,
    /// The first letter of words will be capitalized
    words,
    /// All letters will be capitalized
    letters,
};

/// Start accepting Unicode text input events in a window, with properties
/// describing the input.
///
/// This function will enable text input (`EventType.text_input` and
/// `EventType.text_editing` events) in the specified window. Please use this
/// function paired with `stopTextInput`.
///
/// Text input events are not received by default.
///
/// On some platforms using this function shows the screen keyboard and/or
/// activates an IME, which can prevent some key press events from being passed
/// through.
///
/// These are the supported properties:
///
/// - `TextInputType.Properties.number` - a `TextInputType` value that
///   describes text being input, defaults to `TextInputType.text`.
/// - `prop_textinput_capitalization_number` - a `Capitalization` value
///   that describes how text should be capitalized, defaults to
///   `Capitalization.sentences` for normal text entry, `Capitalization.words` for
///   `TextInputType.text_name`, and `Capitalization.none` for e-mail
///   addresses, usernames, and passwords.
/// - `prop_textinput_autocorrect_boolean` - true to enable auto completion
///   and auto correction, defaults to true.
/// - `prop_textinput_multiline_boolean` - true if multiple lines of text
///   are allowed. This defaults to true if `hint_return_key_hides_ime` is
///   "0" or is not set, and defaults to false if `hint_return_key_hides_ime`
///   is "1".
///
/// On Android you can directly specify the input type:
///
/// - `prop_textinput_android_inputtype_number` - the text input type to
///   use, overriding other properties. This is documented at
///   https://developer.android.com/reference/android/text/InputType
pub fn startTextInputWithProperties(window: *sdl.Window, props: sdl.PropertiesId) Error!void {
    if (!SDL_StartTextInputWithProperties(window, props)) return makeError();
}
extern fn SDL_StartTextInputWithProperties(window: *sdl.Window, props: sdl.PropertiesId) bool;

pub const prop_textinput_capitalization_number = "SDL.textinput.capitalization";
pub const prop_textinput_autocorrect_boolean = "SDL.textinput.autocorrect";
pub const prop_textinput_multiline_boolean = "SDL.textinput.multiline";
pub const prop_textinput_android_inputtype_number = "SDL.textinput.android.inputtype";
/// Check whether or not Unicode text input events are enabled for a window.
pub const textInputActive = SDL_TextInputActive;
extern fn SDL_TextInputActive(window: *sdl.Window) bool;

/// Stop receiving any text input events in a window.
///
/// If `startTextInput` showed the screen keyboard, this function will hide
/// it.
pub fn stopTextInput(window: *sdl.Window) Error!void {
    if (!SDL_StopTextInput(window)) return makeError();
}
extern fn SDL_StopTextInput(window: *sdl.Window) bool;

/// Dismiss the composition window/IME without disabling the subsystem.
pub fn clearComposition(window: *sdl.Window) Error!void {
    if (!SDL_ClearComposition(window)) return makeError();
}
extern fn SDL_ClearComposition(window: *sdl.Window) bool;

/// Set the area used to type Unicode text input.
///
/// Native input methods may place a window with word suggestions near the
/// cursor, without covering the text being entered.
pub fn setTextInputArea(window: *sdl.Window, rect: ?*const sdl.Rect, cursor: c_int) Error!void {
    if (!SDL_SetTextInputArea(window, rect, cursor)) return makeError();
}
extern fn SDL_SetTextInputArea(window: *sdl.Window, rect: ?*const sdl.Rect, cursor: c_int) bool;

/// Get the area used to type Unicode text input.
///
/// This returns the values previously set by `setTextInputArea`.
pub fn getTextInputArea(window: *sdl.Window, rect: ?*sdl.Rect, cursor: ?*c_int) Error!void {
    if (!SDL_GetTextInputArea(window, rect, cursor)) return makeError();
}
extern fn SDL_GetTextInputArea(window: *sdl.Window, rect: ?*sdl.Rect, cursor: ?*c_int) bool;

/// Check whether the platform has screen keyboard support.
pub const hasScreenKeyboardSupport = SDL_HasScreenKeyboardSupport;
extern fn SDL_HasScreenKeyboardSupport() bool;

/// Check whether the screen keyboard is shown for given window.
pub const screenKeyboardShown = SDL_ScreenKeyboardShown;
extern fn SDL_ScreenKeyboardShown(window: *sdl.Window) bool;
