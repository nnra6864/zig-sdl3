//! Application entry points (SDL_main.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// The prototype for the application's main() function.
pub const MainFn = *const fn (argc: c_int, argv: [*]?[*:0]u8) callconv(.c) c_int;

/// Circumvent failure of `init` when not using SDL_main() as an entry
/// point.
///
/// This function is defined in SDL_main.h, along with the preprocessor rule to
/// redefine main() as SDL_main(). Thus to ensure that your main() function
/// will not be changed it is necessary to define SDL_MAIN_HANDLED before
/// including SDL.h.
pub const setMainReady = SDL_SetMainReady;
extern fn SDL_SetMainReady() void;

/// Initializes and launches an SDL application, by doing platform-specific
/// initialization before calling your mainFunction and cleanups after it
/// returns, if that is needed for a specific platform, otherwise it just calls
/// mainFunction.
///
/// You can use this if you want to use your own main() implementation without
/// using SDL_main (like when using SDL_MAIN_HANDLED). When using this, you do
/// *not* need `setMainReady`.
///
/// If `argv` is null, SDL will provide command line arguments, either by
/// querying the OS for them if possible, or supplying a filler array if not.
// FIXME: returns: the return value from mainFunction: 0 on success, otherwise failure; `getError` might have more information on the failure.
pub const runApp = SDL_RunApp;
extern fn SDL_RunApp(argc: c_int, argv: [*]?[*:0]u8, mainFunction: MainFn, reserved: ?*anyopaque) c_int;

/// An entry point for SDL's use in SDL_MAIN_USE_CALLBACKS.
///
/// Generally, you should not call this function directly. This only exists to
/// hand off work into SDL as soon as possible, where it has a lot more control
/// and functionality available, and make the inline code in SDL_main.h as
/// small as possible.
///
/// Not all platforms use this, it's actual use is hidden in a magic
/// header-only library, and you should not call this directly unless you
/// _really_ know what you're doing.
pub const enterAppMainCallbacks = SDL_EnterAppMainCallbacks;
extern fn SDL_EnterAppMainCallbacks(argc: c_int, argv: [*]?[*:0]u8, appinit: sdl.AppInitFn, appiter: sdl.AppIterateFn, appevent: sdl.AppEventFn, appquit: sdl.AppQuitFn) c_int;

/// Register a win32 window class for SDL's use.
///
/// This can be called to set the application window class at startup. It is
/// safe to call this multiple times, as long as every call is eventually
/// paired with a call to `unregisterApp`, but a second registration attempt
/// while a previous registration is still active will be ignored, other than
/// to increment a counter.
///
/// Most applications do not need to, and should not, call this directly; SDL
/// will call it when initializing the video subsystem.
///
/// If `name` is null, SDL currently uses `(CS_BYTEALIGNCLIENT | CS_OWNDC)` for
/// the style, regardless of what is specified here.
pub fn registerApp(name: ?[:0]const u8, style: u32, hInst: ?*anyopaque) Error!void {
    if (!SDL_RegisterApp(if (name) |s| s.ptr else null, style, hInst)) return makeError();
}
extern fn SDL_RegisterApp(name: ?[*:0]const u8, style: u32, hInst: ?*anyopaque) bool;

/// Deregister the win32 window class from a `registerApp` call.
///
/// This can be called to undo the effects of `registerApp`.
///
/// Most applications do not need to, and should not, call this directly; SDL
/// will call it when deinitializing the video subsystem.
///
/// It is safe to call this multiple times, as long as every call is eventually
/// paired with a prior call to `registerApp`. The window class will only be
/// deregistered when the registration counter in `registerApp` decrements to
/// zero through calls to this function.
pub const unregisterApp = SDL_UnregisterApp;
extern fn SDL_UnregisterApp() void;

/// Callback from the application to let the suspend continue.
///
/// This should be called from an event watch in response to an
/// `EventType.did_enter_background` event.
///
/// When using `Render`, your event watch should be added _after_ creating
/// the `Renderer`; this allows the timing of the D3D12 command queue
/// suspension to execute in the correct order.
///
/// When using SDL_GPU, this should be called after calling `gdkSuspendGPU`.
///
/// If you're writing your own D3D12 renderer, this should be called after
/// calling `ID3D12CommandQueue::SuspendX`.
///
/// This function is only needed for Xbox GDK support; all other platforms will
/// do nothing and set an "unsupported" error message.
pub const gdkSuspendComplete = SDL_GDKSuspendComplete;
extern fn SDL_GDKSuspendComplete() void;
