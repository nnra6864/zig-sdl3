//! Sensors (SDL_sensor.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// The opaque structure used to identify an opened SDL sensor.
pub const Sensor = opaque {
    pub const open = openSensor;
    pub const getFromId = getSensorFromId;
    pub const getProperties = getSensorProperties;
    pub const getName = getSensorName;
    pub const getType = getSensorType;
    pub const getNonPortableType = getSensorNonPortableType;
    pub const getId = getSensorId;
    pub const getData = getSensorData;
    pub const close = closeSensor;
};

/// This is a unique ID for a sensor for the time it is connected to the
/// system, and is never reused for the lifetime of the application.
///
/// The value 0 is an invalid ID.
pub const SensorId = enum(u32) { invalid = 0, _ };

/// A constant to represent standard gravity for accelerometer sensors.
///
/// The accelerometer returns the current acceleration in SI meters per second
/// squared. This measurement includes the force of gravity, so a device at
/// rest will have an value of `standard_gravity` away from the center of the
/// earth, which is a positive Y value.
pub const standard_gravity: f32 = 9.80665;

/// The different sensors defined by SDL.
///
/// Additional sensors may be available, using platform dependent semantics.
///
/// Here are the additional Android sensors:
///
/// https://developer.android.com/reference/android/hardware/SensorEvent.html#values
///
/// Accelerometer sensor notes:
///
/// The accelerometer returns the current acceleration in SI meters per second
/// squared. This measurement includes the force of gravity, so a device at
/// rest will have an value of `standard_gravity` away from the center of the
/// earth, which is a positive Y value.
///
/// - `values[0]`: Acceleration on the x axis
/// - `values[1]`: Acceleration on the y axis
/// - `values[2]`: Acceleration on the z axis
///
/// For phones and tablets held in natural orientation and game controllers
/// held in front of you, the axes are defined as follows:
///
/// - -X ... +X : left ... right
/// - -Y ... +Y : bottom ... top
/// - -Z ... +Z : farther ... closer
///
/// The accelerometer axis data is not changed when the device is rotated.
///
/// Gyroscope sensor notes:
///
/// The gyroscope returns the current rate of rotation in radians per second.
/// The rotation is positive in the counter-clockwise direction. That is, an
/// observer looking from a positive location on one of the axes would see
/// positive rotation on that axis when it appeared to be rotating
/// counter-clockwise.
///
/// - `values[0]`: Angular speed around the x axis (pitch)
/// - `values[1]`: Angular speed around the y axis (yaw)
/// - `values[2]`: Angular speed around the z axis (roll)
///
/// For phones and tablets held in natural orientation and game controllers
/// held in front of you, the axes are defined as follows:
///
/// - -X ... +X : left ... right
/// - -Y ... +Y : bottom ... top
/// - -Z ... +Z : farther ... closer
///
/// The gyroscope axis data is not changed when the device is rotated.
pub const SensorType = enum(c_int) {
    /// Returned for an invalid sensor
    invalid = -1,
    /// Unknown sensor type
    unknown,
    /// Accelerometer
    accel,
    /// Gyroscope
    gyro,
    /// Accelerometer for left Joy-Con controller and Wii nunchuk
    accel_l,
    /// Gyroscope for left Joy-Con controller
    gyro_l,
    /// Accelerometer for right Joy-Con controller
    accel_r,
    /// Gyroscope for right Joy-Con controller
    gyro_r,
    count,
};

/// Get a list of currently connected sensors.
///
/// The returned value should be freed with `free` when it is no longer needed.
pub fn getSensors() Error![]SensorId {
    var count: c_int = undefined;
    const ptr = SDL_GetSensors(&count) orelse return makeError();
    return ptr[0..@intCast(count)];
}
extern fn SDL_GetSensors(count: ?*c_int) ?[*]SensorId;

/// Get the implementation dependent name of a sensor.
///
/// This can be called before any sensors are opened.
pub fn getSensorNameForId(instance_id: SensorId) ?[:0]const u8 {
    const str = SDL_GetSensorNameForID(instance_id) orelse return null;
    return std.mem.span(str);
}
extern fn SDL_GetSensorNameForID(instance_id: SensorId) ?[*:0]const u8;

/// Get the type of a sensor.
///
/// This can be called before any sensors are opened.
pub const getSensorTypeForId = SDL_GetSensorTypeForID;
extern fn SDL_GetSensorTypeForID(instance_id: SensorId) SensorType;

/// Get the platform dependent type of a sensor.
///
/// This can be called before any sensors are opened.
pub fn getSensorNonPortableTypeForId(instance_id: SensorId) Error!c_int {
    const result = SDL_GetSensorNonPortableTypeForID(instance_id);
    if (result < 0) return makeError();
    return result;
}
extern fn SDL_GetSensorNonPortableTypeForID(instance_id: SensorId) c_int;

/// Open a sensor for use.
pub fn openSensor(instance_id: SensorId) Error!*Sensor {
    return SDL_OpenSensor(instance_id) orelse makeError();
}
extern fn SDL_OpenSensor(instance_id: SensorId) ?*Sensor;

/// Return the `Sensor` associated with an instance ID.
pub fn getSensorFromId(instance_id: SensorId) Error!*Sensor {
    return SDL_GetSensorFromID(instance_id) orelse makeError();
}
extern fn SDL_GetSensorFromID(instance_id: SensorId) ?*Sensor;

/// Get the properties associated with a sensor.
pub fn getSensorProperties(sensor: *Sensor) Error!sdl.PropertiesId {
    const result = SDL_GetSensorProperties(sensor);
    if (@backingInt(result) == 0) return makeError();
    return result;
}
extern fn SDL_GetSensorProperties(sensor: *Sensor) sdl.PropertiesId;

/// Get the implementation dependent name of a sensor.
pub fn getSensorName(sensor: *Sensor) Error![:0]const u8 {
    const str = SDL_GetSensorName(sensor) orelse return makeError();
    return std.mem.span(str);
}
extern fn SDL_GetSensorName(sensor: *Sensor) ?[*:0]const u8;

/// Get the type of a sensor.
pub const getSensorType = SDL_GetSensorType;
extern fn SDL_GetSensorType(sensor: *Sensor) SensorType;

/// Get the platform dependent type of a sensor.
pub fn getSensorNonPortableType(sensor: *Sensor) Error!c_int {
    const result = SDL_GetSensorNonPortableType(sensor);
    if (result < 0) return makeError();
    return result;
}
extern fn SDL_GetSensorNonPortableType(sensor: *Sensor) c_int;

/// Get the instance ID of a sensor.
pub fn getSensorId(sensor: *Sensor) Error!SensorId {
    const result = SDL_GetSensorID(sensor);
    if (@backingInt(result) == 0) return makeError();
    return result;
}
extern fn SDL_GetSensorID(sensor: *Sensor) SensorId;

/// Get the current state of an opened sensor.
///
/// The number of values and interpretation of the data is sensor dependent.
pub fn getSensorData(sensor: *Sensor, data: []f32) Error!void {
    if (!SDL_GetSensorData(sensor, data.ptr, @intCast(data.len))) return makeError();
}
extern fn SDL_GetSensorData(sensor: *Sensor, data: [*]f32, num_values: c_int) bool;

/// Close a sensor previously opened with `openSensor`.
pub const closeSensor = SDL_CloseSensor;
extern fn SDL_CloseSensor(sensor: *Sensor) void;

/// Update the current state of the open sensors.
///
/// This is called automatically by the event loop if sensor events are
/// enabled.
///
/// This needs to be called from the thread that initialized the sensor
/// subsystem.
pub const updateSensors = SDL_UpdateSensors;
extern fn SDL_UpdateSensors() void;
