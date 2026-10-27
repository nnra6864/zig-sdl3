//! Metal Support (SDL_metal.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");

/// A handle to a CAMetalLayer-backed NSView (macOS) or UIView (iOS/tvOS).
pub const MetalView = *anyopaque;

pub const metal = struct {
    /// Create a CAMetalLayer-backed NSView/UIView and attach it to the specified
    /// window.
    ///
    /// On macOS, this does *not* associate a MTLDevice with the CAMetalLayer on
    /// its own. It is up to user code to do that.
    ///
    /// The returned handle can be casted directly to a NSView or UIView. To access
    /// the backing CAMetalLayer, call `metal.getLayer`.
    pub const createView = SDL_Metal_CreateView;
    extern fn SDL_Metal_CreateView(window: *sdl.Window) ?MetalView;

    /// Destroy an existing `MetalView` object.
    ///
    /// This should be called before `destroyWindow`, if `metal.createView` was
    /// called after `createWindow`.
    pub const destroyView = SDL_Metal_DestroyView;
    extern fn SDL_Metal_DestroyView(view: MetalView) void;

    /// Get a pointer to the backing CAMetalLayer for the given view.
    pub const getLayer = SDL_Metal_GetLayer;
    extern fn SDL_Metal_GetLayer(view: MetalView) ?*anyopaque;
};
