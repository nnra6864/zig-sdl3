//! Byte Order and Byte Swapping (SDL_endian.h)
//!
//! These are inline functions/macros in C, implemented here with Zig builtins.
//! `std.mem.nativeTo*`/`*ToNative` do the same thing.

const std = @import("std");
const builtin = @import("builtin");

const sdl = @import("../sdl3.zig");

/// A value to represent littleendian byteorder.
pub const lil_endian = 1234;

/// A value to represent bigendian byteorder.
pub const big_endian = 4321;

/// The byteorder of the target platform, `lil_endian` or `big_endian`.
pub const byteorder = if (builtin.cpu.arch.endian() == .little) lil_endian else big_endian;

/// The floating point byteorder of the target platform, `lil_endian` or
/// `big_endian`.
pub const floatwordorder = byteorder;

/// Byte-swap an unsigned 16-bit number.
pub fn swap16(x: u16) u16 {
    return @byteSwap(x);
}

/// Byte-swap an unsigned 32-bit number.
pub fn swap32(x: u32) u32 {
    return @byteSwap(x);
}

/// Byte-swap an unsigned 64-bit number.
pub fn swap64(x: u64) u64 {
    return @byteSwap(x);
}

/// Byte-swap a floating point number.
///
/// This will always byte-swap the value, whether it's currently in the native
/// byteorder of the system or not. You should use `swapFloatLE` or
/// `swapFloatBE` instead, in most cases.
pub fn swapFloat(x: f32) f32 {
    return @bitCast(@byteSwap(@as(u32, @bitCast(x))));
}

const little = builtin.cpu.arch.endian() == .little;

/// Swap a 16-bit value from littleendian to native byte order.
pub fn swap16LE(x: u16) u16 {
    return if (little) x else swap16(x);
}

/// Swap a 32-bit value from littleendian to native byte order.
pub fn swap32LE(x: u32) u32 {
    return if (little) x else swap32(x);
}

/// Swap a 64-bit value from littleendian to native byte order.
pub fn swap64LE(x: u64) u64 {
    return if (little) x else swap64(x);
}

/// Swap a floating point value from littleendian to native byte order.
pub fn swapFloatLE(x: f32) f32 {
    return if (little) x else swapFloat(x);
}

/// Swap a 16-bit value from bigendian to native byte order.
pub fn swap16BE(x: u16) u16 {
    return if (little) swap16(x) else x;
}

/// Swap a 32-bit value from bigendian to native byte order.
pub fn swap32BE(x: u32) u32 {
    return if (little) swap32(x) else x;
}

/// Swap a 64-bit value from bigendian to native byte order.
pub fn swap64BE(x: u64) u64 {
    return if (little) swap64(x) else x;
}

/// Swap a floating point value from bigendian to native byte order.
pub fn swapFloatBE(x: f32) f32 {
    return if (little) swapFloat(x) else x;
}

test "byte swapping" {
    try std.testing.expectEqual(0x3412, swap16(0x1234));
    try std.testing.expectEqual(0x78563412, swap32(0x12345678));
    try std.testing.expectEqual(1.5, swapFloat(swapFloat(1.5)));
    try std.testing.expectEqual(std.mem.bigToNative(u32, 0x12345678), swap32BE(0x12345678));
}
