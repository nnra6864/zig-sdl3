//! 2D Accelerated Rendering (SDL_render.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// The name of the software renderer.
pub const software_renderer = "software";

/// The name of the GPU renderer.
pub const gpu_renderer = "gpu";

/// Vertex structure.
pub const Vertex = extern struct {
    /// Vertex position, in `Renderer` coordinates
    position: sdl.FPoint,
    /// Vertex color
    color: sdl.FColor,
    /// Normalized texture coordinates, if needed
    tex_coord: sdl.FPoint,
};

/// The access pattern allowed for a texture.
pub const TextureAccess = enum(c_int) {
    /// Changes rarely, not lockable
    static,
    /// Changes frequently, lockable
    streaming,
    /// Texture can be used as a render target
    target,
};

/// The addressing mode for a texture when used in `renderGeometry`.
///
/// This affects how texture coordinates are interpreted outside of [0, 1]
///
/// Texture wrapping is always supported for power of two texture sizes, and is
/// supported for other texture sizes if
/// `Renderer.Properties.texture_wrapping_boolean` is set to true.
pub const TextureAddressMode = enum(c_int) {
    invalid = -1,
    /// Wrapping is enabled if texture coordinates are outside [0, 1], this is the default
    auto,
    /// Texture coordinates are clamped to the [0, 1] range
    clamp,
    /// The texture is repeated (tiled)
    wrap,
};

/// How the logical size is mapped to the output.
pub const RendererLogicalPresentation = enum(c_int) {
    /// There is no logical size in effect
    disabled,
    /// The rendered content is stretched to the output resolution
    stretch,
    /// The rendered content is fit to the largest dimension and the other dimension is letterboxed with the clear color
    letterbox,
    /// The rendered content is fit to the smallest dimension and the other dimension extends beyond the output bounds
    overscan,
    /// The rendered content is scaled up by integer multiples to fit the output resolution
    integer_scale,
};

/// A structure representing rendering state
pub const Renderer = opaque {
    pub const Properties = struct {
        pub const create_name_string = "SDL.renderer.create.name";
        pub const create_window_pointer = "SDL.renderer.create.window";
        pub const create_surface_pointer = "SDL.renderer.create.surface";
        pub const create_output_colorspace_number = "SDL.renderer.create.output_colorspace";
        pub const create_present_vsync_number = "SDL.renderer.create.present_vsync";
        pub const create_gpu_device_pointer = "SDL.renderer.create.gpu.device";
        pub const create_gpu_shaders_spirv_boolean = "SDL.renderer.create.gpu.shaders_spirv";
        pub const create_gpu_shaders_dxil_boolean = "SDL.renderer.create.gpu.shaders_dxil";
        pub const create_gpu_shaders_msl_boolean = "SDL.renderer.create.gpu.shaders_msl";
        pub const create_vulkan_instance_pointer = "SDL.renderer.create.vulkan.instance";
        pub const create_vulkan_surface_number = "SDL.renderer.create.vulkan.surface";
        pub const create_vulkan_physical_device_pointer = "SDL.renderer.create.vulkan.physical_device";
        pub const create_vulkan_device_pointer = "SDL.renderer.create.vulkan.device";
        pub const create_vulkan_graphics_queue_family_index_number = "SDL.renderer.create.vulkan.graphics_queue_family_index";
        pub const create_vulkan_present_queue_family_index_number = "SDL.renderer.create.vulkan.present_queue_family_index";
        pub const name_string = "SDL.renderer.name";
        pub const window_pointer = "SDL.renderer.window";
        pub const surface_pointer = "SDL.renderer.surface";
        pub const vsync_number = "SDL.renderer.vsync";
        pub const max_texture_size_number = "SDL.renderer.max_texture_size";
        pub const texture_formats_pointer = "SDL.renderer.texture_formats";
        pub const texture_wrapping_boolean = "SDL.renderer.texture_wrapping";
        pub const output_colorspace_number = "SDL.renderer.output_colorspace";
        pub const hdr_enabled_boolean = "SDL.renderer.HDR_enabled";
        pub const sdr_white_point_float = "SDL.renderer.SDR_white_point";
        pub const hdr_headroom_float = "SDL.renderer.HDR_headroom";
        pub const d3d9_device_pointer = "SDL.renderer.d3d9.device";
        pub const d3d11_device_pointer = "SDL.renderer.d3d11.device";
        pub const d3d11_swapchain_pointer = "SDL.renderer.d3d11.swap_chain";
        pub const d3d12_device_pointer = "SDL.renderer.d3d12.device";
        pub const d3d12_swapchain_pointer = "SDL.renderer.d3d12.swap_chain";
        pub const d3d12_command_queue_pointer = "SDL.renderer.d3d12.command_queue";
        pub const vulkan_instance_pointer = "SDL.renderer.vulkan.instance";
        pub const vulkan_surface_number = "SDL.renderer.vulkan.surface";
        pub const vulkan_physical_device_pointer = "SDL.renderer.vulkan.physical_device";
        pub const vulkan_device_pointer = "SDL.renderer.vulkan.device";
        pub const vulkan_graphics_queue_family_index_number = "SDL.renderer.vulkan.graphics_queue_family_index";
        pub const vulkan_present_queue_family_index_number = "SDL.renderer.vulkan.present_queue_family_index";
        pub const vulkan_swapchain_image_count_number = "SDL.renderer.vulkan.swapchain_image_count";
        pub const gpu_device_pointer = "SDL.renderer.gpu.device";
    };
    pub const create = createRenderer;
    pub const createWithProperties = createRendererWithProperties;
    pub const getDevice = getGPURendererDevice;
    pub const createSoftware = createSoftwareRenderer;
    pub const get = getRenderer;
    pub const getWindow = getRenderWindow;
    pub const getName = getRendererName;
    pub const getProperties = getRendererProperties;
    pub const getOutputSize = getRenderOutputSize;
    pub const getCurrentOutputSize = getCurrentRenderOutputSize;
    pub const getFromTexture = getRendererFromTexture;
    pub const setTarget = setRenderTarget;
    pub const getTarget = getRenderTarget;
    pub const setLogicalPresentation = setRenderLogicalPresentation;
    pub const getLogicalPresentation = getRenderLogicalPresentation;
    pub const getLogicalPresentationRect = getRenderLogicalPresentationRect;
    pub const coordinatesFromWindow = renderCoordinatesFromWindow;
    pub const coordinatesToWindow = renderCoordinatesToWindow;
    pub const convertEventToCoordinates = convertEventToRenderCoordinates;
    pub const setViewport = setRenderViewport;
    pub const getViewport = getRenderViewport;
    pub const viewportSet = renderViewportSet;
    pub const getSafeArea = getRenderSafeArea;
    pub const setClipRect = setRenderClipRect;
    pub const getClipRect = getRenderClipRect;
    pub const clipEnabled = renderClipEnabled;
    pub const setScale = setRenderScale;
    pub const getScale = getRenderScale;
    pub const setDrawColor = setRenderDrawColor;
    pub const setDrawColorFloat = setRenderDrawColorFloat;
    pub const getDrawColor = getRenderDrawColor;
    pub const getDrawColorFloat = getRenderDrawColorFloat;
    pub const setColorScale = setRenderColorScale;
    pub const getColorScale = getRenderColorScale;
    pub const setDrawBlendMode = setRenderDrawBlendMode;
    pub const getDrawBlendMode = getRenderDrawBlendMode;
    pub const clear = renderClear;
    pub const point = renderPoint;
    pub const points = renderPoints;
    pub const line = renderLine;
    pub const lines = renderLines;
    pub const rect = renderRect;
    pub const rects = renderRects;
    pub const fillRect = renderFillRect;
    pub const fillRects = renderFillRects;
    pub const texture = renderTexture;
    pub const textureRotated = renderTextureRotated;
    pub const textureAffine = renderTextureAffine;
    pub const textureTiled = renderTextureTiled;
    pub const texture9Grid = renderTexture9Grid;
    pub const texture9GridTiled = renderTexture9GridTiled;
    pub const geometry = renderGeometry;
    pub const geometryRaw = renderGeometryRaw;
    pub const setTextureAddressMode = setRenderTextureAddressMode;
    pub const getTextureAddressMode = getRenderTextureAddressMode;
    pub const readPixels = renderReadPixels;
    pub const present = renderPresent;
    pub const destroy = destroyRenderer;
    pub const flush = flushRenderer;
    pub const getMetalLayer = getRenderMetalLayer;
    pub const getMetalCommandEncoder = getRenderMetalCommandEncoder;
    pub const addVulkanSemaphores = addVulkanRenderSemaphores;
    pub const setVSync = setRenderVSync;
    pub const getVSync = getRenderVSync;
    pub const debugText = renderDebugText;
    pub const debugTextFormat = renderDebugTextFormat;
    pub const setDefaultScaleMode = setDefaultTextureScaleMode;
    pub const getDefaultScaleMode = getDefaultTextureScaleMode;
    pub const createGPUState = createGPURenderState;
    pub const setGPUState = setGPURenderState;
};

pub const Texture = extern struct {
    /// The format of the texture, read-only
    format: sdl.PixelFormat,
    /// The width of the texture, read-only.
    w: c_int,
    /// The height of the texture, read-only.
    h: c_int,
    /// Application reference count, used when freeing texture
    refcount: c_int,

    pub const Properties = struct {
        pub const create_colorspace_number = "SDL.texture.create.colorspace";
        pub const create_format_number = "SDL.texture.create.format";
        pub const create_access_number = "SDL.texture.create.access";
        pub const create_width_number = "SDL.texture.create.width";
        pub const create_height_number = "SDL.texture.create.height";
        pub const create_palette_pointer = "SDL.texture.create.palette";
        pub const create_sdr_white_point_float = "SDL.texture.create.SDR_white_point";
        pub const create_hdr_headroom_float = "SDL.texture.create.HDR_headroom";
        pub const create_d3d11_texture_pointer = "SDL.texture.create.d3d11.texture";
        pub const create_d3d11_texture_u_pointer = "SDL.texture.create.d3d11.texture_u";
        pub const create_d3d11_texture_v_pointer = "SDL.texture.create.d3d11.texture_v";
        pub const create_d3d12_texture_pointer = "SDL.texture.create.d3d12.texture";
        pub const create_d3d12_texture_u_pointer = "SDL.texture.create.d3d12.texture_u";
        pub const create_d3d12_texture_v_pointer = "SDL.texture.create.d3d12.texture_v";
        pub const create_metal_pixelbuffer_pointer = "SDL.texture.create.metal.pixelbuffer";
        pub const create_opengl_texture_number = "SDL.texture.create.opengl.texture";
        pub const create_opengl_texture_uv_number = "SDL.texture.create.opengl.texture_uv";
        pub const create_opengl_texture_u_number = "SDL.texture.create.opengl.texture_u";
        pub const create_opengl_texture_v_number = "SDL.texture.create.opengl.texture_v";
        pub const create_opengles2_texture_number = "SDL.texture.create.opengles2.texture";
        pub const create_opengles2_texture_uv_number = "SDL.texture.create.opengles2.texture_uv";
        pub const create_opengles2_texture_u_number = "SDL.texture.create.opengles2.texture_u";
        pub const create_opengles2_texture_v_number = "SDL.texture.create.opengles2.texture_v";
        pub const create_vulkan_texture_number = "SDL.texture.create.vulkan.texture";
        pub const create_vulkan_layout_number = "SDL.texture.create.vulkan.layout";
        pub const create_gpu_texture_pointer = "SDL.texture.create.gpu.texture";
        pub const create_gpu_texture_uv_pointer = "SDL.texture.create.gpu.texture_uv";
        pub const create_gpu_texture_u_pointer = "SDL.texture.create.gpu.texture_u";
        pub const create_gpu_texture_v_pointer = "SDL.texture.create.gpu.texture_v";
        pub const colorspace_number = "SDL.texture.colorspace";
        pub const format_number = "SDL.texture.format";
        pub const width_number = "SDL.texture.width";
        pub const height_number = "SDL.texture.height";
        pub const sdr_white_point_float = "SDL.texture.SDR_white_point";
        pub const hdr_headroom_float = "SDL.texture.HDR_headroom";
        pub const d3d11_texture_pointer = "SDL.texture.d3d11.texture";
        pub const d3d11_texture_u_pointer = "SDL.texture.d3d11.texture_u";
        pub const d3d11_texture_v_pointer = "SDL.texture.d3d11.texture_v";
        pub const d3d12_texture_pointer = "SDL.texture.d3d12.texture";
        pub const d3d12_texture_u_pointer = "SDL.texture.d3d12.texture_u";
        pub const d3d12_texture_v_pointer = "SDL.texture.d3d12.texture_v";
        pub const opengl_texture_number = "SDL.texture.opengl.texture";
        pub const opengl_texture_uv_number = "SDL.texture.opengl.texture_uv";
        pub const opengl_texture_u_number = "SDL.texture.opengl.texture_u";
        pub const opengl_texture_v_number = "SDL.texture.opengl.texture_v";
        pub const opengl_texture_target_number = "SDL.texture.opengl.target";
        pub const opengl_tex_w_float = "SDL.texture.opengl.tex_w";
        pub const opengl_tex_h_float = "SDL.texture.opengl.tex_h";
        pub const opengles2_texture_number = "SDL.texture.opengles2.texture";
        pub const opengles2_texture_uv_number = "SDL.texture.opengles2.texture_uv";
        pub const opengles2_texture_u_number = "SDL.texture.opengles2.texture_u";
        pub const opengles2_texture_v_number = "SDL.texture.opengles2.texture_v";
        pub const opengles2_texture_target_number = "SDL.texture.opengles2.target";
        pub const vulkan_texture_number = "SDL.texture.vulkan.texture";
        pub const gpu_texture_pointer = "SDL.texture.gpu.texture";
        pub const gpu_texture_uv_pointer = "SDL.texture.gpu.texture_uv";
        pub const gpu_texture_u_pointer = "SDL.texture.gpu.texture_u";
        pub const gpu_texture_v_pointer = "SDL.texture.gpu.texture_v";
    };
    pub const create = createTexture;
    pub const createFromSurface = createTextureFromSurface;
    pub const createWithProperties = createTextureWithProperties;
    pub const getProperties = getTextureProperties;
    pub const getRendererFrom = getRendererFromTexture;
    pub const getSize = getTextureSize;
    pub const setPalette = setTexturePalette;
    pub const getPalette = getTexturePalette;
    pub const setColorMod = setTextureColorMod;
    pub const setColorModFloat = setTextureColorModFloat;
    pub const getColorMod = getTextureColorMod;
    pub const getColorModFloat = getTextureColorModFloat;
    pub const setAlphaMod = setTextureAlphaMod;
    pub const setAlphaModFloat = setTextureAlphaModFloat;
    pub const getAlphaMod = getTextureAlphaMod;
    pub const getAlphaModFloat = getTextureAlphaModFloat;
    pub const setBlendMode = setTextureBlendMode;
    pub const getBlendMode = getTextureBlendMode;
    pub const setScaleMode = setTextureScaleMode;
    pub const getScaleMode = getTextureScaleMode;
    pub const update = updateTexture;
    pub const updateYUV = updateYUVTexture;
    pub const updateNV = updateNVTexture;
    pub const lock = lockTexture;
    pub const lockToSurface = lockTextureToSurface;
    pub const unlock = unlockTexture;
    pub const destroy = destroyTexture;
};

/// Get the number of 2D rendering drivers available for the current display.
///
/// A render driver is a set of code that handles rendering and texture
/// management on a particular display. Normally there is only one, but some
/// drivers may have several available with different capabilities.
///
/// There may be none if SDL was compiled without render support.
pub const getNumRenderDrivers = SDL_GetNumRenderDrivers;
extern fn SDL_GetNumRenderDrivers() c_int;

/// Use this function to get the name of a built in 2D rendering driver.
///
/// The list of rendering drivers is given in the order that they are normally
/// initialized by default; the drivers that seem more reasonable to choose
/// first (as far as the SDL developers believe) are earlier in the list.
///
/// The names of drivers are all simple, low-ASCII identifiers, like "opengl",
/// "direct3d12" or "metal". These never have Unicode characters, and are not
/// meant to be proper names.
pub fn getRenderDriver(index: c_int) ?[:0]const u8 {
    const str = SDL_GetRenderDriver(index) orelse return null;
    return std.mem.span(str);
}
extern fn SDL_GetRenderDriver(index: c_int) ?[*:0]const u8;

/// Create a window and default renderer.
pub fn createWindowAndRenderer(
    title: [:0]const u8,
    width: c_int,
    height: c_int,
    window_flags: sdl.WindowFlags,
) Error!struct { window: *sdl.Window, renderer: *Renderer } {
    var window: *sdl.Window = undefined;
    var renderer: *Renderer = undefined;
    if (!SDL_CreateWindowAndRenderer(title.ptr, width, height, window_flags, &window, &renderer)) return makeError();
    return .{ .window = window, .renderer = renderer };
}
extern fn SDL_CreateWindowAndRenderer(title: [*:0]const u8, width: c_int, height: c_int, window_flags: sdl.WindowFlags, window: **sdl.Window, renderer: **Renderer) bool;

/// Create a 2D rendering context for a window.
///
/// If you want a specific renderer, you can specify its name here. A list of
/// available renderers can be obtained by calling `getRenderDriver`
/// multiple times, with indices from 0 to `getNumRenderDrivers`-1. If you
/// don't need a specific renderer, specify null and SDL will attempt to choose
/// the best option for you, based on what is available on the user's system.
///
/// If `name` is a comma-separated list, SDL will try each name, in the order
/// listed, until one succeeds or all of them fail.
///
/// By default the rendering size matches the window size in pixels, but you
/// can call `setRenderLogicalPresentation` to change the content size and
/// scaling options.
pub fn createRenderer(window: *sdl.Window, name: ?[:0]const u8) Error!*Renderer {
    return SDL_CreateRenderer(window, if (name) |s| s.ptr else null) orelse makeError();
}
extern fn SDL_CreateRenderer(window: *sdl.Window, name: ?[*:0]const u8) ?*Renderer;

/// Create a 2D rendering context for a window, with the specified properties.
///
/// These are the supported properties:
///
/// - `Renderer.Properties.create_name_string`: the name of the rendering driver
///   to use, if a specific one is desired
/// - `Renderer.Properties.create_window_pointer`: the window where rendering is
///   displayed, required if this isn't a software renderer using a surface
/// - `Renderer.Properties.create_surface_pointer`: the surface where rendering
///   is displayed, if you want a software renderer without a window
/// - `Renderer.Properties.create_output_colorspace_number`: a `Colorspace`
///   value describing the colorspace for output to the display, defaults to
///   `Colorspace.srgb`. The direct3d11, direct3d12, and metal renderers
///   support `Colorspace.srgb_linear`, which is a linear color space and
///   supports HDR output. If you select `Colorspace.srgb_linear`, drawing
///   still uses the sRGB colorspace, but values can go beyond 1.0 and float
///   (linear) format textures can be used for HDR content.
/// - `Renderer.Properties.create_present_vsync_number`: non-zero if you want
///   present synchronized with the refresh rate. This property can take any
///   value that is supported by `setRenderVSync` for the renderer.
///
/// With the SDL GPU renderer:
///
/// - `Renderer.Properties.create_gpu_device_pointer`: the device to use with the
///   renderer, optional.
/// - `Renderer.Properties.create_gpu_shaders_spirv_boolean`: the app is able to
///   provide SPIR-V shaders to `GPURenderState`, optional.
/// - `Renderer.Properties.create_gpu_shaders_dxil_boolean`: the app is able to
///   provide DXIL shaders to `GPURenderState`, optional.
/// - `Renderer.Properties.create_gpu_shaders_msl_boolean`: the app is able to
///   provide MSL shaders to `GPURenderState`, optional.
///
/// With the vulkan renderer:
///
/// - `Renderer.Properties.create_vulkan_instance_pointer`: the VkInstance to use
///   with the renderer, optional.
/// - `Renderer.Properties.create_vulkan_surface_number`: the VkSurfaceKHR to use
///   with the renderer, optional.
/// - `Renderer.Properties.create_vulkan_physical_device_pointer`: the
///   VkPhysicalDevice to use with the renderer, optional.
/// - `Renderer.Properties.create_vulkan_device_pointer`: the VkDevice to use
///   with the renderer, optional.
/// - `Renderer.Properties.create_vulkan_graphics_queue_family_index_number`: the
///   queue family index used for rendering.
/// - `Renderer.Properties.create_vulkan_present_queue_family_index_number`: the
///   queue family index used for presentation.
pub fn createRendererWithProperties(props: sdl.PropertiesId) Error!*Renderer {
    return SDL_CreateRendererWithProperties(props) orelse makeError();
}
extern fn SDL_CreateRendererWithProperties(props: sdl.PropertiesId) ?*Renderer;

/// Create a 2D GPU rendering context.
///
/// The GPU device to use is passed in as a parameter. If this is null, then a
/// device will be created normally and can be retrieved using
/// `getGPURendererDevice`.
///
/// The window to use is passed in as a parameter. If this is null, then this
/// will become an offscreen renderer. In that case, you should call
/// `setRenderTarget` to setup rendering to a texture, and then call
/// `renderPresent` normally to complete drawing a frame.
pub fn createGPURenderer(device: ?*sdl.GPUDevice, window: ?*sdl.Window) Error!*Renderer {
    return SDL_CreateGPURenderer(device, window) orelse makeError();
}
extern fn SDL_CreateGPURenderer(device: ?*sdl.GPUDevice, window: ?*sdl.Window) ?*Renderer;

/// Return the GPU device used by a renderer.
pub const getGPURendererDevice = SDL_GetGPURendererDevice;
extern fn SDL_GetGPURendererDevice(renderer: *Renderer) ?*sdl.GPUDevice;

/// Create a 2D software rendering context for a surface.
///
/// Two other APIs which can be used to create `Renderer`:
/// `createRenderer` and `createWindowAndRenderer`. These can _also_
/// create a software renderer, but they are intended to be used with an
/// `Window` as the final destination and not a `Surface`.
pub fn createSoftwareRenderer(surface: *sdl.Surface) Error!*Renderer {
    return SDL_CreateSoftwareRenderer(surface) orelse makeError();
}
extern fn SDL_CreateSoftwareRenderer(surface: *sdl.Surface) ?*Renderer;

/// Get the renderer associated with a window.
pub fn getRenderer(window: *sdl.Window) Error!*Renderer {
    return SDL_GetRenderer(window) orelse makeError();
}
extern fn SDL_GetRenderer(window: *sdl.Window) ?*Renderer;

/// Get the window associated with a renderer.
pub fn getRenderWindow(renderer: *Renderer) Error!*sdl.Window {
    return SDL_GetRenderWindow(renderer) orelse makeError();
}
extern fn SDL_GetRenderWindow(renderer: *Renderer) ?*sdl.Window;

/// Get the name of a renderer.
pub fn getRendererName(renderer: *Renderer) Error![:0]const u8 {
    const str = SDL_GetRendererName(renderer) orelse return makeError();
    return std.mem.span(str);
}
extern fn SDL_GetRendererName(renderer: *Renderer) ?[*:0]const u8;

/// Get the properties associated with a renderer.
///
/// The following read-only properties are provided by SDL:
///
/// - `Renderer.Properties.name_string`: the name of the rendering driver
/// - `Renderer.Properties.window_pointer`: the window where rendering is
///   displayed, if any
/// - `Renderer.Properties.surface_pointer`: the surface where rendering is
///   displayed, if this is a software renderer without a window
/// - `Renderer.Properties.vsync_number`: the current vsync setting
/// - `Renderer.Properties.max_texture_size_number`: the maximum texture width
///   and height
/// - `Renderer.Properties.texture_formats_pointer`: a (const `PixelFormat` *)
///   array of pixel formats, terminated with `PixelFormat.unknown`,
///   representing the available texture formats for this renderer.
/// - `Renderer.Properties.texture_wrapping_boolean`: true if the renderer
///   supports `TextureAddressMode.wrap` on non-power-of-two textures.
/// - `Renderer.Properties.output_colorspace_number`: a `Colorspace` value
///   describing the colorspace for output to the display, defaults to
///   `Colorspace.srgb`.
/// - `Renderer.Properties.hdr_enabled_boolean`: true if the output colorspace is
///   `Colorspace.srgb_linear` and the renderer is showing on a display with
///   HDR enabled. This property can change dynamically when
///   `EventType.window_hdr_state_changed` is sent.
/// - `Renderer.Properties.sdr_white_point_float`: the value of SDR white in the
///   `Colorspace.srgb_linear` colorspace. When HDR is enabled, this value is
///   automatically multiplied into the color scale. This property can change
///   dynamically when `EventType.window_hdr_state_changed` is sent.
/// - `Renderer.Properties.hdr_headroom_float`: the additional high dynamic range
///   that can be displayed, in terms of the SDR white point. When HDR is not
///   enabled, this will be 1.0. This property can change dynamically when
///   `EventType.window_hdr_state_changed` is sent.
///
/// With the direct3d renderer:
///
/// - `Renderer.Properties.d3d9_device_pointer`: the IDirect3DDevice9 associated
///   with the renderer
///
/// With the direct3d11 renderer:
///
/// - `Renderer.Properties.d3d11_device_pointer`: the ID3D11Device associated
///   with the renderer
/// - `Renderer.Properties.d3d11_swapchain_pointer`: the IDXGISwapChain1
///   associated with the renderer. This may change when the window is resized.
///
/// With the direct3d12 renderer:
///
/// - `Renderer.Properties.d3d12_device_pointer`: the ID3D12Device associated
///   with the renderer
/// - `Renderer.Properties.d3d12_swapchain_pointer`: the IDXGISwapChain4
///   associated with the renderer.
/// - `Renderer.Properties.d3d12_command_queue_pointer`: the ID3D12CommandQueue
///   associated with the renderer
///
/// With the vulkan renderer:
///
/// - `Renderer.Properties.vulkan_instance_pointer`: the VkInstance associated
///   with the renderer
/// - `Renderer.Properties.vulkan_surface_number`: the VkSurfaceKHR associated
///   with the renderer
/// - `Renderer.Properties.vulkan_physical_device_pointer`: the VkPhysicalDevice
///   associated with the renderer
/// - `Renderer.Properties.vulkan_device_pointer`: the VkDevice associated with
///   the renderer
/// - `Renderer.Properties.vulkan_graphics_queue_family_index_number`: the queue
///   family index used for rendering
/// - `Renderer.Properties.vulkan_present_queue_family_index_number`: the queue
///   family index used for presentation
/// - `Renderer.Properties.vulkan_swapchain_image_count_number`: the number of
///   swapchain images, or potential frames in flight, used by the Vulkan
///   renderer
///
/// With the gpu renderer:
///
/// - `Renderer.Properties.gpu_device_pointer`: the `GPUDevice` associated with
///   the renderer
pub fn getRendererProperties(renderer: *Renderer) Error!sdl.PropertiesId {
    const result = SDL_GetRendererProperties(renderer);
    if (@backingInt(result) == 0) return makeError();
    return result;
}
extern fn SDL_GetRendererProperties(renderer: *Renderer) sdl.PropertiesId;

/// Get the output size in pixels of a rendering context.
///
/// This returns the true output size in pixels, ignoring any render targets or
/// logical size and presentation.
///
/// For the output size of the current rendering target, with logical size
/// adjustments, use `getCurrentRenderOutputSize` instead.
pub fn getRenderOutputSize(renderer: *Renderer, w: *c_int, h: *c_int) Error!void {
    if (!SDL_GetRenderOutputSize(renderer, w, h)) return makeError();
}
extern fn SDL_GetRenderOutputSize(renderer: *Renderer, w: *c_int, h: *c_int) bool;

/// Get the current output size in pixels of a rendering context.
///
/// If a rendering target is active, this will return the size of the rendering
/// target in pixels, otherwise return the value of `getRenderOutputSize`.
///
/// Rendering target or not, the output will be adjusted by the current logical
/// presentation state, dictated by `setRenderLogicalPresentation`.
pub fn getCurrentRenderOutputSize(renderer: *Renderer, w: *c_int, h: *c_int) Error!void {
    if (!SDL_GetCurrentRenderOutputSize(renderer, w, h)) return makeError();
}
extern fn SDL_GetCurrentRenderOutputSize(renderer: *Renderer, w: *c_int, h: *c_int) bool;

/// Create a texture for a rendering context.
///
/// The contents of a texture when first created are not defined.
pub fn createTexture(renderer: *Renderer, format: sdl.PixelFormat, access: TextureAccess, w: c_int, h: c_int) Error!*Texture {
    return SDL_CreateTexture(renderer, format, access, w, h) orelse makeError();
}
extern fn SDL_CreateTexture(renderer: *Renderer, format: sdl.PixelFormat, access: TextureAccess, w: c_int, h: c_int) ?*Texture;

/// Create a texture from an existing surface.
///
/// The surface is not modified or freed by this function.
///
/// The `TextureAccess` hint for the created texture is
/// `TextureAccess.static`.
///
/// The pixel format of the created texture may be different from the pixel
/// format of the surface, and can be queried using the
/// `Texture.Properties.format_number` property.
pub fn createTextureFromSurface(renderer: *Renderer, surface: *sdl.Surface) Error!*Texture {
    return SDL_CreateTextureFromSurface(renderer, surface) orelse makeError();
}
extern fn SDL_CreateTextureFromSurface(renderer: *Renderer, surface: *sdl.Surface) ?*Texture;

/// Create a texture for a rendering context with the specified properties.
///
/// These are the supported properties:
///
/// - `Texture.Properties.create_colorspace_number`: a `Colorspace` value
///   describing the texture colorspace, defaults to `Colorspace.srgb_linear`
///   for floating point textures, `Colorspace.hdr10` for 10-bit textures,
///   `Colorspace.srgb` for other RGB textures and `Colorspace.jpeg` for
///   YUV textures.
/// - `Texture.Properties.create_format_number`: one of the enumerated values in
///   `PixelFormat`, defaults to the best RGBA format for the renderer
/// - `Texture.Properties.create_access_number`: one of the enumerated values in
///   `TextureAccess`, defaults to `TextureAccess.static`
/// - `Texture.Properties.create_width_number`: the width of the texture in
///   pixels, required
/// - `Texture.Properties.create_height_number`: the height of the texture in
///   pixels, required
/// - `Texture.Properties.create_palette_pointer`: an `Palette` to use with
///   palettized texture formats. This can be set later with
///   `setTexturePalette`
/// - `Texture.Properties.create_sdr_white_point_float`: for HDR10 and floating
///   point textures, this defines the value of 100% diffuse white, with higher
///   values being displayed in the High Dynamic Range headroom. This defaults
///   to 100 for HDR10 textures and 1.0 for floating point textures.
/// - `Texture.Properties.create_hdr_headroom_float`: for HDR10 and floating
///   point textures, this defines the maximum dynamic range used by the
///   content, in terms of the SDR white point. This would be equivalent to
///   maxCLL / `Texture.Properties.create_sdr_white_point_float` for HDR10 content.
///   If this is defined, any values outside the range supported by the display
///   will be scaled into the available HDR headroom, otherwise they are
///   clipped.
///
/// With the direct3d11 renderer:
///
/// - `Texture.Properties.create_d3d11_texture_pointer`: the ID3D11Texture2D
///   associated with the texture, if you want to wrap an existing texture.
/// - `Texture.Properties.create_d3d11_texture_u_pointer`: the ID3D11Texture2D
///   associated with the U plane of a YUV texture, if you want to wrap an
///   existing texture.
/// - `Texture.Properties.create_d3d11_texture_v_pointer`: the ID3D11Texture2D
///   associated with the V plane of a YUV texture, if you want to wrap an
///   existing texture.
///
/// With the direct3d12 renderer:
///
/// - `Texture.Properties.create_d3d12_texture_pointer`: the ID3D12Resource
///   associated with the texture, if you want to wrap an existing texture.
/// - `Texture.Properties.create_d3d12_texture_u_pointer`: the ID3D12Resource
///   associated with the U plane of a YUV texture, if you want to wrap an
///   existing texture.
/// - `Texture.Properties.create_d3d12_texture_v_pointer`: the ID3D12Resource
///   associated with the V plane of a YUV texture, if you want to wrap an
///   existing texture.
///
/// With the metal renderer:
///
/// - `Texture.Properties.create_metal_pixelbuffer_pointer`: the CVPixelBufferRef
///   associated with the texture, if you want to create a texture from an
///   existing pixel buffer.
///
/// With the opengl renderer:
///
/// - `Texture.Properties.create_opengl_texture_number`: the GLuint texture
///   associated with the texture, if you want to wrap an existing texture.
/// - `Texture.Properties.create_opengl_texture_uv_number`: the GLuint texture
///   associated with the UV plane of an NV12 texture, if you want to wrap an
///   existing texture.
/// - `Texture.Properties.create_opengl_texture_u_number`: the GLuint texture
///   associated with the U plane of a YUV texture, if you want to wrap an
///   existing texture.
/// - `Texture.Properties.create_opengl_texture_v_number`: the GLuint texture
///   associated with the V plane of a YUV texture, if you want to wrap an
///   existing texture.
///
/// With the opengles2 renderer:
///
/// - `Texture.Properties.create_opengles2_texture_number`: the GLuint texture
///   associated with the texture, if you want to wrap an existing texture.
/// - `Texture.Properties.create_opengles2_texture_uv_number`: the GLuint texture
///   associated with the UV plane of an NV12 texture, if you want to wrap an
///   existing texture.
/// - `Texture.Properties.create_opengles2_texture_u_number`: the GLuint texture
///   associated with the U plane of a YUV texture, if you want to wrap an
///   existing texture.
/// - `Texture.Properties.create_opengles2_texture_v_number`: the GLuint texture
///   associated with the V plane of a YUV texture, if you want to wrap an
///   existing texture.
///
/// With the vulkan renderer:
///
/// - `Texture.Properties.create_vulkan_texture_number`: the VkImage associated
///   with the texture, if you want to wrap an existing texture.
/// - `Texture.Properties.create_vulkan_layout_number`: the VkImageLayout for the
///   VkImage, defaults to VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL.
///
/// With the GPU renderer:
///
/// - `Texture.Properties.create_gpu_texture_pointer`: the `GPUTexture`
///   associated with the texture, if you want to wrap an existing texture.
/// - `Texture.Properties.create_gpu_texture_uv_pointer`: the `GPUTexture`
///   associated with the UV plane of an NV12 texture, if you want to wrap an
///   existing texture.
/// - `Texture.Properties.create_gpu_texture_u_pointer`: the `GPUTexture`
///   associated with the U plane of a YUV texture, if you want to wrap an
///   existing texture.
/// - `Texture.Properties.create_gpu_texture_v_pointer`: the `GPUTexture`
///   associated with the V plane of a YUV texture, if you want to wrap an
///   existing texture.
pub fn createTextureWithProperties(renderer: *Renderer, props: sdl.PropertiesId) Error!*Texture {
    return SDL_CreateTextureWithProperties(renderer, props) orelse makeError();
}
extern fn SDL_CreateTextureWithProperties(renderer: *Renderer, props: sdl.PropertiesId) ?*Texture;

/// Get the properties associated with a texture.
///
/// The following read-only properties are provided by SDL:
///
/// - `Texture.Properties.colorspace_number`: a `Colorspace` value describing
///   the texture colorspace.
/// - `Texture.Properties.format_number`: one of the enumerated values in
///   `PixelFormat`.
/// - `TextureAccess.Properties.number`: one of the enumerated values in
///   `TextureAccess`.
/// - `Texture.Properties.width_number`: the width of the texture in pixels.
/// - `Texture.Properties.height_number`: the height of the texture in pixels.
/// - `Texture.Properties.sdr_white_point_float`: for HDR10 and floating point
///   textures, this defines the value of 100% diffuse white, with higher
///   values being displayed in the High Dynamic Range headroom. This defaults
///   to 100 for HDR10 textures and 1.0 for other textures.
/// - `Texture.Properties.hdr_headroom_float`: for HDR10 and floating point
///   textures, this defines the maximum dynamic range used by the content, in
///   terms of the SDR white point. If this is defined, any values outside the
///   range supported by the display will be scaled into the available HDR
///   headroom, otherwise they are clipped. This defaults to 1.0 for SDR
///   textures, 4.0 for HDR10 textures, and no default for floating point
///   textures.
///
/// With the direct3d11 renderer:
///
/// - `Texture.Properties.d3d11_texture_pointer`: the ID3D11Texture2D associated
///   with the texture
/// - `Texture.Properties.d3d11_texture_u_pointer`: the ID3D11Texture2D
///   associated with the U plane of a YUV texture
/// - `Texture.Properties.d3d11_texture_v_pointer`: the ID3D11Texture2D
///   associated with the V plane of a YUV texture
///
/// With the direct3d12 renderer:
///
/// - `Texture.Properties.d3d12_texture_pointer`: the ID3D12Resource associated
///   with the texture
/// - `Texture.Properties.d3d12_texture_u_pointer`: the ID3D12Resource associated
///   with the U plane of a YUV texture
/// - `Texture.Properties.d3d12_texture_v_pointer`: the ID3D12Resource associated
///   with the V plane of a YUV texture
///
/// With the vulkan renderer:
///
/// - `Texture.Properties.vulkan_texture_number`: the VkImage associated with the
///   texture
///
/// With the opengl renderer:
///
/// - `Texture.Properties.opengl_texture_number`: the GLuint texture associated
///   with the texture
/// - `Texture.Properties.opengl_texture_uv_number`: the GLuint texture
///   associated with the UV plane of an NV12 texture
/// - `Texture.Properties.opengl_texture_u_number`: the GLuint texture associated
///   with the U plane of a YUV texture
/// - `Texture.Properties.opengl_texture_v_number`: the GLuint texture associated
///   with the V plane of a YUV texture
/// - `Texture.Properties.opengl_texture_target_number`: the GLenum for the
///   texture target (`GL_TEXTURE_2D`, `GL_TEXTURE_RECTANGLE_ARB`, etc)
/// - `Texture.Properties.opengl_tex_w_float`: the texture coordinate width of
///   the texture (0.0 - 1.0)
/// - `Texture.Properties.opengl_tex_h_float`: the texture coordinate height of
///   the texture (0.0 - 1.0)
///
/// With the opengles2 renderer:
///
/// - `Texture.Properties.opengles2_texture_number`: the GLuint texture
///   associated with the texture
/// - `Texture.Properties.opengles2_texture_uv_number`: the GLuint texture
///   associated with the UV plane of an NV12 texture
/// - `Texture.Properties.opengles2_texture_u_number`: the GLuint texture
///   associated with the U plane of a YUV texture
/// - `Texture.Properties.opengles2_texture_v_number`: the GLuint texture
///   associated with the V plane of a YUV texture
/// - `Texture.Properties.opengles2_texture_target_number`: the GLenum for the
///   texture target (`GL_TEXTURE_2D`, `GL_TEXTURE_EXTERNAL_OES`, etc)
///
/// With the gpu renderer:
///
/// - `Texture.Properties.gpu_texture_pointer`: the `GPUTexture` associated
///   with the texture
/// - `Texture.Properties.gpu_texture_uv_pointer`: the `GPUTexture` associated
///   with the UV plane of an NV12 texture
/// - `Texture.Properties.gpu_texture_u_pointer`: the `GPUTexture` associated
///   with the U plane of a YUV texture
/// - `Texture.Properties.gpu_texture_v_pointer`: the `GPUTexture` associated
///   with the V plane of a YUV texture
pub fn getTextureProperties(texture: *Texture) Error!sdl.PropertiesId {
    const result = SDL_GetTextureProperties(texture);
    if (@backingInt(result) == 0) return makeError();
    return result;
}
extern fn SDL_GetTextureProperties(texture: *Texture) sdl.PropertiesId;

/// Get the renderer that created a `Texture`.
pub fn getRendererFromTexture(texture: *Texture) Error!*Renderer {
    return SDL_GetRendererFromTexture(texture) orelse makeError();
}
extern fn SDL_GetRendererFromTexture(texture: *Texture) ?*Renderer;

/// Get the size of a texture, as floating point values.
pub fn getTextureSize(texture: *Texture, w: ?*f32, h: ?*f32) Error!void {
    if (!SDL_GetTextureSize(texture, w, h)) return makeError();
}
extern fn SDL_GetTextureSize(texture: *Texture, w: ?*f32, h: ?*f32) bool;

/// Set the palette used by a texture.
///
/// Setting the palette keeps an internal reference to the palette, which can
/// be safely destroyed afterwards.
///
/// A single palette can be shared with many textures.
pub fn setTexturePalette(texture: *Texture, palette: *sdl.Palette) Error!void {
    if (!SDL_SetTexturePalette(texture, palette)) return makeError();
}
extern fn SDL_SetTexturePalette(texture: *Texture, palette: *sdl.Palette) bool;

/// Get the palette used by a texture.
pub const getTexturePalette = SDL_GetTexturePalette;
extern fn SDL_GetTexturePalette(texture: *Texture) ?*sdl.Palette;

/// Set an additional color value multiplied into render copy operations.
///
/// When this texture is rendered, during the copy operation each source color
/// channel is modulated by the appropriate color value according to the
/// following formula:
///
/// `srcC = srcC * (color / 255)`
///
/// Color modulation is not always supported by the renderer; it will return
/// false if color modulation is not supported.
pub fn setTextureColorMod(texture: *Texture, r: u8, g: u8, b: u8) Error!void {
    if (!SDL_SetTextureColorMod(texture, r, g, b)) return makeError();
}
extern fn SDL_SetTextureColorMod(texture: *Texture, r: u8, g: u8, b: u8) bool;

/// Set an additional color value multiplied into render copy operations.
///
/// When this texture is rendered, during the copy operation each source color
/// channel is modulated by the appropriate color value according to the
/// following formula:
///
/// `srcC = srcC * color`
///
/// Color modulation is not always supported by the renderer; it will return
/// false if color modulation is not supported.
pub fn setTextureColorModFloat(texture: *Texture, r: f32, g: f32, b: f32) Error!void {
    if (!SDL_SetTextureColorModFloat(texture, r, g, b)) return makeError();
}
extern fn SDL_SetTextureColorModFloat(texture: *Texture, r: f32, g: f32, b: f32) bool;

/// Get the additional color value multiplied into render copy operations.
pub fn getTextureColorMod(texture: *Texture, r: *u8, g: *u8, b: *u8) Error!void {
    if (!SDL_GetTextureColorMod(texture, r, g, b)) return makeError();
}
extern fn SDL_GetTextureColorMod(texture: *Texture, r: *u8, g: *u8, b: *u8) bool;

/// Get the additional color value multiplied into render copy operations.
pub fn getTextureColorModFloat(texture: *Texture, r: *f32, g: *f32, b: *f32) Error!void {
    if (!SDL_GetTextureColorModFloat(texture, r, g, b)) return makeError();
}
extern fn SDL_GetTextureColorModFloat(texture: *Texture, r: *f32, g: *f32, b: *f32) bool;

/// Set an additional alpha value multiplied into render copy operations.
///
/// When this texture is rendered, during the copy operation the source alpha
/// value is modulated by this alpha value according to the following formula:
///
/// `srcA = srcA * (alpha / 255)`
///
/// Alpha modulation is not always supported by the renderer; it will return
/// false if alpha modulation is not supported.
pub fn setTextureAlphaMod(texture: *Texture, alpha: u8) Error!void {
    if (!SDL_SetTextureAlphaMod(texture, alpha)) return makeError();
}
extern fn SDL_SetTextureAlphaMod(texture: *Texture, alpha: u8) bool;

/// Set an additional alpha value multiplied into render copy operations.
///
/// When this texture is rendered, during the copy operation the source alpha
/// value is modulated by this alpha value according to the following formula:
///
/// `srcA = srcA * alpha`
///
/// Alpha modulation is not always supported by the renderer; it will return
/// false if alpha modulation is not supported.
pub fn setTextureAlphaModFloat(texture: *Texture, alpha: f32) Error!void {
    if (!SDL_SetTextureAlphaModFloat(texture, alpha)) return makeError();
}
extern fn SDL_SetTextureAlphaModFloat(texture: *Texture, alpha: f32) bool;

/// Get the additional alpha value multiplied into render copy operations.
pub fn getTextureAlphaMod(texture: *Texture) Error!u8 {
    var alpha: u8 = undefined;
    if (!SDL_GetTextureAlphaMod(texture, &alpha)) return makeError();
    return alpha;
}
extern fn SDL_GetTextureAlphaMod(texture: *Texture, alpha: *u8) bool;

/// Get the additional alpha value multiplied into render copy operations.
pub fn getTextureAlphaModFloat(texture: *Texture) Error!f32 {
    var alpha: f32 = undefined;
    if (!SDL_GetTextureAlphaModFloat(texture, &alpha)) return makeError();
    return alpha;
}
extern fn SDL_GetTextureAlphaModFloat(texture: *Texture, alpha: *f32) bool;

/// Set the blend mode for a texture, used by `renderTexture`.
///
/// This blend mode is used for any drawing that involves this texture.
///
/// If the blend mode is not supported, the closest supported mode is chosen
/// and this function returns false.
pub fn setTextureBlendMode(texture: *Texture, blendMode: sdl.BlendMode) Error!void {
    if (!SDL_SetTextureBlendMode(texture, blendMode)) return makeError();
}
extern fn SDL_SetTextureBlendMode(texture: *Texture, blendMode: sdl.BlendMode) bool;

/// Get the blend mode used for texture copy operations.
pub fn getTextureBlendMode(texture: *Texture) Error!sdl.BlendMode {
    var blendMode: sdl.BlendMode = undefined;
    if (!SDL_GetTextureBlendMode(texture, &blendMode)) return makeError();
    return blendMode;
}
extern fn SDL_GetTextureBlendMode(texture: *Texture, blendMode: *sdl.BlendMode) bool;

/// Set the scale mode used for texture scale operations.
///
/// The default texture scale mode is `ScaleMode.linear`.
///
/// If the scale mode is not supported, the closest supported mode is chosen.
pub fn setTextureScaleMode(texture: *Texture, scaleMode: sdl.ScaleMode) Error!void {
    if (!SDL_SetTextureScaleMode(texture, scaleMode)) return makeError();
}
extern fn SDL_SetTextureScaleMode(texture: *Texture, scaleMode: sdl.ScaleMode) bool;

/// Get the scale mode used for texture scale operations.
pub fn getTextureScaleMode(texture: *Texture) Error!sdl.ScaleMode {
    var scaleMode: sdl.ScaleMode = undefined;
    if (!SDL_GetTextureScaleMode(texture, &scaleMode)) return makeError();
    return scaleMode;
}
extern fn SDL_GetTextureScaleMode(texture: *Texture, scaleMode: *sdl.ScaleMode) bool;

/// Update the given texture rectangle with new pixel data.
///
/// The pixel data must be in the pixel format of the texture, which can be
/// queried using the `Texture.Properties.format_number` property.
///
/// This is a fairly slow function, intended for use with static textures that
/// do not change often.
///
/// If the texture is intended to be updated often, it is preferred to create
/// the texture as streaming and use the locking functions referenced below.
/// While this function will work with streaming textures, for optimization
/// reasons you may not get the pixels back if you lock the texture afterward.
pub fn updateTexture(texture: *Texture, rect: ?*const sdl.Rect, pixels: *const anyopaque, pitch: c_int) Error!void {
    if (!SDL_UpdateTexture(texture, rect, pixels, pitch)) return makeError();
}
extern fn SDL_UpdateTexture(texture: *Texture, rect: ?*const sdl.Rect, pixels: *const anyopaque, pitch: c_int) bool;

/// Update a rectangle within a planar YV12 or IYUV texture with new pixel
/// data.
///
/// You can use `updateTexture` as long as your pixel data is a contiguous
/// block of Y and U/V planes in the proper order, but this function is
/// available if your pixel data is not contiguous.
pub fn updateYUVTexture(texture: *Texture, rect: ?*const sdl.Rect, Yplane: [*]const u8, Ypitch: c_int, Uplane: [*]const u8, Upitch: c_int, Vplane: [*]const u8, Vpitch: c_int) Error!void {
    if (!SDL_UpdateYUVTexture(texture, rect, Yplane, Ypitch, Uplane, Upitch, Vplane, Vpitch)) return makeError();
}
extern fn SDL_UpdateYUVTexture(texture: *Texture, rect: ?*const sdl.Rect, Yplane: [*]const u8, Ypitch: c_int, Uplane: [*]const u8, Upitch: c_int, Vplane: [*]const u8, Vpitch: c_int) bool;

/// Update a rectangle within a planar NV12 or NV21 texture with new pixels.
///
/// You can use `updateTexture` as long as your pixel data is a contiguous
/// block of NV12/21 planes in the proper order, but this function is available
/// if your pixel data is not contiguous.
pub fn updateNVTexture(texture: *Texture, rect: ?*const sdl.Rect, Yplane: [*]const u8, Ypitch: c_int, UVplane: [*]const u8, UVpitch: c_int) Error!void {
    if (!SDL_UpdateNVTexture(texture, rect, Yplane, Ypitch, UVplane, UVpitch)) return makeError();
}
extern fn SDL_UpdateNVTexture(texture: *Texture, rect: ?*const sdl.Rect, Yplane: [*]const u8, Ypitch: c_int, UVplane: [*]const u8, UVpitch: c_int) bool;

/// Lock a portion of the texture for **write-only** pixel access.
///
/// As an optimization, the pixels made available for editing don't necessarily
/// contain the old texture data. This is a write-only operation, and if you
/// need to keep a copy of the texture data you should do that at the
/// application level.
///
/// You must use `unlockTexture` to unlock the pixels and apply any
/// changes.
pub fn lockTexture(texture: *Texture, rect: ?*const sdl.Rect) Error!struct { pixels: [*]u8, pitch: c_int } {
    var pixels: *anyopaque = undefined;
    var pitch: c_int = undefined;
    if (!SDL_LockTexture(texture, rect, &pixels, &pitch)) return makeError();
    return .{ .pixels = @ptrCast(pixels), .pitch = pitch };
}
extern fn SDL_LockTexture(texture: *Texture, rect: ?*const sdl.Rect, pixels: **anyopaque, pitch: *c_int) bool;

/// Lock a portion of the texture for **write-only** pixel access, and expose
/// it as a SDL surface.
///
/// Besides providing a `Surface` instead of raw pixel data, this function
/// operates like `lockTexture`.
///
/// As an optimization, the pixels made available for editing don't necessarily
/// contain the old texture data. This is a write-only operation, and if you
/// need to keep a copy of the texture data you should do that at the
/// application level.
///
/// You must use `unlockTexture` to unlock the pixels and apply any
/// changes.
///
/// The returned surface is freed internally after calling `unlockTexture`
/// or `destroyTexture`. The caller should not free it.
pub fn lockTextureToSurface(texture: *Texture, rect: ?*const sdl.Rect) Error!*sdl.Surface {
    var surface: *sdl.Surface = undefined;
    if (!SDL_LockTextureToSurface(texture, rect, &surface)) return makeError();
    return surface;
}
extern fn SDL_LockTextureToSurface(texture: *Texture, rect: ?*const sdl.Rect, surface: **sdl.Surface) bool;

/// Unlock a texture, uploading the changes to video memory, if needed.
///
/// **Warning**: Please note that `lockTexture` is intended to be
/// write-only; it will not guarantee the previous contents of the texture will
/// be provided. You must fully initialize any area of a texture that you lock
/// before unlocking it, as the pixels might otherwise be uninitialized memory.
///
/// Which is to say: locking and immediately unlocking a texture can result in
/// corrupted textures, depending on the renderer in use.
pub const unlockTexture = SDL_UnlockTexture;
extern fn SDL_UnlockTexture(texture: *Texture) void;

/// Set a texture as the current rendering target.
///
/// The default render target is the window for which the renderer was created.
/// To stop rendering to a texture and render to the window again, call this
/// function with a null `texture`.
///
/// Viewport, cliprect, scale, and logical presentation are unique to each
/// render target. Get and set functions for these states apply to the current
/// render target set by this function, and those states persist on each target
/// when the current render target changes.
pub fn setRenderTarget(renderer: *Renderer, texture: ?*Texture) Error!void {
    if (!SDL_SetRenderTarget(renderer, texture)) return makeError();
}
extern fn SDL_SetRenderTarget(renderer: *Renderer, texture: ?*Texture) bool;

/// Get the current render target.
///
/// The default render target is the window for which the renderer was created,
/// and is reported a null here.
pub const getRenderTarget = SDL_GetRenderTarget;
extern fn SDL_GetRenderTarget(renderer: *Renderer) ?*Texture;

/// Set a device-independent resolution and presentation mode for rendering.
///
/// This function sets the width and height of the logical rendering output.
/// The renderer will act as if the current render target is always the
/// requested dimensions, scaling to the actual resolution as necessary.
///
/// This can be useful for games that expect a fixed size, but would like to
/// scale the output to whatever is available, regardless of how a user resizes
/// a window, or if the display is high DPI.
///
/// Logical presentation can be used with both render target textures and the
/// renderer's window; the state is unique to each render target, and this
/// function sets the state for the current render target. It might be useful
/// to draw to a texture that matches the window dimensions with logical
/// presentation enabled, and then draw that texture across the entire window
/// with logical presentation disabled. Be careful not to render both with
/// logical presentation enabled, however, as this could produce
/// double-letterboxing, etc.
///
/// You can disable logical coordinates by setting the mode to
/// `RendererLogicalPresentation.disabled`, and in that case you get the full pixel
/// resolution of the render target; it is safe to toggle logical presentation
/// during the rendering of a frame: perhaps most of the rendering is done to
/// specific dimensions but to make fonts look sharp, the app turns off logical
/// presentation while drawing text, for example.
///
/// You can convert coordinates in an event into rendering coordinates using
/// `convertEventToRenderCoordinates`.
pub fn setRenderLogicalPresentation(renderer: *Renderer, w: c_int, h: c_int, mode: RendererLogicalPresentation) Error!void {
    if (!SDL_SetRenderLogicalPresentation(renderer, w, h, mode)) return makeError();
}
extern fn SDL_SetRenderLogicalPresentation(renderer: *Renderer, w: c_int, h: c_int, mode: RendererLogicalPresentation) bool;

/// Get device independent resolution and presentation mode for rendering.
///
/// This function gets the width and height of the logical rendering output, or
/// 0 if a logical resolution is not enabled.
///
/// Each render target has its own logical presentation state. This function
/// gets the state for the current render target.
pub fn getRenderLogicalPresentation(renderer: *Renderer, w: *c_int, h: *c_int, mode: *RendererLogicalPresentation) Error!void {
    if (!SDL_GetRenderLogicalPresentation(renderer, w, h, mode)) return makeError();
}
extern fn SDL_GetRenderLogicalPresentation(renderer: *Renderer, w: *c_int, h: *c_int, mode: *RendererLogicalPresentation) bool;

/// Get the final presentation rectangle for rendering.
///
/// This function returns the calculated rectangle used for logical
/// presentation, based on the presentation mode and output size. If logical
/// presentation is disabled, it will fill the rectangle with the output size,
/// in pixels.
///
/// Each render target has its own logical presentation state. This function
/// gets the rectangle for the current render target.
pub fn getRenderLogicalPresentationRect(renderer: *Renderer) Error!sdl.FRect {
    var rect: sdl.FRect = undefined;
    if (!SDL_GetRenderLogicalPresentationRect(renderer, &rect)) return makeError();
    return rect;
}
extern fn SDL_GetRenderLogicalPresentationRect(renderer: *Renderer, rect: ?*sdl.FRect) bool;

/// Get a point in render coordinates when given a point in window coordinates.
///
/// This takes into account several states:
///
/// - The window dimensions.
/// - The logical presentation settings (`setRenderLogicalPresentation`)
/// - The scale (`setRenderScale`)
/// - The viewport (`setRenderViewport`)
pub fn renderCoordinatesFromWindow(renderer: *Renderer, window_x: f32, window_y: f32, x: *f32, y: *f32) Error!void {
    if (!SDL_RenderCoordinatesFromWindow(renderer, window_x, window_y, x, y)) return makeError();
}
extern fn SDL_RenderCoordinatesFromWindow(renderer: *Renderer, window_x: f32, window_y: f32, x: *f32, y: *f32) bool;

/// Get a point in window coordinates when given a point in render coordinates.
///
/// This takes into account several states:
///
/// - The window dimensions.
/// - The logical presentation settings (`setRenderLogicalPresentation`)
/// - The scale (`setRenderScale`)
/// - The viewport (`setRenderViewport`)
pub fn renderCoordinatesToWindow(renderer: *Renderer, x: f32, y: f32, window_x: *f32, window_y: *f32) Error!void {
    if (!SDL_RenderCoordinatesToWindow(renderer, x, y, window_x, window_y)) return makeError();
}
extern fn SDL_RenderCoordinatesToWindow(renderer: *Renderer, x: f32, y: f32, window_x: *f32, window_y: *f32) bool;

/// Convert the coordinates in an event to render coordinates.
///
/// This takes into account several states:
///
/// - The window dimensions.
/// - The logical presentation settings (`setRenderLogicalPresentation`)
/// - The scale (`setRenderScale`)
/// - The viewport (`setRenderViewport`)
///
/// Various event types are converted with this function: mouse, touch, pen,
/// etc.
///
/// Touch coordinates are converted from normalized coordinates in the window
/// to non-normalized rendering coordinates.
///
/// Relative mouse coordinates (xrel and yrel event fields) are _also_
/// converted. Applications that do not want these fields converted should use
/// `renderCoordinatesFromWindow` on the specific event fields instead of
/// converting the entire event structure.
///
/// Once converted, coordinates may be outside the rendering area.
pub fn convertEventToRenderCoordinates(renderer: *Renderer, event: *sdl.Event) Error!void {
    if (!SDL_ConvertEventToRenderCoordinates(renderer, event)) return makeError();
}
extern fn SDL_ConvertEventToRenderCoordinates(renderer: *Renderer, event: *sdl.Event) bool;

/// Set the drawing area for rendering on the current target.
///
/// Drawing will clip to this area (separately from any clipping done with
/// `setRenderClipRect`), and the top left of the area will become coordinate
/// (0, 0) for future drawing commands.
///
/// The area's width and height must be >= 0.
///
/// Each render target has its own viewport. This function sets the viewport
/// for the current render target.
pub fn setRenderViewport(renderer: *Renderer, rect: ?*const sdl.Rect) Error!void {
    if (!SDL_SetRenderViewport(renderer, rect)) return makeError();
}
extern fn SDL_SetRenderViewport(renderer: *Renderer, rect: ?*const sdl.Rect) bool;

/// Get the drawing area for the current target.
///
/// Each render target has its own viewport. This function gets the viewport
/// for the current render target.
pub fn getRenderViewport(renderer: *Renderer) Error!sdl.Rect {
    var rect: sdl.Rect = undefined;
    if (!SDL_GetRenderViewport(renderer, &rect)) return makeError();
    return rect;
}
extern fn SDL_GetRenderViewport(renderer: *Renderer, rect: *sdl.Rect) bool;

/// Return whether an explicit rectangle was set as the viewport.
///
/// This is useful if you're saving and restoring the viewport and want to know
/// whether you should restore a specific rectangle or null.
///
/// Each render target has its own viewport. This function checks the viewport
/// for the current render target.
pub const renderViewportSet = SDL_RenderViewportSet;
extern fn SDL_RenderViewportSet(renderer: *Renderer) bool;

/// Get the safe area for rendering within the current viewport.
///
/// Some devices have portions of the screen which are partially obscured or
/// not interactive, possibly due to on-screen controls, curved edges, camera
/// notches, TV overscan, etc. This function provides the area of the current
/// viewport which is safe to have interactible content. You should continue
/// rendering into the rest of the render target, but it should not contain
/// visually important or interactible content.
pub fn getRenderSafeArea(renderer: *Renderer) Error!sdl.Rect {
    var rect: sdl.Rect = undefined;
    if (!SDL_GetRenderSafeArea(renderer, &rect)) return makeError();
    return rect;
}
extern fn SDL_GetRenderSafeArea(renderer: *Renderer, rect: *sdl.Rect) bool;

/// Set the clip rectangle for rendering on the specified target.
///
/// Each render target has its own clip rectangle. This function sets the
/// cliprect for the current render target.
pub fn setRenderClipRect(renderer: *Renderer, rect: ?*const sdl.Rect) Error!void {
    if (!SDL_SetRenderClipRect(renderer, rect)) return makeError();
}
extern fn SDL_SetRenderClipRect(renderer: *Renderer, rect: ?*const sdl.Rect) bool;

/// Get the clip rectangle for the current target.
///
/// Each render target has its own clip rectangle. This function gets the
/// cliprect for the current render target.
pub fn getRenderClipRect(renderer: *Renderer) Error!sdl.Rect {
    var rect: sdl.Rect = undefined;
    if (!SDL_GetRenderClipRect(renderer, &rect)) return makeError();
    return rect;
}
extern fn SDL_GetRenderClipRect(renderer: *Renderer, rect: *sdl.Rect) bool;

/// Get whether clipping is enabled on the given render target.
///
/// Each render target has its own clip rectangle. This function checks the
/// cliprect for the current render target.
pub const renderClipEnabled = SDL_RenderClipEnabled;
extern fn SDL_RenderClipEnabled(renderer: *Renderer) bool;

/// Set the drawing scale for rendering on the current target.
///
/// The drawing coordinates are scaled by the x/y scaling factors before they
/// are used by the renderer. This allows resolution independent drawing with a
/// single coordinate system.
///
/// If this results in scaling or subpixel drawing by the rendering backend, it
/// will be handled using the appropriate quality hints. For best results use
/// integer scaling factors.
///
/// Each render target has its own scale. This function sets the scale for the
/// current render target.
pub fn setRenderScale(renderer: *Renderer, scaleX: f32, scaleY: f32) Error!void {
    if (!SDL_SetRenderScale(renderer, scaleX, scaleY)) return makeError();
}
extern fn SDL_SetRenderScale(renderer: *Renderer, scaleX: f32, scaleY: f32) bool;

/// Get the drawing scale for the current target.
///
/// Each render target has its own scale. This function gets the scale for the
/// current render target.
pub fn getRenderScale(renderer: *Renderer, scaleX: *f32, scaleY: *f32) Error!void {
    if (!SDL_GetRenderScale(renderer, scaleX, scaleY)) return makeError();
}
extern fn SDL_GetRenderScale(renderer: *Renderer, scaleX: *f32, scaleY: *f32) bool;

/// Set the color used for drawing operations.
///
/// Set the color for drawing or filling rectangles, lines, and points, and for
/// `renderClear`.
pub fn setRenderDrawColor(renderer: *Renderer, r: u8, g: u8, b: u8, a: u8) Error!void {
    if (!SDL_SetRenderDrawColor(renderer, r, g, b, a)) return makeError();
}
extern fn SDL_SetRenderDrawColor(renderer: *Renderer, r: u8, g: u8, b: u8, a: u8) bool;

/// Set the color used for drawing operations (Rect, Line and Clear).
///
/// Set the color for drawing or filling rectangles, lines, and points, and for
/// `renderClear`.
pub fn setRenderDrawColorFloat(renderer: *Renderer, r: f32, g: f32, b: f32, a: f32) Error!void {
    if (!SDL_SetRenderDrawColorFloat(renderer, r, g, b, a)) return makeError();
}
extern fn SDL_SetRenderDrawColorFloat(renderer: *Renderer, r: f32, g: f32, b: f32, a: f32) bool;

/// Get the color used for drawing operations (Rect, Line and Clear).
pub fn getRenderDrawColor(renderer: *Renderer, r: *u8, g: *u8, b: *u8, a: *u8) Error!void {
    if (!SDL_GetRenderDrawColor(renderer, r, g, b, a)) return makeError();
}
extern fn SDL_GetRenderDrawColor(renderer: *Renderer, r: *u8, g: *u8, b: *u8, a: *u8) bool;

/// Get the color used for drawing operations (Rect, Line and Clear).
pub fn getRenderDrawColorFloat(renderer: *Renderer, r: *f32, g: *f32, b: *f32, a: *f32) Error!void {
    if (!SDL_GetRenderDrawColorFloat(renderer, r, g, b, a)) return makeError();
}
extern fn SDL_GetRenderDrawColorFloat(renderer: *Renderer, r: *f32, g: *f32, b: *f32, a: *f32) bool;

/// Set the color scale used for render operations.
///
/// The color scale is an additional scale multiplied into the pixel color
/// value while rendering. This can be used to adjust the brightness of colors
/// during HDR rendering, or changing HDR video brightness when playing on an
/// SDR display.
///
/// The color scale does not affect the alpha channel, only the color
/// brightness.
pub fn setRenderColorScale(renderer: *Renderer, scale: f32) Error!void {
    if (!SDL_SetRenderColorScale(renderer, scale)) return makeError();
}
extern fn SDL_SetRenderColorScale(renderer: *Renderer, scale: f32) bool;

/// Get the color scale used for render operations.
pub fn getRenderColorScale(renderer: *Renderer) Error!f32 {
    var scale: f32 = undefined;
    if (!SDL_GetRenderColorScale(renderer, &scale)) return makeError();
    return scale;
}
extern fn SDL_GetRenderColorScale(renderer: *Renderer, scale: *f32) bool;

/// Set the blend mode used for drawing operations.
///
/// This blend mode is used for any drawing that doesn't involve textures.
///
/// If the blend mode is not supported, the closest supported mode is chosen.
pub fn setRenderDrawBlendMode(renderer: *Renderer, blendMode: sdl.BlendMode) Error!void {
    if (!SDL_SetRenderDrawBlendMode(renderer, blendMode)) return makeError();
}
extern fn SDL_SetRenderDrawBlendMode(renderer: *Renderer, blendMode: sdl.BlendMode) bool;

/// Get the blend mode used for drawing operations.
pub fn getRenderDrawBlendMode(renderer: *Renderer) Error!sdl.BlendMode {
    var blendMode: sdl.BlendMode = undefined;
    if (!SDL_GetRenderDrawBlendMode(renderer, &blendMode)) return makeError();
    return blendMode;
}
extern fn SDL_GetRenderDrawBlendMode(renderer: *Renderer, blendMode: *sdl.BlendMode) bool;

/// Clear the current rendering target with the drawing color.
///
/// This function clears the entire rendering target, ignoring the viewport and
/// the clip rectangle. Note, that clearing will also set/fill all pixels of
/// the rendering target to current renderer draw color, so make sure to invoke
/// `setRenderDrawColor` when needed.
pub fn renderClear(renderer: *Renderer) Error!void {
    if (!SDL_RenderClear(renderer)) return makeError();
}
extern fn SDL_RenderClear(renderer: *Renderer) bool;

/// Draw a point on the current rendering target at subpixel precision.
pub fn renderPoint(renderer: *Renderer, x: f32, y: f32) Error!void {
    if (!SDL_RenderPoint(renderer, x, y)) return makeError();
}
extern fn SDL_RenderPoint(renderer: *Renderer, x: f32, y: f32) bool;

/// Draw multiple points on the current rendering target at subpixel precision.
pub fn renderPoints(renderer: *Renderer, points: []const sdl.FPoint) Error!void {
    if (!SDL_RenderPoints(renderer, points.ptr, @intCast(points.len))) return makeError();
}
extern fn SDL_RenderPoints(renderer: *Renderer, points: [*]const sdl.FPoint, count: c_int) bool;

/// Draw a line on the current rendering target at subpixel precision.
pub fn renderLine(renderer: *Renderer, x1: f32, y1: f32, x2: f32, y2: f32) Error!void {
    if (!SDL_RenderLine(renderer, x1, y1, x2, y2)) return makeError();
}
extern fn SDL_RenderLine(renderer: *Renderer, x1: f32, y1: f32, x2: f32, y2: f32) bool;

/// Draw a series of connected lines on the current rendering target at
/// subpixel precision.
pub fn renderLines(renderer: *Renderer, points: []const sdl.FPoint) Error!void {
    if (!SDL_RenderLines(renderer, points.ptr, @intCast(points.len))) return makeError();
}
extern fn SDL_RenderLines(renderer: *Renderer, points: [*]const sdl.FPoint, count: c_int) bool;

/// Draw a rectangle on the current rendering target at subpixel precision.
pub fn renderRect(renderer: *Renderer, rect: ?*const sdl.FRect) Error!void {
    if (!SDL_RenderRect(renderer, rect)) return makeError();
}
extern fn SDL_RenderRect(renderer: *Renderer, rect: ?*const sdl.FRect) bool;

/// Draw some number of rectangles on the current rendering target at subpixel
/// precision.
pub fn renderRects(renderer: *Renderer, rects: []const sdl.FRect) Error!void {
    if (!SDL_RenderRects(renderer, rects.ptr, @intCast(rects.len))) return makeError();
}
extern fn SDL_RenderRects(renderer: *Renderer, rects: [*]const sdl.FRect, count: c_int) bool;

/// Fill a rectangle on the current rendering target with the drawing color at
/// subpixel precision.
pub fn renderFillRect(renderer: *Renderer, rect: ?*const sdl.FRect) Error!void {
    if (!SDL_RenderFillRect(renderer, rect)) return makeError();
}
extern fn SDL_RenderFillRect(renderer: *Renderer, rect: ?*const sdl.FRect) bool;

/// Fill some number of rectangles on the current rendering target with the
/// drawing color at subpixel precision.
pub fn renderFillRects(renderer: *Renderer, rects: []const sdl.FRect) Error!void {
    if (!SDL_RenderFillRects(renderer, rects.ptr, @intCast(rects.len))) return makeError();
}
extern fn SDL_RenderFillRects(renderer: *Renderer, rects: [*]const sdl.FRect, count: c_int) bool;

/// Copy a portion of the texture to the current rendering target at subpixel
/// precision.
pub fn renderTexture(renderer: *Renderer, texture: *Texture, srcrect: ?*const sdl.FRect, dstrect: ?*const sdl.FRect) Error!void {
    if (!SDL_RenderTexture(renderer, texture, srcrect, dstrect)) return makeError();
}
extern fn SDL_RenderTexture(renderer: *Renderer, texture: *Texture, srcrect: ?*const sdl.FRect, dstrect: ?*const sdl.FRect) bool;

/// Copy a portion of the source texture to the current rendering target, with
/// rotation and flipping, at subpixel precision.
pub fn renderTextureRotated(renderer: *Renderer, texture: *Texture, srcrect: ?*const sdl.FRect, dstrect: ?*const sdl.FRect, angle: f64, center: ?*const sdl.FPoint, flip: sdl.FlipMode) Error!void {
    if (!SDL_RenderTextureRotated(renderer, texture, srcrect, dstrect, angle, center, flip)) return makeError();
}
extern fn SDL_RenderTextureRotated(renderer: *Renderer, texture: *Texture, srcrect: ?*const sdl.FRect, dstrect: ?*const sdl.FRect, angle: f64, center: ?*const sdl.FPoint, flip: sdl.FlipMode) bool;

/// Copy a portion of the source texture to the current rendering target, with
/// affine transform, at subpixel precision.
pub fn renderTextureAffine(renderer: *Renderer, texture: *Texture, srcrect: ?*const sdl.FRect, origin: ?*const sdl.FPoint, right: ?*const sdl.FPoint, down: ?*const sdl.FPoint) Error!void {
    if (!SDL_RenderTextureAffine(renderer, texture, srcrect, origin, right, down)) return makeError();
}
extern fn SDL_RenderTextureAffine(renderer: *Renderer, texture: *Texture, srcrect: ?*const sdl.FRect, origin: ?*const sdl.FPoint, right: ?*const sdl.FPoint, down: ?*const sdl.FPoint) bool;

/// Tile a portion of the texture to the current rendering target at subpixel
/// precision.
///
/// The pixels in `srcrect` will be repeated as many times as needed to
/// completely fill `dstrect`.
pub fn renderTextureTiled(renderer: *Renderer, texture: *Texture, srcrect: ?*const sdl.FRect, scale: f32, dstrect: ?*const sdl.FRect) Error!void {
    if (!SDL_RenderTextureTiled(renderer, texture, srcrect, scale, dstrect)) return makeError();
}
extern fn SDL_RenderTextureTiled(renderer: *Renderer, texture: *Texture, srcrect: ?*const sdl.FRect, scale: f32, dstrect: ?*const sdl.FRect) bool;

/// Perform a scaled copy using the 9-grid algorithm to the current rendering
/// target at subpixel precision.
///
/// The pixels in the texture are split into a 3x3 grid, using the different
/// corner sizes for each corner, and the sides and center making up the
/// remaining pixels. The corners are then scaled using `scale` and fit into
/// the corners of the destination rectangle. The sides and center are then
/// stretched into place to cover the remaining destination rectangle.
pub fn renderTexture9Grid(renderer: *Renderer, texture: *Texture, srcrect: ?*const sdl.FRect, left_width: f32, right_width: f32, top_height: f32, bottom_height: f32, scale: f32, dstrect: ?*const sdl.FRect) Error!void {
    if (!SDL_RenderTexture9Grid(renderer, texture, srcrect, left_width, right_width, top_height, bottom_height, scale, dstrect)) return makeError();
}
extern fn SDL_RenderTexture9Grid(renderer: *Renderer, texture: *Texture, srcrect: ?*const sdl.FRect, left_width: f32, right_width: f32, top_height: f32, bottom_height: f32, scale: f32, dstrect: ?*const sdl.FRect) bool;

/// Perform a scaled copy using the 9-grid algorithm to the current rendering
/// target at subpixel precision.
///
/// The pixels in the texture are split into a 3x3 grid, using the different
/// corner sizes for each corner, and the sides and center making up the
/// remaining pixels. The corners are then scaled using `scale` and fit into
/// the corners of the destination rectangle. The sides and center are then
/// tiled into place to cover the remaining destination rectangle.
pub fn renderTexture9GridTiled(renderer: *Renderer, texture: *Texture, srcrect: ?*const sdl.FRect, left_width: f32, right_width: f32, top_height: f32, bottom_height: f32, scale: f32, dstrect: ?*const sdl.FRect, tileScale: f32) Error!void {
    if (!SDL_RenderTexture9GridTiled(renderer, texture, srcrect, left_width, right_width, top_height, bottom_height, scale, dstrect, tileScale)) return makeError();
}
extern fn SDL_RenderTexture9GridTiled(renderer: *Renderer, texture: *Texture, srcrect: ?*const sdl.FRect, left_width: f32, right_width: f32, top_height: f32, bottom_height: f32, scale: f32, dstrect: ?*const sdl.FRect, tileScale: f32) bool;

/// Render a list of triangles, optionally using a texture and indices into the
/// vertex array Color and alpha modulation is done per vertex
/// (`setTextureColorMod` and `setTextureAlphaMod` are ignored).
pub fn renderGeometry(renderer: *Renderer, texture: ?*Texture, vertices: []const Vertex, indices: ?[]const c_int) Error!void {
    if (!SDL_RenderGeometry(renderer, texture, vertices.ptr, @intCast(vertices.len), if (indices) |s| s.ptr else null, if (indices) |s| @intCast(s.len) else 0)) return makeError();
}
extern fn SDL_RenderGeometry(renderer: *Renderer, texture: ?*Texture, vertices: [*]const Vertex, num_vertices: c_int, indices: ?[*]const c_int, num_indices: c_int) bool;

/// Render a list of triangles, optionally using a texture and indices into the
/// vertex arrays Color and alpha modulation is done per vertex
/// (`setTextureColorMod` and `setTextureAlphaMod` are ignored).
pub fn renderGeometryRaw(renderer: *Renderer, texture: ?*Texture, xy: [*]const f32, xy_stride: c_int, color: [*]const sdl.FColor, color_stride: c_int, uv: ?[*]const f32, uv_stride: c_int, num_vertices: c_int, indices: ?*const anyopaque, num_indices: c_int, size_indices: c_int) Error!void {
    if (!SDL_RenderGeometryRaw(renderer, texture, xy, xy_stride, color, color_stride, uv, uv_stride, num_vertices, indices, num_indices, size_indices)) return makeError();
}
extern fn SDL_RenderGeometryRaw(renderer: *Renderer, texture: ?*Texture, xy: [*]const f32, xy_stride: c_int, color: [*]const sdl.FColor, color_stride: c_int, uv: ?[*]const f32, uv_stride: c_int, num_vertices: c_int, indices: ?*const anyopaque, num_indices: c_int, size_indices: c_int) bool;

/// Set the texture addressing mode used in `renderGeometry`.
pub fn setRenderTextureAddressMode(renderer: *Renderer, u_mode: TextureAddressMode, v_mode: TextureAddressMode) Error!void {
    if (!SDL_SetRenderTextureAddressMode(renderer, u_mode, v_mode)) return makeError();
}
extern fn SDL_SetRenderTextureAddressMode(renderer: *Renderer, u_mode: TextureAddressMode, v_mode: TextureAddressMode) bool;

/// Get the texture addressing mode used in `renderGeometry`.
pub fn getRenderTextureAddressMode(renderer: *Renderer) Error!struct { u: TextureAddressMode, v: TextureAddressMode } {
    var u_mode: TextureAddressMode = undefined;
    var v_mode: TextureAddressMode = undefined;
    if (!SDL_GetRenderTextureAddressMode(renderer, &u_mode, &v_mode)) return makeError();
    return .{ .u = u_mode, .v = v_mode };
}
extern fn SDL_GetRenderTextureAddressMode(renderer: *Renderer, u_mode: ?*TextureAddressMode, v_mode: ?*TextureAddressMode) bool;

/// Read pixels from the current rendering target.
///
/// The returned surface contains pixels inside the desired area clipped to the
/// current viewport, and should be freed with `destroySurface`.
///
/// Note that this returns the actual pixels on the screen, so if you are using
/// logical presentation you should use `getRenderLogicalPresentationRect`
/// to get the area containing your content.
///
/// **WARNING**: This is a very slow operation, and should not be used
/// frequently. If you're using this on the main rendering target, it should be
/// called after rendering and before `renderPresent`.
pub fn renderReadPixels(renderer: *Renderer, rect: ?*const sdl.Rect) Error!*sdl.Surface {
    return SDL_RenderReadPixels(renderer, rect) orelse makeError();
}
extern fn SDL_RenderReadPixels(renderer: *Renderer, rect: ?*const sdl.Rect) ?*sdl.Surface;

/// Update the screen with any rendering performed since the previous call.
///
/// SDL's rendering functions operate on a backbuffer; that is, calling a
/// rendering function such as `renderLine` does not directly put a line on
/// the screen, but rather updates the backbuffer. As such, you compose your
/// entire scene and *present* the composed backbuffer to the screen as a
/// complete picture.
///
/// Therefore, when using SDL's rendering API, one does all drawing intended
/// for the frame, and then calls this function once per frame to present the
/// final drawing to the user.
///
/// The backbuffer should be considered invalidated after each present; do not
/// assume that previous contents will exist between frames. You are strongly
/// encouraged to call `renderClear` to initialize the backbuffer before
/// starting each new frame's drawing, even if you plan to overwrite every
/// pixel.
///
/// Please note, that in case of rendering to a texture - there is **no need**
/// to call `renderPresent` after drawing needed objects to a texture, and
/// should not be done; you are only required to change back the rendering
/// target to default via ``setRenderTarget`(renderer, null)` afterwards, as
/// textures by themselves do not have a concept of backbuffers. Calling
/// `renderPresent` while rendering to a texture will fail.
pub fn renderPresent(renderer: *Renderer) Error!void {
    if (!SDL_RenderPresent(renderer)) return makeError();
}
extern fn SDL_RenderPresent(renderer: *Renderer) bool;

/// Destroy the specified texture.
///
/// Passing null or an otherwise invalid texture will set the SDL error message
/// to "Invalid texture".
pub const destroyTexture = SDL_DestroyTexture;
extern fn SDL_DestroyTexture(texture: *Texture) void;

/// Destroy the rendering context for a window and free all associated
/// textures.
///
/// This should be called before destroying the associated window.
pub const destroyRenderer = SDL_DestroyRenderer;
extern fn SDL_DestroyRenderer(renderer: *Renderer) void;

/// Force the rendering context to flush any pending commands and state.
///
/// You do not need to (and in fact, shouldn't) call this function unless you
/// are planning to call into OpenGL/Direct3D/Metal/whatever directly, in
/// addition to using a `Renderer`.
///
/// This is for a very-specific case: if you are using SDL's render API, and
/// you plan to make OpenGL/D3D/whatever calls in addition to SDL render API
/// calls. If this applies, you should call this function between calls to
/// SDL's render API and the low-level API you're using in cooperation.
///
/// In all other cases, you can ignore this function.
///
/// This call makes SDL flush any pending rendering work it was queueing up to
/// do later in a single batch, and marks any internal cached state as invalid,
/// so it'll prepare all its state again later, from scratch.
///
/// This means you do not need to save state in your rendering code to protect
/// the SDL renderer. However, there lots of arbitrary pieces of Direct3D and
/// OpenGL state that can confuse things; you should use your best judgment and
/// be prepared to make changes if specific state needs to be protected.
pub fn flushRenderer(renderer: *Renderer) Error!void {
    if (!SDL_FlushRenderer(renderer)) return makeError();
}
extern fn SDL_FlushRenderer(renderer: *Renderer) bool;

/// Get the CAMetalLayer associated with the given Metal renderer.
///
/// This function returns `void *`, so SDL doesn't have to include Metal's
/// headers, but it can be safely cast to a `CAMetalLayer *`.
pub const getRenderMetalLayer = SDL_GetRenderMetalLayer;
extern fn SDL_GetRenderMetalLayer(renderer: *Renderer) ?*anyopaque;

/// Get the Metal command encoder for the current frame.
///
/// This function returns `void *`, so SDL doesn't have to include Metal's
/// headers, but it can be safely cast to an `id<MTLRenderCommandEncoder>`.
///
/// This will return null if Metal refuses to give SDL a drawable to render to,
/// which might happen if the window is hidden/minimized/offscreen. This
/// doesn't apply to command encoders for render targets, just the window's
/// backbuffer. Check your return values!
pub fn getRenderMetalCommandEncoder(renderer: *Renderer) Error!*anyopaque {
    return SDL_GetRenderMetalCommandEncoder(renderer) orelse makeError();
}
extern fn SDL_GetRenderMetalCommandEncoder(renderer: *Renderer) ?*anyopaque;

/// Add a set of synchronization semaphores for the current frame.
///
/// The Vulkan renderer will wait for `wait_semaphore` before submitting
/// rendering commands and signal `signal_semaphore` after rendering commands
/// are complete for this frame.
///
/// This should be called each frame that you want semaphore synchronization.
/// The Vulkan renderer may have multiple frames in flight on the GPU, so you
/// should have multiple semaphores that are used for synchronization. Querying
/// `Renderer.Properties.vulkan_swapchain_image_count_number` will give you the
/// maximum number of semaphores you'll need.
pub fn addVulkanRenderSemaphores(renderer: *Renderer, wait_stage_mask: u32, wait_semaphore: i64, signal_semaphore: i64) Error!void {
    if (!SDL_AddVulkanRenderSemaphores(renderer, wait_stage_mask, wait_semaphore, signal_semaphore)) return makeError();
}
extern fn SDL_AddVulkanRenderSemaphores(renderer: *Renderer, wait_stage_mask: u32, wait_semaphore: i64, signal_semaphore: i64) bool;

/// Toggle VSync of the given renderer.
///
/// When a renderer is created, vsync defaults to `renderer_vsync_disabled`.
///
/// The `vsync` parameter can be 1 to synchronize present with every vertical
/// refresh, 2 to synchronize present with every second vertical refresh, etc.,
/// `renderer_vsync_adaptive` for late swap tearing (adaptive vsync), or
/// `renderer_vsync_disabled` to disable. Not every value is supported by
/// every driver, so you should check the return value to see whether the
/// requested setting is supported.
pub fn setRenderVSync(renderer: *Renderer, vsync: c_int) Error!void {
    if (!SDL_SetRenderVSync(renderer, vsync)) return makeError();
}
extern fn SDL_SetRenderVSync(renderer: *Renderer, vsync: c_int) bool;

pub const renderer_vsync_disabled = 0;
pub const renderer_vsync_adaptive = -1;
/// Get VSync of the given renderer.
pub fn getRenderVSync(renderer: *Renderer) Error!c_int {
    var vsync: c_int = undefined;
    if (!SDL_GetRenderVSync(renderer, &vsync)) return makeError();
    return vsync;
}
extern fn SDL_GetRenderVSync(renderer: *Renderer, vsync: *c_int) bool;

/// The size, in pixels, of a single `renderDebugText` character.
///
/// The font is monospaced and square, so this applies to all characters.
pub const debug_text_font_character_size = 8;

/// Draw debug text to a `Renderer`.
///
/// This function will render a string of text to a `Renderer`. Note that
/// this is a convenience function for debugging, with severe limitations, and
/// not intended to be used for production apps and games.
///
/// Among these limitations:
///
/// - It accepts UTF-8 strings, but will only renders ASCII characters.
/// - It has a single, tiny size (8x8 pixels). You can use logical presentation
///   or `setRenderScale` to adjust it.
/// - It uses a simple, hardcoded bitmap font. It does not allow different font
///   selections and it does not support truetype, for proper scaling.
/// - It does no word-wrapping and does not treat newline characters as a line
///   break. If the text goes out of the window, it's gone.
///
/// For serious text rendering, there are several good options, such as
/// SDL_ttf, stb_truetype, or other external libraries.
///
/// On first use, this will create an internal texture for rendering glyphs.
/// This texture will live until the renderer is destroyed.
///
/// The text is drawn in the color specified by `setRenderDrawColor`.
pub fn renderDebugText(renderer: *Renderer, x: f32, y: f32, str: [:0]const u8) Error!void {
    if (!SDL_RenderDebugText(renderer, x, y, str.ptr)) return makeError();
}
extern fn SDL_RenderDebugText(renderer: *Renderer, x: f32, y: f32, str: [*:0]const u8) bool;

/// Draw debug text to a `Renderer`.
///
/// This function will render a `std.fmt`-style format string to a renderer.
/// Note that this is a convenience function for debugging, with severe
/// limitations, and is not intended to be used for production apps and games.
///
/// For the full list of limitations and other useful information, see
/// `renderDebugText`.
pub fn renderDebugTextFormat(renderer: *Renderer, x: f32, y: f32, comptime fmt: []const u8, args: anytype) Error!void {
    var buf: [sdl.max_log_message]u8 = undefined;
    const text = std.fmt.bufPrintSentinel(&buf, fmt, args, 0) catch blk: {
        buf[buf.len - 1] = 0;
        break :blk buf[0 .. buf.len - 1 :0];
    };
    if (!SDL_RenderDebugTextFormat(renderer, x, y, "%s", text.ptr)) return makeError();
}
extern fn SDL_RenderDebugTextFormat(renderer: *Renderer, x: f32, y: f32, fmt: [*:0]const u8, ...) bool;

/// Set default scale mode for new textures for given renderer.
///
/// When a renderer is created, scale_mode defaults to `ScaleMode.linear`.
pub fn setDefaultTextureScaleMode(renderer: *Renderer, scale_mode: sdl.ScaleMode) Error!void {
    if (!SDL_SetDefaultTextureScaleMode(renderer, scale_mode)) return makeError();
}
extern fn SDL_SetDefaultTextureScaleMode(renderer: *Renderer, scale_mode: sdl.ScaleMode) bool;

/// Get default texture scale mode of the given renderer.
pub fn getDefaultTextureScaleMode(renderer: *Renderer) Error!sdl.ScaleMode {
    var scale_mode: sdl.ScaleMode = undefined;
    if (!SDL_GetDefaultTextureScaleMode(renderer, &scale_mode)) return makeError();
    return scale_mode;
}
extern fn SDL_GetDefaultTextureScaleMode(renderer: *Renderer, scale_mode: *sdl.ScaleMode) bool;

/// A structure specifying the parameters of a GPU render state.
pub const GPURenderStateCreateInfo = extern struct {
    /// The fragment shader to use when this render state is active
    fragment_shader: *sdl.GPUShader,
    /// The number of additional fragment samplers to bind when this render state is active
    num_sampler_bindings: i32 = 0,
    /// Additional fragment samplers to bind when this render state is active
    sampler_bindings: ?[*]const sdl.GPUTextureSamplerBinding = null,
    /// The number of storage textures to bind when this render state is active
    num_storage_textures: i32 = 0,
    /// Storage textures to bind when this render state is active
    storage_textures: ?[*]const *sdl.GPUTexture = null,
    /// The number of storage buffers to bind when this render state is active
    num_storage_buffers: i32 = 0,
    /// Storage buffers to bind when this render state is active
    storage_buffers: ?[*]const *sdl.GPUBuffer = null,
    /// A properties ID for extensions. Should be 0 if no extensions are needed.
    props: sdl.PropertiesId = .invalid,
};

/// A custom GPU render state.
pub const GPURenderState = opaque {
    pub const setFragmentUniforms = setGPURenderStateFragmentUniforms;
    pub const destroy = destroyGPURenderState;
};

/// Create custom GPU render state.
pub fn createGPURenderState(renderer: *Renderer, createinfo: *const GPURenderStateCreateInfo) Error!*GPURenderState {
    return SDL_CreateGPURenderState(renderer, createinfo) orelse makeError();
}
extern fn SDL_CreateGPURenderState(renderer: *Renderer, createinfo: *const GPURenderStateCreateInfo) ?*GPURenderState;

/// Set fragment shader uniform variables in a custom GPU render state.
///
/// The data is copied and will be pushed using
/// `pushGPUFragmentUniformData` during draw call execution.
pub fn setGPURenderStateFragmentUniforms(state: *GPURenderState, slot_index: u32, data: []const u8) Error!void {
    if (!SDL_SetGPURenderStateFragmentUniforms(state, slot_index, data.ptr, @intCast(data.len))) return makeError();
}
extern fn SDL_SetGPURenderStateFragmentUniforms(state: *GPURenderState, slot_index: u32, data: [*]const u8, length: u32) bool;

/// Set custom GPU render state.
///
/// This function sets custom GPU render state for subsequent draw calls. This
/// allows using custom shaders with the GPU renderer.
pub fn setGPURenderState(renderer: *Renderer, state: ?*GPURenderState) Error!void {
    if (!SDL_SetGPURenderState(renderer, state)) return makeError();
}
extern fn SDL_SetGPURenderState(renderer: *Renderer, state: ?*GPURenderState) bool;

/// Destroy custom GPU render state.
pub const destroyGPURenderState = SDL_DestroyGPURenderState;
extern fn SDL_DestroyGPURenderState(state: *GPURenderState) void;
