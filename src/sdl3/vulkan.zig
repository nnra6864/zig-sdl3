//! Vulkan Support (SDL_vulkan.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

pub const vk = struct {
    /// A generic function pointer, as returned by `vk.getVkGetInstanceProcAddr`.
    pub const FunctionPointer = ?*const anyopaque;

    /// A `VkInstance` handle.
    pub const Instance = enum(usize) { null_handle = 0, _ };
    /// A `VkPhysicalDevice` handle.
    pub const PhysicalDevice = enum(usize) { null_handle = 0, _ };
    /// A `VkSurfaceKHR` handle (non-dispatchable, always 64 bits).
    pub const SurfaceKHR = enum(u64) { null_handle = 0, _ };
    /// `VkAllocationCallbacks`, opaque to SDL.
    pub const AllocationCallbacks = anyopaque;

    /// Dynamically load the Vulkan loader library.
    ///
    /// This should be called after initializing the video driver, but before
    /// creating any Vulkan windows. If no Vulkan loader library is loaded, the
    /// default library will be loaded upon creation of the first Vulkan window.
    ///
    /// SDL keeps a counter of how many times this function has been successfully
    /// called, so it is safe to call this function multiple times, so long as it
    /// is eventually paired with an equivalent number of calls to
    /// `vk.unloadLibrary`. The `path` argument is ignored unless there is no
    /// library currently loaded, and and the library isn't actually unloaded until
    /// there have been an equivalent number of calls to `vk.unloadLibrary`.
    ///
    /// It is fairly common for Vulkan applications to link with libvulkan instead
    /// of explicitly loading it at run time. This will work with SDL provided the
    /// application links to a dynamic library and both it and SDL use the same
    /// search path.
    ///
    /// If you specify a non-null `path`, an application should retrieve all of the
    /// Vulkan functions it uses from the dynamic library using
    /// `vk.getVkGetInstanceProcAddr` unless you can guarantee `path` points
    /// to the same vulkan loader library the application linked to.
    ///
    /// On Apple devices, if `path` is null, SDL will attempt to find the
    /// `vkGetInstanceProcAddr` address within all the Mach-O images of the current
    /// process. This is because it is fairly common for Vulkan applications to
    /// link with libvulkan (and historically MoltenVK was provided as a static
    /// library). If it is not found, on macOS, SDL will attempt to load
    /// `vulkan.framework/vulkan`, `libvulkan.1.dylib`,
    /// `MoltenVK.framework/MoltenVK`, and `libMoltenVK.dylib`, in that order. On
    /// iOS, SDL will attempt to load `libMoltenVK.dylib`. Applications using a
    /// dynamic framework or .dylib must ensure it is included in its application
    /// bundle.
    ///
    /// On non-Apple devices, application linking with a static libvulkan is not
    /// supported. Either do not link to the Vulkan loader or link to a dynamic
    /// library version.
    pub fn loadLibrary(path: ?[:0]const u8) Error!void {
        if (!SDL_Vulkan_LoadLibrary(if (path) |s| s.ptr else null)) return makeError();
    }
    extern fn SDL_Vulkan_LoadLibrary(path: ?[*:0]const u8) bool;

    /// Get the address of the `vkGetInstanceProcAddr` function.
    ///
    /// This should be called after either calling `vk.loadLibrary` or
    /// creating a `Window` with the `WindowFlags.vulkan` flag.
    ///
    /// The actual type of the returned function pointer is
    /// PFN_vkGetInstanceProcAddr, but that isn't available because the Vulkan
    /// headers are not included here. You should cast the return value of this
    /// function to that type, e.g.
    ///
    /// `vkGetInstanceProcAddr =
    /// (PFN_vkGetInstanceProcAddr)`vk.getVkGetInstanceProcAddr`;`
    pub fn getVkGetInstanceProcAddr() Error!*const anyopaque {
        return SDL_Vulkan_GetVkGetInstanceProcAddr() orelse makeError();
    }
    extern fn SDL_Vulkan_GetVkGetInstanceProcAddr() FunctionPointer;

    /// Unload the Vulkan library previously loaded by `vk.loadLibrary`.
    ///
    /// SDL keeps a counter of how many times this function has been called, so it
    /// is safe to call this function multiple times, so long as it is paired with
    /// an equivalent number of calls to `vk.loadLibrary`. The library isn't
    /// actually unloaded until there have been an equivalent number of calls to
    /// `vk.unloadLibrary`.
    ///
    /// Once the library has actually been unloaded, if any Vulkan instances
    /// remain, they will likely crash the program. Clean up any existing Vulkan
    /// resources, and destroy appropriate windows, renderers and GPU devices
    /// before calling this function.
    pub const unloadLibrary = SDL_Vulkan_UnloadLibrary;
    extern fn SDL_Vulkan_UnloadLibrary() void;

    /// Get the Vulkan instance extensions needed for vkCreateInstance.
    ///
    /// This should be called after either calling `vk.loadLibrary` or
    /// creating a `Window` with the `WindowFlags.vulkan` flag.
    ///
    /// On return, the variable pointed to by `count` will be set to the number of
    /// elements returned, suitable for using with
    /// InstanceCreateInfo::enabledExtensionCount, and the returned array can be
    /// used with InstanceCreateInfo::ppEnabledExtensionNames, for calling
    /// Vulkan's vkCreateInstance API.
    ///
    /// You should not free the returned array; it is owned by SDL.
    pub fn getInstanceExtensions() Error![][*:0]const u8 {
        var count: u32 = undefined;
        const ptr = SDL_Vulkan_GetInstanceExtensions(&count) orelse return makeError();
        return ptr[0..@intCast(count)];
    }
    extern fn SDL_Vulkan_GetInstanceExtensions(count: ?*u32) ?[*][*:0]const u8;

    /// Create a Vulkan rendering surface for a window.
    ///
    /// The `window` must have been created with the `WindowFlags.vulkan` flag and
    /// `instance` must have been created with extensions returned by
    /// `vk.getInstanceExtensions` enabled.
    ///
    /// If `allocator` is null, Vulkan will use the system default allocator. This
    /// argument is passed directly to Vulkan and isn't used by SDL itself.
    pub fn createSurface(window: *sdl.Window, instance: Instance, allocator: ?*const AllocationCallbacks) Error!SurfaceKHR {
        var surface: SurfaceKHR = undefined;
        if (!SDL_Vulkan_CreateSurface(window, instance, allocator, &surface)) return makeError();
        return surface;
    }
    extern fn SDL_Vulkan_CreateSurface(window: *sdl.Window, instance: Instance, allocator: ?*const AllocationCallbacks, surface: *SurfaceKHR) bool;

    /// Destroy the Vulkan rendering surface of a window.
    ///
    /// This should be called before `destroyWindow`, if `vk.createSurface`
    /// was called after `createWindow`.
    ///
    /// The `instance` must have been created with extensions returned by
    /// `vk.getInstanceExtensions` enabled and `surface` must have been
    /// created successfully by a `vk.createSurface` call.
    ///
    /// If `allocator` is null, Vulkan will use the system default allocator. This
    /// argument is passed directly to Vulkan and isn't used by SDL itself.
    pub const destroySurface = SDL_Vulkan_DestroySurface;
    extern fn SDL_Vulkan_DestroySurface(instance: Instance, surface: SurfaceKHR, allocator: ?*const AllocationCallbacks) void;

    /// Query support for presentation via a given physical device and queue
    /// family.
    ///
    /// The `instance` must have been created with extensions returned by
    /// `vk.getInstanceExtensions` enabled.
    pub const getPresentationSupport = SDL_Vulkan_GetPresentationSupport;
    extern fn SDL_Vulkan_GetPresentationSupport(instance: Instance, physicalDevice: PhysicalDevice, queueFamilyIndex: u32) bool;
};
