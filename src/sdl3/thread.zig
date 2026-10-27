//! Thread Management (SDL_thread.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// The SDL thread object.
///
/// These are opaque data.
pub const Thread = opaque {
    pub const Properties = struct {
        pub const create_entry_function_pointer = "SDL.thread.create.entry_function";
        pub const create_name_string = "SDL.thread.create.name";
        pub const create_userdata_pointer = "SDL.thread.create.userdata";
        pub const create_stacksize_number = "SDL.thread.create.stacksize";
    };
    pub const create = createThread;
    pub const createWithProperties = createThreadWithProperties;
    pub const createRuntime = createThreadRuntime;
    pub const createWithPropertiesRuntime = createThreadWithPropertiesRuntime;
    pub const getName = getThreadName;
    pub const getId = getThreadId;
    pub const wait = waitThread;
    pub const getState = getThreadState;
    pub const detach = detachThread;
};

/// A unique numeric ID that identifies a thread.
///
/// These are different from `Thread` objects, which are generally what an
/// application will operate on, but having a way to uniquely identify a thread
/// can be useful at times.
pub const ThreadId = enum(u64) { invalid = 0, _ };

/// Thread local storage ID.
///
/// 0 is the invalid ID. An app can create these and then set data for these
/// IDs that is unique to each thread.
pub const TLSID = sdl.AtomicInt;

/// The SDL thread priority.
///
/// SDL will make system changes as necessary in order to apply the thread
/// priority. Code which attempts to control thread state related to priority
/// should be aware that calling `setCurrentThreadPriority` may alter such
/// state. `hint_thread_priority_policy` can be used to control aspects of
/// this behavior.
pub const ThreadPriority = enum(c_int) {
    low,
    normal,
    high,
    time_critical,
};

/// The SDL thread state.
///
/// The current state of a thread can be checked by calling `getThreadState`.
pub const ThreadState = enum(c_int) {
    /// The thread is not valid
    unknown,
    /// The thread is currently running
    alive,
    /// The thread is detached and can't be waited on
    detached,
    /// The thread has finished and should be cleaned up with `waitThread`
    complete,
};

/// The function passed to `createThread` as the new thread's entry point.
pub const ThreadFunction = *const fn (data: ?*anyopaque) callconv(.c) c_int;

/// Create a new thread with a default stack size.
///
/// This is a convenience function, equivalent to calling
/// `createThreadWithProperties` with the following properties set:
///
/// - `Thread.Properties.create_entry_function_pointer`: `fn`
/// - `Thread.Properties.create_name_string`: `name`
/// - `Thread.Properties.create_userdata_pointer`: `data`
///
/// Note that this "function" is actually a macro that calls an internal
/// function with two extra parameters not listed here; they are hidden through
/// preprocessor macros and are needed to support various C runtimes at the
/// point of the function call. Language bindings that aren't using the C
/// headers will need to deal with this.
///
/// Usually, apps should just call this function the same way on every platform
/// and let the macros hide the details.
pub fn createThread(@"fn": ThreadFunction, name: [:0]const u8, data: ?*anyopaque) Error!*Thread {
    return SDL_CreateThreadRuntime(@"fn", name.ptr, data, null, null) orelse makeError();
}

/// Create a new thread with with the specified properties.
///
/// These are the supported properties:
///
/// - `Thread.Properties.create_entry_function_pointer`: a `ThreadFunction`
///   value that will be called at the start of the new thread's life.
///   Required.
/// - `Thread.Properties.create_name_string`: the name of the new thread, which
///   might be available to debuggers. Optional, defaults to null.
/// - `Thread.Properties.create_userdata_pointer`: an arbitrary app-defined
///   pointer, which is passed to the entry function on the new thread, as its
///   only parameter. Optional, defaults to null.
/// - `Thread.Properties.create_stacksize_number`: the size, in bytes, of the new
///   thread's stack. Optional, defaults to 0 (system-defined default).
///
/// SDL makes an attempt to report `Thread.Properties.create_name_string` to the
/// system, so that debuggers can display it. Not all platforms support this.
///
/// Thread naming is a little complicated: Most systems have very small limits
/// for the string length (Haiku has 32 bytes, Linux currently has 16, Visual
/// C++ 6.0 has _nine_!), and possibly other arbitrary rules. You'll have to
/// see what happens with your system's debugger. The name should be UTF-8 (but
/// using the naming limits of C identifiers is a better bet). There are no
/// requirements for thread naming conventions, so long as the string is
/// null-terminated UTF-8, but these guidelines are helpful in choosing a name:
///
/// https://stackoverflow.com/questions/149932/naming-conventions-for-threads
///
/// If a system imposes requirements, SDL will try to munge the string for it
/// (truncate, etc), but the original string contents will be available from
/// `getThreadName`.
///
/// The size (in bytes) of the new stack can be specified with
/// `Thread.Properties.create_stacksize_number`. Zero means "use the system
/// default" which might be wildly different between platforms. x86 Linux
/// generally defaults to eight megabytes, an embedded device might be a few
/// kilobytes instead. You generally need to specify a stack that is a multiple
/// of the system's page size (in many cases, this is 4 kilobytes, but check
/// your system documentation).
///
/// Note that this "function" is actually a macro that calls an internal
/// function with two extra parameters not listed here; they are hidden through
/// preprocessor macros and are needed to support various C runtimes at the
/// point of the function call. Language bindings that aren't using the C
/// headers will need to deal with this.
///
/// The actual symbol in SDL is `createThreadWithPropertiesRuntime`, so
/// there is no symbol clash, but trying to load an SDL shared library and look
/// for "`createThreadWithProperties`" will fail.
///
/// Usually, apps should just call this function the same way on every platform
/// and let the macros hide the details.
pub fn createThreadWithProperties(props: sdl.PropertiesId) Error!*Thread {
    return SDL_CreateThreadWithPropertiesRuntime(props, null, null) orelse makeError();
}

/// The actual entry point for `createThread`.
pub fn createThreadRuntime(@"fn": ThreadFunction, name: [:0]const u8, data: ?*anyopaque, pfnBeginThread: ?*const anyopaque, pfnEndThread: ?*const anyopaque) Error!*Thread {
    return SDL_CreateThreadRuntime(@"fn", name.ptr, data, pfnBeginThread, pfnEndThread) orelse makeError();
}
extern fn SDL_CreateThreadRuntime(@"fn": ThreadFunction, name: [*:0]const u8, data: ?*anyopaque, pfnBeginThread: ?*const anyopaque, pfnEndThread: ?*const anyopaque) ?*Thread;

/// The actual entry point for `createThreadWithProperties`.
pub fn createThreadWithPropertiesRuntime(props: sdl.PropertiesId, pfnBeginThread: ?*const anyopaque, pfnEndThread: ?*const anyopaque) Error!*Thread {
    return SDL_CreateThreadWithPropertiesRuntime(props, pfnBeginThread, pfnEndThread) orelse makeError();
}
extern fn SDL_CreateThreadWithPropertiesRuntime(props: sdl.PropertiesId, pfnBeginThread: ?*const anyopaque, pfnEndThread: ?*const anyopaque) ?*Thread;

/// Get the thread name as it was specified in `createThread`.
pub fn getThreadName(thread: *Thread) ?[:0]const u8 {
    const str = SDL_GetThreadName(thread) orelse return null;
    return std.mem.span(str);
}
extern fn SDL_GetThreadName(thread: *Thread) ?[*:0]const u8;

/// Get the thread identifier for the current thread.
///
/// This thread identifier is as reported by the underlying operating system.
/// If SDL is running on a platform that does not support threads the return
/// value will always be zero.
///
/// This function also returns a valid thread ID when called from the main
/// thread.
pub const getCurrentThreadId = SDL_GetCurrentThreadID;
extern fn SDL_GetCurrentThreadID() ThreadId;

/// Get the thread identifier for the specified thread.
///
/// This thread identifier is as reported by the underlying operating system.
/// If SDL is running on a platform that does not support threads the return
/// value will always be zero.
pub const getThreadId = SDL_GetThreadID;
extern fn SDL_GetThreadID(thread: *Thread) ThreadId;

/// Set the priority for the current thread.
///
/// Note that some platforms will not let you alter the priority (or at least,
/// promote the thread to a higher priority) at all, and some require you to be
/// an administrator account. Be prepared for this to fail.
pub fn setCurrentThreadPriority(priority: ThreadPriority) Error!void {
    if (!SDL_SetCurrentThreadPriority(priority)) return makeError();
}
extern fn SDL_SetCurrentThreadPriority(priority: ThreadPriority) bool;

/// Wait for a thread to finish.
///
/// Threads that haven't been detached will remain until this function cleans
/// them up. Not doing so is a resource leak.
///
/// Once a thread has been cleaned up through this function, the `Thread`
/// that references it becomes invalid and should not be referenced again. As
/// such, only one thread may call `waitThread` on another.
///
/// The return code from the thread function is placed in the area pointed to
/// by `status`, if `status` is not null.
///
/// You may not wait on a thread that has been used in a call to
/// `detachThread`. Use either that function or this one, but not both, or
/// behavior is undefined.
///
/// It is safe to pass a null thread to this function; it is a no-op.
///
/// Note that the thread pointer is freed by this function and is not valid
/// afterward.
pub const waitThread = SDL_WaitThread;
extern fn SDL_WaitThread(thread: *Thread, status: ?*c_int) void;

/// Get the current state of a thread.
pub const getThreadState = SDL_GetThreadState;
extern fn SDL_GetThreadState(thread: *Thread) ThreadState;

/// Let a thread clean up on exit without intervention.
///
/// A thread may be "detached" to signify that it should not remain until
/// another thread has called `waitThread` on it. Detaching a thread is
/// useful for long-running threads that nothing needs to synchronize with or
/// further manage. When a detached thread is done, it simply goes away.
///
/// There is no way to recover the return code of a detached thread. If you
/// need this, don't detach the thread and instead use `waitThread`.
///
/// Once a thread is detached, you should usually assume the `Thread` isn't
/// safe to reference again, as it will become invalid immediately upon the
/// detached thread's exit, instead of remaining until someone has called
/// `waitThread` to finally clean it up. As such, don't detach the same
/// thread more than once.
///
/// If a thread has already exited when passed to `detachThread`, it will
/// stop waiting for a call to `waitThread` and clean up immediately. It is
/// not safe to detach a thread that might be used with `waitThread`.
///
/// You may not call `waitThread` on a thread that has been detached. Use
/// either that function or this one, but not both, or behavior is undefined.
///
/// It is safe to pass null to this function; it is a no-op.
pub const detachThread = SDL_DetachThread;
extern fn SDL_DetachThread(thread: *Thread) void;

/// Get the current thread's value associated with a thread local storage ID.
pub const getTLS = SDL_GetTLS;
extern fn SDL_GetTLS(id: *TLSID) ?*anyopaque;

/// The callback used to cleanup data passed to `setTLS`.
///
/// This is called when a thread exits, to allow an app to free any resources.
pub const TLSDestructorCallback = *const fn (value: ?*anyopaque) callconv(.c) void;

/// Set the current thread's value associated with a thread local storage ID.
///
/// If the thread local storage ID is not initialized (the value is 0), a new
/// ID will be created in a thread-safe way, so all calls using a pointer to
/// the same ID will refer to the same local storage.
///
/// Note that replacing a value from a previous call to this function on the
/// same thread does _not_ call the previous value's destructor!
///
/// `destructor` can be null; it is assumed that `value` does not need to be
/// cleaned up if so.
pub fn setTLS(id: *TLSID, value: ?*const anyopaque, destructor: ?TLSDestructorCallback) Error!void {
    if (!SDL_SetTLS(id, value, destructor)) return makeError();
}
extern fn SDL_SetTLS(id: *TLSID, value: ?*const anyopaque, destructor: ?TLSDestructorCallback) bool;

/// Cleanup all TLS data for this thread.
///
/// If you are creating your threads outside of SDL and then calling SDL
/// functions, you should call this function before your thread exits, to
/// properly clean up SDL memory.
pub const cleanupTLS = SDL_CleanupTLS;
extern fn SDL_CleanupTLS() void;
