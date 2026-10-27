//! Blend modes (SDL_blendmode.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");

/// A set of blend modes used in drawing operations.
///
/// These predefined blend modes are supported everywhere.
///
/// Additional values may be obtained from `composeCustomBlendMode`.
pub const BlendMode = enum(u32) {
    /// no blending: dstRGBA = srcRGBA
    none = 0x0,
    /// alpha blending: dstRGB = (srcRGB * srcA) + (dstRGB * (1-srcA)), dstA = srcA + (dstA * (1-srcA))
    blend = 0x1,
    /// pre-multiplied alpha blending: dstRGBA = srcRGBA + (dstRGBA * (1-srcA))
    blend_premultiplied = 0x10,
    /// additive blending: dstRGB = (srcRGB * srcA) + dstRGB, dstA = dstA
    add = 0x2,
    /// pre-multiplied additive blending: dstRGB = srcRGB + dstRGB, dstA = dstA
    add_premultiplied = 0x20,
    /// color modulate: dstRGB = srcRGB * dstRGB, dstA = dstA
    mod = 0x4,
    /// color multiply: dstRGB = (srcRGB * dstRGB) + (dstRGB * (1-srcA)), dstA = dstA
    mul = 0x8,
    /// Invalid blend mode
    invalid = 0x7fffffff,
    _,
};

/// The blend operation used when combining source and destination pixel
/// components.
pub const BlendOperation = enum(c_int) {
    /// dst + src: supported by all renderers
    add = 0x1,
    /// src - dst : supported by D3D, OpenGL, OpenGLES, and Vulkan
    subtract = 0x2,
    /// dst - src : supported by D3D, OpenGL, OpenGLES, and Vulkan
    rev_subtract = 0x3,
    /// min(dst, src) : supported by D3D, OpenGL, OpenGLES, and Vulkan
    minimum = 0x4,
    /// max(dst, src) : supported by D3D, OpenGL, OpenGLES, and Vulkan
    maximum = 0x5,
};

/// The normalized factor used to multiply pixel components.
///
/// The blend factors are multiplied with the pixels from a drawing operation
/// (src) and the pixels from the render target (dst) before the blend
/// operation. The comma-separated factors listed above are always applied in
/// the component order red, green, blue, and alpha.
pub const BlendFactor = enum(c_int) {
    /// 0, 0, 0, 0
    zero = 0x1,
    /// 1, 1, 1, 1
    one = 0x2,
    /// srcR, srcG, srcB, srcA
    src_color = 0x3,
    /// 1-srcR, 1-srcG, 1-srcB, 1-srcA
    one_minus_src_color = 0x4,
    /// srcA, srcA, srcA, srcA
    src_alpha = 0x5,
    /// 1-srcA, 1-srcA, 1-srcA, 1-srcA
    one_minus_src_alpha = 0x6,
    /// dstR, dstG, dstB, dstA
    dst_color = 0x7,
    /// 1-dstR, 1-dstG, 1-dstB, 1-dstA
    one_minus_dst_color = 0x8,
    /// dstA, dstA, dstA, dstA
    dst_alpha = 0x9,
    /// 1-dstA, 1-dstA, 1-dstA, 1-dstA
    one_minus_dst_alpha = 0xA,
};

/// Compose a custom blend mode for renderers.
///
/// The functions `setRenderDrawBlendMode` and `setTextureBlendMode` accept
/// the `BlendMode` returned by this function if the renderer supports it.
///
/// A blend mode controls how the pixels from a drawing operation (source) get
/// combined with the pixels from the render target (destination). First, the
/// components of the source and destination pixels get multiplied with their
/// blend factors. Then, the blend operation takes the two products and
/// calculates the result that will get stored in the render target.
///
/// Expressed in pseudocode, it would look like this:
///
/// ```c
/// dstRGB = colorOperation(srcRGB * srcColorFactor, dstRGB * dstColorFactor);
/// dstA = alphaOperation(srcA * srcAlphaFactor, dstA * dstAlphaFactor);
/// ```
///
/// Where the functions `colorOperation(src, dst)` and `alphaOperation(src,
/// dst)` can return one of the following:
///
/// - `src + dst`
/// - `src - dst`
/// - `dst - src`
/// - `min(src, dst)`
/// - `max(src, dst)`
///
/// The red, green, and blue components are always multiplied with the first,
/// second, and third components of the `BlendFactor`, respectively. The
/// fourth component is not used.
///
/// The alpha component is always multiplied with the fourth component of the
/// `BlendFactor`. The other components are not used in the alpha
/// calculation.
///
/// Support for these blend modes varies for each renderer. To check if a
/// specific `BlendMode` is supported, create a renderer and pass it to
/// either `setRenderDrawBlendMode` or `setTextureBlendMode`. They will
/// return with an error if the blend mode is not supported.
///
/// This list describes the support of custom blend modes for each renderer.
/// All renderers support the four blend modes listed in the `BlendMode`
/// enumeration.
///
/// - **direct3d**: Supports all operations with all factors. However, some
///   factors produce unexpected results with `BlendOperation.minimum` and
///   `BlendOperation.maximum`.
/// - **direct3d11**: Same as Direct3D 9.
/// - **opengl**: Supports the `BlendOperation.add` operation with all
///   factors. OpenGL versions 1.1, 1.2, and 1.3 do not work correctly here.
/// - **opengles2**: Supports the `BlendOperation.add`,
///   `BlendOperation.subtract`, `BlendOperation.rev_subtract`
///   operations with all factors.
/// - **psp**: No custom blend mode support.
/// - **software**: No custom blend mode support.
///
/// Some renderers do not provide an alpha component for the default render
/// target. The `BlendFactor.dst_alpha` and
/// `BlendFactor.one_minus_dst_alpha` factors do not have an effect in this
/// case.
pub const composeCustomBlendMode = SDL_ComposeCustomBlendMode;
extern fn SDL_ComposeCustomBlendMode(srcColorFactor: BlendFactor, dstColorFactor: BlendFactor, colorOperation: BlendOperation, srcAlphaFactor: BlendFactor, dstAlphaFactor: BlendFactor, alphaOperation: BlendOperation) BlendMode;
