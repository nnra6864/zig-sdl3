//! 3D Rendering and GPU Compute (SDL_gpu.h)

const std = @import("std");
const builtin = @import("builtin");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// An opaque handle representing the SDL_GPU context.
pub const GPUDevice = opaque {
    pub const Properties = struct {
        pub const create_debugmode_boolean = "SDL.gpu.device.create.debugmode";
        pub const create_preferlowpower_boolean = "SDL.gpu.device.create.preferlowpower";
        pub const create_verbose_boolean = "SDL.gpu.device.create.verbose";
        pub const create_name_string = "SDL.gpu.device.create.name";
        pub const create_feature_clip_distance_boolean = "SDL.gpu.device.create.feature.clip_distance";
        pub const create_feature_depth_clamping_boolean = "SDL.gpu.device.create.feature.depth_clamping";
        pub const create_feature_indirect_draw_first_instance_boolean = "SDL.gpu.device.create.feature.indirect_draw_first_instance";
        pub const create_feature_anisotropy_boolean = "SDL.gpu.device.create.feature.anisotropy";
        pub const create_shaders_private_boolean = "SDL.gpu.device.create.shaders.private";
        pub const create_shaders_spirv_boolean = "SDL.gpu.device.create.shaders.spirv";
        pub const create_shaders_dxbc_boolean = "SDL.gpu.device.create.shaders.dxbc";
        pub const create_shaders_dxil_boolean = "SDL.gpu.device.create.shaders.dxil";
        pub const create_shaders_msl_boolean = "SDL.gpu.device.create.shaders.msl";
        pub const create_shaders_metallib_boolean = "SDL.gpu.device.create.shaders.metallib";
        pub const create_d3d12_allow_fewer_resource_slots_boolean = "SDL.gpu.device.create.d3d12.allowtier1resourcebinding";
        pub const create_d3d12_semantic_name_string = "SDL.gpu.device.create.d3d12.semantic";
        pub const create_d3d12_agility_sdk_version_number = "SDL.gpu.device.create.d3d12.agility_sdk_version";
        pub const create_d3d12_agility_sdk_path_string = "SDL.gpu.device.create.d3d12.agility_sdk_path";
        pub const create_vulkan_require_hardware_acceleration_boolean = "SDL.gpu.device.create.vulkan.requirehardwareacceleration";
        pub const create_vulkan_options_pointer = "SDL.gpu.device.create.vulkan.options";
        pub const create_metal_allow_macfamily1_boolean = "SDL.gpu.device.create.metal.allowmacfamily1";
        pub const name_string = "SDL.gpu.device.name";
        pub const driver_name_string = "SDL.gpu.device.driver_name";
        pub const driver_version_string = "SDL.gpu.device.driver_version";
        pub const driver_info_string = "SDL.gpu.device.driver_info";
    };
    pub const create = createGPUDevice;
    pub const createWithProperties = createGPUDeviceWithProperties;
    pub const destroy = destroyGPUDevice;
    pub const getDriver = getGPUDeviceDriver;
    pub const getShaderFormats = getGPUShaderFormats;
    pub const getProperties = getGPUDeviceProperties;
    pub const createComputePipeline = createGPUComputePipeline;
    pub const createGraphicsPipeline = createGPUGraphicsPipeline;
    pub const createSampler = createGPUSampler;
    pub const createShader = createGPUShader;
    pub const createTexture = createGPUTexture;
    pub const createBuffer = createGPUBuffer;
    pub const createTransferBuffer = createGPUTransferBuffer;
    pub const setBufferName = setGPUBufferName;
    pub const setTextureName = setGPUTextureName;
    pub const releaseTexture = releaseGPUTexture;
    pub const releaseSampler = releaseGPUSampler;
    pub const releaseBuffer = releaseGPUBuffer;
    pub const releaseTransferBuffer = releaseGPUTransferBuffer;
    pub const releaseComputePipeline = releaseGPUComputePipeline;
    pub const releaseShader = releaseGPUShader;
    pub const releaseGraphicsPipeline = releaseGPUGraphicsPipeline;
    pub const acquireCommandBuffer = acquireGPUCommandBuffer;
    pub const mapTransferBuffer = mapGPUTransferBuffer;
    pub const unmapTransferBuffer = unmapGPUTransferBuffer;
    pub const windowSupportsSwapchainComposition = windowSupportsGPUSwapchainComposition;
    pub const windowSupportsPresentMode = windowSupportsGPUPresentMode;
    pub const claimWindowFor = claimWindowForGPUDevice;
    pub const releaseWindowFrom = releaseWindowFromGPUDevice;
    pub const setSwapchainParameters = setGPUSwapchainParameters;
    pub const setAllowedFramesInFlight = setGPUAllowedFramesInFlight;
    pub const getSwapchainTextureFormat = getGPUSwapchainTextureFormat;
    pub const waitForSwapchain = waitForGPUSwapchain;
    pub const waitForIdle = waitForGPUIdle;
    pub const waitForFences = waitForGPUFences;
    pub const queryFence = queryGPUFence;
    pub const releaseFence = releaseGPUFence;
    pub const gdkSuspend = gdkSuspendGPU;
    pub const gdkResume = gdkResumeGPU;
};

/// An opaque handle representing a buffer.
///
/// Used for vertices, indices, indirect draw commands, and general compute
/// data.
pub const GPUBuffer = opaque {
    pub const Properties = struct {
        pub const create_name_string = "SDL.gpu.buffer.create.name";
    };
    pub const create = createGPUBuffer;
};

/// An opaque handle representing a transfer buffer.
///
/// Used for transferring data to and from the device.
pub const GPUTransferBuffer = opaque {
    pub const Properties = struct {
        pub const create_name_string = "SDL.gpu.transferbuffer.create.name";
    };
    pub const create = createGPUTransferBuffer;
};

/// An opaque handle representing a texture.
pub const GPUTexture = opaque {
    pub const Properties = struct {
        pub const create_d3d12_clear_r_float = "SDL.gpu.texture.create.d3d12.clear.r";
        pub const create_d3d12_clear_g_float = "SDL.gpu.texture.create.d3d12.clear.g";
        pub const create_d3d12_clear_b_float = "SDL.gpu.texture.create.d3d12.clear.b";
        pub const create_d3d12_clear_a_float = "SDL.gpu.texture.create.d3d12.clear.a";
        pub const create_d3d12_clear_depth_float = "SDL.gpu.texture.create.d3d12.clear.depth";
        pub const create_d3d12_clear_stencil_number = "SDL.gpu.texture.create.d3d12.clear.stencil";
        pub const create_name_string = "SDL.gpu.texture.create.name";
    };
    pub const create = createGPUTexture;
};

/// An opaque handle representing a sampler.
pub const GPUSampler = opaque {
    pub const Properties = struct {
        pub const create_name_string = "SDL.gpu.sampler.create.name";
    };
    pub const create = createGPUSampler;
};

/// An opaque handle representing a compiled shader object.
pub const GPUShader = opaque {
    pub const Properties = struct {
        pub const create_name_string = "SDL.gpu.shader.create.name";
    };
    pub const create = createGPUShader;
};

/// An opaque handle representing a compute pipeline.
///
/// Used during compute passes.
pub const GPUComputePipeline = opaque {
    pub const Properties = struct {
        pub const create_name_string = "SDL.gpu.computepipeline.create.name";
    };
    pub const create = createGPUComputePipeline;
};

/// An opaque handle representing a graphics pipeline.
///
/// Used during render passes.
pub const GPUGraphicsPipeline = opaque {
    pub const Properties = struct {
        pub const create_name_string = "SDL.gpu.graphicspipeline.create.name";
    };
    pub const create = createGPUGraphicsPipeline;
};

/// An opaque handle representing a command buffer.
///
/// Most state is managed via command buffers. When setting state using a
/// command buffer, that state is local to the command buffer.
///
/// Commands only begin execution on the GPU once `submitGPUCommandBuffer` is
/// called. Once the command buffer is submitted, it is no longer valid to use
/// it.
///
/// Command buffers are executed in submission order. If you submit command
/// buffer A and then command buffer B all commands in A will begin executing
/// before any command in B begins executing.
///
/// In multi-threading scenarios, you should only access a command buffer on
/// the thread you acquired it from.
pub const GPUCommandBuffer = opaque {
    pub const insertDebugLabel = insertGPUDebugLabel;
    pub const pushDebugGroup = pushGPUDebugGroup;
    pub const popDebugGroup = popGPUDebugGroup;
    pub const acquire = acquireGPUCommandBuffer;
    pub const pushVertexUniformData = pushGPUVertexUniformData;
    pub const pushFragmentUniformData = pushGPUFragmentUniformData;
    pub const pushComputeUniformData = pushGPUComputeUniformData;
    pub const beginRenderPass = beginGPURenderPass;
    pub const beginComputePass = beginGPUComputePass;
    pub const beginCopyPass = beginGPUCopyPass;
    pub const generateMipmapsForTexture = generateMipmapsForGPUTexture;
    pub const blitTexture = blitGPUTexture;
    pub const acquireSwapchainTexture = acquireGPUSwapchainTexture;
    pub const waitAndAcquireSwapchainTexture = waitAndAcquireGPUSwapchainTexture;
    pub const submit = submitGPUCommandBuffer;
    pub const submitAndAcquireFence = submitGPUCommandBufferAndAcquireFence;
    pub const cancel = cancelGPUCommandBuffer;
};

/// An opaque handle representing a render pass.
///
/// This handle is transient and should not be held or referenced after
/// `endGPURenderPass` is called.
pub const GPURenderPass = opaque {
    pub const begin = beginGPURenderPass;
    pub const bindGraphicsPipeline = bindGPUGraphicsPipeline;
    pub const setViewport = setGPUViewport;
    pub const setScissor = setGPUScissor;
    pub const setBlendConstants = setGPUBlendConstants;
    pub const setStencilReference = setGPUStencilReference;
    pub const bindVertexBuffers = bindGPUVertexBuffers;
    pub const bindIndexBuffer = bindGPUIndexBuffer;
    pub const bindVertexSamplers = bindGPUVertexSamplers;
    pub const bindVertexStorageTextures = bindGPUVertexStorageTextures;
    pub const bindVertexStorageBuffers = bindGPUVertexStorageBuffers;
    pub const bindFragmentSamplers = bindGPUFragmentSamplers;
    pub const bindFragmentStorageTextures = bindGPUFragmentStorageTextures;
    pub const bindFragmentStorageBuffers = bindGPUFragmentStorageBuffers;
    pub const drawIndexedPrimitives = drawGPUIndexedPrimitives;
    pub const drawPrimitives = drawGPUPrimitives;
    pub const drawPrimitivesIndirect = drawGPUPrimitivesIndirect;
    pub const drawIndexedPrimitivesIndirect = drawGPUIndexedPrimitivesIndirect;
    pub const end = endGPURenderPass;
};

/// An opaque handle representing a compute pass.
///
/// This handle is transient and should not be held or referenced after
/// `endGPUComputePass` is called.
pub const GPUComputePass = opaque {
    pub const begin = beginGPUComputePass;
    pub const bindComputePipeline = bindGPUComputePipeline;
    pub const bindComputeSamplers = bindGPUComputeSamplers;
    pub const bindComputeStorageTextures = bindGPUComputeStorageTextures;
    pub const bindComputeStorageBuffers = bindGPUComputeStorageBuffers;
    pub const dispatchCompute = dispatchGPUCompute;
    pub const dispatchComputeIndirect = dispatchGPUComputeIndirect;
    pub const end = endGPUComputePass;
};

/// An opaque handle representing a copy pass.
///
/// This handle is transient and should not be held or referenced after
/// `endGPUCopyPass` is called.
pub const GPUCopyPass = opaque {
    pub const begin = beginGPUCopyPass;
    pub const uploadToTexture = uploadToGPUTexture;
    pub const uploadToBuffer = uploadToGPUBuffer;
    pub const copyTextureToTexture = copyGPUTextureToTexture;
    pub const copyBufferToBuffer = copyGPUBufferToBuffer;
    pub const downloadFromTexture = downloadFromGPUTexture;
    pub const downloadFromBuffer = downloadFromGPUBuffer;
    pub const end = endGPUCopyPass;
};

/// An opaque handle representing a fence.
pub const GPUFence = opaque {
    pub const submitCommandBufferAndAcquire = submitGPUCommandBufferAndAcquireFence;
};

/// Specifies the primitive topology of a graphics pipeline.
///
/// If you are using POINTLIST you must include a point size output in the
/// vertex shader.
///
/// - For HLSL compiling to SPIRV you must decorate a float output with
///   [[vk::builtin("PointSize")]].
/// - For GLSL you must set the gl_PointSize builtin.
/// - For MSL you must include a float output with the [[point_size]]
///   decorator.
///
/// Note that sized point topology is totally unsupported on D3D12. Any size
/// other than 1 will be ignored. In general, you should avoid using point
/// topology for both compatibility and performance reasons. You WILL regret
/// using it.
pub const GPUPrimitiveType = enum(c_int) {
    /// A series of separate triangles.
    trianglelist = 0,
    /// A series of connected triangles.
    trianglestrip,
    /// A series of separate lines.
    linelist,
    /// A series of connected lines.
    linestrip,
    /// A series of separate points.
    pointlist,
};

/// Specifies how the contents of a texture attached to a render pass are
/// treated at the beginning of the render pass.
pub const GPULoadOp = enum(c_int) {
    /// The previous contents of the texture will be preserved.
    load = 0,
    /// The contents of the texture will be cleared to a color.
    clear,
    /// The previous contents of the texture need not be preserved. The contents
    /// will be undefined.
    dont_care,
};

/// Specifies how the contents of a texture attached to a render pass are
/// treated at the end of the render pass.
pub const GPUStoreOp = enum(c_int) {
    /// The contents generated during the render pass will be written to memory.
    store = 0,
    /// The contents generated during the render pass are not needed and may be
    /// discarded. The contents will be undefined.
    dont_care,
    /// The multisample contents generated during the render pass will be
    /// resolved to a non-multisample texture. The contents in the multisample
    /// texture may then be discarded and will be undefined.
    resolve,
    /// The multisample contents generated during the render pass will be
    /// resolved to a non-multisample texture. The contents in the multisample
    /// texture will be written to memory.
    resolve_and_store,
};

/// Specifies the size of elements in an index buffer.
pub const GPUIndexElementSize = enum(c_int) {
    ///  The index elements are 16-bit.
    size_16bit = 0,
    ///  The index elements are 32-bit.
    size_32bit,
};

/// Specifies the pixel format of a texture.
///
/// Texture format support varies depending on driver, hardware, and usage
/// flags. In general, you should use `gpuTextureSupportsFormat` to query if
/// a format is supported before using it. However, there are a few guaranteed
/// formats.
///
/// For SAMPLER usage, the following formats are universally supported:
///
/// - R8G8B8A8_UNORM
/// - B8G8R8A8_UNORM
/// - R8_UNORM
/// - R8_SNORM
/// - R8G8_UNORM
/// - R8G8_SNORM
/// - R8G8B8A8_SNORM
/// - R16_FLOAT
/// - R16G16_FLOAT
/// - R16G16B16A16_FLOAT
/// - R32_FLOAT
/// - R32G32_FLOAT
/// - R32G32B32A32_FLOAT
/// - R11G11B10_UFLOAT
/// - R8G8B8A8_UNORM_SRGB
/// - B8G8R8A8_UNORM_SRGB
/// - D16_UNORM
///
/// For COLOR_TARGET usage, the following formats are universally supported:
///
/// - R8G8B8A8_UNORM
/// - B8G8R8A8_UNORM
/// - R8_UNORM
/// - R16_FLOAT
/// - R16G16_FLOAT
/// - R16G16B16A16_FLOAT
/// - R32_FLOAT
/// - R32G32_FLOAT
/// - R32G32B32A32_FLOAT
/// - R8_UINT
/// - R8G8_UINT
/// - R8G8B8A8_UINT
/// - R16_UINT
/// - R16G16_UINT
/// - R16G16B16A16_UINT
/// - R8_INT
/// - R8G8_INT
/// - R8G8B8A8_INT
/// - R16_INT
/// - R16G16_INT
/// - R16G16B16A16_INT
/// - R8G8B8A8_UNORM_SRGB
/// - B8G8R8A8_UNORM_SRGB
///
/// For STORAGE usages, the following formats are universally supported:
///
/// - R8G8B8A8_UNORM
/// - R8G8B8A8_SNORM
/// - R16G16B16A16_FLOAT
/// - R32_FLOAT
/// - R32G32_FLOAT
/// - R32G32B32A32_FLOAT
/// - R8G8B8A8_UINT
/// - R16G16B16A16_UINT
/// - R8G8B8A8_INT
/// - R16G16B16A16_INT
///
/// For DEPTH_STENCIL_TARGET usage, the following formats are universally
/// supported:
///
/// - D16_UNORM
/// - Either (but not necessarily both!) D24_UNORM or D32_FLOAT
/// - Either (but not necessarily both!) D24_UNORM_S8_UINT or D32_FLOAT_S8_UINT
///
/// Unless D16_UNORM is sufficient for your purposes, always check which of
/// D24/D32 is supported before creating a depth-stencil texture!
pub const GPUTextureFormat = enum(c_uint) {
    invalid = 0,

    // Unsigned Normalized Float Color Formats
    a8_unorm,
    r8_unorm,
    r8g8_unorm,
    r8g8b8a8_unorm,
    r16_unorm,
    r16g16_unorm,
    r16g16b16a16_unorm,
    r10g10b10a2_unorm,
    b5g6r5_unorm,
    b5g5r5a1_unorm,
    b4g4r4a4_unorm,
    b8g8r8a8_unorm,

    // Compressed Unsigned Normalized Float Color Formats
    bc1_rgba_unorm,
    bc2_rgba_unorm,
    bc3_rgba_unorm,
    bc4_r_unorm,
    bc5_rg_unorm,
    bc7_rgba_unorm,

    // Compressed Signed Float Color Formats
    bc6h_rgb_float,

    // Compressed Unsigned Float Color Formats
    bc6h_rgb_ufloat,

    // Signed Normalized Float Color Formats
    r8_snorm,
    r8g8_snorm,
    r8g8b8a8_snorm,
    r16_snorm,
    r16g16_snorm,
    r16g16b16a16_snorm,

    // Signed Float Color Formats
    r16_float,
    r16g16_float,
    r16g16b16a16_float,
    r32_float,
    r32g32_float,
    r32g32b32a32_float,

    // Unsigned Float Color Formats
    r11g11b10_ufloat,

    // Unsigned Integer Color Formats
    r8_uint,
    r8g8_uint,
    r8g8b8a8_uint,
    r16_uint,
    r16g16_uint,
    r16g16b16a16_uint,
    r32_uint,
    r32g32_uint,
    r32g32b32a32_uint,

    // Signed Integer Color Formats
    r8_int,
    r8g8_int,
    r8g8b8a8_int,
    r16_int,
    r16g16_int,
    r16g16b16a16_int,
    r32_int,
    r32g32_int,
    r32g32b32a32_int,

    // SRGB Unsigned Normalized Color Formats
    r8g8b8a8_unorm_srgb,
    b8g8r8a8_unorm_srgb,

    // Compressed SRGB Unsigned Normalized Color Formats
    bc1_rgba_unorm_srgb,
    bc2_rgba_unorm_srgb,
    bc3_rgba_unorm_srgb,
    bc7_rgba_unorm_srgb,

    // Depth Formats
    d16_unorm,
    d24_unorm,
    d32_float,
    d24_unorm_s8_uint,
    d32_float_s8_uint,

    // Compressed ASTC Normalized Float Color Formats
    astc_4x4_unorm,
    astc_5x4_unorm,
    astc_5x5_unorm,
    astc_6x5_unorm,
    astc_6x6_unorm,
    astc_8x5_unorm,
    astc_8x6_unorm,
    astc_8x8_unorm,
    astc_10x5_unorm,
    astc_10x6_unorm,
    astc_10x8_unorm,
    astc_10x10_unorm,
    astc_12x10_unorm,
    astc_12x12_unorm,

    // Compressed SRGB ASTC Normalized Float Color Formats
    astc_4x4_unorm_srgb,
    astc_5x4_unorm_srgb,
    astc_5x5_unorm_srgb,
    astc_6x5_unorm_srgb,
    astc_6x6_unorm_srgb,
    astc_8x5_unorm_srgb,
    astc_8x6_unorm_srgb,
    astc_8x8_unorm_srgb,
    astc_10x5_unorm_srgb,
    astc_10x6_unorm_srgb,
    astc_10x8_unorm_srgb,
    astc_10x10_unorm_srgb,
    astc_12x10_unorm_srgb,
    astc_12x12_unorm_srgb,

    // Compressed ASTC Signed Float Color Formats
    astc_4x4_float,
    astc_5x4_float,
    astc_5x5_float,
    astc_6x5_float,
    astc_6x6_float,
    astc_8x5_float,
    astc_8x6_float,
    astc_8x8_float,
    astc_10x5_float,
    astc_10x6_float,
    astc_10x8_float,
    astc_10x10_float,
    astc_12x10_float,
    astc_12x12_float,
};

/// Specifies how a texture is intended to be used by the client.
///
/// A texture must have at least one usage flag.
/// Note that combining SAMPLER with STORAGE_READ flags is invalid.
///
/// With regards to compute storage usage, READ | WRITE means that you can have
/// shader A that only writes into the texture and shader B that only reads
/// from the texture and bind the same texture to either shader respectively.
/// SIMULTANEOUS means that you can do reads and writes within the same shader
/// or compute pass. It also implies that atomic ops can be used, since those
/// are read-modify-write operations. If you use SIMULTANEOUS, you are
/// responsible for avoiding data races, as there is no data synchronization
/// within a compute pass. Note that SIMULTANEOUS usage is only supported by a
/// limited number of texture formats.
pub const GPUTextureUsageFlags = packed struct(u32) {
    sampler: bool = false,
    color_target: bool = false,
    depth_stencil_target: bool = false,
    graphics_storage_read: bool = false,
    compute_storage_read: bool = false,
    compute_storage_write: bool = false,
    compute_storage_simultaneous_read_write: bool = false,

    __unused: u25 = 0,
};

/// Specifies the type of a texture.
pub const GPUTextureType = enum(c_int) {
    texturetype_2d = 0,
    texturetype_2d_array,
    texturetype_3d,
    texturetype_cube,
    texturetype_cube_array,
};

/// Specifies the sample count of a texture.
///
/// Used in multisampling. Note that this value only applies when the texture
/// is used as a render target.
pub const GPUSampleCount = enum(c_int) {
    samplecount_1 = 0,
    samplecount_2,
    samplecount_4,
    samplecount_8,
};

/// Specifies the face of a cube map.
///
/// Can be passed in as the layer field in texture-related structs.
pub const GPUCubeMapFace = enum(c_int) {
    positive_x = 0,
    negative_x,
    positive_y,
    negative_y,
    positive_z,
    negative_z,
};

/// Specifies how a buffer is intended to be used by the client.
///
/// A buffer must have at least one usage flag.
///
/// If a buffer has multiple read usages, this may lead to a performance penalty
/// due to more conservative memory barriers, but it also may not necessarily affect the performance.
///
/// Unlike textures, READ | WRITE can be used for simultaneous read-write
/// usage. The same data synchronization concerns as textures apply.
///
/// If you use a STORAGE flag, the data in the buffer must respect std140
/// layout conventions. In practical terms this means you must ensure that vec3
/// and vec4 fields are 16-byte aligned.
pub const GPUBufferUsageFlags = packed struct(u32) {
    /// Buffer is a vertex buffer.
    vertex: bool = false,
    /// Buffer is an index buffer.
    index: bool = false,
    /// Buffer is an indirect buffer.
    indirect: bool = false,
    /// Buffer supports storage reads in graphics stages.
    graphics_storage_read: bool = false,
    /// Buffer supports storage reads in the compute stage.
    compute_storage_read: bool = false,
    /// Buffer supports storage writes in the compute stage.
    compute_storage_write: bool = false,

    __unused: u26 = 0,
};

/// Specifies how a transfer buffer is intended to be used by the client.
///
/// Note that mapping and copying FROM an upload transfer buffer or TO a
/// download transfer buffer is undefined behavior.
pub const GPUTransferBufferUsage = enum(c_int) {
    upload = 0,
    download,
};

/// Specifies which stage a shader program corresponds to.
pub const GPUShaderStage = enum(c_int) {
    vertex = 0,
    fragment,
};

/// Specifies the format of shader code.
///
/// Each format corresponds to a specific backend that accepts it.
pub const GPUShaderFormat = packed struct(u32) {
    /// Shaders for NDA'd platforms.
    private: bool = false,
    /// SPIR-V shaders for Vulkan.
    spirv: bool = false,
    /// DXBC SM5_1 shaders for D3D12.
    dxbc: bool = false,
    /// DXIL SM6_0 shaders for D3D12.
    dxil: bool = false,
    /// MSL shaders for Metal.
    msl: bool = false,
    /// Precompiled metallib shaders for Metal.
    metallib: bool = false,

    __unused: u26 = 0,
};

/// Specifies the format of a vertex attribute.
pub const GPUVertexElementFormat = enum(c_int) {
    invalid = 0,

    // 32-bit Signed Integers
    int,
    int2,
    int3,
    int4,

    // 32-bit Unsigned Integers
    uint,
    uint2,
    uint3,
    uint4,

    // 32-bit Floats
    float,
    float2,
    float3,
    float4,

    // 8-bit Signed Integers
    byte2,
    byte4,

    // 8-bit Unsigned Integers
    ubyte2,
    ubyte4,

    // 8-bit Signed Normalized
    byte2_norm,
    byte4_norm,

    // 8-bit Unsigned Normalized
    ubyte2_norm,
    ubyte4_norm,

    // 16-bit Signed Integers
    short2,
    short4,

    // 16-bit Unsigned Integers
    ushort2,
    ushort4,

    // 16-bit Signed Normalized
    short2_norm,
    short4_norm,

    // 16-bit Unsigned Normalized
    ushort2_norm,
    ushort4_norm,

    // 16-bit Floats
    half2,
    half4,
};

/// Specifies the rate at which vertex attributes are pulled from buffers.
pub const GPUVertexInputRate = enum(c_int) {
    ///  Attribute addressing is a function of the vertex index.
    vertex = 0,
    ///  Attribute addressing is a function of the instance index.
    instance,
};

/// Specifies the fill mode of the graphics pipeline.
pub const GPUFillMode = enum(c_int) {
    ///  Polygons will be rendered via rasterization.
    fill = 0,
    ///  Polygon edges will be drawn as line segments.
    line,
};

/// Specifies the facing direction in which triangle faces will be culled.
pub const GPUCullMode = enum(c_int) {
    ///  No triangles are culled.
    none = 0,
    ///  Front-facing triangles are culled.
    front,
    ///  Back-facing triangles are culled.
    back,
};

/// Specifies the vertex winding that will cause a triangle to be determined to
/// be front-facing.
pub const GPUFrontFace = enum(c_int) {
    ///  A triangle with counter-clockwise vertex winding will be considered front-facing.
    counter_clockwise = 0,
    ///  A triangle with clockwise vertex winding will be considered front-facing.
    clockwise,
};

/// Specifies a comparison operator for depth, stencil and sampler operations.
pub const GPUCompareOp = enum(c_int) {
    invalid = 0,
    ///  The comparison always evaluates false.
    never,
    ///  The comparison evaluates reference < test.
    less,
    ///  The comparison evaluates reference == test.
    equal,
    ///  The comparison evaluates reference <= test.
    less_or_equal,
    ///  The comparison evaluates reference > test.
    greater,
    ///  The comparison evaluates reference != test.
    not_equal,
    ///  The comparison evaluates reference >= test.
    greater_or_equal,
    ///  The comparison always evaluates true.
    always,
};

/// Specifies what happens to a stored stencil value if stencil tests fail or
/// pass.
pub const GPUStencilOp = enum(c_int) {
    invalid = 0,
    ///  Keeps the current value.
    keep,
    ///  Sets the value to 0.
    zero,
    ///  Sets the value to reference.
    replace,
    ///  Increments the current value and clamps to the maximum value.
    increment_and_clamp,
    ///  Decrements the current value and clamps to 0.
    decrement_and_clamp,
    ///  Bitwise-inverts the current value.
    invert,
    ///  Increments the current value and wraps back to 0.
    increment_and_wrap,
    ///  Decrements the current value and wraps to the maximum value.
    decrement_and_wrap,
};

/// Specifies the operator to be used when pixels in a render target are
/// blended with existing pixels in the texture.
///
/// The source color is the value written by the fragment shader. The
/// destination color is the value currently existing in the texture.
pub const GPUBlendOp = enum(c_int) {
    invalid = 0,
    /// (source * source_factor) + (destination * destination_factor)
    add,
    /// (source * source_factor) - (destination * destination_factor)
    subtract,
    /// (destination * destination_factor) - (source * source_factor)
    reverse_subtract,
    /// min(source, destination)
    min,
    /// max(source, destination)
    max,
};

/// Specifies a blending factor to be used when pixels in a render target are
/// blended with existing pixels in the texture.
///
/// The source color is the value written by the fragment shader. The
/// destination color is the value currently existing in the texture.
pub const GPUBlendFactor = enum(c_int) {
    invalid = 0,
    zero,
    one,
    /// source color
    src_color,
    /// 1 - source color
    one_minus_src_color,
    /// destination color
    dst_color,
    /// 1 - destination color
    one_minus_dst_color,
    /// source alpha
    src_alpha,
    /// 1 - source alpha
    one_minus_src_alpha,
    /// destination alpha
    dst_alpha,
    /// 1 - destination alpha
    one_minus_dst_alpha,
    /// blend constant
    constant_color,
    /// 1 - blend constant
    one_minus_constant_color,
    /// min(source alpha, 1 - destination alpha)
    src_alpha_saturate,
};

/// Specifies which color components are written in a graphics pipeline.
pub const GPUColorComponentFlags = packed struct(u8) {
    red: bool = false,
    green: bool = false,
    blue: bool = false,
    alpha: bool = false,

    __padding: u4 = 0,
};

/// Specifies a filter operation used by a sampler.
pub const GPUFilter = enum(c_int) {
    /// Point filtering.
    nearest = 0,
    /// Linear filtering.
    linear,
};

/// Specifies a mipmap mode used by a sampler.
pub const GPUSamplerMipmapMode = enum(c_int) {
    /// Point filtering.
    nearest = 0,
    /// Linear filtering.
    linear,
};

/// Specifies behavior of texture sampling when the coordinates exceed the 0-1
/// range.
pub const GPUSamplerAddressMode = enum(c_int) {
    /// Specifies that the coordinates will wrap around.
    repeat = 0,
    /// Specifies that the coordinates will wrap around mirrored.
    mirrored_repeat,
    /// Specifies that the coordinates will clamp to the 0-1 range.
    clamp_to_edge,
};

/// Specifies the timing that will be used to present swapchain textures to the
/// OS.
///
/// VSYNC mode will always be supported. IMMEDIATE and MAILBOX modes may not be
/// supported on certain systems.
///
/// It is recommended to query `windowSupportsGPUPresentMode` after claiming
/// the window if you wish to change the present mode to IMMEDIATE or MAILBOX.
///
/// - VSYNC: Waits for vblank before presenting. No tearing is possible. If
///   there is a pending image to present, the new image is enqueued for
///   presentation. Disallows tearing at the cost of visual latency.
/// - IMMEDIATE: Immediately presents. Lowest latency option, but tearing may
///   occur.
/// - MAILBOX: Waits for vblank before presenting. No tearing is possible. If
///   there is a pending image to present, the pending image is replaced by the
///   new image. Similar to VSYNC, but with reduced visual latency.
pub const GPUPresentMode = enum(c_int) {
    vsync = 0,
    immediate,
    mailbox,
};

/// Specifies the texture format and colorspace of the swapchain textures.
///
/// SDR will always be supported. Other compositions may not be supported on
/// certain systems.
///
/// It is recommended to query `windowSupportsGPUSwapchainComposition` after
/// claiming the window if you wish to change the swapchain composition from
/// SDR.
///
/// - SDR: B8G8R8A8 or R8G8B8A8 swapchain. Pixel values are in sRGB encoding.
/// - SDR_LINEAR: B8G8R8A8_SRGB or R8G8B8A8_SRGB swapchain. Pixel values are
///   stored in memory in sRGB encoding but accessed in shaders in "linear
///   sRGB" encoding which is sRGB but with a linear transfer function.
/// - HDR_EXTENDED_LINEAR: R16G16B16A16_FLOAT swapchain. Pixel values are in
///   extended linear sRGB encoding and permits values outside of the [0, 1]
///   range.
/// - HDR10_ST2084: A2R10G10B10 or A2B10G10R10 swapchain. Pixel values are in
///   BT.2020 ST2084 (PQ) encoding.
pub const GPUSwapchainComposition = enum(c_int) {
    sdr = 0,
    sdr_linear,
    hdr_extended_linear,
    hdr10_st2084,
};

/// A structure specifying a viewport.
pub const GPUViewport = extern struct {
    ///  The left offset of the viewport.
    x: f32,
    ///  The top offset of the viewport.
    y: f32,
    ///  The width of the viewport.
    w: f32,
    ///  The height of the viewport.
    h: f32,
    ///  The minimum depth of the viewport.
    min_depth: f32,
    ///  The maximum depth of the viewport.
    max_depth: f32,
};

/// A structure specifying parameters related to transferring data to or from a
/// texture.
///
/// If either of `pixels_per_row` or `rows_per_layer` is zero, then width and
/// height of passed `GPUTextureRegion` to `uploadToGPUTexture` or
/// `downloadFromGPUTexture` are used as default values respectively and data
/// is considered to be tightly packed.
///
/// **WARNING**: On some older/integrated hardware, Direct3D 12 requires
/// texture data row pitch to be 256 byte aligned, and offsets to be aligned to
/// 512 bytes. If they are not, SDL will make a temporary copy of the data that
/// is properly aligned, but this adds overhead to the transfer process. Apps
/// can avoid this by aligning their data appropriately, or using a different
/// GPU backend than Direct3D 12.
pub const GPUTextureTransferInfo = extern struct {
    ///  The transfer buffer used in the transfer operation.
    transfer_buffer: *GPUTransferBuffer,
    ///  The starting byte of the image data in the transfer buffer.
    offset: u32,
    ///  The number of pixels from one row to the next.
    pixels_per_row: u32,
    ///  The number of rows from one layer/depth-slice to the next.
    rows_per_layer: u32,
};

/// A structure specifying a location in a transfer buffer.
///
/// Used when transferring buffer data to or from a transfer buffer.
pub const GPUTransferBufferLocation = extern struct {
    ///  The transfer buffer used in the transfer operation.
    transfer_buffer: *GPUTransferBuffer,
    /// The starting byte of the buffer data in the transfer buffer.
    offset: u32,
};

/// A structure specifying a location in a texture.
///
/// Used when copying data from one texture to another.
pub const GPUTextureLocation = extern struct {
    ///  The texture used in the copy operation.
    texture: *GPUTexture,
    ///  The mip level index of the location.
    mip_level: u32,
    ///  The layer index of the location.
    layer: u32,
    ///  The left offset of the location.
    x: u32,
    ///  The top offset of the location.
    y: u32,
    ///  The front offset of the location.
    z: u32,
};

/// A structure specifying a region of a texture.
///
/// Used when transferring data to or from a texture.
pub const GPUTextureRegion = extern struct {
    ///  The texture used in the copy operation.
    texture: *GPUTexture,
    ///  The mip level index to transfer.
    mip_level: u32,
    ///  The layer index to transfer.
    layer: u32,
    ///  The left offset of the region.
    x: u32,
    ///  The top offset of the region.
    y: u32,
    ///  The front offset of the region.
    z: u32,
    ///  The width of the region.
    w: u32,
    ///  The height of the region.
    h: u32,
    ///  The depth of the region.
    d: u32,
};

/// A structure specifying a region of a texture used in the blit operation.
pub const GPUBlitRegion = extern struct {
    ///  The texture.
    texture: *GPUTexture,
    ///  The mip level index of the region.
    mip_level: u32,
    ///  The layer index or depth plane of the region. This value is treated as a layer index on 2D array and cube textures, and as a depth plane on 3D textures.
    layer_or_depth_plane: u32,
    ///  The left offset of the region.
    x: u32,
    ///  The top offset of the region.
    y: u32,
    ///  The width of the region.
    w: u32,
    ///  The height of the region.
    h: u32,
};

/// A structure specifying a location in a buffer.
///
/// Used when copying data between buffers.
pub const GPUBufferLocation = extern struct {
    ///  The buffer.
    buffer: *GPUBuffer,
    ///  The starting byte within the buffer.
    offset: u32,
};

/// A structure specifying a region of a buffer.
///
/// Used when transferring data to or from buffers.
pub const GPUBufferRegion = extern struct {
    ///  The buffer.
    buffer: *GPUBuffer,
    ///  The starting byte within the buffer.
    offset: u32,
    ///  The size in bytes of the region.
    size: u32,
};

/// A structure specifying the parameters of an indirect draw command.
///
/// Note that the `first_vertex` and `first_instance` parameters are NOT
/// compatible with built-in vertex/instance ID variables in shaders (for
/// example, SV_VertexID); GPU APIs and shader languages do not define these
/// built-in variables consistently, so if your shader depends on them, the
/// only way to keep behavior consistent and portable is to always pass 0 for
/// the correlating parameter in the draw calls.
pub const GPUIndirectDrawCommand = extern struct {
    ///  The number of vertices to draw.
    num_vertices: u32,
    ///  The number of instances to draw.
    num_instances: u32,
    ///  The index of the first vertex to draw.
    first_vertex: u32,
    ///  The ID of the first instance to draw.
    first_instance: u32,
};

/// A structure specifying the parameters of an indexed indirect draw command.
///
/// Note that the `first_vertex` and `first_instance` parameters are NOT
/// compatible with built-in vertex/instance ID variables in shaders (for
/// example, SV_VertexID); GPU APIs and shader languages do not define these
/// built-in variables consistently, so if your shader depends on them, the
/// only way to keep behavior consistent and portable is to always pass 0 for
/// the correlating parameter in the draw calls.
pub const GPUIndexedIndirectDrawCommand = extern struct {
    ///  The number of indices to draw per instance.
    num_indices: u32,
    ///  The number of instances to draw.
    num_instances: u32,
    ///  The base index within the index buffer.
    first_index: u32,
    ///  The value added to the vertex index before indexing into the vertex buffer.
    vertex_offset: i32,
    ///  The ID of the first instance to draw.
    first_instance: u32,
};

/// A structure specifying the parameters of an indexed dispatch command.
pub const GPUIndirectDispatchCommand = extern struct {
    ///  The number of local workgroups to dispatch in the X dimension.
    groupcount_x: u32,
    ///  The number of local workgroups to dispatch in the Y dimension.
    groupcount_y: u32,
    ///  The number of local workgroups to dispatch in the Z dimension.
    groupcount_z: u32,
};

/// A structure specifying the parameters of a sampler.
///
/// Note that mip_lod_bias is a no-op for the Metal driver. For Metal, LOD bias
/// must be applied via shader instead.
pub const GPUSamplerCreateInfo = extern struct {
    /// The minification filter to apply to lookups.
    min_filter: GPUFilter,
    /// The magnification filter to apply to lookups.
    mag_filter: GPUFilter,
    /// The mipmap filter to apply to lookups.
    mipmap_mode: GPUSamplerMipmapMode,
    /// The addressing mode for U coordinates outside [0, 1).
    address_mode_u: GPUSamplerAddressMode,
    /// The addressing mode for V coordinates outside [0, 1).
    address_mode_v: GPUSamplerAddressMode,
    /// The addressing mode for W coordinates outside [0, 1).
    address_mode_w: GPUSamplerAddressMode,
    /// The bias to be added to mipmap LOD calculation.
    mip_lod_bias: f32,
    /// The anisotropy value clamp used by the sampler. If enable_anisotropy is false, this is ignored.
    max_anisotropy: f32,
    /// The comparison operator to apply to fetched data before filtering.
    compare_op: GPUCompareOp,
    /// Clamps the minimum of the computed LOD value.
    min_lod: f32,
    /// Clamps the maximum of the computed LOD value.
    max_lod: f32,
    /// true to enable anisotropic filtering.
    enable_anisotropy: bool,
    /// true to enable comparison against a reference value during lookups.
    enable_compare: bool,

    padding1: u8 = 0,
    padding2: u8 = 0,

    /// A properties ID for extensions. Should be 0 if no extensions are needed.
    props: sdl.PropertiesId = .invalid,
};

/// A structure specifying the parameters of vertex buffers used in a graphics
/// pipeline.
///
/// When you call `bindGPUVertexBuffers`, you specify the binding slots of
/// the vertex buffers. For example if you called `bindGPUVertexBuffers` with
/// a first_slot of 2 and num_bindings of 3, the binding slots 2, 3, 4 would be
/// used by the vertex buffers you pass in.
///
/// Vertex attributes are linked to buffers via the buffer_slot field of
/// `GPUVertexAttribute`. For example, if an attribute has a buffer_slot of
/// 0, then that attribute belongs to the vertex buffer bound at slot 0.
pub const GPUVertexBufferDescription = extern struct {
    /// The binding slot of the vertex buffer.
    slot: u32,
    /// The size of a single element + the offset between elements.
    pitch: u32,
    /// Whether attribute addressing is a function of the vertex index or instance index.
    input_rate: GPUVertexInputRate,
    /// Reserved for future use. Must be set to 0.
    instance_step_rate: u32 = 0,
};

/// A structure specifying a vertex attribute.
///
/// All vertex attribute locations provided to a `GPUVertexInputState` must
/// be unique.
pub const GPUVertexAttribute = extern struct {
    /// The shader input location index.
    location: u32,
    /// The binding slot of the associated vertex buffer.
    buffer_slot: u32,
    /// The size and type of the attribute data.
    format: GPUVertexElementFormat,
    /// The byte offset of this attribute relative to the start of the vertex element.
    offset: u32,
};

/// A structure specifying the parameters of a graphics pipeline vertex input
/// state.
pub const GPUVertexInputState = extern struct {
    /// A pointer to an array of vertex buffer descriptions.
    vertex_buffer_descriptions: [*]const GPUVertexBufferDescription,
    /// The number of vertex buffer descriptions in the above array.
    num_vertex_buffers: u32,
    /// A pointer to an array of vertex attribute descriptions.
    vertex_attributes: [*]const GPUVertexAttribute,
    /// The number of vertex attribute descriptions in the above array.
    num_vertex_attributes: u32,
};

/// A structure specifying the stencil operation state of a graphics pipeline.
pub const GPUStencilOpState = extern struct {
    /// The action performed on samples that fail the stencil test.
    fail_op: GPUStencilOp,
    /// The action performed on samples that pass the depth and stencil tests.
    pass_op: GPUStencilOp,
    /// The action performed on samples that pass the stencil test and fail the depth test.
    depth_fail_op: GPUStencilOp,
    /// The comparison operator used in the stencil test.
    compare_op: GPUCompareOp,
};

/// A structure specifying the blend state of a color target.
pub const GPUColorTargetBlendState = extern struct {
    /// The value to be multiplied by the source RGB value.
    src_color_blendfactor: GPUBlendFactor,
    /// The value to be multiplied by the destination RGB value.
    dst_color_blendfactor: GPUBlendFactor,
    /// The blend operation for the RGB components.
    color_blend_op: GPUBlendOp,
    /// The value to be multiplied by the source alpha.
    src_alpha_blendfactor: GPUBlendFactor,
    /// The value to be multiplied by the destination alpha.
    dst_alpha_blendfactor: GPUBlendFactor,
    /// The blend operation for the alpha component.
    alpha_blend_op: GPUBlendOp,
    /// A bitmask specifying which of the RGBA components are enabled for writing. Writes to all channels if enable_color_write_mask is false.
    color_write_mask: GPUColorComponentFlags,
    /// Whether blending is enabled for the color target.
    enable_blend: bool,
    /// Whether the color write mask is enabled.
    enable_color_write_mask: bool,

    padding1: u8 = 0,
    padding2: u8 = 0,
};

/// A structure specifying code and metadata for creating a shader object.
pub const GPUShaderCreateInfo = extern struct {
    /// The size in bytes of the code pointed to.
    code_size: usize,
    /// A pointer to shader code.
    code: [*]const u8,
    /// A pointer to a null-terminated UTF-8 string specifying the entry point function name for the shader.
    entrypoint: [*:0]const u8,
    /// The format of the shader code.
    format: GPUShaderFormat,
    /// The stage the shader program corresponds to.
    stage: GPUShaderStage,
    /// The number of samplers defined in the shader.
    num_samplers: u32,
    /// The number of storage textures defined in the shader.
    num_storage_textures: u32,
    /// The number of storage buffers defined in the shader.
    num_storage_buffers: u32,
    /// The number of uniform buffers defined in the shader.
    num_uniform_buffers: u32,

    /// A properties ID for extensions. Should be 0 if no extensions are needed.
    props: sdl.PropertiesId = .invalid,
};

/// A structure specifying the parameters of a texture.
///
/// Usage flags can be bitwise OR'd together for combinations of usages. Note
/// that certain usage combinations are invalid, for example SAMPLER and
/// GRAPHICS_STORAGE.
pub const GPUTextureCreateInfo = extern struct {
    /// The base dimensionality of the texture.
    type: GPUTextureType,
    /// The pixel format of the texture.
    format: GPUTextureFormat,
    /// How the texture is intended to be used by the client.
    usage: GPUTextureUsageFlags,
    /// The width of the texture.
    width: u32,
    /// The height of the texture.
    height: u32,
    /// The layer count or depth of the texture. This value is treated as a layer count on 2D array textures, and as a depth value on 3D textures.
    layer_count_or_depth: u32,
    /// The number of mip levels in the texture.
    num_levels: u32,
    /// The number of samples per texel. Only applies if the texture is used as a render target.
    sample_count: GPUSampleCount,

    /// A properties ID for extensions. Should be 0 if no extensions are needed.
    props: sdl.PropertiesId = .invalid,
};

/// A structure specifying the parameters of a buffer.
///
/// Usage flags can be bitwise OR'd together for combinations of usages. Note
/// that certain combinations are invalid, for example VERTEX and INDEX.
pub const GPUBufferCreateInfo = extern struct {
    /// How the buffer is intended to be used by the client.
    usage: GPUBufferUsageFlags,
    /// The size in bytes of the buffer.
    size: u32,

    /// A properties ID for extensions. Should be 0 if no extensions are needed.
    props: sdl.PropertiesId = .invalid,
};

/// A structure specifying the parameters of a transfer buffer.
pub const GPUTransferBufferCreateInfo = extern struct {
    /// How the transfer buffer is intended to be used by the client.
    usage: GPUTransferBufferUsage,
    /// The size in bytes of the transfer buffer.
    size: u32,

    /// A properties ID for extensions. Should be 0 if no extensions are needed.
    props: sdl.PropertiesId = .invalid,
};

/// A structure specifying the parameters of the graphics pipeline rasterizer
/// state.
///
/// Note that `GPUFillMode.line` is not supported on many Android devices.
/// For those devices, the fill mode will automatically fall back to FILL.
///
/// Also note that the D3D12 driver will enable depth clamping even if
/// enable_depth_clip is true. If you need this clamp+clip behavior, consider
/// enabling depth clip and then manually clamping depth in your fragment
/// shaders on Metal and Vulkan.
pub const GPURasterizerState = extern struct {
    /// Whether polygons will be filled in or drawn as lines.
    fill_mode: GPUFillMode,
    /// The facing direction in which triangles will be culled.
    cull_mode: GPUCullMode,
    /// The vertex winding that will cause a triangle to be determined as front-facing.
    front_face: GPUFrontFace,
    /// A scalar factor controlling the depth value added to each fragment.
    depth_bias_constant_factor: f32,
    /// The maximum depth bias of a fragment.
    depth_bias_clamp: f32,
    /// A scalar factor applied to a fragment's slope in depth calculations.
    depth_bias_slope_factor: f32,
    /// true to bias fragment depth values.
    enable_depth_bias: bool,
    /// true to enable depth clip, false to enable depth clamp.
    enable_depth_clip: bool,

    padding1: u8 = 0,
    padding2: u8 = 0,
};

/// A structure specifying the parameters of the graphics pipeline multisample
/// state.
pub const GPUMultisampleState = extern struct {
    /// The number of samples to be used in rasterization.
    sample_count: GPUSampleCount,
    /// Reserved for future use. Must be set to 0.
    sample_mask: u32 = 0,
    /// Reserved for future use. Must be set to false.
    enable_mask: bool = false,
    /// true enables the alpha-to-coverage feature.
    enable_alpha_to_coverage: bool = false,

    padding2: u8 = 0,
    padding3: u8 = 0,
};

/// A structure specifying the parameters of the graphics pipeline depth
/// stencil state.
pub const GPUDepthStencilState = extern struct {
    /// The comparison operator used for depth testing.
    compare_op: GPUCompareOp,
    /// The stencil op state for back-facing triangles.
    back_stencil_state: GPUStencilOpState,
    /// The stencil op state for front-facing triangles.
    front_stencil_state: GPUStencilOpState,
    /// Selects the bits of the stencil values participating in the stencil test.
    compare_mask: u8,
    /// Selects the bits of the stencil values updated by the stencil test.
    write_mask: u8,
    /// true enables the depth test.
    enable_depth_test: bool,
    /// true enables depth writes. Depth writes are always disabled when enable_depth_test is false.
    enable_depth_write: bool,
    /// true enables the stencil test.
    enable_stencil_test: bool,

    padding1: u8 = 0,
    padding2: u8 = 0,
    padding3: u8 = 0,
};

/// A structure specifying the parameters of color targets used in a graphics
/// pipeline.
pub const GPUColorTargetDescription = extern struct {
    /// The pixel format of the texture to be used as a color target.
    format: GPUTextureFormat,
    /// The blend state to be used for the color target.
    blend_state: GPUColorTargetBlendState,
};

/// A structure specifying the descriptions of render targets used in a
/// graphics pipeline.
pub const GPUGraphicsPipelineTargetInfo = extern struct {
    /// A pointer to an array of color target descriptions.
    color_target_descriptions: [*]const GPUColorTargetDescription,
    /// The number of color target descriptions in the above array.
    num_color_targets: u32,
    /// The pixel format of the depth-stencil target. Ignored if has_depth_stencil_target is false.
    depth_stencil_format: GPUTextureFormat,
    /// true specifies that the pipeline uses a depth-stencil target.
    has_depth_stencil_target: bool,

    padding1: u8 = 0,
    padding2: u8 = 0,
    padding3: u8 = 0,
};

/// A structure specifying the parameters of a graphics pipeline state.
pub const GPUGraphicsPipelineCreateInfo = extern struct {
    /// The vertex shader used by the graphics pipeline.
    vertex_shader: *GPUShader,
    /// The fragment shader used by the graphics pipeline.
    fragment_shader: *GPUShader,
    /// The vertex layout of the graphics pipeline.
    vertex_input_state: GPUVertexInputState,
    /// The primitive topology of the graphics pipeline.
    primitive_type: GPUPrimitiveType,
    /// The rasterizer state of the graphics pipeline.
    rasterizer_state: GPURasterizerState,
    /// The multisample state of the graphics pipeline.
    multisample_state: GPUMultisampleState,
    /// The depth-stencil state of the graphics pipeline.
    depth_stencil_state: GPUDepthStencilState,
    /// Formats and blend modes for the render targets of the graphics pipeline.
    target_info: GPUGraphicsPipelineTargetInfo,

    /// A properties ID for extensions. Should be 0 if no extensions are needed.
    props: sdl.PropertiesId = .invalid,
};

/// A structure specifying the parameters of a compute pipeline state.
pub const GPUComputePipelineCreateInfo = extern struct {
    /// The size in bytes of the compute shader code pointed to.
    code_size: usize,
    /// A pointer to compute shader code.
    code: [*]const u8,
    /// A pointer to a null-terminated UTF-8 string specifying the entry point function name for the shader.
    entrypoint: [*:0]const u8,
    /// The format of the compute shader code.
    format: GPUShaderFormat,
    /// The number of samplers defined in the shader.
    num_samplers: u32,
    /// The number of readonly storage textures defined in the shader.
    num_readonly_storage_textures: u32,
    /// The number of readonly storage buffers defined in the shader.
    num_readonly_storage_buffers: u32,
    /// The number of read-write storage textures defined in the shader.
    num_readwrite_storage_textures: u32,
    /// The number of read-write storage buffers defined in the shader.
    num_readwrite_storage_buffers: u32,
    /// The number of uniform buffers defined in the shader.
    num_uniform_buffers: u32,
    /// The number of threads in the X dimension. This should match the value in the shader.
    threadcount_x: u32,
    /// The number of threads in the Y dimension. This should match the value in the shader.
    threadcount_y: u32,
    /// The number of threads in the Z dimension. This should match the value in the shader.
    threadcount_z: u32,

    /// A properties ID for extensions. Should be 0 if no extensions are needed.
    props: sdl.PropertiesId = .invalid,
};

/// A structure specifying the parameters of a color target used by a render
/// pass.
///
/// The load_op field determines what is done with the texture at the beginning
/// of the render pass.
///
/// - LOAD: Loads the data currently in the texture. Not recommended for
///   multisample textures as it requires significant memory bandwidth.
/// - CLEAR: Clears the texture to a single color.
/// - DONT_CARE: The driver will do whatever it wants with the texture memory.
///   This is a good option if you know that every single pixel will be touched
///   in the render pass.
///
/// The store_op field determines what is done with the color results of the
/// render pass.
///
/// - STORE: Stores the results of the render pass in the texture. Not
///   recommended for multisample textures as it requires significant memory
///   bandwidth.
/// - DONT_CARE: The driver will do whatever it wants with the texture memory.
///   This is often a good option for depth/stencil textures.
/// - RESOLVE: Resolves a multisample texture into resolve_texture, which must
///   have a sample count of 1. Then the driver may discard the multisample
///   texture memory. This is the most performant method of resolving a
///   multisample target.
/// - RESOLVE_AND_STORE: Resolves a multisample texture into the
///   resolve_texture, which must have a sample count of 1. Then the driver
///   stores the multisample texture's contents. Not recommended as it requires
///   significant memory bandwidth.
pub const GPUColorTargetInfo = extern struct {
    /// The texture that will be used as a color target by a render pass.
    texture: *GPUTexture,
    ///  The mip level to use as a color target.
    mip_level: u32,
    ///  The layer index or depth plane to use as a color target. This value is treated as a layer index on 2D array and cube textures, and as a depth plane on 3D textures.
    layer_or_depth_plane: u32,
    ///  The color to clear the color target to at the start of the render pass. Ignored if `GPULoadOp.clear` is not used.
    clear_color: sdl.FColor,
    ///  What is done with the contents of the color target at the beginning of the render pass.
    load_op: GPULoadOp,
    ///  What is done with the results of the render pass.
    store_op: GPUStoreOp,
    ///  The texture that will receive the results of a multisample resolve operation. Ignored if a RESOLVE* store_op is not used.
    resolve_texture: ?*GPUTexture = null,
    ///  The mip level of the resolve texture to use for the resolve operation. Ignored if a RESOLVE* store_op is not used.
    resolve_mip_level: u32 = 0,
    ///  The layer index of the resolve texture to use for the resolve operation. Ignored if a RESOLVE* store_op is not used.
    resolve_layer: u32 = 0,
    /// true cycles the texture if the texture is bound and load_op is not LOAD
    cycle: bool,
    ///  true cycles the resolve texture if the resolve texture is bound. Ignored if a RESOLVE* store_op is not used.
    cycle_resolve_texture: bool = false,

    padding1: u8 = 0,
    padding2: u8 = 0,
};

/// A structure specifying the parameters of a depth-stencil target used by a
/// render pass.
///
/// The load_op field determines what is done with the depth contents of the
/// texture at the beginning of the render pass.
///
/// - LOAD: Loads the depth values currently in the texture.
/// - CLEAR: Clears the texture to a single depth.
/// - DONT_CARE: The driver will do whatever it wants with the memory. This is
///   a good option if you know that every single pixel will be touched in the
///   render pass.
///
/// The store_op field determines what is done with the depth results of the
/// render pass.
///
/// - STORE: Stores the depth results in the texture.
/// - DONT_CARE: The driver will do whatever it wants with the depth results.
///   This is often a good option for depth/stencil textures that don't need to
///   be reused again.
///
/// The stencil_load_op field determines what is done with the stencil contents
/// of the texture at the beginning of the render pass.
///
/// - LOAD: Loads the stencil values currently in the texture.
/// - CLEAR: Clears the stencil values to a single value.
/// - DONT_CARE: The driver will do whatever it wants with the memory. This is
///   a good option if you know that every single pixel will be touched in the
///   render pass.
///
/// The stencil_store_op field determines what is done with the stencil results
/// of the render pass.
///
/// - STORE: Stores the stencil results in the texture.
/// - DONT_CARE: The driver will do whatever it wants with the stencil results.
///   This is often a good option for depth/stencil textures that don't need to
///   be reused again.
///
/// Note that depth/stencil targets do not support multisample resolves.
///
/// Due to ABI limitations, depth textures with more than 255 layers are not
/// supported.
pub const GPUDepthStencilTargetInfo = extern struct {
    ///  The texture that will be used as the depth stencil target by the render pass.
    texture: *GPUTexture,
    ///  The value to clear the depth component to at the beginning of the render pass. Ignored if `GPULoadOp.clear` is not used.
    clear_depth: f32,
    ///  What is done with the depth contents at the beginning of the render pass.
    load_op: GPULoadOp,
    ///  What is done with the depth results of the render pass.
    store_op: GPUStoreOp,
    ///  What is done with the stencil contents at the beginning of the render pass.
    stencil_load_op: GPULoadOp,
    ///  What is done with the stencil results of the render pass.
    stencil_store_op: GPUStoreOp,
    /// true cycles the texture if the texture is bound and any load ops are not LOAD
    cycle: bool,
    ///  The value to clear the stencil component to at the beginning of the render pass. Ignored if `GPULoadOp.clear` is not used.
    clear_stencil: u8,
    /// The mip level to use as the depth stencil target.
    mip_level: u8 = 0,
    /// The layer index to use as the depth stencil target.
    layer: u8 = 0,
};

/// A structure containing parameters for a blit command.
pub const GPUBlitInfo = extern struct {
    /// The source region for the blit.
    source: GPUBlitRegion,
    /// The destination region for the blit.
    destination: GPUBlitRegion,
    /// What is done with the contents of the destination before the blit.
    load_op: GPULoadOp,
    /// The color to clear the destination region to before the blit. Ignored if load_op is not `GPULoadOp.clear`.
    clear_color: sdl.FColor,
    /// The flip mode for the source region.
    flip_mode: sdl.FlipMode,
    /// The filter mode used when blitting.
    filter: GPUFilter,
    /// true cycles the destination texture if it is already bound.
    cycle: bool,

    padding1: u8 = 0,
    padding2: u8 = 0,
    padding3: u8 = 0,
};

/// A structure specifying parameters in a buffer binding call.
pub const GPUBufferBinding = extern struct {
    /// The buffer to bind. Must have been created with `GPUBufferUsageFlags.vertex` for `bindGPUVertexBuffers`, or `GPUBufferUsageFlags.index` for `bindGPUIndexBuffer`.
    buffer: *GPUBuffer,
    /// The starting byte of the data to bind in the buffer.
    offset: u32,
};

/// A structure specifying parameters in a sampler binding call.
pub const GPUTextureSamplerBinding = extern struct {
    /// The texture to bind. Must have been created with `GPUTextureUsageFlags.sampler`.
    texture: *GPUTexture,
    /// The sampler to bind.
    sampler: *GPUSampler,
};

/// A structure specifying parameters related to binding buffers in a compute
/// pass.
pub const GPUStorageBufferReadWriteBinding = extern struct {
    /// The buffer to bind. Must have been created with `GPUBufferUsageFlags.compute_storage_write`.
    buffer: *GPUBuffer,
    /// true cycles the buffer if it is already bound.
    cycle: bool,

    padding1: u8 = 0,
    padding2: u8 = 0,
    padding3: u8 = 0,
};

/// A structure specifying parameters related to binding textures in a compute
/// pass.
pub const GPUStorageTextureReadWriteBinding = extern struct {
    /// The texture to bind. Must have been created with `GPUTextureUsageFlags.compute_storage_write` or `GPUTextureUsageFlags.compute_storage_simultaneous_read_write`.
    texture: *GPUTexture,
    /// The mip level index to bind.
    mip_level: u32,
    /// The layer index to bind.
    layer: u32,
    /// true cycles the texture if it is already bound.
    cycle: bool,

    padding1: u8 = 0,
    padding2: u8 = 0,
    padding3: u8 = 0,
};

/// Checks for GPU runtime support.
pub fn gpuSupportsShaderFormats(format_flags: GPUShaderFormat, name: ?[:0]const u8) bool {
    return SDL_GPUSupportsShaderFormats(format_flags, if (name) |s| s.ptr else null);
}
extern fn SDL_GPUSupportsShaderFormats(format_flags: GPUShaderFormat, name: ?[*:0]const u8) bool;

/// Checks for GPU runtime support.
pub const gpuSupportsProperties = SDL_GPUSupportsProperties;
extern fn SDL_GPUSupportsProperties(props: sdl.PropertiesId) bool;

/// Creates a GPU context.
///
/// The GPU driver name can be one of the following:
///
/// - "vulkan": [Vulkan](CategoryGPU#vulkan)
/// - "direct3d12": [D3D12](CategoryGPU#d3d12)
/// - "metal": [Metal](CategoryGPU#metal)
/// - null: let SDL pick the optimal driver
pub fn createGPUDevice(format_flags: GPUShaderFormat, debug_mode: bool, name: ?[:0]const u8) Error!*GPUDevice {
    return SDL_CreateGPUDevice(format_flags, debug_mode, if (name) |s| s.ptr else null) orelse makeError();
}
extern fn SDL_CreateGPUDevice(format_flags: GPUShaderFormat, debug_mode: bool, name: ?[*:0]const u8) ?*GPUDevice;

/// Creates a GPU context.
///
/// These are the supported properties:
///
/// - `GPUDevice.Properties.create_debugmode_boolean`: enable debug mode
///   properties and validations, defaults to true.
/// - `GPUDevice.Properties.create_preferlowpower_boolean`: enable to prefer
///   energy efficiency over maximum GPU performance, defaults to false.
/// - `GPUDevice.Properties.create_verbose_boolean`: enable to automatically log
///   useful debug information on device creation, defaults to true.
/// - `GPUDevice.Properties.create_name_string`: the name of the GPU driver to
///   use, if a specific one is desired.
/// - `GPUDevice.Properties.create_feature_clip_distance_boolean`: Enable Vulkan
///   device feature shaderClipDistance. If disabled, clip distances are not
///   supported in shader code: gl_ClipDistance[] built-ins of GLSL,
///   SV_ClipDistance0/1 semantics of HLSL and [[clip_distance]] attribute of
///   Metal. Disabling optional features allows the application to run on some
///   older Android devices. Defaults to true.
/// - `GPUDevice.Properties.create_feature_depth_clamping_boolean`: Enable
///   Vulkan device feature depthClamp. If disabled, there is no depth clamp
///   support and enable_depth_clip in `GPURasterizerState` must always be
///   set to true. Disabling optional features allows the application to run on
///   some older Android devices. Defaults to true.
/// - `GPUDevice.Properties.create_feature_indirect_draw_first_instance_boolean`:
///   Enable Vulkan device feature drawIndirectFirstInstance. If disabled, the
///   argument first_instance of `GPUIndirectDrawCommand` must be set to
///   zero. Disabling optional features allows the application to run on some
///   older Android devices. Defaults to true.
/// - `GPUDevice.Properties.create_feature_anisotropy_boolean`: Enable Vulkan
///   device feature samplerAnisotropy. If disabled, enable_anisotropy of
///   `GPUSamplerCreateInfo` must be set to false. Disabling optional
///   features allows the application to run on some older Android devices.
///   Defaults to true.
///
/// These are the current shader format properties:
///
/// - `GPUDevice.Properties.create_shaders_private_boolean`: The app is able to
///   provide shaders for an NDA platform.
/// - `GPUDevice.Properties.create_shaders_spirv_boolean`: The app is able to
///   provide SPIR-V shaders if applicable.
/// - `GPUDevice.Properties.create_shaders_dxbc_boolean`: The app is able to
///   provide DXBC shaders if applicable
/// - `GPUDevice.Properties.create_shaders_dxil_boolean`: The app is able to
///   provide DXIL shaders if applicable.
/// - `GPUDevice.Properties.create_shaders_msl_boolean`: The app is able to
///   provide MSL shaders if applicable.
/// - `GPUDevice.Properties.create_shaders_metallib_boolean`: The app is able to
///   provide Metal shader libraries if applicable.
///
/// With the D3D12 backend:
///
/// - `GPUDevice.Properties.create_d3d12_semantic_name_string`: the prefix to
///   use for all vertex semantics, default is "TEXCOORD".
/// - `GPUDevice.Properties.create_d3d12_allow_fewer_resource_slots_boolean`: By
///   default, Resourcing Binding Tier 2 is required for D3D12 support.
///   However, an application can set this property to true to enable Tier 1
///   support, if (and only if) the application uses 8 or fewer storage
///   resources across all shader stages. As of writing, this property is
///   useful for targeting Intel Haswell and Broadwell GPUs; other hardware
///   either supports Tier 2 Resource Binding or does not support D3D12 in any
///   capacity. Defaults to false.
/// - `GPUDevice.Properties.create_d3d12_agility_sdk_version_number`: Certain
///   feature checks are only possible on Windows 11 by default. By setting
///   this alongside `GPUDevice.Properties.create_d3d12_agility_sdk_path_string`
///   and vendoring D3D12Core.dll from the D3D12 Agility SDK, you can make
///   those feature checks possible on older platforms. The version you provide
///   must match the one given in the DLL.
/// - `GPUDevice.Properties.create_d3d12_agility_sdk_path_string`: Certain
///   feature checks are only possible on Windows 11 by default. By setting
///   this alongside
///   `GPUDevice.Properties.create_d3d12_agility_sdk_version_number` and
///   vendoring D3D12Core.dll from the D3D12 Agility SDK, you can make those
///   feature checks possible on older platforms. The path you provide must be
///   relative to the executable path of your app. Be sure not to put the DLL
///   in the same directory as the exe; Microsoft strongly advises against
///   this!
///
/// With the Vulkan backend:
///
/// - `GPUDevice.Properties.create_vulkan_require_hardware_acceleration_boolean`:
///   By default, Vulkan device enumeration includes drivers of all types,
///   including software renderers (for example, the Lavapipe Mesa driver).
///   This can be useful if your application _requires_ SDL_GPU, but if you can
///   provide your own fallback renderer (for example, an OpenGL renderer) this
///   property can be set to true. Defaults to false.
/// - `GPUDevice.Properties.create_vulkan_options_pointer`: a pointer to an
///   `GPUVulkanOptions` structure to be processed during device creation.
///   This allows configuring a variety of Vulkan-specific options such as
///   increasing the API version and opting into extensions aside from the
///   minimal set SDL requires.
///
/// With the Metal backend: -
/// `GPUDevice.Properties.create_metal_allow_macfamily1_boolean`: By default,
/// macOS support requires what Apple calls "MTLGPUFamilyMac2" hardware or
/// newer. However, an application can set this property to true to enable
/// support for "MTLGPUFamilyMac1" hardware, if (and only if) the application
/// does not write to sRGB textures. (For history's sake: MacFamily1 also does
/// not support indirect command buffers, MSAA depth resolve, and stencil
/// resolve/feedback, but these are not exposed features in SDL_GPU.)
pub fn createGPUDeviceWithProperties(props: sdl.PropertiesId) Error!*GPUDevice {
    return SDL_CreateGPUDeviceWithProperties(props) orelse makeError();
}
extern fn SDL_CreateGPUDeviceWithProperties(props: sdl.PropertiesId) ?*GPUDevice;

/// A structure specifying additional options when using Vulkan.
///
/// When no such structure is provided, SDL will use Vulkan API version 1.0 and
/// a minimal set of features. The requested API version influences how the
/// feature_list is processed by SDL. When requesting API version 1.0, the
/// feature_list is ignored. Only the vulkan_10_physical_device_features and
/// the extension lists are used. When requesting API version 1.1, the
/// feature_list is scanned for feature structures introduced in Vulkan 1.1.
/// When requesting Vulkan 1.2 or higher, the feature_list is additionally
/// scanned for compound feature structs such as
/// VkPhysicalDeviceVulkan11Features. The device and instance extension lists,
/// as well as vulkan_10_physical_device_features, are always processed.
pub const GPUVulkanOptions = extern struct {
    /// The Vulkan API version to request for the instance. Use Vulkan's VK_MAKE_VERSION or VK_MAKE_API_VERSION.
    vulkan_api_version: u32,
    /// Pointer to the first element of a chain of Vulkan feature structs. (Requires API version 1.1 or higher.)
    feature_list: ?*anyopaque,
    /// Pointer to a VkPhysicalDeviceFeatures struct to enable additional Vulkan 1.0 features.
    vulkan_10_physical_device_features: ?*anyopaque,
    /// Number of additional device extensions to require.
    device_extension_count: u32,
    /// Pointer to a list of additional device extensions to require.
    device_extension_names: ?*?[*:0]const u8,
    /// Number of additional instance extensions to require.
    instance_extension_count: u32,
    /// Pointer to a list of additional instance extensions to require.
    instance_extension_names: ?*?[*:0]const u8,
};

/// Destroys a GPU context previously returned by `createGPUDevice`.
pub const destroyGPUDevice = SDL_DestroyGPUDevice;
extern fn SDL_DestroyGPUDevice(device: *GPUDevice) void;

/// Get the number of GPU drivers compiled into SDL.
pub const getNumGPUDrivers = SDL_GetNumGPUDrivers;
extern fn SDL_GetNumGPUDrivers() c_int;

/// Get the name of a built in GPU driver.
///
/// The GPU drivers are presented in the order in which they are normally
/// checked during initialization.
///
/// The names of drivers are all simple, low-ASCII identifiers, like "vulkan",
/// "metal" or "direct3d12". These never have Unicode characters, and are not
/// meant to be proper names.
pub fn getGPUDriver(index: c_int) [:0]const u8 {
    const str = SDL_GetGPUDriver(index);
    return std.mem.span(str);
}
extern fn SDL_GetGPUDriver(index: c_int) [*:0]const u8;

/// Returns the name of the backend used to create this GPU context.
pub fn getGPUDeviceDriver(device: *GPUDevice) Error![:0]const u8 {
    const str = SDL_GetGPUDeviceDriver(device) orelse return makeError();
    return std.mem.span(str);
}
extern fn SDL_GetGPUDeviceDriver(device: *GPUDevice) ?[*:0]const u8;

/// Returns the supported shader formats for this GPU context.
pub const getGPUShaderFormats = SDL_GetGPUShaderFormats;
extern fn SDL_GetGPUShaderFormats(device: *GPUDevice) GPUShaderFormat;

/// Get the properties associated with a GPU device.
///
/// All properties are optional and may differ between GPU backends and SDL
/// versions.
///
/// The following properties are provided by SDL:
///
/// `GPUDevice.Properties.name_string`: Contains the name of the underlying
/// device as reported by the system driver. This string has no standardized
/// format, is highly inconsistent between hardware devices and drivers, and is
/// able to change at any time. Do not attempt to parse this string as it is
/// bound to fail at some point in the future when system drivers are updated,
/// new hardware devices are introduced, or when SDL adds new GPU backends or
/// modifies existing ones.
///
/// Strings that have been found in the wild include:
///
/// - GTX 970
/// - GeForce GTX 970
/// - NVIDIA GeForce GTX 970
/// - Microsoft Direct3D12 (NVIDIA GeForce GTX 970)
/// - NVIDIA Graphics Device
/// - GeForce GPU
/// - P106-100
/// - AMD 15D8:C9
/// - AMD Custom GPU 0405
/// - AMD Radeon (TM) Graphics
/// - ASUS Radeon RX 470 Series
/// - Intel(R) Arc(tm) A380 Graphics (DG2)
/// - Virtio-GPU Venus (NVIDIA TITAN V)
/// - SwiftShader Device (LLVM 16.0.0)
/// - llvmpipe (LLVM 15.0.4, 256 bits)
/// - Microsoft Basic Render Driver
/// - unknown device
///
/// The above list shows that the same device can have different formats, the
/// vendor name may or may not appear in the string, the included vendor name
/// may not be the vendor of the chipset on the device, some manufacturers
/// include pseudo-legal marks while others don't, some devices may not use a
/// marketing name in the string, the device string may be wrapped by the name
/// of a translation interface, the device may be emulated in software, or the
/// string may contain generic text that does not identify the device at all.
///
/// `GPUDevice.Properties.driver_name_string`: Contains the self-reported name
/// of the underlying system driver.
///
/// Strings that have been found in the wild include:
///
/// - Intel Corporation
/// - Intel open-source Mesa driver
/// - Qualcomm Technologies Inc. Adreno Vulkan Driver
/// - MoltenVK
/// - Mali-G715
/// - venus
///
/// `GPUDevice.Properties.driver_version_string`: Contains the self-reported
/// version of the underlying system driver. This is a relatively short version
/// string in an unspecified format. If `GPUDevice.Properties.driver_info_string`
/// is available then that property should be preferred over this one as it may
/// contain additional information that is useful for identifying the exact
/// driver version used.
///
/// Strings that have been found in the wild include:
///
/// - 53.0.0
/// - 0.405.2463
/// - 32.0.15.6614
///
/// `GPUDevice.Properties.driver_info_string`: Contains the detailed version
/// information of the underlying system driver as reported by the driver. This
/// is an arbitrary string with no standardized format and it may contain
/// newlines. This property should be preferred over
/// `GPUDevice.Properties.driver_version_string` if it is available as it usually
/// contains the same information but in a format that is easier to read.
///
/// Strings that have been found in the wild include:
///
/// - 101.6559
/// - 1.2.11
/// - Mesa 21.2.2 (LLVM 12.0.1)
/// - Mesa 22.2.0-devel (git-f226222 2022-04-14 impish-oibaf-ppa)
/// - v1.r53p0-00eac0.824c4f31403fb1fbf8ee1042422c2129
///
/// This string has also been observed to be a multiline string (which has a
/// trailing newline):
///
/// ```
/// Driver Build: 85da404, I46ff5fc46f, 1606794520
/// Date: 11/30/20
/// Compiler Version: EV031.31.04.01
/// Driver Branch: promo490_3_Google
/// ```
pub fn getGPUDeviceProperties(device: *GPUDevice) Error!sdl.PropertiesId {
    const result = SDL_GetGPUDeviceProperties(device);
    if (@backingInt(result) == 0) return makeError();
    return result;
}
extern fn SDL_GetGPUDeviceProperties(device: *GPUDevice) sdl.PropertiesId;

/// Creates a pipeline object to be used in a compute workflow.
///
/// Shader resource bindings must be authored to follow a particular order
/// depending on the shader format.
///
/// For SPIR-V shaders, use the following resource sets:
///
/// - 0: Sampled textures, followed by read-only storage textures, followed by
///   read-only storage buffers
/// - 1: Read-write storage textures, followed by read-write storage buffers
/// - 2: Uniform buffers
///
/// For DXBC and DXIL shaders, use the following register order:
///
/// - (t[n], space0): Sampled textures, followed by read-only storage textures,
///   followed by read-only storage buffers
/// - (u[n], space1): Read-write storage textures, followed by read-write
///   storage buffers
/// - (b[n], space2): Uniform buffers
///
/// For MSL/metallib, use the following order:
///
/// - [[buffer]]: Uniform buffers, followed by read-only storage buffers,
///   followed by read-write storage buffers
/// - [[texture]]: Sampled textures, followed by read-only storage textures,
///   followed by read-write storage textures
///
/// There are optional properties that can be provided through `props`. These
/// are the supported properties:
///
/// - `GPUComputePipeline.Properties.create_name_string`: a name that can be
///   displayed in debugging tools.
pub fn createGPUComputePipeline(device: *GPUDevice, createinfo: *const GPUComputePipelineCreateInfo) Error!*GPUComputePipeline {
    return SDL_CreateGPUComputePipeline(device, createinfo) orelse makeError();
}
extern fn SDL_CreateGPUComputePipeline(device: *GPUDevice, createinfo: *const GPUComputePipelineCreateInfo) ?*GPUComputePipeline;

/// Creates a pipeline object to be used in a graphics workflow.
///
/// There are optional properties that can be provided through `props`. These
/// are the supported properties:
///
/// - `GPUGraphicsPipeline.Properties.create_name_string`: a name that can be
///   displayed in debugging tools.
pub fn createGPUGraphicsPipeline(device: *GPUDevice, createinfo: *const GPUGraphicsPipelineCreateInfo) Error!*GPUGraphicsPipeline {
    return SDL_CreateGPUGraphicsPipeline(device, createinfo) orelse makeError();
}
extern fn SDL_CreateGPUGraphicsPipeline(device: *GPUDevice, createinfo: *const GPUGraphicsPipelineCreateInfo) ?*GPUGraphicsPipeline;

/// Creates a sampler object to be used when binding textures in a graphics
/// workflow.
///
/// There are optional properties that can be provided through `props`. These
/// are the supported properties:
///
/// - `GPUSampler.Properties.create_name_string`: a name that can be displayed
///   in debugging tools.
pub fn createGPUSampler(device: *GPUDevice, createinfo: *const GPUSamplerCreateInfo) Error!*GPUSampler {
    return SDL_CreateGPUSampler(device, createinfo) orelse makeError();
}
extern fn SDL_CreateGPUSampler(device: *GPUDevice, createinfo: *const GPUSamplerCreateInfo) ?*GPUSampler;

/// Creates a shader to be used when creating a graphics pipeline.
///
/// Shader resource bindings must be authored to follow a particular order
/// depending on the shader format.
///
/// For SPIR-V shaders, use the following resource sets:
///
/// For vertex shaders:
///
/// - 0: Sampled textures, followed by storage textures, followed by storage
///   buffers
/// - 1: Uniform buffers
///
/// For fragment shaders:
///
/// - 2: Sampled textures, followed by storage textures, followed by storage
///   buffers
/// - 3: Uniform buffers
///
/// For DXBC and DXIL shaders, use the following register order:
///
/// For vertex shaders:
///
/// - (t[n], space0): Sampled textures, followed by storage textures, followed
///   by storage buffers
/// - (s[n], space0): Samplers with indices corresponding to the sampled
///   textures
/// - (b[n], space1): Uniform buffers
///
/// For pixel shaders:
///
/// - (t[n], space2): Sampled textures, followed by storage textures, followed
///   by storage buffers
/// - (s[n], space2): Samplers with indices corresponding to the sampled
///   textures
/// - (b[n], space3): Uniform buffers
///
/// For MSL/metallib, use the following order:
///
/// - [[texture]]: Sampled textures, followed by storage textures
/// - [[sampler]]: Samplers with indices corresponding to the sampled textures
/// - [[buffer]]: Uniform buffers, followed by storage buffers. Vertex buffer 0
///   is bound at [[buffer(14)]], vertex buffer 1 at [[buffer(15)]], and so on.
///   Rather than manually authoring vertex buffer indices, use the
///   [[stage_in]] attribute which will automatically use the vertex input
///   information from the `GPUGraphicsPipeline`.
///
/// Shader semantics other than system-value semantics do not matter in D3D12
/// and for ease of use the SDL implementation assumes that non system-value
/// semantics will all be TEXCOORD. If you are using HLSL as the shader source
/// language, your vertex semantics should start at TEXCOORD0 and increment
/// like so: TEXCOORD1, TEXCOORD2, etc. If you wish to change the semantic
/// prefix to something other than TEXCOORD you can use
/// `GPUDevice.Properties.create_d3d12_semantic_name_string` with
/// `createGPUDeviceWithProperties`.
///
/// There are optional properties that can be provided through `props`. These
/// are the supported properties:
///
/// - `GPUShader.Properties.create_name_string`: a name that can be displayed in
///   debugging tools.
pub fn createGPUShader(device: *GPUDevice, createinfo: *const GPUShaderCreateInfo) Error!*GPUShader {
    return SDL_CreateGPUShader(device, createinfo) orelse makeError();
}
extern fn SDL_CreateGPUShader(device: *GPUDevice, createinfo: *const GPUShaderCreateInfo) ?*GPUShader;

/// Creates a texture object to be used in graphics or compute workflows.
///
/// The contents of this texture are undefined until data is written to the
/// texture, either via `uploadToGPUTexture` or by performing a render or
/// compute pass with this texture as a target.
///
/// Note that certain combinations of usage flags are invalid. For example, a
/// texture cannot have both the SAMPLER and GRAPHICS_STORAGE_READ flags.
///
/// If you request a sample count higher than the hardware supports, the
/// implementation will automatically fall back to the highest available sample
/// count.
///
/// There are optional properties that can be provided through
/// `GPUTextureCreateInfo`'s `props`. These are the supported properties:
///
/// - `GPUTexture.Properties.create_d3d12_clear_r_float`: (Direct3D 12 only) if
///   the texture usage is `GPUTextureUsageFlags.color_target`, clear the texture
///   to a color with this red intensity. Defaults to zero.
/// - `GPUTexture.Properties.create_d3d12_clear_g_float`: (Direct3D 12 only) if
///   the texture usage is `GPUTextureUsageFlags.color_target`, clear the texture
///   to a color with this green intensity. Defaults to zero.
/// - `GPUTexture.Properties.create_d3d12_clear_b_float`: (Direct3D 12 only) if
///   the texture usage is `GPUTextureUsageFlags.color_target`, clear the texture
///   to a color with this blue intensity. Defaults to zero.
/// - `GPUTexture.Properties.create_d3d12_clear_a_float`: (Direct3D 12 only) if
///   the texture usage is `GPUTextureUsageFlags.color_target`, clear the texture
///   to a color with this alpha intensity. Defaults to zero.
/// - `GPUTexture.Properties.create_d3d12_clear_depth_float`: (Direct3D 12 only)
///   if the texture usage is `GPUTextureUsageFlags.depth_stencil_target`, clear
///   the texture to a depth of this value. Defaults to zero.
/// - `GPUTexture.Properties.create_d3d12_clear_stencil_number`: (Direct3D 12
///   only) if the texture usage is `GPUTextureUsageFlags.depth_stencil_target`,
///   clear the texture to a stencil of this Uint8 value. Defaults to zero.
/// - `GPUTexture.Properties.create_name_string`: a name that can be displayed
///   in debugging tools.
pub fn createGPUTexture(device: *GPUDevice, createinfo: *const GPUTextureCreateInfo) Error!*GPUTexture {
    return SDL_CreateGPUTexture(device, createinfo) orelse makeError();
}
extern fn SDL_CreateGPUTexture(device: *GPUDevice, createinfo: *const GPUTextureCreateInfo) ?*GPUTexture;

/// Creates a buffer object to be used in graphics or compute workflows.
///
/// The contents of this buffer are undefined until data is written to the
/// buffer.
///
/// Note that certain combinations of usage flags are invalid. For example, a
/// buffer cannot have both the VERTEX and INDEX flags.
///
/// If you use a STORAGE flag, the data in the buffer must respect std140
/// layout conventions. In practical terms this means you must ensure that vec3
/// and vec4 fields are 16-byte aligned.
///
/// For better understanding of underlying concepts and memory management with
/// SDL GPU API, you may refer
/// [this blog post](https://moonside.games/posts/sdl-gpu-concepts-cycling/)
/// .
///
/// There are optional properties that can be provided through `props`. These
/// are the supported properties:
///
/// - `GPUBuffer.Properties.create_name_string`: a name that can be displayed in
///   debugging tools.
pub fn createGPUBuffer(device: *GPUDevice, createinfo: *const GPUBufferCreateInfo) Error!*GPUBuffer {
    return SDL_CreateGPUBuffer(device, createinfo) orelse makeError();
}
extern fn SDL_CreateGPUBuffer(device: *GPUDevice, createinfo: *const GPUBufferCreateInfo) ?*GPUBuffer;

/// Creates a transfer buffer to be used when uploading to or downloading from
/// graphics resources.
///
/// Download buffers can be particularly expensive to create, so it is good
/// practice to reuse them if data will be downloaded regularly.
///
/// There are optional properties that can be provided through `props`. These
/// are the supported properties:
///
/// - `GPUTransferBuffer.Properties.create_name_string`: a name that can be
///   displayed in debugging tools.
pub fn createGPUTransferBuffer(device: *GPUDevice, createinfo: *const GPUTransferBufferCreateInfo) Error!*GPUTransferBuffer {
    return SDL_CreateGPUTransferBuffer(device, createinfo) orelse makeError();
}
extern fn SDL_CreateGPUTransferBuffer(device: *GPUDevice, createinfo: *const GPUTransferBufferCreateInfo) ?*GPUTransferBuffer;

/// Sets an arbitrary string constant to label a buffer.
///
/// You should use `GPUBuffer.Properties.create_name_string` with
/// `createGPUBuffer` instead of this function to avoid thread safety issues.
pub fn setGPUBufferName(device: *GPUDevice, buffer: *GPUBuffer, text: [:0]const u8) void {
    return SDL_SetGPUBufferName(device, buffer, text.ptr);
}
extern fn SDL_SetGPUBufferName(device: *GPUDevice, buffer: *GPUBuffer, text: [*:0]const u8) void;

/// Sets an arbitrary string constant to label a texture.
///
/// You should use `GPUTexture.Properties.create_name_string` with
/// `createGPUTexture` instead of this function to avoid thread safety
/// issues.
pub fn setGPUTextureName(device: *GPUDevice, texture: *GPUTexture, text: [:0]const u8) void {
    return SDL_SetGPUTextureName(device, texture, text.ptr);
}
extern fn SDL_SetGPUTextureName(device: *GPUDevice, texture: *GPUTexture, text: [*:0]const u8) void;

/// Inserts an arbitrary string label into the command buffer callstream.
///
/// Useful for debugging.
///
/// On Direct3D 12, using `insertGPUDebugLabel` requires
/// WinPixEventRuntime.dll to be in your PATH or in the same directory as your
/// executable. See
/// [here](https://devblogs.microsoft.com/pix/winpixeventruntime/)
/// for instructions on how to obtain it.
pub fn insertGPUDebugLabel(command_buffer: *GPUCommandBuffer, text: [:0]const u8) void {
    return SDL_InsertGPUDebugLabel(command_buffer, text.ptr);
}
extern fn SDL_InsertGPUDebugLabel(command_buffer: *GPUCommandBuffer, text: [*:0]const u8) void;

/// Begins a debug group with an arbitrary name.
///
/// Used for denoting groups of calls when viewing the command buffer
/// callstream in a graphics debugging tool.
///
/// Each call to `pushGPUDebugGroup` must have a corresponding call to
/// `popGPUDebugGroup`.
///
/// On Direct3D 12, using `pushGPUDebugGroup` requires WinPixEventRuntime.dll
/// to be in your PATH or in the same directory as your executable. See
/// [here](https://devblogs.microsoft.com/pix/winpixeventruntime/)
/// for instructions on how to obtain it.
///
/// On some backends (e.g. Metal), pushing a debug group during a
/// render/blit/compute pass will create a group that is scoped to the native
/// pass rather than the command buffer. For best results, if you push a debug
/// group during a pass, always pop it in the same pass.
pub fn pushGPUDebugGroup(command_buffer: *GPUCommandBuffer, name: [:0]const u8) void {
    return SDL_PushGPUDebugGroup(command_buffer, name.ptr);
}
extern fn SDL_PushGPUDebugGroup(command_buffer: *GPUCommandBuffer, name: [*:0]const u8) void;

/// Ends the most-recently pushed debug group.
///
/// On Direct3D 12, using `popGPUDebugGroup` requires WinPixEventRuntime.dll
/// to be in your PATH or in the same directory as your executable. See
/// [here](https://devblogs.microsoft.com/pix/winpixeventruntime/)
/// for instructions on how to obtain it.
pub const popGPUDebugGroup = SDL_PopGPUDebugGroup;
extern fn SDL_PopGPUDebugGroup(command_buffer: *GPUCommandBuffer) void;

/// Frees the given texture as soon as it is safe to do so.
///
/// You must not reference the texture after calling this function.
pub const releaseGPUTexture = SDL_ReleaseGPUTexture;
extern fn SDL_ReleaseGPUTexture(device: *GPUDevice, texture: *GPUTexture) void;

/// Frees the given sampler as soon as it is safe to do so.
///
/// You must not reference the sampler after calling this function.
pub const releaseGPUSampler = SDL_ReleaseGPUSampler;
extern fn SDL_ReleaseGPUSampler(device: *GPUDevice, sampler: *GPUSampler) void;

/// Frees the given buffer as soon as it is safe to do so.
///
/// You must not reference the buffer after calling this function.
pub const releaseGPUBuffer = SDL_ReleaseGPUBuffer;
extern fn SDL_ReleaseGPUBuffer(device: *GPUDevice, buffer: *GPUBuffer) void;

/// Frees the given transfer buffer as soon as it is safe to do so.
///
/// You must not reference the transfer buffer after calling this function.
pub const releaseGPUTransferBuffer = SDL_ReleaseGPUTransferBuffer;
extern fn SDL_ReleaseGPUTransferBuffer(device: *GPUDevice, transfer_buffer: *GPUTransferBuffer) void;

/// Frees the given compute pipeline as soon as it is safe to do so.
///
/// You must not reference the compute pipeline after calling this function.
pub const releaseGPUComputePipeline = SDL_ReleaseGPUComputePipeline;
extern fn SDL_ReleaseGPUComputePipeline(device: *GPUDevice, compute_pipeline: *GPUComputePipeline) void;

/// Frees the given shader as soon as it is safe to do so.
///
/// You must not reference the shader after calling this function.
pub const releaseGPUShader = SDL_ReleaseGPUShader;
extern fn SDL_ReleaseGPUShader(device: *GPUDevice, shader: *GPUShader) void;

/// Frees the given graphics pipeline as soon as it is safe to do so.
///
/// You must not reference the graphics pipeline after calling this function.
pub const releaseGPUGraphicsPipeline = SDL_ReleaseGPUGraphicsPipeline;
extern fn SDL_ReleaseGPUGraphicsPipeline(device: *GPUDevice, graphics_pipeline: *GPUGraphicsPipeline) void;

/// Acquire a command buffer.
///
/// This command buffer is managed by the implementation and should not be
/// freed by the user. The command buffer may only be used on the thread it was
/// acquired on. The command buffer should be submitted on the thread it was
/// acquired on.
///
/// It is valid to acquire multiple command buffers on the same thread at once.
/// In fact a common design pattern is to acquire two command buffers per frame
/// where one is dedicated to render and compute passes and the other is
/// dedicated to copy passes and other preparatory work such as generating
/// mipmaps. Interleaving commands between the two command buffers reduces the
/// total amount of passes overall which improves rendering performance.
pub fn acquireGPUCommandBuffer(device: *GPUDevice) Error!*GPUCommandBuffer {
    return SDL_AcquireGPUCommandBuffer(device) orelse makeError();
}
extern fn SDL_AcquireGPUCommandBuffer(device: *GPUDevice) ?*GPUCommandBuffer;

/// Pushes data to a vertex uniform slot on the command buffer.
///
/// Subsequent draw calls in this command buffer will use this uniform data.
///
/// The data being pushed must respect std140 layout conventions. In practical
/// terms this means you must ensure that vec3 and vec4 fields are 16-byte
/// aligned.
///
/// For detailed information about accessing uniform data from a shader, please
/// refer to `createGPUShader`.
pub const pushGPUVertexUniformData = SDL_PushGPUVertexUniformData;
extern fn SDL_PushGPUVertexUniformData(command_buffer: *GPUCommandBuffer, slot_index: u32, data: *const anyopaque, length: u32) void;

/// Pushes data to a fragment uniform slot on the command buffer.
///
/// Subsequent draw calls in this command buffer will use this uniform data.
///
/// The data being pushed must respect std140 layout conventions. In practical
/// terms this means you must ensure that vec3 and vec4 fields are 16-byte
/// aligned.
pub const pushGPUFragmentUniformData = SDL_PushGPUFragmentUniformData;
extern fn SDL_PushGPUFragmentUniformData(command_buffer: *GPUCommandBuffer, slot_index: u32, data: *const anyopaque, length: u32) void;

/// Pushes data to a uniform slot on the command buffer.
///
/// Subsequent draw calls in this command buffer will use this uniform data.
///
/// The data being pushed must respect std140 layout conventions. In practical
/// terms this means you must ensure that vec3 and vec4 fields are 16-byte
/// aligned.
pub const pushGPUComputeUniformData = SDL_PushGPUComputeUniformData;
extern fn SDL_PushGPUComputeUniformData(command_buffer: *GPUCommandBuffer, slot_index: u32, data: *const anyopaque, length: u32) void;

/// Begins a render pass on a command buffer.
///
/// A render pass consists of a set of texture subresources (or depth slices in
/// the 3D texture case) which will be rendered to during the render pass,
/// along with corresponding clear values and load/store operations. All
/// operations related to graphics pipelines must take place inside of a render
/// pass. A default viewport and scissor state are automatically set when this
/// is called. You cannot begin another render pass, or begin a compute pass or
/// copy pass until you have ended the render pass.
///
/// Using `GPULoadOp.load` before any contents have been written to the
/// texture subresource will result in undefined behavior. `GPULoadOp.clear`
/// will set the contents of the texture subresource to a single value before
/// any rendering is performed. It's fine to do an empty render pass using
/// `GPUStoreOp.store` to clear a texture, but in general it's better to
/// think of clearing not as an independent operation but as something that's
/// done as the beginning of a render pass.
pub fn beginGPURenderPass(command_buffer: *GPUCommandBuffer, color_target_infos: []const GPUColorTargetInfo, depth_stencil_target_info: ?*const GPUDepthStencilTargetInfo) *GPURenderPass {
    return SDL_BeginGPURenderPass(command_buffer, color_target_infos.ptr, @intCast(color_target_infos.len), depth_stencil_target_info);
}
extern fn SDL_BeginGPURenderPass(command_buffer: *GPUCommandBuffer, color_target_infos: [*]const GPUColorTargetInfo, num_color_targets: u32, depth_stencil_target_info: ?*const GPUDepthStencilTargetInfo) *GPURenderPass;

/// Binds a graphics pipeline on a render pass to be used in rendering.
///
/// A graphics pipeline must be bound before making any draw calls.
pub const bindGPUGraphicsPipeline = SDL_BindGPUGraphicsPipeline;
extern fn SDL_BindGPUGraphicsPipeline(render_pass: *GPURenderPass, graphics_pipeline: *GPUGraphicsPipeline) void;

/// Sets the current viewport state on a command buffer.
pub const setGPUViewport = SDL_SetGPUViewport;
extern fn SDL_SetGPUViewport(render_pass: *GPURenderPass, viewport: *const GPUViewport) void;

/// Sets the current scissor state on a command buffer.
pub const setGPUScissor = SDL_SetGPUScissor;
extern fn SDL_SetGPUScissor(render_pass: *GPURenderPass, scissor: *const sdl.Rect) void;

/// Sets the current blend constants on a command buffer.
pub const setGPUBlendConstants = SDL_SetGPUBlendConstants;
extern fn SDL_SetGPUBlendConstants(render_pass: *GPURenderPass, blend_constants: sdl.FColor) void;

/// Sets the current stencil reference value on a command buffer.
pub const setGPUStencilReference = SDL_SetGPUStencilReference;
extern fn SDL_SetGPUStencilReference(render_pass: *GPURenderPass, reference: u8) void;

/// Binds vertex buffers on a command buffer for use with subsequent draw
/// calls.
pub fn bindGPUVertexBuffers(render_pass: *GPURenderPass, first_slot: u32, bindings: []const GPUBufferBinding) void {
    return SDL_BindGPUVertexBuffers(render_pass, first_slot, bindings.ptr, @intCast(bindings.len));
}
extern fn SDL_BindGPUVertexBuffers(render_pass: *GPURenderPass, first_slot: u32, bindings: [*]const GPUBufferBinding, num_bindings: u32) void;

/// Binds an index buffer on a command buffer for use with subsequent draw
/// calls.
pub const bindGPUIndexBuffer = SDL_BindGPUIndexBuffer;
extern fn SDL_BindGPUIndexBuffer(render_pass: *GPURenderPass, binding: *const GPUBufferBinding, index_element_size: GPUIndexElementSize) void;

/// Binds texture-sampler pairs for use on the vertex shader.
///
/// The textures must have been created with `GPUTextureUsageFlags.sampler`.
///
/// The textures being bound must have a matching type declared in the shader
/// (2D, 3D, etc.). Multisample textures are not allowed.
///
/// Be sure your shader is set up according to the requirements documented in
/// `createGPUShader`.
pub fn bindGPUVertexSamplers(render_pass: *GPURenderPass, first_slot: u32, texture_sampler_bindings: []const GPUTextureSamplerBinding) void {
    return SDL_BindGPUVertexSamplers(render_pass, first_slot, texture_sampler_bindings.ptr, @intCast(texture_sampler_bindings.len));
}
extern fn SDL_BindGPUVertexSamplers(render_pass: *GPURenderPass, first_slot: u32, texture_sampler_bindings: [*]const GPUTextureSamplerBinding, num_bindings: u32) void;

/// Binds storage textures for use on the vertex shader.
///
/// These textures must have been created with
/// `GPUTextureUsageFlags.graphics_storage_read`.
///
/// The textures being bound must have a matching type declared in the shader
/// (2D, 3D, 2DMS, etc.)
///
/// Be sure your shader is set up according to the requirements documented in
/// `createGPUShader`.
pub fn bindGPUVertexStorageTextures(render_pass: *GPURenderPass, first_slot: u32, storage_textures: []const *GPUTexture) void {
    return SDL_BindGPUVertexStorageTextures(render_pass, first_slot, storage_textures.ptr, @intCast(storage_textures.len));
}
extern fn SDL_BindGPUVertexStorageTextures(render_pass: *GPURenderPass, first_slot: u32, storage_textures: [*]const *GPUTexture, num_bindings: u32) void;

/// Binds storage buffers for use on the vertex shader.
///
/// These buffers must have been created with
/// `GPUBufferUsageFlags.graphics_storage_read`.
///
/// Be sure your shader is set up according to the requirements documented in
/// `createGPUShader`.
pub fn bindGPUVertexStorageBuffers(render_pass: *GPURenderPass, first_slot: u32, storage_buffers: []const *GPUBuffer) void {
    return SDL_BindGPUVertexStorageBuffers(render_pass, first_slot, storage_buffers.ptr, @intCast(storage_buffers.len));
}
extern fn SDL_BindGPUVertexStorageBuffers(render_pass: *GPURenderPass, first_slot: u32, storage_buffers: [*]const *GPUBuffer, num_bindings: u32) void;

/// Binds texture-sampler pairs for use on the fragment shader.
///
/// The textures must have been created with `GPUTextureUsageFlags.sampler`.
///
/// The textures being bound must have a matching type declared in the shader
/// (2D, 3D, etc.). Multisample textures are not allowed.
///
/// Be sure your shader is set up according to the requirements documented in
/// `createGPUShader`.
pub fn bindGPUFragmentSamplers(render_pass: *GPURenderPass, first_slot: u32, texture_sampler_bindings: []const GPUTextureSamplerBinding) void {
    return SDL_BindGPUFragmentSamplers(render_pass, first_slot, texture_sampler_bindings.ptr, @intCast(texture_sampler_bindings.len));
}
extern fn SDL_BindGPUFragmentSamplers(render_pass: *GPURenderPass, first_slot: u32, texture_sampler_bindings: [*]const GPUTextureSamplerBinding, num_bindings: u32) void;

/// Binds storage textures for use on the fragment shader.
///
/// These textures must have been created with
/// `GPUTextureUsageFlags.graphics_storage_read`.
///
/// The textures being bound must have a matching type declared in the shader
/// (2D, 3D, 2DMS, etc.)
///
/// Be sure your shader is set up according to the requirements documented in
/// `createGPUShader`.
pub fn bindGPUFragmentStorageTextures(render_pass: *GPURenderPass, first_slot: u32, storage_textures: []const *GPUTexture) void {
    return SDL_BindGPUFragmentStorageTextures(render_pass, first_slot, storage_textures.ptr, @intCast(storage_textures.len));
}
extern fn SDL_BindGPUFragmentStorageTextures(render_pass: *GPURenderPass, first_slot: u32, storage_textures: [*]const *GPUTexture, num_bindings: u32) void;

/// Binds storage buffers for use on the fragment shader.
///
/// These buffers must have been created with
/// `GPUBufferUsageFlags.graphics_storage_read`.
///
/// Be sure your shader is set up according to the requirements documented in
/// `createGPUShader`.
pub fn bindGPUFragmentStorageBuffers(render_pass: *GPURenderPass, first_slot: u32, storage_buffers: []const *GPUBuffer) void {
    return SDL_BindGPUFragmentStorageBuffers(render_pass, first_slot, storage_buffers.ptr, @intCast(storage_buffers.len));
}
extern fn SDL_BindGPUFragmentStorageBuffers(render_pass: *GPURenderPass, first_slot: u32, storage_buffers: [*]const *GPUBuffer, num_bindings: u32) void;

/// Draws data using bound graphics state with an index buffer and instancing
/// enabled.
///
/// You must not call this function before binding a graphics pipeline.
///
/// Note that the `first_vertex` and `first_instance` parameters are NOT
/// compatible with built-in vertex/instance ID variables in shaders (for
/// example, SV_VertexID); GPU APIs and shader languages do not define these
/// built-in variables consistently, so if your shader depends on them, the
/// only way to keep behavior consistent and portable is to always pass 0 for
/// the correlating parameter in the draw calls.
pub const drawGPUIndexedPrimitives = SDL_DrawGPUIndexedPrimitives;
extern fn SDL_DrawGPUIndexedPrimitives(render_pass: *GPURenderPass, num_indices: u32, num_instances: u32, first_index: u32, vertex_offset: i32, first_instance: u32) void;

/// Draws data using bound graphics state.
///
/// You must not call this function before binding a graphics pipeline.
///
/// Note that the `first_vertex` and `first_instance` parameters are NOT
/// compatible with built-in vertex/instance ID variables in shaders (for
/// example, SV_VertexID); GPU APIs and shader languages do not define these
/// built-in variables consistently, so if your shader depends on them, the
/// only way to keep behavior consistent and portable is to always pass 0 for
/// the correlating parameter in the draw calls.
pub const drawGPUPrimitives = SDL_DrawGPUPrimitives;
extern fn SDL_DrawGPUPrimitives(render_pass: *GPURenderPass, num_vertices: u32, num_instances: u32, first_vertex: u32, first_instance: u32) void;

/// Draws data using bound graphics state and with draw parameters set from a
/// buffer.
///
/// The buffer must consist of tightly-packed draw parameter sets that each
/// match the layout of `GPUIndirectDrawCommand`. You must not call this
/// function before binding a graphics pipeline.
pub const drawGPUPrimitivesIndirect = SDL_DrawGPUPrimitivesIndirect;
extern fn SDL_DrawGPUPrimitivesIndirect(render_pass: *GPURenderPass, buffer: *GPUBuffer, offset: u32, draw_count: u32) void;

/// Draws data using bound graphics state with an index buffer enabled and with
/// draw parameters set from a buffer.
///
/// The buffer must consist of tightly-packed draw parameter sets that each
/// match the layout of `GPUIndexedIndirectDrawCommand`. You must not call
/// this function before binding a graphics pipeline.
pub const drawGPUIndexedPrimitivesIndirect = SDL_DrawGPUIndexedPrimitivesIndirect;
extern fn SDL_DrawGPUIndexedPrimitivesIndirect(render_pass: *GPURenderPass, buffer: *GPUBuffer, offset: u32, draw_count: u32) void;

/// Ends the given render pass.
///
/// All bound graphics state on the render pass command buffer is unset. The
/// render pass handle is now invalid.
pub const endGPURenderPass = SDL_EndGPURenderPass;
extern fn SDL_EndGPURenderPass(render_pass: *GPURenderPass) void;

/// Begins a compute pass on a command buffer.
///
/// A compute pass is defined by a set of texture subresources and buffers that
/// may be written to by compute pipelines. These textures and buffers must
/// have been created with the COMPUTE_STORAGE_WRITE bit or the
/// COMPUTE_STORAGE_SIMULTANEOUS_READ_WRITE bit. If you do not create a texture
/// with COMPUTE_STORAGE_SIMULTANEOUS_READ_WRITE, you must not read from the
/// texture in the compute pass. All operations related to compute pipelines
/// must take place inside of a compute pass. You must not begin another
/// compute pass, or a render pass or copy pass before ending the compute pass.
///
/// A VERY IMPORTANT NOTE - Reads and writes in compute passes are NOT
/// implicitly synchronized. This means you may cause data races by both
/// reading and writing a resource region in a compute pass, or by writing
/// multiple times to a resource region. If your compute work depends on
/// reading the completed output from a previous dispatch, you MUST end the
/// current compute pass and begin a new one before you can safely access the
/// data. Otherwise you will receive unexpected results. Reading and writing a
/// texture in the same compute pass is only supported by specific texture
/// formats. Make sure you check the format support!
pub fn beginGPUComputePass(command_buffer: *GPUCommandBuffer, storage_texture_bindings: []const GPUStorageTextureReadWriteBinding, storage_buffer_bindings: []const GPUStorageBufferReadWriteBinding) *GPUComputePass {
    return SDL_BeginGPUComputePass(command_buffer, storage_texture_bindings.ptr, @intCast(storage_texture_bindings.len), storage_buffer_bindings.ptr, @intCast(storage_buffer_bindings.len));
}
extern fn SDL_BeginGPUComputePass(command_buffer: *GPUCommandBuffer, storage_texture_bindings: [*]const GPUStorageTextureReadWriteBinding, num_storage_texture_bindings: u32, storage_buffer_bindings: [*]const GPUStorageBufferReadWriteBinding, num_storage_buffer_bindings: u32) *GPUComputePass;

/// Binds a compute pipeline on a command buffer for use in compute dispatch.
pub const bindGPUComputePipeline = SDL_BindGPUComputePipeline;
extern fn SDL_BindGPUComputePipeline(compute_pass: *GPUComputePass, compute_pipeline: *GPUComputePipeline) void;

/// Binds texture-sampler pairs for use on the compute shader.
///
/// The textures must have been created with `GPUTextureUsageFlags.sampler`.
///
/// The textures being bound must have a matching type declared in the shader
/// (2D, 3D, etc.). Multisample textures are not allowed.
///
/// Be sure your shader is set up according to the requirements documented in
/// `createGPUComputePipeline`.
pub fn bindGPUComputeSamplers(compute_pass: *GPUComputePass, first_slot: u32, texture_sampler_bindings: []const GPUTextureSamplerBinding) void {
    return SDL_BindGPUComputeSamplers(compute_pass, first_slot, texture_sampler_bindings.ptr, @intCast(texture_sampler_bindings.len));
}
extern fn SDL_BindGPUComputeSamplers(compute_pass: *GPUComputePass, first_slot: u32, texture_sampler_bindings: [*]const GPUTextureSamplerBinding, num_bindings: u32) void;

/// Binds storage textures as readonly for use on the compute pipeline.
///
/// These textures must have been created with
/// `GPUTextureUsageFlags.compute_storage_read`.
///
/// The textures being bound must have a matching type declared in the shader
/// (2D, 3D, 2DMS, etc.)
///
/// Be sure your shader is set up according to the requirements documented in
/// `createGPUShader`.
pub fn bindGPUComputeStorageTextures(compute_pass: *GPUComputePass, first_slot: u32, storage_textures: []const *GPUTexture) void {
    return SDL_BindGPUComputeStorageTextures(compute_pass, first_slot, storage_textures.ptr, @intCast(storage_textures.len));
}
extern fn SDL_BindGPUComputeStorageTextures(compute_pass: *GPUComputePass, first_slot: u32, storage_textures: [*]const *GPUTexture, num_bindings: u32) void;

/// Binds storage buffers as readonly for use on the compute pipeline.
///
/// These buffers must have been created with
/// `GPUBufferUsageFlags.compute_storage_read`.
///
/// Be sure your shader is set up according to the requirements documented in
/// `createGPUShader`.
pub fn bindGPUComputeStorageBuffers(compute_pass: *GPUComputePass, first_slot: u32, storage_buffers: []const *GPUBuffer) void {
    return SDL_BindGPUComputeStorageBuffers(compute_pass, first_slot, storage_buffers.ptr, @intCast(storage_buffers.len));
}
extern fn SDL_BindGPUComputeStorageBuffers(compute_pass: *GPUComputePass, first_slot: u32, storage_buffers: [*]const *GPUBuffer, num_bindings: u32) void;

/// Dispatches compute work.
///
/// You must not call this function before binding a compute pipeline.
///
/// A VERY IMPORTANT NOTE If you dispatch multiple times in a compute pass, and
/// the dispatches write to the same resource region as each other, there is no
/// guarantee of which order the writes will occur. If the write order matters,
/// you MUST end the compute pass and begin another one.
pub const dispatchGPUCompute = SDL_DispatchGPUCompute;
extern fn SDL_DispatchGPUCompute(compute_pass: *GPUComputePass, groupcount_x: u32, groupcount_y: u32, groupcount_z: u32) void;

/// Dispatches compute work with parameters set from a buffer.
///
/// The buffer layout should match the layout of
/// `GPUIndirectDispatchCommand`. You must not call this function before
/// binding a compute pipeline.
///
/// A VERY IMPORTANT NOTE If you dispatch multiple times in a compute pass, and
/// the dispatches write to the same resource region as each other, there is no
/// guarantee of which order the writes will occur. If the write order matters,
/// you MUST end the compute pass and begin another one.
pub const dispatchGPUComputeIndirect = SDL_DispatchGPUComputeIndirect;
extern fn SDL_DispatchGPUComputeIndirect(compute_pass: *GPUComputePass, buffer: *GPUBuffer, offset: u32) void;

/// Ends the current compute pass.
///
/// All bound compute state on the command buffer is unset. The compute pass
/// handle is now invalid.
pub const endGPUComputePass = SDL_EndGPUComputePass;
extern fn SDL_EndGPUComputePass(compute_pass: *GPUComputePass) void;

/// Maps a transfer buffer into application address space.
///
/// You must unmap the transfer buffer before encoding upload commands. The
/// memory is owned by the graphics driver - do NOT call `free` on the
/// returned pointer.
pub fn mapGPUTransferBuffer(device: *GPUDevice, transfer_buffer: *GPUTransferBuffer, cycle: bool) Error!*anyopaque {
    return SDL_MapGPUTransferBuffer(device, transfer_buffer, cycle) orelse makeError();
}
extern fn SDL_MapGPUTransferBuffer(device: *GPUDevice, transfer_buffer: *GPUTransferBuffer, cycle: bool) ?*anyopaque;

/// Unmaps a previously mapped transfer buffer.
pub const unmapGPUTransferBuffer = SDL_UnmapGPUTransferBuffer;
extern fn SDL_UnmapGPUTransferBuffer(device: *GPUDevice, transfer_buffer: *GPUTransferBuffer) void;

/// Begins a copy pass on a command buffer.
///
/// All operations related to copying to or from buffers or textures take place
/// inside a copy pass. You must not begin another copy pass, or a render pass
/// or compute pass before ending the copy pass.
pub const beginGPUCopyPass = SDL_BeginGPUCopyPass;
extern fn SDL_BeginGPUCopyPass(command_buffer: *GPUCommandBuffer) *GPUCopyPass;

/// Uploads data from a transfer buffer to a texture.
///
/// The upload occurs on the GPU timeline. You may assume that the upload has
/// finished in subsequent commands.
///
/// You must align the data in the transfer buffer to a multiple of the texel
/// size of the texture format.
pub const uploadToGPUTexture = SDL_UploadToGPUTexture;
extern fn SDL_UploadToGPUTexture(copy_pass: *GPUCopyPass, source: *const GPUTextureTransferInfo, destination: *const GPUTextureRegion, cycle: bool) void;

/// Uploads data from a transfer buffer to a buffer.
///
/// The upload occurs on the GPU timeline. You may assume that the upload has
/// finished in subsequent commands.
pub const uploadToGPUBuffer = SDL_UploadToGPUBuffer;
extern fn SDL_UploadToGPUBuffer(copy_pass: *GPUCopyPass, source: *const GPUTransferBufferLocation, destination: *const GPUBufferRegion, cycle: bool) void;

/// Performs a texture-to-texture copy.
///
/// This copy occurs on the GPU timeline. You may assume the copy has finished
/// in subsequent commands.
///
/// This function does not support copying between depth and color textures.
/// For those, copy the texture to a buffer and then to the destination
/// texture.
pub const copyGPUTextureToTexture = SDL_CopyGPUTextureToTexture;
extern fn SDL_CopyGPUTextureToTexture(copy_pass: *GPUCopyPass, source: *const GPUTextureLocation, destination: *const GPUTextureLocation, w: u32, h: u32, d: u32, cycle: bool) void;

/// Performs a buffer-to-buffer copy.
///
/// This copy occurs on the GPU timeline. You may assume the copy has finished
/// in subsequent commands.
pub const copyGPUBufferToBuffer = SDL_CopyGPUBufferToBuffer;
extern fn SDL_CopyGPUBufferToBuffer(copy_pass: *GPUCopyPass, source: *const GPUBufferLocation, destination: *const GPUBufferLocation, size: u32, cycle: bool) void;

/// Copies data from a texture to a transfer buffer on the GPU timeline.
///
/// This data is not guaranteed to be copied until the command buffer fence is
/// signaled.
pub const downloadFromGPUTexture = SDL_DownloadFromGPUTexture;
extern fn SDL_DownloadFromGPUTexture(copy_pass: *GPUCopyPass, source: *const GPUTextureRegion, destination: *const GPUTextureTransferInfo) void;

/// Copies data from a buffer to a transfer buffer on the GPU timeline.
///
/// This data is not guaranteed to be copied until the command buffer fence is
/// signaled.
pub const downloadFromGPUBuffer = SDL_DownloadFromGPUBuffer;
extern fn SDL_DownloadFromGPUBuffer(copy_pass: *GPUCopyPass, source: *const GPUBufferRegion, destination: *const GPUTransferBufferLocation) void;

/// Ends the current copy pass.
pub const endGPUCopyPass = SDL_EndGPUCopyPass;
extern fn SDL_EndGPUCopyPass(copy_pass: *GPUCopyPass) void;

/// Generates mipmaps for the given texture.
///
/// This function must not be called inside of any pass.
pub const generateMipmapsForGPUTexture = SDL_GenerateMipmapsForGPUTexture;
extern fn SDL_GenerateMipmapsForGPUTexture(command_buffer: *GPUCommandBuffer, texture: *GPUTexture) void;

/// Blits from a source texture region to a destination texture region.
///
/// This function must not be called inside of any pass.
pub const blitGPUTexture = SDL_BlitGPUTexture;
extern fn SDL_BlitGPUTexture(command_buffer: *GPUCommandBuffer, info: *const GPUBlitInfo) void;

/// Determines whether a swapchain composition is supported by the window.
///
/// The window must be claimed before calling this function.
pub const windowSupportsGPUSwapchainComposition = SDL_WindowSupportsGPUSwapchainComposition;
extern fn SDL_WindowSupportsGPUSwapchainComposition(device: *GPUDevice, window: *sdl.Window, swapchain_composition: GPUSwapchainComposition) bool;

/// Determines whether a presentation mode is supported by the window.
///
/// The window must be claimed before calling this function.
pub const windowSupportsGPUPresentMode = SDL_WindowSupportsGPUPresentMode;
extern fn SDL_WindowSupportsGPUPresentMode(device: *GPUDevice, window: *sdl.Window, present_mode: GPUPresentMode) bool;

/// Claims a window, creating a swapchain structure for it.
///
/// This must be called before `acquireGPUSwapchainTexture` is called using
/// the window. You should only call this function from the thread that created
/// the window.
///
/// The swapchain will be created with `GPUSwapchainComposition.sdr` and
/// `GPUPresentMode.vsync`. If you want to have different swapchain
/// parameters, you must call `setGPUSwapchainParameters` after claiming the
/// window.
pub fn claimWindowForGPUDevice(device: *GPUDevice, window: *sdl.Window) Error!void {
    if (!SDL_ClaimWindowForGPUDevice(device, window)) return makeError();
}
extern fn SDL_ClaimWindowForGPUDevice(device: *GPUDevice, window: *sdl.Window) bool;

/// Unclaims a window, destroying its swapchain structure.
pub const releaseWindowFromGPUDevice = SDL_ReleaseWindowFromGPUDevice;
extern fn SDL_ReleaseWindowFromGPUDevice(device: *GPUDevice, window: *sdl.Window) void;

/// Changes the swapchain parameters for the given claimed window.
///
/// This function will fail if the requested present mode or swapchain
/// composition are unsupported by the device. Check if the parameters are
/// supported via `windowSupportsGPUPresentMode` /
/// `windowSupportsGPUSwapchainComposition` prior to calling this function.
///
/// `GPUPresentMode.vsync` with `GPUSwapchainComposition.sdr` is always
/// supported.
pub fn setGPUSwapchainParameters(device: *GPUDevice, window: *sdl.Window, swapchain_composition: GPUSwapchainComposition, present_mode: GPUPresentMode) Error!void {
    if (!SDL_SetGPUSwapchainParameters(device, window, swapchain_composition, present_mode)) return makeError();
}
extern fn SDL_SetGPUSwapchainParameters(device: *GPUDevice, window: *sdl.Window, swapchain_composition: GPUSwapchainComposition, present_mode: GPUPresentMode) bool;

/// Configures the maximum allowed number of frames in flight.
///
/// The default value when the device is created is 2. This means that after
/// you have submitted 2 frames for presentation, if the GPU has not finished
/// working on the first frame, `acquireGPUSwapchainTexture` will fill the
/// swapchain texture pointer with null, and
/// `waitAndAcquireGPUSwapchainTexture` will block.
///
/// Higher values increase throughput at the expense of visual latency. Lower
/// values decrease visual latency at the expense of throughput.
///
/// Note that calling this function will stall and flush the command queue to
/// prevent synchronization issues.
///
/// The minimum value of allowed frames in flight is 1, and the maximum is 3.
pub fn setGPUAllowedFramesInFlight(device: *GPUDevice, allowed_frames_in_flight: u32) Error!void {
    if (!SDL_SetGPUAllowedFramesInFlight(device, allowed_frames_in_flight)) return makeError();
}
extern fn SDL_SetGPUAllowedFramesInFlight(device: *GPUDevice, allowed_frames_in_flight: u32) bool;

/// Obtains the texture format of the swapchain for the given window.
///
/// Note that this format can change if the swapchain parameters change.
pub const getGPUSwapchainTextureFormat = SDL_GetGPUSwapchainTextureFormat;
extern fn SDL_GetGPUSwapchainTextureFormat(device: *GPUDevice, window: *sdl.Window) GPUTextureFormat;

/// Acquire a texture to use in presentation.
///
/// When a swapchain texture is acquired on a command buffer, it will
/// automatically be submitted for presentation when the command buffer is
/// submitted. The swapchain texture should only be referenced by the command
/// buffer used to acquire it.
///
/// This function will fill the swapchain texture handle with null if too many
/// frames are in flight. This is not an error. This null pointer should not be
/// passed back into SDL. Instead, it should be considered as an indication to
/// wait until the swapchain is available.
///
/// If you use this function, it is possible to create a situation where many
/// command buffers are allocated while the rendering context waits for the GPU
/// to catch up, which will cause memory usage to grow. You should use
/// `waitAndAcquireGPUSwapchainTexture` unless you know what you are doing
/// with timing.
///
/// The swapchain texture is managed by the implementation and must not be
/// freed by the user. You MUST NOT call this function from any thread other
/// than the one that created the window.
///
/// `texture` is null if the swapchain texture isn't available (for example
/// when the window is minimized), which is not an error.
pub fn acquireGPUSwapchainTexture(command_buffer: *GPUCommandBuffer, window: *sdl.Window) Error!struct { texture: ?*GPUTexture, width: u32, height: u32 } {
    var texture: ?*GPUTexture = undefined;
    var width: u32 = undefined;
    var height: u32 = undefined;
    if (!SDL_AcquireGPUSwapchainTexture(command_buffer, window, &texture, &width, &height)) return makeError();
    return .{ .texture = texture, .width = width, .height = height };
}
extern fn SDL_AcquireGPUSwapchainTexture(command_buffer: *GPUCommandBuffer, window: *sdl.Window, swapchain_texture: *?*GPUTexture, swapchain_texture_width: ?*u32, swapchain_texture_height: ?*u32) bool;

/// Blocks the thread until a swapchain texture is available to be acquired.
pub fn waitForGPUSwapchain(device: *GPUDevice, window: *sdl.Window) Error!void {
    if (!SDL_WaitForGPUSwapchain(device, window)) return makeError();
}
extern fn SDL_WaitForGPUSwapchain(device: *GPUDevice, window: *sdl.Window) bool;

/// Blocks the thread until a swapchain texture is available to be acquired,
/// and then acquires it.
///
/// When a swapchain texture is acquired on a command buffer, it will
/// automatically be submitted for presentation when the command buffer is
/// submitted. The swapchain texture should only be referenced by the command
/// buffer used to acquire it. It is an error to call
/// `cancelGPUCommandBuffer` after a swapchain texture is acquired.
///
/// This function can fill the swapchain texture handle with null in certain
/// cases, for example if the window is minimized. This is not an error. You
/// should always make sure to check whether the pointer is null before
/// actually using it.
///
/// The swapchain texture is managed by the implementation and must not be
/// freed by the user. You MUST NOT call this function from any thread other
/// than the one that created the window.
///
/// The swapchain texture is write-only and cannot be used as a sampler or for
/// another reading operation.
///
/// `texture` is null if the swapchain texture isn't available (for example
/// when the window is minimized), which is not an error.
pub fn waitAndAcquireGPUSwapchainTexture(command_buffer: *GPUCommandBuffer, window: *sdl.Window) Error!struct { texture: ?*GPUTexture, width: u32, height: u32 } {
    var texture: ?*GPUTexture = undefined;
    var width: u32 = undefined;
    var height: u32 = undefined;
    if (!SDL_WaitAndAcquireGPUSwapchainTexture(command_buffer, window, &texture, &width, &height)) return makeError();
    return .{ .texture = texture, .width = width, .height = height };
}
extern fn SDL_WaitAndAcquireGPUSwapchainTexture(command_buffer: *GPUCommandBuffer, window: *sdl.Window, swapchain_texture: *?*GPUTexture, swapchain_texture_width: ?*u32, swapchain_texture_height: ?*u32) bool;

/// Submits a command buffer so its commands can be processed on the GPU.
///
/// It is invalid to use the command buffer after this is called.
///
/// This must be called from the thread the command buffer was acquired on.
///
/// All commands in the submission are guaranteed to begin executing before any
/// command in a subsequent submission begins executing.
pub fn submitGPUCommandBuffer(command_buffer: *GPUCommandBuffer) Error!void {
    if (!SDL_SubmitGPUCommandBuffer(command_buffer)) return makeError();
}
extern fn SDL_SubmitGPUCommandBuffer(command_buffer: *GPUCommandBuffer) bool;

/// Submits a command buffer so its commands can be processed on the GPU, and
/// acquires a fence associated with the command buffer.
///
/// You must release this fence when it is no longer needed or it will cause a
/// leak. It is invalid to use the command buffer after this is called.
///
/// This must be called from the thread the command buffer was acquired on.
///
/// All commands in the submission are guaranteed to begin executing before any
/// command in a subsequent submission begins executing.
pub fn submitGPUCommandBufferAndAcquireFence(command_buffer: *GPUCommandBuffer) Error!*GPUFence {
    return SDL_SubmitGPUCommandBufferAndAcquireFence(command_buffer) orelse makeError();
}
extern fn SDL_SubmitGPUCommandBufferAndAcquireFence(command_buffer: *GPUCommandBuffer) ?*GPUFence;

/// Cancels a command buffer.
///
/// None of the enqueued commands are executed.
///
/// It is an error to call this function after a swapchain texture has been
/// acquired.
///
/// This must be called from the thread the command buffer was acquired on.
///
/// You must not reference the command buffer after calling this function.
pub fn cancelGPUCommandBuffer(command_buffer: *GPUCommandBuffer) Error!void {
    if (!SDL_CancelGPUCommandBuffer(command_buffer)) return makeError();
}
extern fn SDL_CancelGPUCommandBuffer(command_buffer: *GPUCommandBuffer) bool;

/// Blocks the thread until the GPU is completely idle.
pub fn waitForGPUIdle(device: *GPUDevice) Error!void {
    if (!SDL_WaitForGPUIdle(device)) return makeError();
}
extern fn SDL_WaitForGPUIdle(device: *GPUDevice) bool;

/// Blocks the thread until the given fences are signaled.
pub fn waitForGPUFences(device: *GPUDevice, wait_all: bool, fences: []const *GPUFence) Error!void {
    if (!SDL_WaitForGPUFences(device, wait_all, fences.ptr, @intCast(fences.len))) return makeError();
}
extern fn SDL_WaitForGPUFences(device: *GPUDevice, wait_all: bool, fences: [*]const *GPUFence, num_fences: u32) bool;

/// Checks the status of a fence.
pub const queryGPUFence = SDL_QueryGPUFence;
extern fn SDL_QueryGPUFence(device: *GPUDevice, fence: *GPUFence) bool;

/// Releases a fence obtained from `submitGPUCommandBufferAndAcquireFence`.
///
/// You must not reference the fence after calling this function.
pub const releaseGPUFence = SDL_ReleaseGPUFence;
extern fn SDL_ReleaseGPUFence(device: *GPUDevice, fence: *GPUFence) void;

/// Obtains the texel block size for a texture format.
pub const gpuTextureFormatTexelBlockSize = SDL_GPUTextureFormatTexelBlockSize;
extern fn SDL_GPUTextureFormatTexelBlockSize(format: GPUTextureFormat) u32;

/// Determines whether a texture format is supported for a given type and
/// usage.
pub const gpuTextureSupportsFormat = SDL_GPUTextureSupportsFormat;
extern fn SDL_GPUTextureSupportsFormat(device: *GPUDevice, format: GPUTextureFormat, @"type": GPUTextureType, usage: GPUTextureUsageFlags) bool;

/// Determines if a sample count for a texture format is supported.
pub const gpuTextureSupportsSampleCount = SDL_GPUTextureSupportsSampleCount;
extern fn SDL_GPUTextureSupportsSampleCount(device: *GPUDevice, format: GPUTextureFormat, sample_count: GPUSampleCount) bool;

/// Calculate the size in bytes of a texture format with dimensions.
pub const calculateGPUTextureFormatSize = SDL_CalculateGPUTextureFormatSize;
extern fn SDL_CalculateGPUTextureFormatSize(format: GPUTextureFormat, width: u32, height: u32, depth_or_layer_count: u32) u32;

/// Get the SDL pixel format corresponding to a GPU texture format.
pub const getPixelFormatFromGPUTextureFormat = SDL_GetPixelFormatFromGPUTextureFormat;
extern fn SDL_GetPixelFormatFromGPUTextureFormat(format: GPUTextureFormat) sdl.PixelFormat;

/// Get the GPU texture format corresponding to an SDL pixel format.
pub const getGPUTextureFormatFromPixelFormat = SDL_GetGPUTextureFormatFromPixelFormat;
extern fn SDL_GetGPUTextureFormatFromPixelFormat(format: sdl.PixelFormat) GPUTextureFormat;

/// Call this to suspend GPU operation on Xbox when you receive the
/// `EventType.did_enter_background` event.
///
/// Do NOT call any SDL_GPU functions after calling this function! This must
/// also be called before calling `gdkSuspendComplete`.
pub const gdkSuspendGPU = SDL_GDKSuspendGPU;
extern fn SDL_GDKSuspendGPU(device: *GPUDevice) void;

/// Call this to resume GPU operation on Xbox when you receive the
/// `EventType.will_enter_foreground` event.
///
/// When resuming, this function MUST be called before calling any other
/// SDL_GPU functions.
pub const gdkResumeGPU = SDL_GDKResumeGPU;
extern fn SDL_GDKResumeGPU(device: *GPUDevice) void;
