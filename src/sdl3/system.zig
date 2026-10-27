//! Platform-specific Functionality (SDL_system.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// A callback to be used with `setWindowsMessageHook`.
///
/// This callback may modify the message, and should return true if the message
/// should continue to be processed, or false to prevent further processing.
///
/// As this is processing a message directly from the Windows event loop, this
/// callback should do the minimum required work and return quickly.
/// The Windows `MSG` structure.
pub const MSG = opaque {};

pub const WindowsMessageHook = *const fn (userdata: ?*anyopaque, msg: *MSG) callconv(.c) bool;

/// Set a callback for every Windows message, run before TranslateMessage().
///
/// The callback may modify the message, and should return true if the message
/// should continue to be processed, or false to prevent further processing.
pub const setWindowsMessageHook = SDL_SetWindowsMessageHook;
extern fn SDL_SetWindowsMessageHook(callback: ?WindowsMessageHook, userdata: ?*anyopaque) void;

/// Get the D3D9 adapter index that matches the specified display.
///
/// The returned adapter index can be passed to `IDirect3D9::CreateDevice` and
/// controls on which monitor a full screen application will appear.
pub fn getDirect3D9AdapterIndex(displayID: sdl.DisplayId) Error!c_int {
    const result = SDL_GetDirect3D9AdapterIndex(displayID);
    if (result < 0) return makeError();
    return result;
}
extern fn SDL_GetDirect3D9AdapterIndex(displayID: sdl.DisplayId) c_int;

/// Get the DXGI Adapter and Output indices for the specified display.
///
/// The DXGI Adapter and Output indices can be passed to `EnumAdapters` and
/// `EnumOutputs` respectively to get the objects required to create a DX10 or
/// DX11 device and swap chain.
pub fn getDXGIOutputInfo(displayID: sdl.DisplayId) Error!struct { adapter_index: c_int, output_index: c_int } {
    var adapter_index: c_int = undefined;
    var output_index: c_int = undefined;
    if (!SDL_GetDXGIOutputInfo(displayID, &adapter_index, &output_index)) return makeError();
    return .{ .adapter_index = adapter_index, .output_index = output_index };
}
extern fn SDL_GetDXGIOutputInfo(displayID: sdl.DisplayId, adapterIndex: *c_int, outputIndex: *c_int) bool;

/// A callback to be used with `setX11EventHook`.
///
/// This callback may modify the event, and should return true if the event
/// should continue to be processed, or false to prevent further processing.
///
/// As this is processing an event directly from the X11 event loop, this
/// callback should do the minimum required work and return quickly.
/// The X11 `XEvent` union.
pub const XEvent = opaque {};

pub const X11EventHook = *const fn (userdata: ?*anyopaque, xevent: *XEvent) callconv(.c) bool;

/// Set a callback for every X11 event.
///
/// The callback may modify the event, and should return true if the event
/// should continue to be processed, or false to prevent further processing.
pub const setX11EventHook = SDL_SetX11EventHook;
extern fn SDL_SetX11EventHook(callback: ?X11EventHook, userdata: ?*anyopaque) void;

/// Sets the UNIX nice value for a thread.
///
/// This uses setpriority() if possible, and RealtimeKit if available.
pub fn setLinuxThreadPriority(threadID: i64, priority: c_int) Error!void {
    if (!SDL_SetLinuxThreadPriority(threadID, priority)) return makeError();
}
extern fn SDL_SetLinuxThreadPriority(threadID: i64, priority: c_int) bool;

/// Sets the priority (not nice level) and scheduling policy for a thread.
///
/// This uses setpriority() if possible, and RealtimeKit if available.
pub fn setLinuxThreadPriorityAndPolicy(threadID: i64, sdlPriority: c_int, schedPolicy: c_int) Error!void {
    if (!SDL_SetLinuxThreadPriorityAndPolicy(threadID, sdlPriority, schedPolicy)) return makeError();
}
extern fn SDL_SetLinuxThreadPriorityAndPolicy(threadID: i64, sdlPriority: c_int, schedPolicy: c_int) bool;

/// The prototype for an Apple iOS animation callback.
///
/// This datatype is only useful on Apple iOS.
///
/// After passing a function pointer of this type to
/// `setiOSAnimationCallback`, the system will call that function pointer at
/// a regular interval.
pub const IOSAnimationCallback = *const fn (userdata: ?*anyopaque) callconv(.c) void;

/// Use this function to set the animation callback on Apple iOS.
///
/// The function prototype for `callback` is:
///
/// ```c
/// void callback(void *callbackParam);
/// ```
///
/// Where its parameter, `callbackParam`, is what was passed as `callbackParam`
/// to `setiOSAnimationCallback`.
///
/// This function is only available on Apple iOS.
///
/// For more information see:
///
/// https://wiki.libsdl.org/SDL3/README-ios
///
/// Note that if you use the "main callbacks" instead of a standard C `main`
/// function, you don't have to use this API, as SDL will manage this for you.
///
/// Details on main callbacks are here:
///
/// https://wiki.libsdl.org/SDL3/README-main-functions
pub fn setiOSAnimationCallback(window: *sdl.Window, interval: c_int, callback: ?IOSAnimationCallback, callbackParam: ?*anyopaque) Error!void {
    if (!SDL_SetiOSAnimationCallback(window, interval, callback, callbackParam)) return makeError();
}
extern fn SDL_SetiOSAnimationCallback(window: *sdl.Window, interval: c_int, callback: ?IOSAnimationCallback, callbackParam: ?*anyopaque) bool;

/// Use this function to enable or disable the SDL event pump on Apple iOS.
///
/// This function is only available on Apple iOS.
pub const setiOSEventPump = SDL_SetiOSEventPump;
extern fn SDL_SetiOSEventPump(enabled: bool) void;

/// Get the Android Java Native Interface Environment of the current thread.
///
/// This is the JNIEnv one needs to access the Java virtual machine from native
/// code, and is needed for many Android APIs to be usable from C.
///
/// The prototype of the function in SDL's code actually declare a void* return
/// type, even if the implementation returns a pointer to a JNIEnv. The
/// rationale being that the SDL headers can avoid including jni.h.
pub fn getAndroidJNIEnv() Error!*anyopaque {
    return SDL_GetAndroidJNIEnv() orelse makeError();
}
extern fn SDL_GetAndroidJNIEnv() ?*anyopaque;

/// Retrieve the Java instance of the Android activity class.
///
/// The prototype of the function in SDL's code actually declares a void*
/// return type, even if the implementation returns a jobject. The rationale
/// being that the SDL headers can avoid including jni.h.
///
/// The jobject returned by the function is a local reference and must be
/// released by the caller. See the PushLocalFrame() and PopLocalFrame() or
/// DeleteLocalRef() functions of the Java native interface:
///
/// https://docs.oracle.com/javase/1.5.0/docs/guide/jni/spec/functions.html
pub fn getAndroidActivity() Error!*anyopaque {
    return SDL_GetAndroidActivity() orelse makeError();
}
extern fn SDL_GetAndroidActivity() ?*anyopaque;

/// Query Android API level of the current device.
///
/// - API level 35: Android 15 (VANILLA_ICE_CREAM)
/// - API level 34: Android 14 (UPSIDE_DOWN_CAKE)
/// - API level 33: Android 13 (TIRAMISU)
/// - API level 32: Android 12L (S_V2)
/// - API level 31: Android 12 (S)
/// - API level 30: Android 11 (R)
/// - API level 29: Android 10 (Q)
/// - API level 28: Android 9 (P)
/// - API level 27: Android 8.1 (O_MR1)
/// - API level 26: Android 8.0 (O)
/// - API level 25: Android 7.1 (N_MR1)
/// - API level 24: Android 7.0 (N)
/// - API level 23: Android 6.0 (M)
/// - API level 22: Android 5.1 (LOLLIPOP_MR1)
/// - API level 21: Android 5.0 (LOLLIPOP, L)
/// - API level 20: Android 4.4W (KITKAT_WATCH)
/// - API level 19: Android 4.4 (KITKAT)
/// - API level 18: Android 4.3 (JELLY_BEAN_MR2)
/// - API level 17: Android 4.2 (JELLY_BEAN_MR1)
/// - API level 16: Android 4.1 (JELLY_BEAN)
/// - API level 15: Android 4.0.3 (ICE_CREAM_SANDWICH_MR1)
/// - API level 14: Android 4.0 (ICE_CREAM_SANDWICH)
/// - API level 13: Android 3.2 (HONEYCOMB_MR2)
/// - API level 12: Android 3.1 (HONEYCOMB_MR1)
/// - API level 11: Android 3.0 (HONEYCOMB)
/// - API level 10: Android 2.3.3 (GINGERBREAD_MR1)
pub const getAndroidSDKVersion = SDL_GetAndroidSDKVersion;
extern fn SDL_GetAndroidSDKVersion() c_int;

/// Query if the application is running on a Chromebook.
pub const isChromebook = SDL_IsChromebook;
extern fn SDL_IsChromebook() bool;

/// Query if the application is running on a Samsung DeX docking station.
pub const isDeXMode = SDL_IsDeXMode;
extern fn SDL_IsDeXMode() bool;

/// Trigger the Android system back button behavior.
pub const sendAndroidBackButton = SDL_SendAndroidBackButton;
extern fn SDL_SendAndroidBackButton() void;

/// See the official Android developer guide for more information:
/// http://developer.android.com/guide/topics/data/data-storage.html
pub const android_external_storage_read: u32 = 0x01;

/// See the official Android developer guide for more information:
/// http://developer.android.com/guide/topics/data/data-storage.html
pub const android_external_storage_write: u32 = 0x02;

/// Get the path used for internal storage for this Android application.
///
/// This path is unique to your application and cannot be written to by other
/// applications.
///
/// Your internal storage path is typically:
/// `/data/data/your.app.package/files`.
///
/// This is a C wrapper over `android.content.Context.getFilesDir()`:
///
/// https://developer.android.com/reference/android/content/Context#getFilesDir()
pub fn getAndroidInternalStoragePath() Error![:0]const u8 {
    const str = SDL_GetAndroidInternalStoragePath() orelse return makeError();
    return std.mem.span(str);
}
extern fn SDL_GetAndroidInternalStoragePath() ?[*:0]const u8;

/// Get the current state of external storage for this Android application.
///
/// The current state of external storage, a bitmask of these values:
/// `android_external_storage_read`, `android_external_storage_write`.
///
/// If external storage is currently unavailable, this will return 0.
pub const getAndroidExternalStorageState = SDL_GetAndroidExternalStorageState;
extern fn SDL_GetAndroidExternalStorageState() u32;

/// Get the path used for external storage for this Android application.
///
/// This path is unique to your application, but is public and can be written
/// to by other applications.
///
/// Your external storage path is typically:
/// `/storage/sdcard0/Android/data/your.app.package/files`.
///
/// This is a C wrapper over `android.content.Context.getExternalFilesDir()`:
///
/// https://developer.android.com/reference/android/content/Context#getExternalFilesDir()
pub fn getAndroidExternalStoragePath() Error![:0]const u8 {
    const str = SDL_GetAndroidExternalStoragePath() orelse return makeError();
    return std.mem.span(str);
}
extern fn SDL_GetAndroidExternalStoragePath() ?[*:0]const u8;

/// Get the path used for caching data for this Android application.
///
/// This path is unique to your application, but is public and can be written
/// to by other applications.
///
/// Your cache path is typically: `/data/data/your.app.package/cache/`.
///
/// This is a C wrapper over `android.content.Context.getCacheDir()`:
///
/// https://developer.android.com/reference/android/content/Context#getCacheDir()
pub fn getAndroidCachePath() Error![:0]const u8 {
    const str = SDL_GetAndroidCachePath() orelse return makeError();
    return std.mem.span(str);
}
extern fn SDL_GetAndroidCachePath() ?[*:0]const u8;

/// Callback that presents a response from a `requestAndroidPermission` call.
pub const RequestAndroidPermissionCallback = *const fn (userdata: ?*anyopaque, permission: [*:0]const u8, granted: bool) callconv(.c) void;

/// Request permissions at runtime, asynchronously.
///
/// You do not need to call this for built-in functionality of SDL; recording
/// from a microphone or reading images from a camera, using standard SDL APIs,
/// will manage permission requests for you.
///
/// This function never blocks. Instead, the app-supplied callback will be
/// called when a decision has been made. This callback may happen on a
/// different thread, and possibly much later, as it might wait on a user to
/// respond to a system dialog. If permission has already been granted for a
/// specific entitlement, the callback will still fire, probably on the current
/// thread and before this function returns.
///
/// If the request submission fails, this function returns -1 and the callback
/// will NOT be called, but this should only happen in catastrophic conditions,
/// like memory running out. Normally there will be a yes or no to the request
/// through the callback.
///
/// For the `permission` parameter, choose a value from here:
///
/// https://developer.android.com/reference/android/Manifest.permission
///
/// The result of the request is only ever reported through the callback, not
/// this return value.
pub fn requestAndroidPermission(permission: [:0]const u8, cb: RequestAndroidPermissionCallback, userdata: ?*anyopaque) Error!void {
    if (!SDL_RequestAndroidPermission(permission.ptr, cb, userdata)) return makeError();
}
extern fn SDL_RequestAndroidPermission(permission: [*:0]const u8, cb: RequestAndroidPermissionCallback, userdata: ?*anyopaque) bool;

/// Shows an Android toast notification.
///
/// Toasts are a sort of lightweight notification that are unique to Android.
///
/// https://developer.android.com/guide/topics/ui/notifiers/toasts
///
/// Shows toast in UI thread.
///
/// For the `gravity` parameter, choose a value from here, or -1 if you don't
/// have a preference:
///
/// https://developer.android.com/reference/android/view/Gravity
pub fn showAndroidToast(message: [:0]const u8, duration: c_int, gravity: c_int, xoffset: c_int, yoffset: c_int) Error!void {
    if (!SDL_ShowAndroidToast(message.ptr, duration, gravity, xoffset, yoffset)) return makeError();
}
extern fn SDL_ShowAndroidToast(message: [*:0]const u8, duration: c_int, gravity: c_int, xoffset: c_int, yoffset: c_int) bool;

/// Send a user command to SDLActivity.
///
/// Override "boolean onUnhandledMessage(Message msg)" to handle the message.
pub fn sendAndroidMessage(command: u32, param: c_int) Error!void {
    if (!SDL_SendAndroidMessage(command, param)) return makeError();
}
extern fn SDL_SendAndroidMessage(command: u32, param: c_int) bool;

/// Query if the current device is a tablet.
///
/// If SDL can't determine this, it will return false.
pub const isTablet = SDL_IsTablet;
extern fn SDL_IsTablet() bool;

/// Query if the current device is a TV.
///
/// If SDL can't determine this, it will return false.
pub const isTV = SDL_IsTV;
extern fn SDL_IsTV() bool;

/// Application sandbox environment.
pub const Sandbox = enum(c_int) {
    none = 0,
    unknown_container,
    flatpak,
    snap,
    macos,
};

/// Get the application sandbox environment, if any.
pub const getSandbox = SDL_GetSandbox;
extern fn SDL_GetSandbox() Sandbox;

/// Let iOS apps with external event handling report
/// onApplicationWillTerminate.
///
/// This functions allows iOS apps that have their own event handling to hook
/// into SDL to generate SDL events. This maps directly to an iOS-specific
/// event, but since it doesn't do anything iOS-specific internally, it is
/// available on all platforms, in case it might be useful for some specific
/// paradigm. Most apps do not need to use this directly; SDL's internal event
/// code will handle all this for windows created by `createWindow`!
pub const onApplicationWillTerminate = SDL_OnApplicationWillTerminate;
extern fn SDL_OnApplicationWillTerminate() void;

/// Let iOS apps with external event handling report
/// onApplicationDidReceiveMemoryWarning.
///
/// This functions allows iOS apps that have their own event handling to hook
/// into SDL to generate SDL events. This maps directly to an iOS-specific
/// event, but since it doesn't do anything iOS-specific internally, it is
/// available on all platforms, in case it might be useful for some specific
/// paradigm. Most apps do not need to use this directly; SDL's internal event
/// code will handle all this for windows created by `createWindow`!
pub const onApplicationDidReceiveMemoryWarning = SDL_OnApplicationDidReceiveMemoryWarning;
extern fn SDL_OnApplicationDidReceiveMemoryWarning() void;

/// Let iOS apps with external event handling report
/// onApplicationWillResignActive.
///
/// This functions allows iOS apps that have their own event handling to hook
/// into SDL to generate SDL events. This maps directly to an iOS-specific
/// event, but since it doesn't do anything iOS-specific internally, it is
/// available on all platforms, in case it might be useful for some specific
/// paradigm. Most apps do not need to use this directly; SDL's internal event
/// code will handle all this for windows created by `createWindow`!
pub const onApplicationWillEnterBackground = SDL_OnApplicationWillEnterBackground;
extern fn SDL_OnApplicationWillEnterBackground() void;

/// Let iOS apps with external event handling report
/// onApplicationDidEnterBackground.
///
/// This functions allows iOS apps that have their own event handling to hook
/// into SDL to generate SDL events. This maps directly to an iOS-specific
/// event, but since it doesn't do anything iOS-specific internally, it is
/// available on all platforms, in case it might be useful for some specific
/// paradigm. Most apps do not need to use this directly; SDL's internal event
/// code will handle all this for windows created by `createWindow`!
pub const onApplicationDidEnterBackground = SDL_OnApplicationDidEnterBackground;
extern fn SDL_OnApplicationDidEnterBackground() void;

/// Let iOS apps with external event handling report
/// onApplicationWillEnterForeground.
///
/// This functions allows iOS apps that have their own event handling to hook
/// into SDL to generate SDL events. This maps directly to an iOS-specific
/// event, but since it doesn't do anything iOS-specific internally, it is
/// available on all platforms, in case it might be useful for some specific
/// paradigm. Most apps do not need to use this directly; SDL's internal event
/// code will handle all this for windows created by `createWindow`!
pub const onApplicationWillEnterForeground = SDL_OnApplicationWillEnterForeground;
extern fn SDL_OnApplicationWillEnterForeground() void;

/// Let iOS apps with external event handling report
/// onApplicationDidBecomeActive.
///
/// This functions allows iOS apps that have their own event handling to hook
/// into SDL to generate SDL events. This maps directly to an iOS-specific
/// event, but since it doesn't do anything iOS-specific internally, it is
/// available on all platforms, in case it might be useful for some specific
/// paradigm. Most apps do not need to use this directly; SDL's internal event
/// code will handle all this for windows created by `createWindow`!
pub const onApplicationDidEnterForeground = SDL_OnApplicationDidEnterForeground;
extern fn SDL_OnApplicationDidEnterForeground() void;

/// Let iOS apps with external event handling report
/// onApplicationDidChangeStatusBarOrientation.
///
/// This functions allows iOS apps that have their own event handling to hook
/// into SDL to generate SDL events. This maps directly to an iOS-specific
/// event, but since it doesn't do anything iOS-specific internally, it is
/// available on all platforms, in case it might be useful for some specific
/// paradigm. Most apps do not need to use this directly; SDL's internal event
/// code will handle all this for windows created by `createWindow`!
pub const onApplicationDidChangeStatusBarOrientation = SDL_OnApplicationDidChangeStatusBarOrientation;
extern fn SDL_OnApplicationDidChangeStatusBarOrientation() void;

/// A GDK `XTaskQueueHandle`.
pub const XTaskQueueHandle = *opaque {};

/// A GDK `XUserHandle`.
pub const XUserHandle = *opaque {};

/// Gets a reference to the global async task queue handle for GDK,
/// initializing if needed.
///
/// Once you are done with the task queue, you should call
/// XTaskQueueCloseHandle to reduce the reference count to avoid a resource
/// leak.
pub fn getGDKTaskQueue() Error!XTaskQueueHandle {
    var outTaskQueue: XTaskQueueHandle = undefined;
    if (!SDL_GetGDKTaskQueue(&outTaskQueue)) return makeError();
    return outTaskQueue;
}
extern fn SDL_GetGDKTaskQueue(outTaskQueue: *XTaskQueueHandle) bool;

/// Gets a reference to the default user handle for GDK.
///
/// This is effectively a synchronous version of XUserAddAsync, which always
/// prefers the default user and allows a sign-in UI.
pub fn getGDKDefaultUser() Error!XUserHandle {
    var outUserHandle: XUserHandle = undefined;
    if (!SDL_GetGDKDefaultUser(&outUserHandle)) return makeError();
    return outUserHandle;
}
extern fn SDL_GetGDKDefaultUser(outUserHandle: *XUserHandle) bool;
