//! Filesystem Access (SDL_filesystem.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// Get the directory where the application was run from.
///
/// SDL caches the result of this call internally, but the first call to this
/// function is not necessarily fast, so plan accordingly.
///
/// **macOS and iOS Specific Functionality**: If the application is in a ".app"
/// bundle, this function returns the Resource directory (e.g.
/// MyApp.app/Contents/Resources/). This behaviour can be overridden by adding
/// a property to the Info.plist file. Adding a string key with the name
/// SDL_FILESYSTEM_BASE_DIR_TYPE with a supported value will change the
/// behaviour.
///
/// Supported values for the SDL_FILESYSTEM_BASE_DIR_TYPE property (Given an
/// application in /Applications/SDLApp/MyApp.app):
///
/// - `resource`: bundle resource directory (the default). For example:
///   `/Applications/SDLApp/MyApp.app/Contents/Resources`
/// - `bundle`: the Bundle directory. For example:
///   `/Applications/SDLApp/MyApp.app/`
/// - `parent`: the containing directory of the bundle. For example:
///   `/Applications/SDLApp/`
///
/// **Android Specific Functionality**: This function returns "./", which
/// allows filesystem operations to use internal storage and the asset system.
///
/// **Nintendo 3DS Specific Functionality**: This function returns "romfs"
/// directory of the application as it is uncommon to store resources outside
/// the executable. As such it is not a writable directory.
///
/// The returned path is guaranteed to end with a path separator ('\\' on
/// Windows, '/' on most other platforms).
pub fn getBasePath() Error![:0]const u8 {
    const str = SDL_GetBasePath() orelse return makeError();
    return std.mem.span(str);
}
extern fn SDL_GetBasePath() ?[*:0]const u8;

/// Get the user-and-app-specific path where files can be written.
///
/// Get the "pref dir". This is meant to be where users can write personal
/// files (preferences and save games, etc) that are specific to your
/// application. This directory is unique per user, per application.
///
/// This function will decide the appropriate location in the native
/// filesystem, create the directory if necessary, and return a string of the
/// absolute path to the directory in UTF-8 encoding.
///
/// On Windows, the string might look like:
///
/// `C:\\Users\\bob\\AppData\\Roaming\\My Company\\My Program Name\\`
///
/// On Linux, the string might look like:
///
/// `/home/bob/.local/share/My Program Name/`
///
/// On macOS, the string might look like:
///
/// `/Users/bob/Library/Application Support/My Program Name/`
///
/// You should assume the path returned by this function is the only safe place
/// to write files (and that `getBasePath`, while it might be writable, or
/// even the parent of the returned path, isn't where you should be writing
/// things).
///
/// Both the org and app strings may become part of a directory name, so please
/// follow these rules:
///
/// - Try to use the same org string (_including case-sensitivity_) for all
///   your applications that use this function.
/// - Always use a unique app string for each one, and make sure it never
///   changes for an app once you've decided on it.
/// - Unicode characters are legal, as long as they are UTF-8 encoded, but...
/// - ...only use letters, numbers, and spaces. Avoid punctuation like "Game
///   Name 2: Bad Guy's Revenge!" ... "Game Name 2" is sufficient.
///
/// Due to historical mistakes, `org` is allowed to be null or "". In such
/// cases, SDL will omit the org subdirectory, including on platforms where it
/// shouldn't, and including on platforms where this would make your app fail
/// certification for an app store. New apps should definitely specify a real
/// string for `org`.
///
/// The returned path is guaranteed to end with a path separator ('\\' on
/// Windows, '/' on most other platforms).
///
/// The returned value should be freed with `free` when it is no longer needed.
pub fn getPrefPath(org: [:0]const u8, app: [:0]const u8) Error![:0]u8 {
    const str = SDL_GetPrefPath(org.ptr, app.ptr) orelse return makeError();
    return std.mem.span(str);
}
extern fn SDL_GetPrefPath(org: [*:0]const u8, app: [*:0]const u8) ?[*:0]u8;

/// The type of the OS-provided default folder for a specific purpose.
///
/// Note that the Trash folder isn't included here, because trashing files
/// usually involves extra OS-specific functionality to remember the file's
/// original location.
///
/// The folders supported per platform are:
///
/// |             | Windows | macOS/iOS | tvOS | Unix (XDG) | Haiku | Emscripten |
/// | ----------- | ------- | --------- | ---- | ---------- | ----- | ---------- |
/// | HOME        | X       | X         |      | X          | X     | X          |
/// | DESKTOP     | X       | X         |      | X          | X     |            |
/// | DOCUMENTS   | X       | X         |      | X          |       |            |
/// | DOWNLOADS   | Vista+  | X         |      | X          |       |            |
/// | MUSIC       | X       | X         |      | X          |       |            |
/// | PICTURES    | X       | X         |      | X          |       |            |
/// | PUBLICSHARE |         | X         |      | X          |       |            |
/// | SAVEDGAMES  | Vista+  |           |      |            |       |            |
/// | SCREENSHOTS | Vista+  |           |      |            |       |            |
/// | TEMPLATES   | X       | X         |      | X          |       |            |
/// | VIDEOS      | X       | X*        |      | X          |       |            |
///
/// Note that on macOS/iOS, the Videos folder is called "Movies".
pub const Folder = enum(c_int) {
    /// The folder which contains all of the current user's data, preferences, and documents. It usually contains most of the other folders. If a requested folder does not exist, the home folder can be considered a safe fallback to store a user's documents.
    home,
    /// The folder of files that are displayed on the desktop. Note that the existence of a desktop folder does not guarantee that the system does show icons on its desktop; certain GNU/Linux distros with a graphical environment may not have desktop icons.
    desktop,
    /// User document files, possibly application-specific. This is a good place to save a user's projects.
    documents,
    /// Standard folder for user files downloaded from the internet.
    downloads,
    /// Music files that can be played using a standard music player (mp3, ogg...).
    music,
    /// Image files that can be displayed using a standard viewer (png, jpg...).
    pictures,
    /// Files that are meant to be shared with other users on the same computer.
    publicshare,
    /// Save files for games.
    savedgames,
    /// Application screenshots.
    screenshots,
    /// Template files to be used when the user requests the desktop environment to create a new file in a certain folder, such as "New Text File.txt".  Any file in the Templates folder can be used as a starting point for a new file.
    templates,
    /// Video files that can be played using a standard video player (mp4, webm...).
    videos,
    /// Total number of types in this enum, not a folder type by itself.
    count,
};

/// Finds the most suitable user folder for a specific purpose.
///
/// Many OSes provide certain standard folders for certain purposes, such as
/// storing pictures, music or videos for a certain user. This function gives
/// the path for many of those special locations.
///
/// This function is specifically for _user_ folders, which are meant for the
/// user to access and manage. For application-specific folders, meant to hold
/// data for the application to manage, see `getBasePath` and
/// `getPrefPath`.
///
/// The returned path is guaranteed to end with a path separator ('\\' on
/// Windows, '/' on most other platforms).
///
/// If null is returned, the error may be obtained with `getError`.
pub fn getUserFolder(folder: Folder) Error![:0]const u8 {
    const str = SDL_GetUserFolder(folder) orelse return makeError();
    return std.mem.span(str);
}
extern fn SDL_GetUserFolder(folder: Folder) ?[*:0]const u8;

/// Types of filesystem entries.
///
/// Note that there may be other sorts of items on a filesystem: devices, named
/// pipes, etc. They are currently reported as `PathType.other`.
pub const PathType = enum(c_int) {
    /// path does not exist
    none,
    /// a normal file
    file,
    /// a directory
    directory,
    /// something completely different like a device node (not a symlink, those are always followed)
    other,
};

/// Information about a path on the filesystem.
pub const PathInfo = extern struct {
    /// the path type
    type: PathType,
    /// the file size in bytes
    size: u64,
    /// the time when the path was created
    create_time: sdl.Time,
    /// the last time the path was modified
    modify_time: sdl.Time,
    /// the last time the path was read
    access_time: sdl.Time,
};

/// Flags for path matching.
pub const GlobFlags = packed struct(u32) {
    caseinsensitive: bool = false,
    __unused1: u31 = 0,
};

/// Create a directory, and any missing parent directories.
///
/// This reports success if `path` already exists as a directory.
///
/// If parent directories are missing, it will also create them. Note that if
/// this fails, it will not remove any parent directories it already made.
pub fn createDirectory(path: [:0]const u8) Error!void {
    if (!SDL_CreateDirectory(path.ptr)) return makeError();
}
extern fn SDL_CreateDirectory(path: [*:0]const u8) bool;

/// Possible results from an enumeration callback.
pub const EnumerationResult = enum(c_int) {
    /// Value that requests that enumeration continue.
    @"continue",
    /// Value that requests that enumeration stop, successfully.
    success,
    /// Value that requests that enumeration stop, as a failure.
    failure,
};

/// Callback for directory enumeration.
///
/// Enumeration of directory entries will continue until either all entries
/// have been provided to the callback, or the callback has requested a stop
/// through its return value.
///
/// Returning `EnumerationResult.@"continue"` will let enumeration proceed, calling the
/// callback with further entries. `EnumerationResult.success` and `EnumerationResult.failure` will
/// terminate the enumeration early, and dictate the return value of the
/// enumeration function itself.
///
/// `dirname` is guaranteed to end with a path separator ('\\' on Windows, '/'
/// on most other platforms).
pub const EnumerateDirectoryCallback = *const fn (userdata: ?*anyopaque, dirname: [*:0]const u8, fname: [*:0]const u8) callconv(.c) EnumerationResult;

/// Enumerate a directory through a callback function.
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
pub fn enumerateDirectory(path: [:0]const u8, callback: EnumerateDirectoryCallback, userdata: ?*anyopaque) Error!void {
    if (!SDL_EnumerateDirectory(path.ptr, callback, userdata)) return makeError();
}
extern fn SDL_EnumerateDirectory(path: [*:0]const u8, callback: EnumerateDirectoryCallback, userdata: ?*anyopaque) bool;

/// Remove a file or an empty directory.
///
/// Directories that are not empty will fail; this function will not recursely
/// delete directory trees.
pub fn removePath(path: [:0]const u8) Error!void {
    if (!SDL_RemovePath(path.ptr)) return makeError();
}
extern fn SDL_RemovePath(path: [*:0]const u8) bool;

/// Rename a file or directory.
///
/// If the file at `newpath` already exists, it will be replaced.
///
/// Note that this will not copy files across filesystems/drives/volumes, as
/// that is a much more complicated (and possibly time-consuming) operation.
///
/// Which is to say, if this function fails, `copyFile` to a temporary file
/// in the same directory as `newpath`, then `renamePath` from the
/// temporary file to `newpath` and `removePath` on `oldpath` might work
/// for files. Renaming a non-empty directory across filesystems is
/// dramatically more complex, however.
pub fn renamePath(oldpath: [:0]const u8, newpath: [:0]const u8) Error!void {
    if (!SDL_RenamePath(oldpath.ptr, newpath.ptr)) return makeError();
}
extern fn SDL_RenamePath(oldpath: [*:0]const u8, newpath: [*:0]const u8) bool;

/// Copy a file.
///
/// If the file at `newpath` already exists, it will be overwritten with the
/// contents of the file at `oldpath`.
///
/// This function will block until the copy is complete, which might be a
/// significant time for large files on slow disks. On some platforms, the copy
/// can be handed off to the OS itself, but on others SDL might just open both
/// paths, and read from one and write to the other.
///
/// Note that this is not an atomic operation! If something tries to read from
/// `newpath` while the copy is in progress, it will see an incomplete copy of
/// the data, and if the calling thread terminates (or the power goes out)
/// during the copy, `newpath`'s previous contents will be gone, replaced with
/// an incomplete copy of the data. To avoid this risk, it is recommended that
/// the app copy to a temporary file in the same directory as `newpath`, and if
/// the copy is successful, use `renamePath` to replace `newpath` with the
/// temporary file. This will ensure that reads of `newpath` will either see a
/// complete copy of the data, or it will see the pre-copy state of `newpath`.
///
/// This function attempts to synchronize the newly-copied data to disk before
/// returning, if the platform allows it, so that the renaming trick will not
/// have a problem in a system crash or power failure, where the file could be
/// renamed but the contents never made it from the system file cache to the
/// physical disk.
///
/// If the copy fails for any reason, the state of `newpath` is undefined. It
/// might be half a copy, it might be the untouched data of what was already
/// there, or it might be a zero-byte file, etc.
pub fn copyFile(oldpath: [:0]const u8, newpath: [:0]const u8) Error!void {
    if (!SDL_CopyFile(oldpath.ptr, newpath.ptr)) return makeError();
}
extern fn SDL_CopyFile(oldpath: [*:0]const u8, newpath: [*:0]const u8) bool;

/// Get information about a filesystem path.
///
/// Symlinks, on filesystems that support them, are always followed, so you
/// will always get information on what the symlink eventually points to, and
/// not the symlink itself.
pub fn getPathInfo(path: [:0]const u8) Error!PathInfo {
    var info: PathInfo = undefined;
    if (!SDL_GetPathInfo(path.ptr, &info)) return makeError();
    return info;
}
extern fn SDL_GetPathInfo(path: [*:0]const u8, info: ?*PathInfo) bool;

/// Enumerate a directory tree, filtered by pattern, and return a list.
///
/// Files are filtered out if they don't match the string in `pattern`, which
/// may contain wildcard characters `*` (match everything) and `?` (match one
/// character). If pattern is null, no filtering is done and all results are
/// returned. Subdirectories are permitted, and are specified with a path
/// separator of `/`. Wildcard characters `*` and `?` never match a path
/// separator.
///
/// `flags` may be set to `GlobFlags.caseinsensitive` to make the pattern matching
/// case-insensitive.
///
/// The returned array is always null-terminated, for your iterating
/// convenience, but if `count` is non-null, on return it will contain the
/// number of items in the array, not counting the null terminator.
///
/// The returned value should be freed with `free` when it is no longer needed.
pub fn globDirectory(path: [:0]const u8, pattern: ?[:0]const u8, flags: GlobFlags) Error![][*:0]u8 {
    var count: c_int = undefined;
    const ptr = SDL_GlobDirectory(path.ptr, if (pattern) |s| s.ptr else null, flags, &count) orelse return makeError();
    return ptr[0..@intCast(count)];
}
extern fn SDL_GlobDirectory(path: [*:0]const u8, pattern: ?[*:0]const u8, flags: GlobFlags, count: ?*c_int) ?[*][*:0]u8;

/// Get what the system believes is the "current working directory."
///
/// For systems without a concept of a current working directory, this will
/// still attempt to provide something reasonable.
///
/// SDL does not provide a means to _change_ the current working directory; for
/// platforms without this concept, this would cause surprises with file access
/// outside of SDL.
///
/// The returned path is guaranteed to end with a path separator ('\\' on
/// Windows, '/' on most other platforms).
///
/// The returned value should be freed with `free` when it is no longer needed.
pub fn getCurrentDirectory() Error![:0]u8 {
    const str = SDL_GetCurrentDirectory() orelse return makeError();
    return std.mem.span(str);
}
extern fn SDL_GetCurrentDirectory() ?[*:0]u8;
