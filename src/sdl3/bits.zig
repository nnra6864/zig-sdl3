//! Bit Manipulation (SDL_bits.h)
//!
//! These are inline functions in C, implemented here with Zig builtins.

const std = @import("std");

const sdl = @import("../sdl3.zig");

/// Get the index of the most significant (set) bit in a 32-bit number.
///
/// Result is undefined when called with 0. This operation can also be stated
/// as "count leading zeroes" and "log base 2".
///
/// Returns the index of the most significant bit, or -1 if the value is 0.
pub fn mostSignificantBitIndex32(x: u32) c_int {
    if (x == 0) return -1;
    return 31 - @as(c_int, @clz(x));
}

/// Determine if a unsigned 32-bit value has exactly one bit set.
///
/// If there are no bits set (`x` is zero), or more than one bit set, this
/// returns false. If any one bit is exclusively set, this returns true.
pub fn hasExactlyOneBitSet32(x: u32) bool {
    return @popCount(x) == 1;
}

test "bit helpers" {
    try std.testing.expectEqual(-1, mostSignificantBitIndex32(0));
    try std.testing.expectEqual(31, mostSignificantBitIndex32(0x80000000));
    try std.testing.expect(hasExactlyOneBitSet32(64));
    try std.testing.expect(!hasExactlyOneBitSet32(3));
}
