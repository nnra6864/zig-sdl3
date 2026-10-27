//! Event Handling (SDL_events.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// The types of events that can be delivered.
pub const EventType = enum(u32) {
    /// Unused (do not remove)
    first = 0,
    /// User-requested quit
    quit = 0x100,
    /// The application is being terminated by the OS. This event must be handled in a callback set with `addEventWatch`. Called on iOS in applicationWillTerminate() Called on Android in onDestroy()
    terminating,
    /// The application is low on memory, free memory if possible. This event must be handled in a callback set with `addEventWatch`. Called on iOS in applicationDidReceiveMemoryWarning() Called on Android in onTrimMemory()
    low_memory,
    /// The application is about to enter the background. This event must be handled in a callback set with `addEventWatch`. Called on iOS in applicationWillResignActive() Called on Android in onPause()
    will_enter_background,
    /// The application did enter the background and may not get CPU for some time. This event must be handled in a callback set with `addEventWatch`. Called on iOS in applicationDidEnterBackground() Called on Android in onPause()
    did_enter_background,
    /// The application is about to enter the foreground. This event must be handled in a callback set with `addEventWatch`. Called on iOS in applicationWillEnterForeground() Called on Android in onResume()
    will_enter_foreground,
    /// The application is now interactive. This event must be handled in a callback set with `addEventWatch`. Called on iOS in applicationDidBecomeActive() Called on Android in onResume()
    did_enter_foreground,
    /// The user's locale preferences have changed.
    locale_changed,
    /// The system theme changed
    system_theme_changed,
    /// Display orientation has changed to data1
    display_orientation = 0x151,
    /// Display has been added to the system
    display_added,
    /// Display has been removed from the system
    display_removed,
    /// Display has changed position
    display_moved,
    /// Display has changed desktop mode
    display_desktop_mode_changed,
    /// Display has changed current mode
    display_current_mode_changed,
    /// Display has changed content scale
    display_content_scale_changed,
    /// Display has changed usable bounds
    display_usable_bounds_changed,
    /// Window has been shown
    window_shown = 0x202,
    /// Window has been hidden
    window_hidden,
    /// Window has been exposed and should be redrawn, and can be redrawn directly from event watchers for this event. data1 is 1 for live-resize expose events, 0 otherwise.
    window_exposed,
    /// Window has been moved to data1, data2
    window_moved,
    /// Window has been resized to data1xdata2
    window_resized,
    /// The pixel size of the window has changed to data1xdata2
    window_pixel_size_changed,
    /// The pixel size of a Metal view associated with the window has changed
    window_metal_view_resized,
    /// Window has been minimized
    window_minimized,
    /// Window has been maximized
    window_maximized,
    /// Window has been restored to normal size and position
    window_restored,
    /// Window has gained mouse focus
    window_mouse_enter,
    /// Window has lost mouse focus
    window_mouse_leave,
    /// Window has gained keyboard focus
    window_focus_gained,
    /// Window has lost keyboard focus
    window_focus_lost,
    /// The window manager requests that the window be closed
    window_close_requested,
    /// Window had a hit test that wasn't `HitTestResult.normal`
    window_hit_test,
    /// The ICC profile of the window's display has changed
    window_iccprof_changed,
    /// Window has been moved to display data1
    window_display_changed,
    /// Window display scale has been changed
    window_display_scale_changed,
    /// The window safe area has been changed
    window_safe_area_changed,
    /// The window has been occluded
    window_occluded,
    /// The window has entered fullscreen mode
    window_enter_fullscreen,
    /// The window has left fullscreen mode
    window_leave_fullscreen,
    /// The window with the associated ID is being or has been destroyed. If this message is being handled in an event watcher, the window handle is still valid and can still be used to retrieve any properties associated with the window. Otherwise, the handle has already been destroyed and all resources associated with it are invalid
    window_destroyed,
    /// Window HDR properties have changed
    window_hdr_state_changed,
    /// Key pressed
    key_down = 0x300,
    /// Key released
    key_up,
    /// Keyboard text editing (composition)
    text_editing,
    /// Keyboard text input
    text_input,
    /// Keymap changed due to a system event such as an input language or keyboard layout change.
    keymap_changed,
    /// A new keyboard has been inserted into the system
    keyboard_added,
    /// A keyboard has been removed
    keyboard_removed,
    /// Keyboard text editing candidates
    text_editing_candidates,
    /// The on-screen keyboard has been shown
    screen_keyboard_shown,
    /// The on-screen keyboard has been hidden
    screen_keyboard_hidden,
    /// Mouse moved
    mouse_motion = 0x400,
    /// Mouse button pressed
    mouse_button_down,
    /// Mouse button released
    mouse_button_up,
    /// Mouse wheel motion
    mouse_wheel,
    /// A new mouse has been inserted into the system
    mouse_added,
    /// A mouse has been removed
    mouse_removed,
    /// Joystick axis motion
    joystick_axis_motion = 0x600,
    /// Joystick trackball motion
    joystick_ball_motion,
    /// Joystick hat position change
    joystick_hat_motion,
    /// Joystick button pressed
    joystick_button_down,
    /// Joystick button released
    joystick_button_up,
    /// A new joystick has been inserted into the system
    joystick_added,
    /// An opened joystick has been removed
    joystick_removed,
    /// Joystick battery level change
    joystick_battery_updated,
    /// Joystick update is complete
    joystick_update_complete,
    /// Gamepad axis motion
    gamepad_axis_motion = 0x650,
    /// Gamepad button pressed
    gamepad_button_down,
    /// Gamepad button released
    gamepad_button_up,
    /// A new gamepad has been inserted into the system
    gamepad_added,
    /// A gamepad has been removed
    gamepad_removed,
    /// The gamepad mapping was updated
    gamepad_remapped,
    /// Gamepad touchpad was touched
    gamepad_touchpad_down,
    /// Gamepad touchpad finger was moved
    gamepad_touchpad_motion,
    /// Gamepad touchpad finger was lifted
    gamepad_touchpad_up,
    /// Gamepad sensor was updated
    gamepad_sensor_update,
    /// Gamepad update is complete
    gamepad_update_complete,
    /// Gamepad Steam handle has changed
    gamepad_steam_handle_updated,
    finger_down = 0x700,
    finger_up,
    finger_motion,
    finger_canceled,
    /// Pinch gesture started
    pinch_begin = 0x710,
    /// Pinch gesture updated
    pinch_update,
    /// Pinch gesture ended
    pinch_end,
    /// The clipboard changed
    clipboard_update = 0x900,
    /// The system requests a file open
    drop_file = 0x1000,
    /// text/plain drag-and-drop event
    drop_text,
    /// A new set of drops is beginning (null filename)
    drop_begin,
    /// Current set of drops is now complete (null filename)
    drop_complete,
    /// Position while moving over the window
    drop_position,
    /// A new audio device is available
    audio_device_added = 0x1100,
    /// An audio device has been removed.
    audio_device_removed,
    /// An audio device's format has been changed by the system.
    audio_device_format_changed,
    /// A sensor was updated
    sensor_update = 0x1200,
    /// Pressure-sensitive pen has become available
    pen_proximity_in = 0x1300,
    /// Pressure-sensitive pen has become unavailable
    pen_proximity_out,
    /// Pressure-sensitive pen touched drawing surface
    pen_down,
    /// Pressure-sensitive pen stopped touching drawing surface
    pen_up,
    /// Pressure-sensitive pen button pressed
    pen_button_down,
    /// Pressure-sensitive pen button released
    pen_button_up,
    /// Pressure-sensitive pen is moving on the tablet
    pen_motion,
    /// Pressure-sensitive pen angle/pressure/etc changed
    pen_axis,
    /// A new camera device is available
    camera_device_added = 0x1400,
    /// A camera device has been removed.
    camera_device_removed,
    /// A camera device has been approved for use by the user.
    camera_device_approved,
    /// A camera device has been denied for use by the user.
    camera_device_denied,
    /// The render targets have been reset and their contents need to be updated
    render_targets_reset = 0x2000,
    /// The device has been reset and all textures need to be recreated
    render_device_reset,
    /// The device has been lost and can't be recovered.
    render_device_lost,
    private0 = 0x4000,
    private1,
    private2,
    private3,
    /// Signals the end of an event poll cycle
    poll_sentinel = 0x7F00,
    /// Events `EventType.user` through `EventType.last` are for your use, and should be allocated with `registerEvents`
    user = 0x8000,
    /// This last event is only for bounding internal arrays
    last = 0xFFFF,
    _,

    pub const display_first: EventType = .display_orientation;
    pub const display_last: EventType = .display_usable_bounds_changed;
    pub const window_first: EventType = .window_shown;
    pub const window_last: EventType = .window_hdr_state_changed;
};

/// Fields shared by every event
pub const CommonEvent = extern struct {
    /// Event type, shared with all events, Uint32 to cover user events which are not in the `EventType` enumeration
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
};

/// Display state change event data (event.display.*)
pub const DisplayEvent = extern struct {
    /// SDL_DISPLAYEVENT_
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The associated display
    display_id: sdl.DisplayId,
    /// event dependent data
    data1: i32,
    /// event dependent data
    data2: i32,
};

/// Window state change event data (event.window.*)
pub const WindowEvent = extern struct {
    /// SDL_EVENT_WINDOW_
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The associated window
    window_id: sdl.WindowId,
    /// event dependent data
    data1: i32,
    /// event dependent data
    data2: i32,
};

/// Keyboard device event structure (event.kdevice.*)
pub const KeyboardDeviceEvent = extern struct {
    /// `EventType.keyboard_added` or `EventType.keyboard_removed`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The keyboard instance id
    which: sdl.KeyboardId,
};

/// Keyboard button event structure (event.key.*)
///
/// The `key` is the base `Keycode` generated by pressing the `scancode`
/// using the current keyboard layout, applying any options specified in
/// `hint_keycode_options`. You can get the `Keycode` corresponding to the
/// event scancode and modifiers directly from the keyboard layout, bypassing
/// `hint_keycode_options`, by calling `getKeyFromScancode`.
pub const KeyboardEvent = extern struct {
    /// `EventType.key_down` or `EventType.key_up`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The window with keyboard focus, if any
    window_id: sdl.WindowId,
    /// The keyboard instance id, or 0 if unknown or virtual
    which: sdl.KeyboardId,
    /// SDL physical key code
    scancode: sdl.Scancode,
    /// SDL virtual key code
    key: sdl.Keycode,
    /// current key modifiers
    mod: sdl.Keymod,
    /// The platform dependent scancode for this event
    raw: u16,
    /// true if the key is pressed
    down: bool,
    /// true if this is a key repeat
    repeat: bool,
};

/// Keyboard text editing event structure (event.edit.*)
///
/// The start cursor is the position, in UTF-8 characters, where new typing
/// will be inserted into the editing text. The length is the number of UTF-8
/// characters that will be replaced by new typing.
pub const TextEditingEvent = extern struct {
    /// `EventType.text_editing`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The window with keyboard focus, if any
    window_id: sdl.WindowId,
    /// The editing text
    text: ?[*:0]const u8,
    /// The start cursor of selected editing text, or -1 if not set
    start: i32,
    /// The length of selected editing text, or -1 if not set
    length: i32,
};

/// Keyboard IME candidates event structure (event.edit_candidates.*)
pub const TextEditingCandidatesEvent = extern struct {
    /// `EventType.text_editing_candidates`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The window with keyboard focus, if any
    window_id: sdl.WindowId,
    /// The list of candidates, or null if there are no candidates available
    candidates: ?*?[*:0]const u8,
    /// The number of strings in `candidates`
    num_candidates: i32,
    /// The index of the selected candidate, or -1 if no candidate is selected
    selected_candidate: i32,
    /// true if the list is horizontal, false if it's vertical
    horizontal: bool,
    padding1: u8 = 0,
    padding2: u8 = 0,
    padding3: u8 = 0,
};

/// Keyboard text input event structure (event.text.*)
///
/// This event will never be delivered unless text input is enabled by calling
/// `startTextInput`. Text input is disabled by default!
pub const TextInputEvent = extern struct {
    /// `EventType.text_input`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The window with keyboard focus, if any
    window_id: sdl.WindowId,
    /// The input text, UTF-8 encoded
    text: ?[*:0]const u8,
};

/// Mouse device event structure (event.mdevice.*)
pub const MouseDeviceEvent = extern struct {
    /// `EventType.mouse_added` or `EventType.mouse_removed`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The mouse instance id
    which: sdl.MouseId,
};

/// Mouse motion event structure (event.motion.*)
pub const MouseMotionEvent = extern struct {
    /// `EventType.mouse_motion`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The window with mouse focus, if any
    window_id: sdl.WindowId,
    /// The mouse instance id in relative mode, `touch_mouseid` for touch events, `pen_mouseid` for pen events, or 0
    which: sdl.MouseId,
    /// The current button state
    state: sdl.MouseButtonFlags,
    /// X coordinate, relative to window
    x: f32,
    /// Y coordinate, relative to window
    y: f32,
    /// The relative motion in the X direction
    xrel: f32,
    /// The relative motion in the Y direction
    yrel: f32,
};

/// Mouse button event structure (event.button.*)
pub const MouseButtonEvent = extern struct {
    /// `EventType.mouse_button_down` or `EventType.mouse_button_up`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The window with mouse focus, if any
    window_id: sdl.WindowId,
    /// The mouse instance id in relative mode, `touch_mouseid` for touch events, `pen_mouseid` for pen events, or 0
    which: sdl.MouseId,
    /// The mouse button index
    button: u8,
    /// true if the button is pressed
    down: bool,
    /// 1 for single-click, 2 for double-click, etc.
    clicks: u8,
    padding: u8 = 0,
    /// X coordinate, relative to window
    x: f32,
    /// Y coordinate, relative to window
    y: f32,
};

/// Mouse wheel event structure (event.wheel.*)
pub const MouseWheelEvent = extern struct {
    /// `EventType.mouse_wheel`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The window with mouse focus, if any
    window_id: sdl.WindowId,
    /// The mouse instance id in relative mode or 0
    which: sdl.MouseId,
    /// The amount scrolled horizontally, positive to the right and negative to the left
    x: f32,
    /// The amount scrolled vertically, positive away from the user and negative toward the user
    y: f32,
    /// Set to one of the SDL_MOUSEWHEEL_* defines. When FLIPPED the values in X and Y will be opposite. Multiply by -1 to change them back
    direction: sdl.MouseWheelDirection,
    /// X coordinate, relative to window
    mouse_x: f32,
    /// Y coordinate, relative to window
    mouse_y: f32,
    /// The amount scrolled horizontally, accumulated to whole scroll "ticks" (added in 3.2.12)
    integer_x: i32,
    /// The amount scrolled vertically, accumulated to whole scroll "ticks" (added in 3.2.12)
    integer_y: i32,
};

/// Joystick axis motion event structure (event.jaxis.*)
pub const JoyAxisEvent = extern struct {
    /// `EventType.joystick_axis_motion`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The joystick instance id
    which: sdl.JoystickId,
    /// The joystick axis index
    axis: u8,
    padding1: u8 = 0,
    padding2: u8 = 0,
    padding3: u8 = 0,
    /// The axis value (range: -32768 to 32767)
    value: i16,
    padding4: u16 = 0,
};

/// Joystick trackball motion event structure (event.jball.*)
pub const JoyBallEvent = extern struct {
    /// `EventType.joystick_ball_motion`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The joystick instance id
    which: sdl.JoystickId,
    /// The joystick trackball index
    ball: u8,
    padding1: u8 = 0,
    padding2: u8 = 0,
    padding3: u8 = 0,
    /// The relative motion in the X direction
    xrel: i16,
    /// The relative motion in the Y direction
    yrel: i16,
};

/// Joystick hat position change event structure (event.jhat.*)
pub const JoyHatEvent = extern struct {
    /// `EventType.joystick_hat_motion`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The joystick instance id
    which: sdl.JoystickId,
    /// The joystick hat index
    hat: u8,
    /// The hat position value, see `HatState`.
    ///
    /// Note that zero means the POV is centered.
    value: sdl.HatState,
    padding1: u8 = 0,
    padding2: u8 = 0,
};

/// Joystick button event structure (event.jbutton.*)
pub const JoyButtonEvent = extern struct {
    /// `EventType.joystick_button_down` or `EventType.joystick_button_up`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The joystick instance id
    which: sdl.JoystickId,
    /// The joystick button index
    button: u8,
    /// true if the button is pressed
    down: bool,
    padding1: u8 = 0,
    padding2: u8 = 0,
};

/// Joystick device event structure (event.jdevice.*)
///
/// SDL will send JOYSTICK_ADDED events for devices that are already plugged in
/// during `init`.
pub const JoyDeviceEvent = extern struct {
    /// `EventType.joystick_added` or `EventType.joystick_removed` or `EventType.joystick_update_complete`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The joystick instance id
    which: sdl.JoystickId,
};

/// Joystick battery level change event structure (event.jbattery.*)
pub const JoyBatteryEvent = extern struct {
    /// `EventType.joystick_battery_updated`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The joystick instance id
    which: sdl.JoystickId,
    /// The joystick battery state
    state: sdl.PowerState,
    /// The joystick battery percent charge remaining
    percent: c_int,
};

/// Gamepad axis motion event structure (event.gaxis.*)
pub const GamepadAxisEvent = extern struct {
    /// `EventType.gamepad_axis_motion`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The joystick instance id
    which: sdl.JoystickId,
    /// The gamepad axis (`GamepadAxis`)
    axis: u8,
    padding1: u8 = 0,
    padding2: u8 = 0,
    padding3: u8 = 0,
    /// The axis value (range: -32768 to 32767)
    value: i16,
    padding4: u16 = 0,
};

/// Gamepad button event structure (event.gbutton.*)
pub const GamepadButtonEvent = extern struct {
    /// `EventType.gamepad_button_down` or `EventType.gamepad_button_up`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The joystick instance id
    which: sdl.JoystickId,
    /// The gamepad button (`GamepadButton`)
    button: u8,
    /// true if the button is pressed
    down: bool,
    padding1: u8 = 0,
    padding2: u8 = 0,
};

/// Gamepad device event structure (event.gdevice.*)
///
/// Joysticks that are supported gamepads receive both a `JoyDeviceEvent`
/// and a `GamepadDeviceEvent`.
///
/// SDL will send GAMEPAD_ADDED events for joysticks that are already plugged
/// in during `init` and are recognized as gamepads. It will also send
/// events for joysticks that get gamepad mappings at runtime.
pub const GamepadDeviceEvent = extern struct {
    /// `EventType.gamepad_added`, `EventType.gamepad_removed`, or `EventType.gamepad_remapped`, `EventType.gamepad_update_complete` or `EventType.gamepad_steam_handle_updated`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The joystick instance id
    which: sdl.JoystickId,
};

/// Gamepad touchpad event structure (event.gtouchpad.*)
pub const GamepadTouchpadEvent = extern struct {
    /// `EventType.gamepad_touchpad_down` or `EventType.gamepad_touchpad_motion` or `EventType.gamepad_touchpad_up`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The joystick instance id
    which: sdl.JoystickId,
    /// The index of the touchpad
    touchpad: i32,
    /// The index of the finger on the touchpad
    finger: i32,
    /// Normalized in the range 0...1 with 0 being on the left
    x: f32,
    /// Normalized in the range 0...1 with 0 being at the top
    y: f32,
    /// Normalized in the range 0...1
    pressure: f32,
};

/// Gamepad sensor event structure (event.gsensor.*)
pub const GamepadSensorEvent = extern struct {
    /// `EventType.gamepad_sensor_update`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The joystick instance id
    which: sdl.JoystickId,
    /// The type of the sensor, one of the values of `SensorType`
    sensor: i32,
    /// Up to 3 values from the sensor, as defined in SDL_sensor.h
    data: [3]f32,
    /// The timestamp of the sensor reading in nanoseconds, not necessarily synchronized with the system clock
    sensor_timestamp: u64,
};

/// Audio device event structure (event.adevice.*)
///
/// Note that SDL will send a `EventType.audio_device_added` event for every
/// device it discovers during initialization. After that, this event will only
/// arrive when a device is hotplugged during the program's run.
pub const AudioDeviceEvent = extern struct {
    /// `EventType.audio_device_added`, or `EventType.audio_device_removed`, or `EventType.audio_device_format_changed`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// `AudioDeviceId` for the device being added or removed or changing
    which: sdl.AudioDeviceId,
    /// false if a playback device, true if a recording device.
    recording: bool,
    padding1: u8 = 0,
    padding2: u8 = 0,
    padding3: u8 = 0,
};

/// Camera device event structure (event.cdevice.*)
pub const CameraDeviceEvent = extern struct {
    /// `EventType.camera_device_added`, `EventType.camera_device_removed`, `EventType.camera_device_approved`, `EventType.camera_device_denied`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// `CameraId` for the device being added or removed or changing
    which: sdl.CameraId,
};

/// Renderer event structure (event.render.*)
pub const RenderEvent = extern struct {
    /// `EventType.render_targets_reset`, `EventType.render_device_reset`, `EventType.render_device_lost`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The window containing the renderer in question.
    window_id: sdl.WindowId,
};

/// Touch finger event structure (event.tfinger.*)
///
/// Coordinates in this event are normalized. `x` and `y` are normalized to a
/// range between 0.0f and 1.0f, relative to the window, so (0,0) is the top
/// left and (1,1) is the bottom right. Delta coordinates `dx` and `dy` are
/// normalized in the ranges of -1.0f (traversed all the way from the bottom or
/// right to all the way up or left) to 1.0f (traversed all the way from the
/// top or left to all the way down or right).
///
/// Note that while the coordinates are _normalized_, they are not _clamped_,
/// which means in some circumstances you can get a value outside of this
/// range. For example, a renderer using logical presentation might give a
/// negative value when the touch is in the letterboxing. Some platforms might
/// report a touch outside of the window, which will also be outside of the
/// range.
pub const TouchFingerEvent = extern struct {
    /// `EventType.finger_down`, `EventType.finger_up`, `EventType.finger_motion`, or `EventType.finger_canceled`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The touch device id
    touch_id: sdl.TouchId,
    finger_id: sdl.FingerId,
    /// Normalized in the range 0...1
    x: f32,
    /// Normalized in the range 0...1
    y: f32,
    /// Normalized in the range -1...1
    dx: f32,
    /// Normalized in the range -1...1
    dy: f32,
    /// Normalized in the range 0...1
    pressure: f32,
    /// The window underneath the finger, if any
    window_id: sdl.WindowId,
};

/// Pinch event structure (event.pinch.*)
pub const PinchFingerEvent = extern struct {
    /// `EventType.pinch_begin` or `EventType.pinch_update` or `EventType.pinch_end`
    type: EventType,
    reserved: u32 = 0,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The scale change since the last `EventType.pinch_update`. Scale < 1 is "zoom out". Scale > 1 is "zoom in".
    scale: f32,
    /// The window underneath the finger, if any
    window_id: sdl.WindowId,
};

/// Pressure-sensitive pen proximity event structure (event.pproximity.*)
///
/// When a pen becomes visible to the system (it is close enough to a tablet,
/// etc), SDL will send an `EventType.pen_proximity_in` event with the new pen's
/// ID. This ID is valid until the pen leaves proximity again (has been removed
/// from the tablet's area, the tablet has been unplugged, etc). If the same
/// pen reenters proximity again, it will be given a new ID.
///
/// Note that "proximity" means "close enough for the tablet to know the tool
/// is there." The pen touching and lifting off from the tablet while not
/// leaving the area are handled by `EventType.pen_down` and `EventType.pen_up`.
///
/// Not all platforms have a window associated with the pen during proximity
/// events. Some wait until motion/button/etc events to offer this info.
pub const PenProximityEvent = extern struct {
    /// `EventType.pen_proximity_in` or `EventType.pen_proximity_out`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The window with pen focus, if any
    window_id: sdl.WindowId,
    /// The pen instance id
    which: sdl.PenId,
    /// Complete pen input state at time of event (added in 3.4.16).
    pen_state: sdl.PenInputFlags,
    /// the device type of the pen, if known (added in 3.4.18).
    device_type: sdl.PenDeviceType,
};

/// Pressure-sensitive pen motion event structure (event.pmotion.*)
///
/// Depending on the hardware, you may get motion events when the pen is not
/// touching a tablet, for tracking a pen even when it isn't drawing. You
/// should listen for `EventType.pen_down` and `EventType.pen_up` events, or check
/// `pen_state.down` to decide if a pen is "drawing" when
/// dealing with pen motion.
pub const PenMotionEvent = extern struct {
    /// `EventType.pen_motion`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The window with pen focus, if any
    window_id: sdl.WindowId,
    /// The pen instance id
    which: sdl.PenId,
    /// Complete pen input state at time of event
    pen_state: sdl.PenInputFlags,
    /// X coordinate, relative to window
    x: f32,
    /// Y coordinate, relative to window
    y: f32,
    /// the device type of the pen, if known (added in 3.4.18).
    device_type: sdl.PenDeviceType,
};

/// Pressure-sensitive pen touched event structure (event.ptouch.*)
///
/// These events come when a pen touches a surface (a tablet, etc), or lifts
/// off from one.
pub const PenTouchEvent = extern struct {
    /// `EventType.pen_down` or `EventType.pen_up`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The window with pen focus, if any
    window_id: sdl.WindowId,
    /// The pen instance id
    which: sdl.PenId,
    /// Complete pen input state at time of event
    pen_state: sdl.PenInputFlags,
    /// X coordinate, relative to window
    x: f32,
    /// Y coordinate, relative to window
    y: f32,
    /// true if eraser end is used (not all pens support this).
    eraser: bool,
    /// true if the pen is touching or false if the pen is lifted off
    down: bool,
    /// the device type of the pen, if known (added in 3.4.18).
    device_type: sdl.PenDeviceType,
};

/// Pressure-sensitive pen button event structure (event.pbutton.*)
///
/// This is for buttons on the pen itself that the user might click. The pen
/// itself pressing down to draw triggers a `EventType.pen_down` event instead.
pub const PenButtonEvent = extern struct {
    /// `EventType.pen_button_down` or `EventType.pen_button_up`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The window with mouse focus, if any
    window_id: sdl.WindowId,
    /// The pen instance id
    which: sdl.PenId,
    /// Complete pen input state at time of event
    pen_state: sdl.PenInputFlags,
    /// X coordinate, relative to window
    x: f32,
    /// Y coordinate, relative to window
    y: f32,
    /// The pen button index (first button is 1).
    button: u8,
    /// true if the button is pressed
    down: bool,
    /// the device type of the pen, if known (added in 3.4.18).
    device_type: sdl.PenDeviceType,
};

/// Pressure-sensitive pen pressure / angle event structure (event.paxis.*)
///
/// You might get some of these events even if the pen isn't touching the
/// tablet.
pub const PenAxisEvent = extern struct {
    /// `EventType.pen_axis`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The window with pen focus, if any
    window_id: sdl.WindowId,
    /// The pen instance id
    which: sdl.PenId,
    /// Complete pen input state at time of event
    pen_state: sdl.PenInputFlags,
    /// X coordinate, relative to window
    x: f32,
    /// Y coordinate, relative to window
    y: f32,
    /// Axis that has changed
    axis: sdl.PenAxis,
    /// New value of axis
    value: f32,
    /// the device type of the pen, if known (added in 3.4.18).
    device_type: sdl.PenDeviceType,
};

/// An event used to drop text or request a file open by the system
/// (event.drop.*)
pub const DropEvent = extern struct {
    /// `EventType.drop_begin` or `EventType.drop_file` or `EventType.drop_text` or `EventType.drop_complete` or `EventType.drop_position`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The window that was dropped on, if any
    window_id: sdl.WindowId,
    /// X coordinate, relative to window (not on begin)
    x: f32,
    /// Y coordinate, relative to window (not on begin)
    y: f32,
    /// The source app that sent this drop event, or null if that isn't available
    source: ?[*:0]const u8,
    /// The text for `EventType.drop_text` and the file name for `EventType.drop_file`, null for other events
    data: ?[*:0]const u8,
};

/// An event triggered when the clipboard contents have changed
/// (event.clipboard.*)
pub const ClipboardEvent = extern struct {
    /// `EventType.clipboard_update`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// are we owning the clipboard (internal update)
    owner: bool,
    /// number of mime types
    num_mime_types: i32,
    /// current mime types
    mime_types: ?*?[*:0]const u8,
};

/// Sensor event structure (event.sensor.*)
pub const SensorEvent = extern struct {
    /// `EventType.sensor_update`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The instance ID of the sensor
    which: sdl.SensorId,
    /// Up to 6 values from the sensor - additional values can be queried using `getSensorData`
    data: [6]f32,
    /// The timestamp of the sensor reading in nanoseconds, not necessarily synchronized with the system clock
    sensor_timestamp: u64,
};

/// The "quit requested" event
pub const QuitEvent = extern struct {
    /// `EventType.quit`
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
};

/// A user-defined event type (event.user.*)
///
/// This event is unique; it is never created by SDL, but only by the
/// application. The event can be pushed onto the event queue using
/// `pushEvent`. The contents of the structure members are completely up to
/// the programmer; the only requirement is that '''type''' is a value obtained
/// from `registerEvents`.
pub const UserEvent = extern struct {
    /// `EventType.user` through `EventType.last`, Uint32 because these are not in the `EventType` enumeration
    type: EventType,
    reserved: u32,
    /// In nanoseconds, populated using `getTicksNS`
    timestamp: u64,
    /// The associated window if any
    window_id: sdl.WindowId,
    /// User defined event code
    code: i32,
    /// User defined data pointer
    data1: ?*anyopaque,
    /// User defined data pointer
    data2: ?*anyopaque,
};

/// The structure for all events in SDL.
///
/// The `Event` structure is the core of all event handling in SDL. `Event`
/// is a union of all event structures used in SDL.
pub const Event = extern union {
    /// Event type, shared with all events, Uint32 to cover user events which are not in the `EventType` enumeration
    type: EventType,
    /// Common event data
    common: CommonEvent,
    /// Display event data
    display: DisplayEvent,
    /// Window event data
    window: WindowEvent,
    /// Keyboard device change event data
    kdevice: KeyboardDeviceEvent,
    /// Keyboard event data
    key: KeyboardEvent,
    /// Text editing event data
    edit: TextEditingEvent,
    /// Text editing candidates event data
    edit_candidates: TextEditingCandidatesEvent,
    /// Text input event data
    text: TextInputEvent,
    /// Mouse device change event data
    mdevice: MouseDeviceEvent,
    /// Mouse motion event data
    motion: MouseMotionEvent,
    /// Mouse button event data
    button: MouseButtonEvent,
    /// Mouse wheel event data
    wheel: MouseWheelEvent,
    /// Joystick device change event data
    jdevice: JoyDeviceEvent,
    /// Joystick axis event data
    jaxis: JoyAxisEvent,
    /// Joystick ball event data
    jball: JoyBallEvent,
    /// Joystick hat event data
    jhat: JoyHatEvent,
    /// Joystick button event data
    jbutton: JoyButtonEvent,
    /// Joystick battery event data
    jbattery: JoyBatteryEvent,
    /// Gamepad device event data
    gdevice: GamepadDeviceEvent,
    /// Gamepad axis event data
    gaxis: GamepadAxisEvent,
    /// Gamepad button event data
    gbutton: GamepadButtonEvent,
    /// Gamepad touchpad event data
    gtouchpad: GamepadTouchpadEvent,
    /// Gamepad sensor event data
    gsensor: GamepadSensorEvent,
    /// Audio device event data
    adevice: AudioDeviceEvent,
    /// Camera device event data
    cdevice: CameraDeviceEvent,
    /// Sensor event data
    sensor: SensorEvent,
    /// Quit request event data
    quit: QuitEvent,
    /// Custom event data
    user: UserEvent,
    /// Touch finger event data
    tfinger: TouchFingerEvent,
    /// Pinch event data
    pinch: PinchFingerEvent,
    /// Pen proximity event data
    pproximity: PenProximityEvent,
    /// Pen tip touching event data
    ptouch: PenTouchEvent,
    /// Pen motion event data
    pmotion: PenMotionEvent,
    /// Pen button event data
    pbutton: PenButtonEvent,
    /// Pen axis event data
    paxis: PenAxisEvent,
    /// Render event data
    render: RenderEvent,
    /// Drag and drop event data
    drop: DropEvent,
    /// Clipboard event data
    clipboard: ClipboardEvent,
    padding: [128]u8,
};

/// Pump the event loop, gathering events from the input devices.
///
/// This function updates the event queue and internal input device state.
///
/// `pumpEvents` gathers all the pending input information from devices and
/// places it in the event queue. Without calls to `pumpEvents` no events
/// would ever be placed on the queue. Often the need for calls to
/// `pumpEvents` is hidden from the user since `pollEvent` and
/// `waitEvent` implicitly call `pumpEvents`. However, if you are not
/// polling or waiting for events (e.g. you are filtering them), then you must
/// call `pumpEvents` to force an event queue update.
pub const pumpEvents = SDL_PumpEvents;
extern fn SDL_PumpEvents() void;

/// The type of action to request from `peepEvents`.
pub const EventAction = enum(c_int) {
    /// Add events to the back of the queue.
    addevent,
    /// Check but don't remove events from the queue front.
    peekevent,
    /// Retrieve/remove events from the front of the queue.
    getevent,
};

/// Check the event queue for messages and optionally return them.
///
/// `action` may be any of the following:
///
/// - `EventAction.addevent`: up to `numevents` events will be added to the back of the
///   event queue.
/// - `EventAction.peekevent`: `numevents` events at the front of the event queue,
///   within the specified minimum and maximum type, will be returned to the
///   caller and will _not_ be removed from the queue. If you pass null for
///   `events`, then `numevents` is ignored and the total number of matching
///   events will be returned.
/// - `EventAction.getevent`: up to `numevents` events at the front of the event queue,
///   within the specified minimum and maximum type, will be returned to the
///   caller and will be removed from the queue.
///
/// You may have to call `pumpEvents` before calling this function.
/// Otherwise, the events may not be ready to be filtered when you call
/// `peepEvents`.
pub fn peepEvents(events: ?[]Event, action: EventAction, minType: EventType, maxType: EventType) Error!c_int {
    const result = SDL_PeepEvents(if (events) |s| s.ptr else null, if (events) |s| @intCast(s.len) else 0, action, minType, maxType);
    if (result < 0) return makeError();
    return result;
}
extern fn SDL_PeepEvents(events: ?[*]Event, numevents: c_int, action: EventAction, minType: EventType, maxType: EventType) c_int;

/// Check for the existence of a certain event type in the event queue.
///
/// If you need to check for a range of event types, use `hasEvents`
/// instead.
pub const hasEvent = SDL_HasEvent;
extern fn SDL_HasEvent(@"type": EventType) bool;

/// Check for the existence of certain event types in the event queue.
///
/// If you need to check for a single event type, use `hasEvent` instead.
pub const hasEvents = SDL_HasEvents;
extern fn SDL_HasEvents(minType: EventType, maxType: EventType) bool;

/// Clear events of a specific type from the event queue.
///
/// This will unconditionally remove any events from the queue that match
/// `type`. If you need to remove a range of event types, use `flushEvents`
/// instead.
///
/// It's also normal to just ignore events you don't care about in your event
/// loop without calling this function.
///
/// This function only affects currently queued events. If you want to make
/// sure that all pending OS events are flushed, you can call `pumpEvents`
/// on the main thread immediately before the flush call.
///
/// If you have user events with custom data that needs to be freed, you should
/// use `peepEvents` to remove and clean up those events before calling
/// this function.
pub const flushEvent = SDL_FlushEvent;
extern fn SDL_FlushEvent(@"type": EventType) void;

/// Clear events of a range of types from the event queue.
///
/// This will unconditionally remove any events from the queue that are in the
/// range of `minType` to `maxType`, inclusive. If you need to remove a single
/// event type, use `flushEvent` instead.
///
/// It's also normal to just ignore events you don't care about in your event
/// loop without calling this function.
///
/// This function only affects currently queued events. If you want to make
/// sure that all pending OS events are flushed, you can call `pumpEvents`
/// on the main thread immediately before the flush call.
pub const flushEvents = SDL_FlushEvents;
extern fn SDL_FlushEvents(minType: EventType, maxType: EventType) void;

/// Poll for currently pending events.
///
/// If `event` is not null, the next event is removed from the queue and stored
/// in the `Event` structure pointed to by `event`.
///
/// If `event` is null, it simply returns true if there is an event in the
/// queue, but will not remove it from the queue.
///
/// As this function may implicitly call `pumpEvents`, you can only call
/// this function in the thread that initialized the video subsystem.
///
/// `pollEvent` is the favored way of receiving system events since it can
/// be done from the main loop and does not suspend the main loop while waiting
/// on an event to be posted.
///
/// The common practice is to fully process the event queue once every frame,
/// usually as a first step before updating the game's state:
///
/// ```c
/// while (game_is_still_running) {
///     SDL_Event event;
///     while (SDL_PollEvent(&event)) {  // poll until all events are handled!
///         // decide what to do with this event.
///     }
///
///     // update game state, draw the current frame
/// }
/// ```
///
/// Note that Windows (and possibly other platforms) has a quirk about how it
/// handles events while dragging/resizing a window, which can cause this
/// function to block for significant amounts of time. Technical explanations
/// and solutions are discussed on the wiki:
///
/// https://wiki.libsdl.org/SDL3/AppFreezeDuringDrag
pub const pollEvent = SDL_PollEvent;
extern fn SDL_PollEvent(event: ?*Event) bool;

/// Wait indefinitely for the next available event.
///
/// If `event` is not null, the next event is removed from the queue and stored
/// in the `Event` structure pointed to by `event`.
///
/// As this function may implicitly call `pumpEvents`, you can only call
/// this function in the thread that initialized the video subsystem.
pub fn waitEvent(event: ?*Event) Error!void {
    if (!SDL_WaitEvent(event)) return makeError();
}
extern fn SDL_WaitEvent(event: ?*Event) bool;

/// Wait until the specified timeout (in milliseconds) for the next available
/// event.
///
/// If `event` is not null, the next event is removed from the queue and stored
/// in the `Event` structure pointed to by `event`.
///
/// As this function may implicitly call `pumpEvents`, you can only call
/// this function in the thread that initialized the video subsystem.
///
/// The timeout is not guaranteed, the actual wait time could be longer due to
/// system scheduling.
pub const waitEventTimeout = SDL_WaitEventTimeout;
extern fn SDL_WaitEventTimeout(event: ?*Event, timeoutMS: i32) bool;

/// Add an event to the event queue.
///
/// The event queue can actually be used as a two way communication channel.
/// Not only can events be read from the queue, but the user can also push
/// their own events onto it. `event` is a pointer to the event structure you
/// wish to push onto the queue. The event is copied into the queue, and the
/// caller may dispose of the memory pointed to after `pushEvent` returns.
///
/// Note: Pushing device input events onto the queue doesn't modify the state
/// of the device within SDL.
///
/// Note: Events pushed onto the queue with `pushEvent` get passed through
/// the event filter but events added with `peepEvents` do not.
///
/// For pushing application-specific events, please use `registerEvents` to
/// get an event type that does not conflict with other code that also wants
/// its own custom event types.
///
/// Returns true on success, false if the event was filtered or on failure;
/// call `getError` for more information. A common reason for error is the
/// event queue being full.
pub const pushEvent = SDL_PushEvent;
extern fn SDL_PushEvent(event: *Event) bool;

/// A function pointer used for callbacks that watch the event queue.
pub const EventFilter = *const fn (userdata: ?*anyopaque, event: *Event) callconv(.c) bool;

/// Set up a filter to process all events before they are added to the internal
/// event queue.
///
/// If you just want to see events without modifying them or preventing them
/// from being queued, you should use `addEventWatch` instead.
///
/// If the filter function returns true when called, then the event will be
/// added to the internal queue. If it returns false, then the event will be
/// dropped from the queue, but the internal state will still be updated. This
/// allows selective filtering of dynamically arriving events.
///
/// **WARNING**: Be very careful of what you do in the event filter function,
/// as it may run in a different thread! The exception is handling of
/// `EventType.window_exposed`, which is guaranteed to be sent from the OS on the
/// main thread and you are expected to redraw your window in response to this
/// event.
///
/// On platforms that support it, if the quit event is generated by an
/// interrupt signal (e.g. pressing Ctrl-C), it will be delivered to the
/// application at the next event poll.
///
/// Note: Disabled events never make it to the event filter function; see
/// `setEventEnabled`.
///
/// Note: Events pushed onto the queue with `pushEvent` get passed through
/// the event filter, but events pushed onto the queue with `peepEvents` do
/// not.
pub const setEventFilter = SDL_SetEventFilter;
extern fn SDL_SetEventFilter(filter: ?EventFilter, userdata: ?*anyopaque) void;

/// Query the current event filter.
///
/// This function can be used to "chain" filters, by saving the existing filter
/// before replacing it with a function that will call that saved filter.
///
/// Returns null if there is no event filter set.
pub fn getEventFilter() ?struct { filter: EventFilter, userdata: ?*anyopaque } {
    var filter: EventFilter = undefined;
    var userdata: ?*anyopaque = undefined;
    if (!SDL_GetEventFilter(&filter, &userdata)) return null;
    return .{ .filter = filter, .userdata = userdata };
}
extern fn SDL_GetEventFilter(filter: *EventFilter, userdata: ?*?*anyopaque) bool;

/// Add a callback to be triggered when an event is added to the event queue.
///
/// `filter` will be called when an event happens, and its return value is
/// ignored.
///
/// **WARNING**: Be very careful of what you do in the event filter function,
/// as it may run in a different thread!
///
/// If the quit event is generated by a signal (e.g. SIGINT), it will bypass
/// the internal queue and be delivered to the watch callback immediately, and
/// arrive at the next event poll.
///
/// Note: the callback is called for events posted by the user through
/// `pushEvent`, but not for disabled events, nor for events by a filter
/// callback set with `setEventFilter`, nor for events posted by the user
/// through `peepEvents`.
pub fn addEventWatch(filter: EventFilter, userdata: ?*anyopaque) Error!void {
    if (!SDL_AddEventWatch(filter, userdata)) return makeError();
}
extern fn SDL_AddEventWatch(filter: EventFilter, userdata: ?*anyopaque) bool;

/// Remove an event watch callback added with `addEventWatch`.
///
/// This function takes the same input as `addEventWatch` to identify and
/// delete the corresponding callback.
pub const removeEventWatch = SDL_RemoveEventWatch;
extern fn SDL_RemoveEventWatch(filter: EventFilter, userdata: ?*anyopaque) void;

/// Run a specific filter function on the current event queue, removing any
/// events for which the filter returns false.
///
/// See `setEventFilter` for more information. Unlike `setEventFilter`,
/// this function does not change the filter permanently, it only uses the
/// supplied filter until this function returns.
pub const filterEvents = SDL_FilterEvents;
extern fn SDL_FilterEvents(filter: EventFilter, userdata: ?*anyopaque) void;

/// Set the state of processing events by type.
pub const setEventEnabled = SDL_SetEventEnabled;
extern fn SDL_SetEventEnabled(@"type": EventType, enabled: bool) void;

/// Query the state of processing events by type.
pub const eventEnabled = SDL_EventEnabled;
extern fn SDL_EventEnabled(@"type": EventType) bool;

/// Allocate a set of user-defined events, and return the beginning event
/// number for that set of events.
///
/// Returns the beginning event number, or null if `numevents` is invalid or if
/// there are not enough user-defined events left.
pub fn registerEvents(numevents: c_int) ?EventType {
    const first = SDL_RegisterEvents(numevents);
    if (first == 0) return null;
    return @fromBackingInt(@intCast(first));
}
extern fn SDL_RegisterEvents(numevents: c_int) u32;

/// Get window associated with an event.
pub const getWindowFromEvent = SDL_GetWindowFromEvent;
extern fn SDL_GetWindowFromEvent(event: *const Event) ?*sdl.Window;

/// Generate an English description of an event.
///
/// This will fill `buf` with a null-terminated string that might look
/// something like this:
///
/// ```
/// SDL_EVENT_MOUSE_MOTION (timestamp=1140256324 windowid=2 which=0 state=0 x=492.99 y=139.09 xrel=52 yrel=6)
/// ```
///
/// The exact format of the string is not guaranteed; it is intended for
/// logging purposes, to be read by a human, and not parsed by a computer.
///
/// The description is truncated if it doesn't fit in `buf`, which must not be
/// empty.
pub fn getEventDescription(event: *const Event, buf: []u8) [:0]u8 {
    const needed: usize = @intCast(SDL_GetEventDescription(event, buf.ptr, @intCast(buf.len)));
    const len = @min(needed, buf.len - 1);
    return buf[0..len :0];
}
extern fn SDL_GetEventDescription(event: ?*const Event, buf: ?[*]u8, buflen: c_int) c_int;
