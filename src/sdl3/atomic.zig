//! Atomic Operations (SDL_atomic.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");

/// An atomic spinlock.
///
/// The atomic locks are efficient spinlocks using CPU instructions, but are
/// vulnerable to starvation and can spin forever if a thread holding a lock
/// has been terminated. For this reason you should minimize the code executed
/// inside an atomic lock and never do expensive things like API or system
/// calls while holding them.
///
/// They are also vulnerable to starvation if the thread holding the lock is
/// lower priority than other threads and doesn't get scheduled. In general you
/// should use mutexes instead, since they have better performance and
/// contention behavior.
///
/// The atomic locks are not safe to lock recursively.
///
/// Porting Note: The spin lock functions and type are required and can not be
/// emulated because they are used in the atomic emulation code.
pub const SpinLock = c_int;

/// Try to lock a spin lock by setting it to a non-zero value.
///
/// ***Please note that spinlocks are dangerous if you don't know what you're
/// doing. Please be careful using any sort of spinlock!***
pub const tryLockSpinlock = SDL_TryLockSpinlock;
extern fn SDL_TryLockSpinlock(lock: *SpinLock) bool;

/// Lock a spin lock by setting it to a non-zero value.
///
/// ***Please note that spinlocks are dangerous if you don't know what you're
/// doing. Please be careful using any sort of spinlock!***
pub const lockSpinlock = SDL_LockSpinlock;
extern fn SDL_LockSpinlock(lock: *SpinLock) void;

/// Unlock a spin lock by setting it to 0.
///
/// Always returns immediately.
///
/// ***Please note that spinlocks are dangerous if you don't know what you're
/// doing. Please be careful using any sort of spinlock!***
pub const unlockSpinlock = SDL_UnlockSpinlock;
extern fn SDL_UnlockSpinlock(lock: *SpinLock) void;

/// A function to insert a CPU-specific "pause" instruction into the program.
///
/// This can be useful in busy-wait loops, as it serves as a hint to the CPU as
/// to the program's intent; some CPUs can use this to do more efficient
/// processing. On some platforms, this doesn't do anything.
///
/// Note that if you are busy-waiting, there are often more-efficient
/// approaches with other synchronization primitives: mutexes, semaphores,
/// condition variables, etc.
pub const cpuPauseInstruction = std.atomic.spinLoopHint;

/// Insert a memory release barrier (function version).
///
/// Please refer to `MemoryBarrierRelease` for details. This is a function
/// version, which might be useful if you need to use this functionality from a
/// scripting language, etc. Also, some of the macro versions call this
/// function behind the scenes, where more heavy lifting can happen inside of
/// SDL. Generally, though, an app written in C/C++/etc should use the macro
/// version, as it will be more efficient.
pub const memoryBarrierReleaseFunction = SDL_MemoryBarrierReleaseFunction;
extern fn SDL_MemoryBarrierReleaseFunction() void;

/// Insert a memory acquire barrier (function version).
///
/// Please refer to `MemoryBarrierRelease` for details. This is a function
/// version, which might be useful if you need to use this functionality from a
/// scripting language, etc. Also, some of the macro versions call this
/// function behind the scenes, where more heavy lifting can happen inside of
/// SDL. Generally, though, an app written in C/C++/etc should use the macro
/// version, as it will be more efficient.
pub const memoryBarrierAcquireFunction = SDL_MemoryBarrierAcquireFunction;
extern fn SDL_MemoryBarrierAcquireFunction() void;

/// A type representing an atomic integer value.
///
/// This can be used to manage a value that is synchronized across multiple
/// CPUs without a race condition; when an app sets a value with
/// `setAtomicInt` all other threads, regardless of the CPU it is running on,
/// will see that value when retrieved with `getAtomicInt`, regardless of CPU
/// caches, etc.
///
/// This is also useful for atomic compare-and-swap operations: a thread can
/// change the value as long as its current value matches expectations. When
/// done in a loop, one can guarantee data consistency across threads without a
/// lock (but the usual warnings apply: if you don't know what you're doing, or
/// you don't do it carefully, you can confidently cause any number of
/// disasters with this, so in most cases, you _should_ use a mutex instead of
/// this!).
///
/// This is a struct so people don't accidentally use numeric operations on it
/// directly. You have to use SDL atomic functions.
pub const AtomicInt = extern struct {
    value: c_int,
};

/// Set an atomic variable to a new value if it is currently an old value.
///
/// ***Note: If you don't know what this function is for, you shouldn't use
/// it!***
pub const compareAndSwapAtomicInt = SDL_CompareAndSwapAtomicInt;
extern fn SDL_CompareAndSwapAtomicInt(a: *AtomicInt, oldval: c_int, newval: c_int) bool;

/// Set an atomic variable to a value.
///
/// This function also acts as a full memory barrier.
///
/// ***Note: If you don't know what this function is for, you shouldn't use
/// it!***
pub const setAtomicInt = SDL_SetAtomicInt;
extern fn SDL_SetAtomicInt(a: *AtomicInt, v: c_int) c_int;

/// Get the value of an atomic variable.
///
/// ***Note: If you don't know what this function is for, you shouldn't use
/// it!***
pub const getAtomicInt = SDL_GetAtomicInt;
extern fn SDL_GetAtomicInt(a: *AtomicInt) c_int;

/// Add to an atomic variable.
///
/// This function also acts as a full memory barrier.
///
/// ***Note: If you don't know what this function is for, you shouldn't use
/// it!***
pub const addAtomicInt = SDL_AddAtomicInt;
extern fn SDL_AddAtomicInt(a: *AtomicInt, v: c_int) c_int;

/// Increment an atomic variable used as a reference count.
///
/// ***Note: If you don't know what this function is for, you shouldn't use it!***
///
/// Returns the previous value of the atomic variable.
pub fn atomicIncRef(a: *AtomicInt) c_int {
    return addAtomicInt(a, 1);
}

/// Decrement an atomic variable used as a reference count.
///
/// ***Note: If you don't know what this function is for, you shouldn't use it!***
///
/// Returns true if the variable reached zero after decrementing, false
/// otherwise.
pub fn atomicDecRef(a: *AtomicInt) bool {
    return addAtomicInt(a, -1) == 1;
}

/// A type representing an atomic unsigned integer value.
///
/// This can be used to manage a value that is synchronized across multiple
/// CPUs without a race condition; when an app sets a value with
/// `setAtomicU32` all other threads, regardless of the CPU it is running on,
/// will see that value when retrieved with `getAtomicU32`, regardless of CPU
/// caches, etc.
///
/// This is also useful for atomic compare-and-swap operations: a thread can
/// change the value as long as its current value matches expectations. When
/// done in a loop, one can guarantee data consistency across threads without a
/// lock (but the usual warnings apply: if you don't know what you're doing, or
/// you don't do it carefully, you can confidently cause any number of
/// disasters with this, so in most cases, you _should_ use a mutex instead of
/// this!).
///
/// This is a struct so people don't accidentally use numeric operations on it
/// directly. You have to use SDL atomic functions.
pub const AtomicU32 = extern struct {
    value: u32,
};

/// Set an atomic variable to a new value if it is currently an old value.
///
/// ***Note: If you don't know what this function is for, you shouldn't use
/// it!***
pub const compareAndSwapAtomicU32 = SDL_CompareAndSwapAtomicU32;
extern fn SDL_CompareAndSwapAtomicU32(a: *AtomicU32, oldval: u32, newval: u32) bool;

/// Set an atomic variable to a value.
///
/// This function also acts as a full memory barrier.
///
/// ***Note: If you don't know what this function is for, you shouldn't use
/// it!***
pub const setAtomicU32 = SDL_SetAtomicU32;
extern fn SDL_SetAtomicU32(a: *AtomicU32, v: u32) u32;

/// Get the value of an atomic variable.
///
/// ***Note: If you don't know what this function is for, you shouldn't use
/// it!***
pub const getAtomicU32 = SDL_GetAtomicU32;
extern fn SDL_GetAtomicU32(a: *AtomicU32) u32;

/// Add to an atomic variable.
///
/// This function also acts as a full memory barrier.
///
/// ***Note: If you don't know what this function is for, you shouldn't use
/// it!***
pub const addAtomicU32 = SDL_AddAtomicU32;
extern fn SDL_AddAtomicU32(a: *AtomicU32, v: c_int) u32;

/// Set a pointer to a new value if it is currently an old value.
///
/// ***Note: If you don't know what this function is for, you shouldn't use
/// it!***
pub const compareAndSwapAtomicPointer = SDL_CompareAndSwapAtomicPointer;
extern fn SDL_CompareAndSwapAtomicPointer(a: *?*anyopaque, oldval: ?*anyopaque, newval: ?*anyopaque) bool;

/// Set a pointer to a value atomically.
///
/// ***Note: If you don't know what this function is for, you shouldn't use
/// it!***
pub const setAtomicPointer = SDL_SetAtomicPointer;
extern fn SDL_SetAtomicPointer(a: *?*anyopaque, v: ?*anyopaque) ?*anyopaque;

/// Get the value of a pointer atomically.
///
/// ***Note: If you don't know what this function is for, you shouldn't use
/// it!***
pub const getAtomicPointer = SDL_GetAtomicPointer;
extern fn SDL_GetAtomicPointer(a: *?*anyopaque) ?*anyopaque;
