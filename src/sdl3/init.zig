//! Initialization and Shutdown (SDL_init.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// Initialization flags for `init` and/or `initSubSystem`
///
/// These are the flags which may be passed to `init`. You should specify
/// the subsystems which you will be using in your application.
pub const InitFlags = packed struct(u32) {
    __unused0: u4 = 0,
    /// `audio` implies `events`
    audio: bool = false,
    /// `video` implies `events`, should be initialized on the main thread
    video: bool = false,
    __unused6: u3 = 0,
    /// `joystick` implies `events`
    joystick: bool = false,
    __unused10: u2 = 0,
    haptic: bool = false,
    /// `gamepad` implies `joystick`
    gamepad: bool = false,
    events: bool = false,
    /// `sensor` implies `events`
    sensor: bool = false,
    /// `camera` implies `events`
    camera: bool = false,
    __unused17: u15 = 0,

    pub const everything: InitFlags = .{
        .audio = true,
        .video = true,
        .joystick = true,
        .haptic = true,
        .gamepad = true,
        .events = true,
        .sensor = true,
        .camera = true,
    };
};

/// Return values for optional main callbacks.
///
/// Returning `AppResult.success` or `AppResult.failure` from `AppInit`,
/// `AppEvent`, or `AppIterate` will terminate the program and report
/// success/failure to the operating system. What that means is
/// platform-dependent. On Unix, for example, on success, the process error
/// code will be zero, and on failure it will be 1. This interface doesn't
/// allow you to return specific exit codes, just whether there was an error
/// generally or not.
///
/// Returning `AppResult.@"continue"` from these functions will let the app continue
/// to run.
///
/// See
/// [Main callbacks in SDL3](https://wiki.libsdl.org/SDL3/README-main-functions#main-callbacks-in-sdl3)
/// for complete details.
pub const AppResult = enum(c_int) {
    /// Value that requests that the app continue from the main callbacks.
    @"continue",
    /// Value that requests termination with success from the main callbacks.
    success,
    /// Value that requests termination with error from the main callbacks.
    failure,
};

/// Function pointer typedef for `AppInit`.
///
/// These are used by `enterAppMainCallbacks`. This mechanism operates behind
/// the scenes for apps using the optional main callbacks. Apps that want to
/// use this should just implement `AppInit` directly.
pub const AppInitFn = *const fn (appstate: ?*?*anyopaque, argc: c_int, argv: [*]?[*:0]u8) callconv(.c) AppResult;

/// Function pointer typedef for `AppIterate`.
///
/// These are used by `enterAppMainCallbacks`. This mechanism operates behind
/// the scenes for apps using the optional main callbacks. Apps that want to
/// use this should just implement `AppIterate` directly.
pub const AppIterateFn = *const fn (appstate: ?*anyopaque) callconv(.c) AppResult;

/// Function pointer typedef for `AppEvent`.
///
/// These are used by `enterAppMainCallbacks`. This mechanism operates behind
/// the scenes for apps using the optional main callbacks. Apps that want to
/// use this should just implement `AppEvent` directly.
pub const AppEventFn = *const fn (appstate: ?*anyopaque, event: *sdl.Event) callconv(.c) AppResult;

/// Function pointer typedef for `AppQuit`.
///
/// These are used by `enterAppMainCallbacks`. This mechanism operates behind
/// the scenes for apps using the optional main callbacks. Apps that want to
/// use this should just implement `AppEvent` directly.
pub const AppQuitFn = *const fn (appstate: ?*anyopaque, result: AppResult) callconv(.c) void;

/// Initialize the SDL library.
///
/// `init` simply forwards to calling `initSubSystem`. Therefore, the
/// two may be used interchangeably. Though for readability of your code
/// `initSubSystem` might be preferred.
///
/// The file I/O (for example: `ioFromFile`) and threading (`createThread`)
/// subsystems are initialized by default. Message boxes
/// (`showSimpleMessageBox`) also attempt to work without initializing the
/// video subsystem, in hopes of being useful in showing an error dialog when
/// `init` fails. You must specifically initialize other subsystems if you
/// use them in your application.
///
/// Logging (such as `log`) works without initialization, too.
///
/// `flags` may be any of the following OR'd together:
///
/// - `InitFlags.audio`: audio subsystem; automatically initializes the events
///   subsystem
/// - `InitFlags.video`: video subsystem; automatically initializes the events
///   subsystem, should be initialized on the main thread.
/// - `InitFlags.joystick`: joystick subsystem; automatically initializes the
///   events subsystem
/// - `InitFlags.haptic`: haptic (force feedback) subsystem
/// - `InitFlags.gamepad`: gamepad subsystem; automatically initializes the
///   joystick subsystem
/// - `InitFlags.events`: events subsystem
/// - `InitFlags.sensor`: sensor subsystem; automatically initializes the events
///   subsystem
/// - `InitFlags.camera`: camera subsystem; automatically initializes the events
///   subsystem
///
/// Subsystem initialization is ref-counted, you must call `quitSubSystem`
/// for each `initSubSystem` to correctly shutdown a subsystem manually (or
/// call `quit` to force shutdown). If a subsystem is already loaded then
/// this call will increase the ref-count and return.
///
/// Consider reporting some basic metadata about your application before
/// calling `init`, using either `setAppMetadata` or
/// `setAppMetadataProperty`.
pub fn init(flags: InitFlags) Error!void {
    if (!SDL_Init(flags)) return makeError();
}
extern fn SDL_Init(flags: InitFlags) bool;

/// Compatibility function to initialize the SDL library.
///
/// This function and `init` are interchangeable.
pub fn initSubSystem(flags: InitFlags) Error!void {
    if (!SDL_InitSubSystem(flags)) return makeError();
}
extern fn SDL_InitSubSystem(flags: InitFlags) bool;

/// Shut down specific SDL subsystems.
///
/// You still need to call `quit` even if you close all open subsystems
/// with `quitSubSystem`.
pub const quitSubSystem = SDL_QuitSubSystem;
extern fn SDL_QuitSubSystem(flags: InitFlags) void;

/// Get a mask of the specified subsystems which are currently initialized.
pub const wasInit = SDL_WasInit;
extern fn SDL_WasInit(flags: InitFlags) InitFlags;

/// Clean up all initialized subsystems.
///
/// You should call this function even if you have already shutdown each
/// initialized subsystem with `quitSubSystem`. It is safe to call this
/// function even in the case of errors in initialization.
///
/// You can use this function with atexit() to ensure that it is run when your
/// application is shutdown, but it is not wise to do this from a library or
/// other dynamically loaded code.
pub const quit = SDL_Quit;
extern fn SDL_Quit() void;

/// Return whether this is the main thread.
///
/// On Apple platforms, the main thread is the thread that runs your program's
/// main() entry point. On other platforms, the main thread is the one that
/// calls `init`(`InitFlags.video`), which should usually be the one that runs
/// your program's main() entry point. If you are using the main callbacks,
/// `AppInit`, `AppIterate`, and `AppQuit` are all called on the
/// main thread.
pub const isMainThread = SDL_IsMainThread;
extern fn SDL_IsMainThread() bool;

/// Callback run on the main thread.
pub const MainThreadCallback = *const fn (userdata: ?*anyopaque) callconv(.c) void;

/// Call a function on the main thread during event processing.
///
/// If this is called on the main thread, the callback is executed immediately.
/// If this is called on another thread, this callback is queued for execution
/// on the main thread during event processing.
///
/// Be careful of deadlocks when using this functionality. You should not have
/// the main thread wait for the current thread while this function is being
/// called with `wait_complete` true.
pub fn runOnMainThread(callback: MainThreadCallback, userdata: ?*anyopaque, wait_complete: bool) Error!void {
    if (!SDL_RunOnMainThread(callback, userdata, wait_complete)) return makeError();
}
extern fn SDL_RunOnMainThread(callback: MainThreadCallback, userdata: ?*anyopaque, wait_complete: bool) bool;

/// Specify basic metadata about your app.
///
/// You can optionally provide metadata about your app to SDL. This is not
/// required, but strongly encouraged.
///
/// There are several locations where SDL can make use of metadata (an "About"
/// box in the macOS menu bar, the name of the app can be shown on some audio
/// mixers, etc). Any piece of metadata can be left as null, if a specific
/// detail doesn't make sense for the app.
///
/// This function should be called as early as possible, before `init`.
/// Multiple calls to this function are allowed, but various state might not
/// change once it has been set up with a previous call to this function.
///
/// Passing a null removes any previous metadata.
///
/// This is a simplified interface for the most important information. You can
/// supply significantly more detailed metadata with
/// `setAppMetadataProperty`.
pub fn setAppMetadata(appname: ?[:0]const u8, appversion: ?[:0]const u8, appidentifier: ?[:0]const u8) Error!void {
    if (!SDL_SetAppMetadata(
        if (appname) |s| s.ptr else null,
        if (appversion) |s| s.ptr else null,
        if (appidentifier) |s| s.ptr else null,
    )) return makeError();
}
extern fn SDL_SetAppMetadata(appname: ?[*:0]const u8, appversion: ?[*:0]const u8, appidentifier: ?[*:0]const u8) bool;

/// Specify metadata about your app through a set of properties.
///
/// You can optionally provide metadata about your app to SDL. This is not
/// required, but strongly encouraged.
///
/// There are several locations where SDL can make use of metadata (an "About"
/// box in the macOS menu bar, the name of the app can be shown on some audio
/// mixers, etc). Any piece of metadata can be left out, if a specific detail
/// doesn't make sense for the app.
///
/// This function should be called as early as possible, before `init`.
/// Multiple calls to this function are allowed, but various state might not
/// change once it has been set up with a previous call to this function.
///
/// Once set, this metadata can be read using `getAppMetadataProperty`.
///
/// These are the supported properties:
///
/// - `prop_app_metadata_name_string`: The human-readable name of the
///   application, like "My Game 2: Bad Guy's Revenge!". This will show up
///   anywhere the OS shows the name of the application separately from window
///   titles, such as volume control applets, etc. If not provided by the app,
///   SDL will attempt to pick a reasonable default (the app's binary's name
///   if the platform can provide it, or "SDL Application" if all else fails).
/// - `prop_app_metadata_version_string`: The version of the app that is
///   running; there are no rules on format, so "1.0.3beta2" and "April 22nd,
///   2024" and a git hash are all valid options. This has no default.
/// - `prop_app_metadata_identifier_string`: A unique string that
///   identifies this app. This must be in reverse-domain format, like
///   "com.example.mygame2". This string is used by desktop compositors to
///   identify and group windows together, as well as match applications with
///   associated desktop settings and icons. If you plan to package your
///   application in a container such as Flatpak, the app ID should match the
///   name of your Flatpak container as well. This has no default.
/// - `prop_app_metadata_creator_string`: The human-readable name of the
///   creator/developer/maker of this app, like "MojoWorkshop, LLC"
/// - `prop_app_metadata_copyright_string`: The human-readable copyright
///   notice, like "Copyright (c) 2024 MojoWorkshop, LLC" or whatnot. Keep this
///   to one line, don't paste a copy of a whole software license in here. This
///   has no default.
/// - `prop_app_metadata_url_string`: A URL to the app on the web. Maybe a
///   product page, or a storefront, or even a GitHub repository, for user's
///   further information This has no default.
/// - `prop_app_metadata_type_string`: The type of application this is.
///   Currently this string can be "game" for a video game, "mediaplayer" for a
///   media player, or generically "application" if nothing else applies.
///   Future versions of SDL might add new types. This defaults to
///   "application".
pub fn setAppMetadataProperty(name: [:0]const u8, value: ?[:0]const u8) Error!void {
    if (!SDL_SetAppMetadataProperty(name.ptr, if (value) |s| s.ptr else null)) return makeError();
}
extern fn SDL_SetAppMetadataProperty(name: [*:0]const u8, value: ?[*:0]const u8) bool;

pub const prop_app_metadata_name_string = "SDL.app.metadata.name";
pub const prop_app_metadata_version_string = "SDL.app.metadata.version";
pub const prop_app_metadata_identifier_string = "SDL.app.metadata.identifier";
pub const prop_app_metadata_creator_string = "SDL.app.metadata.creator";
pub const prop_app_metadata_copyright_string = "SDL.app.metadata.copyright";
pub const prop_app_metadata_url_string = "SDL.app.metadata.url";
pub const prop_app_metadata_type_string = "SDL.app.metadata.type";
/// Get metadata about your app.
///
/// This returns metadata previously set using `setAppMetadata` or
/// `setAppMetadataProperty`. See `setAppMetadataProperty` for the list
/// of available properties and their meanings.
pub fn getAppMetadataProperty(name: [:0]const u8) ?[:0]const u8 {
    const str = SDL_GetAppMetadataProperty(name.ptr) orelse return null;
    return std.mem.span(str);
}
extern fn SDL_GetAppMetadataProperty(name: [*:0]const u8) ?[*:0]const u8;
