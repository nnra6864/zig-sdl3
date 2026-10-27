//! Async I/O (SDL_asyncio.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// The asynchronous I/O operation structure.
///
/// This operates as an opaque handle. One can then request read or write
/// operations on it.
pub const AsyncIO = opaque {
    pub const fromFile = asyncIOFromFile;
    pub const getSize = getAsyncIOSize;
    pub const read = readAsyncIO;
    pub const write = writeAsyncIO;
    pub const close = closeAsyncIO;
};

/// Types of asynchronous I/O tasks.
pub const AsyncIOTaskType = enum(c_int) {
    /// A read operation.
    read,
    /// A write operation.
    write,
    /// A close operation.
    close,
};

/// Possible outcomes of an asynchronous I/O task.
pub const AsyncIOResult = enum(c_int) {
    /// request was completed without error
    complete,
    /// request failed for some reason; check `getError`!
    failure,
    /// request was canceled before completing.
    canceled,
};

/// Information about a completed asynchronous I/O request.
pub const AsyncIOOutcome = extern struct {
    /// what generated this task. This pointer will be invalid if it was closed!
    asyncio: ?*AsyncIO,
    /// What sort of task was this? Read, write, etc?
    type: AsyncIOTaskType,
    /// the result of the work (success, failure, cancellation).
    result: AsyncIOResult,
    /// buffer where data was read/written.
    buffer: ?*anyopaque,
    /// offset in the `AsyncIO` where data was read/written.
    offset: u64,
    /// number of bytes the task was to read/write.
    bytes_requested: u64,
    /// actual number of bytes that were read/written.
    bytes_transferred: u64,
    /// pointer provided by the app when starting the task
    userdata: ?*anyopaque,
};

/// A queue of completed asynchronous I/O tasks.
///
/// When starting an asynchronous operation, you specify a queue for the new
/// task. A queue can be asked later if any tasks in it have completed,
/// allowing an app to manage multiple pending tasks in one place, in whatever
/// order they complete.
pub const AsyncIOQueue = opaque {
    pub const create = createAsyncIOQueue;
    pub const destroy = destroyAsyncIOQueue;
    pub const signal = signalAsyncIOQueue;
};

/// Use this function to create a new `AsyncIO` object for reading from
/// and/or writing to a named file.
///
/// The `mode` string understands the following values:
///
/// - "r": Open a file for reading only. It must exist.
/// - "w": Open a file for writing only. It will create missing files or
///   truncate existing ones.
/// - "r+": Open a file for update both reading and writing. The file must
///   exist.
/// - "w+": Create an empty file for both reading and writing. If a file with
///   the same name already exists its content is erased and the file is
///   treated as a new empty file.
///
/// There is no "b" mode, as there is only "binary" style I/O, and no "a" mode
/// for appending, since you specify the position when starting a task.
///
/// This function supports Unicode filenames, but they must be encoded in UTF-8
/// format, regardless of the underlying operating system.
///
/// This call is _not_ asynchronous; it will open the file before returning,
/// under the assumption that doing so is generally a fast operation. Future
/// reads and writes to the opened file will be async, however.
pub fn asyncIOFromFile(file: [:0]const u8, mode: [:0]const u8) Error!*AsyncIO {
    return SDL_AsyncIOFromFile(file.ptr, mode.ptr) orelse makeError();
}
extern fn SDL_AsyncIOFromFile(file: [*:0]const u8, mode: [*:0]const u8) ?*AsyncIO;

/// Use this function to get the size of the data stream in an `AsyncIO`.
///
/// This call is _not_ asynchronous; it assumes that obtaining this info is a
/// non-blocking operation in most reasonable cases.
pub fn getAsyncIOSize(asyncio: *AsyncIO) Error!i64 {
    const result = SDL_GetAsyncIOSize(asyncio);
    if (result < 0) return makeError();
    return result;
}
extern fn SDL_GetAsyncIOSize(asyncio: *AsyncIO) i64;

/// Start an async read.
///
/// This function reads up to `size` bytes from `offset` position in the data
/// source to the area pointed at by `ptr`. This function may read less bytes
/// than requested.
///
/// This function returns as quickly as possible; it does not wait for the read
/// to complete. On a successful return, this work will continue in the
/// background. If the work begins, even failure is asynchronous: a failing
/// return value from this function only means the work couldn't start at all.
///
/// `ptr` must remain available until the work is done, and may be accessed by
/// the system at any time until then. Do not allocate it on the stack, as this
/// might take longer than the life of the calling function to complete!
///
/// An `AsyncIOQueue` must be specified. The newly-created task will be added
/// to it when it completes its work.
pub fn readAsyncIO(asyncio: *AsyncIO, buf: []u8, offset: u64, queue: *AsyncIOQueue, userdata: ?*anyopaque) Error!void {
    if (!SDL_ReadAsyncIO(asyncio, buf.ptr, offset, buf.len, queue, userdata)) return makeError();
}
extern fn SDL_ReadAsyncIO(asyncio: *AsyncIO, ptr: [*]u8, offset: u64, size: u64, queue: *AsyncIOQueue, userdata: ?*anyopaque) bool;

/// Start an async write.
///
/// This function writes `size` bytes from `offset` position in the data source
/// to the area pointed at by `ptr`.
///
/// This function returns as quickly as possible; it does not wait for the
/// write to complete. On a successful return, this work will continue in the
/// background. If the work begins, even failure is asynchronous: a failing
/// return value from this function only means the work couldn't start at all.
///
/// `ptr` must remain available until the work is done, and may be accessed by
/// the system at any time until then. Do not allocate it on the stack, as this
/// might take longer than the life of the calling function to complete!
///
/// An `AsyncIOQueue` must be specified. The newly-created task will be added
/// to it when it completes its work.
pub fn writeAsyncIO(asyncio: *AsyncIO, data: []const u8, offset: u64, queue: *AsyncIOQueue, userdata: ?*anyopaque) Error!void {
    if (!SDL_WriteAsyncIO(asyncio, data.ptr, offset, data.len, queue, userdata)) return makeError();
}
extern fn SDL_WriteAsyncIO(asyncio: *AsyncIO, ptr: [*]const u8, offset: u64, size: u64, queue: *AsyncIOQueue, userdata: ?*anyopaque) bool;

/// Close and free any allocated resources for an async I/O object.
///
/// Closing a file is _also_ an asynchronous task! If a write failure were to
/// happen during the closing process, for example, the task results will
/// report it as usual.
///
/// Closing a file that has been written to does not guarantee the data has
/// made it to physical media; it may remain in the operating system's file
/// cache, for later writing to disk. This means that a successfully-closed
/// file can be lost if the system crashes or loses power in this small window.
/// To prevent this, call this function with the `flush` parameter set to true.
/// This will make the operation take longer, and perhaps increase system load
/// in general, but a successful result guarantees that the data has made it to
/// physical storage. Don't use this for temporary files, caches, and
/// unimportant data, and definitely use it for crucial irreplaceable files,
/// like game saves.
///
/// This function guarantees that the close will happen after any other pending
/// tasks to `asyncio`, so it's safe to open a file, start several operations,
/// close the file immediately, then check for all results later. This function
/// will not block until the tasks have completed.
///
/// Once this function returns true, `asyncio` is no longer valid, regardless
/// of any future outcomes. Any completed tasks might still contain this
/// pointer in their `AsyncIOOutcome` data, in case the app was using this
/// value to track information, but it should not be used again.
///
/// If this function returns false, the close wasn't started at all, and it's
/// safe to attempt to close again later.
///
/// An `AsyncIOQueue` must be specified. The newly-created task will be added
/// to it when it completes its work.
pub fn closeAsyncIO(asyncio: *AsyncIO, flush: bool, queue: *AsyncIOQueue, userdata: ?*anyopaque) Error!void {
    if (!SDL_CloseAsyncIO(asyncio, flush, queue, userdata)) return makeError();
}
extern fn SDL_CloseAsyncIO(asyncio: *AsyncIO, flush: bool, queue: *AsyncIOQueue, userdata: ?*anyopaque) bool;

/// Create a task queue for tracking multiple I/O operations.
///
/// Async I/O operations are assigned to a queue when started. The queue can be
/// checked for completed tasks thereafter.
pub fn createAsyncIOQueue() Error!*AsyncIOQueue {
    return SDL_CreateAsyncIOQueue() orelse makeError();
}
extern fn SDL_CreateAsyncIOQueue() ?*AsyncIOQueue;

/// Destroy a previously-created async I/O task queue.
///
/// If there are still tasks pending for this queue, this call will block until
/// those tasks are finished. All those tasks will be deallocated. Their
/// results will be lost to the app.
///
/// Any pending reads from `loadFileAsync` that are still in this queue
/// will have their buffers deallocated by this function, to prevent a memory
/// leak.
///
/// Once this function is called, the queue is no longer valid and should not
/// be used, including by other threads that might access it while destruction
/// is blocking on pending tasks.
///
/// Do not destroy a queue that still has threads waiting on it through
/// `waitAsyncIOResult`. You can call `signalAsyncIOQueue` first to
/// unblock those threads, and take measures (such as `waitThread`) to make
/// sure they have finished their wait and won't wait on the queue again.
pub const destroyAsyncIOQueue = SDL_DestroyAsyncIOQueue;
extern fn SDL_DestroyAsyncIOQueue(queue: *AsyncIOQueue) void;

/// Query an async I/O task queue for completed tasks.
///
/// If a task assigned to this queue has finished, this will return true and
/// fill in `outcome` with the details of the task. If no task in the queue has
/// finished, this function will return false. This function does not block.
///
/// If a task has completed, this function will free its resources and the task
/// pointer will no longer be valid. The task will be removed from the queue.
///
/// It is safe for multiple threads to call this function on the same queue at
/// once; a completed task will only go to one of the threads.
///
/// Returns null if no task has completed yet.
pub fn getAsyncIOResult(queue: *AsyncIOQueue) ?AsyncIOOutcome {
    var outcome: AsyncIOOutcome = undefined;
    if (!SDL_GetAsyncIOResult(queue, &outcome)) return null;
    return outcome;
}
extern fn SDL_GetAsyncIOResult(queue: *AsyncIOQueue, outcome: ?*AsyncIOOutcome) bool;

/// Block until an async I/O task queue has a completed task.
///
/// This function puts the calling thread to sleep until there a task assigned
/// to the queue that has finished.
///
/// If a task assigned to the queue has finished, this will return true and
/// fill in `outcome` with the details of the task. If no task in the queue has
/// finished, this function will return false.
///
/// If a task has completed, this function will free its resources and the task
/// pointer will no longer be valid. The task will be removed from the queue.
///
/// It is safe for multiple threads to call this function on the same queue at
/// once; a completed task will only go to one of the threads.
///
/// Note that by the nature of various platforms, more than one waiting thread
/// may wake to handle a single task, but only one will obtain it, so
/// `timeoutMS` is a _maximum_ wait time, and this function may return false
/// sooner.
///
/// This function may return false if there was a system error, the OS
/// inadvertently awoke multiple threads, or if `signalAsyncIOQueue` was
/// called to wake up all waiting threads without a finished task.
///
/// A timeout can be used to specify a maximum wait time, but rather than
/// polling, it is possible to have a timeout of -1 to wait forever, and use
/// `signalAsyncIOQueue` to wake up the waiting threads later.
///
/// Returns null if no task completed before the timeout (or the queue was
/// signaled).
pub fn waitAsyncIOResult(queue: *AsyncIOQueue, timeoutMS: i32) ?AsyncIOOutcome {
    var outcome: AsyncIOOutcome = undefined;
    if (!SDL_WaitAsyncIOResult(queue, &outcome, timeoutMS)) return null;
    return outcome;
}
extern fn SDL_WaitAsyncIOResult(queue: *AsyncIOQueue, outcome: ?*AsyncIOOutcome, timeoutMS: i32) bool;

/// Wake up any threads that are blocking in `waitAsyncIOResult`.
///
/// This will unblock any threads that are sleeping in a call to
/// `waitAsyncIOResult` for the specified queue, and cause them to return
/// from that function.
///
/// This can be useful when destroying a queue to make sure nothing is touching
/// it indefinitely. In this case, once this call completes, the caller should
/// take measures to make sure any previously-blocked threads have returned
/// from their wait and will not touch the queue again (perhaps by setting a
/// flag to tell the threads to terminate and then using `waitThread` to
/// make sure they've done so).
pub const signalAsyncIOQueue = SDL_SignalAsyncIOQueue;
extern fn SDL_SignalAsyncIOQueue(queue: *AsyncIOQueue) void;

/// Load all the data from a file path, asynchronously.
///
/// This function returns as quickly as possible; it does not wait for the read
/// to complete. On a successful return, this work will continue in the
/// background. If the work begins, even failure is asynchronous: a failing
/// return value from this function only means the work couldn't start at all.
///
/// The data is allocated with a zero byte at the end (null terminated) for
/// convenience. This extra byte is not included in `AsyncIOOutcome`'s
/// bytes_transferred value.
///
/// This function will allocate the buffer to contain the file. It must be
/// deallocated by calling `free` on `AsyncIOOutcome`'s buffer field
/// after completion.
///
/// An `AsyncIOQueue` must be specified. The newly-created task will be added
/// to it when it completes its work.
pub fn loadFileAsync(file: [:0]const u8, queue: *AsyncIOQueue, userdata: ?*anyopaque) Error!void {
    if (!SDL_LoadFileAsync(file.ptr, queue, userdata)) return makeError();
}
extern fn SDL_LoadFileAsync(file: [*:0]const u8, queue: *AsyncIOQueue, userdata: ?*anyopaque) bool;
