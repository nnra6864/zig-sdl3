//! Force Feedback Support (SDL_haptic.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// The haptic structure used to identify an SDL haptic.
pub const Haptic = opaque {
    pub const open = openHaptic;
    pub const getFromId = getHapticFromId;
    pub const getId = getHapticId;
    pub const getName = getHapticName;
    pub const openFromMouse = openHapticFromMouse;
    pub const openFromJoystick = openHapticFromJoystick;
    pub const close = closeHaptic;
    pub const getMaxEffects = getMaxHapticEffects;
    pub const getMaxEffectsPlaying = getMaxHapticEffectsPlaying;
    pub const getFeatures = getHapticFeatures;
    pub const getNumAxes = getNumHapticAxes;
    pub const effectSupported = hapticEffectSupported;
    pub const createEffect = createHapticEffect;
    pub const updateEffect = updateHapticEffect;
    pub const runEffect = runHapticEffect;
    pub const stopEffect = stopHapticEffect;
    pub const destroyEffect = destroyHapticEffect;
    pub const getEffectStatus = getHapticEffectStatus;
    pub const setGain = setHapticGain;
    pub const setAutocenter = setHapticAutocenter;
    pub const pause = pauseHaptic;
    pub const @"resume" = resumeHaptic;
    pub const stopEffects = stopHapticEffects;
    pub const rumbleSupported = hapticRumbleSupported;
    pub const initRumble = initHapticRumble;
    pub const playRumble = playHapticRumble;
    pub const stopRumble = stopHapticRumble;
};

/// Type of haptic effect.
pub const HapticEffectType = u16;

/// Constant effect supported.
///
/// Constant haptic effect.
pub const haptic_constant: u16 = 1 << 0;

/// Sine wave effect supported.
///
/// Periodic haptic effect that simulates sine waves.
pub const haptic_sine: u16 = 1 << 1;

/// Square wave effect supported.
///
/// Periodic haptic effect that simulates square waves.
pub const haptic_square: u16 = 1 << 2;

/// Triangle wave effect supported.
///
/// Periodic haptic effect that simulates triangular waves.
pub const haptic_triangle: u16 = 1 << 3;

/// Sawtoothup wave effect supported.
///
/// Periodic haptic effect that simulates saw tooth up waves.
pub const haptic_sawtoothup: u16 = 1 << 4;

/// Sawtoothdown wave effect supported.
///
/// Periodic haptic effect that simulates saw tooth down waves.
pub const haptic_sawtoothdown: u16 = 1 << 5;

/// Ramp effect supported.
///
/// Ramp haptic effect.
pub const haptic_ramp: u16 = 1 << 6;

/// Spring effect supported - uses axes position.
///
/// Condition haptic effect that simulates a spring. Effect is based on the
/// axes position.
pub const haptic_spring: u16 = 1 << 7;

/// Damper effect supported - uses axes velocity.
///
/// Condition haptic effect that simulates dampening. Effect is based on the
/// axes velocity.
pub const haptic_damper: u16 = 1 << 8;

/// Inertia effect supported - uses axes acceleration.
///
/// Condition haptic effect that simulates inertia. Effect is based on the axes
/// acceleration.
pub const haptic_inertia: u16 = 1 << 9;

/// Friction effect supported - uses axes movement.
///
/// Condition haptic effect that simulates friction. Effect is based on the
/// axes movement.
pub const haptic_friction: u16 = 1 << 10;

/// Left/Right effect supported.
///
/// Haptic effect for direct control over high/low frequency motors.
pub const haptic_leftright: u16 = 1 << 11;

/// Reserved for future use.
pub const haptic_reserved1: u16 = 1 << 12;

/// Reserved for future use.
pub const haptic_reserved2: u16 = 1 << 13;

/// Reserved for future use.
pub const haptic_reserved3: u16 = 1 << 14;

/// Custom effect is supported.
///
/// User defined custom haptic effect.
pub const haptic_custom: u16 = 1 << 15;

/// Device can set global gain.
///
/// Device supports setting the global gain.
pub const haptic_gain: u32 = 1 << 16;

/// Device can set autocenter.
///
/// Device supports setting autocenter.
pub const haptic_autocenter: u32 = 1 << 17;

/// Device can be queried for effect status.
///
/// Device supports querying effect status.
pub const haptic_status: u32 = 1 << 18;

/// Device can be paused.
///
/// Devices supports being paused.
pub const haptic_pause: u32 = 1 << 19;

/// The haptic features supported by a device, as returned by
/// `getHapticFeatures`.
///
/// Each field corresponds to the `haptic_*` constant of the same name.
pub const HapticFeatures = packed struct(u32) {
    constant: bool = false,
    sine: bool = false,
    square: bool = false,
    triangle: bool = false,
    sawtoothup: bool = false,
    sawtoothdown: bool = false,
    ramp: bool = false,
    spring: bool = false,
    damper: bool = false,
    inertia: bool = false,
    friction: bool = false,
    leftright: bool = false,
    reserved1: bool = false,
    reserved2: bool = false,
    reserved3: bool = false,
    custom: bool = false,
    gain: bool = false,
    autocenter: bool = false,
    status: bool = false,
    pause: bool = false,
    __unused20: u12 = 0,
};

/// The type of coordinates used for a haptic direction.
pub const HapticDirectionType = enum(u8) {
    /// Uses polar coordinates for the direction.
    polar = 0,
    /// Uses cartesian coordinates for the direction.
    cartesian = 1,
    /// Uses spherical coordinates for the direction.
    spherical = 2,
    /// Use this value to play an effect on the steering wheel axis.
    ///
    /// This provides better compatibility across platforms and devices as SDL will
    /// guess the correct axis.
    steering_axis = 3,
    _,
};

/// Used to play a device an infinite number of times.
pub const haptic_infinity: u32 = 4294967295;

/// ID for haptic effects.
///
/// This is -1 if the ID is invalid.
pub const HapticEffectId = enum(c_int) { invalid = -1, _ };

/// Structure that represents a haptic direction.
///
/// This is the direction where the force comes from, instead of the direction
/// in which the force is exerted.
///
/// Directions can be specified by:
///
/// - `HapticDirectionType.polar` : Specified by polar coordinates.
/// - `HapticDirectionType.cartesian` : Specified by cartesian coordinates.
/// - `HapticDirectionType.spherical` : Specified by spherical coordinates.
///
/// Cardinal directions of the haptic device are relative to the positioning of
/// the device. North is considered to be away from the user.
///
/// The following diagram represents the cardinal directions:
///
/// ```
///                .--.
///                |__| .-------.
///                |=.| |.-----.|
///                |--| ||     ||
///                |  | |'-----'|
///                |__|~')_____('
///                  [ COMPUTER ]
///
///
///                    North (0,-1)
///                        ^
///                        |
///                        |
///  (-1,0)  West <----[ HAPTIC ]----> East (1,0)
///                        |
///                        |
///                        v
///                     South (0,1)
///
///
///                     [ USER ]
///                       \|||/
///                       (o o)
///                 ---ooO-(_)-Ooo---
/// ```
///
/// If type is `HapticDirectionType.polar`, direction is encoded by hundredths of a degree
/// starting north and turning clockwise. `HapticDirectionType.polar` only uses the first
/// `dir` parameter. The cardinal directions would be:
///
/// - North: 0 (0 degrees)
/// - East: 9000 (90 degrees)
/// - South: 18000 (180 degrees)
/// - West: 27000 (270 degrees)
///
/// If type is `HapticDirectionType.cartesian`, direction is encoded by three positions (X
/// axis, Y axis and Z axis (with 3 axes)). `HapticDirectionType.cartesian` uses the first
/// three `dir` parameters. The cardinal directions would be:
///
/// - North: 0,-1, 0
/// - East: 1, 0, 0
/// - South: 0, 1, 0
/// - West: -1, 0, 0
///
/// The Z axis represents the height of the effect if supported, otherwise it's
/// unused. In cartesian encoding (1, 2) would be the same as (2, 4), you can
/// use any multiple you want, only the direction matters.
///
/// If type is `HapticDirectionType.spherical`, direction is encoded by two rotations. The
/// first two `dir` parameters are used. The `dir` parameters are as follows
/// (all values are in hundredths of degrees):
///
/// - Degrees from (1, 0) rotated towards (0, 1).
/// - Degrees towards (0, 0, 1) (device needs at least 3 axes).
///
/// Example of force coming from the south with all encodings (force coming
/// from the south means the user will have to pull the stick to counteract):
///
/// ```c
///  SDL_HapticDirection direction;
///
///  // Cartesian directions
///  direction.type = SDL_HAPTIC_CARTESIAN; // Using cartesian direction encoding.
///  direction.dir[0] = 0; // X position
///  direction.dir[1] = 1; // Y position
///  // Assuming the device has 2 axes, we don't need to specify third parameter.
///
///  // Polar directions
///  direction.type = SDL_HAPTIC_POLAR; // We'll be using polar direction encoding.
///  direction.dir[0] = 18000; // Polar only uses first parameter
///
///  // Spherical coordinates
///  direction.type = SDL_HAPTIC_SPHERICAL; // Spherical encoding
///  direction.dir[0] = 9000; // Since we only have two axes we don't need more parameters.
/// ```
pub const HapticDirection = extern struct {
    /// The type of encoding.
    type: HapticDirectionType,
    /// The encoded direction.
    dir: [3]i32,
};

/// A structure containing a template for a Constant effect.
///
/// This struct is exclusively for the `haptic_constant` effect.
///
/// A constant effect applies a constant force in the specified direction to
/// the joystick.
pub const HapticConstant = extern struct {
    /// `haptic_constant`
    type: HapticEffectType,
    /// Direction of the effect.
    direction: HapticDirection,
    /// Duration of the effect.
    length: u32,
    /// Delay before starting the effect.
    delay: u16,
    /// Button that triggers the effect.
    button: u16,
    /// How soon it can be triggered again after button.
    interval: u16,
    /// Strength of the constant effect.
    level: i16,
    /// Duration of the attack.
    attack_length: u16,
    /// Level at the start of the attack.
    attack_level: u16,
    /// Duration of the fade.
    fade_length: u16,
    /// Level at the end of the fade.
    fade_level: u16,
};

/// A structure containing a template for a Periodic effect.
///
/// The struct handles the following effects:
///
/// - `haptic_sine`
/// - `haptic_square`
/// - `haptic_triangle`
/// - `haptic_sawtoothup`
/// - `haptic_sawtoothdown`
///
/// A periodic effect consists in a wave-shaped effect that repeats itself over
/// time. The type determines the shape of the wave and the parameters
/// determine the dimensions of the wave.
///
/// Phase is given by hundredth of a degree meaning that giving the phase a
/// value of 9000 will displace it 25% of its period. Here are sample values:
///
/// - 0: No phase displacement.
/// - 9000: Displaced 25% of its period.
/// - 18000: Displaced 50% of its period.
/// - 27000: Displaced 75% of its period.
/// - 36000: Displaced 100% of its period, same as 0, but 0 is preferred.
///
/// Examples:
///
/// ```
///   SDL_HAPTIC_SINE
///     __      __      __      __
///    /  \    /  \    /  \    /
///   /    \__/    \__/    \__/
///
///   SDL_HAPTIC_SQUARE
///    __    __    __    __    __
///   |  |  |  |  |  |  |  |  |  |
///   |  |__|  |__|  |__|  |__|  |
///
///   SDL_HAPTIC_TRIANGLE
///     /\    /\    /\    /\    /\
///    /  \  /  \  /  \  /  \  /
///   /    \/    \/    \/    \/
///
///   SDL_HAPTIC_SAWTOOTHUP
///     /|  /|  /|  /|  /|  /|  /|
///    / | / | / | / | / | / | / |
///   /  |/  |/  |/  |/  |/  |/  |
///
///   SDL_HAPTIC_SAWTOOTHDOWN
///   \  |\  |\  |\  |\  |\  |\  |
///    \ | \ | \ | \ | \ | \ | \ |
///     \|  \|  \|  \|  \|  \|  \|
/// ```
pub const HapticPeriodic = extern struct {
    /// `haptic_sine`, `haptic_square` `haptic_triangle`, `haptic_sawtoothup` or `haptic_sawtoothdown`
    type: HapticEffectType,
    /// Direction of the effect.
    direction: HapticDirection,
    /// Duration of the effect.
    length: u32,
    /// Delay before starting the effect.
    delay: u16,
    /// Button that triggers the effect.
    button: u16,
    /// How soon it can be triggered again after button.
    interval: u16,
    /// Period of the wave.
    period: u16,
    /// Peak value; if negative, equivalent to 180 degrees extra phase shift.
    magnitude: i16,
    /// Mean value of the wave.
    offset: i16,
    /// Positive phase shift given by hundredth of a degree.
    phase: u16,
    /// Duration of the attack.
    attack_length: u16,
    /// Level at the start of the attack.
    attack_level: u16,
    /// Duration of the fade.
    fade_length: u16,
    /// Level at the end of the fade.
    fade_level: u16,
};

/// A structure containing a template for a Condition effect.
///
/// The struct handles the following effects:
///
/// - `haptic_spring`: Effect based on axes position.
/// - `haptic_damper`: Effect based on axes velocity.
/// - `haptic_inertia`: Effect based on axes acceleration.
/// - `haptic_friction`: Effect based on axes movement.
///
/// Direction is handled by condition internals instead of a direction member.
/// The condition effect specific members have three parameters. The first
/// refers to the X axis, the second refers to the Y axis and the third refers
/// to the Z axis. The right terms refer to the positive side of the axis and
/// the left terms refer to the negative side of the axis. Please refer to the
/// `HapticDirection` diagram for which side is positive and which is
/// negative.
pub const HapticCondition = extern struct {
    /// `haptic_spring`, `haptic_damper`, `haptic_inertia` or `haptic_friction`
    type: HapticEffectType,
    /// Direction of the effect.
    direction: HapticDirection,
    /// Duration of the effect.
    length: u32,
    /// Delay before starting the effect.
    delay: u16,
    /// Button that triggers the effect.
    button: u16,
    /// How soon it can be triggered again after button.
    interval: u16,
    /// Level when joystick is to the positive side; max 0xFFFF.
    right_sat: [3]u16,
    /// Level when joystick is to the negative side; max 0xFFFF.
    left_sat: [3]u16,
    /// How fast to increase the force towards the positive side.
    right_coeff: [3]i16,
    /// How fast to increase the force towards the negative side.
    left_coeff: [3]i16,
    /// Size of the dead zone; max 0xFFFF: whole axis-range when 0-centered.
    deadband: [3]u16,
    /// Position of the dead zone.
    center: [3]i16,
};

/// A structure containing a template for a Ramp effect.
///
/// This struct is exclusively for the `haptic_ramp` effect.
///
/// The ramp effect starts at start strength and ends at end strength. It
/// augments in linear fashion. If you use attack and fade with a ramp the
/// effects get added to the ramp effect making the effect become quadratic
/// instead of linear.
pub const HapticRamp = extern struct {
    /// `haptic_ramp`
    type: HapticEffectType,
    /// Direction of the effect.
    direction: HapticDirection,
    /// Duration of the effect.
    length: u32,
    /// Delay before starting the effect.
    delay: u16,
    /// Button that triggers the effect.
    button: u16,
    /// How soon it can be triggered again after button.
    interval: u16,
    /// Beginning strength level.
    start: i16,
    /// Ending strength level.
    end: i16,
    /// Duration of the attack.
    attack_length: u16,
    /// Level at the start of the attack.
    attack_level: u16,
    /// Duration of the fade.
    fade_length: u16,
    /// Level at the end of the fade.
    fade_level: u16,
};

/// A structure containing a template for a Left/Right effect.
///
/// This struct is exclusively for the `haptic_leftright` effect.
///
/// The Left/Right effect is used to explicitly control the large and small
/// motors, commonly found in modern game controllers. The small (right) motor
/// is high frequency, and the large (left) motor is low frequency.
pub const HapticLeftRight = extern struct {
    /// `haptic_leftright`
    type: HapticEffectType,
    /// Duration of the effect in milliseconds.
    length: u32,
    /// Control of the large controller motor.
    large_magnitude: u16,
    /// Control of the small controller motor.
    small_magnitude: u16,
};

/// A structure containing a template for the `haptic_custom` effect.
///
/// This struct is exclusively for the `haptic_custom` effect.
///
/// A custom force feedback effect is much like a periodic effect, where the
/// application can define its exact shape. You will have to allocate the data
/// yourself. Data should consist of channels * samples Uint16 samples.
///
/// If channels is one, the effect is rotated using the defined direction.
/// Otherwise it uses the samples in data for the different axes.
pub const HapticCustom = extern struct {
    /// `haptic_custom`
    type: HapticEffectType,
    /// Direction of the effect.
    direction: HapticDirection,
    /// Duration of the effect.
    length: u32,
    /// Delay before starting the effect.
    delay: u16,
    /// Button that triggers the effect.
    button: u16,
    /// How soon it can be triggered again after button.
    interval: u16,
    /// Axes to use, minimum of one.
    channels: u8,
    /// Sample periods.
    period: u16,
    /// Amount of samples.
    samples: u16,
    /// Should contain channels*samples items.
    data: ?*u16,
    /// Duration of the attack.
    attack_length: u16,
    /// Level at the start of the attack.
    attack_level: u16,
    /// Duration of the fade.
    fade_length: u16,
    /// Level at the end of the fade.
    fade_level: u16,
};

/// The generic template for any haptic effect.
///
/// All values max at 32767 (0x7FFF). Signed values also can be negative. Time
/// values unless specified otherwise are in milliseconds.
///
/// You can also pass `haptic_infinity` to length instead of a 0-32767 value.
/// Neither delay, interval, attack_length nor fade_length support
/// `haptic_infinity`. Fade will also not be used since effect never ends.
///
/// Additionally, the `haptic_ramp` effect does not support a duration of
/// `haptic_infinity`.
///
/// Button triggers may not be supported on all devices, it is advised to not
/// use them if possible. Buttons start at index 1 instead of index 0 like the
/// joystick.
///
/// If both attack_length and fade_level are 0, the envelope is not used,
/// otherwise both values are used.
///
/// Common parts:
///
/// ```c
///  // Replay - All effects have this
///  Uint32 length;        // Duration of effect (ms).
///  Uint16 delay;         // Delay before starting effect.
///
///  // Trigger - All effects have this
///  Uint16 button;        // Button that triggers effect.
///  Uint16 interval;      // How soon before effect can be triggered again.
///
///  // Envelope - All effects except condition effects have this
///  Uint16 attack_length; // Duration of the attack (ms).
///  Uint16 attack_level;  // Level at the start of the attack.
///  Uint16 fade_length;   // Duration of the fade out (ms).
///  Uint16 fade_level;    // Level at the end of the fade.
/// ```
///
/// Here we have an example of a constant effect evolution in time:
///
/// ```
///  Strength
///  ^
///  |
///  |    effect level -->  _________________
///  |                     /                 \
///  |                    /                   \
///  |                   /                     \
///  |                  /                       \
///  | attack_level --> |                        \
///  |                  |                        |  <---  fade_level
///  |
///  +--------------------------------------------------> Time
///                     [--]                 [---]
///                     attack_length        fade_length
///
///  [------------------][-----------------------]
///  delay               length
/// ```
///
/// Note either the attack_level or the fade_level may be above the actual
/// effect level.
pub const HapticEffect = extern union {
    /// Effect type.
    type: HapticEffectType,
    /// Constant effect.
    constant: HapticConstant,
    /// Periodic effect.
    periodic: HapticPeriodic,
    /// Condition effect.
    condition: HapticCondition,
    /// Ramp effect.
    ramp: HapticRamp,
    /// Left/Right effect.
    leftright: HapticLeftRight,
    /// Custom effect.
    custom: HapticCustom,
};

/// This is a unique ID for a haptic device for the time it is connected to the
/// system, and is never reused for the lifetime of the application.
///
/// If the haptic device is disconnected and reconnected, it will get a new ID.
///
/// The value 0 is an invalid ID.
pub const HapticId = enum(u32) { invalid = 0, _ };

/// Get a list of currently connected haptic devices.
///
/// The returned value should be freed with `free` when it is no longer needed.
pub fn getHaptics() Error![]HapticId {
    var count: c_int = undefined;
    const ptr = SDL_GetHaptics(&count) orelse return makeError();
    return ptr[0..@intCast(count)];
}
extern fn SDL_GetHaptics(count: ?*c_int) ?[*]HapticId;

/// Get the implementation dependent name of a haptic device.
///
/// This can be called before any haptic devices are opened.
pub fn getHapticNameForId(instance_id: HapticId) ?[:0]const u8 {
    const str = SDL_GetHapticNameForID(instance_id) orelse return null;
    return std.mem.span(str);
}
extern fn SDL_GetHapticNameForID(instance_id: HapticId) ?[*:0]const u8;

/// Open a haptic device for use.
///
/// The index passed as an argument refers to the N'th haptic device on this
/// system.
///
/// When opening a haptic device, its gain will be set to maximum and
/// autocenter will be disabled. To modify these values use `setHapticGain`
/// and `setHapticAutocenter`.
pub fn openHaptic(instance_id: HapticId) Error!*Haptic {
    return SDL_OpenHaptic(instance_id) orelse makeError();
}
extern fn SDL_OpenHaptic(instance_id: HapticId) ?*Haptic;

/// Get the `Haptic` associated with an instance ID, if it has been opened.
pub fn getHapticFromId(instance_id: HapticId) Error!*Haptic {
    return SDL_GetHapticFromID(instance_id) orelse makeError();
}
extern fn SDL_GetHapticFromID(instance_id: HapticId) ?*Haptic;

/// Get the instance ID of an opened haptic device.
pub fn getHapticId(haptic: *Haptic) Error!HapticId {
    const result = SDL_GetHapticID(haptic);
    if (@backingInt(result) == 0) return makeError();
    return result;
}
extern fn SDL_GetHapticID(haptic: *Haptic) HapticId;

/// Get the implementation dependent name of a haptic device.
pub fn getHapticName(haptic: *Haptic) ?[:0]const u8 {
    const str = SDL_GetHapticName(haptic) orelse return null;
    return std.mem.span(str);
}
extern fn SDL_GetHapticName(haptic: *Haptic) ?[*:0]const u8;

/// Query whether or not the current mouse has haptic capabilities.
pub const isMouseHaptic = SDL_IsMouseHaptic;
extern fn SDL_IsMouseHaptic() bool;

/// Try to open a haptic device from the current mouse.
pub fn openHapticFromMouse() Error!*Haptic {
    return SDL_OpenHapticFromMouse() orelse makeError();
}
extern fn SDL_OpenHapticFromMouse() ?*Haptic;

/// Query if a joystick has haptic features.
pub const isJoystickHaptic = SDL_IsJoystickHaptic;
extern fn SDL_IsJoystickHaptic(joystick: *sdl.Joystick) bool;

/// Open a haptic device for use from a joystick device.
///
/// You must still close the haptic device separately. It will not be closed
/// with the joystick.
///
/// When opened from a joystick you should first close the haptic device before
/// closing the joystick device. If not, on some implementations the haptic
/// device will also get unallocated and you'll be unable to use force feedback
/// on that device.
pub fn openHapticFromJoystick(joystick: *sdl.Joystick) Error!*Haptic {
    return SDL_OpenHapticFromJoystick(joystick) orelse makeError();
}
extern fn SDL_OpenHapticFromJoystick(joystick: *sdl.Joystick) ?*Haptic;

/// Close a haptic device previously opened with `openHaptic`.
pub const closeHaptic = SDL_CloseHaptic;
extern fn SDL_CloseHaptic(haptic: *Haptic) void;

/// Get the number of effects a haptic device can store.
///
/// On some platforms this isn't fully supported, and therefore is an
/// approximation. Always check to see if your created effect was actually
/// created and do not rely solely on `getMaxHapticEffects`.
pub fn getMaxHapticEffects(haptic: *Haptic) Error!c_int {
    const result = SDL_GetMaxHapticEffects(haptic);
    if (result < 0) return makeError();
    return result;
}
extern fn SDL_GetMaxHapticEffects(haptic: *Haptic) c_int;

/// Get the number of effects a haptic device can play at the same time.
///
/// This is not supported on all platforms, but will always return a value.
pub fn getMaxHapticEffectsPlaying(haptic: *Haptic) Error!c_int {
    const result = SDL_GetMaxHapticEffectsPlaying(haptic);
    if (result < 0) return makeError();
    return result;
}
extern fn SDL_GetMaxHapticEffectsPlaying(haptic: *Haptic) c_int;

/// Get the haptic device's supported features in bitwise manner.
pub fn getHapticFeatures(haptic: *Haptic) Error!HapticFeatures {
    const features = SDL_GetHapticFeatures(haptic);
    if (@as(u32, @bitCast(features)) == 0) return makeError();
    return features;
}
extern fn SDL_GetHapticFeatures(haptic: *Haptic) HapticFeatures;

/// Get the number of haptic axes the device has.
///
/// The number of haptic axes might be useful if working with the
/// `HapticDirection` effect.
pub fn getNumHapticAxes(haptic: *Haptic) Error!c_int {
    const result = SDL_GetNumHapticAxes(haptic);
    if (result < 0) return makeError();
    return result;
}
extern fn SDL_GetNumHapticAxes(haptic: *Haptic) c_int;

/// Check to see if an effect is supported by a haptic device.
pub const hapticEffectSupported = SDL_HapticEffectSupported;
extern fn SDL_HapticEffectSupported(haptic: *Haptic, effect: *const HapticEffect) bool;

/// Create a new haptic effect on a specified device.
pub fn createHapticEffect(haptic: *Haptic, effect: *const HapticEffect) Error!HapticEffectId {
    const result = SDL_CreateHapticEffect(haptic, effect);
    if (result == .invalid) return makeError();
    return result;
}
extern fn SDL_CreateHapticEffect(haptic: *Haptic, effect: *const HapticEffect) HapticEffectId;

/// Update the properties of an effect.
///
/// Can be used dynamically, although behavior when dynamically changing
/// direction may be strange. Specifically the effect may re-upload itself and
/// start playing from the start. You also cannot change the type either when
/// running `updateHapticEffect`.
pub fn updateHapticEffect(haptic: *Haptic, effect: HapticEffectId, data: *const HapticEffect) Error!void {
    if (!SDL_UpdateHapticEffect(haptic, effect, data)) return makeError();
}
extern fn SDL_UpdateHapticEffect(haptic: *Haptic, effect: HapticEffectId, data: *const HapticEffect) bool;

/// Run the haptic effect on its associated haptic device.
///
/// To repeat the effect over and over indefinitely, set `iterations` to
/// `haptic_infinity`. (Repeats the envelope - attack and fade.) To make
/// one instance of the effect last indefinitely (so the effect does not fade),
/// set the effect's `length` in its structure/union to `haptic_infinity`
/// instead.
pub fn runHapticEffect(haptic: *Haptic, effect: HapticEffectId, iterations: u32) Error!void {
    if (!SDL_RunHapticEffect(haptic, effect, iterations)) return makeError();
}
extern fn SDL_RunHapticEffect(haptic: *Haptic, effect: HapticEffectId, iterations: u32) bool;

/// Stop the haptic effect on its associated haptic device.
pub fn stopHapticEffect(haptic: *Haptic, effect: HapticEffectId) Error!void {
    if (!SDL_StopHapticEffect(haptic, effect)) return makeError();
}
extern fn SDL_StopHapticEffect(haptic: *Haptic, effect: HapticEffectId) bool;

/// Destroy a haptic effect on the device.
///
/// This will stop the effect if it's running. Effects are automatically
/// destroyed when the device is closed.
pub const destroyHapticEffect = SDL_DestroyHapticEffect;
extern fn SDL_DestroyHapticEffect(haptic: *Haptic, effect: HapticEffectId) void;

/// Get the status of the current effect on the specified haptic device.
///
/// Device must support the `haptic_status` feature.
pub const getHapticEffectStatus = SDL_GetHapticEffectStatus;
extern fn SDL_GetHapticEffectStatus(haptic: *Haptic, effect: HapticEffectId) bool;

/// Set the global gain of the specified haptic device.
///
/// Device must support the `haptic_gain` feature.
///
/// The user may specify the maximum gain by setting the environment variable
/// SDL_HAPTIC_GAIN_MAX which should be between 0 and 100. All calls to
/// `setHapticGain` will scale linearly using SDL_HAPTIC_GAIN_MAX as the
/// maximum.
pub fn setHapticGain(haptic: *Haptic, gain: c_int) Error!void {
    if (!SDL_SetHapticGain(haptic, gain)) return makeError();
}
extern fn SDL_SetHapticGain(haptic: *Haptic, gain: c_int) bool;

/// Set the global autocenter of the device.
///
/// Autocenter should be between 0 and 100. Setting it to 0 will disable
/// autocentering.
///
/// Device must support the `haptic_autocenter` feature.
pub fn setHapticAutocenter(haptic: *Haptic, autocenter: c_int) Error!void {
    if (!SDL_SetHapticAutocenter(haptic, autocenter)) return makeError();
}
extern fn SDL_SetHapticAutocenter(haptic: *Haptic, autocenter: c_int) bool;

/// Pause a haptic device.
///
/// Device must support the `haptic_pause` feature. Call `resumeHaptic`
/// to resume playback.
///
/// Do not modify the effects nor add new ones while the device is paused. That
/// can cause all sorts of weird errors.
pub fn pauseHaptic(haptic: *Haptic) Error!void {
    if (!SDL_PauseHaptic(haptic)) return makeError();
}
extern fn SDL_PauseHaptic(haptic: *Haptic) bool;

/// Resume a haptic device.
///
/// Call to unpause after `pauseHaptic`.
pub fn resumeHaptic(haptic: *Haptic) Error!void {
    if (!SDL_ResumeHaptic(haptic)) return makeError();
}
extern fn SDL_ResumeHaptic(haptic: *Haptic) bool;

/// Stop all the currently playing effects on a haptic device.
pub fn stopHapticEffects(haptic: *Haptic) Error!void {
    if (!SDL_StopHapticEffects(haptic)) return makeError();
}
extern fn SDL_StopHapticEffects(haptic: *Haptic) bool;

/// Check whether rumble is supported on a haptic device.
pub const hapticRumbleSupported = SDL_HapticRumbleSupported;
extern fn SDL_HapticRumbleSupported(haptic: *Haptic) bool;

/// Initialize a haptic device for simple rumble playback.
pub fn initHapticRumble(haptic: *Haptic) Error!void {
    if (!SDL_InitHapticRumble(haptic)) return makeError();
}
extern fn SDL_InitHapticRumble(haptic: *Haptic) bool;

/// Run a simple rumble effect on a haptic device.
pub fn playHapticRumble(haptic: *Haptic, strength: f32, length: u32) Error!void {
    if (!SDL_PlayHapticRumble(haptic, strength, length)) return makeError();
}
extern fn SDL_PlayHapticRumble(haptic: *Haptic, strength: f32, length: u32) bool;

/// Stop the simple rumble on a haptic device.
pub fn stopHapticRumble(haptic: *Haptic) Error!void {
    if (!SDL_StopHapticRumble(haptic)) return makeError();
}
extern fn SDL_StopHapticRumble(haptic: *Haptic) bool;
