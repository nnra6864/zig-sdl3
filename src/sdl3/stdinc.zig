//! Standard Library Functionality (SDL_stdinc.h)
//!
//! Only the parts that are useful from Zig are bound here (memory management
//! and a few types); the libc-like string, math, sorting and character
//! functions are covered by Zig's standard library.

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// SDL times are signed, 64-bit integers representing nanoseconds since the
/// Unix epoch (Jan 1, 1970).
///
/// They can be converted between POSIX time_t values with `nsToSeconds` and
/// `secondsToNS`, and between Windows FILETIME values with `timeToWindows`
/// and `timeFromWindows`.
pub const Time = i64;
pub const max_time: Time = std.math.maxInt(i64);
pub const min_time: Time = std.math.minInt(i64);

/// Define a four character code as a `u32`.
pub fn fourcc(a: u8, b: u8, c: u8, d: u8) u32 {
    return @as(u32, a) | (@as(u32, b) << 8) | (@as(u32, c) << 16) | (@as(u32, d) << 24);
}

/// Allocate uninitialized memory.
///
/// The allocated memory returned by this function must be freed with
/// `free`.
///
/// If `size` is 0, it will be set to 1.
///
/// If the allocation is successful, the returned pointer is guaranteed to be
/// aligned to either the *fundamental alignment* (`alignof(max_align_t)` in
/// C11 and later) or `2 * sizeof(void *)`, whichever is smaller. Use
/// `alignedAlloc` if you need to allocate memory aligned to an alignment
/// greater than this guarantee.
pub const malloc = SDL_malloc;
extern fn SDL_malloc(size: usize) ?*anyopaque;

/// Allocate a zero-initialized array.
///
/// The memory returned by this function must be freed with `free`.
///
/// If either of `nmemb` or `size` is 0, they will both be set to 1.
///
/// If the allocation is successful, the returned pointer is guaranteed to be
/// aligned to either the *fundamental alignment* (`alignof(max_align_t)` in
/// C11 and later) or `2 * sizeof(void *)`, whichever is smaller.
pub const calloc = SDL_calloc;
extern fn SDL_calloc(nmemb: usize, size: usize) ?*anyopaque;

/// Change the size of allocated memory.
///
/// The memory returned by this function must be freed with `free`.
///
/// If `size` is 0, it will be set to 1. Note that this is unlike some other C
/// runtime `realloc` implementations, which may treat `realloc(mem, 0)` the
/// same way as `free(mem)`.
///
/// If `mem` is null, the behavior of this function is equivalent to
/// `malloc`. Otherwise, the function can have one of three possible
/// outcomes:
///
/// - If it returns the same pointer as `mem`, it means that `mem` was resized
///   in place without freeing.
/// - If it returns a different non-null pointer, it means that `mem` was freed
///   and cannot be dereferenced anymore.
/// - If it returns null (indicating failure), then `mem` will remain valid and
///   must still be freed with `free`.
///
/// If the allocation is successfully resized, the returned pointer is
/// guaranteed to be aligned to either the *fundamental alignment*
/// (`alignof(max_align_t)` in C11 and later) or `2 * sizeof(void *)`,
/// whichever is smaller.
pub const realloc = SDL_realloc;
extern fn SDL_realloc(mem: ?*anyopaque, size: usize) ?*anyopaque;

/// Free allocated memory.
///
/// The pointer is no longer valid after this call and cannot be dereferenced
/// anymore.
///
/// If `mem` is null, this function does nothing.
pub const free = SDL_free;
extern fn SDL_free(mem: ?*anyopaque) void;

/// A callback used to implement `malloc`.
///
/// SDL will always ensure that the passed `size` is greater than 0.
pub const MallocFn = *const fn (size: usize) callconv(.c) ?*anyopaque;

/// A callback used to implement `calloc`.
///
/// SDL will always ensure that the passed `nmemb` and `size` are both greater
/// than 0.
pub const CallocFn = *const fn (nmemb: usize, size: usize) callconv(.c) ?*anyopaque;

/// A callback used to implement `realloc`.
///
/// SDL will always ensure that the passed `size` is greater than 0.
pub const ReallocFn = *const fn (mem: ?*anyopaque, size: usize) callconv(.c) ?*anyopaque;

/// A callback used to implement `free`.
///
/// SDL will always ensure that the passed `mem` is a non-null pointer.
pub const FreeFn = *const fn (mem: ?*anyopaque) callconv(.c) void;

/// The set of memory functions SDL uses, as returned by `getMemoryFunctions`.
pub const MemoryFunctions = struct {
    malloc: MallocFn,
    calloc: CallocFn,
    realloc: ReallocFn,
    free: FreeFn,
};

/// Get the original set of SDL memory functions.
///
/// This is what `malloc` and friends will use by default, if there has been
/// no call to `setMemoryFunctions`. This is not necessarily using the C
/// runtime's `malloc` functions behind the scenes! Different platforms and
/// build configurations might do any number of unexpected things.
pub fn getOriginalMemoryFunctions() MemoryFunctions {
    var funcs: MemoryFunctions = undefined;
    SDL_GetOriginalMemoryFunctions(&funcs.malloc, &funcs.calloc, &funcs.realloc, &funcs.free);
    return funcs;
}
extern fn SDL_GetOriginalMemoryFunctions(malloc_func: *MallocFn, calloc_func: *CallocFn, realloc_func: *ReallocFn, free_func: *FreeFn) void;

/// Get the current set of SDL memory functions.
pub fn getMemoryFunctions() MemoryFunctions {
    var funcs: MemoryFunctions = undefined;
    SDL_GetMemoryFunctions(&funcs.malloc, &funcs.calloc, &funcs.realloc, &funcs.free);
    return funcs;
}
extern fn SDL_GetMemoryFunctions(malloc_func: *MallocFn, calloc_func: *CallocFn, realloc_func: *ReallocFn, free_func: *FreeFn) void;

/// Replace SDL's memory allocation functions with a custom set.
///
/// It is not safe to call this function once any allocations have been made,
/// as future calls to `free` will use the new allocator, even if they came
/// from a `malloc` made with the old one!
///
/// If used, usually this needs to be the first call made into the SDL library,
/// if not the very first thing done at program startup time.
pub fn setMemoryFunctions(malloc_func: MallocFn, calloc_func: CallocFn, realloc_func: ReallocFn, free_func: FreeFn) Error!void {
    if (!SDL_SetMemoryFunctions(malloc_func, calloc_func, realloc_func, free_func)) return makeError();
}
extern fn SDL_SetMemoryFunctions(malloc_func: MallocFn, calloc_func: CallocFn, realloc_func: ReallocFn, free_func: FreeFn) bool;

/// Allocate memory aligned to a specific alignment.
///
/// The memory returned by this function must be freed with `alignedFree`,
/// _not_ `free`.
///
/// If `alignment` is less than the size of `void *`, it will be increased to
/// match that.
///
/// The returned memory address will be a multiple of the alignment value, and
/// the size of the memory allocated will be a multiple of the alignment value.
pub const alignedAlloc = SDL_aligned_alloc;
extern fn SDL_aligned_alloc(alignment: usize, size: usize) ?*anyopaque;

/// Free memory allocated by `alignedAlloc`.
///
/// The pointer is no longer valid after this call and cannot be dereferenced
/// anymore.
///
/// If `mem` is null, this function does nothing.
pub const alignedFree = SDL_aligned_free;
extern fn SDL_aligned_free(mem: ?*anyopaque) void;

/// Get the number of outstanding (unfreed) allocations.
///
/// Returns -1 if allocation counting is disabled.
pub const getNumAllocations = SDL_GetNumAllocations;
extern fn SDL_GetNumAllocations() c_int;

/// A `std.mem.Allocator` backed by SDL's memory functions (`alignedAlloc`
/// and `alignedFree`), so allocations show up in `getNumAllocations` and go
/// through any functions set with `setMemoryFunctions`.
pub const allocator: std.mem.Allocator = .{
    .ptr = undefined,
    .vtable = &.{
        .alloc = allocatorAlloc,
        .resize = std.mem.Allocator.noResize,
        .remap = std.mem.Allocator.noRemap,
        .free = allocatorFree,
    },
};

fn allocatorAlloc(_: *anyopaque, len: usize, alignment: std.mem.Alignment, _: usize) ?[*]u8 {
    return @ptrCast(SDL_aligned_alloc(alignment.toByteUnits(), len));
}

fn allocatorFree(_: *anyopaque, memory: []u8, _: std.mem.Alignment, _: usize) void {
    SDL_aligned_free(memory.ptr);
}

test allocator {
    const slice = try allocator.alloc(u64, 16);
    defer allocator.free(slice);
    slice[15] = 42;
    try std.testing.expect(std.mem.isAligned(@intFromPtr(slice.ptr), @alignOf(u64)));
    try std.testing.checkAllAllocationFailures(allocator, struct {
        fn f(a: std.mem.Allocator) !void {
            const x = try a.create([64]u8);
            a.destroy(x);
        }
    }.f, .{});
}
