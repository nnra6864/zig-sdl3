//! Joystick Support (SDL_joystick.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// The joystick structure used to identify an SDL joystick.
///
/// This is opaque data.
pub const Joystick = opaque {
    pub const Id = JoystickId;
    pub const Type = JoystickType;
    pub const ConnectionState = JoystickConnectionState;

    pub const Properties = struct {
        pub const cap_mono_led_boolean = "SDL.joystick.cap.mono_led";
        pub const cap_rgb_led_boolean = "SDL.joystick.cap.rgb_led";
        pub const cap_player_led_boolean = "SDL.joystick.cap.player_led";
        pub const cap_rumble_boolean = "SDL.joystick.cap.rumble";
        pub const cap_trigger_rumble_boolean = "SDL.joystick.cap.trigger_rumble";
    };
    pub const open = openJoystick;
    pub const getFromId = getJoystickFromId;
    pub const getFromPlayerIndex = getJoystickFromPlayerIndex;
    pub const setVirtualAxis = setJoystickVirtualAxis;
    pub const setVirtualBall = setJoystickVirtualBall;
    pub const setVirtualButton = setJoystickVirtualButton;
    pub const setVirtualHat = setJoystickVirtualHat;
    pub const setVirtualTouchpad = setJoystickVirtualTouchpad;
    pub const sendVirtualSensorData = sendJoystickVirtualSensorData;
    pub const getProperties = getJoystickProperties;
    pub const getName = getJoystickName;
    pub const getPath = getJoystickPath;
    pub const getPlayerIndex = getJoystickPlayerIndex;
    pub const setPlayerIndex = setJoystickPlayerIndex;
    pub const getGUID = getJoystickGUID;
    pub const getVendor = getJoystickVendor;
    pub const getProduct = getJoystickProduct;
    pub const getProductVersion = getJoystickProductVersion;
    pub const getFirmwareVersion = getJoystickFirmwareVersion;
    pub const getSerial = getJoystickSerial;
    pub const getType = getJoystickType;
    pub const connected = joystickConnected;
    pub const getId = getJoystickId;
    pub const getNumAxes = getNumJoystickAxes;
    pub const getNumBalls = getNumJoystickBalls;
    pub const getNumHats = getNumJoystickHats;
    pub const getNumButtons = getNumJoystickButtons;
    pub const getAxis = getJoystickAxis;
    pub const getAxisInitialState = getJoystickAxisInitialState;
    pub const getBall = getJoystickBall;
    pub const getHat = getJoystickHat;
    pub const getButton = getJoystickButton;
    pub const rumble = rumbleJoystick;
    pub const rumbleTriggers = rumbleJoystickTriggers;
    pub const setLED = setJoystickLED;
    pub const sendEffect = sendJoystickEffect;
    pub const close = closeJoystick;
    pub const getConnectionState = getJoystickConnectionState;
    pub const getPowerInfo = getJoystickPowerInfo;
};

/// This is a unique ID for a joystick for the time it is connected to the
/// system, and is never reused for the lifetime of the application.
///
/// If the joystick is disconnected and reconnected, it will get a new ID.
///
/// The value 0 is an invalid ID.
pub const JoystickId = enum(u32) { invalid = 0, _ };

/// An enum of some common joystick types.
///
/// In some cases, SDL can identify a low-level joystick as being a certain
/// type of device, and will report it through `getJoystickType` (or
/// `getJoystickTypeForId`).
///
/// This is by no means a complete list of everything that can be plugged into
/// a computer.
///
/// You may refer to
/// [XInput Controller Types](https://learn.microsoft.com/en-us/windows/win32/xinput/xinput-and-controller-subtypes)
/// table for a general understanding of each joystick type.
pub const JoystickType = enum(c_int) {
    unknown,
    gamepad,
    wheel,
    arcade_stick,
    flight_stick,
    dance_pad,
    guitar,
    drum_kit,
    arcade_pad,
    throttle,
    count,
};

/// Possible connection states for a joystick device.
///
/// This is used by `getJoystickConnectionState` to report how a device is
/// connected to the system.
pub const JoystickConnectionState = enum(c_int) {
    invalid = -1,
    unknown,
    wired,
    wireless,
};

/// The largest value a `Joystick`'s axis can report.
pub const joystick_axis_max = 32767;

/// The smallest value a `Joystick`'s axis can report.
///
/// This is a negative number!
pub const joystick_axis_min = -32768;

/// Locking for atomic access to the joystick API.
///
/// The SDL joystick functions are thread-safe, however you can lock the
/// joysticks while processing to guarantee that the joystick list won't change
/// and joystick and gamepad events will not be delivered.
pub const lockJoysticks = SDL_LockJoysticks;
extern fn SDL_LockJoysticks() void;

/// Unlocking for atomic access to the joystick API.
pub const unlockJoysticks = SDL_UnlockJoysticks;
extern fn SDL_UnlockJoysticks() void;

/// Return whether a joystick is currently connected.
pub const hasJoystick = SDL_HasJoystick;
extern fn SDL_HasJoystick() bool;

/// Get a list of currently connected joysticks.
///
/// The returned value should be freed with `free` when it is no longer needed.
pub fn getJoysticks() Error![]JoystickId {
    var count: c_int = undefined;
    const ptr = SDL_GetJoysticks(&count) orelse return makeError();
    return ptr[0..@intCast(count)];
}
extern fn SDL_GetJoysticks(count: ?*c_int) ?[*]JoystickId;

/// Get the implementation dependent name of a joystick.
///
/// This can be called before any joysticks are opened.
pub fn getJoystickNameForId(instance_id: JoystickId) ?[:0]const u8 {
    const str = SDL_GetJoystickNameForID(instance_id) orelse return null;
    return std.mem.span(str);
}
extern fn SDL_GetJoystickNameForID(instance_id: JoystickId) ?[*:0]const u8;

/// Get the implementation dependent path of a joystick.
///
/// This can be called before any joysticks are opened.
pub fn getJoystickPathForId(instance_id: JoystickId) ?[:0]const u8 {
    const str = SDL_GetJoystickPathForID(instance_id) orelse return null;
    return std.mem.span(str);
}
extern fn SDL_GetJoystickPathForID(instance_id: JoystickId) ?[*:0]const u8;

/// Get the player index of a joystick.
///
/// This can be called before any joysticks are opened.
pub fn getJoystickPlayerIndexForId(instance_id: JoystickId) Error!c_int {
    const result = SDL_GetJoystickPlayerIndexForID(instance_id);
    if (result < 0) return makeError();
    return result;
}
extern fn SDL_GetJoystickPlayerIndexForID(instance_id: JoystickId) c_int;

/// Get the implementation-dependent GUID of a joystick.
///
/// This can be called before any joysticks are opened.
pub const getJoystickGUIDForId = SDL_GetJoystickGUIDForID;
extern fn SDL_GetJoystickGUIDForID(instance_id: JoystickId) sdl.GUID;

/// Get the USB vendor ID of a joystick, if available.
///
/// This can be called before any joysticks are opened. If the vendor ID isn't
/// available this function returns 0.
pub const getJoystickVendorForId = SDL_GetJoystickVendorForID;
extern fn SDL_GetJoystickVendorForID(instance_id: JoystickId) u16;

/// Get the USB product ID of a joystick, if available.
///
/// This can be called before any joysticks are opened. If the product ID isn't
/// available this function returns 0.
pub const getJoystickProductForId = SDL_GetJoystickProductForID;
extern fn SDL_GetJoystickProductForID(instance_id: JoystickId) u16;

/// Get the product version of a joystick, if available.
///
/// This can be called before any joysticks are opened. If the product version
/// isn't available this function returns 0.
pub const getJoystickProductVersionForId = SDL_GetJoystickProductVersionForID;
extern fn SDL_GetJoystickProductVersionForID(instance_id: JoystickId) u16;

/// Get the type of a joystick, if available.
///
/// This can be called before any joysticks are opened.
pub const getJoystickTypeForId = SDL_GetJoystickTypeForID;
extern fn SDL_GetJoystickTypeForID(instance_id: JoystickId) JoystickType;

/// Open a joystick for use.
///
/// The joystick subsystem must be initialized before a joystick can be opened
/// for use.
pub fn openJoystick(instance_id: JoystickId) Error!*Joystick {
    return SDL_OpenJoystick(instance_id) orelse makeError();
}
extern fn SDL_OpenJoystick(instance_id: JoystickId) ?*Joystick;

/// Get the `Joystick` associated with an instance ID, if it has been opened.
pub fn getJoystickFromId(instance_id: JoystickId) Error!*Joystick {
    return SDL_GetJoystickFromID(instance_id) orelse makeError();
}
extern fn SDL_GetJoystickFromID(instance_id: JoystickId) ?*Joystick;

/// Get the `Joystick` associated with a player index.
pub fn getJoystickFromPlayerIndex(player_index: c_int) Error!*Joystick {
    return SDL_GetJoystickFromPlayerIndex(player_index) orelse makeError();
}
extern fn SDL_GetJoystickFromPlayerIndex(player_index: c_int) ?*Joystick;

/// The structure that describes a virtual joystick touchpad.
pub const VirtualJoystickTouchpadDesc = extern struct {
    /// the number of simultaneous fingers on this touchpad
    nfingers: u16,
    padding: [3]u16 = @splat(0),
};

/// The structure that describes a virtual joystick sensor.
pub const VirtualJoystickSensorDesc = extern struct {
    /// the type of this sensor
    type: sdl.SensorType,
    /// the update frequency of this sensor, may be 0.0f
    rate: f32,
};

/// The structure that describes a virtual joystick.
///
/// This structure should be initialized using SDL_INIT_INTERFACE(). All
/// elements of this structure are optional.
pub const VirtualJoystickDesc = extern struct {
    /// the version of this interface
    version: u32,
    /// `JoystickType`
    type: u16,
    /// unused
    padding: u16 = 0,
    /// the USB vendor ID of this joystick
    vendor_id: u16,
    /// the USB product ID of this joystick
    product_id: u16,
    /// the number of axes on this joystick
    naxes: u16,
    /// the number of buttons on this joystick
    nbuttons: u16,
    /// the number of balls on this joystick
    nballs: u16,
    /// the number of hats on this joystick
    nhats: u16,
    /// the number of touchpads on this joystick, requires `touchpads` to point at valid descriptions
    ntouchpads: u16,
    /// the number of sensors on this joystick, requires `sensors` to point at valid descriptions
    nsensors: u16,
    /// unused
    padding2: [2]u16 = @splat(0),
    /// A mask of which buttons are valid for this controller e.g. (1 << `GamepadButton.south`)
    button_mask: u32,
    /// A mask of which axes are valid for this controller e.g. (1 << `GamepadAxis.leftx`)
    axis_mask: u32,
    /// the name of the joystick
    name: ?[*:0]const u8,
    /// A pointer to an array of touchpad descriptions, required if `ntouchpads` is > 0
    touchpads: ?*const VirtualJoystickTouchpadDesc,
    /// A pointer to an array of sensor descriptions, required if `nsensors` is > 0
    sensors: ?*const VirtualJoystickSensorDesc,
    /// User data pointer passed to callbacks
    userdata: ?*anyopaque,
    /// Called when the joystick state should be updated
    update: ?*const fn (userdata: ?*anyopaque) callconv(.c) void,
    /// Called when the player index is set
    setPlayerIndex: ?*const fn (userdata: ?*anyopaque, player_index: c_int) callconv(.c) void,
    /// Implements `rumbleJoystick`
    rumble: ?*const fn (userdata: ?*anyopaque, low_frequency_rumble: u16, high_frequency_rumble: u16) callconv(.c) bool,
    /// Implements `rumbleJoystickTriggers`
    rumbleTriggers: ?*const fn (userdata: ?*anyopaque, left_rumble: u16, right_rumble: u16) callconv(.c) bool,
    /// Implements `setJoystickLED`
    setLED: ?*const fn (userdata: ?*anyopaque, red: u8, green: u8, blue: u8) callconv(.c) bool,
    /// Implements `sendJoystickEffect`
    sendEffect: ?*const fn (userdata: ?*anyopaque, data: ?*const anyopaque, size: c_int) callconv(.c) bool,
    /// Implements `setGamepadSensorEnabled`
    setSensorsEnabled: ?*const fn (userdata: ?*anyopaque, enabled: bool) callconv(.c) bool,
    /// Cleans up the userdata when the joystick is detached
    cleanup: ?*const fn (userdata: ?*anyopaque) callconv(.c) void,
};

/// Attach a new virtual joystick.
///
/// Apps can create virtual joysticks, that exist without hardware directly
/// backing them, and have program-supplied inputs. Once attached, a virtual
/// joystick looks like any other joystick that SDL can access. These can be
/// used to make other things look like joysticks, or provide pre-recorded
/// input, etc.
///
/// Once attached, the app can send joystick inputs to the new virtual joystick
/// using `setJoystickVirtualAxis`, etc.
///
/// When no longer needed, the virtual joystick can be removed by calling
/// `detachVirtualJoystick`.
pub fn attachVirtualJoystick(desc: *const VirtualJoystickDesc) Error!JoystickId {
    const result = SDL_AttachVirtualJoystick(desc);
    if (@backingInt(result) == 0) return makeError();
    return result;
}
extern fn SDL_AttachVirtualJoystick(desc: *const VirtualJoystickDesc) JoystickId;

/// Detach a virtual joystick.
pub fn detachVirtualJoystick(instance_id: JoystickId) Error!void {
    if (!SDL_DetachVirtualJoystick(instance_id)) return makeError();
}
extern fn SDL_DetachVirtualJoystick(instance_id: JoystickId) bool;

/// Query whether or not a joystick is virtual.
pub const isJoystickVirtual = SDL_IsJoystickVirtual;
extern fn SDL_IsJoystickVirtual(instance_id: JoystickId) bool;

/// Set the state of an axis on an opened virtual joystick.
///
/// Please note that values set here will not be applied until the next call to
/// `updateJoysticks`, which can either be called directly, or can be called
/// indirectly through various other SDL APIs, including, but not limited to
/// the following: `pollEvent`, `pumpEvents`, `waitEventTimeout`,
/// `waitEvent`.
///
/// Note that when sending trigger axes, you should scale the value to the full
/// range of Sint16. For example, a trigger at rest would have the value of
/// `joystick_axis_min`.
pub fn setJoystickVirtualAxis(joystick: *Joystick, axis: c_int, value: i16) Error!void {
    if (!SDL_SetJoystickVirtualAxis(joystick, axis, value)) return makeError();
}
extern fn SDL_SetJoystickVirtualAxis(joystick: *Joystick, axis: c_int, value: i16) bool;

/// Generate ball motion on an opened virtual joystick.
///
/// Please note that values set here will not be applied until the next call to
/// `updateJoysticks`, which can either be called directly, or can be called
/// indirectly through various other SDL APIs, including, but not limited to
/// the following: `pollEvent`, `pumpEvents`, `waitEventTimeout`,
/// `waitEvent`.
pub fn setJoystickVirtualBall(joystick: *Joystick, ball: c_int, xrel: i16, yrel: i16) Error!void {
    if (!SDL_SetJoystickVirtualBall(joystick, ball, xrel, yrel)) return makeError();
}
extern fn SDL_SetJoystickVirtualBall(joystick: *Joystick, ball: c_int, xrel: i16, yrel: i16) bool;

/// Set the state of a button on an opened virtual joystick.
///
/// Please note that values set here will not be applied until the next call to
/// `updateJoysticks`, which can either be called directly, or can be called
/// indirectly through various other SDL APIs, including, but not limited to
/// the following: `pollEvent`, `pumpEvents`, `waitEventTimeout`,
/// `waitEvent`.
pub fn setJoystickVirtualButton(joystick: *Joystick, button: c_int, down: bool) Error!void {
    if (!SDL_SetJoystickVirtualButton(joystick, button, down)) return makeError();
}
extern fn SDL_SetJoystickVirtualButton(joystick: *Joystick, button: c_int, down: bool) bool;

/// Set the state of a hat on an opened virtual joystick.
///
/// Please note that values set here will not be applied until the next call to
/// `updateJoysticks`, which can either be called directly, or can be called
/// indirectly through various other SDL APIs, including, but not limited to
/// the following: `pollEvent`, `pumpEvents`, `waitEventTimeout`,
/// `waitEvent`.
pub fn setJoystickVirtualHat(joystick: *Joystick, hat: c_int, value: HatState) Error!void {
    if (!SDL_SetJoystickVirtualHat(joystick, hat, value)) return makeError();
}
extern fn SDL_SetJoystickVirtualHat(joystick: *Joystick, hat: c_int, value: HatState) bool;

/// Set touchpad finger state on an opened virtual joystick.
///
/// Please note that values set here will not be applied until the next call to
/// `updateJoysticks`, which can either be called directly, or can be called
/// indirectly through various other SDL APIs, including, but not limited to
/// the following: `pollEvent`, `pumpEvents`, `waitEventTimeout`,
/// `waitEvent`.
pub fn setJoystickVirtualTouchpad(joystick: *Joystick, touchpad: c_int, finger: c_int, down: bool, x: f32, y: f32, pressure: f32) Error!void {
    if (!SDL_SetJoystickVirtualTouchpad(joystick, touchpad, finger, down, x, y, pressure)) return makeError();
}
extern fn SDL_SetJoystickVirtualTouchpad(joystick: *Joystick, touchpad: c_int, finger: c_int, down: bool, x: f32, y: f32, pressure: f32) bool;

/// Send a sensor update for an opened virtual joystick.
///
/// Please note that values set here will not be applied until the next call to
/// `updateJoysticks`, which can either be called directly, or can be called
/// indirectly through various other SDL APIs, including, but not limited to
/// the following: `pollEvent`, `pumpEvents`, `waitEventTimeout`,
/// `waitEvent`.
pub fn sendJoystickVirtualSensorData(joystick: *Joystick, @"type": sdl.SensorType, sensor_timestamp: u64, data: []const f32) Error!void {
    if (!SDL_SendJoystickVirtualSensorData(joystick, @"type", sensor_timestamp, data.ptr, @intCast(data.len))) return makeError();
}
extern fn SDL_SendJoystickVirtualSensorData(joystick: *Joystick, @"type": sdl.SensorType, sensor_timestamp: u64, data: [*]const f32, num_values: c_int) bool;

/// Get the properties associated with a joystick.
///
/// The following read-only properties are provided by SDL:
///
/// - `Joystick.Properties.cap_mono_led_boolean`: true if this joystick has an
///   LED that has adjustable brightness
/// - `Joystick.Properties.cap_rgb_led_boolean`: true if this joystick has an LED
///   that has adjustable color
/// - `Joystick.Properties.cap_player_led_boolean`: true if this joystick has a
///   player LED
/// - `Joystick.Properties.cap_rumble_boolean`: true if this joystick has
///   left/right rumble
/// - `Joystick.Properties.cap_trigger_rumble_boolean`: true if this joystick has
///   simple trigger rumble
pub fn getJoystickProperties(joystick: *Joystick) Error!sdl.PropertiesId {
    const result = SDL_GetJoystickProperties(joystick);
    if (@backingInt(result) == 0) return makeError();
    return result;
}
extern fn SDL_GetJoystickProperties(joystick: *Joystick) sdl.PropertiesId;

/// Get the implementation dependent name of a joystick.
pub fn getJoystickName(joystick: *Joystick) ?[:0]const u8 {
    const str = SDL_GetJoystickName(joystick) orelse return null;
    return std.mem.span(str);
}
extern fn SDL_GetJoystickName(joystick: *Joystick) ?[*:0]const u8;

/// Get the implementation dependent path of a joystick.
pub fn getJoystickPath(joystick: *Joystick) ?[:0]const u8 {
    const str = SDL_GetJoystickPath(joystick) orelse return null;
    return std.mem.span(str);
}
extern fn SDL_GetJoystickPath(joystick: *Joystick) ?[*:0]const u8;

/// Get the player index of an opened joystick.
///
/// For XInput controllers this returns the XInput user index. Many joysticks
/// will not be able to supply this information.
pub fn getJoystickPlayerIndex(joystick: *Joystick) Error!c_int {
    const result = SDL_GetJoystickPlayerIndex(joystick);
    if (result < 0) return makeError();
    return result;
}
extern fn SDL_GetJoystickPlayerIndex(joystick: *Joystick) c_int;

/// Set the player index of an opened joystick.
pub fn setJoystickPlayerIndex(joystick: *Joystick, player_index: c_int) Error!void {
    if (!SDL_SetJoystickPlayerIndex(joystick, player_index)) return makeError();
}
extern fn SDL_SetJoystickPlayerIndex(joystick: *Joystick, player_index: c_int) bool;

/// Get the implementation-dependent GUID for the joystick.
///
/// This function requires an open joystick.
pub const getJoystickGUID = SDL_GetJoystickGUID;
extern fn SDL_GetJoystickGUID(joystick: *Joystick) sdl.GUID;

/// Get the USB vendor ID of an opened joystick, if available.
///
/// If the vendor ID isn't available this function returns 0.
pub const getJoystickVendor = SDL_GetJoystickVendor;
extern fn SDL_GetJoystickVendor(joystick: *Joystick) u16;

/// Get the USB product ID of an opened joystick, if available.
///
/// If the product ID isn't available this function returns 0.
pub const getJoystickProduct = SDL_GetJoystickProduct;
extern fn SDL_GetJoystickProduct(joystick: *Joystick) u16;

/// Get the product version of an opened joystick, if available.
///
/// If the product version isn't available this function returns 0.
pub const getJoystickProductVersion = SDL_GetJoystickProductVersion;
extern fn SDL_GetJoystickProductVersion(joystick: *Joystick) u16;

/// Get the firmware version of an opened joystick, if available.
///
/// If the firmware version isn't available this function returns 0.
pub const getJoystickFirmwareVersion = SDL_GetJoystickFirmwareVersion;
extern fn SDL_GetJoystickFirmwareVersion(joystick: *Joystick) u16;

/// Get the serial number of an opened joystick, if available.
///
/// Returns the serial number of the joystick, or null if it is not available.
pub fn getJoystickSerial(joystick: *Joystick) ?[:0]const u8 {
    const str = SDL_GetJoystickSerial(joystick) orelse return null;
    return std.mem.span(str);
}
extern fn SDL_GetJoystickSerial(joystick: *Joystick) ?[*:0]const u8;

/// Get the type of an opened joystick.
pub const getJoystickType = SDL_GetJoystickType;
extern fn SDL_GetJoystickType(joystick: *Joystick) JoystickType;

/// Get the device information encoded in a `GUID` structure.
pub const getJoystickGUIDInfo = SDL_GetJoystickGUIDInfo;
extern fn SDL_GetJoystickGUIDInfo(guid: sdl.GUID, vendor: *u16, product: *u16, version: *u16, crc16: *u16) void;

/// Get the status of a specified joystick.
pub const joystickConnected = SDL_JoystickConnected;
extern fn SDL_JoystickConnected(joystick: *Joystick) bool;

/// Get the instance ID of an opened joystick.
pub fn getJoystickId(joystick: *Joystick) Error!JoystickId {
    const result = SDL_GetJoystickID(joystick);
    if (@backingInt(result) == 0) return makeError();
    return result;
}
extern fn SDL_GetJoystickID(joystick: *Joystick) JoystickId;

/// Get the number of general axis controls on a joystick.
///
/// Often, the directional pad on a game controller will either look like 4
/// separate buttons or a POV hat, and not axes, but all of this is up to the
/// device and platform.
pub fn getNumJoystickAxes(joystick: *Joystick) Error!c_int {
    const result = SDL_GetNumJoystickAxes(joystick);
    if (result < 0) return makeError();
    return result;
}
extern fn SDL_GetNumJoystickAxes(joystick: *Joystick) c_int;

/// Get the number of trackballs on a joystick.
///
/// Joystick trackballs have only relative motion events associated with them
/// and their state cannot be polled.
///
/// Most joysticks do not have trackballs.
pub fn getNumJoystickBalls(joystick: *Joystick) Error!c_int {
    const result = SDL_GetNumJoystickBalls(joystick);
    if (result < 0) return makeError();
    return result;
}
extern fn SDL_GetNumJoystickBalls(joystick: *Joystick) c_int;

/// Get the number of POV hats on a joystick.
pub fn getNumJoystickHats(joystick: *Joystick) Error!c_int {
    const result = SDL_GetNumJoystickHats(joystick);
    if (result < 0) return makeError();
    return result;
}
extern fn SDL_GetNumJoystickHats(joystick: *Joystick) c_int;

/// Get the number of buttons on a joystick.
pub fn getNumJoystickButtons(joystick: *Joystick) Error!c_int {
    const result = SDL_GetNumJoystickButtons(joystick);
    if (result < 0) return makeError();
    return result;
}
extern fn SDL_GetNumJoystickButtons(joystick: *Joystick) c_int;

/// Set the state of joystick event processing.
///
/// If joystick events are disabled, you must call `updateJoysticks`
/// yourself and check the state of the joystick when you want joystick
/// information.
pub const setJoystickEventsEnabled = SDL_SetJoystickEventsEnabled;
extern fn SDL_SetJoystickEventsEnabled(enabled: bool) void;

/// Query the state of joystick event processing.
///
/// If joystick events are disabled, you must call `updateJoysticks`
/// yourself and check the state of the joystick when you want joystick
/// information.
pub const joystickEventsEnabled = SDL_JoystickEventsEnabled;
extern fn SDL_JoystickEventsEnabled() bool;

/// Update the current state of the open joysticks.
///
/// This is called automatically by the event loop if any joystick events are
/// enabled.
pub const updateJoysticks = SDL_UpdateJoysticks;
extern fn SDL_UpdateJoysticks() void;

/// Get the current state of an axis control on a joystick.
///
/// SDL makes no promises about what part of the joystick any given axis refers
/// to. Your game should have some sort of configuration UI to let users
/// specify what each axis should be bound to. Alternately, SDL's higher-level
/// Game Controller API makes a great effort to apply order to this lower-level
/// interface, so you know that a specific axis is the "left thumb stick," etc.
///
/// The value returned by `getJoystickAxis` is a signed integer (-32768 to
/// 32767) representing the current position of the axis. It may be necessary
/// to impose certain tolerances on these values to account for jitter.
///
/// Returns 0 on failure; call `getError` for more information.
pub const getJoystickAxis = SDL_GetJoystickAxis;
extern fn SDL_GetJoystickAxis(joystick: *Joystick, axis: c_int) i16;

/// Get the initial state of an axis control on a joystick.
///
/// The state is a value ranging from -32768 to 32767.
///
/// The axis indices start at index 0.
///
/// Returns null if this axis doesn't have an initial value.
pub fn getJoystickAxisInitialState(joystick: *Joystick, axis: c_int) ?i16 {
    var state: i16 = undefined;
    if (!SDL_GetJoystickAxisInitialState(joystick, axis, &state)) return null;
    return state;
}
extern fn SDL_GetJoystickAxisInitialState(joystick: *Joystick, axis: c_int, state: *i16) bool;

/// Get the ball axis change since the last poll.
///
/// Trackballs can only return relative motion since the last call to
/// `getJoystickBall`, these motion deltas are placed into `dx` and `dy`.
///
/// Most joysticks do not have trackballs.
pub fn getJoystickBall(joystick: *Joystick, ball: c_int, dx: *c_int, dy: *c_int) Error!void {
    if (!SDL_GetJoystickBall(joystick, ball, dx, dy)) return makeError();
}
extern fn SDL_GetJoystickBall(joystick: *Joystick, ball: c_int, dx: *c_int, dy: *c_int) bool;

/// Get the current state of a POV hat on a joystick.
///
pub const getJoystickHat = SDL_GetJoystickHat;
extern fn SDL_GetJoystickHat(joystick: *Joystick, hat: c_int) HatState;

/// The state of a joystick hat (POV), as reported by `getJoystickHat` and
/// joystick hat events.
///
/// Note that zero (all fields false) means the POV is centered.
pub const HatState = packed struct(u8) {
    up: bool = false,
    right: bool = false,
    down: bool = false,
    left: bool = false,
    __unused4: u4 = 0,

    pub const centered: HatState = .{};
    pub const right_up: HatState = .{ .right = true, .up = true };
    pub const right_down: HatState = .{ .right = true, .down = true };
    pub const left_up: HatState = .{ .left = true, .up = true };
    pub const left_down: HatState = .{ .left = true, .down = true };
};

/// Get the current state of a button on a joystick.
pub const getJoystickButton = SDL_GetJoystickButton;
extern fn SDL_GetJoystickButton(joystick: *Joystick, button: c_int) bool;

/// Start a rumble effect.
///
/// Each call to this function cancels any previous rumble effect, and calling
/// it with 0 intensity stops any rumbling.
///
/// This function requires you to process SDL events or call
/// `updateJoysticks` to update rumble state.
pub const rumbleJoystick = SDL_RumbleJoystick;
extern fn SDL_RumbleJoystick(joystick: *Joystick, low_frequency_rumble: u16, high_frequency_rumble: u16, duration_ms: u32) bool;

/// Start a rumble effect in the joystick's triggers.
///
/// Each call to this function cancels any previous trigger rumble effect, and
/// calling it with 0 intensity stops any rumbling.
///
/// Note that this is rumbling of the _triggers_ and not the game controller as
/// a whole. This is currently only supported on Xbox One controllers. If you
/// want the (more common) whole-controller rumble, use `rumbleJoystick`
/// instead.
///
/// This function requires you to process SDL events or call
/// `updateJoysticks` to update rumble state.
pub fn rumbleJoystickTriggers(joystick: *Joystick, left_rumble: u16, right_rumble: u16, duration_ms: u32) Error!void {
    if (!SDL_RumbleJoystickTriggers(joystick, left_rumble, right_rumble, duration_ms)) return makeError();
}
extern fn SDL_RumbleJoystickTriggers(joystick: *Joystick, left_rumble: u16, right_rumble: u16, duration_ms: u32) bool;

/// Update a joystick's LED color.
///
/// An example of a joystick LED is the light on the back of a PlayStation 4's
/// DualShock 4 controller.
///
/// For joysticks with a single color LED, the maximum of the RGB values will
/// be used as the LED brightness.
pub fn setJoystickLED(joystick: *Joystick, red: u8, green: u8, blue: u8) Error!void {
    if (!SDL_SetJoystickLED(joystick, red, green, blue)) return makeError();
}
extern fn SDL_SetJoystickLED(joystick: *Joystick, red: u8, green: u8, blue: u8) bool;

/// Send a joystick specific effect packet.
pub fn sendJoystickEffect(joystick: *Joystick, data: *const anyopaque, size: c_int) Error!void {
    if (!SDL_SendJoystickEffect(joystick, data, size)) return makeError();
}
extern fn SDL_SendJoystickEffect(joystick: *Joystick, data: *const anyopaque, size: c_int) bool;

/// Close a joystick previously opened with `openJoystick`.
pub const closeJoystick = SDL_CloseJoystick;
extern fn SDL_CloseJoystick(joystick: *Joystick) void;

/// Get the connection state of a joystick.
pub fn getJoystickConnectionState(joystick: *Joystick) Error!JoystickConnectionState {
    const state = SDL_GetJoystickConnectionState(joystick);
    if (state == .invalid) return makeError();
    return state;
}
extern fn SDL_GetJoystickConnectionState(joystick: *Joystick) JoystickConnectionState;

/// Get the battery state of a joystick.
///
/// You should never take a battery status as absolute truth. Batteries
/// (especially failing batteries) are delicate hardware, and the values
/// reported here are best estimates based on what that hardware reports. It's
/// not uncommon for older batteries to lose stored power much faster than it
/// reports, or completely drain when reporting it has 20 percent left, etc.
///
/// `percent` is -1 if it can't be determined.
pub fn getJoystickPowerInfo(joystick: *Joystick) Error!struct { state: sdl.PowerState, percent: c_int } {
    var percent: c_int = undefined;
    const state = SDL_GetJoystickPowerInfo(joystick, &percent);
    if (state == .@"error") return makeError();
    return .{ .state = state, .percent = percent };
}
extern fn SDL_GetJoystickPowerInfo(joystick: *Joystick, percent: ?*c_int) sdl.PowerState;
