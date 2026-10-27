//! File Dialogs (SDL_dialog.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");

/// An entry for filters for file dialogs.
///
/// `name` is a user-readable label for the filter (for example, "Office
/// document").
///
/// `pattern` is a semicolon-separated list of file extensions (for example,
/// "doc;docx"). File extensions may only contain alphanumeric characters,
/// hyphens, underscores and periods. Alternatively, the whole string can be a
/// single asterisk ("*"), which serves as an "All files" filter.
pub const DialogFileFilter = extern struct {
    name: ?[*:0]const u8,
    pattern: ?[*:0]const u8,
};

/// Callback used by file dialog functions.
///
/// The specific usage is described in each function.
///
/// If `filelist` is:
///
/// - null, an error occurred. Details can be obtained with `getError`.
/// - A pointer to null, the user either didn't choose any file or canceled the
///   dialog.
/// - A pointer to non-`null`, the user chose one or more files. The argument
///   is a null-terminated array of pointers to UTF-8 encoded strings, each
///   containing a path.
///
/// The filelist argument should not be freed; it will automatically be freed
/// when the callback returns.
///
/// The filter argument is the index of the filter that was selected, or -1 if
/// no filter was selected or if the platform or method doesn't support
/// fetching the selected filter.
///
/// In Android, the `filelist` are `content://` URIs. They should be opened
/// using `ioFromFile` with appropriate modes. This applies both to open
/// and save file dialog.
pub const DialogFileCallback = *const fn (userdata: ?*anyopaque, filelist: ?[*:null]const ?[*:0]const u8, filter: c_int) callconv(.c) void;

/// Displays a dialog that lets the user select a file on their filesystem.
///
/// This is an asynchronous function; it will return immediately, and the
/// result will be passed to the callback.
///
/// The callback will be invoked with a null-terminated list of files the user
/// chose. The list will be empty if the user canceled the dialog, and it will
/// be null if an error occurred.
///
/// Note that the callback may be called from a different thread than the one
/// the function was invoked on.
///
/// Depending on the platform, the user may be allowed to input paths that
/// don't yet exist.
///
/// On Linux, dialogs may require XDG Portals, which requires DBus, which
/// requires an event-handling loop. Apps that do not use SDL to handle events
/// should add a call to `pumpEvents` in their main loop.
pub fn showOpenFileDialog(callback: DialogFileCallback, userdata: ?*anyopaque, window: ?*sdl.Window, filters: []const DialogFileFilter, default_location: ?[:0]const u8, allow_many: bool) void {
    SDL_ShowOpenFileDialog(callback, userdata, window, filters.ptr, @intCast(filters.len), if (default_location) |s| s.ptr else null, allow_many);
}
extern fn SDL_ShowOpenFileDialog(callback: DialogFileCallback, userdata: ?*anyopaque, window: ?*sdl.Window, filters: [*]const DialogFileFilter, nfilters: c_int, default_location: ?[*:0]const u8, allow_many: bool) void;

/// Displays a dialog that lets the user choose a new or existing file on their
/// filesystem.
///
/// This is an asynchronous function; it will return immediately, and the
/// result will be passed to the callback.
///
/// The callback will be invoked with a null-terminated list of files the user
/// chose. The list will be empty if the user canceled the dialog, and it will
/// be null if an error occurred.
///
/// Note that the callback may be called from a different thread than the one
/// the function was invoked on.
///
/// The chosen file may or may not already exist.
///
/// On Linux, dialogs may require XDG Portals, which requires DBus, which
/// requires an event-handling loop. Apps that do not use SDL to handle events
/// should add a call to `pumpEvents` in their main loop.
pub fn showSaveFileDialog(callback: DialogFileCallback, userdata: ?*anyopaque, window: ?*sdl.Window, filters: []const DialogFileFilter, default_location: ?[:0]const u8) void {
    SDL_ShowSaveFileDialog(callback, userdata, window, filters.ptr, @intCast(filters.len), if (default_location) |s| s.ptr else null);
}
extern fn SDL_ShowSaveFileDialog(callback: DialogFileCallback, userdata: ?*anyopaque, window: ?*sdl.Window, filters: [*]const DialogFileFilter, nfilters: c_int, default_location: ?[*:0]const u8) void;

/// Displays a dialog that lets the user select a folder on their filesystem.
///
/// This is an asynchronous function; it will return immediately, and the
/// result will be passed to the callback.
///
/// The callback will be invoked with a null-terminated list of files the user
/// chose. The list will be empty if the user canceled the dialog, and it will
/// be null if an error occurred.
///
/// Note that the callback may be called from a different thread than the one
/// the function was invoked on.
///
/// Depending on the platform, the user may be allowed to input paths that
/// don't yet exist.
///
/// On Linux, dialogs may require XDG Portals, which requires DBus, which
/// requires an event-handling loop. Apps that do not use SDL to handle events
/// should add a call to `pumpEvents` in their main loop.
pub fn showOpenFolderDialog(callback: DialogFileCallback, userdata: ?*anyopaque, window: ?*sdl.Window, default_location: ?[:0]const u8, allow_many: bool) void {
    return SDL_ShowOpenFolderDialog(callback, userdata, window, if (default_location) |s| s.ptr else null, allow_many);
}
extern fn SDL_ShowOpenFolderDialog(callback: DialogFileCallback, userdata: ?*anyopaque, window: ?*sdl.Window, default_location: ?[*:0]const u8, allow_many: bool) void;

/// Various types of file dialogs.
///
/// This is used by `showFileDialogWithProperties` to decide what kind of
/// dialog to present to the user.
pub const FileDialogType = enum(c_int) {
    openfile,
    savefile,
    openfolder,
};

/// Create and launch a file dialog with the specified properties.
///
/// These are the supported properties:
///
/// - `prop_file_dialog_filters_pointer`: a pointer to a list of
///   `DialogFileFilter` structs, which will be used as filters for
///   file-based selections. Ignored if the dialog is an "Open Folder" dialog.
///   If non-null, the array of filters must remain valid at least until the
///   callback is invoked.
/// - `prop_file_dialog_nfilters_number`: the number of filters in the
///   array of filters, if it exists.
/// - `prop_file_dialog_window_pointer`: the window that the dialog should
///   be modal for.
/// - `prop_file_dialog_location_string`: the default folder or file to
///   start the dialog at.
/// - `prop_file_dialog_many_boolean`: true to allow the user to select
///   more than one entry.
/// - `prop_file_dialog_title_string`: the title for the dialog.
/// - `prop_file_dialog_accept_string`: the label that the accept button
///   should have.
/// - `prop_file_dialog_cancel_string`: the label that the cancel button
///   should have.
///
/// Note that each platform may or may not support any of the properties.
pub const showFileDialogWithProperties = SDL_ShowFileDialogWithProperties;
extern fn SDL_ShowFileDialogWithProperties(@"type": FileDialogType, callback: DialogFileCallback, userdata: ?*anyopaque, props: sdl.PropertiesId) void;

pub const prop_file_dialog_filters_pointer = "SDL.filedialog.filters";
pub const prop_file_dialog_nfilters_number = "SDL.filedialog.nfilters";
pub const prop_file_dialog_window_pointer = "SDL.filedialog.window";
pub const prop_file_dialog_location_string = "SDL.filedialog.location";
pub const prop_file_dialog_many_boolean = "SDL.filedialog.many";
pub const prop_file_dialog_title_string = "SDL.filedialog.title";
pub const prop_file_dialog_accept_string = "SDL.filedialog.accept";
pub const prop_file_dialog_cancel_string = "SDL.filedialog.cancel";
