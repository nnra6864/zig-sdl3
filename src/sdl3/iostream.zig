//! I/O Streams (SDL_iostream.h)

const std = @import("std");
const builtin = @import("builtin");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// `IOStream` status, set by a read or write operation.
pub const IOStatus = enum(c_int) {
    /// Everything is ready (no errors and not EOF).
    ready,
    /// Read or write I/O error
    @"error",
    /// End of file
    eof,
    /// Non blocking I/O, not ready
    not_ready,
    /// Tried to write a read-only buffer
    readonly,
    /// Tried to read a write-only buffer
    writeonly,
};

/// Possible `whence` values for `IOStream` seeking.
///
/// These map to the same "whence" concept that `fseek` or `lseek` use in the
/// standard C runtime.
pub const IOWhence = enum(c_int) {
    /// Seek from the beginning of data
    set,
    /// Seek relative to current read point
    cur,
    /// Seek relative to the end of data
    end,
};

/// The function pointers that drive an `IOStream`.
///
/// Applications can provide this struct to `openIO` to create their own
/// implementation of `IOStream`. This is not necessarily required, as SDL
/// already offers several common types of I/O streams, via functions like
/// `ioFromFile` and `ioFromMem`.
///
/// This structure should be initialized using SDL_INIT_INTERFACE()
pub const IOStreamInterface = extern struct {
    version: u32,
    /// Return the number of bytes in this `IOStream`
    size: ?*const fn (userdata: ?*anyopaque) callconv(.c) i64,
    /// Seek to `offset` relative to `whence`, one of stdio's whence values:
    /// `IOWhence.set`, `IOWhence.cur`, `IOWhence.end`
    seek: ?*const fn (userdata: ?*anyopaque, offset: i64, whence: IOWhence) callconv(.c) i64,
    /// Read up to `size` bytes from the data stream to the area pointed
    /// at by `ptr`. `size` will always be > 0.
    ///
    /// On an incomplete read, you should set `*status` to a value from the
    /// `IOStatus` enum. You do not have to explicitly set this on
    /// a complete, successful read.
    read: ?*const fn (userdata: ?*anyopaque, ptr: ?*anyopaque, size: usize, status: ?*IOStatus) callconv(.c) usize,
    /// Write exactly `size` bytes from the area pointed at by `ptr`
    /// to data stream. `size` will always be > 0.
    ///
    /// On an incomplete write, you should set `*status` to a value from the
    /// `IOStatus` enum. You do not have to explicitly set this on
    /// a complete, successful write.
    write: ?*const fn (userdata: ?*anyopaque, ptr: ?*const anyopaque, size: usize, status: ?*IOStatus) callconv(.c) usize,
    /// If the stream is buffering, make sure the data is written out.
    ///
    /// On failure, you should set `*status` to a value from the
    /// `IOStatus` enum. You do not have to explicitly set this on
    /// a successful flush.
    flush: ?*const fn (userdata: ?*anyopaque, status: ?*IOStatus) callconv(.c) bool,
    /// Close and free any allocated resources.
    ///
    /// This does not guarantee file writes will sync to physical media; they
    /// can be in the system's file cache, waiting to go to disk.
    ///
    /// The `IOStream` is still destroyed even if this fails, so clean up anything
    /// even if flushing buffers, etc, returns an error.
    close: ?*const fn (userdata: ?*anyopaque) callconv(.c) bool,
};

/// The read/write operation structure.
///
/// This operates as an opaque handle. There are several APIs to create various
/// types of I/O streams, or an app can supply an `IOStreamInterface` to
/// `openIO` to provide their own stream implementation behind this
/// struct's abstract interface.
pub const IOStream = opaque {
    pub const close = closeIO;
    pub const getProperties = getIOProperties;
    pub const getStatus = getIOStatus;
    pub const getSize = getIOSize;
    pub const seek = seekIO;
    pub const tell = tellIO;
    pub const read = readIO;
    pub const write = writeIO;
    pub const print = ioPrintf;
    pub const flush = flushIO;
    pub const loadFile = loadFile_IO;
    pub const saveFile = saveFile_IO;

    pub const Properties = struct {
        pub const windows_handle_pointer = "SDL.iostream.windows.handle";
        pub const stdio_file_pointer = "SDL.iostream.stdio.file";
        pub const file_descriptor_number = "SDL.iostream.file_descriptor";
        pub const android_aasset_pointer = "SDL.iostream.android.aasset";
        pub const memory_pointer = "SDL.iostream.memory.base";
        pub const memory_size_number = "SDL.iostream.memory.size";
        pub const memory_free_func_pointer = "SDL.iostream.memory.free";
        pub const dynamic_memory_pointer = "SDL.iostream.dynamic.memory";
        pub const dynamic_chunksize_number = "SDL.iostream.dynamic.chunksize";
    };
};

/// Use this function to create a new `IOStream` structure for reading from
/// and/or writing to a named file.
///
/// The `mode` string is treated roughly the same as in a call to the C
/// library's fopen(), even if SDL doesn't happen to use fopen() behind the
/// scenes.
///
/// Available `mode` strings:
///
/// - "r": Open a file for reading. The file must exist.
/// - "w": Create an empty file for writing. If a file with the same name
///   already exists its content is erased and the file is treated as a new
///   empty file.
/// - "wx": Create an empty file for writing. If a file with the same name
///   already exists, the call fails.
/// - "a": Append to a file. Writing operations append data at the end of the
///   file. The file is created if it does not exist.
/// - "r+": Open a file for update both reading and writing. The file must
///   exist.
/// - "w+": Create an empty file for both reading and writing. If a file with
///   the same name already exists its content is erased and the file is
///   treated as a new empty file.
/// - "w+x": Create an empty file for both reading and writing. If a file with
///   the same name already exists, the call fails.
/// - "a+": Open a file for reading and appending. All writing operations are
///   performed at the end of the file, protecting the previous content to be
///   overwritten. You can reposition (fseek, rewind) the internal pointer to
///   anywhere in the file for reading, but writing operations will move it
///   back to the end of file. The file is created if it does not exist.
///
/// **NOTE**: In order to open a file as a binary file, a "b" character has to
/// be included in the `mode` string. This additional "b" character can either
/// be appended at the end of the string (thus making the following compound
/// modes: "rb", "wb", "ab", "r+b", "w+b", "a+b") or be inserted between the
/// letter and the "+" sign for the mixed modes ("rb+", "wb+", "ab+").
/// Additional characters may follow the sequence, although they should have no
/// effect. For example, "t" is sometimes appended to make explicit the file is
/// a text file.
///
/// This function supports Unicode filenames, but they must be encoded in UTF-8
/// format, regardless of the underlying operating system.
///
/// In Android, `ioFromFile` can be used to open content:// URIs. As a
/// fallback, `ioFromFile` will transparently open a matching filename in
/// the app's `assets`.
///
/// Closing the `IOStream` will close SDL's internal file handle.
///
/// The following properties may be set at creation time by SDL:
///
/// - `IOStream.Properties.windows_handle_pointer`: a pointer, that can be cast
///   to a win32 `HANDLE`, that this `IOStream` is using to access the
///   filesystem. If the program isn't running on Windows, or SDL used some
///   other method to access the filesystem, this property will not be set.
/// - `IOStream.Properties.stdio_file_pointer`: a pointer, that can be cast to a
///   stdio `FILE *`, that this `IOStream` is using to access the filesystem.
///   If SDL used some other method to access the filesystem, this property
///   will not be set. PLEASE NOTE that if SDL is using a different C runtime
///   than your app, trying to use this pointer will almost certainly result in
///   a crash! This is mostly a problem on Windows; make sure you build SDL and
///   your app with the same compiler and settings to avoid it.
/// - `IOStream.Properties.file_descriptor_number`: a file descriptor that this
///   `IOStream` is using to access the filesystem.
/// - `IOStream.Properties.android_aasset_pointer`: a pointer, that can be cast
///   to an Android NDK `AAsset *`, that this `IOStream` is using to access
///   the filesystem. If SDL used some other method to access the filesystem,
///   this property will not be set.
pub fn ioFromFile(file: [:0]const u8, mode: [:0]const u8) Error!*IOStream {
    return SDL_IOFromFile(file.ptr, mode.ptr) orelse makeError();
}
extern fn SDL_IOFromFile(file: [*:0]const u8, mode: [*:0]const u8) ?*IOStream;

/// Use this function to prepare a read-write memory buffer for use with
/// `IOStream`.
///
/// This function sets up an `IOStream` struct based on a memory area of a
/// certain size, for both read and write access.
///
/// This memory buffer is not copied by the `IOStream`; the pointer you
/// provide must remain valid until you close the stream.
///
/// If you need to make sure the `IOStream` never writes to the memory
/// buffer, you should use `ioFromConstMem` with a read-only buffer of
/// memory instead.
///
/// The following properties will be set at creation time by SDL:
///
/// - `IOStream.Properties.memory_pointer`: this will be the `mem` parameter that
///   was passed to this function.
/// - `IOStream.Properties.memory_size_number`: this will be the `size` parameter
///   that was passed to this function.
///
/// Additionally, the following properties are recognized:
///
/// - `IOStream.Properties.memory_free_func_pointer`: if this property is set to
///   a non-null value it will be interpreted as a function of `FreeFn`
///   type and called with the passed `mem` pointer when closing the stream. By
///   default it is unset, i.e., the memory will not be freed.
pub fn ioFromMem(mem: []u8) Error!*IOStream {
    return SDL_IOFromMem(mem.ptr, mem.len) orelse makeError();
}
extern fn SDL_IOFromMem(mem: [*]u8, size: usize) ?*IOStream;

/// Use this function to prepare a read-only memory buffer for use with
/// `IOStream`.
///
/// This function sets up an `IOStream` struct based on a memory area of a
/// certain size. It assumes the memory area is not writable.
///
/// Attempting to write to this `IOStream` stream will report an error
/// without writing to the memory buffer.
///
/// This memory buffer is not copied by the `IOStream`; the pointer you
/// provide must remain valid until you close the stream.
///
/// If you need to write to a memory buffer, you should use `ioFromMem`
/// with a writable buffer of memory instead.
///
/// The following properties will be set at creation time by SDL:
///
/// - `IOStream.Properties.memory_pointer`: this will be the `mem` parameter that
///   was passed to this function.
/// - `IOStream.Properties.memory_size_number`: this will be the `size` parameter
///   that was passed to this function.
///
/// Additionally, the following properties are recognized:
///
/// - `IOStream.Properties.memory_free_func_pointer`: if this property is set to
///   a non-null value it will be interpreted as a function of `FreeFn`
///   type and called with the passed `mem` pointer when closing the stream. By
///   default it is unset, i.e., the memory will not be freed.
pub fn ioFromConstMem(mem: []const u8) Error!*IOStream {
    return SDL_IOFromConstMem(mem.ptr, mem.len) orelse makeError();
}
extern fn SDL_IOFromConstMem(mem: [*]const u8, size: usize) ?*IOStream;

/// Use this function to create an `IOStream` that is backed by dynamically
/// allocated memory.
///
/// This supports the following properties to provide access to the memory and
/// control over allocations:
///
/// - `IOStream.Properties.dynamic_memory_pointer`: a pointer to the internal
///   memory of the stream. This can be set to null to transfer ownership of
///   the memory to the application, which should free the memory with
///   `free`. If this is done, the next operation on the stream must be
///   `closeIO`.
/// - `IOStream.Properties.dynamic_chunksize_number`: memory will be allocated in
///   multiples of this size, defaulting to 1024.
pub fn ioFromDynamicMem() Error!*IOStream {
    return SDL_IOFromDynamicMem() orelse makeError();
}
extern fn SDL_IOFromDynamicMem() ?*IOStream;

/// Create a custom `IOStream`.
///
/// Applications do not need to use this function unless they are providing
/// their own `IOStream` implementation. If you just need an `IOStream` to
/// read/write a common data source, you should use the built-in
/// implementations in SDL, like `ioFromFile` or `ioFromMem`, etc.
///
/// This function makes a copy of `iface` and the caller does not need to keep
/// it around after this call.
pub fn openIO(iface: *const IOStreamInterface, userdata: ?*anyopaque) Error!*IOStream {
    return SDL_OpenIO(iface, userdata) orelse makeError();
}
extern fn SDL_OpenIO(iface: *const IOStreamInterface, userdata: ?*anyopaque) ?*IOStream;

/// Close and free an allocated `IOStream` structure.
///
/// `closeIO` closes and cleans up the `IOStream` stream. It releases any
/// resources used by the stream and frees the `IOStream` itself. This
/// returns true on success, or false if the stream failed to flush to its
/// output (e.g. to disk).
///
/// Note that if this fails to flush the stream for any reason, this function
/// reports an error, but the `IOStream` is still invalid once this function
/// returns.
///
/// This call flushes any buffered writes to the operating system, but there
/// are no guarantees that those writes have gone to physical media; they might
/// be in the OS's file cache, waiting to go to disk later. If it's absolutely
/// crucial that writes go to disk immediately, so they are definitely stored
/// even if the power fails before the file cache would have caught up, one
/// should call `flushIO` before closing. Note that flushing takes time and
/// makes the system and your app operate less efficiently, so do so sparingly.
pub fn closeIO(context: *IOStream) Error!void {
    if (!SDL_CloseIO(context)) return makeError();
}
extern fn SDL_CloseIO(context: *IOStream) bool;

/// Get the properties associated with an `IOStream`.
pub fn getIOProperties(context: *IOStream) Error!sdl.PropertiesId {
    const result = SDL_GetIOProperties(context);
    if (@backingInt(result) == 0) return makeError();
    return result;
}
extern fn SDL_GetIOProperties(context: *IOStream) sdl.PropertiesId;

/// Query the stream status of an `IOStream`.
///
/// This information can be useful to decide if a short read or write was due
/// to an error, an EOF, or a non-blocking operation that isn't yet ready to
/// complete.
///
/// An `IOStream`'s status is only expected to change after a `readIO` or
/// `writeIO` call; don't expect it to change if you just call this query
/// function in a tight loop.
pub const getIOStatus = SDL_GetIOStatus;
extern fn SDL_GetIOStatus(context: *IOStream) IOStatus;

/// Use this function to get the size of the data stream in an `IOStream`.
pub fn getIOSize(context: *IOStream) Error!i64 {
    const result = SDL_GetIOSize(context);
    if (result < 0) return makeError();
    return result;
}
extern fn SDL_GetIOSize(context: *IOStream) i64;

/// Seek within an `IOStream` data stream.
///
/// This function seeks to byte `offset`, relative to `whence`.
///
/// `whence` may be any of the following values:
///
/// - `IOWhence.set`: seek from the beginning of data
/// - `IOWhence.cur`: seek relative to current read point
/// - `IOWhence.end`: seek relative to the end of data
///
/// If this stream can not seek, it will return -1.
pub fn seekIO(context: *IOStream, offset: i64, whence: IOWhence) Error!i64 {
    const result = SDL_SeekIO(context, offset, whence);
    if (result < 0) return makeError();
    return result;
}
extern fn SDL_SeekIO(context: *IOStream, offset: i64, whence: IOWhence) i64;

/// Determine the current read/write offset in an `IOStream` data stream.
///
/// `tellIO` is actually a wrapper function that calls the `IOStream`'s
/// `seek` method, with an offset of 0 bytes from `IOWhence.cur`, to
/// simplify application development.
pub fn tellIO(context: *IOStream) Error!i64 {
    const result = SDL_TellIO(context);
    if (result < 0) return makeError();
    return result;
}
extern fn SDL_TellIO(context: *IOStream) i64;

/// Read from a data source.
///
/// This function reads up `size` bytes from the data source to the area
/// pointed at by `ptr`. This function may read less bytes than requested.
///
/// This function will return zero when the data stream is completely read, and
/// `getIOStatus` will return `IOStatus.eof`. If zero is returned and
/// the stream is not at EOF, `getIOStatus` will return a different error
/// value and `getError` will offer a human-readable message.
///
/// A request for zero bytes on a valid stream will return zero immediately
/// without accessing the stream, so the stream status (EOF, err, etc) will not
/// change.
///
/// Returns the number of bytes read, or 0 on end of file or other failure;
/// call `getError` for more information.
pub fn readIO(context: *IOStream, buf: []u8) usize {
    return SDL_ReadIO(context, buf.ptr, buf.len);
}
extern fn SDL_ReadIO(context: *IOStream, ptr: [*]u8, size: usize) usize;

/// Write to an `IOStream` data stream.
///
/// This function writes exactly `size` bytes from the area pointed at by `ptr`
/// to the stream. If this fails for any reason, it'll return less than `size`
/// to demonstrate how far the write progressed. On success, it returns `size`.
///
/// On error, this function still attempts to write as much as possible, so it
/// might return a positive value less than the requested write size.
///
/// The caller can use `getIOStatus` to determine if the problem is
/// recoverable, such as a non-blocking write that can simply be retried later,
/// or a fatal error.
///
/// A request for zero bytes on a valid stream will return zero immediately
/// without accessing the stream, so the stream status (EOF, err, etc) will not
/// change.
///
/// Returns the number of bytes written, which will be less than `data.len` on
/// failure; call `getError` for more information.
pub fn writeIO(context: *IOStream, data: []const u8) usize {
    return SDL_WriteIO(context, data.ptr, data.len);
}
extern fn SDL_WriteIO(context: *IOStream, ptr: [*]const u8, size: usize) usize;

/// Print to an `IOStream` data stream.
///
/// This function does formatted printing to the stream.
///
/// The text is formatted with `std.fmt` into a temporary buffer allocated with
/// `malloc`.
pub fn ioPrintf(context: *IOStream, comptime fmt: []const u8, args: anytype) Error!usize {
    const len = std.fmt.count(fmt, args);
    const ptr: [*]u8 = @ptrCast(sdl.malloc(@max(len, 1)) orelse return sdl.outOfMemory());
    defer sdl.free(ptr);
    const text = std.fmt.bufPrint(ptr[0..len], fmt, args) catch unreachable;
    const written = SDL_WriteIO(context, text.ptr, text.len);
    if (written < text.len) return makeError();
    return written;
}

/// Flush any buffered data in the stream.
///
/// This function makes sure that any buffered data is written to the stream.
/// Normally this isn't necessary but if the stream is a pipe or socket it
/// guarantees that any pending data is sent.
pub fn flushIO(context: *IOStream) Error!void {
    if (!SDL_FlushIO(context)) return makeError();
}
extern fn SDL_FlushIO(context: *IOStream) bool;

/// Load all the data from an SDL data stream.
///
/// The data is allocated with a zero byte at the end (null terminated) for
/// convenience. This extra byte is not included in the value reported via
/// `datasize`.
///
/// The data should be freed with `free`.
///
/// The returned data is null terminated and should be freed with `free` when
/// it is no longer needed.
pub fn loadFile_IO(src: *IOStream, closeio: bool) Error![:0]u8 {
    var size: usize = undefined;
    const ptr = SDL_LoadFile_IO(src, &size, closeio) orelse return makeError();
    return ptr[0..size :0];
}
extern fn SDL_LoadFile_IO(src: *IOStream, datasize: ?*usize, closeio: bool) ?[*:0]u8;

/// Load all the data from a file path.
///
/// The data is allocated with a zero byte at the end (null terminated) for
/// convenience. This extra byte is not included in the value reported via
/// `datasize`.
///
/// The data should be freed with `free`.
///
/// The returned data is null terminated and should be freed with `free` when
/// it is no longer needed.
pub fn loadFile(file: [:0]const u8) Error![:0]u8 {
    var size: usize = undefined;
    const ptr = SDL_LoadFile(file.ptr, &size) orelse return makeError();
    return ptr[0..size :0];
}
extern fn SDL_LoadFile(file: [*:0]const u8, datasize: ?*usize) ?[*:0]u8;

/// Save all the data into an SDL data stream.
pub fn saveFile_IO(src: *IOStream, data: []const u8, closeio: bool) Error!void {
    if (!SDL_SaveFile_IO(src, data.ptr, data.len, closeio)) return makeError();
}
extern fn SDL_SaveFile_IO(src: *IOStream, data: [*]const u8, datasize: usize, closeio: bool) bool;

/// Save all the data into a file path.
pub fn saveFile(file: [:0]const u8, data: []const u8) Error!void {
    if (!SDL_SaveFile(file.ptr, data.ptr, data.len)) return makeError();
}
extern fn SDL_SaveFile(file: [*:0]const u8, data: [*]const u8, datasize: usize) bool;

/// Use this function to read a byte from an `IOStream`.
///
/// This function will return false when the data stream is completely read,
/// and `getIOStatus` will return `IOStatus.eof`. If false is returned
/// and the stream is not at EOF, `getIOStatus` will return a different
/// error value and `getError` will offer a human-readable message.
pub fn readU8(src: *IOStream) Error!u8 {
    var value: u8 = undefined;
    if (!SDL_ReadU8(src, &value)) return makeError();
    return value;
}
extern fn SDL_ReadU8(src: *IOStream, value: *u8) bool;

/// Use this function to read a signed byte from an `IOStream`.
///
/// This function will return false when the data stream is completely read,
/// and `getIOStatus` will return `IOStatus.eof`. If false is returned
/// and the stream is not at EOF, `getIOStatus` will return a different
/// error value and `getError` will offer a human-readable message.
pub fn readS8(src: *IOStream) Error!i8 {
    var value: i8 = undefined;
    if (!SDL_ReadS8(src, &value)) return makeError();
    return value;
}
extern fn SDL_ReadS8(src: *IOStream, value: *i8) bool;

/// Use this function to read 16 bits of little-endian data from an
/// `IOStream` and return in native format.
///
/// SDL byteswaps the data only if necessary, so the data returned will be in
/// the native byte order.
///
/// This function will return false when the data stream is completely read,
/// and `getIOStatus` will return `IOStatus.eof`. If false is returned
/// and the stream is not at EOF, `getIOStatus` will return a different
/// error value and `getError` will offer a human-readable message.
pub fn readU16LE(src: *IOStream) Error!u16 {
    var value: u16 = undefined;
    if (!SDL_ReadU16LE(src, &value)) return makeError();
    return value;
}
extern fn SDL_ReadU16LE(src: *IOStream, value: *u16) bool;

/// Use this function to read 16 bits of little-endian data from an
/// `IOStream` and return in native format.
///
/// SDL byteswaps the data only if necessary, so the data returned will be in
/// the native byte order.
///
/// This function will return false when the data stream is completely read,
/// and `getIOStatus` will return `IOStatus.eof`. If false is returned
/// and the stream is not at EOF, `getIOStatus` will return a different
/// error value and `getError` will offer a human-readable message.
pub fn readS16LE(src: *IOStream) Error!i16 {
    var value: i16 = undefined;
    if (!SDL_ReadS16LE(src, &value)) return makeError();
    return value;
}
extern fn SDL_ReadS16LE(src: *IOStream, value: *i16) bool;

/// Use this function to read 16 bits of big-endian data from an `IOStream`
/// and return in native format.
///
/// SDL byteswaps the data only if necessary, so the data returned will be in
/// the native byte order.
///
/// This function will return false when the data stream is completely read,
/// and `getIOStatus` will return `IOStatus.eof`. If false is returned
/// and the stream is not at EOF, `getIOStatus` will return a different
/// error value and `getError` will offer a human-readable message.
pub fn readU16BE(src: *IOStream) Error!u16 {
    var value: u16 = undefined;
    if (!SDL_ReadU16BE(src, &value)) return makeError();
    return value;
}
extern fn SDL_ReadU16BE(src: *IOStream, value: *u16) bool;

/// Use this function to read 16 bits of big-endian data from an `IOStream`
/// and return in native format.
///
/// SDL byteswaps the data only if necessary, so the data returned will be in
/// the native byte order.
///
/// This function will return false when the data stream is completely read,
/// and `getIOStatus` will return `IOStatus.eof`. If false is returned
/// and the stream is not at EOF, `getIOStatus` will return a different
/// error value and `getError` will offer a human-readable message.
pub fn readS16BE(src: *IOStream) Error!i16 {
    var value: i16 = undefined;
    if (!SDL_ReadS16BE(src, &value)) return makeError();
    return value;
}
extern fn SDL_ReadS16BE(src: *IOStream, value: *i16) bool;

/// Use this function to read 32 bits of little-endian data from an
/// `IOStream` and return in native format.
///
/// SDL byteswaps the data only if necessary, so the data returned will be in
/// the native byte order.
///
/// This function will return false when the data stream is completely read,
/// and `getIOStatus` will return `IOStatus.eof`. If false is returned
/// and the stream is not at EOF, `getIOStatus` will return a different
/// error value and `getError` will offer a human-readable message.
pub fn readU32LE(src: *IOStream) Error!u32 {
    var value: u32 = undefined;
    if (!SDL_ReadU32LE(src, &value)) return makeError();
    return value;
}
extern fn SDL_ReadU32LE(src: *IOStream, value: *u32) bool;

/// Use this function to read 32 bits of little-endian data from an
/// `IOStream` and return in native format.
///
/// SDL byteswaps the data only if necessary, so the data returned will be in
/// the native byte order.
///
/// This function will return false when the data stream is completely read,
/// and `getIOStatus` will return `IOStatus.eof`. If false is returned
/// and the stream is not at EOF, `getIOStatus` will return a different
/// error value and `getError` will offer a human-readable message.
pub fn readS32LE(src: *IOStream) Error!i32 {
    var value: i32 = undefined;
    if (!SDL_ReadS32LE(src, &value)) return makeError();
    return value;
}
extern fn SDL_ReadS32LE(src: *IOStream, value: *i32) bool;

/// Use this function to read 32 bits of big-endian data from an `IOStream`
/// and return in native format.
///
/// SDL byteswaps the data only if necessary, so the data returned will be in
/// the native byte order.
///
/// This function will return false when the data stream is completely read,
/// and `getIOStatus` will return `IOStatus.eof`. If false is returned
/// and the stream is not at EOF, `getIOStatus` will return a different
/// error value and `getError` will offer a human-readable message.
pub fn readU32BE(src: *IOStream) Error!u32 {
    var value: u32 = undefined;
    if (!SDL_ReadU32BE(src, &value)) return makeError();
    return value;
}
extern fn SDL_ReadU32BE(src: *IOStream, value: *u32) bool;

/// Use this function to read 32 bits of big-endian data from an `IOStream`
/// and return in native format.
///
/// SDL byteswaps the data only if necessary, so the data returned will be in
/// the native byte order.
///
/// This function will return false when the data stream is completely read,
/// and `getIOStatus` will return `IOStatus.eof`. If false is returned
/// and the stream is not at EOF, `getIOStatus` will return a different
/// error value and `getError` will offer a human-readable message.
pub fn readS32BE(src: *IOStream) Error!i32 {
    var value: i32 = undefined;
    if (!SDL_ReadS32BE(src, &value)) return makeError();
    return value;
}
extern fn SDL_ReadS32BE(src: *IOStream, value: *i32) bool;

/// Use this function to read 64 bits of little-endian data from an
/// `IOStream` and return in native format.
///
/// SDL byteswaps the data only if necessary, so the data returned will be in
/// the native byte order.
///
/// This function will return false when the data stream is completely read,
/// and `getIOStatus` will return `IOStatus.eof`. If false is returned
/// and the stream is not at EOF, `getIOStatus` will return a different
/// error value and `getError` will offer a human-readable message.
pub fn readU64LE(src: *IOStream) Error!u64 {
    var value: u64 = undefined;
    if (!SDL_ReadU64LE(src, &value)) return makeError();
    return value;
}
extern fn SDL_ReadU64LE(src: *IOStream, value: *u64) bool;

/// Use this function to read 64 bits of little-endian data from an
/// `IOStream` and return in native format.
///
/// SDL byteswaps the data only if necessary, so the data returned will be in
/// the native byte order.
///
/// This function will return false when the data stream is completely read,
/// and `getIOStatus` will return `IOStatus.eof`. If false is returned
/// and the stream is not at EOF, `getIOStatus` will return a different
/// error value and `getError` will offer a human-readable message.
pub fn readS64LE(src: *IOStream) Error!i64 {
    var value: i64 = undefined;
    if (!SDL_ReadS64LE(src, &value)) return makeError();
    return value;
}
extern fn SDL_ReadS64LE(src: *IOStream, value: *i64) bool;

/// Use this function to read 64 bits of big-endian data from an `IOStream`
/// and return in native format.
///
/// SDL byteswaps the data only if necessary, so the data returned will be in
/// the native byte order.
///
/// This function will return false when the data stream is completely read,
/// and `getIOStatus` will return `IOStatus.eof`. If false is returned
/// and the stream is not at EOF, `getIOStatus` will return a different
/// error value and `getError` will offer a human-readable message.
pub fn readU64BE(src: *IOStream) Error!u64 {
    var value: u64 = undefined;
    if (!SDL_ReadU64BE(src, &value)) return makeError();
    return value;
}
extern fn SDL_ReadU64BE(src: *IOStream, value: *u64) bool;

/// Use this function to read 64 bits of big-endian data from an `IOStream`
/// and return in native format.
///
/// SDL byteswaps the data only if necessary, so the data returned will be in
/// the native byte order.
///
/// This function will return false when the data stream is completely read,
/// and `getIOStatus` will return `IOStatus.eof`. If false is returned
/// and the stream is not at EOF, `getIOStatus` will return a different
/// error value and `getError` will offer a human-readable message.
pub fn readS64BE(src: *IOStream) Error!i64 {
    var value: i64 = undefined;
    if (!SDL_ReadS64BE(src, &value)) return makeError();
    return value;
}
extern fn SDL_ReadS64BE(src: *IOStream, value: *i64) bool;

/// Use this function to write a byte to an `IOStream`.
pub fn writeU8(dst: *IOStream, value: u8) Error!void {
    if (!SDL_WriteU8(dst, value)) return makeError();
}
extern fn SDL_WriteU8(dst: *IOStream, value: u8) bool;

/// Use this function to write a signed byte to an `IOStream`.
pub fn writeS8(dst: *IOStream, value: i8) Error!void {
    if (!SDL_WriteS8(dst, value)) return makeError();
}
extern fn SDL_WriteS8(dst: *IOStream, value: i8) bool;

/// Use this function to write 16 bits in native format to an `IOStream` as
/// little-endian data.
///
/// SDL byteswaps the data only if necessary, so the application always
/// specifies native format, and the data written will be in little-endian
/// format.
pub fn writeU16LE(dst: *IOStream, value: u16) Error!void {
    if (!SDL_WriteU16LE(dst, value)) return makeError();
}
extern fn SDL_WriteU16LE(dst: *IOStream, value: u16) bool;

/// Use this function to write 16 bits in native format to an `IOStream` as
/// little-endian data.
///
/// SDL byteswaps the data only if necessary, so the application always
/// specifies native format, and the data written will be in little-endian
/// format.
pub fn writeS16LE(dst: *IOStream, value: i16) Error!void {
    if (!SDL_WriteS16LE(dst, value)) return makeError();
}
extern fn SDL_WriteS16LE(dst: *IOStream, value: i16) bool;

/// Use this function to write 16 bits in native format to an `IOStream` as
/// big-endian data.
///
/// SDL byteswaps the data only if necessary, so the application always
/// specifies native format, and the data written will be in big-endian format.
pub fn writeU16BE(dst: *IOStream, value: u16) Error!void {
    if (!SDL_WriteU16BE(dst, value)) return makeError();
}
extern fn SDL_WriteU16BE(dst: *IOStream, value: u16) bool;

/// Use this function to write 16 bits in native format to an `IOStream` as
/// big-endian data.
///
/// SDL byteswaps the data only if necessary, so the application always
/// specifies native format, and the data written will be in big-endian format.
pub fn writeS16BE(dst: *IOStream, value: i16) Error!void {
    if (!SDL_WriteS16BE(dst, value)) return makeError();
}
extern fn SDL_WriteS16BE(dst: *IOStream, value: i16) bool;

/// Use this function to write 32 bits in native format to an `IOStream` as
/// little-endian data.
///
/// SDL byteswaps the data only if necessary, so the application always
/// specifies native format, and the data written will be in little-endian
/// format.
pub fn writeU32LE(dst: *IOStream, value: u32) Error!void {
    if (!SDL_WriteU32LE(dst, value)) return makeError();
}
extern fn SDL_WriteU32LE(dst: *IOStream, value: u32) bool;

/// Use this function to write 32 bits in native format to an `IOStream` as
/// little-endian data.
///
/// SDL byteswaps the data only if necessary, so the application always
/// specifies native format, and the data written will be in little-endian
/// format.
pub fn writeS32LE(dst: *IOStream, value: i32) Error!void {
    if (!SDL_WriteS32LE(dst, value)) return makeError();
}
extern fn SDL_WriteS32LE(dst: *IOStream, value: i32) bool;

/// Use this function to write 32 bits in native format to an `IOStream` as
/// big-endian data.
///
/// SDL byteswaps the data only if necessary, so the application always
/// specifies native format, and the data written will be in big-endian format.
pub fn writeU32BE(dst: *IOStream, value: u32) Error!void {
    if (!SDL_WriteU32BE(dst, value)) return makeError();
}
extern fn SDL_WriteU32BE(dst: *IOStream, value: u32) bool;

/// Use this function to write 32 bits in native format to an `IOStream` as
/// big-endian data.
///
/// SDL byteswaps the data only if necessary, so the application always
/// specifies native format, and the data written will be in big-endian format.
pub fn writeS32BE(dst: *IOStream, value: i32) Error!void {
    if (!SDL_WriteS32BE(dst, value)) return makeError();
}
extern fn SDL_WriteS32BE(dst: *IOStream, value: i32) bool;

/// Use this function to write 64 bits in native format to an `IOStream` as
/// little-endian data.
///
/// SDL byteswaps the data only if necessary, so the application always
/// specifies native format, and the data written will be in little-endian
/// format.
pub fn writeU64LE(dst: *IOStream, value: u64) Error!void {
    if (!SDL_WriteU64LE(dst, value)) return makeError();
}
extern fn SDL_WriteU64LE(dst: *IOStream, value: u64) bool;

/// Use this function to write 64 bits in native format to an `IOStream` as
/// little-endian data.
///
/// SDL byteswaps the data only if necessary, so the application always
/// specifies native format, and the data written will be in little-endian
/// format.
pub fn writeS64LE(dst: *IOStream, value: i64) Error!void {
    if (!SDL_WriteS64LE(dst, value)) return makeError();
}
extern fn SDL_WriteS64LE(dst: *IOStream, value: i64) bool;

/// Use this function to write 64 bits in native format to an `IOStream` as
/// big-endian data.
///
/// SDL byteswaps the data only if necessary, so the application always
/// specifies native format, and the data written will be in big-endian format.
pub fn writeU64BE(dst: *IOStream, value: u64) Error!void {
    if (!SDL_WriteU64BE(dst, value)) return makeError();
}
extern fn SDL_WriteU64BE(dst: *IOStream, value: u64) bool;

/// Use this function to write 64 bits in native format to an `IOStream` as
/// big-endian data.
///
/// SDL byteswaps the data only if necessary, so the application always
/// specifies native format, and the data written will be in big-endian format.
pub fn writeS64BE(dst: *IOStream, value: i64) Error!void {
    if (!SDL_WriteS64BE(dst, value)) return makeError();
}
extern fn SDL_WriteS64BE(dst: *IOStream, value: i64) bool;

test "ioPrintf and memory streams" {
    const stream = try ioFromDynamicMem();
    defer closeIO(stream) catch {};

    try std.testing.expectEqual(12, try ioPrintf(stream, "{s}, {d}!", .{ "hello", 1234 }));
    try writeU16LE(stream, 0xBEEF);
    _ = try seekIO(stream, 0, .set);

    var buf: [12]u8 = undefined;
    try std.testing.expectEqual(12, readIO(stream, &buf));
    try std.testing.expectEqualStrings("hello, 1234!", &buf);
    try std.testing.expectEqual(0xBEEF, try readU16LE(stream));
}
