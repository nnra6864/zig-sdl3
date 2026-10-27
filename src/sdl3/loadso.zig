//! Shared Object/DLL Management (SDL_loadso.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// An opaque datatype that represents a loaded shared object.
pub const SharedObject = opaque {};

/// Dynamically load a shared object.
pub fn loadObject(sofile: [:0]const u8) Error!*SharedObject {
    return SDL_LoadObject(sofile.ptr) orelse makeError();
}
extern fn SDL_LoadObject(sofile: [*:0]const u8) ?*SharedObject;

/// Look up the address of the named function in a shared object.
///
/// This function pointer is no longer valid after calling `unloadObject`.
///
/// This function can only look up C function names. Other languages may have
/// name mangling and intrinsic language support that varies from compiler to
/// compiler.
///
/// Make sure you declare your function pointers with the same calling
/// convention as the actual library function. Your code will crash
/// mysteriously if you do not do this.
///
/// If the requested function doesn't exist, null is returned.
pub fn loadFunction(handle: *SharedObject, name: [:0]const u8) Error!*const anyopaque {
    return SDL_LoadFunction(handle, name.ptr) orelse makeError();
}
extern fn SDL_LoadFunction(handle: *SharedObject, name: [*:0]const u8) ?*const anyopaque;

/// Unload a shared object from memory.
///
/// Note that any pointers from this object looked up through
/// `loadFunction` will no longer be valid.
pub const unloadObject = SDL_UnloadObject;
extern fn SDL_UnloadObject(handle: *SharedObject) void;
