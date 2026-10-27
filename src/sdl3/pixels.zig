//! Pixel Formats and Conversion Routines (SDL_pixels.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// A fully opaque 8-bit alpha value.
pub const alpha_opaque: u8 = 255;

/// A fully opaque floating point alpha value.
pub const alpha_opaque_float: f32 = 1.0;

/// A fully transparent 8-bit alpha value.
pub const alpha_transparent: u8 = 0;

/// A fully transparent floating point alpha value.
pub const alpha_transparent_float: f32 = 0.0;

/// Pixel type.
pub const PixelType = enum(c_int) {
    unknown,
    index1,
    index4,
    index8,
    packed8,
    packed16,
    packed32,
    arrayu8,
    arrayu16,
    arrayu32,
    arrayf16,
    arrayf32,
    index2,
    _,
};

/// Bitmap pixel order, high bit -> low bit.
pub const BitmapOrder = enum(c_int) {
    none,
    @"4321",
    @"1234",
};

/// Packed component order, high bit -> low bit.
pub const PackedOrder = enum(c_int) {
    none,
    xrgb,
    rgbx,
    argb,
    rgba,
    xbgr,
    bgrx,
    abgr,
    bgra,
};

/// Array component order, low byte -> high byte.
pub const ArrayOrder = enum(c_int) {
    none,
    rgb,
    rgba,
    argb,
    bgr,
    bgra,
    abgr,
};

/// Packed component layout.
pub const PackedLayout = enum(c_int) {
    none,
    @"332",
    @"4444",
    @"1555",
    @"5551",
    @"565",
    @"8888",
    @"2101010",
    @"1010102",
    _,
};

/// Pixel format.
///
/// SDL's pixel formats have the following naming convention:
///
/// - Names with a list of components and a single bit count, such as RGB24 and
///   ABGR32, define a platform-independent encoding into bytes in the order
///   specified. For example, in RGB24 data, each pixel is encoded in 3 bytes
///   (red, green, blue) in that order, and in ABGR32 data, each pixel is
///   encoded in 4 bytes (alpha, blue, green, red) in that order. Use these
///   names if the property of a format that is important to you is the order
///   of the bytes in memory or on disk.
/// - Names with a bit count per component, such as ARGB8888 and XRGB1555, are
///   "packed" into an appropriately-sized integer in the platform's native
///   endianness. For example, ARGB8888 is a sequence of 32-bit integers; in
///   each integer, the most significant bits are alpha, and the least
///   significant bits are blue. On a little-endian CPU such as x86, the least
///   significant bits of each integer are arranged first in memory, but on a
///   big-endian CPU such as s390x, the most significant bits are arranged
///   first. Use these names if the property of a format that is important to
///   you is the meaning of each bit position within a native-endianness
///   integer.
/// - In indexed formats such as INDEX4LSB, each pixel is represented by
///   encoding an index into the palette into the indicated number of bits,
///   with multiple pixels packed into each byte if appropriate. In LSB
///   formats, the first (leftmost) pixel is stored in the least-significant
///   bits of the byte; in MSB formats, it's stored in the most-significant
///   bits. INDEX8 does not need LSB/MSB variants, because each pixel exactly
///   fills one byte.
///
/// The 32-bit byte-array encodings such as RGBA32 are aliases for the
/// appropriate 8888 encoding for the current platform. For example, RGBA32 is
/// an alias for ABGR8888 on little-endian CPUs like x86, or an alias for
/// RGBA8888 on big-endian CPUs.
pub const PixelFormat = enum(u32) {
    unknown = 0,
    index1lsb = 0x11100100,
    index1msb = 0x11200100,
    index2lsb = 0x1c100200,
    index2msb = 0x1c200200,
    index4lsb = 0x12100400,
    index4msb = 0x12200400,
    index8 = 0x13000801,
    rgb332 = 0x14110801,
    xrgb4444 = 0x15120c02,
    xbgr4444 = 0x15520c02,
    xrgb1555 = 0x15130f02,
    xbgr1555 = 0x15530f02,
    argb4444 = 0x15321002,
    rgba4444 = 0x15421002,
    abgr4444 = 0x15721002,
    bgra4444 = 0x15821002,
    argb1555 = 0x15331002,
    rgba5551 = 0x15441002,
    abgr1555 = 0x15731002,
    bgra5551 = 0x15841002,
    rgb565 = 0x15151002,
    bgr565 = 0x15551002,
    rgb24 = 0x17101803,
    bgr24 = 0x17401803,
    xrgb8888 = 0x16161804,
    rgbx8888 = 0x16261804,
    xbgr8888 = 0x16561804,
    bgrx8888 = 0x16661804,
    argb8888 = 0x16362004,
    rgba8888 = 0x16462004,
    abgr8888 = 0x16762004,
    bgra8888 = 0x16862004,
    xrgb2101010 = 0x16172004,
    xbgr2101010 = 0x16572004,
    argb2101010 = 0x16372004,
    abgr2101010 = 0x16772004,
    rgb48 = 0x18103006,
    bgr48 = 0x18403006,
    rgba64 = 0x18204008,
    argb64 = 0x18304008,
    bgra64 = 0x18504008,
    abgr64 = 0x18604008,
    rgb48_float = 0x1a103006,
    bgr48_float = 0x1a403006,
    rgba64_float = 0x1a204008,
    argb64_float = 0x1a304008,
    bgra64_float = 0x1a504008,
    abgr64_float = 0x1a604008,
    rgb96_float = 0x1b10600c,
    bgr96_float = 0x1b40600c,
    rgba128_float = 0x1b208010,
    argb128_float = 0x1b308010,
    bgra128_float = 0x1b508010,
    abgr128_float = 0x1b608010,
    /// Planar mode: Y + V + U  (3 planes)
    yv12 = 0x32315659,
    /// Planar mode: Y + U + V  (3 planes)
    iyuv = 0x56555949,
    /// Packed mode: Y0+U0+Y1+V0 (1 plane)
    yuy2 = 0x32595559,
    /// Packed mode: U0+Y0+V0+Y1 (1 plane)
    uyvy = 0x59565955,
    /// Packed mode: Y0+V0+Y1+U0 (1 plane)
    yvyu = 0x55595659,
    /// Planar mode: Y + U/V interleaved  (2 planes)
    nv12 = 0x3231564e,
    /// Planar mode: Y + V/U interleaved  (2 planes)
    nv21 = 0x3132564e,
    /// Planar mode: Y + U/V interleaved  (2 planes)
    p010 = 0x30313050,
    /// Android video texture format
    external_oes = 0x2053454f,
    /// Motion JPEG
    mjpg = 0x47504a4d,
    _,

    const little_endian = @import("builtin").cpu.arch.endian() == .little;

    pub const rgba32: PixelFormat = if (little_endian) .abgr8888 else .rgba8888;
    pub const argb32: PixelFormat = if (little_endian) .bgra8888 else .argb8888;
    pub const bgra32: PixelFormat = if (little_endian) .argb8888 else .bgra8888;
    pub const abgr32: PixelFormat = if (little_endian) .rgba8888 else .abgr8888;
    pub const rgbx32: PixelFormat = if (little_endian) .xbgr8888 else .rgbx8888;
    pub const xrgb32: PixelFormat = if (little_endian) .bgrx8888 else .xrgb8888;
    pub const bgrx32: PixelFormat = if (little_endian) .xrgb8888 else .bgrx8888;
    pub const xbgr32: PixelFormat = if (little_endian) .rgbx8888 else .xbgr8888;

    /// A function to define a FourCC pixel format.
    pub fn defineFourCC(a: u8, b: u8, c: u8, d: u8) PixelFormat {
        return @fromBackingInt(@intCast(@as(u32, a) | (@as(u32, b) << 8) | (@as(u32, c) << 16) | (@as(u32, d) << 24)));
    }

    /// A function to define all the non-FourCC pixel formats.
    ///
    /// `order_` is a `BitmapOrder`, `PackedOrder` or `ArrayOrder` value,
    /// depending on `pixel_type`.
    pub fn define(pixel_type: PixelType, order_: anytype, layout_: PackedLayout, bits: u8, bytes: u8) PixelFormat {
        return @fromBackingInt(@intCast((1 << 28) |
            (@as(u32, @intCast(@backingInt(pixel_type))) << 24) |
            (@as(u32, @intCast(@backingInt(order_))) << 20) |
            (@as(u32, @intCast(@backingInt(layout_))) << 16) |
            (@as(u32, bits) << 8) |
            (@as(u32, bytes) << 0)));
    }

    /// Retrieve the flags of a pixel format.
    pub fn flag(self: PixelFormat) u4 {
        return @truncate(@backingInt(self) >> 28);
    }

    /// Retrieve the type of a pixel format.
    pub fn pixelType(self: PixelFormat) PixelType {
        return @fromBackingInt(@intCast(@as(u4, @truncate(@backingInt(self) >> 24))));
    }

    /// Retrieve the order of a pixel format.
    ///
    /// This is a `BitmapOrder`, `PackedOrder` or `ArrayOrder` value,
    /// depending on the format type.
    pub fn order(self: PixelFormat) u4 {
        return @truncate(@backingInt(self) >> 20);
    }

    /// Retrieve the layout of a pixel format.
    ///
    /// This is usually a value from the `PackedLayout` enumeration, or zero if
    /// a layout doesn't make sense for the format type.
    pub fn layout(self: PixelFormat) PackedLayout {
        return @fromBackingInt(@intCast(@as(u4, @truncate(@backingInt(self) >> 16))));
    }

    /// Determine this format's bits per pixel.
    ///
    /// FourCC formats will report zero here, as it rarely makes sense to
    /// measure them per-pixel.
    pub fn bitsPerPixel(self: PixelFormat) u8 {
        if (self.isFourCC()) return 0;
        return @truncate(@backingInt(self) >> 8);
    }

    /// Determine this format's bytes per pixel.
    ///
    /// FourCC formats do their best here, but many of them don't have a
    /// meaningful measurement of bytes per pixel.
    pub fn bytesPerPixel(self: PixelFormat) u8 {
        if (self.isFourCC()) return switch (self) {
            .yuy2, .uyvy, .yvyu, .p010 => 2,
            else => 1,
        };
        return @truncate(@backingInt(self));
    }

    /// Determine if this is an indexed format.
    pub fn isIndexed(self: PixelFormat) bool {
        return !self.isFourCC() and switch (self.pixelType()) {
            .index1, .index2, .index4, .index8 => true,
            else => false,
        };
    }

    /// Determine if this is a packed format.
    pub fn isPacked(self: PixelFormat) bool {
        return !self.isFourCC() and switch (self.pixelType()) {
            .packed8, .packed16, .packed32 => true,
            else => false,
        };
    }

    /// Determine if this is an array format.
    pub fn isArray(self: PixelFormat) bool {
        return !self.isFourCC() and switch (self.pixelType()) {
            .arrayu8, .arrayu16, .arrayu32, .arrayf16, .arrayf32 => true,
            else => false,
        };
    }

    /// Determine if this is a 10-bit format.
    pub fn is10Bit(self: PixelFormat) bool {
        return !self.isFourCC() and self.pixelType() == .packed32 and self.layout() == .@"2101010";
    }

    /// Determine if this is a floating point format.
    pub fn isFloat(self: PixelFormat) bool {
        return !self.isFourCC() and switch (self.pixelType()) {
            .arrayf16, .arrayf32 => true,
            else => false,
        };
    }

    /// Determine if this format has an alpha channel.
    pub fn isAlpha(self: PixelFormat) bool {
        if (self.isPacked()) return switch (@as(PackedOrder, @fromBackingInt(@intCast(self.order())))) {
            .argb, .rgba, .abgr, .bgra => true,
            else => false,
        };
        if (self.isArray()) return switch (@as(ArrayOrder, @fromBackingInt(@intCast(self.order())))) {
            .argb, .rgba, .abgr, .bgra => true,
            else => false,
        };
        return false;
    }

    /// Determine if this is a "FourCC" format.
    ///
    /// This covers custom and other unusual formats.
    pub fn isFourCC(self: PixelFormat) bool {
        return @backingInt(self) != 0 and self.flag() != 1;
    }
};

/// Colorspace color type.
pub const ColorType = enum(c_int) {
    unknown = 0,
    rgb = 1,
    ycbcr = 2,
    _,
};

/// Colorspace color range, as described by
/// https://www.itu.int/rec/R-REC-BT.2100-2-201807-I/en
pub const ColorRange = enum(c_int) {
    unknown = 0,
    /// Narrow range, e.g. 16-235 for 8-bit RGB and luma, and 16-240 for 8-bit chroma
    limited = 1,
    /// Full range, e.g. 0-255 for 8-bit RGB and luma, and 1-255 for 8-bit chroma
    full = 2,
    _,
};

/// Colorspace color primaries, as described by
/// https://www.itu.int/rec/T-REC-H.273-201612-S/en
pub const ColorPrimaries = enum(c_int) {
    unknown = 0,
    /// ITU-R BT.709-6
    bt709 = 1,
    unspecified = 2,
    /// ITU-R BT.470-6 System M
    bt470m = 4,
    /// ITU-R BT.470-6 System B, G / ITU-R BT.601-7 625
    bt470bg = 5,
    /// ITU-R BT.601-7 525, SMPTE 170M
    bt601 = 6,
    /// SMPTE 240M, functionally the same as `ColorPrimaries.bt601`
    smpte240 = 7,
    /// Generic film (color filters using Illuminant C)
    generic_film = 8,
    /// ITU-R BT.2020-2 / ITU-R BT.2100-0
    bt2020 = 9,
    /// SMPTE ST 428-1
    xyz = 10,
    /// SMPTE RP 431-2
    smpte431 = 11,
    /// SMPTE EG 432-1 / DCI P3
    smpte432 = 12,
    /// EBU Tech. 3213-E
    ebu3213 = 22,
    custom = 31,
    _,
};

/// Colorspace transfer characteristics.
///
/// These are as described by https://www.itu.int/rec/T-REC-H.273-201612-S/en
pub const TransferCharacteristics = enum(c_int) {
    unknown = 0,
    /// Rec. ITU-R BT.709-6 / ITU-R BT1361
    bt709 = 1,
    unspecified = 2,
    /// ITU-R BT.470-6 System M / ITU-R BT1700 625 PAL & SECAM
    gamma22 = 4,
    /// ITU-R BT.470-6 System B, G
    gamma28 = 5,
    /// SMPTE ST 170M / ITU-R BT.601-7 525 or 625
    bt601 = 6,
    /// SMPTE ST 240M
    smpte240 = 7,
    linear = 8,
    log100 = 9,
    log100_sqrt10 = 10,
    /// IEC 61966-2-4
    iec61966 = 11,
    /// ITU-R BT1361 Extended Colour Gamut
    bt1361 = 12,
    /// IEC 61966-2-1 (sRGB or sYCC)
    srgb = 13,
    /// ITU-R BT2020 for 10-bit system
    bt2020_10bit = 14,
    /// ITU-R BT2020 for 12-bit system
    bt2020_12bit = 15,
    /// SMPTE ST 2084 for 10-, 12-, 14- and 16-bit systems
    pq = 16,
    /// SMPTE ST 428-1
    smpte428 = 17,
    /// ARIB STD-B67, known as "hybrid log-gamma" (HLG)
    hlg = 18,
    custom = 31,
    _,
};

/// Colorspace matrix coefficients.
///
/// These are as described by https://www.itu.int/rec/T-REC-H.273-201612-S/en
pub const MatrixCoefficients = enum(c_int) {
    identity = 0,
    /// ITU-R BT.709-6
    bt709 = 1,
    unspecified = 2,
    /// US FCC Title 47
    fcc = 4,
    /// ITU-R BT.470-6 System B, G / ITU-R BT.601-7 625, functionally the same as `MatrixCoefficients.bt601`
    bt470bg = 5,
    /// ITU-R BT.601-7 525
    bt601 = 6,
    /// SMPTE 240M
    smpte240 = 7,
    ycgco = 8,
    /// ITU-R BT.2020-2 non-constant luminance
    bt2020_ncl = 9,
    /// ITU-R BT.2020-2 constant luminance
    bt2020_cl = 10,
    /// SMPTE ST 2085
    smpte2085 = 11,
    chroma_derived_ncl = 12,
    chroma_derived_cl = 13,
    /// ITU-R BT.2100-0 ICTCP
    ictcp = 14,
    custom = 31,
    _,
};

/// Colorspace chroma sample location.
pub const ChromaLocation = enum(c_int) {
    /// RGB, no chroma sampling
    none = 0,
    /// In MPEG-2, MPEG-4, and AVC, Cb and Cr are taken on midpoint of the left-edge of the 2x2 square. In other words, they have the same horizontal location as the top-left pixel, but is shifted one-half pixel down vertically.
    left = 1,
    /// In JPEG/JFIF, H.261, and MPEG-1, Cb and Cr are taken at the center of the 2x2 square. In other words, they are offset one-half pixel to the right and one-half pixel down compared to the top-left pixel.
    center = 2,
    /// In HEVC for BT.2020 and BT.2100 content (in particular on Blu-rays), Cb and Cr are sampled at the same location as the group's top-left Y pixel ("co-sited", "co-located").
    topleft = 3,
    _,
};

/// Colorspace definitions.
///
/// Since similar colorspaces may vary in their details (matrix, transfer
/// function, etc.), this is not an exhaustive list, but rather a
/// representative sample of the kinds of colorspaces supported in SDL.
pub const Colorspace = enum(u32) {
    unknown = 0,
    /// Equivalent to DXGI_COLOR_SPACE_RGB_FULL_G22_NONE_P709
    srgb = 0x120005a0,
    /// Equivalent to DXGI_COLOR_SPACE_RGB_FULL_G10_NONE_P709
    srgb_linear = 0x12000500,
    /// Equivalent to DXGI_COLOR_SPACE_RGB_FULL_G2084_NONE_P2020
    hdr10 = 0x12002600,
    /// Equivalent to DXGI_COLOR_SPACE_YCBCR_FULL_G22_NONE_P709_X601
    jpeg = 0x220004c6,
    /// Equivalent to DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P601
    bt601_limited = 0x211018c6,
    /// Equivalent to DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P601
    bt601_full = 0x221018c6,
    /// Equivalent to DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P709
    bt709_limited = 0x21100421,
    /// Equivalent to DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P709
    bt709_full = 0x22100421,
    /// Equivalent to DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P2020
    bt2020_limited = 0x21102609,
    /// Equivalent to DXGI_COLOR_SPACE_YCBCR_FULL_G22_LEFT_P2020
    bt2020_full = 0x22102609,
    _,

    /// The default colorspace for RGB surfaces if no colorspace is specified
    pub const rgb_default: Colorspace = .srgb;
    /// The default colorspace for YUV surfaces if no colorspace is specified
    pub const yuv_default: Colorspace = .bt601_limited;

    /// A function for defining `Colorspace` values.
    pub fn define(
        color_type: ColorType,
        range_: ColorRange,
        primaries_: ColorPrimaries,
        transfer_: TransferCharacteristics,
        matrix_: MatrixCoefficients,
        chroma_: ChromaLocation,
    ) Colorspace {
        return @fromBackingInt(@intCast((@as(u32, @intCast(@backingInt(color_type))) << 28) |
            (@as(u32, @intCast(@backingInt(range_))) << 24) |
            (@as(u32, @intCast(@backingInt(chroma_))) << 20) |
            (@as(u32, @intCast(@backingInt(primaries_))) << 10) |
            (@as(u32, @intCast(@backingInt(transfer_))) << 5) |
            (@as(u32, @intCast(@backingInt(matrix_))) << 0)));
    }

    /// Retrieve the type of a colorspace.
    pub fn colorType(self: Colorspace) ColorType {
        return @fromBackingInt(@intCast(@as(u4, @truncate(@backingInt(self) >> 28))));
    }

    /// Retrieve the range of a colorspace.
    pub fn range(self: Colorspace) ColorRange {
        return @fromBackingInt(@intCast(@as(u4, @truncate(@backingInt(self) >> 24))));
    }

    /// Retrieve the chroma sample location of a colorspace.
    pub fn chroma(self: Colorspace) ChromaLocation {
        return @fromBackingInt(@intCast(@as(u4, @truncate(@backingInt(self) >> 20))));
    }

    /// Retrieve the primaries of a colorspace.
    pub fn primaries(self: Colorspace) ColorPrimaries {
        return @fromBackingInt(@intCast(@as(u5, @truncate(@backingInt(self) >> 10))));
    }

    /// Retrieve the transfer characteristics of a colorspace.
    pub fn transfer(self: Colorspace) TransferCharacteristics {
        return @fromBackingInt(@intCast(@as(u5, @truncate(@backingInt(self) >> 5))));
    }

    /// Retrieve the matrix coefficients of a colorspace.
    pub fn matrix(self: Colorspace) MatrixCoefficients {
        return @fromBackingInt(@intCast(@as(u5, @truncate(@backingInt(self)))));
    }

    /// Determine if this colorspace uses BT601 (or BT470BG) matrix coefficients.
    pub fn isMatrixBt601(self: Colorspace) bool {
        return self.matrix() == .bt601 or self.matrix() == .bt470bg;
    }

    /// Determine if this colorspace uses BT709 matrix coefficients.
    pub fn isMatrixBt709(self: Colorspace) bool {
        return self.matrix() == .bt709;
    }

    /// Determine if this colorspace uses BT2020_NCL matrix coefficients.
    pub fn isMatrixBt2020Ncl(self: Colorspace) bool {
        return self.matrix() == .bt2020_ncl;
    }

    /// Determine if this colorspace has a limited range.
    pub fn isLimitedRange(self: Colorspace) bool {
        return self.range() != .full;
    }

    /// Determine if this colorspace has a full range.
    pub fn isFullRange(self: Colorspace) bool {
        return self.range() == .full;
    }
};

/// A structure that represents a color as RGBA components.
///
/// The bits of this structure can be directly reinterpreted as an
/// integer-packed color which uses the `PixelFormat.rgba32` format
/// (`PixelFormat.abgr8888` on little-endian systems and
/// `PixelFormat.rgba8888` on big-endian systems).
pub const Color = extern struct {
    r: u8,
    g: u8,
    b: u8,
    a: u8,
};

/// The bits of this structure can be directly reinterpreted as a float-packed
/// color which uses the `PixelFormat.rgba128_float` format
pub const FColor = extern struct {
    r: f32,
    g: f32,
    b: f32,
    a: f32,
};

/// A set of indexed colors representing a palette.
pub const Palette = extern struct {
    /// number of elements in `colors`.
    ncolors: c_int,
    /// an array of colors, `ncolors` long.
    colors: ?[*]Color,
    /// internal use only, do not touch.
    version: u32,
    /// internal use only, do not touch.
    refcount: c_int,
};

/// Details about the format of a pixel.
pub const PixelFormatDetails = extern struct {
    format: PixelFormat,
    bits_per_pixel: u8,
    bytes_per_pixel: u8,
    padding: [2]u8 = @splat(0),
    Rmask: u32,
    Gmask: u32,
    Bmask: u32,
    Amask: u32,
    Rbits: u8,
    Gbits: u8,
    Bbits: u8,
    Abits: u8,
    Rshift: u8,
    Gshift: u8,
    Bshift: u8,
    Ashift: u8,
};

/// Get the human readable name of a pixel format.
pub fn getPixelFormatName(format: PixelFormat) [:0]const u8 {
    const str = SDL_GetPixelFormatName(format);
    return std.mem.span(str);
}
extern fn SDL_GetPixelFormatName(format: PixelFormat) [*:0]const u8;

/// Convert one of the enumerated pixel formats to a bpp value and RGBA masks.
pub fn getMasksForPixelFormat(format: PixelFormat) Error!struct { bpp: c_int, r_mask: u32, g_mask: u32, b_mask: u32, a_mask: u32 } {
    var bpp: c_int = undefined;
    var r_mask: u32 = undefined;
    var g_mask: u32 = undefined;
    var b_mask: u32 = undefined;
    var a_mask: u32 = undefined;
    if (!SDL_GetMasksForPixelFormat(format, &bpp, &r_mask, &g_mask, &b_mask, &a_mask)) return makeError();
    return .{ .bpp = bpp, .r_mask = r_mask, .g_mask = g_mask, .b_mask = b_mask, .a_mask = a_mask };
}
extern fn SDL_GetMasksForPixelFormat(format: PixelFormat, bpp: *c_int, Rmask: *u32, Gmask: *u32, Bmask: *u32, Amask: *u32) bool;

/// Convert a bpp value and RGBA masks to an enumerated pixel format.
///
/// This will return `PixelFormat.unknown` if the conversion wasn't
/// possible.
pub const getPixelFormatForMasks = SDL_GetPixelFormatForMasks;
extern fn SDL_GetPixelFormatForMasks(bpp: c_int, Rmask: u32, Gmask: u32, Bmask: u32, Amask: u32) PixelFormat;

/// Create a `PixelFormatDetails` structure corresponding to a pixel format.
///
/// Returned structure may come from a shared global cache (i.e. not newly
/// allocated), and hence should not be modified, especially the palette. Weird
/// errors such as `Blit combination not supported` may occur.
pub fn getPixelFormatDetails(format: PixelFormat) Error!*const PixelFormatDetails {
    return SDL_GetPixelFormatDetails(format) orelse makeError();
}
extern fn SDL_GetPixelFormatDetails(format: PixelFormat) ?*const PixelFormatDetails;

/// Create a palette structure with the specified number of color entries.
///
/// The palette entries are initialized to white.
pub fn createPalette(ncolors: c_int) Error!*Palette {
    return SDL_CreatePalette(ncolors) orelse makeError();
}
extern fn SDL_CreatePalette(ncolors: c_int) ?*Palette;

/// Set a range of colors in a palette.
pub fn setPaletteColors(palette: *Palette, colors: []const Color, firstcolor: c_int) Error!void {
    if (!SDL_SetPaletteColors(palette, colors.ptr, firstcolor, @intCast(colors.len))) return makeError();
}
extern fn SDL_SetPaletteColors(palette: *Palette, colors: [*]const Color, firstcolor: c_int, ncolors: c_int) bool;

/// Free a palette created with `createPalette`.
pub const destroyPalette = SDL_DestroyPalette;
extern fn SDL_DestroyPalette(palette: *Palette) void;

/// Map an RGB triple to an opaque pixel value for a given pixel format.
///
/// This function maps the RGB color value to the specified pixel format and
/// returns the pixel value best approximating the given RGB color value for
/// the given pixel format.
///
/// If the format has a palette (8-bit) the index of the closest matching color
/// in the palette will be returned.
///
/// If the specified pixel format has an alpha component it will be returned as
/// all 1 bits (fully opaque).
///
/// If the pixel format bpp (color depth) is less than 32-bpp then the unused
/// upper bits of the return value can safely be ignored (e.g., with a 16-bpp
/// format the return value can be assigned to a Uint16, and similarly a Uint8
/// for an 8-bpp format).
pub const mapRGB = SDL_MapRGB;
extern fn SDL_MapRGB(format: *const PixelFormatDetails, palette: ?*const Palette, r: u8, g: u8, b: u8) u32;

/// Map an RGBA quadruple to a pixel value for a given pixel format.
///
/// This function maps the RGBA color value to the specified pixel format and
/// returns the pixel value best approximating the given RGBA color value for
/// the given pixel format.
///
/// If the specified pixel format has no alpha component the alpha value will
/// be ignored (as it will be in formats with a palette).
///
/// If the format has a palette (8-bit) the index of the closest matching color
/// in the palette will be returned.
///
/// If the pixel format bpp (color depth) is less than 32-bpp then the unused
/// upper bits of the return value can safely be ignored (e.g., with a 16-bpp
/// format the return value can be assigned to a Uint16, and similarly a Uint8
/// for an 8-bpp format).
pub const mapRGBA = SDL_MapRGBA;
extern fn SDL_MapRGBA(format: *const PixelFormatDetails, palette: ?*const Palette, r: u8, g: u8, b: u8, a: u8) u32;

/// Get RGB values from a pixel in the specified format.
///
/// This function uses the entire 8-bit [0..255] range when converting color
/// components from pixel formats with less than 8-bits per RGB component
/// (e.g., a completely white pixel in 16-bit RGB565 format would return [0xff,
/// 0xff, 0xff] not [0xf8, 0xfc, 0xf8]).
pub const getRGB = SDL_GetRGB;
extern fn SDL_GetRGB(pixelvalue: u32, format: *const PixelFormatDetails, palette: ?*const Palette, r: ?*u8, g: ?*u8, b: ?*u8) void;

/// Get RGBA values from a pixel in the specified format.
///
/// This function uses the entire 8-bit [0..255] range when converting color
/// components from pixel formats with less than 8-bits per RGB component
/// (e.g., a completely white pixel in 16-bit RGB565 format would return [0xff,
/// 0xff, 0xff] not [0xf8, 0xfc, 0xf8]).
///
/// If the surface has no alpha component, the alpha will be returned as 0xff
/// (100% opaque).
pub const getRGBA = SDL_GetRGBA;
extern fn SDL_GetRGBA(pixelvalue: u32, format: *const PixelFormatDetails, palette: ?*const Palette, r: ?*u8, g: ?*u8, b: ?*u8, a: ?*u8) void;

test "PixelFormat and Colorspace helpers" {
    const expect = std.testing.expect;
    const expectEqual = std.testing.expectEqual;

    try expectEqual(PixelFormat.argb8888, PixelFormat.define(.packed32, PackedOrder.argb, .@"8888", 32, 4));
    try expectEqual(PixelFormat.nv12, PixelFormat.defineFourCC('N', 'V', '1', '2'));
    try expectEqual(32, PixelFormat.argb8888.bitsPerPixel());
    try expectEqual(4, PixelFormat.argb8888.bytesPerPixel());
    try expectEqual(2, PixelFormat.yuy2.bytesPerPixel());
    try expect(PixelFormat.argb8888.isAlpha());
    try expect(!PixelFormat.xrgb8888.isAlpha());
    try expect(PixelFormat.rgba128_float.isFloat());
    try expect(PixelFormat.argb2101010.is10Bit());
    try expect(PixelFormat.index8.isIndexed());
    try expect(PixelFormat.nv12.isFourCC());
    try expect(!PixelFormat.argb8888.isFourCC());

    try expectEqual(ColorType.rgb, Colorspace.srgb.colorType());
    try expectEqual(ColorRange.full, Colorspace.srgb.range());
    try expect(Colorspace.bt709_limited.isMatrixBt709());
    try expect(Colorspace.bt709_limited.isLimitedRange());
    try expectEqual(Colorspace.srgb, Colorspace.define(.rgb, .full, .bt709, .srgb, .identity, .none));
}
