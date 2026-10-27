//! Audio Device Management, Playing and Recording (SDL_audio.h)

const std = @import("std");
const assert = std.debug.assert;

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// Mask of bits in an `AudioFormat` that contains the format bit size.
///
/// Generally one should use `AudioFormat.bitSize` instead of this macro directly.
pub const audio_mask_bitsize: u32 = 0xFF;

/// Mask of bits in an `AudioFormat` that contain the floating point flag.
///
/// Generally one should use `AudioFormat.isFloat` instead of this macro directly.
pub const audio_mask_float: u32 = 1 << 8;

/// Mask of bits in an `AudioFormat` that contain the bigendian flag.
///
/// Generally one should use `AudioFormat.isBigEndian` or `AudioFormat.isLittleEndian`
/// instead of this macro directly.
pub const audio_mask_big_endian: u32 = 1 << 12;

/// Mask of bits in an `AudioFormat` that contain the signed data flag.
///
/// Generally one should use `AudioFormat.isSigned` instead of this macro directly.
pub const audio_mask_signed: u32 = 1 << 15;

/// Audio format.
pub const AudioFormat = enum(u32) {
    /// Unspecified audio format
    unknown = 0x0000,
    /// Unsigned 8-bit samples
    u8 = 0x0008,
    /// Signed 8-bit samples
    s8 = 0x8008,
    /// Signed 16-bit samples
    s16le = 0x8010,
    /// As above, but big-endian byte order
    s16be = 0x9010,
    /// 32-bit integer samples
    s32le = 0x8020,
    /// As above, but big-endian byte order
    s32be = 0x9020,
    /// 32-bit floating point samples
    f32le = 0x8120,
    /// As above, but big-endian byte order
    f32be = 0x9120,
    _,

    const little_endian = @import("builtin").cpu.arch.endian() == .little;

    /// 16-bit integer samples in native byte order
    pub const s16: AudioFormat = if (little_endian) .s16le else .s16be;
    /// 32-bit integer samples in native byte order
    pub const s32: AudioFormat = if (little_endian) .s32le else .s32be;
    /// 32-bit floating point samples in native byte order
    pub const @"f32": AudioFormat = if (little_endian) .f32le else .f32be;

    /// Define an `AudioFormat` value.
    ///
    /// SDL does not support custom audio formats, so this function is not of
    /// much use externally, but it can be illustrative as to what the various
    /// bits of an `AudioFormat` value mean.
    pub fn define(signed: bool, bigendian: bool, float: bool, size: u8) AudioFormat {
        return @fromBackingInt(@intCast((@as(u32, @intFromBool(signed)) << 15) |
            (@as(u32, @intFromBool(bigendian)) << 12) |
            (@as(u32, @intFromBool(float)) << 8) |
            (size & audio_mask_bitsize)));
    }

    /// Retrieve the size, in bits, from an `AudioFormat`.
    pub fn bitSize(self: AudioFormat) u16 {
        return @intCast(@backingInt(self) & audio_mask_bitsize);
    }

    /// Retrieve the size, in bytes, from an `AudioFormat`.
    pub fn byteSize(self: AudioFormat) u16 {
        return self.bitSize() / 8;
    }

    /// Determine if an `AudioFormat` represents floating point data.
    pub fn isFloat(self: AudioFormat) bool {
        return @backingInt(self) & audio_mask_float != 0;
    }

    /// Determine if an `AudioFormat` represents bigendian data.
    pub fn isBigEndian(self: AudioFormat) bool {
        return @backingInt(self) & audio_mask_big_endian != 0;
    }

    /// Determine if an `AudioFormat` represents littleendian data.
    pub fn isLittleEndian(self: AudioFormat) bool {
        return !self.isBigEndian();
    }

    /// Determine if an `AudioFormat` represents signed data.
    pub fn isSigned(self: AudioFormat) bool {
        return @backingInt(self) & audio_mask_signed != 0;
    }

    /// Determine if an `AudioFormat` represents integer data.
    pub fn isInt(self: AudioFormat) bool {
        return !self.isFloat();
    }

    /// Determine if an `AudioFormat` represents unsigned data.
    pub fn isUnsigned(self: AudioFormat) bool {
        return !self.isSigned();
    }
};

/// SDL Audio Device instance IDs.
///
/// Zero is used to signify an invalid/null device.
pub const AudioDeviceId = enum(u32) {
    invalid = 0,
    /// A value used to request a default recording audio device.
    default_recording = 0xFFFFFFFE,
    /// A value used to request a default playback audio device.
    default_playback = 0xFFFFFFFF,
    _,
};

/// A value used to request a default playback audio device.
///
/// Several functions that require an `AudioDeviceId` will accept this value
/// to signify the app just wants the system to choose a default device instead
/// of the app providing a specific one.
pub const audio_device_default_playback: AudioDeviceId = .default_playback;

/// A value used to request a default recording audio device.
///
/// Several functions that require an `AudioDeviceId` will accept this value
/// to signify the app just wants the system to choose a default device instead
/// of the app providing a specific one.
pub const audio_device_default_recording: AudioDeviceId = .default_recording;

/// Format specifier for audio data.
pub const AudioSpec = extern struct {
    /// Audio data format
    format: AudioFormat,
    /// Number of channels: 1 mono, 2 stereo, etc
    channels: c_int,
    /// sample rate: sample frames per second
    freq: c_int,

    /// Calculate the size of each audio frame (in bytes) from an `AudioSpec`.
    ///
    /// This reports on the size of an audio sample frame: stereo Sint16 data
    /// (2 channels of 2 bytes each) would be 4 bytes per frame, for example.
    pub fn frameSize(self: AudioSpec) c_int {
        return self.format.byteSize() * self.channels;
    }
};

/// The opaque handle that represents an audio stream.
///
/// `AudioStream` is an audio conversion interface.
///
/// - It can handle resampling data in chunks without generating artifacts,
///   when it doesn't have the complete buffer available.
/// - It can handle incoming data in any variable size.
/// - It can handle input/output format changes on the fly.
/// - It can remap audio channels between inputs and outputs.
/// - You push data as you have it, and pull it when you need it; the
///   stream will buffer data as needed.
/// - It can also function as a basic audio data queue even if you just have
///   sound that needs to pass from one place to another.
/// - You can hook callbacks up to them when more data is added or requested,
///   to manage data on-the-fly.
///
/// Audio streams are the core of the SDL3 audio interface. You create one or
/// more of them, bind them to an opened audio device, and feed data to them
/// (or for recording, consume data from them).
pub const AudioStream = opaque {
    pub const Properties = struct {
        pub const auto_cleanup_boolean = "SDL.audiostream.auto_cleanup";
    };
    pub const unbinds = unbindAudioStreams;
    pub const unbind = unbindAudioStream;
    pub const getDevice = getAudioStreamDevice;
    pub const create = createAudioStream;
    pub const getProperties = getAudioStreamProperties;
    pub const getFormat = getAudioStreamFormat;
    pub const setFormat = setAudioStreamFormat;
    pub const getFrequencyRatio = getAudioStreamFrequencyRatio;
    pub const setFrequencyRatio = setAudioStreamFrequencyRatio;
    pub const getGain = getAudioStreamGain;
    pub const setGain = setAudioStreamGain;
    pub const getInputChannelMap = getAudioStreamInputChannelMap;
    pub const getOutputChannelMap = getAudioStreamOutputChannelMap;
    pub const setInputChannelMap = setAudioStreamInputChannelMap;
    pub const setOutputChannelMap = setAudioStreamOutputChannelMap;
    pub const putData = putAudioStreamData;
    pub const putDataNoCopy = putAudioStreamDataNoCopy;
    pub const putPlanarData = putAudioStreamPlanarData;
    pub const getData = getAudioStreamData;
    pub const getAvailable = getAudioStreamAvailable;
    pub const getQueued = getAudioStreamQueued;
    pub const flush = flushAudioStream;
    pub const clear = clearAudioStream;
    pub const pauseDevice = pauseAudioStreamDevice;
    pub const resumeDevice = resumeAudioStreamDevice;
    pub const devicePaused = audioStreamDevicePaused;
    pub const lock = lockAudioStream;
    pub const unlock = unlockAudioStream;
    pub const setGetCallback = setAudioStreamGetCallback;
    pub const setPutCallback = setAudioStreamPutCallback;
    pub const destroy = destroyAudioStream;
};

/// Use this function to get the number of built-in audio drivers.
///
/// This function returns a hardcoded number. This never returns a negative
/// value; if there are no drivers compiled into this build of SDL, this
/// function returns zero. The presence of a driver in this list does not mean
/// it will function, it just means SDL is capable of interacting with that
/// interface. For example, a build of SDL might have esound support, but if
/// there's no esound server available, SDL's esound driver would fail if used.
///
/// By default, SDL tries all drivers, in its preferred order, until one is
/// found to be usable.
pub const getNumAudioDrivers = SDL_GetNumAudioDrivers;
extern fn SDL_GetNumAudioDrivers() c_int;

/// Use this function to get the name of a built in audio driver.
///
/// The list of audio drivers is given in the order that they are normally
/// initialized by default; the drivers that seem more reasonable to choose
/// first (as far as the SDL developers believe) are earlier in the list.
///
/// The names of drivers are all simple, low-ASCII identifiers, like "alsa",
/// "coreaudio" or "wasapi". These never have Unicode characters, and are not
/// meant to be proper names.
pub fn getAudioDriver(index: c_int) ?[:0]const u8 {
    const str = SDL_GetAudioDriver(index) orelse return null;
    return std.mem.span(str);
}
extern fn SDL_GetAudioDriver(index: c_int) ?[*:0]const u8;

/// Get the name of the current audio driver.
///
/// The names of drivers are all simple, low-ASCII identifiers, like "alsa",
/// "coreaudio" or "wasapi". These never have Unicode characters, and are not
/// meant to be proper names.
pub fn getCurrentAudioDriver() ?[:0]const u8 {
    const str = SDL_GetCurrentAudioDriver() orelse return null;
    return std.mem.span(str);
}
extern fn SDL_GetCurrentAudioDriver() ?[*:0]const u8;

/// Get a list of currently-connected audio playback devices.
///
/// This returns of list of available devices that play sound, perhaps to
/// speakers or headphones ("playback" devices). If you want devices that
/// record audio, like a microphone ("recording" devices), use
/// `getAudioRecordingDevices` instead.
///
/// This only returns a list of physical devices; it will not have any device
/// IDs returned by `openAudioDevice`.
///
/// If this function returns null, to signify an error, `*count` will be set to
/// zero.
///
/// The returned value should be freed with `free` when it is no longer needed.
pub fn getAudioPlaybackDevices() Error![]AudioDeviceId {
    var count: c_int = undefined;
    const ptr = SDL_GetAudioPlaybackDevices(&count) orelse return makeError();
    return ptr[0..@intCast(count)];
}
extern fn SDL_GetAudioPlaybackDevices(count: ?*c_int) ?[*]AudioDeviceId;

/// Get a list of currently-connected audio recording devices.
///
/// This returns of list of available devices that record audio, like a
/// microphone ("recording" devices). If you want devices that play sound,
/// perhaps to speakers or headphones ("playback" devices), use
/// `getAudioPlaybackDevices` instead.
///
/// This only returns a list of physical devices; it will not have any device
/// IDs returned by `openAudioDevice`.
///
/// If this function returns null, to signify an error, `*count` will be set to
/// zero.
///
/// The returned value should be freed with `free` when it is no longer needed.
pub fn getAudioRecordingDevices() Error![]AudioDeviceId {
    var count: c_int = undefined;
    const ptr = SDL_GetAudioRecordingDevices(&count) orelse return makeError();
    return ptr[0..@intCast(count)];
}
extern fn SDL_GetAudioRecordingDevices(count: ?*c_int) ?[*]AudioDeviceId;

/// Get the human-readable name of a specific audio device.
///
/// **WARNING**: this function will work with `audio_device_default_playback`
/// and `audio_device_default_recording`, returning the current default
/// physical devices' names. However, as the default device may change at any
/// time, it is likely better to show a generic name to the user, like "System
/// default audio device" or perhaps "default [currently %s]". Do not store
/// this name to disk to reidentify the device in a later run of the program,
/// as the default might change in general, and the string will be the name of
/// a specific device and not the abstract system default.
pub fn getAudioDeviceName(devid: AudioDeviceId) Error![:0]const u8 {
    const str = SDL_GetAudioDeviceName(devid) orelse return makeError();
    return std.mem.span(str);
}
extern fn SDL_GetAudioDeviceName(devid: AudioDeviceId) ?[*:0]const u8;

/// Get the current audio format of a specific audio device.
///
/// For an opened device, this will report the format the device is currently
/// using. If the device isn't yet opened, this will report the device's
/// preferred format (or a reasonable default if this can't be determined).
///
/// You may also specify `audio_device_default_playback` or
/// `audio_device_default_recording` here, which is useful for getting a
/// reasonable recommendation before opening the system-recommended default
/// device.
///
/// You can also use this to request the current device buffer size. This is
/// specified in sample frames and represents the amount of data SDL will feed
/// to the physical hardware in each chunk. This can be converted to
/// milliseconds of audio with the following equation:
///
/// `ms = (int) ((((Sint64) frames) * 1000) / spec.freq);`
///
/// Buffer size is only important if you need low-level control over the audio
/// playback timing. Most apps do not need this.
pub fn getAudioDeviceFormat(devid: AudioDeviceId) Error!struct { spec: AudioSpec, sample_frames: c_int } {
    var spec: AudioSpec = undefined;
    var sample_frames: c_int = undefined;
    if (!SDL_GetAudioDeviceFormat(devid, &spec, &sample_frames)) return makeError();
    return .{ .spec = spec, .sample_frames = sample_frames };
}
extern fn SDL_GetAudioDeviceFormat(devid: AudioDeviceId, spec: *AudioSpec, sample_frames: ?*c_int) bool;

/// Get the current channel map of an audio device.
///
/// Channel maps are optional; most things do not need them, instead passing
/// data in the [order that SDL expects](CategoryAudio#channel-layouts).
///
/// Audio devices usually have no remapping applied. This is represented by
/// returning null, and does not signify an error.
///
/// Returns null if no remapping is necessary. The returned slice should be
/// freed with `free` when it is no longer needed.
pub fn getAudioDeviceChannelMap(devid: AudioDeviceId) ?[]c_int {
    var count: c_int = undefined;
    const ptr = SDL_GetAudioDeviceChannelMap(devid, &count) orelse return null;
    return ptr[0..@intCast(count)];
}
extern fn SDL_GetAudioDeviceChannelMap(devid: AudioDeviceId, count: ?*c_int) ?[*]c_int;

/// Open a specific audio device.
///
/// You can open both playback and recording devices through this function.
/// Playback devices will take data from bound audio streams, mix it, and send
/// it to the hardware. Recording devices will feed any bound audio streams
/// with a copy of any incoming data.
///
/// An opened audio device starts out with no audio streams bound. To start
/// audio playing, bind a stream and supply audio data to it. Unlike SDL2,
/// there is no audio callback; you only bind audio streams and make sure they
/// have data flowing into them (however, you can simulate SDL2's semantics
/// fairly closely by using `openAudioDeviceStream` instead of this
/// function).
///
/// If you don't care about opening a specific device, pass a `devid` of either
/// `audio_device_default_playback` or
/// `audio_device_default_recording`. In this case, SDL will try to pick
/// the most reasonable default, and may also switch between physical devices
/// seamlessly later, if the most reasonable default changes during the
/// lifetime of this opened device (user changed the default in the OS's system
/// preferences, the default got unplugged so the system jumped to a new
/// default, the user plugged in headphones on a mobile device, etc). Unless
/// you have a good reason to choose a specific device, this is probably what
/// you want.
///
/// You may request a specific format for the audio device, but there is no
/// promise the device will honor that request for several reasons. As such,
/// it's only meant to be a hint as to what data your app will provide. Audio
/// streams will accept data in whatever format you specify and manage
/// conversion for you as appropriate. `getAudioDeviceFormat` can tell you
/// the preferred format for the device before opening and the actual format
/// the device is using after opening.
///
/// It's legal to open the same device ID more than once; each successful open
/// will generate a new logical `AudioDeviceId` that is managed separately
/// from others on the same physical device. This allows libraries to open a
/// device separately from the main app and bind its own streams without
/// conflicting.
///
/// It is also legal to open a device ID returned by a previous call to this
/// function; doing so just creates another logical device on the same physical
/// device. This may be useful for making logical groupings of audio streams.
///
/// This function returns the opened device ID on success. This is a new,
/// unique `AudioDeviceId` that represents a logical device.
///
/// Some backends might offer arbitrary devices (for example, a networked audio
/// protocol that can connect to an arbitrary server). For these, as a change
/// from SDL2, you should open a default device ID and use an SDL hint to
/// specify the target if you care, or otherwise let the backend figure out a
/// reasonable default. Most backends don't offer anything like this, and often
/// this would be an end user setting an environment variable for their custom
/// need, and not something an application should specifically manage.
///
/// When done with an audio device, possibly at the end of the app's life, one
/// should call `closeAudioDevice` on the returned device id.
pub fn openAudioDevice(devid: AudioDeviceId, spec: ?*const AudioSpec) Error!AudioDeviceId {
    const result = SDL_OpenAudioDevice(devid, spec);
    if (@backingInt(result) == 0) return makeError();
    return result;
}
extern fn SDL_OpenAudioDevice(devid: AudioDeviceId, spec: ?*const AudioSpec) AudioDeviceId;

/// Determine if an audio device is physical (instead of logical).
///
/// An `AudioDeviceId` that represents physical hardware is a physical
/// device; there is one for each piece of hardware that SDL can see. Logical
/// devices are created by calling `openAudioDevice` or
/// `openAudioDeviceStream`, and while each is associated with a physical
/// device, there can be any number of logical devices on one physical device.
///
/// For the most part, logical and physical IDs are interchangeable--if you try
/// to open a logical device, SDL understands to assign that effort to the
/// underlying physical device, etc. However, it might be useful to know if an
/// arbitrary device ID is physical or logical. This function reports which.
///
/// This function may return either true or false for invalid device IDs.
pub const isAudioDevicePhysical = SDL_IsAudioDevicePhysical;
extern fn SDL_IsAudioDevicePhysical(devid: AudioDeviceId) bool;

/// Determine if an audio device is a playback device (instead of recording).
///
/// This function may return either true or false for invalid device IDs.
pub const isAudioDevicePlayback = SDL_IsAudioDevicePlayback;
extern fn SDL_IsAudioDevicePlayback(devid: AudioDeviceId) bool;

/// Use this function to pause audio playback on a specified device.
///
/// This function pauses audio processing for a given device. Any bound audio
/// streams will not progress, and no audio will be generated. Pausing one
/// device does not prevent other unpaused devices from running.
///
/// Unlike in SDL2, audio devices start in an _unpaused_ state, since an app
/// has to bind a stream before any audio will flow. Pausing a paused device is
/// a legal no-op.
///
/// Pausing a device can be useful to halt all audio without unbinding all the
/// audio streams. This might be useful while a game is paused, or a level is
/// loading, etc.
///
/// Physical devices can not be paused or unpaused, only logical devices
/// created through `openAudioDevice` can be.
pub fn pauseAudioDevice(devid: AudioDeviceId) Error!void {
    if (!SDL_PauseAudioDevice(devid)) return makeError();
}
extern fn SDL_PauseAudioDevice(devid: AudioDeviceId) bool;

/// Use this function to unpause audio playback on a specified device.
///
/// This function unpauses audio processing for a given device that has
/// previously been paused with `pauseAudioDevice`. Once unpaused, any
/// bound audio streams will begin to progress again, and audio can be
/// generated.
///
/// Unlike in SDL2, audio devices start in an _unpaused_ state, since an app
/// has to bind a stream before any audio will flow. Unpausing an unpaused
/// device is a legal no-op.
///
/// Physical devices can not be paused or unpaused, only logical devices
/// created through `openAudioDevice` can be.
pub fn resumeAudioDevice(devid: AudioDeviceId) Error!void {
    if (!SDL_ResumeAudioDevice(devid)) return makeError();
}
extern fn SDL_ResumeAudioDevice(devid: AudioDeviceId) bool;

/// Use this function to query if an audio device is paused.
///
/// Unlike in SDL2, audio devices start in an _unpaused_ state, since an app
/// has to bind a stream before any audio will flow.
///
/// Physical devices can not be paused or unpaused, only logical devices
/// created through `openAudioDevice` can be. Physical and invalid device
/// IDs will report themselves as unpaused here.
pub const audioDevicePaused = SDL_AudioDevicePaused;
extern fn SDL_AudioDevicePaused(devid: AudioDeviceId) bool;

/// Get the gain of an audio device.
///
/// The gain of a device is its volume; a larger gain means a louder output,
/// with a gain of zero being silence.
///
/// Audio devices default to a gain of 1.0f (no change in output).
///
/// Physical devices may not have their gain changed, only logical devices, and
/// this function will always return -1.0f when used on physical devices.
pub fn getAudioDeviceGain(devid: AudioDeviceId) Error!f32 {
    const result = SDL_GetAudioDeviceGain(devid);
    if (result < 0) return makeError();
    return result;
}
extern fn SDL_GetAudioDeviceGain(devid: AudioDeviceId) f32;

/// Change the gain of an audio device.
///
/// The gain of a device is its volume; a larger gain means a louder output,
/// with a gain of zero being silence.
///
/// Audio devices default to a gain of 1.0f (no change in output).
///
/// Physical devices may not have their gain changed, only logical devices, and
/// this function will always return false when used on physical devices. While
/// it might seem attractive to adjust several logical devices at once in this
/// way, it would allow an app or library to interfere with another portion of
/// the program's otherwise-isolated devices.
///
/// This is applied, along with any per-audiostream gain, during playback to
/// the hardware, and can be continuously changed to create various effects. On
/// recording devices, this will adjust the gain before passing the data into
/// an audiostream; that recording audiostream can then adjust its gain further
/// when outputting the data elsewhere, if it likes, but that second gain is
/// not applied until the data leaves the audiostream again.
pub fn setAudioDeviceGain(devid: AudioDeviceId, gain: f32) Error!void {
    if (!SDL_SetAudioDeviceGain(devid, gain)) return makeError();
}
extern fn SDL_SetAudioDeviceGain(devid: AudioDeviceId, gain: f32) bool;

/// Close a previously-opened audio device.
///
/// The application should close open audio devices once they are no longer
/// needed.
///
/// This function may block briefly while pending audio data is played by the
/// hardware, so that applications don't drop the last buffer of data they
/// supplied if terminating immediately afterwards.
pub const closeAudioDevice = SDL_CloseAudioDevice;
extern fn SDL_CloseAudioDevice(devid: AudioDeviceId) void;

/// Bind a list of audio streams to an audio device.
///
/// Audio data will flow through any bound streams. For a playback device, data
/// for all bound streams will be mixed together and fed to the device. For a
/// recording device, a copy of recorded data will be provided to each bound
/// stream.
///
/// Audio streams can only be bound to an open device. This operation is
/// atomic--all streams bound in the same call will start processing at the
/// same time, so they can stay in sync. Also: either all streams will be bound
/// or none of them will be.
///
/// It is an error to bind an already-bound stream; it must be explicitly
/// unbound first.
///
/// Binding a stream to a device will set its output format for playback
/// devices, and its input format for recording devices, so they match the
/// device's settings. The caller is welcome to change the other end of the
/// stream's format at any time with `setAudioStreamFormat`. If the other
/// end of the stream's format has never been set (the audio stream was created
/// with a null audio spec), this function will set it to match the device
/// end's format.
pub fn bindAudioStreams(devid: AudioDeviceId, streams: []const *AudioStream) Error!void {
    if (!SDL_BindAudioStreams(devid, streams.ptr, @intCast(streams.len))) return makeError();
}
extern fn SDL_BindAudioStreams(devid: AudioDeviceId, streams: [*]const *AudioStream, num_streams: c_int) bool;

/// Bind a single audio stream to an audio device.
///
/// This is a convenience function, equivalent to calling
/// ``bindAudioStreams`(devid, &stream, 1)`.
pub fn bindAudioStream(devid: AudioDeviceId, stream: *AudioStream) Error!void {
    if (!SDL_BindAudioStream(devid, stream)) return makeError();
}
extern fn SDL_BindAudioStream(devid: AudioDeviceId, stream: *AudioStream) bool;

/// Unbind a list of audio streams from their audio devices.
///
/// The streams being unbound do not all have to be on the same device. All
/// streams on the same device will be unbound atomically (data will stop
/// flowing through all unbound streams on the same device at the same time).
///
/// Unbinding a stream that isn't bound to a device is a legal no-op.
pub fn unbindAudioStreams(streams: ?[]const *AudioStream) void {
    return SDL_UnbindAudioStreams(if (streams) |s| s.ptr else null, if (streams) |s| @intCast(s.len) else 0);
}
extern fn SDL_UnbindAudioStreams(streams: ?[*]const *AudioStream, num_streams: c_int) void;

/// Unbind a single audio stream from its audio device.
///
/// This is a convenience function, equivalent to calling
/// ``unbindAudioStreams`(&stream, 1)`.
pub const unbindAudioStream = SDL_UnbindAudioStream;
extern fn SDL_UnbindAudioStream(stream: ?*AudioStream) void;

/// Query an audio stream for its currently-bound device.
///
/// This reports the logical audio device that an audio stream is currently
/// bound to.
///
/// If not bound, or invalid, this returns zero, which is not a valid device
/// ID.
pub const getAudioStreamDevice = SDL_GetAudioStreamDevice;
extern fn SDL_GetAudioStreamDevice(stream: *AudioStream) AudioDeviceId;

/// Create a new audio stream.
///
/// Note that `src_spec` or `dst_spec` may be null, but any attempts to
/// put or get data from an audio stream will fail until it has valid
/// specs assigned to both ends of the stream. Specs can be assigned later
/// through `setAudioStreamFormat`, or binding the stream to an audio
/// device (which will set the format of only the input or output,
/// depending on what kind of device the stream was bound to).
pub fn createAudioStream(src_spec: ?*const AudioSpec, dst_spec: ?*const AudioSpec) Error!*AudioStream {
    return SDL_CreateAudioStream(src_spec, dst_spec) orelse makeError();
}
extern fn SDL_CreateAudioStream(src_spec: ?*const AudioSpec, dst_spec: ?*const AudioSpec) ?*AudioStream;

/// Get the properties associated with an audio stream.
///
/// The application can hang any data it wants here, but the following
/// properties are understood by SDL:
///
/// - `AudioStream.Properties.auto_cleanup_boolean`: if true (the default), the
///   stream be automatically cleaned up when the audio subsystem quits. If set
///   to false, the streams will persist beyond that. This property is ignored
///   for streams created through `openAudioDeviceStream`, and will always
///   be cleaned up. Streams that are not cleaned up will still be unbound from
///   devices when the audio subsystem quits. This property was added in SDL
///   3.4.0.
pub fn getAudioStreamProperties(stream: *AudioStream) Error!sdl.PropertiesId {
    const result = SDL_GetAudioStreamProperties(stream);
    if (@backingInt(result) == 0) return makeError();
    return result;
}
extern fn SDL_GetAudioStreamProperties(stream: *AudioStream) sdl.PropertiesId;

/// Query the current format of an audio stream.
pub fn getAudioStreamFormat(stream: *AudioStream, src_spec: ?*AudioSpec, dst_spec: ?*AudioSpec) Error!void {
    if (!SDL_GetAudioStreamFormat(stream, src_spec, dst_spec)) return makeError();
}
extern fn SDL_GetAudioStreamFormat(stream: *AudioStream, src_spec: ?*AudioSpec, dst_spec: ?*AudioSpec) bool;

/// Change the input and output formats of an audio stream.
///
/// Future calls to and `getAudioStreamAvailable` and `getAudioStreamData`
/// will reflect the new format, and future calls to `putAudioStreamData`
/// must provide data in the new input formats.
///
/// Data that was previously queued in the stream will still be operated on in
/// the format that was current when it was added, which is to say you can put
/// the end of a sound file in one format to a stream, change formats for the
/// next sound file, and start putting that new data while the previous sound
/// file is still queued, and everything will still play back correctly.
///
/// If a stream is bound to a device, then the format of the side of the stream
/// bound to a device cannot be changed (src_spec for recording devices,
/// dst_spec for playback devices). Attempts to make a change to this side will
/// be ignored, but this will not report an error. The other side's format can
/// be changed.
///
/// `src_spec` and `dst_spec` may each be null; a null spec signals not to
/// change the current format for that side of the stream.
pub fn setAudioStreamFormat(stream: *AudioStream, src_spec: ?*const AudioSpec, dst_spec: ?*const AudioSpec) Error!void {
    if (!SDL_SetAudioStreamFormat(stream, src_spec, dst_spec)) return makeError();
}
extern fn SDL_SetAudioStreamFormat(stream: *AudioStream, src_spec: ?*const AudioSpec, dst_spec: ?*const AudioSpec) bool;

/// Get the frequency ratio of an audio stream.
pub fn getAudioStreamFrequencyRatio(stream: *AudioStream) ?f32 {
    const result = SDL_GetAudioStreamFrequencyRatio(stream);
    if (result == 0.0) return null;
    return result;
}
extern fn SDL_GetAudioStreamFrequencyRatio(stream: *AudioStream) f32;

/// Change the frequency ratio of an audio stream.
///
/// The frequency ratio is used to adjust the rate at which input data is
/// consumed. Changing this effectively modifies the speed and pitch of the
/// audio. A value greater than 1.0f will play the audio faster, and at a
/// higher pitch. A value less than 1.0f will play the audio slower, and at a
/// lower pitch. 1.0f means play at normal speed.
///
/// This is applied during `getAudioStreamData`, and can be continuously
/// changed to create various effects.
pub fn setAudioStreamFrequencyRatio(stream: *AudioStream, ratio: f32) Error!void {
    if (!SDL_SetAudioStreamFrequencyRatio(stream, ratio)) return makeError();
}
extern fn SDL_SetAudioStreamFrequencyRatio(stream: *AudioStream, ratio: f32) bool;

/// Get the gain of an audio stream.
///
/// The gain of a stream is its volume; a larger gain means a louder output,
/// with a gain of zero being silence.
///
/// Audio streams default to a gain of 1.0f (no change in output).
pub fn getAudioStreamGain(stream: *AudioStream) Error!f32 {
    const result = SDL_GetAudioStreamGain(stream);
    if (result < 0) return makeError();
    return result;
}
extern fn SDL_GetAudioStreamGain(stream: *AudioStream) f32;

/// Change the gain of an audio stream.
///
/// The gain of a stream is its volume; a larger gain means a louder output,
/// with a gain of zero being silence.
///
/// Audio streams default to a gain of 1.0f (no change in output).
///
/// This is applied during `getAudioStreamData`, and can be continuously
/// changed to create various effects.
pub fn setAudioStreamGain(stream: *AudioStream, gain: f32) Error!void {
    if (!SDL_SetAudioStreamGain(stream, gain)) return makeError();
}
extern fn SDL_SetAudioStreamGain(stream: *AudioStream, gain: f32) bool;

/// Get the current input channel map of an audio stream.
///
/// Channel maps are optional; most things do not need them, instead passing
/// data in the [order that SDL expects](CategoryAudio#channel-layouts).
///
/// Audio streams default to no remapping applied. This is represented by
/// returning null, and does not signify an error.
///
/// Returns null if no remapping is necessary. The returned slice should be
/// freed with `free` when it is no longer needed.
pub fn getAudioStreamInputChannelMap(stream: *AudioStream) ?[]c_int {
    var count: c_int = undefined;
    const ptr = SDL_GetAudioStreamInputChannelMap(stream, &count) orelse return null;
    return ptr[0..@intCast(count)];
}
extern fn SDL_GetAudioStreamInputChannelMap(stream: *AudioStream, count: ?*c_int) ?[*]c_int;

/// Get the current output channel map of an audio stream.
///
/// Channel maps are optional; most things do not need them, instead passing
/// data in the [order that SDL expects](CategoryAudio#channel-layouts).
///
/// Audio streams default to no remapping applied. This is represented by
/// returning null, and does not signify an error.
///
/// Returns null if no remapping is necessary. The returned slice should be
/// freed with `free` when it is no longer needed.
pub fn getAudioStreamOutputChannelMap(stream: *AudioStream) ?[]c_int {
    var count: c_int = undefined;
    const ptr = SDL_GetAudioStreamOutputChannelMap(stream, &count) orelse return null;
    return ptr[0..@intCast(count)];
}
extern fn SDL_GetAudioStreamOutputChannelMap(stream: *AudioStream, count: ?*c_int) ?[*]c_int;

/// Set the current input channel map of an audio stream.
///
/// Channel maps are optional; most things do not need them, instead passing
/// data in the [order that SDL expects](CategoryAudio#channel-layouts).
///
/// The input channel map reorders data that is added to a stream via
/// `putAudioStreamData`. Future calls to `putAudioStreamData` must provide
/// data in the new channel order.
///
/// Each item in the array represents an input channel, and its value is the
/// channel that it should be remapped to. To reverse a stereo signal's left
/// and right values, you'd have an array of `{ 1, 0 }`. It is legal to remap
/// multiple channels to the same thing, so `{ 1, 1 }` would duplicate the
/// right channel to both channels of a stereo signal. An element in the
/// channel map set to -1 instead of a valid channel will mute that channel,
/// setting it to a silence value.
///
/// You cannot change the number of channels through a channel map, just
/// reorder/mute them.
///
/// Data that was previously queued in the stream will still be operated on in
/// the order that was current when it was added, which is to say you can put
/// the end of a sound file in one order to a stream, change orders for the
/// next sound file, and start putting that new data while the previous sound
/// file is still queued, and everything will still play back correctly.
///
/// Audio streams default to no remapping applied. Passing a null channel map
/// is legal, and turns off remapping.
///
/// SDL will copy the channel map; the caller does not have to save this array
/// after this call.
///
/// If `count` is not equal to the current number of channels in the audio
/// stream's format, this will fail. This is a safety measure to make sure a
/// race condition hasn't changed the format while this call is setting the
/// channel map.
///
/// Unlike attempting to change the stream's format, the input channel map on a
/// stream bound to a recording device is permitted to change at any time; any
/// data added to the stream from the device after this call will have the new
/// mapping, but previously-added data will still have the prior mapping.
pub fn setAudioStreamInputChannelMap(stream: *AudioStream, chmap: ?[]const c_int) Error!void {
    if (!SDL_SetAudioStreamInputChannelMap(stream, if (chmap) |s| s.ptr else null, if (chmap) |s| @intCast(s.len) else 0)) return makeError();
}
extern fn SDL_SetAudioStreamInputChannelMap(stream: *AudioStream, chmap: ?[*]const c_int, count: c_int) bool;

/// Set the current output channel map of an audio stream.
///
/// Channel maps are optional; most things do not need them, instead passing
/// data in the [order that SDL expects](CategoryAudio#channel-layouts).
///
/// The output channel map reorders data that is leaving a stream via
/// `getAudioStreamData`.
///
/// Each item in the array represents an input channel, and its value is the
/// channel that it should be remapped to. To reverse a stereo signal's left
/// and right values, you'd have an array of `{ 1, 0 }`. It is legal to remap
/// multiple channels to the same thing, so `{ 1, 1 }` would duplicate the
/// right channel to both channels of a stereo signal. An element in the
/// channel map set to -1 instead of a valid channel will mute that channel,
/// setting it to a silence value.
///
/// You cannot change the number of channels through a channel map, just
/// reorder/mute them.
///
/// The output channel map can be changed at any time, as output remapping is
/// applied during `getAudioStreamData`.
///
/// Audio streams default to no remapping applied. Passing a null channel map
/// is legal, and turns off remapping.
///
/// SDL will copy the channel map; the caller does not have to save this array
/// after this call.
///
/// If `count` is not equal to the current number of channels in the audio
/// stream's format, this will fail. This is a safety measure to make sure a
/// race condition hasn't changed the format while this call is setting the
/// channel map.
///
/// Unlike attempting to change the stream's format, the output channel map on
/// a stream bound to a recording device is permitted to change at any time;
/// any data added to the stream after this call will have the new mapping, but
/// previously-added data will still have the prior mapping. When the channel
/// map doesn't match the hardware's channel layout, SDL will convert the data
/// before feeding it to the device for playback.
pub fn setAudioStreamOutputChannelMap(stream: *AudioStream, chmap: ?[]const c_int) Error!void {
    if (!SDL_SetAudioStreamOutputChannelMap(stream, if (chmap) |s| s.ptr else null, if (chmap) |s| @intCast(s.len) else 0)) return makeError();
}
extern fn SDL_SetAudioStreamOutputChannelMap(stream: *AudioStream, chmap: ?[*]const c_int, count: c_int) bool;

/// Add data to the stream.
///
/// This data must match the format/channels/samplerate specified in the latest
/// call to `setAudioStreamFormat`, or the format specified when creating the
/// stream if it hasn't been changed.
///
/// Note that this call simply copies the unconverted data for later. This is
/// different than SDL2, where data was converted during the Put call and the
/// Get call would just dequeue the previously-converted data.
pub fn putAudioStreamData(comptime SampleType: type, stream: *AudioStream, data: []const SampleType) Error!void {
    if (!SDL_PutAudioStreamData(stream, data.ptr, @intCast(@sizeOf(SampleType) * data.len))) return makeError();
}
extern fn SDL_PutAudioStreamData(stream: *AudioStream, buf: *const anyopaque, len: c_int) bool;

/// A callback that fires for completed `putAudioStreamDataNoCopy` data.
///
/// When using `putAudioStreamDataNoCopy` to provide data to an
/// `AudioStream`, it's not safe to dispose of the data until the stream has
/// completely consumed it. Often times it's difficult to know exactly when
/// this has happened.
///
/// This callback fires once when the stream no longer needs the buffer,
/// allowing the app to easily free or reuse it.
pub const AudioStreamDataCompleteCallback = *const fn (userdata: ?*anyopaque, buf: ?*const anyopaque, buflen: c_int) callconv(.c) void;

/// Add external data to an audio stream without copying it.
///
/// Unlike `putAudioStreamData`, this function does not make a copy of the
/// provided data, instead storing the provided pointer. This means that the
/// put operation does not need to allocate and copy the data, but the original
/// data must remain available until the stream is done with it, either by
/// being read from the stream in its entirety, or a call to
/// `clearAudioStream` or `destroyAudioStream`.
///
/// The data must match the format/channels/samplerate specified in the latest
/// call to `setAudioStreamFormat`, or the format specified when creating the
/// stream if it hasn't been changed.
///
/// An optional callback may be provided, which is called when the stream no
/// longer needs the data. Once this callback fires, the stream will not access
/// the data again. This callback will fire for any reason the data is no
/// longer needed, including clearing or destroying the stream.
///
/// Note that there is still an allocation to store tracking information, so
/// this function is more efficient for larger blocks of data. If you're
/// planning to put a few samples at a time, it will be more efficient to use
/// `putAudioStreamData`, which allocates and buffers in blocks.
pub fn putAudioStreamDataNoCopy(comptime SampleType: type, stream: *AudioStream, data: []const SampleType, callback: ?AudioStreamDataCompleteCallback, userdata: ?*anyopaque) Error!void {
    if (!SDL_PutAudioStreamDataNoCopy(stream, data.ptr, @intCast(@sizeOf(SampleType) * data.len), callback, userdata)) return makeError();
}
extern fn SDL_PutAudioStreamDataNoCopy(stream: *AudioStream, buf: *const anyopaque, len: c_int, callback: ?AudioStreamDataCompleteCallback, userdata: ?*anyopaque) bool;

/// Add data to the stream with each channel in a separate array.
///
/// This data must match the format/channels/samplerate specified in the latest
/// call to `setAudioStreamFormat`, or the format specified when creating the
/// stream if it hasn't been changed.
///
/// The data will be interleaved and queued. Note that `AudioStream` only
/// operates on interleaved data, so this is simply a convenience function for
/// easily queueing data from sources that provide separate arrays. There is no
/// equivalent function to retrieve planar data.
///
/// The arrays in `channel_buffers` are ordered as they are to be interleaved;
/// the first array will be the first sample in the interleaved data. Any
/// individual array may be null; in this case, silence will be interleaved for
/// that channel.
///
/// The length of `channel_buffers` is used as a safety to prevent overflow, in
/// case the stream format has changed elsewhere. If more channels are specified
/// than the current input spec, they are ignored. If less channels are
/// specified, the missing arrays are treated as if they are null (silence is
/// written to those channels).
///
/// Note that `num_samples` is the number of _samples per array_. This can also
/// be thought of as the number of _sample frames_ to be queued. A value of 1
/// with stereo arrays will queue two samples to the stream. This is different
/// than `putAudioStreamData`, which wants the size of a single array in
/// bytes.
pub fn putAudioStreamPlanarData(stream: *AudioStream, channel_buffers: []const ?*const anyopaque, num_samples: c_int) Error!void {
    if (!SDL_PutAudioStreamPlanarData(stream, channel_buffers.ptr, @intCast(channel_buffers.len), num_samples)) return makeError();
}
extern fn SDL_PutAudioStreamPlanarData(stream: *AudioStream, channel_buffers: [*]const ?*const anyopaque, num_channels: c_int, num_samples: c_int) bool;

/// Get converted/resampled data from the stream.
///
/// The input/output data format/channels/samplerate is specified when creating
/// the stream, and can be changed after creation by calling
/// `setAudioStreamFormat`.
///
/// Note that any conversion and resampling necessary is done during this call,
/// and `putAudioStreamData` simply queues unconverted data for later. This
/// is different than SDL2, where that work was done while inputting new data
/// to the stream and requesting the output just copied the converted data.
///
/// Returns the part of `buf` that was filled with converted audio.
pub fn getAudioStreamData(comptime SampleType: type, stream: *AudioStream, buf: []SampleType) Error![]SampleType {
    const result = SDL_GetAudioStreamData(stream, buf.ptr, @intCast(@sizeOf(SampleType) * buf.len));
    if (result < 0) return makeError();
    return buf[0 .. @as(usize, @intCast(result)) / @sizeOf(SampleType)];
}
extern fn SDL_GetAudioStreamData(stream: *AudioStream, buf: *anyopaque, len: c_int) c_int;

/// Get the number of converted/resampled bytes available.
///
/// The stream may be buffering data behind the scenes until it has enough to
/// resample correctly, so this number might be lower than what you expect, or
/// even be zero. Add more data or flush the stream if you need the data now.
///
/// If the stream has so much data that it would overflow an int, the return
/// value is clamped to a maximum value, but no queued data is lost; if there
/// are gigabytes of data queued, the app might need to read some of it with
/// `getAudioStreamData` before this function's return value is no longer
/// clamped.
pub fn getAudioStreamAvailable(stream: *AudioStream) Error!usize {
    const result = SDL_GetAudioStreamAvailable(stream);
    if (result < 0) return makeError();
    return @intCast(result);
}
extern fn SDL_GetAudioStreamAvailable(stream: *AudioStream) c_int;

/// Get the number of bytes currently queued.
///
/// This is the number of bytes put into a stream as input, not the number that
/// can be retrieved as output. Because of several details, it's not possible
/// to calculate one number directly from the other. If you need to know how
/// much usable data can be retrieved right now, you should use
/// `getAudioStreamAvailable` and not this function.
///
/// Note that audio streams can change their input format at any time, even if
/// there is still data queued in a different format, so the returned byte
/// count will not necessarily match the number of _sample frames_ available.
/// Users of this API should be aware of format changes they make when feeding
/// a stream and plan accordingly.
///
/// Queued data is not converted until it is consumed by
/// `getAudioStreamData`, so this value should be representative of the exact
/// data that was put into the stream.
///
/// If the stream has so much data that it would overflow an int, the return
/// value is clamped to a maximum value, but no queued data is lost; if there
/// are gigabytes of data queued, the app might need to read some of it with
/// `getAudioStreamData` before this function's return value is no longer
/// clamped.
pub fn getAudioStreamQueued(stream: *AudioStream) Error!usize {
    const result = SDL_GetAudioStreamQueued(stream);
    if (result < 0) return makeError();
    return @intCast(result);
}
extern fn SDL_GetAudioStreamQueued(stream: *AudioStream) c_int;

/// Tell the stream that you're done sending data, and anything being buffered
/// should be converted/resampled and made available immediately.
///
/// It is legal to add more data to a stream after flushing, but there may be
/// audio gaps in the output. Generally this is intended to signal the end of
/// input, so the complete output becomes available.
pub fn flushAudioStream(stream: *AudioStream) Error!void {
    if (!SDL_FlushAudioStream(stream)) return makeError();
}
extern fn SDL_FlushAudioStream(stream: *AudioStream) bool;

/// Clear any pending data in the stream.
///
/// This drops any queued data, so there will be nothing to read from the
/// stream until more is added.
pub fn clearAudioStream(stream: *AudioStream) Error!void {
    if (!SDL_ClearAudioStream(stream)) return makeError();
}
extern fn SDL_ClearAudioStream(stream: *AudioStream) bool;

/// Use this function to pause audio playback on the audio device associated
/// with an audio stream.
///
/// This function pauses audio processing for a given device. Any bound audio
/// streams will not progress, and no audio will be generated. Pausing one
/// device does not prevent other unpaused devices from running.
///
/// Pausing a device can be useful to halt all audio without unbinding all the
/// audio streams. This might be useful while a game is paused, or a level is
/// loading, etc.
pub fn pauseAudioStreamDevice(stream: *AudioStream) Error!void {
    if (!SDL_PauseAudioStreamDevice(stream)) return makeError();
}
extern fn SDL_PauseAudioStreamDevice(stream: *AudioStream) bool;

/// Use this function to unpause audio playback on the audio device associated
/// with an audio stream.
///
/// This function unpauses audio processing for a given device that has
/// previously been paused. Once unpaused, any bound audio streams will begin
/// to progress again, and audio can be generated.
///
/// `openAudioDeviceStream` opens audio devices in a paused state, so this
/// function call is required for audio playback to begin on such devices.
pub fn resumeAudioStreamDevice(stream: *AudioStream) Error!void {
    if (!SDL_ResumeAudioStreamDevice(stream)) return makeError();
}
extern fn SDL_ResumeAudioStreamDevice(stream: *AudioStream) bool;

/// Use this function to query if an audio device associated with a stream is
/// paused.
///
/// Unlike in SDL2, audio devices start in an _unpaused_ state, since an app
/// has to bind a stream before any audio will flow.
pub const audioStreamDevicePaused = SDL_AudioStreamDevicePaused;
extern fn SDL_AudioStreamDevicePaused(stream: *AudioStream) bool;

/// Lock an audio stream for serialized access.
///
/// Each `AudioStream` has an internal mutex it uses to protect its data
/// structures from threading conflicts. This function allows an app to lock
/// that mutex, which could be useful if registering callbacks on this stream.
///
/// One does not need to lock a stream to use in it most cases, as the stream
/// manages this lock internally. However, this lock is held during callbacks,
/// which may run from arbitrary threads at any time, so if an app needs to
/// protect shared data during those callbacks, locking the stream guarantees
/// that the callback is not running while the lock is held.
///
/// As this is just a wrapper over `lockMutex` for an internal lock; it has
/// all the same attributes (recursive locks are allowed, etc).
pub fn lockAudioStream(stream: *AudioStream) Error!void {
    if (!SDL_LockAudioStream(stream)) return makeError();
}
extern fn SDL_LockAudioStream(stream: *AudioStream) bool;

/// Unlock an audio stream for serialized access.
///
/// This unlocks an audio stream after a call to `lockAudioStream`.
pub fn unlockAudioStream(stream: *AudioStream) Error!void {
    if (!SDL_UnlockAudioStream(stream)) return makeError();
}
extern fn SDL_UnlockAudioStream(stream: *AudioStream) bool;

/// A callback that fires when data passes through an `AudioStream`.
///
/// Apps can (optionally) register a callback with an audio stream that is
/// called when data is added with `putAudioStreamData`, or requested with
/// `getAudioStreamData`.
///
/// Two values are offered here: one is the amount of additional data needed to
/// satisfy the immediate request (which might be zero if the stream already
/// has enough data queued) and the other is the total amount being requested.
/// In a Get call triggering a Put callback, these values can be different. In
/// a Put call triggering a Get callback, these values are always the same.
///
/// Byte counts might be slightly overestimated due to buffering or resampling,
/// and may change from call to call.
///
/// This callback is not required to do anything. Generally this is useful for
/// adding/reading data on demand, and the app will often put/get data as
/// appropriate, but the system goes on with the data currently available to it
/// if this callback does nothing.
///
/// Do not call `destroyAudioStream` on `stream` during this callback.
pub const AudioStreamCallback = *const fn (userdata: ?*anyopaque, stream: *AudioStream, additional_amount: c_int, total_amount: c_int) callconv(.c) void;

/// Set a callback that runs when data is requested from an audio stream.
///
/// This callback is called _before_ data is obtained from the stream, giving
/// the callback the chance to add more on-demand.
///
/// The callback can (optionally) call `putAudioStreamData` to add more
/// audio to the stream during this call; if needed, the request that triggered
/// this callback will obtain the new data immediately.
///
/// The callback's `additional_amount` argument is roughly how many bytes of
/// _unconverted_ data (in the stream's input format) is needed by the caller,
/// although this may overestimate a little for safety. This takes into account
/// how much is already in the stream and only asks for any extra necessary to
/// resolve the request, which means the callback may be asked for zero bytes,
/// and a different amount on each call.
///
/// The callback is not required to supply exact amounts; it is allowed to
/// supply too much or too little or none at all. The caller will get what's
/// available, up to the amount they requested, regardless of this callback's
/// outcome.
///
/// Clearing or flushing an audio stream does not call this callback.
///
/// This function obtains the stream's lock, which means any existing callback
/// (get or put) in progress will finish running before setting the new
/// callback.
///
/// Setting a null function turns off the callback.
pub fn setAudioStreamGetCallback(stream: *AudioStream, callback: ?AudioStreamCallback, userdata: ?*anyopaque) Error!void {
    if (!SDL_SetAudioStreamGetCallback(stream, callback, userdata)) return makeError();
}
extern fn SDL_SetAudioStreamGetCallback(stream: *AudioStream, callback: ?AudioStreamCallback, userdata: ?*anyopaque) bool;

/// Set a callback that runs when data is added to an audio stream.
///
/// This callback is called _after_ the data is added to the stream, giving the
/// callback the chance to obtain it immediately.
///
/// The callback can (optionally) call `getAudioStreamData` to obtain audio
/// from the stream during this call.
///
/// The callback's `additional_amount` argument is how many bytes of
/// _converted_ data (in the stream's output format) was provided by the
/// caller, although this may underestimate a little for safety. This value
/// might be less than what is currently available in the stream, if data was
/// already there, and might be less than the caller provided if the stream
/// needs to keep a buffer to aid in resampling. Which means the callback may
/// be provided with zero bytes, and a different amount on each call.
///
/// The callback may call `getAudioStreamAvailable` to see the total amount
/// currently available to read from the stream, instead of the total provided
/// by the current call.
///
/// The callback is not required to obtain all data. It is allowed to read less
/// or none at all. Anything not read now simply remains in the stream for
/// later access.
///
/// Clearing or flushing an audio stream does not call this callback.
///
/// This function obtains the stream's lock, which means any existing callback
/// (get or put) in progress will finish running before setting the new
/// callback.
///
/// Setting a null function turns off the callback.
pub fn setAudioStreamPutCallback(stream: *AudioStream, callback: ?AudioStreamCallback, userdata: ?*anyopaque) Error!void {
    if (!SDL_SetAudioStreamPutCallback(stream, callback, userdata)) return makeError();
}
extern fn SDL_SetAudioStreamPutCallback(stream: *AudioStream, callback: ?AudioStreamCallback, userdata: ?*anyopaque) bool;

/// Free an audio stream.
///
/// This will release all allocated data, including any audio that is still
/// queued. You do not need to manually clear the stream first.
///
/// If this stream was bound to an audio device, it is unbound during this
/// call. If this stream was created with `openAudioDeviceStream`, the audio
/// device that was opened alongside this stream's creation will be closed,
/// too.
pub const destroyAudioStream = SDL_DestroyAudioStream;
extern fn SDL_DestroyAudioStream(stream: *AudioStream) void;

/// Convenience function for straightforward audio init for the common case.
///
/// If all your app intends to do is provide a single source of PCM audio, this
/// function allows you to do all your audio setup in a single call.
///
/// This is also intended to be a clean means to migrate apps from SDL2.
///
/// This function will open an audio device, create a stream and bind it.
/// Unlike other methods of setup, the audio device will be closed when this
/// stream is destroyed, so the app can treat the returned `AudioStream` as
/// the only object needed to manage audio playback.
///
/// Also unlike other functions, the audio device begins paused. This is to map
/// more closely to SDL2-style behavior, since there is no extra step here to
/// bind a stream to begin audio flowing. The audio device should be resumed
/// with `resumeAudioStreamDevice`.
///
/// This function works with both playback and recording devices.
///
/// The `spec` parameter represents the app's side of the audio stream. That
/// is, for recording audio, this will be the output format, and for playing
/// audio, this will be the input format. If spec is null, the system will
/// choose the format, and the app can use `getAudioStreamFormat` to obtain
/// this information later.
///
/// If you don't care about opening a specific audio device, you can (and
/// probably _should_), use `audio_device_default_playback` for playback and
/// `audio_device_default_recording` for recording.
///
/// One can optionally provide a callback function; if null, the app is
/// expected to queue audio data for playback (or unqueue audio data if
/// capturing). Otherwise, the callback will begin to fire once the device is
/// unpaused.
///
/// Destroying the returned stream with `destroyAudioStream` will also close
/// the audio device associated with this stream.
pub fn openAudioDeviceStream(devid: AudioDeviceId, spec: ?*const AudioSpec, callback: ?AudioStreamCallback, userdata: ?*anyopaque) Error!*AudioStream {
    return SDL_OpenAudioDeviceStream(devid, spec, callback, userdata) orelse makeError();
}
extern fn SDL_OpenAudioDeviceStream(devid: AudioDeviceId, spec: ?*const AudioSpec, callback: ?AudioStreamCallback, userdata: ?*anyopaque) ?*AudioStream;

/// A callback that fires when data is about to be fed to an audio device.
///
/// This is useful for accessing the final mix, perhaps for writing a
/// visualizer or applying a final effect to the audio data before playback.
///
/// This callback should run as quickly as possible and not block for any
/// significant time, as this callback delays submission of data to the audio
/// device, which can cause audio playback problems.
///
/// The postmix callback _must_ be able to handle any audio data format
/// specified in `spec`, which can change between callbacks if the audio device
/// changed. However, this only covers frequency and channel count; data is
/// always provided here in `AudioFormat.f32` format.
///
/// The postmix callback runs _after_ logical device gain and audiostream gain
/// have been applied, which is to say you can make the output data louder at
/// this point than the gain settings would suggest.
pub const AudioPostmixCallback = *const fn (userdata: ?*anyopaque, spec: *const AudioSpec, buffer: [*]f32, buflen: c_int) callconv(.c) void;

/// Set a callback that fires when data is about to be fed to an audio device.
///
/// This is useful for accessing the final mix, perhaps for writing a
/// visualizer or applying a final effect to the audio data before playback.
///
/// The buffer is the final mix of all bound audio streams on an opened device;
/// this callback will fire regularly for any device that is both opened and
/// unpaused. If there is no new data to mix, either because no streams are
/// bound to the device or all the streams are empty, this callback will still
/// fire with the entire buffer set to silence.
///
/// This callback is allowed to make changes to the data; the contents of the
/// buffer after this call is what is ultimately passed along to the hardware.
///
/// The callback is always provided the data in float format (values from -1.0f
/// to 1.0f), but the number of channels or sample rate may be different than
/// the format the app requested when opening the device; SDL might have had to
/// manage a conversion behind the scenes, or the playback might have jumped to
/// new physical hardware when a system default changed, etc. These details may
/// change between calls. Accordingly, the size of the buffer might change
/// between calls as well.
///
/// This callback can run at any time, and from any thread; if you need to
/// serialize access to your app's data, you should provide and use a mutex or
/// other synchronization device.
///
/// All of this to say: there are specific needs this callback can fulfill, but
/// it is not the simplest interface. Apps should generally provide audio in
/// their preferred format through an `AudioStream` and let SDL handle the
/// difference.
///
/// This function is extremely time-sensitive; the callback should do the least
/// amount of work possible and return as quickly as it can. The longer the
/// callback runs, the higher the risk of audio dropouts or other problems.
///
/// This function will block until the audio device is in between iterations,
/// so any existing callback that might be running will finish before this
/// function sets the new callback and returns.
///
/// Setting a null callback function disables any previously-set callback.
pub fn setAudioPostmixCallback(devid: AudioDeviceId, callback: ?AudioPostmixCallback, userdata: ?*anyopaque) Error!void {
    if (!SDL_SetAudioPostmixCallback(devid, callback, userdata)) return makeError();
}
extern fn SDL_SetAudioPostmixCallback(devid: AudioDeviceId, callback: ?AudioPostmixCallback, userdata: ?*anyopaque) bool;

/// Load the audio data of a WAVE file into memory.
///
/// Loading a WAVE file requires `src`, `spec`, `audio_buf` and `audio_len` to
/// be valid pointers. The entire data portion of the file is then loaded into
/// memory and decoded if necessary.
///
/// Supported formats are RIFF WAVE files with the formats PCM (8, 16, 24, and
/// 32 bits), IEEE Float (32 bits), Microsoft ADPCM and IMA ADPCM (4 bits), and
/// A-law and mu-law (8 bits). Other formats are currently unsupported and
/// cause an error.
///
/// If this function succeeds, the return value is zero and the pointer to the
/// audio data allocated by the function is written to `audio_buf` and its
/// length in bytes to `audio_len`. The `AudioSpec` members `freq`,
/// `channels`, and `format` are set to the values of the audio data in the
/// buffer.
///
/// It's necessary to use `free` to free the audio data returned in
/// `audio_buf` when it is no longer used.
///
/// Because of the underspecification of the .WAV format, there are many
/// problematic files in the wild that cause issues with strict decoders. To
/// provide compatibility with these files, this decoder is lenient in regards
/// to the truncation of the file, the fact chunk, and the size of the RIFF
/// chunk. The hints `hint_wave_riff_chunk_size`,
/// `hint_wave_truncation`, and `hint_wave_fact_chunk` can be used to
/// tune the behavior of the loading process.
///
/// Any file that is invalid (due to truncation, corruption, or wrong values in
/// the headers), too big, or unsupported causes an error. Additionally, any
/// critical I/O error from the data source will terminate the loading process
/// with an error. The function returns null on error and in all cases (with
/// the exception of `src` being null), an appropriate error message will be
/// set.
///
/// It is required that the data source supports seeking.
///
/// Example:
///
/// ```c
/// SDL_LoadWAV_IO(SDL_IOFromFile("sample.wav", "rb"), true, &spec, &buf, &len);
/// ```
///
/// Note that the `loadWAV` function does this same thing for you, but in a
/// less messy way:
///
/// ```c
/// SDL_LoadWAV("sample.wav", &spec, &buf, &len);
/// ```
///
///          This function returns false if the .WAV file cannot be opened,
///          uses an unknown data format, or is corrupt; call `getError`
///          for more information.
///
///          When the application is done with the data returned in
///          `audio_buf`, it should call `free` to dispose of it.
///
/// The returned buffer should be freed with `free` when it is no longer needed.
pub fn loadWAV_IO(src: *sdl.IOStream, closeio: bool) Error!struct { spec: AudioSpec, buf: []u8 } {
    var spec: AudioSpec = undefined;
    var buf: [*]u8 = undefined;
    var len: u32 = undefined;
    if (!SDL_LoadWAV_IO(src, closeio, &spec, &buf, &len)) return makeError();
    return .{ .spec = spec, .buf = buf[0..len] };
}
extern fn SDL_LoadWAV_IO(src: *sdl.IOStream, closeio: bool, spec: *AudioSpec, audio_buf: *[*]u8, audio_len: *u32) bool;

/// Loads a WAV from a file path.
///
/// This is a convenience function that is effectively the same as:
///
/// ```c
/// SDL_LoadWAV_IO(SDL_IOFromFile(path, "rb"), true, spec, audio_buf, audio_len);
/// ```
///
///          This function returns false if the .WAV file cannot be opened,
///          uses an unknown data format, or is corrupt; call `getError`
///          for more information.
///
///          When the application is done with the data returned in
///          `audio_buf`, it should call `free` to dispose of it.
///
/// The returned buffer should be freed with `free` when it is no longer needed.
pub fn loadWAV(path: [:0]const u8) Error!struct { spec: AudioSpec, buf: []u8 } {
    var spec: AudioSpec = undefined;
    var buf: [*]u8 = undefined;
    var len: u32 = undefined;
    if (!SDL_LoadWAV(path.ptr, &spec, &buf, &len)) return makeError();
    return .{ .spec = spec, .buf = buf[0..len] };
}
extern fn SDL_LoadWAV(path: [*:0]const u8, spec: *AudioSpec, audio_buf: *[*]u8, audio_len: *u32) bool;

/// Mix audio data in a specified format.
///
/// This takes an audio buffer `src` of `len` bytes of `format` data and mixes
/// it into `dst`, performing addition, volume adjustment, and overflow
/// clipping. The buffer pointed to by `dst` must also be `len` bytes of
/// `format` data.
///
/// This is provided for convenience -- you can mix your own audio data.
///
/// Do not use this function for mixing together more than two streams of
/// sample data. The output from repeated application of this function may be
/// distorted by clipping, because there is no accumulator with greater range
/// than the input (not to mention this being an inefficient way of doing it).
///
/// It is a common misconception that this function is required to write audio
/// data to an output stream in an audio callback. While you can do that,
/// `mixAudio` is really only needed when you're mixing a single audio
/// stream with a volume adjustment.
///
/// `dst` must be at least as long as `src`.
pub fn mixAudio(dst: []u8, src: []const u8, format: AudioFormat, volume: f32) Error!void {
    std.debug.assert(dst.len >= src.len);
    if (!SDL_MixAudio(dst.ptr, src.ptr, format, @intCast(src.len), volume)) return makeError();
}
extern fn SDL_MixAudio(dst: [*]u8, src: [*]const u8, format: AudioFormat, len: u32, volume: f32) bool;

/// Convert some audio data of one format to another format.
///
/// Please note that this function is for convenience, but should not be used
/// to resample audio in blocks, as it will introduce audio artifacts on the
/// boundaries. You should only use this function if you are converting audio
/// data in its entirety in one call. If you want to convert audio in smaller
/// chunks, use an `AudioStream`, which is designed for this situation.
///
/// Internally, this function creates and destroys an `AudioStream` on each
/// use, so it's also less efficient than using one directly, if you need to
/// convert multiple times.
///
/// The returned buffer should be freed with `free` when it is no longer needed.
pub fn convertAudioSamples(src_spec: *const AudioSpec, src_data: []const u8, dst_spec: *const AudioSpec) Error![]u8 {
    var dst_data: [*]u8 = undefined;
    var dst_len: c_int = undefined;
    if (!SDL_ConvertAudioSamples(src_spec, src_data.ptr, @intCast(src_data.len), dst_spec, &dst_data, &dst_len)) return makeError();
    return dst_data[0..@intCast(dst_len)];
}
extern fn SDL_ConvertAudioSamples(src_spec: *const AudioSpec, src_data: [*]const u8, src_len: c_int, dst_spec: *const AudioSpec, dst_data: *[*]u8, dst_len: *c_int) bool;

/// Get the human readable name of an audio format.
pub fn getAudioFormatName(format: AudioFormat) [:0]const u8 {
    const str = SDL_GetAudioFormatName(format);
    return std.mem.span(str);
}
extern fn SDL_GetAudioFormatName(format: AudioFormat) [*:0]const u8;

/// Get the appropriate memset value for silencing an audio format.
///
/// The value returned by this function can be used as the second argument to
/// memset (or `memset`) to set an audio buffer in a specific format to
/// silence.
pub const getSilenceValueForFormat = SDL_GetSilenceValueForFormat;
extern fn SDL_GetSilenceValueForFormat(format: AudioFormat) c_int;

test "AudioFormat helpers and generic stream functions" {
    try std.testing.expectEqual(AudioFormat.s16le, AudioFormat.define(true, false, false, 16));
    try std.testing.expectEqual(32, AudioFormat.f32be.bitSize());
    try std.testing.expect(AudioFormat.f32.isFloat());
    try std.testing.expect(AudioFormat.u8.isUnsigned());
    try std.testing.expectEqual(8, (AudioSpec{ .format = .s32, .channels = 2, .freq = 48000 }).frameSize());

    _ = @TypeOf(putAudioStreamData(f32, undefined, undefined));
    _ = @TypeOf(getAudioStreamData(i16, undefined, undefined));
}
