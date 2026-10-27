//! Object Properties (SDL_properties.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// An ID that represents a properties set.
pub const PropertiesId = enum(u32) { invalid = 0, _ };

/// SDL property type
pub const PropertyType = enum(c_int) {
    invalid,
    pointer,
    string,
    number,
    float,
    boolean,
};

/// A generic property for naming things.
///
/// This property is intended to be added to any `PropertiesId` that needs a
/// generic name associated with the property set. It is not guaranteed that
/// any property set will include this key, but it is convenient to have a
/// standard key that any piece of code could reasonably agree to use.
///
/// For example, the properties associated with an `Texture` might have a
/// name string of "player sprites", or an `AudioStream` might have
/// "background music", etc. This might also be useful for an `IOStream` to
/// list the path to its asset.
///
/// There is no format for the value set with this key; it is expected to be
/// human-readable and informational in nature, possibly for logging or
/// debugging purposes.
///
/// SDL does not currently set this property on any objects it creates, but
/// this may change in later versions; it is currently expected that apps and
/// external libraries will take advantage of it, when appropriate.
pub const prop_name_string = "SDL.name";

/// Get the global SDL properties.
pub fn getGlobalProperties() Error!PropertiesId {
    const result = SDL_GetGlobalProperties();
    if (@backingInt(result) == 0) return makeError();
    return result;
}
extern fn SDL_GetGlobalProperties() PropertiesId;

/// Create a group of properties.
///
/// All properties are automatically destroyed when `quit` is called.
pub fn createProperties() Error!PropertiesId {
    const result = SDL_CreateProperties();
    if (@backingInt(result) == 0) return makeError();
    return result;
}
extern fn SDL_CreateProperties() PropertiesId;

/// Copy a group of properties.
///
/// Copy all the properties from one group of properties to another, with the
/// exception of properties requiring cleanup (set using
/// `setPointerPropertyWithCleanup`), which will not be copied. Any
/// property that already exists on `dst` will be overwritten.
pub fn copyProperties(src: PropertiesId, dst: PropertiesId) Error!void {
    if (!SDL_CopyProperties(src, dst)) return makeError();
}
extern fn SDL_CopyProperties(src: PropertiesId, dst: PropertiesId) bool;

/// Lock a group of properties.
///
/// Obtain a multi-threaded lock for these properties. Other threads will wait
/// while trying to lock these properties until they are unlocked. Properties
/// must be unlocked before they are destroyed.
///
/// The lock is automatically taken when setting individual properties, this
/// function is only needed when you want to set several properties atomically
/// or want to guarantee that properties being queried aren't freed in another
/// thread.
pub fn lockProperties(props: PropertiesId) Error!void {
    if (!SDL_LockProperties(props)) return makeError();
}
extern fn SDL_LockProperties(props: PropertiesId) bool;

/// Unlock a group of properties.
pub const unlockProperties = SDL_UnlockProperties;
extern fn SDL_UnlockProperties(props: PropertiesId) void;

/// A callback used to free resources when a property is deleted.
///
/// This should release any resources associated with `value` that are no
/// longer needed.
///
/// This callback is set per-property. Different properties in the same group
/// can have different cleanup callbacks.
///
/// This callback will be called _during_ `setPointerPropertyWithCleanup` if
/// the function fails for any reason.
pub const CleanupPropertyCallback = *const fn (userdata: ?*anyopaque, value: ?*anyopaque) callconv(.c) void;

/// Set a pointer property in a group of properties with a cleanup function
/// that is called when the property is deleted.
///
/// The cleanup function is also called if setting the property fails for any
/// reason.
///
/// For simply setting basic data types, like numbers, bools, or strings, use
/// `setNumberProperty`, `setBooleanProperty`, or `setStringProperty`
/// instead, as those functions will handle cleanup on your behalf. This
/// function is only for more complex, custom data.
pub fn setPointerPropertyWithCleanup(props: PropertiesId, name: [:0]const u8, value: ?*anyopaque, cleanup: ?CleanupPropertyCallback, userdata: ?*anyopaque) Error!void {
    if (!SDL_SetPointerPropertyWithCleanup(props, name.ptr, value, cleanup, userdata)) return makeError();
}
extern fn SDL_SetPointerPropertyWithCleanup(props: PropertiesId, name: [*:0]const u8, value: ?*anyopaque, cleanup: ?CleanupPropertyCallback, userdata: ?*anyopaque) bool;

/// Set a pointer property in a group of properties.
pub fn setPointerProperty(props: PropertiesId, name: [:0]const u8, value: ?*anyopaque) Error!void {
    if (!SDL_SetPointerProperty(props, name.ptr, value)) return makeError();
}
extern fn SDL_SetPointerProperty(props: PropertiesId, name: [*:0]const u8, value: ?*anyopaque) bool;

/// Set a string property in a group of properties.
///
/// This function makes a copy of the string; the caller does not have to
/// preserve the data after this call completes.
pub fn setStringProperty(props: PropertiesId, name: [:0]const u8, value: ?[:0]const u8) Error!void {
    if (!SDL_SetStringProperty(props, name.ptr, if (value) |s| s.ptr else null)) return makeError();
}
extern fn SDL_SetStringProperty(props: PropertiesId, name: [*:0]const u8, value: ?[*:0]const u8) bool;

/// Set an integer property in a group of properties.
pub fn setNumberProperty(props: PropertiesId, name: [:0]const u8, value: i64) Error!void {
    if (!SDL_SetNumberProperty(props, name.ptr, value)) return makeError();
}
extern fn SDL_SetNumberProperty(props: PropertiesId, name: [*:0]const u8, value: i64) bool;

/// Set a floating point property in a group of properties.
pub fn setFloatProperty(props: PropertiesId, name: [:0]const u8, value: f32) Error!void {
    if (!SDL_SetFloatProperty(props, name.ptr, value)) return makeError();
}
extern fn SDL_SetFloatProperty(props: PropertiesId, name: [*:0]const u8, value: f32) bool;

/// Set a boolean property in a group of properties.
pub fn setBooleanProperty(props: PropertiesId, name: [:0]const u8, value: bool) Error!void {
    if (!SDL_SetBooleanProperty(props, name.ptr, value)) return makeError();
}
extern fn SDL_SetBooleanProperty(props: PropertiesId, name: [*:0]const u8, value: bool) bool;

/// Return whether a property exists in a group of properties.
pub fn hasProperty(props: PropertiesId, name: [:0]const u8) bool {
    return SDL_HasProperty(props, name.ptr);
}
extern fn SDL_HasProperty(props: PropertiesId, name: [*:0]const u8) bool;

/// Get the type of a property in a group of properties.
pub fn getPropertyType(props: PropertiesId, name: [:0]const u8) PropertyType {
    return SDL_GetPropertyType(props, name.ptr);
}
extern fn SDL_GetPropertyType(props: PropertiesId, name: [*:0]const u8) PropertyType;

/// Get a pointer property from a group of properties.
///
/// By convention, the names of properties that SDL exposes on objects will
/// start with "SDL.", and properties that SDL uses internally will start with
/// "SDL.internal.". These should be considered read-only and should not be
/// modified by applications.
pub fn getPointerProperty(props: PropertiesId, name: [:0]const u8, default_value: ?*anyopaque) ?*anyopaque {
    return SDL_GetPointerProperty(props, name.ptr, default_value);
}
extern fn SDL_GetPointerProperty(props: PropertiesId, name: [*:0]const u8, default_value: ?*anyopaque) ?*anyopaque;

/// Get a string property from a group of properties.
pub fn getStringProperty(props: PropertiesId, name: [:0]const u8, default_value: ?[:0]const u8) ?[:0]const u8 {
    const str = SDL_GetStringProperty(props, name.ptr, if (default_value) |s| s.ptr else null) orelse return null;
    return std.mem.span(str);
}
extern fn SDL_GetStringProperty(props: PropertiesId, name: [*:0]const u8, default_value: ?[*:0]const u8) ?[*:0]const u8;

/// Get a number property from a group of properties.
///
/// You can use `getPropertyType` to query whether the property exists and
/// is a number property.
pub fn getNumberProperty(props: PropertiesId, name: [:0]const u8, default_value: i64) i64 {
    return SDL_GetNumberProperty(props, name.ptr, default_value);
}
extern fn SDL_GetNumberProperty(props: PropertiesId, name: [*:0]const u8, default_value: i64) i64;

/// Get a floating point property from a group of properties.
///
/// You can use `getPropertyType` to query whether the property exists and
/// is a floating point property.
pub fn getFloatProperty(props: PropertiesId, name: [:0]const u8, default_value: f32) f32 {
    return SDL_GetFloatProperty(props, name.ptr, default_value);
}
extern fn SDL_GetFloatProperty(props: PropertiesId, name: [*:0]const u8, default_value: f32) f32;

/// Get a boolean property from a group of properties.
///
/// You can use `getPropertyType` to query whether the property exists and
/// is a boolean property.
pub fn getBooleanProperty(props: PropertiesId, name: [:0]const u8, default_value: bool) bool {
    return SDL_GetBooleanProperty(props, name.ptr, default_value);
}
extern fn SDL_GetBooleanProperty(props: PropertiesId, name: [*:0]const u8, default_value: bool) bool;

/// Clear a property from a group of properties.
pub fn clearProperty(props: PropertiesId, name: [:0]const u8) Error!void {
    if (!SDL_ClearProperty(props, name.ptr)) return makeError();
}
extern fn SDL_ClearProperty(props: PropertiesId, name: [*:0]const u8) bool;

/// A callback used to enumerate all the properties in a group of properties.
///
/// This callback is called from `enumerateProperties`, and is called once
/// per property in the set.
pub const EnumeratePropertiesCallback = *const fn (userdata: ?*anyopaque, props: PropertiesId, name: [*:0]const u8) callconv(.c) void;

/// Enumerate the properties contained in a group of properties.
///
/// The callback function is called for each property in the group of
/// properties. The properties are locked during enumeration.
pub fn enumerateProperties(props: PropertiesId, callback: EnumeratePropertiesCallback, userdata: ?*anyopaque) Error!void {
    if (!SDL_EnumerateProperties(props, callback, userdata)) return makeError();
}
extern fn SDL_EnumerateProperties(props: PropertiesId, callback: EnumeratePropertiesCallback, userdata: ?*anyopaque) bool;

/// Destroy a group of properties.
///
/// All properties are deleted and their cleanup functions will be called, if
/// any.
pub const destroyProperties = SDL_DestroyProperties;
extern fn SDL_DestroyProperties(props: PropertiesId) void;
