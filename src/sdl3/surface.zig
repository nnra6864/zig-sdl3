//! Surface Creation and Simple Drawing (SDL_surface.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// The flags on a `Surface`.
///
/// These are generally considered read-only.
pub const SurfaceFlags = packed struct(u32) {
    /// Surface uses preallocated pixel memory
    preallocated: bool = false,
    /// Surface needs to be locked to access pixels
    lock_needed: bool = false,
    /// Surface is currently locked
    locked: bool = false,
    /// Surface uses pixel memory allocated with `aligned_alloc`
    simd_aligned: bool = false,
    __unused4: u28 = 0,
};

/// The scaling mode.
pub const ScaleMode = enum(c_int) {
    invalid = -1,
    /// nearest pixel sampling
    nearest,
    /// linear filtering
    linear,
    /// nearest pixel sampling with improved scaling for pixel art
    pixelart,
    _,
};

/// The flip mode.
pub const FlipMode = enum(c_int) {
    /// Do not flip
    none,
    /// flip horizontally
    horizontal,
    /// flip vertically
    vertical,
    /// flip horizontally and vertically (not a diagonal flip)
    horizontal_and_vertical = 3,
};

pub const Surface = extern struct {
    /// The flags of the surface, read-only
    flags: SurfaceFlags,
    /// The format of the surface, read-only
    format: sdl.PixelFormat,
    /// The width of the surface, read-only.
    w: c_int,
    /// The height of the surface, read-only.
    h: c_int,
    /// The distance in bytes between rows of pixels, read-only
    pitch: c_int,
    /// A pointer to the pixels of the surface, the pixels are writeable if non-null
    pixels: ?*anyopaque,
    /// Application reference count, used when freeing surface
    refcount: c_int,
    /// Reserved for internal use
    reserved: ?*anyopaque,

    pub const Flags = SurfaceFlags;

    pub const Properties = struct {
        pub const sdr_white_point_float = "SDL.surface.SDR_white_point";
        pub const hdr_headroom_float = "SDL.surface.HDR_headroom";
        pub const tonemap_operator_string = "SDL.surface.tonemap";
        pub const hotspot_x_number = "SDL.surface.hotspot.x";
        pub const hotspot_y_number = "SDL.surface.hotspot.y";
        pub const rotation_float = "SDL.surface.rotation";
    };
    pub const create = createSurface;
    pub const createFrom = createSurfaceFrom;
    pub const destroy = destroySurface;
    pub const getProperties = getSurfaceProperties;
    pub const setColorspace = setSurfaceColorspace;
    pub const getColorspace = getSurfaceColorspace;
    pub const createPalette = createSurfacePalette;
    pub const setPalette = setSurfacePalette;
    pub const getPalette = getSurfacePalette;
    pub const addAlternateImage = addSurfaceAlternateImage;
    pub const hasAlternateImages = surfaceHasAlternateImages;
    pub const getImages = getSurfaceImages;
    pub const removeAlternateImages = removeSurfaceAlternateImages;
    pub const lock = lockSurface;
    pub const unlock = unlockSurface;
    pub const setRLE = setSurfaceRLE;
    pub const hasRLE = surfaceHasRLE;
    pub const setColorKey = setSurfaceColorKey;
    pub const hasColorKey = surfaceHasColorKey;
    pub const getColorKey = getSurfaceColorKey;
    pub const setColorMod = setSurfaceColorMod;
    pub const getColorMod = getSurfaceColorMod;
    pub const setAlphaMod = setSurfaceAlphaMod;
    pub const getAlphaMod = getSurfaceAlphaMod;
    pub const setBlendMode = setSurfaceBlendMode;
    pub const getBlendMode = getSurfaceBlendMode;
    pub const setClipRect = setSurfaceClipRect;
    pub const getClipRect = getSurfaceClipRect;
    pub const flip = flipSurface;
    pub const rotate = rotateSurface;
    pub const duplicate = duplicateSurface;
    pub const scale = scaleSurface;
    pub const convert = convertSurface;
    pub const convertAndColorspace = convertSurfaceAndColorspace;
    pub const premultiplyAlpha = premultiplySurfaceAlpha;
    pub const clear = clearSurface;
    pub const fillRect = fillSurfaceRect;
    pub const fillRects = fillSurfaceRects;
    pub const blit = blitSurface;
    pub const blitUnchecked = blitSurfaceUnchecked;
    pub const blitScaled = blitSurfaceScaled;
    pub const blitUncheckedScaled = blitSurfaceUncheckedScaled;
    pub const stretch = stretchSurface;
    pub const blitTiled = blitSurfaceTiled;
    pub const blitTiledWithScale = blitSurfaceTiledWithScale;
    pub const blit9Grid = blitSurface9Grid;
    pub const mapRGB = mapSurfaceRGB;
    pub const mapRGBA = mapSurfaceRGBA;
    pub const readPixel = readSurfacePixel;
    pub const readPixelFloat = readSurfacePixelFloat;
    pub const writePixel = writeSurfacePixel;
    pub const writePixelFloat = writeSurfacePixelFloat;
};

/// Allocate a new surface with a specific pixel format.
///
/// The pixels of the new surface are initialized to zero.
pub fn createSurface(width: c_int, height: c_int, format: sdl.PixelFormat) Error!*Surface {
    return SDL_CreateSurface(width, height, format) orelse makeError();
}
extern fn SDL_CreateSurface(width: c_int, height: c_int, format: sdl.PixelFormat) ?*Surface;

/// Allocate a new surface with a specific pixel format and existing pixel
/// data.
///
/// No copy is made of the pixel data. Pixel data is not managed automatically;
/// you must free the surface before you free the pixel data.
///
/// Pitch is the offset in bytes from one row of pixels to the next, e.g.
/// `width*4` for `PixelFormat.rgba8888`.
///
/// You may pass null for pixels and 0 for pitch to create a surface that you
/// will fill in with valid values later.
pub fn createSurfaceFrom(width: c_int, height: c_int, format: sdl.PixelFormat, pixels: *anyopaque, pitch: c_int) Error!*Surface {
    return SDL_CreateSurfaceFrom(width, height, format, pixels, pitch) orelse makeError();
}
extern fn SDL_CreateSurfaceFrom(width: c_int, height: c_int, format: sdl.PixelFormat, pixels: *anyopaque, pitch: c_int) ?*Surface;

/// Free a surface.
///
/// It is safe to pass null to this function.
pub const destroySurface = SDL_DestroySurface;
extern fn SDL_DestroySurface(surface: *Surface) void;

/// Get the properties associated with a surface.
///
/// The following properties are understood by SDL:
///
/// - `Surface.Properties.sdr_white_point_float`: for HDR10 and floating point
///   surfaces, this defines the value of 100% diffuse white, with higher
///   values being displayed in the High Dynamic Range headroom. This defaults
///   to 203 for HDR10 surfaces and 1.0 for floating point surfaces.
/// - `Surface.Properties.hdr_headroom_float`: for HDR10 and floating point
///   surfaces, this defines the maximum dynamic range used by the content, in
///   terms of the SDR white point. This defaults to 0.0, which disables tone
///   mapping.
/// - `Surface.Properties.tonemap_operator_string`: the tone mapping operator
///   used when compressing from a surface with high dynamic range to another
///   with lower dynamic range. Currently this supports "chrome", which uses
///   the same tone mapping that Chrome uses for HDR content, the form "*=N",
///   where N is a floating point scale factor applied in linear space, and
///   "none", which disables tone mapping. This defaults to "chrome".
/// - `Surface.Properties.hotspot_x_number`: the hotspot pixel offset from the
///   left edge of the image, if this surface is being used as a cursor.
/// - `Surface.Properties.hotspot_y_number`: the hotspot pixel offset from the
///   top edge of the image, if this surface is being used as a cursor.
/// - `Surface.Properties.rotation_float`: the number of degrees a surface's data
///   is meant to be rotated clockwise to make the image right-side up. Default
///   0. This is used by the camera API, if a mobile device is oriented
///   differently than what its camera provides (i.e. - the camera always
///   provides portrait images but the phone is being held in landscape
///   orientation).
pub fn getSurfaceProperties(surface: *Surface) Error!sdl.PropertiesId {
    const result = SDL_GetSurfaceProperties(surface);
    if (@backingInt(result) == 0) return makeError();
    return result;
}
extern fn SDL_GetSurfaceProperties(surface: *Surface) sdl.PropertiesId;

/// Set the colorspace used by a surface.
///
/// Setting the colorspace doesn't change the pixels, only how they are
/// interpreted in color operations.
pub fn setSurfaceColorspace(surface: *Surface, colorspace: sdl.Colorspace) Error!void {
    if (!SDL_SetSurfaceColorspace(surface, colorspace)) return makeError();
}
extern fn SDL_SetSurfaceColorspace(surface: *Surface, colorspace: sdl.Colorspace) bool;

/// Get the colorspace used by a surface.
///
/// The colorspace defaults to `Colorspace.srgb_linear` for floating point
/// formats, `Colorspace.hdr10` for 10-bit formats, `Colorspace.srgb` for
/// other RGB surfaces and `Colorspace.bt709_full` for YUV textures.
pub const getSurfaceColorspace = SDL_GetSurfaceColorspace;
extern fn SDL_GetSurfaceColorspace(surface: *Surface) sdl.Colorspace;

/// Create a palette and associate it with a surface.
///
/// This function creates a palette compatible with the provided surface. The
/// palette is then returned for you to modify, and the surface will
/// automatically use the new palette in future operations. You do not need to
/// destroy the returned palette, it will be freed when the reference count
/// reaches 0, usually when the surface is destroyed.
///
/// Bitmap surfaces (with format `PixelFormat.index1lsb` or
/// `PixelFormat.index1msb`) will have the palette initialized with 0 as
/// white and 1 as black. Other surfaces will get a palette initialized with
/// white in every entry.
///
/// If this function is called for a surface that already has a palette, a new
/// palette will be created to replace it.
pub fn createSurfacePalette(surface: *Surface) Error!*sdl.Palette {
    return SDL_CreateSurfacePalette(surface) orelse makeError();
}
extern fn SDL_CreateSurfacePalette(surface: *Surface) ?*sdl.Palette;

/// Set the palette used by a surface.
///
/// Setting the palette keeps an internal reference to the palette, which can
/// be safely destroyed afterwards.
///
/// A single palette can be shared with many surfaces.
pub fn setSurfacePalette(surface: *Surface, palette: *sdl.Palette) Error!void {
    if (!SDL_SetSurfacePalette(surface, palette)) return makeError();
}
extern fn SDL_SetSurfacePalette(surface: *Surface, palette: *sdl.Palette) bool;

/// Get the palette used by a surface.
pub const getSurfacePalette = SDL_GetSurfacePalette;
extern fn SDL_GetSurfacePalette(surface: *Surface) ?*sdl.Palette;

/// Add an alternate version of a surface.
///
/// This function adds an alternate version of this surface, usually used for
/// content with high DPI representations like cursors or icons. The size,
/// format, and content do not need to match the original surface, and these
/// alternate versions will not be updated when the original surface changes.
///
/// This function adds a reference to the alternate version, so you should call
/// `destroySurface` on the image after this call.
pub fn addSurfaceAlternateImage(surface: *Surface, image: *Surface) Error!void {
    if (!SDL_AddSurfaceAlternateImage(surface, image)) return makeError();
}
extern fn SDL_AddSurfaceAlternateImage(surface: *Surface, image: *Surface) bool;

/// Return whether a surface has alternate versions available.
pub const surfaceHasAlternateImages = SDL_SurfaceHasAlternateImages;
extern fn SDL_SurfaceHasAlternateImages(surface: *Surface) bool;

/// Get an array including all versions of a surface.
///
/// This returns all versions of a surface, with the surface being queried as
/// the first element in the returned array.
///
/// Freeing the array of surfaces does not affect the surfaces in the array.
/// They are still referenced by the surface being queried and will be cleaned
/// up normally.
///
/// The returned value should be freed with `free` when it is no longer needed.
pub fn getSurfaceImages(surface: *Surface) Error![]*Surface {
    var count: c_int = undefined;
    const ptr = SDL_GetSurfaceImages(surface, &count) orelse return makeError();
    return ptr[0..@intCast(count)];
}
extern fn SDL_GetSurfaceImages(surface: *Surface, count: ?*c_int) ?[*]*Surface;

/// Remove all alternate versions of a surface.
///
/// This function removes a reference from all the alternative versions,
/// destroying them if this is the last reference to them.
pub const removeSurfaceAlternateImages = SDL_RemoveSurfaceAlternateImages;
extern fn SDL_RemoveSurfaceAlternateImages(surface: *Surface) void;

/// Set up a surface for directly accessing the pixels.
///
/// Between calls to `lockSurface` / `unlockSurface`, you can write to
/// and read from `surface->pixels`, using the pixel format stored in
/// `surface->format`. Once you are done accessing the surface, you should use
/// `unlockSurface` to release it.
///
/// Not all surfaces require locking. If `SDL_MUSTLOCK(surface)` evaluates to
/// 0, then you can read and write to the surface at any time, and the pixel
/// format of the surface will not change.
pub fn lockSurface(surface: *Surface) Error!void {
    if (!SDL_LockSurface(surface)) return makeError();
}
extern fn SDL_LockSurface(surface: *Surface) bool;

/// Release a surface after directly accessing the pixels.
pub const unlockSurface = SDL_UnlockSurface;
extern fn SDL_UnlockSurface(surface: *Surface) void;

/// Load a BMP or PNG image from a seekable SDL data stream.
///
/// The new surface should be freed with `destroySurface`. Not doing so
/// will result in a memory leak.
pub fn loadSurface_IO(src: *sdl.IOStream, closeio: bool) Error!*Surface {
    return SDL_LoadSurface_IO(src, closeio) orelse makeError();
}
extern fn SDL_LoadSurface_IO(src: *sdl.IOStream, closeio: bool) ?*Surface;

/// Load a BMP or PNG image from a file.
///
/// The new surface should be freed with `destroySurface`. Not doing so
/// will result in a memory leak.
pub fn loadSurface(file: [:0]const u8) Error!*Surface {
    return SDL_LoadSurface(file.ptr) orelse makeError();
}
extern fn SDL_LoadSurface(file: [*:0]const u8) ?*Surface;

/// Load a BMP image from a seekable SDL data stream.
///
/// The new surface should be freed with `destroySurface`. Not doing so
/// will result in a memory leak.
pub fn loadBMP_IO(src: *sdl.IOStream, closeio: bool) Error!*Surface {
    return SDL_LoadBMP_IO(src, closeio) orelse makeError();
}
extern fn SDL_LoadBMP_IO(src: *sdl.IOStream, closeio: bool) ?*Surface;

/// Load a BMP image from a file.
///
/// The new surface should be freed with `destroySurface`. Not doing so
/// will result in a memory leak.
pub fn loadBMP(file: [:0]const u8) Error!*Surface {
    return SDL_LoadBMP(file.ptr) orelse makeError();
}
extern fn SDL_LoadBMP(file: [*:0]const u8) ?*Surface;

/// Save a surface to a seekable SDL data stream in BMP format.
///
/// Surfaces with a 24-bit, 32-bit and paletted 8-bit format get saved in the
/// BMP directly. Other RGB formats with 8-bit or higher get converted to a
/// 24-bit surface or, if they have an alpha mask or a colorkey, to a 32-bit
/// surface before they are saved. YUV and paletted 1-bit and 4-bit formats are
/// not supported.
pub fn saveBMP_IO(surface: *Surface, dst: *sdl.IOStream, closeio: bool) Error!void {
    if (!SDL_SaveBMP_IO(surface, dst, closeio)) return makeError();
}
extern fn SDL_SaveBMP_IO(surface: *Surface, dst: *sdl.IOStream, closeio: bool) bool;

/// Save a surface to a file in BMP format.
///
/// Surfaces with a 24-bit, 32-bit and paletted 8-bit format get saved in the
/// BMP directly. Other RGB formats with 8-bit or higher get converted to a
/// 24-bit surface or, if they have an alpha mask or a colorkey, to a 32-bit
/// surface before they are saved. YUV and paletted 1-bit and 4-bit formats are
/// not supported.
pub fn saveBMP(surface: *Surface, file: [:0]const u8) Error!void {
    if (!SDL_SaveBMP(surface, file.ptr)) return makeError();
}
extern fn SDL_SaveBMP(surface: *Surface, file: [*:0]const u8) bool;

/// Load a PNG image from a seekable SDL data stream.
///
/// This is intended as a convenience function for loading images from trusted
/// sources. If you want to load arbitrary images you should use libpng or
/// another image loading library designed with security in mind.
///
/// The new surface should be freed with `destroySurface`. Not doing so
/// will result in a memory leak.
pub fn loadPNG_IO(src: *sdl.IOStream, closeio: bool) Error!*Surface {
    return SDL_LoadPNG_IO(src, closeio) orelse makeError();
}
extern fn SDL_LoadPNG_IO(src: *sdl.IOStream, closeio: bool) ?*Surface;

/// Load a PNG image from a file.
///
/// This is intended as a convenience function for loading images from trusted
/// sources. If you want to load arbitrary images you should use libpng or
/// another image loading library designed with security in mind.
///
/// The new surface should be freed with `destroySurface`. Not doing so
/// will result in a memory leak.
pub fn loadPNG(file: [:0]const u8) Error!*Surface {
    return SDL_LoadPNG(file.ptr) orelse makeError();
}
extern fn SDL_LoadPNG(file: [*:0]const u8) ?*Surface;

/// Save a surface to a seekable SDL data stream in PNG format.
pub fn savePNG_IO(surface: *Surface, dst: *sdl.IOStream, closeio: bool) Error!void {
    if (!SDL_SavePNG_IO(surface, dst, closeio)) return makeError();
}
extern fn SDL_SavePNG_IO(surface: *Surface, dst: *sdl.IOStream, closeio: bool) bool;

/// Save a surface to a file in PNG format.
pub fn savePNG(surface: *Surface, file: [:0]const u8) Error!void {
    if (!SDL_SavePNG(surface, file.ptr)) return makeError();
}
extern fn SDL_SavePNG(surface: *Surface, file: [*:0]const u8) bool;

/// Set the RLE acceleration hint for a surface.
///
/// If RLE is enabled, color key and alpha blending blits are much faster, but
/// the surface must be locked before directly accessing the pixels.
pub fn setSurfaceRLE(surface: *Surface, enabled: bool) Error!void {
    if (!SDL_SetSurfaceRLE(surface, enabled)) return makeError();
}
extern fn SDL_SetSurfaceRLE(surface: *Surface, enabled: bool) bool;

/// Returns whether the surface is RLE enabled.
///
/// It is safe to pass a null `surface` here; it will return false.
pub const surfaceHasRLE = SDL_SurfaceHasRLE;
extern fn SDL_SurfaceHasRLE(surface: *Surface) bool;

/// Set the color key (transparent pixel) in a surface.
///
/// The color key defines a pixel value that will be treated as transparent in
/// a blit. For example, one can use this to specify that cyan pixels should be
/// considered transparent, and therefore not rendered.
///
/// It is a pixel of the format used by the surface, as generated by
/// `mapRGB`.
pub fn setSurfaceColorKey(surface: *Surface, enabled: bool, key: u32) Error!void {
    if (!SDL_SetSurfaceColorKey(surface, enabled, key)) return makeError();
}
extern fn SDL_SetSurfaceColorKey(surface: *Surface, enabled: bool, key: u32) bool;

/// Returns whether the surface has a color key.
///
/// It is safe to pass a null `surface` here; it will return false.
pub const surfaceHasColorKey = SDL_SurfaceHasColorKey;
extern fn SDL_SurfaceHasColorKey(surface: *Surface) bool;

/// Get the color key (transparent pixel) for a surface.
///
/// The color key is a pixel of the format used by the surface, as generated by
/// `mapRGB`.
///
/// If the surface doesn't have color key enabled this function returns false.
pub fn getSurfaceColorKey(surface: *Surface) Error!u32 {
    var key: u32 = undefined;
    if (!SDL_GetSurfaceColorKey(surface, &key)) return makeError();
    return key;
}
extern fn SDL_GetSurfaceColorKey(surface: *Surface, key: *u32) bool;

/// Set an additional color value multiplied into blit operations.
///
/// When this surface is blitted, during the blit operation each source color
/// channel is modulated by the appropriate color value according to the
/// following formula:
///
/// `srcC = srcC * (color / 255)`
pub fn setSurfaceColorMod(surface: *Surface, r: u8, g: u8, b: u8) Error!void {
    if (!SDL_SetSurfaceColorMod(surface, r, g, b)) return makeError();
}
extern fn SDL_SetSurfaceColorMod(surface: *Surface, r: u8, g: u8, b: u8) bool;

/// Get the additional color value multiplied into blit operations.
pub fn getSurfaceColorMod(surface: *Surface, r: *u8, g: *u8, b: *u8) Error!void {
    if (!SDL_GetSurfaceColorMod(surface, r, g, b)) return makeError();
}
extern fn SDL_GetSurfaceColorMod(surface: *Surface, r: *u8, g: *u8, b: *u8) bool;

/// Set an additional alpha value used in blit operations.
///
/// When this surface is blitted, during the blit operation the source alpha
/// value is modulated by this alpha value according to the following formula:
///
/// `srcA = srcA * (alpha / 255)`
pub fn setSurfaceAlphaMod(surface: *Surface, alpha: u8) Error!void {
    if (!SDL_SetSurfaceAlphaMod(surface, alpha)) return makeError();
}
extern fn SDL_SetSurfaceAlphaMod(surface: *Surface, alpha: u8) bool;

/// Get the additional alpha value used in blit operations.
pub fn getSurfaceAlphaMod(surface: *Surface) Error!u8 {
    var alpha: u8 = undefined;
    if (!SDL_GetSurfaceAlphaMod(surface, &alpha)) return makeError();
    return alpha;
}
extern fn SDL_GetSurfaceAlphaMod(surface: *Surface, alpha: *u8) bool;

/// Set the blend mode used for blit operations.
///
/// To copy a surface to another surface (or texture) without blending with the
/// existing data, the blendmode of the SOURCE surface should be set to
/// `BlendMode.none`.
pub fn setSurfaceBlendMode(surface: *Surface, blendMode: sdl.BlendMode) Error!void {
    if (!SDL_SetSurfaceBlendMode(surface, blendMode)) return makeError();
}
extern fn SDL_SetSurfaceBlendMode(surface: *Surface, blendMode: sdl.BlendMode) bool;

/// Get the blend mode used for blit operations.
pub fn getSurfaceBlendMode(surface: *Surface) Error!sdl.BlendMode {
    var blendMode: sdl.BlendMode = undefined;
    if (!SDL_GetSurfaceBlendMode(surface, &blendMode)) return makeError();
    return blendMode;
}
extern fn SDL_GetSurfaceBlendMode(surface: *Surface, blendMode: *sdl.BlendMode) bool;

/// Set the clipping rectangle for a surface.
///
/// When `surface` is the destination of a blit, only the area within the clip
/// rectangle is drawn into.
///
/// Note that blits are automatically clipped to the edges of the source and
/// destination surfaces.
pub const setSurfaceClipRect = SDL_SetSurfaceClipRect;
extern fn SDL_SetSurfaceClipRect(surface: *Surface, rect: ?*const sdl.Rect) bool;

/// Get the clipping rectangle for a surface.
///
/// When `surface` is the destination of a blit, only the area within the clip
/// rectangle is drawn into.
pub fn getSurfaceClipRect(surface: *Surface) Error!sdl.Rect {
    var rect: sdl.Rect = undefined;
    if (!SDL_GetSurfaceClipRect(surface, &rect)) return makeError();
    return rect;
}
extern fn SDL_GetSurfaceClipRect(surface: *Surface, rect: *sdl.Rect) bool;

/// Flip a surface vertically or horizontally.
pub fn flipSurface(surface: *Surface, flip: FlipMode) Error!void {
    if (!SDL_FlipSurface(surface, flip)) return makeError();
}
extern fn SDL_FlipSurface(surface: *Surface, flip: FlipMode) bool;

/// Return a copy of a surface rotated clockwise a number of degrees.
///
/// The angle of rotation can be negative for counter-clockwise rotation.
///
/// When the rotation isn't a multiple of 90 degrees, the resulting surface is
/// larger than the original, with the background filled in with the colorkey,
/// if available, or RGBA 255/255/255/0 if not.
///
/// If `surface` has the `Surface.Properties.rotation_float` property set on it,
/// the new copy will have the adjusted value set: if the rotation property is
/// 90 and `angle` was 30, the new surface will have a property value of 60
/// (that is: to be upright vs gravity, this surface needs to rotate 60 more
/// degrees). However, note that further rotations on the new surface in this
/// example will produce unexpected results, since the image will have resized
/// and padded to accommodate the not-90 degree angle.
pub fn rotateSurface(surface: *Surface, angle: f32) Error!*Surface {
    return SDL_RotateSurface(surface, angle) orelse makeError();
}
extern fn SDL_RotateSurface(surface: *Surface, angle: f32) ?*Surface;

/// Creates a new surface identical to the existing surface.
///
/// If the original surface has alternate images, the new surface will have a
/// reference to them as well.
///
/// The returned surface should be freed with `destroySurface`.
pub fn duplicateSurface(surface: *Surface) Error!*Surface {
    return SDL_DuplicateSurface(surface) orelse makeError();
}
extern fn SDL_DuplicateSurface(surface: *Surface) ?*Surface;

/// Creates a new surface identical to the existing surface, scaled to the
/// desired size.
///
/// The returned surface should be freed with `destroySurface`.
pub fn scaleSurface(surface: *Surface, width: c_int, height: c_int, scaleMode: ScaleMode) Error!*Surface {
    return SDL_ScaleSurface(surface, width, height, scaleMode) orelse makeError();
}
extern fn SDL_ScaleSurface(surface: *Surface, width: c_int, height: c_int, scaleMode: ScaleMode) ?*Surface;

/// Copy an existing surface to a new surface of the specified format.
///
/// This function is used to optimize images for faster *repeat* blitting. This
/// is accomplished by converting the original and storing the result as a new
/// surface. The new, optimized surface can then be used as the source for
/// future blits, making them faster.
///
/// If you are converting to an indexed surface and want to map colors to a
/// palette, you can use `convertSurfaceAndColorspace` instead.
///
/// If the original surface has alternate images, the new surface will have a
/// reference to them as well.
pub fn convertSurface(surface: *Surface, format: sdl.PixelFormat) Error!*Surface {
    return SDL_ConvertSurface(surface, format) orelse makeError();
}
extern fn SDL_ConvertSurface(surface: *Surface, format: sdl.PixelFormat) ?*Surface;

/// Copy an existing surface to a new surface of the specified format and
/// colorspace.
///
/// This function converts an existing surface to a new format and colorspace
/// and returns the new surface. This will perform any pixel format and
/// colorspace conversion needed.
///
/// If the original surface has alternate images, the new surface will have a
/// reference to them as well.
pub fn convertSurfaceAndColorspace(surface: *Surface, format: sdl.PixelFormat, palette: ?*sdl.Palette, colorspace: sdl.Colorspace, props: sdl.PropertiesId) Error!*Surface {
    return SDL_ConvertSurfaceAndColorspace(surface, format, palette, colorspace, props) orelse makeError();
}
extern fn SDL_ConvertSurfaceAndColorspace(surface: *Surface, format: sdl.PixelFormat, palette: ?*sdl.Palette, colorspace: sdl.Colorspace, props: sdl.PropertiesId) ?*Surface;

/// Copy a block of pixels of one format to another format.
pub fn convertPixels(width: c_int, height: c_int, src_format: sdl.PixelFormat, src: *const anyopaque, src_pitch: c_int, dst_format: sdl.PixelFormat, dst: *anyopaque, dst_pitch: c_int) Error!void {
    if (!SDL_ConvertPixels(width, height, src_format, src, src_pitch, dst_format, dst, dst_pitch)) return makeError();
}
extern fn SDL_ConvertPixels(width: c_int, height: c_int, src_format: sdl.PixelFormat, src: *const anyopaque, src_pitch: c_int, dst_format: sdl.PixelFormat, dst: *anyopaque, dst_pitch: c_int) bool;

/// Copy a block of pixels of one format and colorspace to another format and
/// colorspace.
pub fn convertPixelsAndColorspace(width: c_int, height: c_int, src_format: sdl.PixelFormat, src_colorspace: sdl.Colorspace, src_properties: sdl.PropertiesId, src: *const anyopaque, src_pitch: c_int, dst_format: sdl.PixelFormat, dst_colorspace: sdl.Colorspace, dst_properties: sdl.PropertiesId, dst: *anyopaque, dst_pitch: c_int) Error!void {
    if (!SDL_ConvertPixelsAndColorspace(width, height, src_format, src_colorspace, src_properties, src, src_pitch, dst_format, dst_colorspace, dst_properties, dst, dst_pitch)) return makeError();
}
extern fn SDL_ConvertPixelsAndColorspace(width: c_int, height: c_int, src_format: sdl.PixelFormat, src_colorspace: sdl.Colorspace, src_properties: sdl.PropertiesId, src: *const anyopaque, src_pitch: c_int, dst_format: sdl.PixelFormat, dst_colorspace: sdl.Colorspace, dst_properties: sdl.PropertiesId, dst: *anyopaque, dst_pitch: c_int) bool;

/// Premultiply the alpha on a block of pixels.
///
/// This is safe to use with src == dst, but not for other overlapping areas.
pub fn premultiplyAlpha(width: c_int, height: c_int, src_format: sdl.PixelFormat, src: *const anyopaque, src_pitch: c_int, dst_format: sdl.PixelFormat, dst: *anyopaque, dst_pitch: c_int, linear: bool) Error!void {
    if (!SDL_PremultiplyAlpha(width, height, src_format, src, src_pitch, dst_format, dst, dst_pitch, linear)) return makeError();
}
extern fn SDL_PremultiplyAlpha(width: c_int, height: c_int, src_format: sdl.PixelFormat, src: *const anyopaque, src_pitch: c_int, dst_format: sdl.PixelFormat, dst: *anyopaque, dst_pitch: c_int, linear: bool) bool;

/// Premultiply the alpha in a surface.
///
/// This is safe to use with src == dst, but not for other overlapping areas.
pub fn premultiplySurfaceAlpha(surface: *Surface, linear: bool) Error!void {
    if (!SDL_PremultiplySurfaceAlpha(surface, linear)) return makeError();
}
extern fn SDL_PremultiplySurfaceAlpha(surface: *Surface, linear: bool) bool;

/// Clear a surface with a specific color, with floating point precision.
///
/// This function handles all surface formats, and ignores any clip rectangle.
///
/// If the surface is YUV, the color is assumed to be in the sRGB colorspace,
/// otherwise the color is assumed to be in the colorspace of the surface.
pub fn clearSurface(surface: *Surface, r: f32, g: f32, b: f32, a: f32) Error!void {
    if (!SDL_ClearSurface(surface, r, g, b, a)) return makeError();
}
extern fn SDL_ClearSurface(surface: *Surface, r: f32, g: f32, b: f32, a: f32) bool;

/// Perform a fast fill of a rectangle with a specific color.
///
/// `color` should be a pixel of the format used by the surface, and can be
/// generated by `mapRGB` or `mapRGBA`. If the color value contains an
/// alpha component then the destination is simply filled with that alpha
/// information, no blending takes place.
///
/// If there is a clip rectangle set on the destination (set via
/// `setSurfaceClipRect`), then this function will fill based on the
/// intersection of the clip rectangle and `rect`.
pub fn fillSurfaceRect(dst: *Surface, rect: ?*const sdl.Rect, color: u32) Error!void {
    if (!SDL_FillSurfaceRect(dst, rect, color)) return makeError();
}
extern fn SDL_FillSurfaceRect(dst: *Surface, rect: ?*const sdl.Rect, color: u32) bool;

/// Perform a fast fill of a set of rectangles with a specific color.
///
/// `color` should be a pixel of the format used by the surface, and can be
/// generated by `mapRGB` or `mapRGBA`. If the color value contains an
/// alpha component then the destination is simply filled with that alpha
/// information, no blending takes place.
///
/// If there is a clip rectangle set on the destination (set via
/// `setSurfaceClipRect`), then this function will fill based on the
/// intersection of the clip rectangle and `rect`.
pub fn fillSurfaceRects(dst: *Surface, rects: []const sdl.Rect, color: u32) Error!void {
    if (!SDL_FillSurfaceRects(dst, rects.ptr, @intCast(rects.len), color)) return makeError();
}
extern fn SDL_FillSurfaceRects(dst: *Surface, rects: [*]const sdl.Rect, count: c_int, color: u32) bool;

/// Performs a fast blit from the source surface to the destination surface
/// with clipping.
///
/// If either `srcrect` or `dstrect` are null, the entire surface (`src` or
/// `dst`) is copied while ensuring clipping to `dst->clip_rect`.
///
/// The blit function should not be called on a locked surface.
///
/// The blit semantics for surfaces with and without blending and colorkey are
/// defined as follows:
///
/// ```
///    RGBA->RGB:
///      Source surface blend mode set to SDL_BLENDMODE_BLEND:
///       alpha-blend (using the source alpha-channel and per-surface alpha)
///       SDL_SRCCOLORKEY ignored.
///     Source surface blend mode set to SDL_BLENDMODE_NONE:
///       copy RGB.
///       if SDL_SRCCOLORKEY set, only copy the pixels that do not match the
///       RGB values of the source color key, ignoring alpha in the
///       comparison.
///
///   RGB->RGBA:
///     Source surface blend mode set to SDL_BLENDMODE_BLEND:
///       alpha-blend (using the source per-surface alpha)
///     Source surface blend mode set to SDL_BLENDMODE_NONE:
///       copy RGB, set destination alpha to source per-surface alpha value.
///     both:
///       if SDL_SRCCOLORKEY set, only copy the pixels that do not match the
///       source color key.
///
///   RGBA->RGBA:
///     Source surface blend mode set to SDL_BLENDMODE_BLEND:
///       alpha-blend (using the source alpha-channel and per-surface alpha)
///       SDL_SRCCOLORKEY ignored.
///     Source surface blend mode set to SDL_BLENDMODE_NONE:
///       copy all of RGBA to the destination.
///       if SDL_SRCCOLORKEY set, only copy the pixels that do not match the
///       RGB values of the source color key, ignoring alpha in the
///       comparison.
///
///   RGB->RGB:
///     Source surface blend mode set to SDL_BLENDMODE_BLEND:
///       alpha-blend (using the source per-surface alpha)
///     Source surface blend mode set to SDL_BLENDMODE_NONE:
///       copy RGB.
///     both:
///       if SDL_SRCCOLORKEY set, only copy the pixels that do not match the
///       source color key.
/// ```
pub fn blitSurface(src: *Surface, srcrect: ?*const sdl.Rect, dst: *Surface, dstrect: ?*const sdl.Rect) Error!void {
    if (!SDL_BlitSurface(src, srcrect, dst, dstrect)) return makeError();
}
extern fn SDL_BlitSurface(src: *Surface, srcrect: ?*const sdl.Rect, dst: *Surface, dstrect: ?*const sdl.Rect) bool;

/// Perform low-level surface blitting only.
///
/// This is a semi-private blit function and it performs low-level surface
/// blitting, assuming the input rectangles have already been clipped.
pub fn blitSurfaceUnchecked(src: *Surface, srcrect: ?*const sdl.Rect, dst: *Surface, dstrect: ?*const sdl.Rect) Error!void {
    if (!SDL_BlitSurfaceUnchecked(src, srcrect, dst, dstrect)) return makeError();
}
extern fn SDL_BlitSurfaceUnchecked(src: *Surface, srcrect: ?*const sdl.Rect, dst: *Surface, dstrect: ?*const sdl.Rect) bool;

/// Perform a scaled blit to a destination surface, which may be of a different
/// format.
pub fn blitSurfaceScaled(src: *Surface, srcrect: ?*const sdl.Rect, dst: *Surface, dstrect: ?*const sdl.Rect, scaleMode: ScaleMode) Error!void {
    if (!SDL_BlitSurfaceScaled(src, srcrect, dst, dstrect, scaleMode)) return makeError();
}
extern fn SDL_BlitSurfaceScaled(src: *Surface, srcrect: ?*const sdl.Rect, dst: *Surface, dstrect: ?*const sdl.Rect, scaleMode: ScaleMode) bool;

/// Perform low-level surface scaled blitting only.
///
/// This is a semi-private function and it performs low-level surface blitting,
/// assuming the input rectangles have already been clipped.
pub fn blitSurfaceUncheckedScaled(src: *Surface, srcrect: ?*const sdl.Rect, dst: *Surface, dstrect: ?*const sdl.Rect, scaleMode: ScaleMode) Error!void {
    if (!SDL_BlitSurfaceUncheckedScaled(src, srcrect, dst, dstrect, scaleMode)) return makeError();
}
extern fn SDL_BlitSurfaceUncheckedScaled(src: *Surface, srcrect: ?*const sdl.Rect, dst: *Surface, dstrect: ?*const sdl.Rect, scaleMode: ScaleMode) bool;

/// Perform a stretched pixel copy from one surface to another.
pub fn stretchSurface(src: *Surface, srcrect: ?*const sdl.Rect, dst: *Surface, dstrect: ?*const sdl.Rect, scaleMode: ScaleMode) Error!void {
    if (!SDL_StretchSurface(src, srcrect, dst, dstrect, scaleMode)) return makeError();
}
extern fn SDL_StretchSurface(src: *Surface, srcrect: ?*const sdl.Rect, dst: *Surface, dstrect: ?*const sdl.Rect, scaleMode: ScaleMode) bool;

/// Perform a tiled blit to a destination surface, which may be of a different
/// format.
///
/// The pixels in `srcrect` will be repeated as many times as needed to
/// completely fill `dstrect`.
pub fn blitSurfaceTiled(src: *Surface, srcrect: ?*const sdl.Rect, dst: *Surface, dstrect: ?*const sdl.Rect) Error!void {
    if (!SDL_BlitSurfaceTiled(src, srcrect, dst, dstrect)) return makeError();
}
extern fn SDL_BlitSurfaceTiled(src: *Surface, srcrect: ?*const sdl.Rect, dst: *Surface, dstrect: ?*const sdl.Rect) bool;

/// Perform a scaled and tiled blit to a destination surface, which may be of a
/// different format.
///
/// The pixels in `srcrect` will be scaled and repeated as many times as needed
/// to completely fill `dstrect`.
pub fn blitSurfaceTiledWithScale(src: *Surface, srcrect: ?*const sdl.Rect, scale: f32, scaleMode: ScaleMode, dst: *Surface, dstrect: ?*const sdl.Rect) Error!void {
    if (!SDL_BlitSurfaceTiledWithScale(src, srcrect, scale, scaleMode, dst, dstrect)) return makeError();
}
extern fn SDL_BlitSurfaceTiledWithScale(src: *Surface, srcrect: ?*const sdl.Rect, scale: f32, scaleMode: ScaleMode, dst: *Surface, dstrect: ?*const sdl.Rect) bool;

/// Perform a scaled blit using the 9-grid algorithm to a destination surface,
/// which may be of a different format.
///
/// The pixels in the source surface are split into a 3x3 grid, using the
/// different corner sizes for each corner, and the sides and center making up
/// the remaining pixels. The corners are then scaled using `scale` and fit
/// into the corners of the destination rectangle. The sides and center are
/// then stretched into place to cover the remaining destination rectangle.
pub fn blitSurface9Grid(src: *Surface, srcrect: ?*const sdl.Rect, left_width: c_int, right_width: c_int, top_height: c_int, bottom_height: c_int, scale: f32, scaleMode: ScaleMode, dst: *Surface, dstrect: ?*const sdl.Rect) Error!void {
    if (!SDL_BlitSurface9Grid(src, srcrect, left_width, right_width, top_height, bottom_height, scale, scaleMode, dst, dstrect)) return makeError();
}
extern fn SDL_BlitSurface9Grid(src: *Surface, srcrect: ?*const sdl.Rect, left_width: c_int, right_width: c_int, top_height: c_int, bottom_height: c_int, scale: f32, scaleMode: ScaleMode, dst: *Surface, dstrect: ?*const sdl.Rect) bool;

/// Map an RGB triple to an opaque pixel value for a surface.
///
/// This function maps the RGB color value to the specified pixel format and
/// returns the pixel value best approximating the given RGB color value for
/// the given pixel format.
///
/// If the surface has a palette, the index of the closest matching color in
/// the palette will be returned.
///
/// If the surface pixel format has an alpha component it will be returned as
/// all 1 bits (fully opaque).
///
/// If the pixel format bpp (color depth) is less than 32-bpp then the unused
/// upper bits of the return value can safely be ignored (e.g., with a 16-bpp
/// format the return value can be assigned to a Uint16, and similarly a Uint8
/// for an 8-bpp format).
pub const mapSurfaceRGB = SDL_MapSurfaceRGB;
extern fn SDL_MapSurfaceRGB(surface: *Surface, r: u8, g: u8, b: u8) u32;

/// Map an RGBA quadruple to a pixel value for a surface.
///
/// This function maps the RGBA color value to the specified pixel format and
/// returns the pixel value best approximating the given RGBA color value for
/// the given pixel format.
///
/// If the surface pixel format has no alpha component the alpha value will be
/// ignored (as it will be in formats with a palette).
///
/// If the surface has a palette, the index of the closest matching color in
/// the palette will be returned.
///
/// If the pixel format bpp (color depth) is less than 32-bpp then the unused
/// upper bits of the return value can safely be ignored (e.g., with a 16-bpp
/// format the return value can be assigned to a Uint16, and similarly a Uint8
/// for an 8-bpp format).
pub const mapSurfaceRGBA = SDL_MapSurfaceRGBA;
extern fn SDL_MapSurfaceRGBA(surface: *Surface, r: u8, g: u8, b: u8, a: u8) u32;

/// Retrieves a single pixel from a surface.
///
/// This function prioritizes correctness over speed: it is suitable for unit
/// tests, but is not intended for use in a game engine.
///
/// Like `getRGBA`, this uses the entire 0..255 range when converting color
/// components from pixel formats with less than 8 bits per RGB component.
pub fn readSurfacePixel(surface: *Surface, x: c_int, y: c_int) Error!sdl.Color {
    var c: sdl.Color = undefined;
    if (!SDL_ReadSurfacePixel(surface, x, y, &c.r, &c.g, &c.b, &c.a)) return makeError();
    return c;
}
extern fn SDL_ReadSurfacePixel(surface: *Surface, x: c_int, y: c_int, r: ?*u8, g: ?*u8, b: ?*u8, a: ?*u8) bool;

/// Retrieves a single pixel from a surface.
///
/// This function prioritizes correctness over speed: it is suitable for unit
/// tests, but is not intended for use in a game engine.
pub fn readSurfacePixelFloat(surface: *Surface, x: c_int, y: c_int) Error!sdl.FColor {
    var c: sdl.FColor = undefined;
    if (!SDL_ReadSurfacePixelFloat(surface, x, y, &c.r, &c.g, &c.b, &c.a)) return makeError();
    return c;
}
extern fn SDL_ReadSurfacePixelFloat(surface: *Surface, x: c_int, y: c_int, r: ?*f32, g: ?*f32, b: ?*f32, a: ?*f32) bool;

/// Writes a single pixel to a surface.
///
/// This function prioritizes correctness over speed: it is suitable for unit
/// tests, but is not intended for use in a game engine.
///
/// Like `mapRGBA`, this uses the entire 0..255 range when converting color
/// components from pixel formats with less than 8 bits per RGB component.
pub fn writeSurfacePixel(surface: *Surface, x: c_int, y: c_int, r: u8, g: u8, b: u8, a: u8) Error!void {
    if (!SDL_WriteSurfacePixel(surface, x, y, r, g, b, a)) return makeError();
}
extern fn SDL_WriteSurfacePixel(surface: *Surface, x: c_int, y: c_int, r: u8, g: u8, b: u8, a: u8) bool;

/// Writes a single pixel to a surface.
///
/// This function prioritizes correctness over speed: it is suitable for unit
/// tests, but is not intended for use in a game engine.
pub fn writeSurfacePixelFloat(surface: *Surface, x: c_int, y: c_int, r: f32, g: f32, b: f32, a: f32) Error!void {
    if (!SDL_WriteSurfacePixelFloat(surface, x, y, r, g, b, a)) return makeError();
}
extern fn SDL_WriteSurfacePixelFloat(surface: *Surface, x: c_int, y: c_int, r: f32, g: f32, b: f32, a: f32) bool;
