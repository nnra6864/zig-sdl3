//! Storage Abstraction (SDL_storage.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// Function interface for `Storage`.
///
/// Apps that want to supply a custom implementation of `Storage` will fill
/// in all the functions in this struct, and then pass it to `openStorage` to
/// create a custom `Storage` object.
///
/// It is not usually necessary to do this; SDL provides standard
/// implementations for many things you might expect to do with a `Storage`.
///
/// This structure should be initialized using SDL_INIT_INTERFACE()
pub const StorageInterface = extern struct {
    version: u32,
    close: ?*const fn (userdata: ?*anyopaque) callconv(.c) bool,
    ready: ?*const fn (userdata: ?*anyopaque) callconv(.c) bool,
    enumerate: ?*const fn (userdata: ?*anyopaque, path: ?[*:0]const u8, callback: ?sdl.EnumerateDirectoryCallback, callback_userdata: ?*anyopaque) callconv(.c) bool,
    info: ?*const fn (userdata: ?*anyopaque, path: ?[*:0]const u8, info: ?*sdl.PathInfo) callconv(.c) bool,
    read_file: ?*const fn (userdata: ?*anyopaque, path: ?[*:0]const u8, destination: ?*anyopaque, length: u64) callconv(.c) bool,
    write_file: ?*const fn (userdata: ?*anyopaque, path: ?[*:0]const u8, source: ?*const anyopaque, length: u64) callconv(.c) bool,
    mkdir: ?*const fn (userdata: ?*anyopaque, path: ?[*:0]const u8) callconv(.c) bool,
    remove: ?*const fn (userdata: ?*anyopaque, path: ?[*:0]const u8) callconv(.c) bool,
    rename: ?*const fn (userdata: ?*anyopaque, oldpath: ?[*:0]const u8, newpath: ?[*:0]const u8) callconv(.c) bool,
    copy: ?*const fn (userdata: ?*anyopaque, oldpath: ?[*:0]const u8, newpath: ?[*:0]const u8) callconv(.c) bool,
    space_remaining: ?*const fn (userdata: ?*anyopaque) callconv(.c) u64,
};

/// An abstract interface for filesystem access.
///
/// This is an opaque datatype. One can create this object using standard SDL
/// functions like `openTitleStorage` or `openUserStorage`, etc, or create
/// an object with a custom implementation using `openStorage`.
pub const Storage = opaque {
    pub const openTitle = openTitleStorage;
    pub const openUser = openUserStorage;
    pub const openFile = openFileStorage;
    pub const open = openStorage;
    pub const close = closeStorage;
    pub const ready = storageReady;
    pub const getFileSize = getStorageFileSize;
    pub const readFile = readStorageFile;
    pub const writeFile = writeStorageFile;
    pub const createDirectory = createStorageDirectory;
    pub const enumerateDirectory = enumerateStorageDirectory;
    pub const removePath = removeStoragePath;
    pub const renamePath = renameStoragePath;
    pub const copyFile = copyStorageFile;
    pub const getPathInfo = getStoragePathInfo;
    pub const getSpaceRemaining = getStorageSpaceRemaining;
    pub const globDirectory = globStorageDirectory;
};

/// Opens up a read-only container for the application's filesystem.
///
/// By default, `openTitleStorage` uses the generic storage implementation.
/// When the path override is not provided, the generic implementation will use
/// the output of `getBasePath` as the base path.
pub fn openTitleStorage(override: ?[:0]const u8, props: sdl.PropertiesId) Error!*Storage {
    return SDL_OpenTitleStorage(if (override) |s| s.ptr else null, props) orelse makeError();
}
extern fn SDL_OpenTitleStorage(override: ?[*:0]const u8, props: sdl.PropertiesId) ?*Storage;

/// Opens up a container for a user's unique read/write filesystem.
///
/// While title storage can generally be kept open throughout runtime, user
/// storage should only be opened when the client is ready to read/write files.
/// This allows the backend to properly batch file operations and flush them
/// when the container has been closed; ensuring safe and optimal save I/O.
pub fn openUserStorage(org: [:0]const u8, app: [:0]const u8, props: sdl.PropertiesId) Error!*Storage {
    return SDL_OpenUserStorage(org.ptr, app.ptr, props) orelse makeError();
}
extern fn SDL_OpenUserStorage(org: [*:0]const u8, app: [*:0]const u8, props: sdl.PropertiesId) ?*Storage;

/// Opens up a container for local filesystem storage.
///
/// This is provided for development and tools. Portable applications should
/// use `openTitleStorage` for access to game data and
/// `openUserStorage` for access to user data.
pub fn openFileStorage(path: ?[:0]const u8) Error!*Storage {
    return SDL_OpenFileStorage(if (path) |s| s.ptr else null) orelse makeError();
}
extern fn SDL_OpenFileStorage(path: ?[*:0]const u8) ?*Storage;

/// Opens up a container using a client-provided storage interface.
///
/// Applications do not need to use this function unless they are providing
/// their own `Storage` implementation. If you just need a `Storage`, you
/// should use the built-in implementations in SDL, like `openTitleStorage`
/// or `openUserStorage`.
///
/// This function makes a copy of `iface` and the caller does not need to keep
/// it around after this call.
pub fn openStorage(iface: *const StorageInterface, userdata: ?*anyopaque) Error!*Storage {
    return SDL_OpenStorage(iface, userdata) orelse makeError();
}
extern fn SDL_OpenStorage(iface: *const StorageInterface, userdata: ?*anyopaque) ?*Storage;

/// Closes and frees a storage container.
///
/// Even if the function returns an error, the container data will be freed;
/// the error is only for informational purposes.
pub fn closeStorage(storage: *Storage) Error!void {
    if (!SDL_CloseStorage(storage)) return makeError();
}
extern fn SDL_CloseStorage(storage: *Storage) bool;

/// Checks if the storage container is ready to use.
///
/// This function should be called in regular intervals until it returns true -
/// however, it is not recommended to spinwait on this call, as the backend may
/// depend on a synchronous message loop. You might instead poll this in your
/// game's main loop while processing events and drawing a loading screen.
pub const storageReady = SDL_StorageReady;
extern fn SDL_StorageReady(storage: *Storage) bool;

/// Query the size of a file within a storage container.
pub fn getStorageFileSize(storage: *Storage, path: [:0]const u8) Error!u64 {
    var length: u64 = undefined;
    if (!SDL_GetStorageFileSize(storage, path.ptr, &length)) return makeError();
    return length;
}
extern fn SDL_GetStorageFileSize(storage: *Storage, path: [*:0]const u8, length: *u64) bool;

/// Synchronously read a file from a storage container into a client-provided
/// buffer.
///
/// The value of `length` must match the length of the file exactly; call
/// `getStorageFileSize` to get this value. This behavior may be relaxed in
/// a future release.
pub fn readStorageFile(storage: *Storage, path: [:0]const u8, destination: []u8) Error!void {
    if (!SDL_ReadStorageFile(storage, path.ptr, destination.ptr, destination.len)) return makeError();
}
extern fn SDL_ReadStorageFile(storage: *Storage, path: [*:0]const u8, destination: [*]u8, length: u64) bool;

/// Synchronously write a file from client memory into a storage container.
pub fn writeStorageFile(storage: *Storage, path: [:0]const u8, source: []const u8) Error!void {
    if (!SDL_WriteStorageFile(storage, path.ptr, source.ptr, source.len)) return makeError();
}
extern fn SDL_WriteStorageFile(storage: *Storage, path: [*:0]const u8, source: [*]const u8, length: u64) bool;

/// Create a directory in a writable storage container.
pub fn createStorageDirectory(storage: *Storage, path: [:0]const u8) Error!void {
    if (!SDL_CreateStorageDirectory(storage, path.ptr)) return makeError();
}
extern fn SDL_CreateStorageDirectory(storage: *Storage, path: [*:0]const u8) bool;

/// Enumerate a directory in a storage container through a callback function.
///
/// This function provides every directory entry through an app-provided
/// callback, called once for each directory entry, until all results have been
/// provided or the callback returns either `EnumerationResult.success` or
/// `EnumerationResult.failure`.
///
/// This will return false if there was a system problem in general, or if a
/// callback returns `EnumerationResult.failure`. A successful return means a callback
/// returned `EnumerationResult.success` to halt enumeration, or all directory entries
/// were enumerated.
///
/// If `path` is null, this is treated as a request to enumerate the root of
/// the storage container's tree. An empty string also works for this.
pub fn enumerateStorageDirectory(storage: *Storage, path: ?[:0]const u8, callback: sdl.EnumerateDirectoryCallback, userdata: ?*anyopaque) Error!void {
    if (!SDL_EnumerateStorageDirectory(storage, if (path) |s| s.ptr else null, callback, userdata)) return makeError();
}
extern fn SDL_EnumerateStorageDirectory(storage: *Storage, path: ?[*:0]const u8, callback: sdl.EnumerateDirectoryCallback, userdata: ?*anyopaque) bool;

/// Remove a file or an empty directory in a writable storage container.
pub fn removeStoragePath(storage: *Storage, path: [:0]const u8) Error!void {
    if (!SDL_RemoveStoragePath(storage, path.ptr)) return makeError();
}
extern fn SDL_RemoveStoragePath(storage: *Storage, path: [*:0]const u8) bool;

/// Rename a file or directory in a writable storage container.
pub fn renameStoragePath(storage: *Storage, oldpath: [:0]const u8, newpath: [:0]const u8) Error!void {
    if (!SDL_RenameStoragePath(storage, oldpath.ptr, newpath.ptr)) return makeError();
}
extern fn SDL_RenameStoragePath(storage: *Storage, oldpath: [*:0]const u8, newpath: [*:0]const u8) bool;

/// Copy a file in a writable storage container.
pub fn copyStorageFile(storage: *Storage, oldpath: [:0]const u8, newpath: [:0]const u8) Error!void {
    if (!SDL_CopyStorageFile(storage, oldpath.ptr, newpath.ptr)) return makeError();
}
extern fn SDL_CopyStorageFile(storage: *Storage, oldpath: [*:0]const u8, newpath: [*:0]const u8) bool;

/// Get information about a filesystem path in a storage container.
pub fn getStoragePathInfo(storage: *Storage, path: [:0]const u8) Error!sdl.PathInfo {
    var info: sdl.PathInfo = undefined;
    if (!SDL_GetStoragePathInfo(storage, path.ptr, &info)) return makeError();
    return info;
}
extern fn SDL_GetStoragePathInfo(storage: *Storage, path: [*:0]const u8, info: ?*sdl.PathInfo) bool;

/// Queries the remaining space in a storage container.
pub const getStorageSpaceRemaining = SDL_GetStorageSpaceRemaining;
extern fn SDL_GetStorageSpaceRemaining(storage: *Storage) u64;

/// Enumerate a directory tree, filtered by pattern, and return a list.
///
/// Files are filtered out if they don't match the string in `pattern`, which
/// may contain wildcard characters `*` (match everything) and `?` (match one
/// character). If pattern is null, no filtering is done and all results are
/// returned. Subdirectories are permitted, and are specified with a path
/// separator of '/'. Wildcard characters `*` and `?` never match a path
/// separator.
///
/// `flags` may be set to `GlobFlags.caseinsensitive` to make the pattern matching
/// case-insensitive.
///
/// The returned array is always null-terminated, for your iterating
/// convenience, but if `count` is non-null, on return it will contain the
/// number of items in the array, not counting the null terminator.
///
/// If `path` is null, this is treated as a request to enumerate the root of
/// the storage container's tree. An empty string also works for this.
///
/// The returned value should be freed with `free` when it is no longer needed.
pub fn globStorageDirectory(storage: *Storage, path: ?[:0]const u8, pattern: ?[:0]const u8, flags: sdl.GlobFlags) Error![][*:0]u8 {
    var count: c_int = undefined;
    const ptr = SDL_GlobStorageDirectory(storage, if (path) |s| s.ptr else null, if (pattern) |s| s.ptr else null, flags, &count) orelse return makeError();
    return ptr[0..@intCast(count)];
}
extern fn SDL_GlobStorageDirectory(storage: *Storage, path: ?[*:0]const u8, pattern: ?[*:0]const u8, flags: sdl.GlobFlags, count: ?*c_int) ?[*][*:0]u8;
