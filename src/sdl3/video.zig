//! Display and Window Management (SDL_video.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// This is a unique ID for a display for the time it is connected to the
/// system, and is never reused for the lifetime of the application.
///
/// If the display is disconnected and reconnected, it will get a new ID.
///
/// The value 0 is an invalid ID.
pub const DisplayId = enum(u32) {
    invalid = 0,
    _,
    pub const Properties = struct {
        pub const hdr_enabled_boolean = "SDL.display.HDR_enabled";
        pub const kmsdrm_panel_orientation_number = "SDL.display.KMSDRM.panel_orientation";
        pub const wayland_wl_output_pointer = "SDL.display.wayland.wl_output";
        pub const windows_hmonitor_pointer = "SDL.display.windows.hmonitor";
    };
};

/// This is a unique ID for a window.
///
/// The value 0 is an invalid ID.
pub const WindowId = enum(u32) { invalid = 0, _ };

/// The pointer to the global `wl_display` object used by the Wayland video
/// backend.
///
/// Can be set before the video subsystem is initialized to import an external
/// `wl_display` object from an application or toolkit for use in SDL, or read
/// after initialization to export the `wl_display` used by the Wayland video
/// backend. Setting this property after the video subsystem has been
/// initialized has no effect, and reading it when the video subsystem is
/// uninitialized will either return the user provided value, if one was set
/// prior to initialization, or null. See docs/README-wayland.md for more
/// information.
pub const prop_global_video_wayland_wl_display_pointer = "SDL.video.wayland.wl_display";

/// System theme.
pub const SystemTheme = enum(c_int) {
    /// Unknown system theme
    unknown,
    /// Light colored system theme
    light,
    /// Dark colored system theme
    dark,
};

/// Internal display mode data.
///
/// This lives as a field in `DisplayMode`, as opaque data.
pub const DisplayModeData = opaque {};

/// The structure that defines a display mode.
pub const DisplayMode = extern struct {
    /// the display this mode is associated with
    displayId: DisplayId,
    /// pixel format
    format: sdl.PixelFormat,
    /// width
    w: c_int,
    /// height
    h: c_int,
    /// scale converting size to pixels (e.g. a 1920x1080 mode with 2.0 scale would have 3840x2160 pixels)
    pixel_density: f32,
    /// refresh rate (or 0.0f for unspecified)
    refresh_rate: f32,
    /// precise refresh rate numerator (or 0 for unspecified)
    refresh_rate_numerator: c_int,
    /// precise refresh rate denominator
    refresh_rate_denominator: c_int,
    /// Private
    internal: ?*DisplayModeData,
};

/// Display orientation values; the way a display is rotated.
pub const DisplayOrientation = enum(c_int) {
    /// The display orientation can't be determined
    unknown,
    /// The display is in landscape mode, with the right side up, relative to portrait mode
    landscape,
    /// The display is in landscape mode, with the left side up, relative to portrait mode
    landscape_flipped,
    /// The display is in portrait mode
    portrait,
    /// The display is in portrait mode, upside down
    portrait_flipped,
};

/// The struct used as an opaque handle to a window.
pub const Window = opaque {
    pub const Flags = WindowFlags;

    pub const pos_undefined = posUndefinedDisplay(0);
    pub const pos_centered = posCenteredDisplay(0);

    pub const Properties = struct {
        pub const create_always_on_top_boolean = "SDL.window.create.always_on_top";
        pub const create_borderless_boolean = "SDL.window.create.borderless";
        pub const create_constrain_popup_boolean = "SDL.window.create.constrain_popup";
        pub const create_focusable_boolean = "SDL.window.create.focusable";
        pub const create_external_graphics_context_boolean = "SDL.window.create.external_graphics_context";
        pub const create_flags_number = "SDL.window.create.flags";
        pub const create_fullscreen_boolean = "SDL.window.create.fullscreen";
        pub const create_height_number = "SDL.window.create.height";
        pub const create_hidden_boolean = "SDL.window.create.hidden";
        pub const create_high_pixel_density_boolean = "SDL.window.create.high_pixel_density";
        pub const create_maximized_boolean = "SDL.window.create.maximized";
        pub const create_menu_boolean = "SDL.window.create.menu";
        pub const create_metal_boolean = "SDL.window.create.metal";
        pub const create_minimized_boolean = "SDL.window.create.minimized";
        pub const create_modal_boolean = "SDL.window.create.modal";
        pub const create_mouse_grabbed_boolean = "SDL.window.create.mouse_grabbed";
        pub const create_opengl_boolean = "SDL.window.create.opengl";
        pub const create_parent_pointer = "SDL.window.create.parent";
        pub const create_resizable_boolean = "SDL.window.create.resizable";
        pub const create_title_string = "SDL.window.create.title";
        pub const create_transparent_boolean = "SDL.window.create.transparent";
        pub const create_tooltip_boolean = "SDL.window.create.tooltip";
        pub const create_utility_boolean = "SDL.window.create.utility";
        pub const create_vulkan_boolean = "SDL.window.create.vulkan";
        pub const create_width_number = "SDL.window.create.width";
        pub const create_x_number = "SDL.window.create.x";
        pub const create_y_number = "SDL.window.create.y";
        pub const create_cocoa_window_pointer = "SDL.window.create.cocoa.window";
        pub const create_cocoa_view_pointer = "SDL.window.create.cocoa.view";
        pub const create_windowscene_pointer = "SDL.window.create.uikit.windowscene";
        pub const create_wayland_surface_role_custom_boolean = "SDL.window.create.wayland.surface_role_custom";
        pub const create_wayland_create_egl_window_boolean = "SDL.window.create.wayland.create_egl_window";
        pub const create_wayland_wl_surface_pointer = "SDL.window.create.wayland.wl_surface";
        pub const create_win32_hwnd_pointer = "SDL.window.create.win32.hwnd";
        pub const create_win32_pixel_format_hwnd_pointer = "SDL.window.create.win32.pixel_format_hwnd";
        pub const create_x11_window_number = "SDL.window.create.x11.window";
        pub const create_emscripten_canvas_id_string = "SDL.window.create.emscripten.canvas_id";
        pub const create_emscripten_keyboard_element_string = "SDL.window.create.emscripten.keyboard_element";
        pub const shape_pointer = "SDL.window.shape";
        pub const hdr_enabled_boolean = "SDL.window.HDR_enabled";
        pub const sdr_white_level_float = "SDL.window.SDR_white_level";
        pub const hdr_headroom_float = "SDL.window.HDR_headroom";
        pub const android_window_pointer = "SDL.window.android.window";
        pub const android_surface_pointer = "SDL.window.android.surface";
        pub const uikit_window_pointer = "SDL.window.uikit.window";
        pub const uikit_metal_view_tag_number = "SDL.window.uikit.metal_view_tag";
        pub const uikit_opengl_framebuffer_number = "SDL.window.uikit.opengl.framebuffer";
        pub const uikit_opengl_renderbuffer_number = "SDL.window.uikit.opengl.renderbuffer";
        pub const uikit_opengl_resolve_framebuffer_number = "SDL.window.uikit.opengl.resolve_framebuffer";
        pub const kmsdrm_device_index_number = "SDL.window.kmsdrm.dev_index";
        pub const kmsdrm_drm_fd_number = "SDL.window.kmsdrm.drm_fd";
        pub const kmsdrm_gbm_device_pointer = "SDL.window.kmsdrm.gbm_dev";
        pub const cocoa_window_pointer = "SDL.window.cocoa.window";
        pub const cocoa_metal_view_tag_number = "SDL.window.cocoa.metal_view_tag";
        pub const openvr_overlay_id_number = "SDL.window.openvr.overlay_id";
        pub const vivante_display_pointer = "SDL.window.vivante.display";
        pub const vivante_window_pointer = "SDL.window.vivante.window";
        pub const vivante_surface_pointer = "SDL.window.vivante.surface";
        pub const win32_hwnd_pointer = "SDL.window.win32.hwnd";
        pub const win32_hdc_pointer = "SDL.window.win32.hdc";
        pub const win32_instance_pointer = "SDL.window.win32.instance";
        pub const wayland_display_pointer = "SDL.window.wayland.display";
        pub const wayland_surface_pointer = "SDL.window.wayland.surface";
        pub const wayland_viewport_pointer = "SDL.window.wayland.viewport";
        pub const wayland_egl_window_pointer = "SDL.window.wayland.egl_window";
        pub const wayland_xdg_surface_pointer = "SDL.window.wayland.xdg_surface";
        pub const wayland_xdg_toplevel_pointer = "SDL.window.wayland.xdg_toplevel";
        pub const wayland_xdg_toplevel_export_handle_string = "SDL.window.wayland.xdg_toplevel_export_handle";
        pub const wayland_xdg_popup_pointer = "SDL.window.wayland.xdg_popup";
        pub const wayland_xdg_positioner_pointer = "SDL.window.wayland.xdg_positioner";
        pub const x11_display_pointer = "SDL.window.x11.display";
        pub const x11_screen_number = "SDL.window.x11.screen";
        pub const x11_window_number = "SDL.window.x11.window";
        pub const emscripten_canvas_id_string = "SDL.window.emscripten.canvas_id";
        pub const emscripten_keyboard_element_string = "SDL.window.emscripten.keyboard_element";
    };
    pub const getDisplayFor = getDisplayForWindow;
    pub const getPixelDensity = getWindowPixelDensity;
    pub const getDisplayScale = getWindowDisplayScale;
    pub const setFullscreenMode = setWindowFullscreenMode;
    pub const getFullscreenMode = getWindowFullscreenMode;
    pub const getICCProfile = getWindowICCProfile;
    pub const getPixelFormat = getWindowPixelFormat;
    pub const create = createWindow;
    pub const createPopup = createPopupWindow;
    pub const createWithProperties = createWindowWithProperties;
    pub const getId = getWindowId;
    pub const getFromId = getWindowFromId;
    pub const getParent = getWindowParent;
    pub const getProperties = getWindowProperties;
    pub const getFlags = getWindowFlags;
    pub const setTitle = setWindowTitle;
    pub const getTitle = getWindowTitle;
    pub const setIcon = setWindowIcon;
    pub const setPosition = setWindowPosition;
    pub const getPosition = getWindowPosition;
    pub const setSize = setWindowSize;
    pub const getSize = getWindowSize;
    pub const getSafeArea = getWindowSafeArea;
    pub const setAspectRatio = setWindowAspectRatio;
    pub const getAspectRatio = getWindowAspectRatio;
    pub const getBordersSize = getWindowBordersSize;
    pub const getSizeInPixels = getWindowSizeInPixels;
    pub const setMinimumSize = setWindowMinimumSize;
    pub const getMinimumSize = getWindowMinimumSize;
    pub const setMaximumSize = setWindowMaximumSize;
    pub const getMaximumSize = getWindowMaximumSize;
    pub const setBordered = setWindowBordered;
    pub const setResizable = setWindowResizable;
    pub const setAlwaysOnTop = setWindowAlwaysOnTop;
    pub const setFillDocument = setWindowFillDocument;
    pub const show = showWindow;
    pub const hide = hideWindow;
    pub const raise = raiseWindow;
    pub const maximize = maximizeWindow;
    pub const minimize = minimizeWindow;
    pub const restore = restoreWindow;
    pub const setFullscreen = setWindowFullscreen;
    pub const sync = syncWindow;
    pub const hasSurface = windowHasSurface;
    pub const getSurface = getWindowSurface;
    pub const setSurfaceVSync = setWindowSurfaceVSync;
    pub const getSurfaceVSync = getWindowSurfaceVSync;
    pub const updateSurface = updateWindowSurface;
    pub const updateSurfaceRects = updateWindowSurfaceRects;
    pub const destroySurface = destroyWindowSurface;
    pub const setKeyboardGrab = setWindowKeyboardGrab;
    pub const setMouseGrab = setWindowMouseGrab;
    pub const getKeyboardGrab = getWindowKeyboardGrab;
    pub const getMouseGrab = getWindowMouseGrab;
    pub const getGrabbed = getGrabbedWindow;
    pub const setMouseRect = setWindowMouseRect;
    pub const getMouseRect = getWindowMouseRect;
    pub const setOpacity = setWindowOpacity;
    pub const getOpacity = getWindowOpacity;
    pub const setParent = setWindowParent;
    pub const setModal = setWindowModal;
    pub const setFocusable = setWindowFocusable;
    pub const showSystemMenu = showWindowSystemMenu;
    pub const setHitTest = setWindowHitTest;
    pub const setShape = setWindowShape;
    pub const flash = flashWindow;
    pub const setProgressState = setWindowProgressState;
    pub const getProgressState = getWindowProgressState;
    pub const setProgressValue = setWindowProgressValue;
    pub const getProgressValue = getWindowProgressValue;
    pub const destroy = destroyWindow;
};

/// The flags on a window.
///
/// These cover a lot of true/false, or on/off, window state. Some of it is
/// immutable after being set through `createWindow`, some of it can be
/// changed on existing windows by the app, and some of it might be altered by
/// the user or system outside of the app's control.
///
/// When creating windows with `WindowFlags.resizable`, SDL will constrain
/// resizable windows to the dimensions recommended by the compositor to fit it
/// within the usable desktop space, although some compositors will do this
/// automatically without intervention as well. Use `setWindowResizable`
/// after creation instead if you wish to create a window with a specific size.
pub const WindowFlags = packed struct(u64) {
    /// window is in fullscreen mode
    fullscreen: bool = false,
    /// window usable with OpenGL context
    opengl: bool = false,
    /// window is occluded
    occluded: bool = false,
    /// window is neither mapped onto the desktop nor shown in the taskbar/dock/window list; `showWindow` is required for it to become visible
    hidden: bool = false,
    /// no window decoration
    borderless: bool = false,
    /// window can be resized
    resizable: bool = false,
    /// window is minimized
    minimized: bool = false,
    /// window is maximized
    maximized: bool = false,
    /// window has grabbed mouse input
    mouse_grabbed: bool = false,
    /// window has input focus
    input_focus: bool = false,
    /// window has mouse focus
    mouse_focus: bool = false,
    /// window not created by SDL
    external: bool = false,
    /// window is modal
    modal: bool = false,
    /// window uses high pixel density back buffer if possible
    high_pixel_density: bool = false,
    /// window has mouse captured (unrelated to MOUSE_GRABBED)
    mouse_capture: bool = false,
    /// window has relative mode enabled
    mouse_relative_mode: bool = false,
    /// window should always be above others
    always_on_top: bool = false,
    /// window should be treated as a utility window, not showing in the task bar and window list
    utility: bool = false,
    /// window should be treated as a tooltip and does not get mouse or keyboard focus, requires a parent window
    tooltip: bool = false,
    /// window should be treated as a popup menu, requires a parent window
    popup_menu: bool = false,
    /// window has grabbed keyboard input
    keyboard_grabbed: bool = false,
    /// window is in fill-document mode (Emscripten only)
    fill_document: bool = false,
    __unused22: u6 = 0,
    /// window usable for Vulkan surface
    vulkan: bool = false,
    /// window usable for Metal view
    metal: bool = false,
    /// window with transparent buffer
    transparent: bool = false,
    /// window should not be focusable
    not_focusable: bool = false,
    __unused32: u32 = 0,
};

/// A magic value used with `pos_undefined`.
///
/// Generally this value isn't used directly, but rather through
/// `pos_undefined` or `posUndefinedDisplay`.
const pos_undefined_mask: i32 = 0x1fff_0000;

/// Used to indicate that you don't care what the window position is.
///
/// If you _really_ don't care, `pos_undefined` is the same, but always
/// uses the primary display instead of specifying one.
pub fn posUndefinedDisplay(x: i32) i32 {
    return pos_undefined_mask | x;
}

/// Used to indicate that you don't care what the window position/display is.
///
/// This always uses the primary display.
pub const pos_undefined: i32 = posUndefinedDisplay(0);

/// A macro to test if the window position is marked as "undefined."
pub fn posIsUndefined(x: i32) bool {
    return (@as(u32, @bitCast(x)) & 0xFFFF0000) == @as(u32, pos_undefined_mask);
}

/// A magic value used with `pos_centered`.
///
/// Generally this value isn't used directly, but rather through
/// `pos_centered` or `posCenteredDisplay`.
const pos_centered_mask: i32 = 0x2fff_0000;

/// Used to indicate that the window position should be centered.
///
/// `pos_centered` is the same, but always uses the primary display
/// instead of specifying one.
pub fn posCenteredDisplay(x: i32) i32 {
    return pos_centered_mask | x;
}

/// Used to indicate that the window position should be centered.
///
/// This always uses the primary display.
pub const pos_centered: i32 = posCenteredDisplay(0);

/// A macro to test if the window position is marked as "centered."
pub fn posIsCentered(x: i32) bool {
    return (@as(u32, @bitCast(x)) & 0xFFFF0000) == @as(u32, pos_centered_mask);
}

/// Window flash operation.
pub const FlashOperation = enum(c_int) {
    /// Cancel any window flash state
    cancel,
    /// Flash the window briefly to get attention
    briefly,
    /// Flash the window until it gets focus
    until_focused,
};

/// Window progress state
pub const ProgressState = enum(c_int) {
    /// An invalid progress state indicating an error; check `getError`
    invalid = -1,
    /// No progress bar is shown
    none,
    /// The progress bar is shown in a indeterminate state
    indeterminate,
    /// The progress bar is shown in a normal state
    normal,
    /// The progress bar is shown in a paused state
    paused,
    /// The progress bar is shown in a state indicating the application had an error
    @"error",
};

/// An opaque handle to an OpenGL context.
pub const GLContext = *GLContextState;
pub const GLContextState = opaque {};

/// Opaque type for an EGL display.
pub const EGLDisplay = *anyopaque;

/// Opaque type for an EGL config.
pub const EGLConfig = *anyopaque;

/// Opaque type for an EGL surface.
pub const EGLSurface = *anyopaque;

/// An EGL attribute, used when creating an EGL context.
pub const EGLAttrib = isize;

/// An EGL integer attribute, used when creating an EGL surface.
pub const EGLint = c_int;

/// EGL platform attribute initialization callback.
///
/// This is called when SDL is attempting to create an EGL context, to let the
/// app add extra attributes to its eglGetPlatformDisplay() call.
///
/// The callback should return a pointer to an EGL attribute array terminated
/// with `EGL_NONE`. If this function returns null, the `createWindow`
/// process will fail gracefully.
///
/// The returned pointer should be allocated with `malloc` and will be
/// passed to `free`.
///
/// The arrays returned by each callback will be appended to the existing
/// attribute arrays defined by SDL.
pub const EGLAttribArrayCallback = *const fn (userdata: ?*anyopaque) callconv(.c) ?[*]EGLAttrib;

/// EGL surface/context attribute initialization callback types.
///
/// This is called when SDL is attempting to create an EGL surface, to let the
/// app add extra attributes to its eglCreateWindowSurface() or
/// eglCreateContext calls.
///
/// For convenience, the EGLDisplay and EGLConfig to use are provided to the
/// callback.
///
/// The callback should return a pointer to an EGL attribute array terminated
/// with `EGL_NONE`. If this function returns null, the `createWindow`
/// process will fail gracefully.
///
/// The returned pointer should be allocated with `malloc` and will be
/// passed to `free`.
///
/// The arrays returned by each callback will be appended to the existing
/// attribute arrays defined by SDL.
pub const EGLIntArrayCallback = *const fn (userdata: ?*anyopaque, display: EGLDisplay, config: EGLConfig) callconv(.c) ?[*]EGLint;

pub const egl = struct {
    /// Get an EGL library function by name.
    ///
    /// If an EGL library is loaded, this function allows applications to get entry
    /// points for EGL functions. This is useful to provide to an EGL API and
    /// extension loader.
    pub fn getProcAddress(proc: [:0]const u8) gl.FunctionPointer {
        return SDL_EGL_GetProcAddress(proc.ptr);
    }
    extern fn SDL_EGL_GetProcAddress(proc: [*:0]const u8) gl.FunctionPointer;

    /// Get the currently active EGL display.
    pub fn getCurrentDisplay() Error!EGLDisplay {
        return SDL_EGL_GetCurrentDisplay() orelse makeError();
    }
    extern fn SDL_EGL_GetCurrentDisplay() ?EGLDisplay;

    /// Get the currently active EGL config.
    pub fn getCurrentConfig() Error!EGLConfig {
        return SDL_EGL_GetCurrentConfig() orelse makeError();
    }
    extern fn SDL_EGL_GetCurrentConfig() ?EGLConfig;

    /// Get the EGL surface associated with the window.
    pub fn getWindowSurface(window: *Window) Error!EGLSurface {
        return SDL_EGL_GetWindowSurface(window) orelse makeError();
    }
    extern fn SDL_EGL_GetWindowSurface(window: *Window) ?EGLSurface;

    /// Sets the callbacks for defining custom EGLAttrib arrays for EGL
    /// initialization.
    ///
    /// Callbacks that aren't needed can be set to null.
    ///
    /// NOTE: These callback pointers will be reset after `gl.resetAttributes`.
    pub const setAttributeCallbacks = SDL_EGL_SetAttributeCallbacks;
    extern fn SDL_EGL_SetAttributeCallbacks(platformAttribCallback: ?EGLAttribArrayCallback, surfaceAttribCallback: ?EGLIntArrayCallback, contextAttribCallback: ?EGLIntArrayCallback, userdata: ?*anyopaque) void;
};

pub const gl = struct {
    /// An opaque handle to an OpenGL context.
    pub const Context = GLContext;

    /// A generic function pointer, as returned by `gl.getProcAddress`.
    pub const FunctionPointer = ?*const anyopaque;

    /// An enumeration of OpenGL configuration attributes.
    ///
    /// While you can set most OpenGL attributes normally, the attributes listed
    /// above must be known before SDL creates the window that will be used with
    /// the OpenGL context. These attributes are set and read with
    /// `setAttribute` and `getAttribute`.
    ///
    /// In some cases, these attributes are minimum requests; the GL does not
    /// promise to give you exactly what you asked for. It's possible to ask for a
    /// 16-bit depth buffer and get a 24-bit one instead, for example, or to ask
    /// for no stencil buffer and still have one available. Context creation should
    /// fail if the GL can't provide your requested attributes at a minimum, but
    /// you should check to see exactly what you got.
    pub const Attr = enum(i32) {
        /// the minimum number of bits for the red channel of the color buffer; defaults to 8.
        red_size,
        /// the minimum number of bits for the green channel of the color buffer; defaults to 8.
        green_size,
        /// the minimum number of bits for the blue channel of the color buffer; defaults to 8.
        blue_size,
        /// the minimum number of bits for the alpha channel of the color buffer; defaults to 8.
        alpha_size,
        /// the minimum number of bits for frame buffer size; defaults to 0.
        buffer_size,
        /// whether the output is single or double buffered; defaults to double buffering on.
        doublebuffer,
        /// the minimum number of bits in the depth buffer; defaults to 16.
        depth_size,
        /// the minimum number of bits in the stencil buffer; defaults to 0.
        stencil_size,
        /// the minimum number of bits for the red channel of the accumulation buffer; defaults to 0.
        accum_red_size,
        /// the minimum number of bits for the green channel of the accumulation buffer; defaults to 0.
        accum_green_size,
        /// the minimum number of bits for the blue channel of the accumulation buffer; defaults to 0.
        accum_blue_size,
        /// the minimum number of bits for the alpha channel of the accumulation buffer; defaults to 0.
        accum_alpha_size,
        /// whether the output is stereo 3D; defaults to off.
        stereo,
        /// the number of buffers used for multisample anti-aliasing; defaults to 0.
        multisamplebuffers,
        /// the number of samples used around the current pixel used for multisample anti-aliasing.
        multisamplesamples,
        /// set to 1 to require hardware acceleration, set to 0 to force software rendering; defaults to allow either.
        accelerated_visual,
        /// not used (deprecated).
        retained_backing,
        /// OpenGL context major version.
        context_major_version,
        /// OpenGL context minor version.
        context_minor_version,
        /// some combination of 0 or more of elements of the `ContextFlags` enumeration; defaults to 0.
        context_flags,
        /// type of GL context (Core, Compatibility, ES). See `Profile`; default value depends on platform.
        context_profile_mask,
        /// OpenGL context sharing; defaults to 0.
        share_with_current_context,
        /// requests sRGB-capable visual if 1. Defaults to -1 ("don't care"). This is a request; GL drivers might not comply!
        framebuffer_srgb_capable,
        /// sets context the release behavior. See `ContextReleaseFlag`; defaults to `flush`.
        context_release_behavior,
        /// set context reset notification. See `ContextResetNotification`; defaults to `no_notification`.
        context_reset_notification,
        context_no_error,
        floatbuffers,
        egl_platform,
    };

    /// Possible values to be set for the ContextProfileMask attribute.
    pub const Profile = enum(c_int) {
        core = 0x0001,
        compatibility = 0x0002,
        es = 0x0004,
    };

    /// Possible flags to be set for the ContextFlags attribute.
    pub const ContextFlags = packed struct(i32) {
        debug: bool = false,
        forward_compatible: bool = false,
        robust_access: bool = false,
        reset_isolation: bool = false,
        __unused: i28 = 0,
    };

    /// Possible values to be set for the ContextReleaseBehavior
    /// attribute.
    pub const ContextReleaseFlags = packed struct(i32) {
        flush: bool = false,
        __unused: i31 = 0,
    };

    /// Possible values to be set ContextResetNotification attribute.
    pub const ContextResetNotification = enum(c_int) {
        no_notification = 0x0000,
        lose_context = 0x0001,
    };

    /// Dynamically load an OpenGL library.
    ///
    /// This should be done after initializing the video driver, but before
    /// creating any OpenGL windows. If no OpenGL library is loaded, the default
    /// library will be loaded upon creation of the first OpenGL window.
    ///
    /// If you do this, you need to retrieve all of the GL functions used in your
    /// program from the dynamic library using `gl.getProcAddress`.
    pub fn loadLibrary(path: ?[:0]const u8) Error!void {
        if (!SDL_GL_LoadLibrary(if (path) |s| s.ptr else null)) return makeError();
    }
    extern fn SDL_GL_LoadLibrary(path: ?[*:0]const u8) bool;

    /// Get an OpenGL function by name.
    ///
    /// If the GL library is loaded at runtime with `gl.loadLibrary`, then all
    /// GL functions must be retrieved this way. Usually this is used to retrieve
    /// function pointers to OpenGL extensions.
    ///
    /// There are some quirks to looking up OpenGL functions that require some
    /// extra care from the application. If you code carefully, you can handle
    /// these quirks without any platform-specific code, though:
    ///
    /// - On Windows, function pointers are specific to the current GL context;
    ///   this means you need to have created a GL context and made it current
    ///   before calling `gl.getProcAddress`. If you recreate your context or
    ///   create a second context, you should assume that any existing function
    ///   pointers aren't valid to use with it. This is (currently) a
    ///   Windows-specific limitation, and in practice lots of drivers don't suffer
    ///   this limitation, but it is still the way the wgl API is documented to
    ///   work and you should expect crashes if you don't respect it. Store a copy
    ///   of the function pointers that comes and goes with context lifespan.
    /// - On X11, function pointers returned by this function are valid for any
    ///   context, and can even be looked up before a context is created at all.
    ///   This means that, for at least some common OpenGL implementations, if you
    ///   look up a function that doesn't exist, you'll get a non-null result that
    ///   is _NOT_ safe to call. You must always make sure the function is actually
    ///   available for a given GL context before calling it, by checking for the
    ///   existence of the appropriate extension with `gl.extensionSupported`,
    ///   or verifying that the version of OpenGL you're using offers the function
    ///   as core functionality.
    /// - Some OpenGL drivers, on all platforms, *will* return null if a function
    ///   isn't supported, but you can't count on this behavior. Check for
    ///   extensions you use, and if you get a null anyway, act as if that
    ///   extension wasn't available. This is probably a bug in the driver, but you
    ///   can code defensively for this scenario anyhow.
    /// - Just because you're on Linux/Unix, don't assume you'll be using X11.
    ///   Next-gen display servers are waiting to replace it, and may or may not
    ///   make the same promises about function pointers.
    /// - OpenGL function pointers must be declared `APIENTRY` as in the example
    ///   code. This will ensure the proper calling convention is followed on
    ///   platforms where this matters (Win32) thereby avoiding stack corruption.
    pub fn getProcAddress(proc: [:0]const u8) FunctionPointer {
        return SDL_GL_GetProcAddress(proc.ptr);
    }
    extern fn SDL_GL_GetProcAddress(proc: [*:0]const u8) FunctionPointer;

    /// Unload the OpenGL library previously loaded by `gl.loadLibrary`.
    pub const unloadLibrary = SDL_GL_UnloadLibrary;
    extern fn SDL_GL_UnloadLibrary() void;

    /// Check if an OpenGL extension is supported for the current context.
    ///
    /// This function operates on the current GL context; you must have created a
    /// context and it must be current before calling this function. Do not assume
    /// that all contexts you create will have the same set of extensions
    /// available, or that recreating an existing context will offer the same
    /// extensions again.
    ///
    /// While it's probably not a massive overhead, this function is not an O(1)
    /// operation. Check the extensions you care about after creating the GL
    /// context and save that information somewhere instead of calling the function
    /// every time you need to know.
    pub fn extensionSupported(extension: [:0]const u8) bool {
        return SDL_GL_ExtensionSupported(extension.ptr);
    }
    extern fn SDL_GL_ExtensionSupported(extension: [*:0]const u8) bool;

    /// Reset all previously set OpenGL context attributes to their default values.
    pub const resetAttributes = SDL_GL_ResetAttributes;
    extern fn SDL_GL_ResetAttributes() void;

    /// Set an OpenGL window attribute before window creation.
    ///
    /// This function sets the OpenGL attribute `attr` to `value`. The requested
    /// attributes should be set before creating an OpenGL window. You should use
    /// `gl.getAttribute` to check the values after creating the OpenGL
    /// context, since the values obtained can differ from the requested ones.
    pub fn setAttribute(attr: Attr, value: c_int) Error!void {
        if (!SDL_GL_SetAttribute(attr, value)) return makeError();
    }
    extern fn SDL_GL_SetAttribute(attr: Attr, value: c_int) bool;

    /// Get the actual value for an attribute from the current context.
    pub fn getAttribute(attr: Attr) Error!c_int {
        var value: c_int = undefined;
        if (!SDL_GL_GetAttribute(attr, &value)) return makeError();
        return value;
    }
    extern fn SDL_GL_GetAttribute(attr: Attr, value: *c_int) bool;

    /// Create an OpenGL context for an OpenGL window, and make it current.
    ///
    /// The OpenGL context will be created with the current states set through
    /// `gl.setAttribute`.
    ///
    /// The `Window` specified must have been created with the `WindowFlags.opengl`
    /// flag, or context creation will fail.
    ///
    /// Windows users new to OpenGL should note that, for historical reasons, GL
    /// functions added after OpenGL version 1.1 are not available by default.
    /// Those functions must be loaded at run-time, either with an OpenGL
    /// extension-handling library or with `gl.getProcAddress` and its related
    /// functions.
    ///
    /// `Context` is opaque to the application.
    pub fn createContext(window: *Window) Error!Context {
        return SDL_GL_CreateContext(window) orelse makeError();
    }
    extern fn SDL_GL_CreateContext(window: *Window) ?Context;

    /// Set up an OpenGL context for rendering into an OpenGL window.
    ///
    /// The context must have been created with a compatible window.
    pub fn makeCurrent(window: *Window, context: Context) Error!void {
        if (!SDL_GL_MakeCurrent(window, context)) return makeError();
    }
    extern fn SDL_GL_MakeCurrent(window: *Window, context: Context) bool;

    /// Get the currently active OpenGL window.
    pub fn getCurrentWindow() Error!*Window {
        return SDL_GL_GetCurrentWindow() orelse makeError();
    }
    extern fn SDL_GL_GetCurrentWindow() ?*Window;

    /// Get the currently active OpenGL context.
    pub fn getCurrentContext() Error!Context {
        return SDL_GL_GetCurrentContext() orelse makeError();
    }
    extern fn SDL_GL_GetCurrentContext() ?Context;

    /// Set the swap interval for the current OpenGL context.
    ///
    /// Some systems allow specifying -1 for the interval, to enable adaptive
    /// vsync. Adaptive vsync works the same as vsync, but if you've already missed
    /// the vertical retrace for a given frame, it swaps buffers immediately, which
    /// might be less jarring for the user during occasional framerate drops. If an
    /// application requests adaptive vsync and the system does not support it,
    /// this function will fail and return false. In such a case, you should
    /// probably retry the call with 1 for the interval.
    ///
    /// Adaptive vsync is implemented for some glX drivers with
    /// GLX_EXT_swap_control_tear, and for some Windows drivers with
    /// WGL_EXT_swap_control_tear.
    ///
    /// Read more on the Khronos wiki:
    /// https://www.khronos.org/opengl/wiki/Swap_Interval#Adaptive_Vsync
    pub fn setSwapInterval(interval: c_int) Error!void {
        if (!SDL_GL_SetSwapInterval(interval)) return makeError();
    }
    extern fn SDL_GL_SetSwapInterval(interval: c_int) bool;

    /// Get the swap interval for the current OpenGL context.
    ///
    /// If the system can't determine the swap interval, or there isn't a valid
    /// current context, this function will set *interval to 0 as a safe default.
    pub fn getSwapInterval() Error!c_int {
        var interval: c_int = undefined;
        if (!SDL_GL_GetSwapInterval(&interval)) return makeError();
        return interval;
    }
    extern fn SDL_GL_GetSwapInterval(interval: *c_int) bool;

    /// Update a window with OpenGL rendering.
    ///
    /// This is used with double-buffered OpenGL contexts, which are the default.
    ///
    /// On macOS, make sure you bind 0 to the draw framebuffer before swapping the
    /// window, otherwise nothing will happen. If you aren't using
    /// glBindFramebuffer(), this is the default and you won't have to do anything
    /// extra.
    pub fn swapWindow(window: *Window) Error!void {
        if (!SDL_GL_SwapWindow(window)) return makeError();
    }
    extern fn SDL_GL_SwapWindow(window: *Window) bool;

    /// Delete an OpenGL context.
    pub fn destroyContext(context: Context) Error!void {
        if (!SDL_GL_DestroyContext(context)) return makeError();
    }
    extern fn SDL_GL_DestroyContext(context: Context) bool;
};

/// Get the number of video drivers compiled into SDL.
pub const getNumVideoDrivers = SDL_GetNumVideoDrivers;
extern fn SDL_GetNumVideoDrivers() c_int;

/// Get the name of a built in video driver.
///
/// The video drivers are presented in the order in which they are normally
/// checked during initialization.
///
/// The names of drivers are all simple, low-ASCII identifiers, like "cocoa",
/// "x11" or "windows". These never have Unicode characters, and are not meant
/// to be proper names.
pub fn getVideoDriver(index: c_int) ?[:0]const u8 {
    const str = SDL_GetVideoDriver(index) orelse return null;
    return std.mem.span(str);
}
extern fn SDL_GetVideoDriver(index: c_int) ?[*:0]const u8;

/// Get the name of the currently initialized video driver.
///
/// The names of drivers are all simple, low-ASCII identifiers, like "cocoa",
/// "x11" or "windows". These never have Unicode characters, and are not meant
/// to be proper names.
pub fn getCurrentVideoDriver() ?[:0]const u8 {
    const str = SDL_GetCurrentVideoDriver() orelse return null;
    return std.mem.span(str);
}
extern fn SDL_GetCurrentVideoDriver() ?[*:0]const u8;

/// Get the current system theme.
pub const getSystemTheme = SDL_GetSystemTheme;
extern fn SDL_GetSystemTheme() SystemTheme;

/// Get a list of currently connected displays.
///
/// The returned value should be freed with `free` when it is no longer needed.
pub fn getDisplays() Error![]DisplayId {
    var count: c_int = undefined;
    const ptr = SDL_GetDisplays(&count) orelse return makeError();
    return ptr[0..@intCast(count)];
}
extern fn SDL_GetDisplays(count: ?*c_int) ?[*]DisplayId;

/// Return the primary display.
pub fn getPrimaryDisplay() Error!DisplayId {
    const result = SDL_GetPrimaryDisplay();
    if (@backingInt(result) == 0) return makeError();
    return result;
}
extern fn SDL_GetPrimaryDisplay() DisplayId;

/// Get the properties associated with a display.
///
/// The following read-only properties are provided by SDL:
///
/// - `DisplayId.Properties.hdr_enabled_boolean`: true if the display has HDR
///   headroom above the SDR white point. This is for informational and
///   diagnostic purposes only, as not all platforms provide this information
///   at the display level.
///
/// On KMS/DRM:
///
/// - `DisplayId.Properties.kmsdrm_panel_orientation_number`: the "panel
///   orientation" property for the display in degrees of clockwise rotation.
///   Note that this is provided only as a hint, and the application is
///   responsible for any coordinate transformations needed to conform to the
///   requested display orientation.
///
/// On Wayland:
///
/// - `DisplayId.Properties.wayland_wl_output_pointer`: the wl_output associated
///   with the display
///
/// On Windows:
///
/// - `DisplayId.Properties.windows_hmonitor_pointer`: the monitor handle
///   (HMONITOR) associated with the display
pub fn getDisplayProperties(displayID: DisplayId) Error!sdl.PropertiesId {
    const result = SDL_GetDisplayProperties(displayID);
    if (@backingInt(result) == 0) return makeError();
    return result;
}
extern fn SDL_GetDisplayProperties(displayID: DisplayId) sdl.PropertiesId;

/// Get the name of a display in UTF-8 encoding.
pub fn getDisplayName(displayID: DisplayId) Error![:0]const u8 {
    const str = SDL_GetDisplayName(displayID) orelse return makeError();
    return std.mem.span(str);
}
extern fn SDL_GetDisplayName(displayID: DisplayId) ?[*:0]const u8;

/// Get the desktop area represented by a display.
///
/// The primary display is often located at (0,0), but may be placed at a
/// different location depending on monitor layout.
pub fn getDisplayBounds(displayID: DisplayId) Error!sdl.Rect {
    var rect: sdl.Rect = undefined;
    if (!SDL_GetDisplayBounds(displayID, &rect)) return makeError();
    return rect;
}
extern fn SDL_GetDisplayBounds(displayID: DisplayId, rect: *sdl.Rect) bool;

/// Get the usable desktop area represented by a display, in screen
/// coordinates.
///
/// This is the same area as `getDisplayBounds` reports, but with portions
/// reserved by the system removed. For example, on Apple's macOS, this
/// subtracts the area occupied by the menu bar and dock.
///
/// Setting a window to be fullscreen generally bypasses these unusable areas,
/// so these are good guidelines for the maximum space available to a
/// non-fullscreen window.
pub fn getDisplayUsableBounds(displayID: DisplayId) Error!sdl.Rect {
    var rect: sdl.Rect = undefined;
    if (!SDL_GetDisplayUsableBounds(displayID, &rect)) return makeError();
    return rect;
}
extern fn SDL_GetDisplayUsableBounds(displayID: DisplayId, rect: *sdl.Rect) bool;

/// Get the orientation of a display when it is unrotated.
pub const getNaturalDisplayOrientation = SDL_GetNaturalDisplayOrientation;
extern fn SDL_GetNaturalDisplayOrientation(displayID: DisplayId) DisplayOrientation;

/// Get the orientation of a display.
pub const getCurrentDisplayOrientation = SDL_GetCurrentDisplayOrientation;
extern fn SDL_GetCurrentDisplayOrientation(displayID: DisplayId) DisplayOrientation;

/// Get the content scale of a display.
///
/// The content scale is the expected scale for content based on the DPI
/// settings of the display. For example, a 4K display might have a 2.0 (200%)
/// display scale, which means that the user expects UI elements to be twice as
/// big on this display, to aid in readability.
///
/// After window creation, `getWindowDisplayScale` should be used to query
/// the content scale factor for individual windows instead of querying the
/// display for a window and calling this function, as the per-window content
/// scale factor may differ from the base value of the display it is on,
/// particularly on high-DPI and/or multi-monitor desktop configurations.
pub fn getDisplayContentScale(displayID: DisplayId) ?f32 {
    const result = SDL_GetDisplayContentScale(displayID);
    if (result == 0.0) return null;
    return result;
}
extern fn SDL_GetDisplayContentScale(displayID: DisplayId) f32;

/// Get a list of fullscreen display modes available on a display.
///
/// The display modes are sorted in this priority:
///
/// - w -> largest to smallest
/// - h -> largest to smallest
/// - bits per pixel -> more colors to fewer colors
/// - packed pixel layout -> largest to smallest
/// - refresh rate -> highest to lowest
/// - pixel density -> lowest to highest
///
/// The returned value should be freed with `free` when it is no longer needed.
pub fn getFullscreenDisplayModes(displayID: DisplayId) Error![]*DisplayMode {
    var count: c_int = undefined;
    const ptr = SDL_GetFullscreenDisplayModes(displayID, &count) orelse return makeError();
    return ptr[0..@intCast(count)];
}
extern fn SDL_GetFullscreenDisplayModes(displayID: DisplayId, count: ?*c_int) ?[*]*DisplayMode;

/// Get the closest match to the requested display mode.
///
/// The available display modes are scanned and `closest` is filled in with the
/// closest mode matching the requested mode and returned. The mode format and
/// refresh rate default to the desktop mode if they are set to 0. The modes
/// are scanned with size being first priority, format being second priority,
/// and finally checking the refresh rate. If all the available modes are too
/// small, then false is returned.
pub fn getClosestFullscreenDisplayMode(displayID: DisplayId, w: c_int, h: c_int, refresh_rate: f32, include_high_density_modes: bool) Error!DisplayMode {
    var closest: DisplayMode = undefined;
    if (!SDL_GetClosestFullscreenDisplayMode(displayID, w, h, refresh_rate, include_high_density_modes, &closest)) return makeError();
    return closest;
}
extern fn SDL_GetClosestFullscreenDisplayMode(displayID: DisplayId, w: c_int, h: c_int, refresh_rate: f32, include_high_density_modes: bool, closest: *DisplayMode) bool;

/// Get information about the desktop's display mode.
///
/// There's a difference between this function and `getCurrentDisplayMode`
/// when SDL runs fullscreen and has changed the resolution. In that case this
/// function will return the previous native display mode, and not the current
/// display mode.
pub fn getDesktopDisplayMode(displayID: DisplayId) Error!*const DisplayMode {
    return SDL_GetDesktopDisplayMode(displayID) orelse makeError();
}
extern fn SDL_GetDesktopDisplayMode(displayID: DisplayId) ?*const DisplayMode;

/// Get information about the current display mode.
///
/// There's a difference between this function and `getDesktopDisplayMode`
/// when SDL runs fullscreen and has changed the resolution. In that case this
/// function will return the current display mode, and not the previous native
/// display mode.
pub fn getCurrentDisplayMode(displayID: DisplayId) Error!*const DisplayMode {
    return SDL_GetCurrentDisplayMode(displayID) orelse makeError();
}
extern fn SDL_GetCurrentDisplayMode(displayID: DisplayId) ?*const DisplayMode;

/// Get the display containing a point.
pub fn getDisplayForPoint(point: *const sdl.Point) Error!DisplayId {
    const result = SDL_GetDisplayForPoint(point);
    if (@backingInt(result) == 0) return makeError();
    return result;
}
extern fn SDL_GetDisplayForPoint(point: *const sdl.Point) DisplayId;

/// Get the display primarily containing a rect.
pub fn getDisplayForRect(rect: *const sdl.Rect) Error!DisplayId {
    const result = SDL_GetDisplayForRect(rect);
    if (@backingInt(result) == 0) return makeError();
    return result;
}
extern fn SDL_GetDisplayForRect(rect: *const sdl.Rect) DisplayId;

/// Get the display associated with a window.
pub fn getDisplayForWindow(window: *Window) Error!DisplayId {
    const result = SDL_GetDisplayForWindow(window);
    if (@backingInt(result) == 0) return makeError();
    return result;
}
extern fn SDL_GetDisplayForWindow(window: *Window) DisplayId;

/// Get the pixel density of a window.
///
/// This is a ratio of pixel size to window size. For example, if the window is
/// 1920x1080 and it has a high density back buffer of 3840x2160 pixels, it
/// would have a pixel density of 2.0.
pub fn getWindowPixelDensity(window: *Window) ?f32 {
    const result = SDL_GetWindowPixelDensity(window);
    if (result == 0.0) return null;
    return result;
}
extern fn SDL_GetWindowPixelDensity(window: *Window) f32;

/// Get the content display scale relative to a window's pixel size.
///
/// This is a combination of the window pixel density and the display content
/// scale, and is the expected scale for displaying content in this window. For
/// example, if a 3840x2160 window had a display scale of 2.0, the user expects
/// the content to take twice as many pixels and be the same physical size as
/// if it were being displayed in a 1920x1080 window with a display scale of
/// 1.0.
///
/// Conceptually this value corresponds to the scale display setting, and is
/// updated when that setting is changed, or the window moves to a display with
/// a different scale setting.
pub fn getWindowDisplayScale(window: *Window) ?f32 {
    const result = SDL_GetWindowDisplayScale(window);
    if (result == 0.0) return null;
    return result;
}
extern fn SDL_GetWindowDisplayScale(window: *Window) f32;

/// Set the display mode to use when a window is visible and fullscreen.
///
/// This only affects the display mode used when the window is fullscreen. To
/// change the window size when the window is not fullscreen, use
/// `setWindowSize`.
///
/// If the window is currently in the fullscreen state, this request is
/// asynchronous on some windowing systems and the new mode dimensions may not
/// be applied immediately upon the return of this function. If an immediate
/// change is required, call `syncWindow` to block until the changes have
/// taken effect.
///
/// When the new mode takes effect, an `EventType.window_resized` and/or an
/// `EventType.window_pixel_size_changed` event will be emitted with the new mode
/// dimensions.
pub fn setWindowFullscreenMode(window: *Window, mode: ?*const DisplayMode) Error!void {
    if (!SDL_SetWindowFullscreenMode(window, mode)) return makeError();
}
extern fn SDL_SetWindowFullscreenMode(window: *Window, mode: ?*const DisplayMode) bool;

/// Query the display mode to use when a window is visible at fullscreen.
pub const getWindowFullscreenMode = SDL_GetWindowFullscreenMode;
extern fn SDL_GetWindowFullscreenMode(window: *Window) ?*const DisplayMode;

/// Get the raw ICC profile data for the screen the window is currently on.
///
/// The returned value should be freed with `free` when it is no longer needed.
pub fn getWindowICCProfile(window: *Window) Error![]u8 {
    var size: usize = undefined;
    const ptr = SDL_GetWindowICCProfile(window, &size) orelse return makeError();
    return @as([*]u8, @ptrCast(ptr))[0..size];
}
extern fn SDL_GetWindowICCProfile(window: *Window, size: *usize) ?*anyopaque;

/// Get the pixel format associated with the window.
pub fn getWindowPixelFormat(window: *Window) Error!sdl.PixelFormat {
    const format = SDL_GetWindowPixelFormat(window);
    if (format == .unknown) return makeError();
    return format;
}
extern fn SDL_GetWindowPixelFormat(window: *Window) sdl.PixelFormat;

/// Get a list of valid windows.
///
/// The returned value should be freed with `free` when it is no longer needed.
pub fn getWindows() Error![]*Window {
    var count: c_int = undefined;
    const ptr = SDL_GetWindows(&count) orelse return makeError();
    return ptr[0..@intCast(count)];
}
extern fn SDL_GetWindows(count: ?*c_int) ?[*]*Window;

/// Create a window with the specified dimensions and flags.
///
/// The window size is a request and may be different than expected based on
/// the desktop layout and window manager policies. Your application should be
/// prepared to handle a window of any size.
///
/// `flags` may be any of the following OR'd together:
///
/// - `WindowFlags.fullscreen`: fullscreen window at desktop resolution
/// - `WindowFlags.opengl`: window usable with an OpenGL context
/// - `WindowFlags.hidden`: window is not visible
/// - `WindowFlags.borderless`: no window decoration
/// - `WindowFlags.resizable`: window can be resized
/// - `WindowFlags.minimized`: window is minimized
/// - `WindowFlags.maximized`: window is maximized
/// - `WindowFlags.mouse_grabbed`: window has grabbed mouse focus
/// - `WindowFlags.input_focus`: window has input focus
/// - `WindowFlags.mouse_focus`: window has mouse focus
/// - `WindowFlags.external`: window not created by SDL
/// - `WindowFlags.modal`: window is modal
/// - `WindowFlags.high_pixel_density`: window uses high pixel density back
///   buffer if possible
/// - `WindowFlags.mouse_capture`: window has mouse captured (unrelated to
///   MOUSE_GRABBED)
/// - `WindowFlags.always_on_top`: window should always be above others
/// - `WindowFlags.utility`: window should be treated as a utility window, not
///   showing in the task bar and window list
/// - `WindowFlags.tooltip`: window should be treated as a tooltip and does not
///   get mouse or keyboard focus, requires a parent window
/// - `WindowFlags.popup_menu`: window should be treated as a popup menu,
///   requires a parent window
/// - `WindowFlags.keyboard_grabbed`: window has grabbed keyboard input
/// - `WindowFlags.vulkan`: window usable with a Vulkan instance
/// - `WindowFlags.metal`: window usable with a Metal instance
/// - `WindowFlags.transparent`: window with transparent buffer
/// - `WindowFlags.not_focusable`: window should not be focusable
///
/// The `Window` will be shown if `WindowFlags.hidden` is not set. If hidden at
/// creation time, `showWindow` can be used to show it later.
///
/// On Apple's macOS, you **must** set the NSHighResolutionCapable Info.plist
/// property to YES, otherwise you will not receive a High-DPI OpenGL canvas.
///
/// The window pixel size may differ from its window coordinate size if the
/// window is on a high pixel density display. Use `getWindowSize` to query
/// the client area's size in window coordinates, and
/// `getWindowSizeInPixels` or `getRenderOutputSize` to query the
/// drawable size in pixels. Note that the drawable size can vary after the
/// window is created and should be queried again if you get an
/// `EventType.window_pixel_size_changed` event.
///
/// If the window is created with any of the `WindowFlags.opengl` or
/// `WindowFlags.vulkan` flags, then the corresponding LoadLibrary function
/// (`gl.loadLibrary` or `vk.loadLibrary`) is called and the
/// corresponding UnloadLibrary function is called by `destroyWindow`.
///
/// If `WindowFlags.vulkan` is specified and there isn't a working Vulkan driver,
/// `createWindow` will fail, because `vk.loadLibrary` will fail.
///
/// If `WindowFlags.metal` is specified on an OS that does not support Metal,
/// `createWindow` will fail.
///
/// If you intend to use this window with a `Renderer`, you should use
/// `createWindowAndRenderer` instead of this function, to avoid window
/// flicker.
///
/// On non-Apple devices, SDL requires you to either not link to the Vulkan
/// loader or link to a dynamic library version. This limitation may be removed
/// in a future version of SDL.
pub fn createWindow(title: [:0]const u8, w: c_int, h: c_int, flags: WindowFlags) Error!*Window {
    return SDL_CreateWindow(title.ptr, w, h, flags) orelse makeError();
}
extern fn SDL_CreateWindow(title: [*:0]const u8, w: c_int, h: c_int, flags: WindowFlags) ?*Window;

/// Create a child popup window of the specified parent window.
///
/// The window size is a request and may be different than expected based on
/// the desktop layout and window manager policies. Your application should be
/// prepared to handle a window of any size.
///
/// The flags parameter **must** contain at least one of the following:
///
/// - `WindowFlags.tooltip`: The popup window is a tooltip and will not pass any
///   input events.
/// - `WindowFlags.popup_menu`: The popup window is a popup menu. The topmost
///   popup menu will implicitly gain the keyboard focus.
///
/// The following flags are not relevant to popup window creation and will be
/// ignored:
///
/// - `WindowFlags.minimized`
/// - `WindowFlags.maximized`
/// - `WindowFlags.fullscreen`
/// - `WindowFlags.borderless`
///
/// The following flags are incompatible with popup window creation and will
/// cause it to fail:
///
/// - `WindowFlags.utility`
/// - `WindowFlags.modal`
///
/// The parent parameter **must** be non-null and a valid window. The parent of
/// a popup window can be either a regular, toplevel window, or another popup
/// window.
///
/// Popup windows cannot be minimized, maximized, made fullscreen, raised,
/// flash, be made a modal window, be the parent of a toplevel window, or grab
/// the mouse and/or keyboard. Attempts to do so will fail.
///
/// Popup windows implicitly do not have a border/decorations and do not appear
/// on the taskbar/dock or in lists of windows such as alt-tab menus.
///
/// By default, popup window positions will automatically be constrained to
/// keep the entire window within display bounds. This can be overridden with
/// the `Window.Properties.create_constrain_popup_boolean` property.
///
/// By default, popup menus will automatically grab keyboard focus from the
/// parent when shown. This behavior can be overridden by setting the
/// `WindowFlags.not_focusable` flag, setting the
/// `Window.Properties.create_focusable_boolean` property to false, or toggling
/// it after creation via the `setWindowFocusable` function.
///
/// If a parent window is hidden or destroyed, any child popup windows will be
/// recursively hidden or destroyed as well. Child popup windows not explicitly
/// hidden will be restored when the parent is shown.
pub fn createPopupWindow(parent: ?*Window, offset_x: c_int, offset_y: c_int, w: c_int, h: c_int, flags: WindowFlags) Error!*Window {
    return SDL_CreatePopupWindow(parent, offset_x, offset_y, w, h, flags) orelse makeError();
}
extern fn SDL_CreatePopupWindow(parent: ?*Window, offset_x: c_int, offset_y: c_int, w: c_int, h: c_int, flags: WindowFlags) ?*Window;

/// Create a window with the specified properties.
///
/// The window size is a request and may be different than expected based on
/// the desktop layout and window manager policies. Your application should be
/// prepared to handle a window of any size.
///
/// These are the supported properties:
///
/// - `Window.Properties.create_always_on_top_boolean`: true if the window should
///   be always on top
/// - `Window.Properties.create_borderless_boolean`: true if the window has no
///   window decoration
/// - `Window.Properties.create_constrain_popup_boolean`: true if the "tooltip"
///   and "menu" window types should be automatically constrained to be
///   entirely within display bounds (default), false if no constraints on the
///   position are desired.
/// - `Window.Properties.create_external_graphics_context_boolean`: true if the
///   window will be used with an externally managed graphics context.
/// - `Window.Properties.create_focusable_boolean`: true if the window should
///   accept keyboard input (defaults true)
/// - `Window.Properties.create_fullscreen_boolean`: true if the window should
///   start in fullscreen mode at desktop resolution
/// - `Window.Properties.create_height_number`: the height of the window
/// - `Window.Properties.create_hidden_boolean`: true if the window should start
///   hidden
/// - `Window.Properties.create_high_pixel_density_boolean`: true if the window
///   uses a high pixel density buffer if possible
/// - `Window.Properties.create_maximized_boolean`: true if the window should
///   start maximized
/// - `Window.Properties.create_menu_boolean`: true if the window is a popup menu
/// - `Window.Properties.create_metal_boolean`: true if the window will be used
///   with Metal rendering
/// - `Window.Properties.create_minimized_boolean`: true if the window should
///   start minimized
/// - `Window.Properties.create_modal_boolean`: true if the window is modal to
///   its parent
/// - `Window.Properties.create_mouse_grabbed_boolean`: true if the window starts
///   with grabbed mouse focus
/// - `Window.Properties.create_opengl_boolean`: true if the window will be used
///   with OpenGL rendering
/// - `Window.Properties.create_parent_pointer`: a `Window` that will be the
///   parent of this window, required for windows with the "tooltip", "menu",
///   and "modal" properties
/// - `Window.Properties.create_resizable_boolean`: true if the window should be
///   resizable
/// - `Window.Properties.create_title_string`: the title of the window, in UTF-8
///   encoding
/// - `Window.Properties.create_transparent_boolean`: true if the window show
///   transparent in the areas with alpha of 0
/// - `Window.Properties.create_tooltip_boolean`: true if the window is a tooltip
/// - `Window.Properties.create_utility_boolean`: true if the window is a utility
///   window, not showing in the task bar and window list
/// - `Window.Properties.create_vulkan_boolean`: true if the window will be used
///   with Vulkan rendering
/// - `Window.Properties.create_width_number`: the width of the window
/// - `Window.Properties.create_x_number`: the x position of the window, or
///   `pos_centered`, defaults to `pos_undefined`. This is
///   relative to the parent for windows with the "tooltip" or "menu" property
///   set.
/// - `Window.Properties.create_y_number`: the y position of the window, or
///   `pos_centered`, defaults to `pos_undefined`. This is
///   relative to the parent for windows with the "tooltip" or "menu" property
///   set.
///
/// These are additional supported properties on macOS:
///
/// - `Window.Properties.create_cocoa_window_pointer`: the
///   `(__unsafe_unretained)` NSWindow associated with the window, if you want
///   to wrap an existing window.
/// - `Window.Properties.create_cocoa_view_pointer`: the `(__unsafe_unretained)`
///   NSView associated with the window, defaults to `[window contentView]`
///
/// These are additional supported properties on iOS, tvOS, and visionOS:
///
/// - `Window.Properties.create_windowscene_pointer`: the `(__unsafe_unretained)`
///   UIWindowScene associated with the window, defaults to the active window
///   scene.
///
/// These are additional supported properties on Wayland:
///
/// - `Window.Properties.create_wayland_surface_role_custom_boolean` - true if
///   the application wants to use the Wayland surface for a custom role and
///   does not want it attached to an XDG toplevel window. See
///   [README-wayland](README-wayland) for more information on using custom
///   surfaces.
/// - `Window.Properties.create_wayland_create_egl_window_boolean` - true if the
///   application wants an associated `wl_egl_window` object to be created and
///   attached to the window, even if the window does not have the OpenGL
///   property or `WindowFlags.opengl` flag set.
/// - `Window.Properties.create_wayland_wl_surface_pointer` - the wl_surface
///   associated with the window, if you want to wrap an existing window. See
///   [README-wayland](README-wayland) for more information.
///
/// These are additional supported properties on Windows:
///
/// - `Window.Properties.create_win32_hwnd_pointer`: the HWND associated with the
///   window, if you want to wrap an existing window.
/// - `Window.Properties.create_win32_pixel_format_hwnd_pointer`: optional,
///   another window to share pixel format with, useful for OpenGL windows
///
/// These are additional supported properties with X11:
///
/// - `Window.Properties.create_x11_window_number`: the X11 Window associated
///   with the window, if you want to wrap an existing window.
///
/// The window is implicitly shown if the "hidden" property is not set.
///
/// These are additional supported properties with Emscripten:
///
/// - `Window.Properties.create_emscripten_canvas_id_string`: the id given to the
///   canvas element. This should start with a '#' sign
/// - `Window.Properties.create_emscripten_keyboard_element_string`: override the
///   binding element for keyboard inputs for this canvas. The variable can be
///   one of:
///   - "#window": the javascript window object (default)
///   - "#document": the javascript document object
///   - "#screen": the javascript window.screen object
///   - "#canvas": the WebGL canvas element
///   - "#none": Don't bind anything at all
///   - any other string without a leading # sign applies to the element on the
///     page with that ID.
///
/// Windows with the "tooltip" and "menu" properties are popup windows and have
/// the behaviors and guidelines outlined in `createPopupWindow`.
///
/// If this window is being created to be used with a `Renderer`, you should
/// not add a graphics API specific property
/// (`Window.Properties.create_opengl_boolean`, etc), as SDL will handle that
/// internally when it chooses a renderer. However, SDL might need to recreate
/// your window at that point, which may cause the window to appear briefly,
/// and then flicker as it is recreated. The correct approach to this is to
/// create the window with the `Window.Properties.create_hidden_boolean` property
/// set to true, then create the renderer, then show the window with
/// `showWindow`.
pub fn createWindowWithProperties(props: sdl.PropertiesId) Error!*Window {
    return SDL_CreateWindowWithProperties(props) orelse makeError();
}
extern fn SDL_CreateWindowWithProperties(props: sdl.PropertiesId) ?*Window;

/// Get the numeric ID of a window.
///
/// The numeric ID is what `WindowEvent` references, and is necessary to map
/// these events to specific `Window` objects.
pub fn getWindowId(window: *Window) Error!WindowId {
    const result = SDL_GetWindowID(window);
    if (@backingInt(result) == 0) return makeError();
    return result;
}
extern fn SDL_GetWindowID(window: *Window) WindowId;

/// Get a window from a stored ID.
///
/// The numeric ID is what `WindowEvent` references, and is necessary to map
/// these events to specific `Window` objects.
pub const getWindowFromId = SDL_GetWindowFromID;
extern fn SDL_GetWindowFromID(id: WindowId) ?*Window;

/// Get parent of a window.
pub const getWindowParent = SDL_GetWindowParent;
extern fn SDL_GetWindowParent(window: *Window) ?*Window;

/// Get the properties associated with a window.
///
/// The following read-only properties are provided by SDL:
///
/// - `Window.Properties.shape_pointer`: the surface associated with a shaped
///   window
/// - `Window.Properties.hdr_enabled_boolean`: true if the window has HDR
///   headroom above the SDR white point. This property can change dynamically
///   when `EventType.window_hdr_state_changed` is sent.
/// - `Window.Properties.sdr_white_level_float`: the value of SDR white in the
///   `Colorspace.srgb_linear` colorspace. On Windows this corresponds to the
///   SDR white level in scRGB colorspace, and on Apple platforms this is
///   always 1.0 for EDR content. This property can change dynamically when
///   `EventType.window_hdr_state_changed` is sent.
/// - `Window.Properties.hdr_headroom_float`: the additional high dynamic range
///   that can be displayed, in terms of the SDR white point. When HDR is not
///   enabled, this will be 1.0. This property can change dynamically when
///   `EventType.window_hdr_state_changed` is sent.
///
/// On Android:
///
/// - `Window.Properties.android_window_pointer`: the ANativeWindow associated
///   with the window
/// - `Window.Properties.android_surface_pointer`: the EGLSurface associated with
///   the window
///
/// On iOS:
///
/// - `Window.Properties.uikit_window_pointer`: the `(__unsafe_unretained)`
///   UIWindow associated with the window
/// - `Window.Properties.uikit_metal_view_tag_number`: the NSInteger tag
///   associated with metal views on the window
/// - `Window.Properties.uikit_opengl_framebuffer_number`: the OpenGL view's
///   framebuffer object. It must be bound when rendering to the screen using
///   OpenGL.
/// - `Window.Properties.uikit_opengl_renderbuffer_number`: the OpenGL view's
///   renderbuffer object. It must be bound when `gl.swapWindow` is called.
/// - `Window.Properties.uikit_opengl_resolve_framebuffer_number`: the OpenGL
///   view's resolve framebuffer, when MSAA is used.
///
/// On KMS/DRM:
///
/// - `Window.Properties.kmsdrm_device_index_number`: the device index associated
///   with the window (e.g. the X in /dev/dri/cardX)
/// - `Window.Properties.kmsdrm_drm_fd_number`: the DRM FD associated with the
///   window
/// - `Window.Properties.kmsdrm_gbm_device_pointer`: the GBM device associated
///   with the window
///
/// On macOS:
///
/// - `Window.Properties.cocoa_window_pointer`: the `(__unsafe_unretained)`
///   NSWindow associated with the window
/// - `Window.Properties.cocoa_metal_view_tag_number`: the NSInteger tag
///   associated with metal views on the window
///
/// On OpenVR:
///
/// - `Window.Properties.openvr_overlay_id_number`: the OpenVR Overlay Handle ID
///   for the associated overlay window.
///
/// On Vivante:
///
/// - `Window.Properties.vivante_display_pointer`: the EGLNativeDisplayType
///   associated with the window
/// - `Window.Properties.vivante_window_pointer`: the EGLNativeWindowType
///   associated with the window
/// - `Window.Properties.vivante_surface_pointer`: the EGLSurface associated with
///   the window
///
/// On Windows:
///
/// - `Window.Properties.win32_hwnd_pointer`: the HWND associated with the window
/// - `Window.Properties.win32_hdc_pointer`: the HDC associated with the window
/// - `Window.Properties.win32_instance_pointer`: the HINSTANCE associated with
///   the window
///
/// On Wayland:
///
/// Note: The `xdg_*` window objects do not internally persist across window
/// show/hide calls. They will be null if the window is hidden and must be
/// queried each time it is shown.
///
/// - `Window.Properties.wayland_display_pointer`: the wl_display associated with
///   the window
/// - `Window.Properties.wayland_surface_pointer`: the wl_surface associated with
///   the window
/// - `Window.Properties.wayland_viewport_pointer`: the wp_viewport associated
///   with the window
/// - `Window.Properties.wayland_egl_window_pointer`: the wl_egl_window
///   associated with the window
/// - `Window.Properties.wayland_xdg_surface_pointer`: the xdg_surface associated
///   with the window
/// - `Window.Properties.wayland_xdg_toplevel_pointer`: the xdg_toplevel role
///   associated with the window
/// - '`Window.Properties.wayland_xdg_toplevel_export_handle_string`': the export
///   handle associated with the window
/// - `Window.Properties.wayland_xdg_popup_pointer`: the xdg_popup role
///   associated with the window
/// - `Window.Properties.wayland_xdg_positioner_pointer`: the xdg_positioner
///   associated with the window, in popup mode
///
/// On X11:
///
/// - `Window.Properties.x11_display_pointer`: the X11 Display associated with
///   the window
/// - `Window.Properties.x11_screen_number`: the screen number associated with
///   the window
/// - `Window.Properties.x11_window_number`: the X11 Window associated with the
///   window
///
/// On Emscripten:
///
/// - `Window.Properties.emscripten_canvas_id_string`: the id the canvas element
///   will have
/// - `Window.Properties.emscripten_keyboard_element_string`: the keyboard
///   element that associates keyboard events to this window
pub fn getWindowProperties(window: *Window) Error!sdl.PropertiesId {
    const result = SDL_GetWindowProperties(window);
    if (@backingInt(result) == 0) return makeError();
    return result;
}
extern fn SDL_GetWindowProperties(window: *Window) sdl.PropertiesId;

/// Get the window flags.
pub const getWindowFlags = SDL_GetWindowFlags;
extern fn SDL_GetWindowFlags(window: *Window) WindowFlags;

/// Set the title of a window.
///
/// This string is expected to be in UTF-8 encoding.
pub fn setWindowTitle(window: *Window, title: [:0]const u8) Error!void {
    if (!SDL_SetWindowTitle(window, title.ptr)) return makeError();
}
extern fn SDL_SetWindowTitle(window: *Window, title: [*:0]const u8) bool;

/// Get the title of a window.
pub fn getWindowTitle(window: *Window) [:0]const u8 {
    const str = SDL_GetWindowTitle(window);
    return std.mem.span(str);
}
extern fn SDL_GetWindowTitle(window: *Window) [*:0]const u8;

/// Set the icon for a window.
///
/// If this function is passed a surface with alternate representations added
/// using `addSurfaceAlternateImage`, the surface will be interpreted as
/// the content to be used for 100% display scale, and the alternate
/// representations will be used for high DPI situations. For example, if the
/// original surface is 32x32, then on a 2x macOS display or 200% display scale
/// on Windows, a 64x64 version of the image will be used, if available. If a
/// matching version of the image isn't available, the closest larger size
/// image will be downscaled to the appropriate size and be used instead, if
/// available. Otherwise, the closest smaller image will be upscaled and be
/// used instead.
pub fn setWindowIcon(window: *Window, icon: *sdl.Surface) Error!void {
    if (!SDL_SetWindowIcon(window, icon)) return makeError();
}
extern fn SDL_SetWindowIcon(window: *Window, icon: *sdl.Surface) bool;

/// Request that the window's position be set.
///
/// If the window is in an exclusive fullscreen or maximized state, this
/// request has no effect.
///
/// This can be used to reposition fullscreen-desktop windows onto a different
/// display, however, as exclusive fullscreen windows are locked to a specific
/// display, they can only be repositioned programmatically via
/// `setWindowFullscreenMode`.
///
/// On some windowing systems this request is asynchronous and the new
/// coordinates may not have have been applied immediately upon the return of
/// this function. If an immediate change is required, call `syncWindow` to
/// block until the changes have taken effect.
///
/// When the window position changes, an `EventType.window_moved` event will be
/// emitted with the window's new coordinates. Note that the new coordinates
/// may not match the exact coordinates requested, as some windowing systems
/// can restrict the position of the window in certain scenarios (e.g.
/// constraining the position so the window is always within desktop bounds).
/// Additionally, as this is just a request, it can be denied by the windowing
/// system.
pub fn setWindowPosition(window: *Window, x: c_int, y: c_int) Error!void {
    if (!SDL_SetWindowPosition(window, x, y)) return makeError();
}
extern fn SDL_SetWindowPosition(window: *Window, x: c_int, y: c_int) bool;

/// Get the position of a window.
///
/// This is the current position of the window as last reported by the
/// windowing system.
///
/// If you do not need the value for one of the positions a null may be passed
/// in the `x` or `y` parameter.
pub fn getWindowPosition(window: *Window, x: ?*c_int, y: ?*c_int) Error!void {
    if (!SDL_GetWindowPosition(window, x, y)) return makeError();
}
extern fn SDL_GetWindowPosition(window: *Window, x: ?*c_int, y: ?*c_int) bool;

/// Request that the size of a window's client area be set.
///
/// If the window is in a fullscreen or maximized state, this request has no
/// effect.
///
/// To change the exclusive fullscreen mode of a window, use
/// `setWindowFullscreenMode`.
///
/// On some windowing systems, this request is asynchronous and the new window
/// size may not have have been applied immediately upon the return of this
/// function. If an immediate change is required, call `syncWindow` to
/// block until the changes have taken effect.
///
/// When the window size changes, an `EventType.window_resized` event will be
/// emitted with the new window dimensions. Note that the new dimensions may
/// not match the exact size requested, as some windowing systems can restrict
/// the window size in certain scenarios (e.g. constraining the size of the
/// content area to remain within the usable desktop bounds). Additionally, as
/// this is just a request, it can be denied by the windowing system.
pub fn setWindowSize(window: *Window, w: c_int, h: c_int) Error!void {
    if (!SDL_SetWindowSize(window, w, h)) return makeError();
}
extern fn SDL_SetWindowSize(window: *Window, w: c_int, h: c_int) bool;

/// Get the size of a window's client area.
///
/// The window pixel size may differ from its window coordinate size if the
/// window is on a high pixel density display. Use `getWindowSizeInPixels`
/// or `getRenderOutputSize` to get the real client area size in pixels.
pub fn getWindowSize(window: *Window, w: ?*c_int, h: ?*c_int) Error!void {
    if (!SDL_GetWindowSize(window, w, h)) return makeError();
}
extern fn SDL_GetWindowSize(window: *Window, w: ?*c_int, h: ?*c_int) bool;

/// Get the safe area for this window.
///
/// Some devices have portions of the screen which are partially obscured or
/// not interactive, possibly due to on-screen controls, curved edges, camera
/// notches, TV overscan, etc. This function provides the area of the window
/// which is safe to have interactable content. You should continue rendering
/// into the rest of the window, but it should not contain visually important
/// or interactable content.
pub fn getWindowSafeArea(window: *Window) Error!sdl.Rect {
    var rect: sdl.Rect = undefined;
    if (!SDL_GetWindowSafeArea(window, &rect)) return makeError();
    return rect;
}
extern fn SDL_GetWindowSafeArea(window: *Window, rect: *sdl.Rect) bool;

/// Request that the aspect ratio of a window's client area be set.
///
/// The aspect ratio is the ratio of width divided by height, e.g. 2560x1600
/// would be 1.6. Larger aspect ratios are wider and smaller aspect ratios are
/// narrower.
///
/// If, at the time of this request, the window in a fixed-size state, such as
/// maximized or fullscreen, the request will be deferred until the window
/// exits this state and becomes resizable again.
///
/// On some windowing systems, this request is asynchronous and the new window
/// aspect ratio may not have have been applied immediately upon the return of
/// this function. If an immediate change is required, call `syncWindow` to
/// block until the changes have taken effect.
///
/// When the window size changes, an `EventType.window_resized` event will be
/// emitted with the new window dimensions. Note that the new dimensions may
/// not match the exact aspect ratio requested, as some windowing systems can
/// restrict the window size in certain scenarios (e.g. constraining the size
/// of the content area to remain within the usable desktop bounds).
/// Additionally, as this is just a request, it can be denied by the windowing
/// system.
pub fn setWindowAspectRatio(window: *Window, min_aspect: f32, max_aspect: f32) Error!void {
    if (!SDL_SetWindowAspectRatio(window, min_aspect, max_aspect)) return makeError();
}
extern fn SDL_SetWindowAspectRatio(window: *Window, min_aspect: f32, max_aspect: f32) bool;

/// Get the aspect ratio of a window's client area.
pub fn getWindowAspectRatio(window: *Window, min_aspect: ?*f32, max_aspect: ?*f32) Error!void {
    if (!SDL_GetWindowAspectRatio(window, min_aspect, max_aspect)) return makeError();
}
extern fn SDL_GetWindowAspectRatio(window: *Window, min_aspect: ?*f32, max_aspect: ?*f32) bool;

/// Get the size of a window's borders (decorations) around the client area.
///
/// Note: If this function fails (returns false), the size values will be
/// initialized to 0, 0, 0, 0 (if a non-null pointer is provided), as if the
/// window in question was borderless.
///
/// Note: This function may fail on systems where the window has not yet been
/// decorated by the display server (for example, immediately after calling
/// `createWindow`). It is recommended that you wait at least until the
/// window has been presented and composited, so that the window system has a
/// chance to decorate the window and provide the border dimensions to SDL.
///
/// This function also returns false if getting the information is not
/// supported.
pub fn getWindowBordersSize(window: *Window, top: ?*c_int, left: ?*c_int, bottom: ?*c_int, right: ?*c_int) Error!void {
    if (!SDL_GetWindowBordersSize(window, top, left, bottom, right)) return makeError();
}
extern fn SDL_GetWindowBordersSize(window: *Window, top: ?*c_int, left: ?*c_int, bottom: ?*c_int, right: ?*c_int) bool;

/// Get the size of a window's client area, in pixels.
pub fn getWindowSizeInPixels(window: *Window, w: ?*c_int, h: ?*c_int) Error!void {
    if (!SDL_GetWindowSizeInPixels(window, w, h)) return makeError();
}
extern fn SDL_GetWindowSizeInPixels(window: *Window, w: ?*c_int, h: ?*c_int) bool;

/// Set the minimum size of a window's client area.
pub fn setWindowMinimumSize(window: *Window, min_w: c_int, min_h: c_int) Error!void {
    if (!SDL_SetWindowMinimumSize(window, min_w, min_h)) return makeError();
}
extern fn SDL_SetWindowMinimumSize(window: *Window, min_w: c_int, min_h: c_int) bool;

/// Get the minimum size of a window's client area.
pub fn getWindowMinimumSize(window: *Window, w: ?*c_int, h: ?*c_int) Error!void {
    if (!SDL_GetWindowMinimumSize(window, w, h)) return makeError();
}
extern fn SDL_GetWindowMinimumSize(window: *Window, w: ?*c_int, h: ?*c_int) bool;

/// Set the maximum size of a window's client area.
pub fn setWindowMaximumSize(window: *Window, max_w: c_int, max_h: c_int) Error!void {
    if (!SDL_SetWindowMaximumSize(window, max_w, max_h)) return makeError();
}
extern fn SDL_SetWindowMaximumSize(window: *Window, max_w: c_int, max_h: c_int) bool;

/// Get the maximum size of a window's client area.
pub fn getWindowMaximumSize(window: *Window, w: ?*c_int, h: ?*c_int) Error!void {
    if (!SDL_GetWindowMaximumSize(window, w, h)) return makeError();
}
extern fn SDL_GetWindowMaximumSize(window: *Window, w: ?*c_int, h: ?*c_int) bool;

/// Set the border state of a window.
///
/// This will add or remove the window's `WindowFlags.borderless` flag and add
/// or remove the border from the actual window. This is a no-op if the
/// window's border already matches the requested state.
///
/// You can't change the border state of a fullscreen window.
pub fn setWindowBordered(window: *Window, bordered: bool) Error!void {
    if (!SDL_SetWindowBordered(window, bordered)) return makeError();
}
extern fn SDL_SetWindowBordered(window: *Window, bordered: bool) bool;

/// Set the user-resizable state of a window.
///
/// This will add or remove the window's `WindowFlags.resizable` flag and
/// allow/disallow user resizing of the window. This is a no-op if the window's
/// resizable state already matches the requested state.
///
/// You can't change the resizable state of a fullscreen window.
pub fn setWindowResizable(window: *Window, resizable: bool) Error!void {
    if (!SDL_SetWindowResizable(window, resizable)) return makeError();
}
extern fn SDL_SetWindowResizable(window: *Window, resizable: bool) bool;

/// Set the window to always be above the others.
///
/// This will add or remove the window's `WindowFlags.always_on_top` flag. This
/// will bring the window to the front and keep the window above the rest.
pub fn setWindowAlwaysOnTop(window: *Window, on_top: bool) Error!void {
    if (!SDL_SetWindowAlwaysOnTop(window, on_top)) return makeError();
}
extern fn SDL_SetWindowAlwaysOnTop(window: *Window, on_top: bool) bool;

/// Set the window to fill the current document space (Emscripten only).
///
/// This will add or remove the window's `WindowFlags.fill_document` flag.
///
/// Currently this flag only applies to the Emscripten target.
///
/// When enabled, the canvas element fills the entire document. Resize events
/// will be generated as the browser window is resized, as that will adjust the
/// canvas size as well. The canvas will cover anything else on the page,
/// including any controls provided by Emscripten in its generated HTML file
/// (in fact, any elements on the page that aren't the canvas will be moved
/// into a hidden `div` element).
///
/// Often times this is desirable for a browser-based game, but it means
/// several things that we expect of an SDL window on other platforms might not
/// work as expected, such as minimum window sizes and aspect ratios.
pub fn setWindowFillDocument(window: *Window, fill: bool) Error!void {
    if (!SDL_SetWindowFillDocument(window, fill)) return makeError();
}
extern fn SDL_SetWindowFillDocument(window: *Window, fill: bool) bool;

/// Show a window.
pub fn showWindow(window: *Window) Error!void {
    if (!SDL_ShowWindow(window)) return makeError();
}
extern fn SDL_ShowWindow(window: *Window) bool;

/// Hide a window.
pub fn hideWindow(window: *Window) Error!void {
    if (!SDL_HideWindow(window)) return makeError();
}
extern fn SDL_HideWindow(window: *Window) bool;

/// Request that a window be raised above other windows and gain the input
/// focus.
///
/// The result of this request is subject to desktop window manager policy,
/// particularly if raising the requested window would result in stealing focus
/// from another application. If the window is successfully raised and gains
/// input focus, an `EventType.window_focus_gained` event will be emitted, and
/// the window will have the `WindowFlags.input_focus` flag set.
pub fn raiseWindow(window: *Window) Error!void {
    if (!SDL_RaiseWindow(window)) return makeError();
}
extern fn SDL_RaiseWindow(window: *Window) bool;

/// Request that the window be made as large as possible.
///
/// Non-resizable windows can't be maximized. The window must have the
/// `WindowFlags.resizable` flag set, or this will have no effect.
///
/// On some windowing systems this request is asynchronous and the new window
/// state may not have have been applied immediately upon the return of this
/// function. If an immediate change is required, call `syncWindow` to
/// block until the changes have taken effect.
///
/// When the window state changes, an `EventType.window_maximized` event will be
/// emitted. Note that, as this is just a request, the windowing system can
/// deny the state change.
///
/// When maximizing a window, whether the constraints set via
/// `setWindowMaximumSize` are honored depends on the policy of the window
/// manager. Win32 and macOS enforce the constraints when maximizing, while X11
/// and Wayland window managers may vary.
pub fn maximizeWindow(window: *Window) Error!void {
    if (!SDL_MaximizeWindow(window)) return makeError();
}
extern fn SDL_MaximizeWindow(window: *Window) bool;

/// Request that the window be minimized to an iconic representation.
///
/// If the window is in a fullscreen state, this request has no direct effect.
/// It may alter the state the window is returned to when leaving fullscreen.
///
/// On some windowing systems this request is asynchronous and the new window
/// state may not have been applied immediately upon the return of this
/// function. If an immediate change is required, call `syncWindow` to
/// block until the changes have taken effect.
///
/// When the window state changes, an `EventType.window_minimized` event will be
/// emitted. Note that, as this is just a request, the windowing system can
/// deny the state change.
pub fn minimizeWindow(window: *Window) Error!void {
    if (!SDL_MinimizeWindow(window)) return makeError();
}
extern fn SDL_MinimizeWindow(window: *Window) bool;

/// Request that the size and position of a minimized or maximized window be
/// restored.
///
/// If the window is in a fullscreen state, this request has no direct effect.
/// It may alter the state the window is returned to when leaving fullscreen.
///
/// On some windowing systems this request is asynchronous and the new window
/// state may not have have been applied immediately upon the return of this
/// function. If an immediate change is required, call `syncWindow` to
/// block until the changes have taken effect.
///
/// When the window state changes, an `EventType.window_restored` event will be
/// emitted. Note that, as this is just a request, the windowing system can
/// deny the state change.
pub fn restoreWindow(window: *Window) Error!void {
    if (!SDL_RestoreWindow(window)) return makeError();
}
extern fn SDL_RestoreWindow(window: *Window) bool;

/// Request that the window's fullscreen state be changed.
///
/// By default a window in fullscreen state uses borderless fullscreen desktop
/// mode, but a specific exclusive display mode can be set using
/// `setWindowFullscreenMode`.
///
/// On some windowing systems this request is asynchronous and the new
/// fullscreen state may not have have been applied immediately upon the return
/// of this function. If an immediate change is required, call `syncWindow`
/// to block until the changes have taken effect.
///
/// When the window state changes, an `EventType.window_enter_fullscreen` or
/// `EventType.window_leave_fullscreen` event will be emitted. Note that, as this
/// is just a request, it can be denied by the windowing system.
pub fn setWindowFullscreen(window: *Window, fullscreen: bool) Error!void {
    if (!SDL_SetWindowFullscreen(window, fullscreen)) return makeError();
}
extern fn SDL_SetWindowFullscreen(window: *Window, fullscreen: bool) bool;

/// Block until any pending window state is finalized.
///
/// On asynchronous windowing systems, this acts as a synchronization barrier
/// for pending window state. It will attempt to wait until any pending window
/// state has been applied and is guaranteed to return within finite time. Note
/// that for how long it can potentially block depends on the underlying window
/// system, as window state changes may involve somewhat lengthy animations
/// that must complete before the window is in its final requested state.
///
/// On windowing systems where changes are immediate, this does nothing.
pub fn syncWindow(window: *Window) Error!void {
    if (!SDL_SyncWindow(window)) return makeError();
}
extern fn SDL_SyncWindow(window: *Window) bool;

/// Return whether the window has a surface associated with it.
pub const windowHasSurface = SDL_WindowHasSurface;
extern fn SDL_WindowHasSurface(window: *Window) bool;

/// Get the SDL surface associated with the window.
///
/// A new surface will be created with the optimal format for the window, if
/// necessary. This surface will be freed when the window is destroyed. Do not
/// free this surface.
///
/// This surface will be invalidated if the window is resized. After resizing a
/// window this function must be called again to return a valid surface.
///
/// You may not combine this with 3D or the rendering API on this window.
///
/// This function is affected by `hint_framebuffer_acceleration`.
pub fn getWindowSurface(window: *Window) Error!*sdl.Surface {
    return SDL_GetWindowSurface(window) orelse makeError();
}
extern fn SDL_GetWindowSurface(window: *Window) ?*sdl.Surface;

/// Toggle VSync for the window surface.
///
/// When a window surface is created, vsync defaults to
/// `window_surface_vsync_disabled`.
///
/// The `vsync` parameter can be 1 to synchronize present with every vertical
/// refresh, 2 to synchronize present with every second vertical refresh, etc.,
/// `window_surface_vsync_adaptive` for late swap tearing (adaptive vsync),
/// or `window_surface_vsync_disabled` to disable. Not every value is
/// supported by every driver, so you should check the return value to see
/// whether the requested setting is supported.
pub fn setWindowSurfaceVSync(window: *Window, vsync: c_int) Error!void {
    if (!SDL_SetWindowSurfaceVSync(window, vsync)) return makeError();
}
extern fn SDL_SetWindowSurfaceVSync(window: *Window, vsync: c_int) bool;

pub const window_surface_vsync_disabled = 0;
pub const window_surface_vsync_adaptive = -1;
/// Get VSync for the window surface.
pub fn getWindowSurfaceVSync(window: *Window) Error!c_int {
    var vsync: c_int = undefined;
    if (!SDL_GetWindowSurfaceVSync(window, &vsync)) return makeError();
    return vsync;
}
extern fn SDL_GetWindowSurfaceVSync(window: *Window, vsync: *c_int) bool;

/// Copy the window surface to the screen.
///
/// This is the function you use to reflect any changes to the surface on the
/// screen.
///
/// This function is equivalent to the SDL 1.2 API `Flip`.
pub fn updateWindowSurface(window: *Window) Error!void {
    if (!SDL_UpdateWindowSurface(window)) return makeError();
}
extern fn SDL_UpdateWindowSurface(window: *Window) bool;

/// Copy areas of the window surface to the screen.
///
/// This is the function you use to reflect changes to portions of the surface
/// on the screen.
///
/// This function is equivalent to the SDL 1.2 API `UpdateRects`.
///
/// Note that this function will update _at least_ the rectangles specified,
/// but this is only intended as an optimization; in practice, this might
/// update more of the screen (or all of the screen!), depending on what method
/// SDL uses to send pixels to the system.
pub fn updateWindowSurfaceRects(window: *Window, rects: []const sdl.Rect) Error!void {
    if (!SDL_UpdateWindowSurfaceRects(window, rects.ptr, @intCast(rects.len))) return makeError();
}
extern fn SDL_UpdateWindowSurfaceRects(window: *Window, rects: [*]const sdl.Rect, numrects: c_int) bool;

/// Destroy the surface associated with the window.
pub fn destroyWindowSurface(window: *Window) Error!void {
    if (!SDL_DestroyWindowSurface(window)) return makeError();
}
extern fn SDL_DestroyWindowSurface(window: *Window) bool;

/// Set a window's keyboard grab mode.
///
/// Keyboard grab enables capture of system keyboard shortcuts like Alt+Tab or
/// the Meta/Super key. Note that not all system keyboard shortcuts can be
/// captured by applications (one example is Ctrl+Alt+Del on Windows).
///
/// This is primarily intended for specialized applications such as VNC clients
/// or VM frontends. Normal games should not use keyboard grab.
///
/// When keyboard grab is enabled, SDL will continue to handle Alt+Tab when the
/// window is full-screen to ensure the user is not trapped in your
/// application. If you have a custom keyboard shortcut to exit fullscreen
/// mode, you may suppress this behavior with
/// `hint_allow_alt_tab_while_grabbed`.
///
/// If the caller enables a grab while another window is currently grabbed, the
/// other window loses its grab in favor of the caller's window.
pub fn setWindowKeyboardGrab(window: *Window, grabbed: bool) Error!void {
    if (!SDL_SetWindowKeyboardGrab(window, grabbed)) return makeError();
}
extern fn SDL_SetWindowKeyboardGrab(window: *Window, grabbed: bool) bool;

/// Set a window's mouse grab mode.
///
/// Mouse grab confines the mouse cursor to the window.
pub fn setWindowMouseGrab(window: *Window, grabbed: bool) Error!void {
    if (!SDL_SetWindowMouseGrab(window, grabbed)) return makeError();
}
extern fn SDL_SetWindowMouseGrab(window: *Window, grabbed: bool) bool;

/// Get a window's keyboard grab mode.
pub const getWindowKeyboardGrab = SDL_GetWindowKeyboardGrab;
extern fn SDL_GetWindowKeyboardGrab(window: *Window) bool;

/// Get a window's mouse grab mode.
pub const getWindowMouseGrab = SDL_GetWindowMouseGrab;
extern fn SDL_GetWindowMouseGrab(window: *Window) bool;

/// Get the window that currently has an input grab enabled.
pub const getGrabbedWindow = SDL_GetGrabbedWindow;
extern fn SDL_GetGrabbedWindow() ?*Window;

/// Confines the cursor to the specified area of a window.
///
/// Note that this does NOT grab the cursor, it only defines the area a cursor
/// is restricted to when the window has mouse focus.
pub fn setWindowMouseRect(window: *Window, rect: ?*const sdl.Rect) Error!void {
    if (!SDL_SetWindowMouseRect(window, rect)) return makeError();
}
extern fn SDL_SetWindowMouseRect(window: *Window, rect: ?*const sdl.Rect) bool;

/// Get the mouse confinement rectangle of a window.
pub const getWindowMouseRect = SDL_GetWindowMouseRect;
extern fn SDL_GetWindowMouseRect(window: *Window) ?*const sdl.Rect;

/// Set the opacity for a window.
///
/// The parameter `opacity` will be clamped internally between 0.0f
/// (transparent) and 1.0f (opaque).
///
/// This function also returns false if setting the opacity isn't supported.
pub fn setWindowOpacity(window: *Window, opacity: f32) Error!void {
    if (!SDL_SetWindowOpacity(window, opacity)) return makeError();
}
extern fn SDL_SetWindowOpacity(window: *Window, opacity: f32) bool;

/// Get the opacity of a window.
///
/// If transparency isn't supported on this platform, opacity will be returned
/// as 1.0f without error.
pub fn getWindowOpacity(window: *Window) Error!f32 {
    const result = SDL_GetWindowOpacity(window);
    if (result < 0) return makeError();
    return result;
}
extern fn SDL_GetWindowOpacity(window: *Window) f32;

/// Set the window as a child of a parent window.
///
/// If the window is already the child of an existing window, it will be
/// reparented to the new owner. Setting the parent window to null unparents
/// the window and removes child window status.
///
/// If a parent window is hidden or destroyed, the operation will be
/// recursively applied to child windows. Child windows hidden with the parent
/// that did not have their hidden status explicitly set will be restored when
/// the parent is shown.
///
/// Attempting to set the parent of a window that is currently in the modal
/// state will fail. Use `setWindowModal` to cancel the modal status before
/// attempting to change the parent.
///
/// Popup windows cannot change parents and attempts to do so will fail.
///
/// Setting a parent window that is currently the sibling or descendent of the
/// child window results in undefined behavior.
pub fn setWindowParent(window: *Window, parent: ?*Window) Error!void {
    if (!SDL_SetWindowParent(window, parent)) return makeError();
}
extern fn SDL_SetWindowParent(window: *Window, parent: ?*Window) bool;

/// Toggle the state of the window as modal.
///
/// To enable modal status on a window, the window must currently be the child
/// window of a parent, or toggling modal status on will fail.
pub fn setWindowModal(window: *Window, modal: bool) Error!void {
    if (!SDL_SetWindowModal(window, modal)) return makeError();
}
extern fn SDL_SetWindowModal(window: *Window, modal: bool) bool;

/// Set whether the window may have input focus.
pub fn setWindowFocusable(window: *Window, focusable: bool) Error!void {
    if (!SDL_SetWindowFocusable(window, focusable)) return makeError();
}
extern fn SDL_SetWindowFocusable(window: *Window, focusable: bool) bool;

/// Display the system-level window menu.
///
/// This default window menu is provided by the system and on some platforms
/// provides functionality for setting or changing privileged state on the
/// window, such as moving it between workspaces or displays, or toggling the
/// always-on-top property.
///
/// On platforms or desktops where this is unsupported, this function does
/// nothing.
pub fn showWindowSystemMenu(window: *Window, x: c_int, y: c_int) Error!void {
    if (!SDL_ShowWindowSystemMenu(window, x, y)) return makeError();
}
extern fn SDL_ShowWindowSystemMenu(window: *Window, x: c_int, y: c_int) bool;

/// Possible return values from the `HitTest` callback.
pub const HitTestResult = enum(c_int) {
    /// Region is normal. No special properties.
    normal,
    /// Region can drag entire window.
    draggable,
    /// Region is the resizable top-left corner border.
    resize_topleft,
    /// Region is the resizable top border.
    resize_top,
    /// Region is the resizable top-right corner border.
    resize_topright,
    /// Region is the resizable right border.
    resize_right,
    /// Region is the resizable bottom-right corner border.
    resize_bottomright,
    /// Region is the resizable bottom border.
    resize_bottom,
    /// Region is the resizable bottom-left corner border.
    resize_bottomleft,
    /// Region is the resizable left border.
    resize_left,
};

/// Callback used for hit-testing.
pub const HitTest = *const fn (win: *Window, area: *const sdl.Point, data: ?*anyopaque) callconv(.c) HitTestResult;

/// Provide a callback that decides if a window region has special properties.
///
/// Normally windows are dragged and resized by decorations provided by the
/// system window manager (a title bar, borders, etc), but for some apps, it
/// makes sense to drag them from somewhere else inside the window itself; for
/// example, one might have a borderless window that wants to be draggable from
/// any part, or simulate its own title bar, etc.
///
/// This function lets the app provide a callback that designates pieces of a
/// given window as special. This callback is run during event processing if we
/// need to tell the OS to treat a region of the window specially; the use of
/// this callback is known as "hit testing."
///
/// Mouse input may not be delivered to your application if it is within a
/// special area; the OS will often apply that input to moving the window or
/// resizing the window and not deliver it to the application.
///
/// Specifying null for a callback disables hit-testing. Hit-testing is
/// disabled by default.
///
/// Platforms that don't support this functionality will return false
/// unconditionally, even if you're attempting to disable hit-testing.
///
/// Your callback may fire at any time, and its firing does not indicate any
/// specific behavior (for example, on Windows, this certainly might fire when
/// the OS is deciding whether to drag your window, but it fires for lots of
/// other reasons, too, some unrelated to anything you probably care about _and
/// when the mouse isn't actually at the location it is testing_). Since this
/// can fire at any time, you should try to keep your callback efficient,
/// devoid of allocations, etc.
pub fn setWindowHitTest(window: *Window, callback: ?HitTest, callback_data: ?*anyopaque) Error!void {
    if (!SDL_SetWindowHitTest(window, callback, callback_data)) return makeError();
}
extern fn SDL_SetWindowHitTest(window: *Window, callback: ?HitTest, callback_data: ?*anyopaque) bool;

/// Set the shape of a transparent window.
///
/// This sets the alpha channel of a transparent window and any fully
/// transparent areas are also transparent to mouse clicks. If you are using
/// something besides the SDL render API, then you are responsible for drawing
/// the alpha channel of the window to match the shape alpha channel to get
/// consistent cross-platform results.
///
/// The shape is copied inside this function, so you can free it afterwards. If
/// your shape surface changes, you should call `setWindowShape` again to
/// update the window. This is an expensive operation, so should be done
/// sparingly.
///
/// The window must have been created with the `WindowFlags.transparent` flag.
pub fn setWindowShape(window: *Window, shape: ?*sdl.Surface) Error!void {
    if (!SDL_SetWindowShape(window, shape)) return makeError();
}
extern fn SDL_SetWindowShape(window: *Window, shape: ?*sdl.Surface) bool;

/// Request a window to demand attention from the user.
pub fn flashWindow(window: *Window, operation: FlashOperation) Error!void {
    if (!SDL_FlashWindow(window, operation)) return makeError();
}
extern fn SDL_FlashWindow(window: *Window, operation: FlashOperation) bool;

/// Sets the state of the progress bar for the given window’s taskbar icon.
pub fn setWindowProgressState(window: *Window, state: ProgressState) Error!void {
    if (!SDL_SetWindowProgressState(window, state)) return makeError();
}
extern fn SDL_SetWindowProgressState(window: *Window, state: ProgressState) bool;

/// Get the state of the progress bar for the given window’s taskbar icon.
pub fn getWindowProgressState(window: *Window) Error!ProgressState {
    const result = SDL_GetWindowProgressState(window);
    if (result == .invalid) return makeError();
    return result;
}
extern fn SDL_GetWindowProgressState(window: *Window) ProgressState;

/// Sets the value of the progress bar for the given window’s taskbar icon.
pub fn setWindowProgressValue(window: *Window, value: f32) Error!void {
    if (!SDL_SetWindowProgressValue(window, value)) return makeError();
}
extern fn SDL_SetWindowProgressValue(window: *Window, value: f32) bool;

/// Get the value of the progress bar for the given window’s taskbar icon.
pub fn getWindowProgressValue(window: *Window) Error!f32 {
    const result = SDL_GetWindowProgressValue(window);
    if (result < 0) return makeError();
    return result;
}
extern fn SDL_GetWindowProgressValue(window: *Window) f32;

/// Destroy a window.
///
/// Any child windows owned by the window will be recursively destroyed as
/// well.
///
/// Note that on some platforms, the visible window may not actually be removed
/// from the screen until the SDL event loop is pumped again, even though the
/// `Window` is no longer valid after this call.
pub const destroyWindow = SDL_DestroyWindow;
extern fn SDL_DestroyWindow(window: *Window) void;

/// Check whether the screensaver is currently enabled.
///
/// The screensaver is disabled by default.
///
/// The default can also be changed using `hint_video_allow_screensaver`.
pub const screenSaverEnabled = SDL_ScreenSaverEnabled;
extern fn SDL_ScreenSaverEnabled() bool;

/// Allow the screen to be blanked by a screen saver.
pub fn enableScreenSaver() Error!void {
    if (!SDL_EnableScreenSaver()) return makeError();
}
extern fn SDL_EnableScreenSaver() bool;

/// Prevent the screen from being blanked by a screen saver.
///
/// If you disable the screensaver, it is automatically re-enabled when SDL
/// quits.
///
/// The screensaver is disabled by default, but this may by changed by
/// `hint_video_allow_screensaver`.
pub fn disableScreenSaver() Error!void {
    if (!SDL_DisableScreenSaver()) return makeError();
}
extern fn SDL_DisableScreenSaver() bool;
