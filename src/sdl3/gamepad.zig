//! Gamepad Support (SDL_gamepad.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// The structure used to identify an SDL gamepad
pub const Gamepad = opaque {
    pub const Type = GamepadType;
    pub const Button = GamepadButton;
    pub const ButtonLabel = GamepadButtonLabel;
    pub const Axis = GamepadAxis;
    pub const BindingType = GamepadBindingType;
    pub const Binding = GamepadBinding;

    pub const Properties = struct {
        pub const cap_mono_led_boolean = sdl.Joystick.Properties.cap_mono_led_boolean;
        pub const cap_rgb_led_boolean = sdl.Joystick.Properties.cap_rgb_led_boolean;
        pub const cap_player_led_boolean = sdl.Joystick.Properties.cap_player_led_boolean;
        pub const cap_rumble_boolean = sdl.Joystick.Properties.cap_rumble_boolean;
        pub const cap_trigger_rumble_boolean = sdl.Joystick.Properties.cap_trigger_rumble_boolean;
    };
    pub const getMapping = getGamepadMapping;
    pub const open = openGamepad;
    pub const getFromId = getGamepadFromId;
    pub const getFromPlayerIndex = getGamepadFromPlayerIndex;
    pub const getProperties = getGamepadProperties;
    pub const getId = getGamepadId;
    pub const getName = getGamepadName;
    pub const getPath = getGamepadPath;
    pub const getType = getGamepadType;
    pub const getRealType = getRealGamepadType;
    pub const getPlayerIndex = getGamepadPlayerIndex;
    pub const setPlayerIndex = setGamepadPlayerIndex;
    pub const getVendor = getGamepadVendor;
    pub const getProduct = getGamepadProduct;
    pub const getProductVersion = getGamepadProductVersion;
    pub const getFirmwareVersion = getGamepadFirmwareVersion;
    pub const getSerial = getGamepadSerial;
    pub const getSteamHandle = getGamepadSteamHandle;
    pub const getConnectionState = getGamepadConnectionState;
    pub const getPowerInfo = getGamepadPowerInfo;
    pub const connected = gamepadConnected;
    pub const getJoystick = getGamepadJoystick;
    pub const getBindings = getGamepadBindings;
    pub const hasAxis = gamepadHasAxis;
    pub const getAxis = getGamepadAxis;
    pub const hasButton = gamepadHasButton;
    pub const getButton = getGamepadButton;
    pub const getButtonLabel = getGamepadButtonLabel;
    pub const getNumTouchpads = getNumGamepadTouchpads;
    pub const getNumTouchpadFingers = getNumGamepadTouchpadFingers;
    pub const getTouchpadFinger = getGamepadTouchpadFinger;
    pub const hasSensor = gamepadHasSensor;
    pub const setSensorEnabled = setGamepadSensorEnabled;
    pub const sensorEnabled = gamepadSensorEnabled;
    pub const getSensorDataRate = getGamepadSensorDataRate;
    pub const getSensorData = getGamepadSensorData;
    pub const rumble = rumbleGamepad;
    pub const rumbleTriggers = rumbleGamepadTriggers;
    pub const setLED = setGamepadLED;
    pub const sendEffect = sendGamepadEffect;
    pub const close = closeGamepad;
    pub const getAppleSFSymbolsNameForButton = getGamepadAppleSFSymbolsNameForButton;
    pub const getAppleSFSymbolsNameForAxis = getGamepadAppleSFSymbolsNameForAxis;
};

/// Standard gamepad types.
///
/// This type does not necessarily map to first-party controllers from
/// Microsoft/Sony/Nintendo; in many cases, third-party controllers can report
/// as these, either because they were designed for a specific console, or they
/// simply most closely match that console's controllers (does it have A/B/X/Y
/// buttons or X/O/Square/Triangle? Does it have a touchpad? etc).
pub const GamepadType = enum(c_int) {
    unknown = 0,
    standard,
    xbox360,
    xboxone,
    ps3,
    ps4,
    ps5,
    nintendo_switch_pro,
    nintendo_switch_joycon_left,
    nintendo_switch_joycon_right,
    nintendo_switch_joycon_pair,
    gamecube,
    steam,
    count,
};

/// The list of buttons available on a gamepad
///
/// For controllers that use a diamond pattern for the face buttons, the
/// south/east/west/north buttons below correspond to the locations in the
/// diamond pattern. For Xbox controllers, this would be A/B/X/Y, for Nintendo
/// Switch controllers, this would be B/A/Y/X, for GameCube controllers this
/// would be A/X/B/Y, for PlayStation controllers this would be
/// Cross/Circle/Square/Triangle.
///
/// For controllers that don't use a diamond pattern for the face buttons, the
/// south/east/west/north buttons indicate the buttons labeled A, B, C, D, or
/// 1, 2, 3, 4, or for controllers that aren't labeled, they are the primary,
/// secondary, etc. buttons.
///
/// The activate action is often the south button and the cancel action is
/// often the east button, but in some regions this is reversed, so your game
/// should allow remapping actions based on user preferences.
///
/// You can query the labels for the face buttons using
/// `getGamepadButtonLabel`
pub const GamepadButton = enum(c_int) {
    invalid = -1,
    /// Bottom face button (e.g. Xbox A button)
    south,
    /// Right face button (e.g. Xbox B button)
    east,
    /// Left face button (e.g. Xbox X button)
    west,
    /// Top face button (e.g. Xbox Y button)
    north,
    back,
    guide,
    start,
    left_stick,
    right_stick,
    left_shoulder,
    right_shoulder,
    dpad_up,
    dpad_down,
    dpad_left,
    dpad_right,
    /// Additional button (e.g. Xbox Series X share button, PS5 microphone button, Nintendo Switch Pro capture button, Steam Controller QAM button, Amazon Luna microphone button, Google Stadia capture button)
    misc1,
    /// Upper or primary paddle, under your right hand (e.g. Xbox Elite paddle P1, DualSense Edge RB button, Right Joy-Con SR button, Steam Controller R4 button)
    right_paddle1,
    /// Upper or primary paddle, under your left hand (e.g. Xbox Elite paddle P3, DualSense Edge LB button, Left Joy-Con SL button, Steam Controller L4 button)
    left_paddle1,
    /// Lower or secondary paddle, under your right hand (e.g. Xbox Elite paddle P2, DualSense Edge right Fn button, Right Joy-Con SL button, Steam Controller R5 button)
    right_paddle2,
    /// Lower or secondary paddle, under your left hand (e.g. Xbox Elite paddle P4, DualSense Edge left Fn button, Left Joy-Con SR button, Steam Controller L5 button)
    left_paddle2,
    /// PS4/PS5 touchpad button
    touchpad,
    /// Additional button
    misc2,
    /// Additional button (e.g. Nintendo GameCube left trigger click)
    misc3,
    /// Additional button (e.g. Nintendo GameCube right trigger click)
    misc4,
    /// Additional button
    misc5,
    /// Additional button
    misc6,
    count,
};

/// The set of gamepad button labels
///
/// This isn't a complete set, just the face buttons to make it easy to show
/// button prompts.
///
/// For a complete set, you should look at the button and gamepad type and have
/// a set of symbols that work well with your art style.
pub const GamepadButtonLabel = enum(c_int) {
    unknown,
    a,
    b,
    x,
    y,
    cross,
    circle,
    square,
    triangle,
};

/// The list of axes available on a gamepad
///
/// Thumbstick axis values range from `joystick_axis_min` to
/// `joystick_axis_max`, and are centered within ~8000 of zero, though
/// advanced UI will allow users to set or autodetect the dead zone, which
/// varies between gamepads.
///
/// Trigger axis values range from 0 (released) to `joystick_axis_max` (fully
/// pressed) when reported by `getGamepadAxis`. Note that this is not the
/// same range that will be reported by the lower-level `getJoystickAxis`.
pub const GamepadAxis = enum(c_int) {
    invalid = -1,
    leftx,
    lefty,
    rightx,
    righty,
    left_trigger,
    right_trigger,
    count,
};

/// Types of gamepad control bindings.
///
/// A gamepad is a collection of bindings that map arbitrary joystick buttons,
/// axes and hat switches to specific positions on a generic console-style
/// gamepad. This enum is used as part of `GamepadBinding` to specify those
/// mappings.
pub const GamepadBindingType = enum(c_int) {
    none = 0,
    button,
    axis,
    hat,
};

/// A mapping between one joystick input to a gamepad control.
///
/// A gamepad has a collection of several bindings, to say, for example, when
/// joystick button number 5 is pressed, that should be treated like the
/// gamepad's "start" button.
///
/// SDL has these bindings built-in for many popular controllers, and can add
/// more with a simple text string. Those strings are parsed into a collection
/// of these structs to make it easier to operate on the data.
pub const GamepadBinding = extern struct {
    input_type: GamepadBindingType,
    input: extern union {
        /// The joystick button index.
        button: c_int,
        axis: extern struct {
            /// The joystick axis index.
            axis: c_int,
            axis_min: c_int,
            axis_max: c_int,
        },
        hat: extern struct {
            /// The joystick hat index.
            hat: c_int,
            hat_mask: c_int,
        },
    },
    output_type: GamepadBindingType,
    output: extern union {
        button: GamepadButton,
        axis: extern struct {
            axis: GamepadAxis,
            axis_min: c_int,
            axis_max: c_int,
        },
    },
};

/// Add support for gamepads that SDL is unaware of or change the binding of an
/// existing gamepad.
///
/// The mapping string has the format "GUID,name,mapping", where GUID is the
/// string value from `guidToString`, name is the human readable string for
/// the device and mappings are gamepad mappings to joystick ones. Under
/// Windows there is a reserved GUID of "xinput" that covers all XInput
/// devices. The mapping format for joystick is:
///
/// - `bX`: a joystick button, index X
/// - `hX.Y`: hat X with value Y
/// - `aX`: axis X of the joystick
///
/// Buttons can be used as a gamepad axes and vice versa.
///
/// If a device with this GUID is already plugged in, SDL will generate an
/// `EventType.gamepad_added` event.
///
/// This string shows an example of a valid mapping for a gamepad:
///
/// ```c
/// "341a3608000000000000504944564944,Afterglow PS3 Controller,a:b1,b:b2,y:b3,x:b0,start:b9,guide:b12,back:b8,dpup:h0.1,dpleft:h0.8,dpdown:h0.4,dpright:h0.2,leftshoulder:b4,rightshoulder:b5,leftstick:b10,rightstick:b11,leftx:a0,lefty:a1,rightx:a2,righty:a3,lefttrigger:b6,righttrigger:b7"
/// ```
pub fn addGamepadMapping(mapping: [:0]const u8) Error!c_int {
    const result = SDL_AddGamepadMapping(mapping.ptr);
    if (result < 0) return makeError();
    return result;
}
extern fn SDL_AddGamepadMapping(mapping: [*:0]const u8) c_int;

/// Load a set of gamepad mappings from an `IOStream`.
///
/// You can call this function several times, if needed, to load different
/// database files.
///
/// If a new mapping is loaded for an already known gamepad GUID, the later
/// version will overwrite the one currently loaded.
///
/// Any new mappings for already plugged in controllers will generate
/// `EventType.gamepad_added` events.
///
/// Mappings not belonging to the current platform or with no platform field
/// specified will be ignored (i.e. mappings for Linux will be ignored in
/// Windows, etc).
///
/// This function will load the text database entirely in memory before
/// processing it, so take this into consideration if you are in a memory
/// constrained environment.
pub fn addGamepadMappingsFromIO(src: *sdl.IOStream, closeio: bool) Error!c_int {
    const result = SDL_AddGamepadMappingsFromIO(src, closeio);
    if (result < 0) return makeError();
    return result;
}
extern fn SDL_AddGamepadMappingsFromIO(src: *sdl.IOStream, closeio: bool) c_int;

/// Load a set of gamepad mappings from a file.
///
/// You can call this function several times, if needed, to load different
/// database files.
///
/// If a new mapping is loaded for an already known gamepad GUID, the later
/// version will overwrite the one currently loaded.
///
/// Any new mappings for already plugged in controllers will generate
/// `EventType.gamepad_added` events.
///
/// Mappings not belonging to the current platform or with no platform field
/// specified will be ignored (i.e. mappings for Linux will be ignored in
/// Windows, etc).
pub fn addGamepadMappingsFromFile(file: [:0]const u8) Error!c_int {
    const result = SDL_AddGamepadMappingsFromFile(file.ptr);
    if (result < 0) return makeError();
    return result;
}
extern fn SDL_AddGamepadMappingsFromFile(file: [*:0]const u8) c_int;

/// Reinitialize the SDL mapping database to its initial state.
///
/// This will generate gamepad events as needed if device mappings change.
pub fn reloadGamepadMappings() Error!void {
    if (!SDL_ReloadGamepadMappings()) return makeError();
}
extern fn SDL_ReloadGamepadMappings() bool;

/// Get the current gamepad mappings.
///
/// The returned value should be freed with `free` when it is no longer needed.
pub fn getGamepadMappings() Error![][*:0]u8 {
    var count: c_int = undefined;
    const ptr = SDL_GetGamepadMappings(&count) orelse return makeError();
    return ptr[0..@intCast(count)];
}
extern fn SDL_GetGamepadMappings(count: ?*c_int) ?[*][*:0]u8;

/// Get the gamepad mapping string for a given GUID.
///
/// The returned value should be freed with `free` when it is no longer needed.
pub fn getGamepadMappingForGUID(guid: sdl.GUID) Error![:0]u8 {
    const str = SDL_GetGamepadMappingForGUID(guid) orelse return makeError();
    return std.mem.span(str);
}
extern fn SDL_GetGamepadMappingForGUID(guid: sdl.GUID) ?[*:0]u8;

/// Get the current mapping of a gamepad.
///
/// Details about mappings are discussed with `addGamepadMapping`.
///
/// The returned value should be freed with `free` when it is no longer needed.
pub fn getGamepadMapping(gamepad: *Gamepad) ?[:0]u8 {
    const str = SDL_GetGamepadMapping(gamepad) orelse return null;
    return std.mem.span(str);
}
extern fn SDL_GetGamepadMapping(gamepad: *Gamepad) ?[*:0]u8;

/// Set the current mapping of a joystick or gamepad.
///
/// Details about mappings are discussed with `addGamepadMapping`.
pub fn setGamepadMapping(instance_id: sdl.JoystickId, mapping: ?[:0]const u8) Error!void {
    if (!SDL_SetGamepadMapping(instance_id, if (mapping) |s| s.ptr else null)) return makeError();
}
extern fn SDL_SetGamepadMapping(instance_id: sdl.JoystickId, mapping: ?[*:0]const u8) bool;

/// Return whether a gamepad is currently connected.
pub const hasGamepad = SDL_HasGamepad;
extern fn SDL_HasGamepad() bool;

/// Get a list of currently connected gamepads.
///
/// The returned value should be freed with `free` when it is no longer needed.
pub fn getGamepads() Error![]sdl.JoystickId {
    var count: c_int = undefined;
    const ptr = SDL_GetGamepads(&count) orelse return makeError();
    return ptr[0..@intCast(count)];
}
extern fn SDL_GetGamepads(count: ?*c_int) ?[*]sdl.JoystickId;

/// Check if the given joystick is supported by the gamepad interface.
pub const isGamepad = SDL_IsGamepad;
extern fn SDL_IsGamepad(instance_id: sdl.JoystickId) bool;

/// Get the implementation dependent name of a gamepad.
///
/// This can be called before any gamepads are opened.
pub fn getGamepadNameForId(instance_id: sdl.JoystickId) ?[:0]const u8 {
    const str = SDL_GetGamepadNameForID(instance_id) orelse return null;
    return std.mem.span(str);
}
extern fn SDL_GetGamepadNameForID(instance_id: sdl.JoystickId) ?[*:0]const u8;

/// Get the implementation dependent path of a gamepad.
///
/// This can be called before any gamepads are opened.
pub fn getGamepadPathForId(instance_id: sdl.JoystickId) ?[:0]const u8 {
    const str = SDL_GetGamepadPathForID(instance_id) orelse return null;
    return std.mem.span(str);
}
extern fn SDL_GetGamepadPathForID(instance_id: sdl.JoystickId) ?[*:0]const u8;

/// Get the player index of a gamepad.
///
/// This can be called before any gamepads are opened.
pub fn getGamepadPlayerIndexForId(instance_id: sdl.JoystickId) Error!c_int {
    const result = SDL_GetGamepadPlayerIndexForID(instance_id);
    if (result < 0) return makeError();
    return result;
}
extern fn SDL_GetGamepadPlayerIndexForID(instance_id: sdl.JoystickId) c_int;

/// Get the implementation-dependent GUID of a gamepad.
///
/// This can be called before any gamepads are opened.
pub const getGamepadGUIDForId = SDL_GetGamepadGUIDForID;
extern fn SDL_GetGamepadGUIDForID(instance_id: sdl.JoystickId) sdl.GUID;

/// Get the USB vendor ID of a gamepad, if available.
///
/// This can be called before any gamepads are opened. If the vendor ID isn't
/// available this function returns 0.
pub const getGamepadVendorForId = SDL_GetGamepadVendorForID;
extern fn SDL_GetGamepadVendorForID(instance_id: sdl.JoystickId) u16;

/// Get the USB product ID of a gamepad, if available.
///
/// This can be called before any gamepads are opened. If the product ID isn't
/// available this function returns 0.
pub const getGamepadProductForId = SDL_GetGamepadProductForID;
extern fn SDL_GetGamepadProductForID(instance_id: sdl.JoystickId) u16;

/// Get the product version of a gamepad, if available.
///
/// This can be called before any gamepads are opened. If the product version
/// isn't available this function returns 0.
pub const getGamepadProductVersionForId = SDL_GetGamepadProductVersionForID;
extern fn SDL_GetGamepadProductVersionForID(instance_id: sdl.JoystickId) u16;

/// Get the type of a gamepad.
///
/// This can be called before any gamepads are opened.
pub const getGamepadTypeForId = SDL_GetGamepadTypeForID;
extern fn SDL_GetGamepadTypeForID(instance_id: sdl.JoystickId) GamepadType;

/// Get the type of a gamepad, ignoring any mapping override.
///
/// This can be called before any gamepads are opened.
pub const getRealGamepadTypeForId = SDL_GetRealGamepadTypeForID;
extern fn SDL_GetRealGamepadTypeForID(instance_id: sdl.JoystickId) GamepadType;

/// Get the mapping of a gamepad.
///
/// This can be called before any gamepads are opened.
///
/// The returned value should be freed with `free` when it is no longer needed.
pub fn getGamepadMappingForId(instance_id: sdl.JoystickId) ?[:0]u8 {
    const str = SDL_GetGamepadMappingForID(instance_id) orelse return null;
    return std.mem.span(str);
}
extern fn SDL_GetGamepadMappingForID(instance_id: sdl.JoystickId) ?[*:0]u8;

/// Open a gamepad for use.
pub fn openGamepad(instance_id: sdl.JoystickId) Error!*Gamepad {
    return SDL_OpenGamepad(instance_id) orelse makeError();
}
extern fn SDL_OpenGamepad(instance_id: sdl.JoystickId) ?*Gamepad;

/// Get the `Gamepad` associated with a joystick instance ID, if it has been
/// opened.
pub fn getGamepadFromId(instance_id: sdl.JoystickId) Error!*Gamepad {
    return SDL_GetGamepadFromID(instance_id) orelse makeError();
}
extern fn SDL_GetGamepadFromID(instance_id: sdl.JoystickId) ?*Gamepad;

/// Get the `Gamepad` associated with a player index.
pub const getGamepadFromPlayerIndex = SDL_GetGamepadFromPlayerIndex;
extern fn SDL_GetGamepadFromPlayerIndex(player_index: c_int) ?*Gamepad;

/// Get the properties associated with an opened gamepad.
///
/// These properties are shared with the underlying joystick object.
///
/// The following read-only properties are provided by SDL:
///
/// - `Gamepad.Properties.cap_mono_led_boolean`: true if this gamepad has an LED
///   that has adjustable brightness
/// - `Gamepad.Properties.cap_rgb_led_boolean`: true if this gamepad has an LED
///   that has adjustable color
/// - `Gamepad.Properties.cap_player_led_boolean`: true if this gamepad has a
///   player LED
/// - `Gamepad.Properties.cap_rumble_boolean`: true if this gamepad has
///   left/right rumble
/// - `Gamepad.Properties.cap_trigger_rumble_boolean`: true if this gamepad has
///   simple trigger rumble
pub fn getGamepadProperties(gamepad: *Gamepad) Error!sdl.PropertiesId {
    const result = SDL_GetGamepadProperties(gamepad);
    if (@backingInt(result) == 0) return makeError();
    return result;
}
extern fn SDL_GetGamepadProperties(gamepad: *Gamepad) sdl.PropertiesId;

/// Get the instance ID of an opened gamepad.
pub fn getGamepadId(gamepad: *Gamepad) Error!sdl.JoystickId {
    const result = SDL_GetGamepadID(gamepad);
    if (@backingInt(result) == 0) return makeError();
    return result;
}
extern fn SDL_GetGamepadID(gamepad: *Gamepad) sdl.JoystickId;

/// Get the implementation-dependent name for an opened gamepad.
pub fn getGamepadName(gamepad: *Gamepad) ?[:0]const u8 {
    const str = SDL_GetGamepadName(gamepad) orelse return null;
    return std.mem.span(str);
}
extern fn SDL_GetGamepadName(gamepad: *Gamepad) ?[*:0]const u8;

/// Get the implementation-dependent path for an opened gamepad.
pub fn getGamepadPath(gamepad: *Gamepad) ?[:0]const u8 {
    const str = SDL_GetGamepadPath(gamepad) orelse return null;
    return std.mem.span(str);
}
extern fn SDL_GetGamepadPath(gamepad: *Gamepad) ?[*:0]const u8;

/// Get the type of an opened gamepad.
pub const getGamepadType = SDL_GetGamepadType;
extern fn SDL_GetGamepadType(gamepad: *Gamepad) GamepadType;

/// Get the type of an opened gamepad, ignoring any mapping override.
pub const getRealGamepadType = SDL_GetRealGamepadType;
extern fn SDL_GetRealGamepadType(gamepad: *Gamepad) GamepadType;

/// Get the player index of an opened gamepad.
///
/// For XInput gamepads this returns the XInput user index.
pub fn getGamepadPlayerIndex(gamepad: *Gamepad) Error!c_int {
    const result = SDL_GetGamepadPlayerIndex(gamepad);
    if (result < 0) return makeError();
    return result;
}
extern fn SDL_GetGamepadPlayerIndex(gamepad: *Gamepad) c_int;

/// Set the player index of an opened gamepad.
pub fn setGamepadPlayerIndex(gamepad: *Gamepad, player_index: c_int) Error!void {
    if (!SDL_SetGamepadPlayerIndex(gamepad, player_index)) return makeError();
}
extern fn SDL_SetGamepadPlayerIndex(gamepad: *Gamepad, player_index: c_int) bool;

/// Get the USB vendor ID of an opened gamepad, if available.
///
/// If the vendor ID isn't available this function returns 0.
pub const getGamepadVendor = SDL_GetGamepadVendor;
extern fn SDL_GetGamepadVendor(gamepad: *Gamepad) u16;

/// Get the USB product ID of an opened gamepad, if available.
///
/// If the product ID isn't available this function returns 0.
pub const getGamepadProduct = SDL_GetGamepadProduct;
extern fn SDL_GetGamepadProduct(gamepad: *Gamepad) u16;

/// Get the product version of an opened gamepad, if available.
///
/// If the product version isn't available this function returns 0.
pub const getGamepadProductVersion = SDL_GetGamepadProductVersion;
extern fn SDL_GetGamepadProductVersion(gamepad: *Gamepad) u16;

/// Get the firmware version of an opened gamepad, if available.
///
/// If the firmware version isn't available this function returns 0.
pub const getGamepadFirmwareVersion = SDL_GetGamepadFirmwareVersion;
extern fn SDL_GetGamepadFirmwareVersion(gamepad: *Gamepad) u16;

/// Get the serial number of an opened gamepad, if available.
///
/// Returns the serial number of the gamepad, or null if it is not available.
pub fn getGamepadSerial(gamepad: *Gamepad) ?[:0]const u8 {
    const str = SDL_GetGamepadSerial(gamepad) orelse return null;
    return std.mem.span(str);
}
extern fn SDL_GetGamepadSerial(gamepad: *Gamepad) ?[*:0]const u8;

/// Get the Steam Input handle of an opened gamepad, if available.
///
/// Returns an InputHandle_t for the gamepad that can be used with Steam Input
/// API: https://partner.steamgames.com/doc/api/ISteamInput
pub const getGamepadSteamHandle = SDL_GetGamepadSteamHandle;
extern fn SDL_GetGamepadSteamHandle(gamepad: *Gamepad) u64;

/// Get the connection state of a gamepad.
pub fn getGamepadConnectionState(gamepad: *Gamepad) Error!sdl.JoystickConnectionState {
    const state = SDL_GetGamepadConnectionState(gamepad);
    if (state == .invalid) return makeError();
    return state;
}
extern fn SDL_GetGamepadConnectionState(gamepad: *Gamepad) sdl.JoystickConnectionState;

/// Get the battery state of a gamepad.
///
/// You should never take a battery status as absolute truth. Batteries
/// (especially failing batteries) are delicate hardware, and the values
/// reported here are best estimates based on what that hardware reports. It's
/// not uncommon for older batteries to lose stored power much faster than it
/// reports, or completely drain when reporting it has 20 percent left, etc.
///
/// `percent` is -1 if it can't be determined.
pub fn getGamepadPowerInfo(gamepad: *Gamepad) Error!struct { state: sdl.PowerState, percent: c_int } {
    var percent: c_int = undefined;
    const state = SDL_GetGamepadPowerInfo(gamepad, &percent);
    if (state == .@"error") return makeError();
    return .{ .state = state, .percent = percent };
}
extern fn SDL_GetGamepadPowerInfo(gamepad: *Gamepad, percent: ?*c_int) sdl.PowerState;

/// Check if a gamepad has been opened and is currently connected.
pub const gamepadConnected = SDL_GamepadConnected;
extern fn SDL_GamepadConnected(gamepad: *Gamepad) bool;

/// Get the underlying joystick from a gamepad.
///
/// This function will give you a `Joystick` object, which allows you to use
/// the `Joystick` functions with a `Gamepad` object. This would be useful
/// for getting a joystick's position at any given time, even if it hasn't
/// moved (moving it would produce an event, which would have the axis' value).
///
/// The pointer returned is owned by the `Gamepad`. You should not call
/// `closeJoystick` on it, for example, since doing so will likely cause
/// SDL to crash.
pub fn getGamepadJoystick(gamepad: *Gamepad) Error!*sdl.Joystick {
    return SDL_GetGamepadJoystick(gamepad) orelse makeError();
}
extern fn SDL_GetGamepadJoystick(gamepad: *Gamepad) ?*sdl.Joystick;

/// Set the state of gamepad event processing.
///
/// If gamepad events are disabled, you must call `updateGamepads` yourself
/// and check the state of the gamepad when you want gamepad information.
pub const setGamepadEventsEnabled = SDL_SetGamepadEventsEnabled;
extern fn SDL_SetGamepadEventsEnabled(enabled: bool) void;

/// Query the state of gamepad event processing.
///
/// If gamepad events are disabled, you must call `updateGamepads` yourself
/// and check the state of the gamepad when you want gamepad information.
pub const gamepadEventsEnabled = SDL_GamepadEventsEnabled;
extern fn SDL_GamepadEventsEnabled() bool;

/// Get the SDL joystick layer bindings for a gamepad.
///
/// The returned value should be freed with `free` when it is no longer needed.
pub fn getGamepadBindings(gamepad: *Gamepad) Error![]*GamepadBinding {
    var count: c_int = undefined;
    const ptr = SDL_GetGamepadBindings(gamepad, &count) orelse return makeError();
    return ptr[0..@intCast(count)];
}
extern fn SDL_GetGamepadBindings(gamepad: *Gamepad, count: ?*c_int) ?[*]*GamepadBinding;

/// Manually pump gamepad updates if not using the loop.
///
/// This function is called automatically by the event loop if events are
/// enabled. Under such circumstances, it will not be necessary to call this
/// function.
pub const updateGamepads = SDL_UpdateGamepads;
extern fn SDL_UpdateGamepads() void;

/// Convert a string into `GamepadType` enum.
///
/// This function is called internally to translate `Gamepad` mapping strings
/// for the underlying joystick device into the consistent `Gamepad` mapping.
/// You do not normally need to call this function unless you are parsing
/// `Gamepad` mappings in your own code.
pub fn getGamepadTypeFromString(str: [:0]const u8) GamepadType {
    return SDL_GetGamepadTypeFromString(str.ptr);
}
extern fn SDL_GetGamepadTypeFromString(str: [*:0]const u8) GamepadType;

/// Convert from a `GamepadType` enum to a string.
pub fn getGamepadStringForType(@"type": GamepadType) ?[:0]const u8 {
    const str = SDL_GetGamepadStringForType(@"type") orelse return null;
    return std.mem.span(str);
}
extern fn SDL_GetGamepadStringForType(@"type": GamepadType) ?[*:0]const u8;

/// Convert a string into `GamepadAxis` enum.
///
/// This function is called internally to translate `Gamepad` mapping strings
/// for the underlying joystick device into the consistent `Gamepad` mapping.
/// You do not normally need to call this function unless you are parsing
/// `Gamepad` mappings in your own code.
///
/// Note specially that "righttrigger" and "lefttrigger" map to
/// `GamepadAxis.right_trigger` and `GamepadAxis.left_trigger`,
/// respectively.
pub fn getGamepadAxisFromString(str: [:0]const u8) GamepadAxis {
    return SDL_GetGamepadAxisFromString(str.ptr);
}
extern fn SDL_GetGamepadAxisFromString(str: [*:0]const u8) GamepadAxis;

/// Convert from a `GamepadAxis` enum to a string.
pub fn getGamepadStringForAxis(axis: GamepadAxis) ?[:0]const u8 {
    const str = SDL_GetGamepadStringForAxis(axis) orelse return null;
    return std.mem.span(str);
}
extern fn SDL_GetGamepadStringForAxis(axis: GamepadAxis) ?[*:0]const u8;

/// Query whether a gamepad has a given axis.
///
/// This merely reports whether the gamepad's mapping defined this axis, as
/// that is all the information SDL has about the physical device.
pub const gamepadHasAxis = SDL_GamepadHasAxis;
extern fn SDL_GamepadHasAxis(gamepad: *Gamepad, axis: GamepadAxis) bool;

/// Get the current state of an axis control on a gamepad.
///
/// The axis indices start at index 0.
///
/// For thumbsticks, the state is a value ranging from -32768 (up/left) to
/// 32767 (down/right).
///
/// Triggers range from 0 when released to 32767 when fully pressed, and never
/// return a negative value. Note that this differs from the value reported by
/// the lower-level `getJoystickAxis`, which normally uses the full range.
///
/// Note that for invalid gamepads or axes, this will return 0. Zero is also a
/// valid value in normal operation; usually it means a centered axis.
pub const getGamepadAxis = SDL_GetGamepadAxis;
extern fn SDL_GetGamepadAxis(gamepad: *Gamepad, axis: GamepadAxis) i16;

/// Convert a string into a `GamepadButton` enum.
///
/// This function is called internally to translate `Gamepad` mapping strings
/// for the underlying joystick device into the consistent `Gamepad` mapping.
/// You do not normally need to call this function unless you are parsing
/// `Gamepad` mappings in your own code.
pub fn getGamepadButtonFromString(str: [:0]const u8) GamepadButton {
    return SDL_GetGamepadButtonFromString(str.ptr);
}
extern fn SDL_GetGamepadButtonFromString(str: [*:0]const u8) GamepadButton;

/// Convert from a `GamepadButton` enum to a string.
pub fn getGamepadStringForButton(button: GamepadButton) ?[:0]const u8 {
    const str = SDL_GetGamepadStringForButton(button) orelse return null;
    return std.mem.span(str);
}
extern fn SDL_GetGamepadStringForButton(button: GamepadButton) ?[*:0]const u8;

/// Query whether a gamepad has a given button.
///
/// This merely reports whether the gamepad's mapping defined this button, as
/// that is all the information SDL has about the physical device.
pub const gamepadHasButton = SDL_GamepadHasButton;
extern fn SDL_GamepadHasButton(gamepad: *Gamepad, button: GamepadButton) bool;

/// Get the current state of a button on a gamepad.
pub const getGamepadButton = SDL_GetGamepadButton;
extern fn SDL_GetGamepadButton(gamepad: *Gamepad, button: GamepadButton) bool;

/// Get the label of a button on a gamepad.
pub const getGamepadButtonLabelForType = SDL_GetGamepadButtonLabelForType;
extern fn SDL_GetGamepadButtonLabelForType(@"type": GamepadType, button: GamepadButton) GamepadButtonLabel;

/// Get the label of a button on a gamepad.
pub const getGamepadButtonLabel = SDL_GetGamepadButtonLabel;
extern fn SDL_GetGamepadButtonLabel(gamepad: *Gamepad, button: GamepadButton) GamepadButtonLabel;

/// Get the number of touchpads on a gamepad.
pub const getNumGamepadTouchpads = SDL_GetNumGamepadTouchpads;
extern fn SDL_GetNumGamepadTouchpads(gamepad: *Gamepad) c_int;

/// Get the number of supported simultaneous fingers on a touchpad on a game
/// gamepad.
pub const getNumGamepadTouchpadFingers = SDL_GetNumGamepadTouchpadFingers;
extern fn SDL_GetNumGamepadTouchpadFingers(gamepad: *Gamepad, touchpad: c_int) c_int;

/// Get the current state of a finger on a touchpad on a gamepad.
pub fn getGamepadTouchpadFinger(gamepad: *Gamepad, touchpad: c_int, finger: c_int, down: ?*bool, x: ?*f32, y: ?*f32, pressure: ?*f32) Error!void {
    if (!SDL_GetGamepadTouchpadFinger(gamepad, touchpad, finger, down, x, y, pressure)) return makeError();
}
extern fn SDL_GetGamepadTouchpadFinger(gamepad: *Gamepad, touchpad: c_int, finger: c_int, down: ?*bool, x: ?*f32, y: ?*f32, pressure: ?*f32) bool;

/// Return whether a gamepad has a particular sensor.
pub const gamepadHasSensor = SDL_GamepadHasSensor;
extern fn SDL_GamepadHasSensor(gamepad: *Gamepad, @"type": sdl.SensorType) bool;

/// Set whether data reporting for a gamepad sensor is enabled.
pub fn setGamepadSensorEnabled(gamepad: *Gamepad, @"type": sdl.SensorType, enabled: bool) Error!void {
    if (!SDL_SetGamepadSensorEnabled(gamepad, @"type", enabled)) return makeError();
}
extern fn SDL_SetGamepadSensorEnabled(gamepad: *Gamepad, @"type": sdl.SensorType, enabled: bool) bool;

/// Query whether sensor data reporting is enabled for a gamepad.
pub const gamepadSensorEnabled = SDL_GamepadSensorEnabled;
extern fn SDL_GamepadSensorEnabled(gamepad: *Gamepad, @"type": sdl.SensorType) bool;

/// Get the data rate (number of events per second) of a gamepad sensor.
pub const getGamepadSensorDataRate = SDL_GetGamepadSensorDataRate;
extern fn SDL_GetGamepadSensorDataRate(gamepad: *Gamepad, @"type": sdl.SensorType) f32;

/// Get the current state of a gamepad sensor.
///
/// The number of values and interpretation of the data is sensor dependent.
/// See the remarks in `SensorType` for details for each type of sensor.
pub fn getGamepadSensorData(gamepad: *Gamepad, @"type": sdl.SensorType, data: []f32) Error!void {
    if (!SDL_GetGamepadSensorData(gamepad, @"type", data.ptr, @intCast(data.len))) return makeError();
}
extern fn SDL_GetGamepadSensorData(gamepad: *Gamepad, @"type": sdl.SensorType, data: [*]f32, num_values: c_int) bool;

/// Start a rumble effect on a gamepad.
///
/// Each call to this function cancels any previous rumble effect, and calling
/// it with 0 intensity stops any rumbling.
///
/// This function requires you to process SDL events or call
/// `updateJoysticks` to update rumble state.
pub fn rumbleGamepad(gamepad: *Gamepad, low_frequency_rumble: u16, high_frequency_rumble: u16, duration_ms: u32) Error!void {
    if (!SDL_RumbleGamepad(gamepad, low_frequency_rumble, high_frequency_rumble, duration_ms)) return makeError();
}
extern fn SDL_RumbleGamepad(gamepad: *Gamepad, low_frequency_rumble: u16, high_frequency_rumble: u16, duration_ms: u32) bool;

/// Start a rumble effect in the gamepad's triggers.
///
/// Each call to this function cancels any previous trigger rumble effect, and
/// calling it with 0 intensity stops any rumbling.
///
/// Note that this is rumbling of the _triggers_ and not the gamepad as a
/// whole. This is currently only supported on Xbox One gamepads. If you want
/// the (more common) whole-gamepad rumble, use `rumbleGamepad` instead.
///
/// This function requires you to process SDL events or call
/// `updateJoysticks` to update rumble state.
pub fn rumbleGamepadTriggers(gamepad: *Gamepad, left_rumble: u16, right_rumble: u16, duration_ms: u32) Error!void {
    if (!SDL_RumbleGamepadTriggers(gamepad, left_rumble, right_rumble, duration_ms)) return makeError();
}
extern fn SDL_RumbleGamepadTriggers(gamepad: *Gamepad, left_rumble: u16, right_rumble: u16, duration_ms: u32) bool;

/// Update a gamepad's LED color.
///
/// An example of a joystick LED is the light on the back of a PlayStation 4's
/// DualShock 4 controller.
///
/// For gamepads with a single color LED, the maximum of the RGB values will be
/// used as the LED brightness.
pub fn setGamepadLED(gamepad: *Gamepad, red: u8, green: u8, blue: u8) Error!void {
    if (!SDL_SetGamepadLED(gamepad, red, green, blue)) return makeError();
}
extern fn SDL_SetGamepadLED(gamepad: *Gamepad, red: u8, green: u8, blue: u8) bool;

/// Send a gamepad specific effect packet.
pub fn sendGamepadEffect(gamepad: *Gamepad, data: []const u8) Error!void {
    if (!SDL_SendGamepadEffect(gamepad, data.ptr, @intCast(data.len))) return makeError();
}
extern fn SDL_SendGamepadEffect(gamepad: *Gamepad, data: [*]const u8, size: c_int) bool;

/// Close a gamepad previously opened with `openGamepad`.
pub const closeGamepad = SDL_CloseGamepad;
extern fn SDL_CloseGamepad(gamepad: *Gamepad) void;

/// Return the sfSymbolsName for a given button on a gamepad on Apple
/// platforms.
pub fn getGamepadAppleSFSymbolsNameForButton(gamepad: *Gamepad, button: GamepadButton) ?[:0]const u8 {
    const str = SDL_GetGamepadAppleSFSymbolsNameForButton(gamepad, button) orelse return null;
    return std.mem.span(str);
}
extern fn SDL_GetGamepadAppleSFSymbolsNameForButton(gamepad: *Gamepad, button: GamepadButton) ?[*:0]const u8;

/// Return the sfSymbolsName for a given axis on a gamepad on Apple platforms.
pub fn getGamepadAppleSFSymbolsNameForAxis(gamepad: *Gamepad, axis: GamepadAxis) ?[:0]const u8 {
    const str = SDL_GetGamepadAppleSFSymbolsNameForAxis(gamepad, axis) orelse return null;
    return std.mem.span(str);
}
extern fn SDL_GetGamepadAppleSFSymbolsNameForAxis(gamepad: *Gamepad, axis: GamepadAxis) ?[*:0]const u8;
