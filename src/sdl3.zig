//! SDL3 bindings for Zig
//!
//! Each SDL header lives in its own file under `src/sdl3/` (e.g. `SDL_video.h` -> `src/sdl3/video.zig`),
//! with declarations in the same order as in the header. Everything is re-exported from here,
//! so the public API is flat: `sdl.createWindow`, `sdl.Window`, ...

const std = @import("std");

const assert_h = @import("sdl3/assert.zig");
pub const AssertState = assert_h.AssertState;
pub const AssertData = assert_h.AssertData;
pub const reportAssertion = assert_h.reportAssertion;
pub const AssertionHandler = assert_h.AssertionHandler;
pub const setAssertionHandler = assert_h.setAssertionHandler;
pub const getDefaultAssertionHandler = assert_h.getDefaultAssertionHandler;
pub const getAssertionHandler = assert_h.getAssertionHandler;
pub const getAssertionReport = assert_h.getAssertionReport;
pub const resetAssertionReport = assert_h.resetAssertionReport;
const asyncio_h = @import("sdl3/asyncio.zig");
pub const AsyncIO = asyncio_h.AsyncIO;
pub const AsyncIOTaskType = asyncio_h.AsyncIOTaskType;
pub const AsyncIOResult = asyncio_h.AsyncIOResult;
pub const AsyncIOOutcome = asyncio_h.AsyncIOOutcome;
pub const AsyncIOQueue = asyncio_h.AsyncIOQueue;
pub const asyncIOFromFile = asyncio_h.asyncIOFromFile;
pub const getAsyncIOSize = asyncio_h.getAsyncIOSize;
pub const readAsyncIO = asyncio_h.readAsyncIO;
pub const writeAsyncIO = asyncio_h.writeAsyncIO;
pub const closeAsyncIO = asyncio_h.closeAsyncIO;
pub const createAsyncIOQueue = asyncio_h.createAsyncIOQueue;
pub const destroyAsyncIOQueue = asyncio_h.destroyAsyncIOQueue;
pub const getAsyncIOResult = asyncio_h.getAsyncIOResult;
pub const waitAsyncIOResult = asyncio_h.waitAsyncIOResult;
pub const signalAsyncIOQueue = asyncio_h.signalAsyncIOQueue;
pub const loadFileAsync = asyncio_h.loadFileAsync;
const atomic_h = @import("sdl3/atomic.zig");
pub const SpinLock = atomic_h.SpinLock;
pub const tryLockSpinlock = atomic_h.tryLockSpinlock;
pub const lockSpinlock = atomic_h.lockSpinlock;
pub const unlockSpinlock = atomic_h.unlockSpinlock;
pub const cpuPauseInstruction = atomic_h.cpuPauseInstruction;
pub const memoryBarrierReleaseFunction = atomic_h.memoryBarrierReleaseFunction;
pub const memoryBarrierAcquireFunction = atomic_h.memoryBarrierAcquireFunction;
pub const AtomicInt = atomic_h.AtomicInt;
pub const compareAndSwapAtomicInt = atomic_h.compareAndSwapAtomicInt;
pub const setAtomicInt = atomic_h.setAtomicInt;
pub const getAtomicInt = atomic_h.getAtomicInt;
pub const addAtomicInt = atomic_h.addAtomicInt;
pub const atomicIncRef = atomic_h.atomicIncRef;
pub const atomicDecRef = atomic_h.atomicDecRef;
pub const AtomicU32 = atomic_h.AtomicU32;
pub const compareAndSwapAtomicU32 = atomic_h.compareAndSwapAtomicU32;
pub const setAtomicU32 = atomic_h.setAtomicU32;
pub const getAtomicU32 = atomic_h.getAtomicU32;
pub const addAtomicU32 = atomic_h.addAtomicU32;
pub const compareAndSwapAtomicPointer = atomic_h.compareAndSwapAtomicPointer;
pub const setAtomicPointer = atomic_h.setAtomicPointer;
pub const getAtomicPointer = atomic_h.getAtomicPointer;
const audio_h = @import("sdl3/audio.zig");
pub const audio_mask_bitsize = audio_h.audio_mask_bitsize;
pub const audio_mask_float = audio_h.audio_mask_float;
pub const audio_mask_big_endian = audio_h.audio_mask_big_endian;
pub const audio_mask_signed = audio_h.audio_mask_signed;
pub const AudioFormat = audio_h.AudioFormat;
pub const AudioDeviceId = audio_h.AudioDeviceId;
pub const audio_device_default_playback = audio_h.audio_device_default_playback;
pub const audio_device_default_recording = audio_h.audio_device_default_recording;
pub const AudioSpec = audio_h.AudioSpec;
pub const AudioStream = audio_h.AudioStream;
pub const getNumAudioDrivers = audio_h.getNumAudioDrivers;
pub const getAudioDriver = audio_h.getAudioDriver;
pub const getCurrentAudioDriver = audio_h.getCurrentAudioDriver;
pub const getAudioPlaybackDevices = audio_h.getAudioPlaybackDevices;
pub const getAudioRecordingDevices = audio_h.getAudioRecordingDevices;
pub const getAudioDeviceName = audio_h.getAudioDeviceName;
pub const getAudioDeviceFormat = audio_h.getAudioDeviceFormat;
pub const getAudioDeviceChannelMap = audio_h.getAudioDeviceChannelMap;
pub const openAudioDevice = audio_h.openAudioDevice;
pub const isAudioDevicePhysical = audio_h.isAudioDevicePhysical;
pub const isAudioDevicePlayback = audio_h.isAudioDevicePlayback;
pub const pauseAudioDevice = audio_h.pauseAudioDevice;
pub const resumeAudioDevice = audio_h.resumeAudioDevice;
pub const audioDevicePaused = audio_h.audioDevicePaused;
pub const getAudioDeviceGain = audio_h.getAudioDeviceGain;
pub const setAudioDeviceGain = audio_h.setAudioDeviceGain;
pub const closeAudioDevice = audio_h.closeAudioDevice;
pub const bindAudioStreams = audio_h.bindAudioStreams;
pub const bindAudioStream = audio_h.bindAudioStream;
pub const unbindAudioStreams = audio_h.unbindAudioStreams;
pub const unbindAudioStream = audio_h.unbindAudioStream;
pub const getAudioStreamDevice = audio_h.getAudioStreamDevice;
pub const createAudioStream = audio_h.createAudioStream;
pub const getAudioStreamProperties = audio_h.getAudioStreamProperties;
pub const getAudioStreamFormat = audio_h.getAudioStreamFormat;
pub const setAudioStreamFormat = audio_h.setAudioStreamFormat;
pub const getAudioStreamFrequencyRatio = audio_h.getAudioStreamFrequencyRatio;
pub const setAudioStreamFrequencyRatio = audio_h.setAudioStreamFrequencyRatio;
pub const getAudioStreamGain = audio_h.getAudioStreamGain;
pub const setAudioStreamGain = audio_h.setAudioStreamGain;
pub const getAudioStreamInputChannelMap = audio_h.getAudioStreamInputChannelMap;
pub const getAudioStreamOutputChannelMap = audio_h.getAudioStreamOutputChannelMap;
pub const setAudioStreamInputChannelMap = audio_h.setAudioStreamInputChannelMap;
pub const setAudioStreamOutputChannelMap = audio_h.setAudioStreamOutputChannelMap;
pub const putAudioStreamData = audio_h.putAudioStreamData;
pub const AudioStreamDataCompleteCallback = audio_h.AudioStreamDataCompleteCallback;
pub const putAudioStreamDataNoCopy = audio_h.putAudioStreamDataNoCopy;
pub const putAudioStreamPlanarData = audio_h.putAudioStreamPlanarData;
pub const getAudioStreamData = audio_h.getAudioStreamData;
pub const getAudioStreamAvailable = audio_h.getAudioStreamAvailable;
pub const getAudioStreamQueued = audio_h.getAudioStreamQueued;
pub const flushAudioStream = audio_h.flushAudioStream;
pub const clearAudioStream = audio_h.clearAudioStream;
pub const pauseAudioStreamDevice = audio_h.pauseAudioStreamDevice;
pub const resumeAudioStreamDevice = audio_h.resumeAudioStreamDevice;
pub const audioStreamDevicePaused = audio_h.audioStreamDevicePaused;
pub const lockAudioStream = audio_h.lockAudioStream;
pub const unlockAudioStream = audio_h.unlockAudioStream;
pub const AudioStreamCallback = audio_h.AudioStreamCallback;
pub const setAudioStreamGetCallback = audio_h.setAudioStreamGetCallback;
pub const setAudioStreamPutCallback = audio_h.setAudioStreamPutCallback;
pub const destroyAudioStream = audio_h.destroyAudioStream;
pub const openAudioDeviceStream = audio_h.openAudioDeviceStream;
pub const AudioPostmixCallback = audio_h.AudioPostmixCallback;
pub const setAudioPostmixCallback = audio_h.setAudioPostmixCallback;
pub const loadWAV_IO = audio_h.loadWAV_IO;
pub const loadWAV = audio_h.loadWAV;
pub const mixAudio = audio_h.mixAudio;
pub const convertAudioSamples = audio_h.convertAudioSamples;
pub const getAudioFormatName = audio_h.getAudioFormatName;
pub const getSilenceValueForFormat = audio_h.getSilenceValueForFormat;
const bits_h = @import("sdl3/bits.zig");
pub const mostSignificantBitIndex32 = bits_h.mostSignificantBitIndex32;
pub const hasExactlyOneBitSet32 = bits_h.hasExactlyOneBitSet32;
const blendmode_h = @import("sdl3/blendmode.zig");
pub const BlendMode = blendmode_h.BlendMode;
pub const BlendOperation = blendmode_h.BlendOperation;
pub const BlendFactor = blendmode_h.BlendFactor;
pub const composeCustomBlendMode = blendmode_h.composeCustomBlendMode;
const camera_h = @import("sdl3/camera.zig");
pub const CameraId = camera_h.CameraId;
pub const Camera = camera_h.Camera;
pub const CameraSpec = camera_h.CameraSpec;
pub const CameraPermissionState = camera_h.CameraPermissionState;
pub const CameraPosition = camera_h.CameraPosition;
pub const getNumCameraDrivers = camera_h.getNumCameraDrivers;
pub const getCameraDriver = camera_h.getCameraDriver;
pub const getCurrentCameraDriver = camera_h.getCurrentCameraDriver;
pub const getCameras = camera_h.getCameras;
pub const getCameraSupportedFormats = camera_h.getCameraSupportedFormats;
pub const getCameraName = camera_h.getCameraName;
pub const getCameraPosition = camera_h.getCameraPosition;
pub const openCamera = camera_h.openCamera;
pub const getCameraPermissionState = camera_h.getCameraPermissionState;
pub const getCameraId = camera_h.getCameraId;
pub const getCameraProperties = camera_h.getCameraProperties;
pub const getCameraFormat = camera_h.getCameraFormat;
pub const acquireCameraFrame = camera_h.acquireCameraFrame;
pub const releaseCameraFrame = camera_h.releaseCameraFrame;
pub const closeCamera = camera_h.closeCamera;
const clipboard_h = @import("sdl3/clipboard.zig");
pub const setClipboardText = clipboard_h.setClipboardText;
pub const getClipboardText = clipboard_h.getClipboardText;
pub const hasClipboardText = clipboard_h.hasClipboardText;
pub const setPrimarySelectionText = clipboard_h.setPrimarySelectionText;
pub const getPrimarySelectionText = clipboard_h.getPrimarySelectionText;
pub const hasPrimarySelectionText = clipboard_h.hasPrimarySelectionText;
pub const ClipboardDataCallback = clipboard_h.ClipboardDataCallback;
pub const ClipboardCleanupCallback = clipboard_h.ClipboardCleanupCallback;
pub const setClipboardData = clipboard_h.setClipboardData;
pub const clearClipboardData = clipboard_h.clearClipboardData;
pub const getClipboardData = clipboard_h.getClipboardData;
pub const hasClipboardData = clipboard_h.hasClipboardData;
pub const getClipboardMimeTypes = clipboard_h.getClipboardMimeTypes;
const cpuinfo_h = @import("sdl3/cpuinfo.zig");
pub const cacheline_size = cpuinfo_h.cacheline_size;
pub const getNumLogicalCPUCores = cpuinfo_h.getNumLogicalCPUCores;
pub const getCPUCacheLineSize = cpuinfo_h.getCPUCacheLineSize;
pub const hasAltiVec = cpuinfo_h.hasAltiVec;
pub const hasMMX = cpuinfo_h.hasMMX;
pub const hasSSE = cpuinfo_h.hasSSE;
pub const hasSSE2 = cpuinfo_h.hasSSE2;
pub const hasSSE3 = cpuinfo_h.hasSSE3;
pub const hasSSE41 = cpuinfo_h.hasSSE41;
pub const hasSSE42 = cpuinfo_h.hasSSE42;
pub const hasAVX = cpuinfo_h.hasAVX;
pub const hasAVX2 = cpuinfo_h.hasAVX2;
pub const hasAVX512F = cpuinfo_h.hasAVX512F;
pub const hasARMSIMD = cpuinfo_h.hasARMSIMD;
pub const hasNEON = cpuinfo_h.hasNEON;
pub const hasLSX = cpuinfo_h.hasLSX;
pub const hasLASX = cpuinfo_h.hasLASX;
pub const getSystemRAM = cpuinfo_h.getSystemRAM;
pub const getSIMDAlignment = cpuinfo_h.getSIMDAlignment;
pub const getSystemPageSize = cpuinfo_h.getSystemPageSize;
const dialog_h = @import("sdl3/dialog.zig");
pub const DialogFileFilter = dialog_h.DialogFileFilter;
pub const DialogFileCallback = dialog_h.DialogFileCallback;
pub const showOpenFileDialog = dialog_h.showOpenFileDialog;
pub const showSaveFileDialog = dialog_h.showSaveFileDialog;
pub const showOpenFolderDialog = dialog_h.showOpenFolderDialog;
pub const FileDialogType = dialog_h.FileDialogType;
pub const showFileDialogWithProperties = dialog_h.showFileDialogWithProperties;
pub const prop_file_dialog_filters_pointer = dialog_h.prop_file_dialog_filters_pointer;
pub const prop_file_dialog_nfilters_number = dialog_h.prop_file_dialog_nfilters_number;
pub const prop_file_dialog_window_pointer = dialog_h.prop_file_dialog_window_pointer;
pub const prop_file_dialog_location_string = dialog_h.prop_file_dialog_location_string;
pub const prop_file_dialog_many_boolean = dialog_h.prop_file_dialog_many_boolean;
pub const prop_file_dialog_title_string = dialog_h.prop_file_dialog_title_string;
pub const prop_file_dialog_accept_string = dialog_h.prop_file_dialog_accept_string;
pub const prop_file_dialog_cancel_string = dialog_h.prop_file_dialog_cancel_string;
const endian_h = @import("sdl3/endian.zig");
pub const lil_endian = endian_h.lil_endian;
pub const big_endian = endian_h.big_endian;
pub const byteorder = endian_h.byteorder;
pub const floatwordorder = endian_h.floatwordorder;
pub const swap16 = endian_h.swap16;
pub const swap32 = endian_h.swap32;
pub const swap64 = endian_h.swap64;
pub const swapFloat = endian_h.swapFloat;
pub const swap16LE = endian_h.swap16LE;
pub const swap32LE = endian_h.swap32LE;
pub const swap64LE = endian_h.swap64LE;
pub const swapFloatLE = endian_h.swapFloatLE;
pub const swap16BE = endian_h.swap16BE;
pub const swap32BE = endian_h.swap32BE;
pub const swap64BE = endian_h.swap64BE;
pub const swapFloatBE = endian_h.swapFloatBE;
const error_h = @import("sdl3/error.zig");
pub const setError = error_h.setError;
pub const outOfMemory = error_h.outOfMemory;
pub const getError = error_h.getError;
pub const clearError = error_h.clearError;
const events_h = @import("sdl3/events.zig");
pub const EventType = events_h.EventType;
pub const CommonEvent = events_h.CommonEvent;
pub const DisplayEvent = events_h.DisplayEvent;
pub const WindowEvent = events_h.WindowEvent;
pub const KeyboardDeviceEvent = events_h.KeyboardDeviceEvent;
pub const KeyboardEvent = events_h.KeyboardEvent;
pub const TextEditingEvent = events_h.TextEditingEvent;
pub const TextEditingCandidatesEvent = events_h.TextEditingCandidatesEvent;
pub const TextInputEvent = events_h.TextInputEvent;
pub const MouseDeviceEvent = events_h.MouseDeviceEvent;
pub const MouseMotionEvent = events_h.MouseMotionEvent;
pub const MouseButtonEvent = events_h.MouseButtonEvent;
pub const MouseWheelEvent = events_h.MouseWheelEvent;
pub const JoyAxisEvent = events_h.JoyAxisEvent;
pub const JoyBallEvent = events_h.JoyBallEvent;
pub const JoyHatEvent = events_h.JoyHatEvent;
pub const JoyButtonEvent = events_h.JoyButtonEvent;
pub const JoyDeviceEvent = events_h.JoyDeviceEvent;
pub const JoyBatteryEvent = events_h.JoyBatteryEvent;
pub const GamepadAxisEvent = events_h.GamepadAxisEvent;
pub const GamepadButtonEvent = events_h.GamepadButtonEvent;
pub const GamepadDeviceEvent = events_h.GamepadDeviceEvent;
pub const GamepadTouchpadEvent = events_h.GamepadTouchpadEvent;
pub const GamepadSensorEvent = events_h.GamepadSensorEvent;
pub const AudioDeviceEvent = events_h.AudioDeviceEvent;
pub const CameraDeviceEvent = events_h.CameraDeviceEvent;
pub const RenderEvent = events_h.RenderEvent;
pub const TouchFingerEvent = events_h.TouchFingerEvent;
pub const PinchFingerEvent = events_h.PinchFingerEvent;
pub const PenProximityEvent = events_h.PenProximityEvent;
pub const PenMotionEvent = events_h.PenMotionEvent;
pub const PenTouchEvent = events_h.PenTouchEvent;
pub const PenButtonEvent = events_h.PenButtonEvent;
pub const PenAxisEvent = events_h.PenAxisEvent;
pub const DropEvent = events_h.DropEvent;
pub const ClipboardEvent = events_h.ClipboardEvent;
pub const SensorEvent = events_h.SensorEvent;
pub const QuitEvent = events_h.QuitEvent;
pub const UserEvent = events_h.UserEvent;
pub const Event = events_h.Event;
pub const pumpEvents = events_h.pumpEvents;
pub const EventAction = events_h.EventAction;
pub const peepEvents = events_h.peepEvents;
pub const hasEvent = events_h.hasEvent;
pub const hasEvents = events_h.hasEvents;
pub const flushEvent = events_h.flushEvent;
pub const flushEvents = events_h.flushEvents;
pub const pollEvent = events_h.pollEvent;
pub const waitEvent = events_h.waitEvent;
pub const waitEventTimeout = events_h.waitEventTimeout;
pub const pushEvent = events_h.pushEvent;
pub const EventFilter = events_h.EventFilter;
pub const setEventFilter = events_h.setEventFilter;
pub const getEventFilter = events_h.getEventFilter;
pub const addEventWatch = events_h.addEventWatch;
pub const removeEventWatch = events_h.removeEventWatch;
pub const filterEvents = events_h.filterEvents;
pub const setEventEnabled = events_h.setEventEnabled;
pub const eventEnabled = events_h.eventEnabled;
pub const registerEvents = events_h.registerEvents;
pub const getWindowFromEvent = events_h.getWindowFromEvent;
pub const getEventDescription = events_h.getEventDescription;
const filesystem_h = @import("sdl3/filesystem.zig");
pub const getBasePath = filesystem_h.getBasePath;
pub const getPrefPath = filesystem_h.getPrefPath;
pub const Folder = filesystem_h.Folder;
pub const getUserFolder = filesystem_h.getUserFolder;
pub const PathType = filesystem_h.PathType;
pub const PathInfo = filesystem_h.PathInfo;
pub const GlobFlags = filesystem_h.GlobFlags;
pub const createDirectory = filesystem_h.createDirectory;
pub const EnumerationResult = filesystem_h.EnumerationResult;
pub const EnumerateDirectoryCallback = filesystem_h.EnumerateDirectoryCallback;
pub const enumerateDirectory = filesystem_h.enumerateDirectory;
pub const removePath = filesystem_h.removePath;
pub const renamePath = filesystem_h.renamePath;
pub const copyFile = filesystem_h.copyFile;
pub const getPathInfo = filesystem_h.getPathInfo;
pub const globDirectory = filesystem_h.globDirectory;
pub const getCurrentDirectory = filesystem_h.getCurrentDirectory;
const gamepad_h = @import("sdl3/gamepad.zig");
pub const Gamepad = gamepad_h.Gamepad;
pub const GamepadType = gamepad_h.GamepadType;
pub const GamepadButton = gamepad_h.GamepadButton;
pub const GamepadButtonLabel = gamepad_h.GamepadButtonLabel;
pub const GamepadAxis = gamepad_h.GamepadAxis;
pub const GamepadBindingType = gamepad_h.GamepadBindingType;
pub const GamepadBinding = gamepad_h.GamepadBinding;
pub const addGamepadMapping = gamepad_h.addGamepadMapping;
pub const addGamepadMappingsFromIO = gamepad_h.addGamepadMappingsFromIO;
pub const addGamepadMappingsFromFile = gamepad_h.addGamepadMappingsFromFile;
pub const reloadGamepadMappings = gamepad_h.reloadGamepadMappings;
pub const getGamepadMappings = gamepad_h.getGamepadMappings;
pub const getGamepadMappingForGUID = gamepad_h.getGamepadMappingForGUID;
pub const getGamepadMapping = gamepad_h.getGamepadMapping;
pub const setGamepadMapping = gamepad_h.setGamepadMapping;
pub const hasGamepad = gamepad_h.hasGamepad;
pub const getGamepads = gamepad_h.getGamepads;
pub const isGamepad = gamepad_h.isGamepad;
pub const getGamepadNameForId = gamepad_h.getGamepadNameForId;
pub const getGamepadPathForId = gamepad_h.getGamepadPathForId;
pub const getGamepadPlayerIndexForId = gamepad_h.getGamepadPlayerIndexForId;
pub const getGamepadGUIDForId = gamepad_h.getGamepadGUIDForId;
pub const getGamepadVendorForId = gamepad_h.getGamepadVendorForId;
pub const getGamepadProductForId = gamepad_h.getGamepadProductForId;
pub const getGamepadProductVersionForId = gamepad_h.getGamepadProductVersionForId;
pub const getGamepadTypeForId = gamepad_h.getGamepadTypeForId;
pub const getRealGamepadTypeForId = gamepad_h.getRealGamepadTypeForId;
pub const getGamepadMappingForId = gamepad_h.getGamepadMappingForId;
pub const openGamepad = gamepad_h.openGamepad;
pub const getGamepadFromId = gamepad_h.getGamepadFromId;
pub const getGamepadFromPlayerIndex = gamepad_h.getGamepadFromPlayerIndex;
pub const getGamepadProperties = gamepad_h.getGamepadProperties;
pub const getGamepadId = gamepad_h.getGamepadId;
pub const getGamepadName = gamepad_h.getGamepadName;
pub const getGamepadPath = gamepad_h.getGamepadPath;
pub const getGamepadType = gamepad_h.getGamepadType;
pub const getRealGamepadType = gamepad_h.getRealGamepadType;
pub const getGamepadPlayerIndex = gamepad_h.getGamepadPlayerIndex;
pub const setGamepadPlayerIndex = gamepad_h.setGamepadPlayerIndex;
pub const getGamepadVendor = gamepad_h.getGamepadVendor;
pub const getGamepadProduct = gamepad_h.getGamepadProduct;
pub const getGamepadProductVersion = gamepad_h.getGamepadProductVersion;
pub const getGamepadFirmwareVersion = gamepad_h.getGamepadFirmwareVersion;
pub const getGamepadSerial = gamepad_h.getGamepadSerial;
pub const getGamepadSteamHandle = gamepad_h.getGamepadSteamHandle;
pub const getGamepadConnectionState = gamepad_h.getGamepadConnectionState;
pub const getGamepadPowerInfo = gamepad_h.getGamepadPowerInfo;
pub const gamepadConnected = gamepad_h.gamepadConnected;
pub const getGamepadJoystick = gamepad_h.getGamepadJoystick;
pub const setGamepadEventsEnabled = gamepad_h.setGamepadEventsEnabled;
pub const gamepadEventsEnabled = gamepad_h.gamepadEventsEnabled;
pub const getGamepadBindings = gamepad_h.getGamepadBindings;
pub const updateGamepads = gamepad_h.updateGamepads;
pub const getGamepadTypeFromString = gamepad_h.getGamepadTypeFromString;
pub const getGamepadStringForType = gamepad_h.getGamepadStringForType;
pub const getGamepadAxisFromString = gamepad_h.getGamepadAxisFromString;
pub const getGamepadStringForAxis = gamepad_h.getGamepadStringForAxis;
pub const gamepadHasAxis = gamepad_h.gamepadHasAxis;
pub const getGamepadAxis = gamepad_h.getGamepadAxis;
pub const getGamepadButtonFromString = gamepad_h.getGamepadButtonFromString;
pub const getGamepadStringForButton = gamepad_h.getGamepadStringForButton;
pub const gamepadHasButton = gamepad_h.gamepadHasButton;
pub const getGamepadButton = gamepad_h.getGamepadButton;
pub const getGamepadButtonLabelForType = gamepad_h.getGamepadButtonLabelForType;
pub const getGamepadButtonLabel = gamepad_h.getGamepadButtonLabel;
pub const getNumGamepadTouchpads = gamepad_h.getNumGamepadTouchpads;
pub const getNumGamepadTouchpadFingers = gamepad_h.getNumGamepadTouchpadFingers;
pub const getGamepadTouchpadFinger = gamepad_h.getGamepadTouchpadFinger;
pub const gamepadHasSensor = gamepad_h.gamepadHasSensor;
pub const setGamepadSensorEnabled = gamepad_h.setGamepadSensorEnabled;
pub const gamepadSensorEnabled = gamepad_h.gamepadSensorEnabled;
pub const getGamepadSensorDataRate = gamepad_h.getGamepadSensorDataRate;
pub const getGamepadSensorData = gamepad_h.getGamepadSensorData;
pub const rumbleGamepad = gamepad_h.rumbleGamepad;
pub const rumbleGamepadTriggers = gamepad_h.rumbleGamepadTriggers;
pub const setGamepadLED = gamepad_h.setGamepadLED;
pub const sendGamepadEffect = gamepad_h.sendGamepadEffect;
pub const closeGamepad = gamepad_h.closeGamepad;
pub const getGamepadAppleSFSymbolsNameForButton = gamepad_h.getGamepadAppleSFSymbolsNameForButton;
pub const getGamepadAppleSFSymbolsNameForAxis = gamepad_h.getGamepadAppleSFSymbolsNameForAxis;
const gpu_h = @import("sdl3/gpu.zig");
pub const GPUDevice = gpu_h.GPUDevice;
pub const GPUBuffer = gpu_h.GPUBuffer;
pub const GPUTransferBuffer = gpu_h.GPUTransferBuffer;
pub const GPUTexture = gpu_h.GPUTexture;
pub const GPUSampler = gpu_h.GPUSampler;
pub const GPUShader = gpu_h.GPUShader;
pub const GPUComputePipeline = gpu_h.GPUComputePipeline;
pub const GPUGraphicsPipeline = gpu_h.GPUGraphicsPipeline;
pub const GPUCommandBuffer = gpu_h.GPUCommandBuffer;
pub const GPURenderPass = gpu_h.GPURenderPass;
pub const GPUComputePass = gpu_h.GPUComputePass;
pub const GPUCopyPass = gpu_h.GPUCopyPass;
pub const GPUFence = gpu_h.GPUFence;
pub const GPUPrimitiveType = gpu_h.GPUPrimitiveType;
pub const GPULoadOp = gpu_h.GPULoadOp;
pub const GPUStoreOp = gpu_h.GPUStoreOp;
pub const GPUIndexElementSize = gpu_h.GPUIndexElementSize;
pub const GPUTextureFormat = gpu_h.GPUTextureFormat;
pub const GPUTextureUsageFlags = gpu_h.GPUTextureUsageFlags;
pub const GPUTextureType = gpu_h.GPUTextureType;
pub const GPUSampleCount = gpu_h.GPUSampleCount;
pub const GPUCubeMapFace = gpu_h.GPUCubeMapFace;
pub const GPUBufferUsageFlags = gpu_h.GPUBufferUsageFlags;
pub const GPUTransferBufferUsage = gpu_h.GPUTransferBufferUsage;
pub const GPUShaderStage = gpu_h.GPUShaderStage;
pub const GPUShaderFormat = gpu_h.GPUShaderFormat;
pub const GPUVertexElementFormat = gpu_h.GPUVertexElementFormat;
pub const GPUVertexInputRate = gpu_h.GPUVertexInputRate;
pub const GPUFillMode = gpu_h.GPUFillMode;
pub const GPUCullMode = gpu_h.GPUCullMode;
pub const GPUFrontFace = gpu_h.GPUFrontFace;
pub const GPUCompareOp = gpu_h.GPUCompareOp;
pub const GPUStencilOp = gpu_h.GPUStencilOp;
pub const GPUBlendOp = gpu_h.GPUBlendOp;
pub const GPUBlendFactor = gpu_h.GPUBlendFactor;
pub const GPUColorComponentFlags = gpu_h.GPUColorComponentFlags;
pub const GPUFilter = gpu_h.GPUFilter;
pub const GPUSamplerMipmapMode = gpu_h.GPUSamplerMipmapMode;
pub const GPUSamplerAddressMode = gpu_h.GPUSamplerAddressMode;
pub const GPUPresentMode = gpu_h.GPUPresentMode;
pub const GPUSwapchainComposition = gpu_h.GPUSwapchainComposition;
pub const GPUViewport = gpu_h.GPUViewport;
pub const GPUTextureTransferInfo = gpu_h.GPUTextureTransferInfo;
pub const GPUTransferBufferLocation = gpu_h.GPUTransferBufferLocation;
pub const GPUTextureLocation = gpu_h.GPUTextureLocation;
pub const GPUTextureRegion = gpu_h.GPUTextureRegion;
pub const GPUBlitRegion = gpu_h.GPUBlitRegion;
pub const GPUBufferLocation = gpu_h.GPUBufferLocation;
pub const GPUBufferRegion = gpu_h.GPUBufferRegion;
pub const GPUIndirectDrawCommand = gpu_h.GPUIndirectDrawCommand;
pub const GPUIndexedIndirectDrawCommand = gpu_h.GPUIndexedIndirectDrawCommand;
pub const GPUIndirectDispatchCommand = gpu_h.GPUIndirectDispatchCommand;
pub const GPUSamplerCreateInfo = gpu_h.GPUSamplerCreateInfo;
pub const GPUVertexBufferDescription = gpu_h.GPUVertexBufferDescription;
pub const GPUVertexAttribute = gpu_h.GPUVertexAttribute;
pub const GPUVertexInputState = gpu_h.GPUVertexInputState;
pub const GPUStencilOpState = gpu_h.GPUStencilOpState;
pub const GPUColorTargetBlendState = gpu_h.GPUColorTargetBlendState;
pub const GPUShaderCreateInfo = gpu_h.GPUShaderCreateInfo;
pub const GPUTextureCreateInfo = gpu_h.GPUTextureCreateInfo;
pub const GPUBufferCreateInfo = gpu_h.GPUBufferCreateInfo;
pub const GPUTransferBufferCreateInfo = gpu_h.GPUTransferBufferCreateInfo;
pub const GPURasterizerState = gpu_h.GPURasterizerState;
pub const GPUMultisampleState = gpu_h.GPUMultisampleState;
pub const GPUDepthStencilState = gpu_h.GPUDepthStencilState;
pub const GPUColorTargetDescription = gpu_h.GPUColorTargetDescription;
pub const GPUGraphicsPipelineTargetInfo = gpu_h.GPUGraphicsPipelineTargetInfo;
pub const GPUGraphicsPipelineCreateInfo = gpu_h.GPUGraphicsPipelineCreateInfo;
pub const GPUComputePipelineCreateInfo = gpu_h.GPUComputePipelineCreateInfo;
pub const GPUColorTargetInfo = gpu_h.GPUColorTargetInfo;
pub const GPUDepthStencilTargetInfo = gpu_h.GPUDepthStencilTargetInfo;
pub const GPUBlitInfo = gpu_h.GPUBlitInfo;
pub const GPUBufferBinding = gpu_h.GPUBufferBinding;
pub const GPUTextureSamplerBinding = gpu_h.GPUTextureSamplerBinding;
pub const GPUStorageBufferReadWriteBinding = gpu_h.GPUStorageBufferReadWriteBinding;
pub const GPUStorageTextureReadWriteBinding = gpu_h.GPUStorageTextureReadWriteBinding;
pub const gpuSupportsShaderFormats = gpu_h.gpuSupportsShaderFormats;
pub const gpuSupportsProperties = gpu_h.gpuSupportsProperties;
pub const createGPUDevice = gpu_h.createGPUDevice;
pub const createGPUDeviceWithProperties = gpu_h.createGPUDeviceWithProperties;
pub const GPUVulkanOptions = gpu_h.GPUVulkanOptions;
pub const destroyGPUDevice = gpu_h.destroyGPUDevice;
pub const getNumGPUDrivers = gpu_h.getNumGPUDrivers;
pub const getGPUDriver = gpu_h.getGPUDriver;
pub const getGPUDeviceDriver = gpu_h.getGPUDeviceDriver;
pub const getGPUShaderFormats = gpu_h.getGPUShaderFormats;
pub const getGPUDeviceProperties = gpu_h.getGPUDeviceProperties;
pub const createGPUComputePipeline = gpu_h.createGPUComputePipeline;
pub const createGPUGraphicsPipeline = gpu_h.createGPUGraphicsPipeline;
pub const createGPUSampler = gpu_h.createGPUSampler;
pub const createGPUShader = gpu_h.createGPUShader;
pub const createGPUTexture = gpu_h.createGPUTexture;
pub const createGPUBuffer = gpu_h.createGPUBuffer;
pub const createGPUTransferBuffer = gpu_h.createGPUTransferBuffer;
pub const setGPUBufferName = gpu_h.setGPUBufferName;
pub const setGPUTextureName = gpu_h.setGPUTextureName;
pub const insertGPUDebugLabel = gpu_h.insertGPUDebugLabel;
pub const pushGPUDebugGroup = gpu_h.pushGPUDebugGroup;
pub const popGPUDebugGroup = gpu_h.popGPUDebugGroup;
pub const releaseGPUTexture = gpu_h.releaseGPUTexture;
pub const releaseGPUSampler = gpu_h.releaseGPUSampler;
pub const releaseGPUBuffer = gpu_h.releaseGPUBuffer;
pub const releaseGPUTransferBuffer = gpu_h.releaseGPUTransferBuffer;
pub const releaseGPUComputePipeline = gpu_h.releaseGPUComputePipeline;
pub const releaseGPUShader = gpu_h.releaseGPUShader;
pub const releaseGPUGraphicsPipeline = gpu_h.releaseGPUGraphicsPipeline;
pub const acquireGPUCommandBuffer = gpu_h.acquireGPUCommandBuffer;
pub const pushGPUVertexUniformData = gpu_h.pushGPUVertexUniformData;
pub const pushGPUFragmentUniformData = gpu_h.pushGPUFragmentUniformData;
pub const pushGPUComputeUniformData = gpu_h.pushGPUComputeUniformData;
pub const beginGPURenderPass = gpu_h.beginGPURenderPass;
pub const bindGPUGraphicsPipeline = gpu_h.bindGPUGraphicsPipeline;
pub const setGPUViewport = gpu_h.setGPUViewport;
pub const setGPUScissor = gpu_h.setGPUScissor;
pub const setGPUBlendConstants = gpu_h.setGPUBlendConstants;
pub const setGPUStencilReference = gpu_h.setGPUStencilReference;
pub const bindGPUVertexBuffers = gpu_h.bindGPUVertexBuffers;
pub const bindGPUIndexBuffer = gpu_h.bindGPUIndexBuffer;
pub const bindGPUVertexSamplers = gpu_h.bindGPUVertexSamplers;
pub const bindGPUVertexStorageTextures = gpu_h.bindGPUVertexStorageTextures;
pub const bindGPUVertexStorageBuffers = gpu_h.bindGPUVertexStorageBuffers;
pub const bindGPUFragmentSamplers = gpu_h.bindGPUFragmentSamplers;
pub const bindGPUFragmentStorageTextures = gpu_h.bindGPUFragmentStorageTextures;
pub const bindGPUFragmentStorageBuffers = gpu_h.bindGPUFragmentStorageBuffers;
pub const drawGPUIndexedPrimitives = gpu_h.drawGPUIndexedPrimitives;
pub const drawGPUPrimitives = gpu_h.drawGPUPrimitives;
pub const drawGPUPrimitivesIndirect = gpu_h.drawGPUPrimitivesIndirect;
pub const drawGPUIndexedPrimitivesIndirect = gpu_h.drawGPUIndexedPrimitivesIndirect;
pub const endGPURenderPass = gpu_h.endGPURenderPass;
pub const beginGPUComputePass = gpu_h.beginGPUComputePass;
pub const bindGPUComputePipeline = gpu_h.bindGPUComputePipeline;
pub const bindGPUComputeSamplers = gpu_h.bindGPUComputeSamplers;
pub const bindGPUComputeStorageTextures = gpu_h.bindGPUComputeStorageTextures;
pub const bindGPUComputeStorageBuffers = gpu_h.bindGPUComputeStorageBuffers;
pub const dispatchGPUCompute = gpu_h.dispatchGPUCompute;
pub const dispatchGPUComputeIndirect = gpu_h.dispatchGPUComputeIndirect;
pub const endGPUComputePass = gpu_h.endGPUComputePass;
pub const mapGPUTransferBuffer = gpu_h.mapGPUTransferBuffer;
pub const unmapGPUTransferBuffer = gpu_h.unmapGPUTransferBuffer;
pub const beginGPUCopyPass = gpu_h.beginGPUCopyPass;
pub const uploadToGPUTexture = gpu_h.uploadToGPUTexture;
pub const uploadToGPUBuffer = gpu_h.uploadToGPUBuffer;
pub const copyGPUTextureToTexture = gpu_h.copyGPUTextureToTexture;
pub const copyGPUBufferToBuffer = gpu_h.copyGPUBufferToBuffer;
pub const downloadFromGPUTexture = gpu_h.downloadFromGPUTexture;
pub const downloadFromGPUBuffer = gpu_h.downloadFromGPUBuffer;
pub const endGPUCopyPass = gpu_h.endGPUCopyPass;
pub const generateMipmapsForGPUTexture = gpu_h.generateMipmapsForGPUTexture;
pub const blitGPUTexture = gpu_h.blitGPUTexture;
pub const windowSupportsGPUSwapchainComposition = gpu_h.windowSupportsGPUSwapchainComposition;
pub const windowSupportsGPUPresentMode = gpu_h.windowSupportsGPUPresentMode;
pub const claimWindowForGPUDevice = gpu_h.claimWindowForGPUDevice;
pub const releaseWindowFromGPUDevice = gpu_h.releaseWindowFromGPUDevice;
pub const setGPUSwapchainParameters = gpu_h.setGPUSwapchainParameters;
pub const setGPUAllowedFramesInFlight = gpu_h.setGPUAllowedFramesInFlight;
pub const getGPUSwapchainTextureFormat = gpu_h.getGPUSwapchainTextureFormat;
pub const acquireGPUSwapchainTexture = gpu_h.acquireGPUSwapchainTexture;
pub const waitForGPUSwapchain = gpu_h.waitForGPUSwapchain;
pub const waitAndAcquireGPUSwapchainTexture = gpu_h.waitAndAcquireGPUSwapchainTexture;
pub const submitGPUCommandBuffer = gpu_h.submitGPUCommandBuffer;
pub const submitGPUCommandBufferAndAcquireFence = gpu_h.submitGPUCommandBufferAndAcquireFence;
pub const cancelGPUCommandBuffer = gpu_h.cancelGPUCommandBuffer;
pub const waitForGPUIdle = gpu_h.waitForGPUIdle;
pub const waitForGPUFences = gpu_h.waitForGPUFences;
pub const queryGPUFence = gpu_h.queryGPUFence;
pub const releaseGPUFence = gpu_h.releaseGPUFence;
pub const gpuTextureFormatTexelBlockSize = gpu_h.gpuTextureFormatTexelBlockSize;
pub const gpuTextureSupportsFormat = gpu_h.gpuTextureSupportsFormat;
pub const gpuTextureSupportsSampleCount = gpu_h.gpuTextureSupportsSampleCount;
pub const calculateGPUTextureFormatSize = gpu_h.calculateGPUTextureFormatSize;
pub const getPixelFormatFromGPUTextureFormat = gpu_h.getPixelFormatFromGPUTextureFormat;
pub const getGPUTextureFormatFromPixelFormat = gpu_h.getGPUTextureFormatFromPixelFormat;
pub const gdkSuspendGPU = gpu_h.gdkSuspendGPU;
pub const gdkResumeGPU = gpu_h.gdkResumeGPU;
const guid_h = @import("sdl3/guid.zig");
pub const GUID = guid_h.GUID;
pub const guidToString = guid_h.guidToString;
pub const stringToGUID = guid_h.stringToGUID;
const haptic_h = @import("sdl3/haptic.zig");
pub const Haptic = haptic_h.Haptic;
pub const HapticEffectType = haptic_h.HapticEffectType;
pub const haptic_constant = haptic_h.haptic_constant;
pub const haptic_sine = haptic_h.haptic_sine;
pub const haptic_square = haptic_h.haptic_square;
pub const haptic_triangle = haptic_h.haptic_triangle;
pub const haptic_sawtoothup = haptic_h.haptic_sawtoothup;
pub const haptic_sawtoothdown = haptic_h.haptic_sawtoothdown;
pub const haptic_ramp = haptic_h.haptic_ramp;
pub const haptic_spring = haptic_h.haptic_spring;
pub const haptic_damper = haptic_h.haptic_damper;
pub const haptic_inertia = haptic_h.haptic_inertia;
pub const haptic_friction = haptic_h.haptic_friction;
pub const haptic_leftright = haptic_h.haptic_leftright;
pub const haptic_reserved1 = haptic_h.haptic_reserved1;
pub const haptic_reserved2 = haptic_h.haptic_reserved2;
pub const haptic_reserved3 = haptic_h.haptic_reserved3;
pub const haptic_custom = haptic_h.haptic_custom;
pub const haptic_gain = haptic_h.haptic_gain;
pub const haptic_autocenter = haptic_h.haptic_autocenter;
pub const haptic_status = haptic_h.haptic_status;
pub const haptic_pause = haptic_h.haptic_pause;
pub const HapticFeatures = haptic_h.HapticFeatures;
pub const HapticDirectionType = haptic_h.HapticDirectionType;
pub const haptic_infinity = haptic_h.haptic_infinity;
pub const HapticEffectId = haptic_h.HapticEffectId;
pub const HapticDirection = haptic_h.HapticDirection;
pub const HapticConstant = haptic_h.HapticConstant;
pub const HapticPeriodic = haptic_h.HapticPeriodic;
pub const HapticCondition = haptic_h.HapticCondition;
pub const HapticRamp = haptic_h.HapticRamp;
pub const HapticLeftRight = haptic_h.HapticLeftRight;
pub const HapticCustom = haptic_h.HapticCustom;
pub const HapticEffect = haptic_h.HapticEffect;
pub const HapticId = haptic_h.HapticId;
pub const getHaptics = haptic_h.getHaptics;
pub const getHapticNameForId = haptic_h.getHapticNameForId;
pub const openHaptic = haptic_h.openHaptic;
pub const getHapticFromId = haptic_h.getHapticFromId;
pub const getHapticId = haptic_h.getHapticId;
pub const getHapticName = haptic_h.getHapticName;
pub const isMouseHaptic = haptic_h.isMouseHaptic;
pub const openHapticFromMouse = haptic_h.openHapticFromMouse;
pub const isJoystickHaptic = haptic_h.isJoystickHaptic;
pub const openHapticFromJoystick = haptic_h.openHapticFromJoystick;
pub const closeHaptic = haptic_h.closeHaptic;
pub const getMaxHapticEffects = haptic_h.getMaxHapticEffects;
pub const getMaxHapticEffectsPlaying = haptic_h.getMaxHapticEffectsPlaying;
pub const getHapticFeatures = haptic_h.getHapticFeatures;
pub const getNumHapticAxes = haptic_h.getNumHapticAxes;
pub const hapticEffectSupported = haptic_h.hapticEffectSupported;
pub const createHapticEffect = haptic_h.createHapticEffect;
pub const updateHapticEffect = haptic_h.updateHapticEffect;
pub const runHapticEffect = haptic_h.runHapticEffect;
pub const stopHapticEffect = haptic_h.stopHapticEffect;
pub const destroyHapticEffect = haptic_h.destroyHapticEffect;
pub const getHapticEffectStatus = haptic_h.getHapticEffectStatus;
pub const setHapticGain = haptic_h.setHapticGain;
pub const setHapticAutocenter = haptic_h.setHapticAutocenter;
pub const pauseHaptic = haptic_h.pauseHaptic;
pub const resumeHaptic = haptic_h.resumeHaptic;
pub const stopHapticEffects = haptic_h.stopHapticEffects;
pub const hapticRumbleSupported = haptic_h.hapticRumbleSupported;
pub const initHapticRumble = haptic_h.initHapticRumble;
pub const playHapticRumble = haptic_h.playHapticRumble;
pub const stopHapticRumble = haptic_h.stopHapticRumble;
const hidapi_h = @import("sdl3/hidapi.zig");
pub const hid = hidapi_h.hid;
const hints_h = @import("sdl3/hints.zig");
pub const hint_allow_alt_tab_while_grabbed = hints_h.hint_allow_alt_tab_while_grabbed;
pub const hint_android_allow_recreate_activity = hints_h.hint_android_allow_recreate_activity;
pub const hint_android_block_on_pause = hints_h.hint_android_block_on_pause;
pub const hint_android_low_latency_audio = hints_h.hint_android_low_latency_audio;
pub const hint_android_aaudio_input_preset = hints_h.hint_android_aaudio_input_preset;
pub const hint_android_trap_back_button = hints_h.hint_android_trap_back_button;
pub const hint_app_id = hints_h.hint_app_id;
pub const hint_app_name = hints_h.hint_app_name;
pub const hint_apple_tv_controller_ui_events = hints_h.hint_apple_tv_controller_ui_events;
pub const hint_apple_tv_remote_allow_rotation = hints_h.hint_apple_tv_remote_allow_rotation;
pub const hint_audio_alsa_default_device = hints_h.hint_audio_alsa_default_device;
pub const hint_audio_alsa_default_playback_device = hints_h.hint_audio_alsa_default_playback_device;
pub const hint_audio_alsa_default_recording_device = hints_h.hint_audio_alsa_default_recording_device;
pub const hint_audio_category = hints_h.hint_audio_category;
pub const hint_audio_channels = hints_h.hint_audio_channels;
pub const hint_audio_device_app_icon_name = hints_h.hint_audio_device_app_icon_name;
pub const hint_audio_device_sample_frames = hints_h.hint_audio_device_sample_frames;
pub const hint_audio_device_stream_name = hints_h.hint_audio_device_stream_name;
pub const hint_audio_device_stream_role = hints_h.hint_audio_device_stream_role;
pub const hint_audio_device_raw_stream = hints_h.hint_audio_device_raw_stream;
pub const hint_audio_disk_input_file = hints_h.hint_audio_disk_input_file;
pub const hint_audio_disk_output_file = hints_h.hint_audio_disk_output_file;
pub const hint_audio_disk_timescale = hints_h.hint_audio_disk_timescale;
pub const hint_audio_driver = hints_h.hint_audio_driver;
pub const hint_audio_dummy_timescale = hints_h.hint_audio_dummy_timescale;
pub const hint_audio_format = hints_h.hint_audio_format;
pub const hint_audio_frequency = hints_h.hint_audio_frequency;
pub const hint_audio_include_monitors = hints_h.hint_audio_include_monitors;
pub const hint_auto_update_joysticks = hints_h.hint_auto_update_joysticks;
pub const hint_auto_update_sensors = hints_h.hint_auto_update_sensors;
pub const hint_bmp_save_legacy_format = hints_h.hint_bmp_save_legacy_format;
pub const hint_camera_driver = hints_h.hint_camera_driver;
pub const hint_cpu_feature_mask = hints_h.hint_cpu_feature_mask;
pub const hint_joystick_directinput = hints_h.hint_joystick_directinput;
pub const hint_file_dialog_driver = hints_h.hint_file_dialog_driver;
pub const hint_display_usable_bounds = hints_h.hint_display_usable_bounds;
pub const hint_invalid_param_checks = hints_h.hint_invalid_param_checks;
pub const hint_emscripten_asyncify = hints_h.hint_emscripten_asyncify;
pub const hint_emscripten_canvas_selector = hints_h.hint_emscripten_canvas_selector;
pub const hint_emscripten_keyboard_element = hints_h.hint_emscripten_keyboard_element;
pub const hint_enable_screen_keyboard = hints_h.hint_enable_screen_keyboard;
pub const hint_enable_steam_screen_keyboard = hints_h.hint_enable_steam_screen_keyboard;
pub const hint_evdev_devices = hints_h.hint_evdev_devices;
pub const hint_event_logging = hints_h.hint_event_logging;
pub const hint_force_raisewindow = hints_h.hint_force_raisewindow;
pub const hint_framebuffer_acceleration = hints_h.hint_framebuffer_acceleration;
pub const hint_gamecontrollerconfig = hints_h.hint_gamecontrollerconfig;
pub const hint_gamecontrollerconfig_file = hints_h.hint_gamecontrollerconfig_file;
pub const hint_gamecontrollertype = hints_h.hint_gamecontrollertype;
pub const hint_gamecontroller_ignore_devices = hints_h.hint_gamecontroller_ignore_devices;
pub const hint_gamecontroller_ignore_devices_except = hints_h.hint_gamecontroller_ignore_devices_except;
pub const hint_gamecontroller_sensor_fusion = hints_h.hint_gamecontroller_sensor_fusion;
pub const hint_gdk_textinput_default_text = hints_h.hint_gdk_textinput_default_text;
pub const hint_gdk_textinput_description = hints_h.hint_gdk_textinput_description;
pub const hint_gdk_textinput_max_length = hints_h.hint_gdk_textinput_max_length;
pub const hint_gdk_textinput_scope = hints_h.hint_gdk_textinput_scope;
pub const hint_gdk_textinput_title = hints_h.hint_gdk_textinput_title;
pub const hint_hidapi_libusb = hints_h.hint_hidapi_libusb;
pub const hint_hidapi_libusb_gamecube = hints_h.hint_hidapi_libusb_gamecube;
pub const hint_hidapi_libusb_whitelist = hints_h.hint_hidapi_libusb_whitelist;
pub const hint_hidapi_udev = hints_h.hint_hidapi_udev;
pub const hint_gpu_driver = hints_h.hint_gpu_driver;
pub const hint_hidapi_enumerate_only_controllers = hints_h.hint_hidapi_enumerate_only_controllers;
pub const hint_hidapi_ignore_devices = hints_h.hint_hidapi_ignore_devices;
pub const hint_ime_implemented_ui = hints_h.hint_ime_implemented_ui;
pub const hint_ios_hide_home_indicator = hints_h.hint_ios_hide_home_indicator;
pub const hint_joystick_allow_background_events = hints_h.hint_joystick_allow_background_events;
pub const hint_joystick_arcadestick_devices = hints_h.hint_joystick_arcadestick_devices;
pub const hint_joystick_arcadestick_devices_excluded = hints_h.hint_joystick_arcadestick_devices_excluded;
pub const hint_joystick_blacklist_devices = hints_h.hint_joystick_blacklist_devices;
pub const hint_joystick_blacklist_devices_excluded = hints_h.hint_joystick_blacklist_devices_excluded;
pub const hint_joystick_device = hints_h.hint_joystick_device;
pub const hint_joystick_enhanced_reports = hints_h.hint_joystick_enhanced_reports;
pub const hint_joystick_flightstick_devices = hints_h.hint_joystick_flightstick_devices;
pub const hint_joystick_flightstick_devices_excluded = hints_h.hint_joystick_flightstick_devices_excluded;
pub const hint_joystick_gameinput = hints_h.hint_joystick_gameinput;
pub const hint_joystick_gameinput_raw = hints_h.hint_joystick_gameinput_raw;
pub const hint_joystick_gamecube_devices = hints_h.hint_joystick_gamecube_devices;
pub const hint_joystick_gamecube_devices_excluded = hints_h.hint_joystick_gamecube_devices_excluded;
pub const hint_joystick_hidapi = hints_h.hint_joystick_hidapi;
pub const hint_joystick_hidapi_combine_joy_cons = hints_h.hint_joystick_hidapi_combine_joy_cons;
pub const hint_joystick_hidapi_gamecube = hints_h.hint_joystick_hidapi_gamecube;
pub const hint_joystick_hidapi_gamecube_rumble_brake = hints_h.hint_joystick_hidapi_gamecube_rumble_brake;
pub const hint_joystick_hidapi_joy_cons = hints_h.hint_joystick_hidapi_joy_cons;
pub const hint_joystick_hidapi_joycon_home_led = hints_h.hint_joystick_hidapi_joycon_home_led;
pub const hint_joystick_hidapi_luna = hints_h.hint_joystick_hidapi_luna;
pub const hint_joystick_hidapi_nintendo_classic = hints_h.hint_joystick_hidapi_nintendo_classic;
pub const hint_joystick_hidapi_ps3 = hints_h.hint_joystick_hidapi_ps3;
pub const hint_joystick_hidapi_ps3_sixaxis_driver = hints_h.hint_joystick_hidapi_ps3_sixaxis_driver;
pub const hint_joystick_hidapi_ps4 = hints_h.hint_joystick_hidapi_ps4;
pub const hint_joystick_hidapi_ps4_report_interval = hints_h.hint_joystick_hidapi_ps4_report_interval;
pub const hint_joystick_hidapi_ps5 = hints_h.hint_joystick_hidapi_ps5;
pub const hint_joystick_hidapi_ps5_player_led = hints_h.hint_joystick_hidapi_ps5_player_led;
pub const hint_joystick_hidapi_shield = hints_h.hint_joystick_hidapi_shield;
pub const hint_joystick_hidapi_stadia = hints_h.hint_joystick_hidapi_stadia;
pub const hint_joystick_hidapi_steam = hints_h.hint_joystick_hidapi_steam;
pub const hint_joystick_hidapi_steam_home_led = hints_h.hint_joystick_hidapi_steam_home_led;
pub const hint_joystick_hidapi_steamdeck = hints_h.hint_joystick_hidapi_steamdeck;
pub const hint_joystick_hidapi_steam_hori = hints_h.hint_joystick_hidapi_steam_hori;
pub const hint_joystick_hidapi_lg4ff = hints_h.hint_joystick_hidapi_lg4ff;
pub const hint_joystick_hidapi_8bitdo = hints_h.hint_joystick_hidapi_8bitdo;
pub const hint_joystick_hidapi_sinput = hints_h.hint_joystick_hidapi_sinput;
pub const hint_joystick_hidapi_zuiki = hints_h.hint_joystick_hidapi_zuiki;
pub const hint_joystick_hidapi_flydigi = hints_h.hint_joystick_hidapi_flydigi;
pub const hint_joystick_hidapi_switch = hints_h.hint_joystick_hidapi_switch;
pub const hint_joystick_hidapi_switch_home_led = hints_h.hint_joystick_hidapi_switch_home_led;
pub const hint_joystick_hidapi_switch_player_led = hints_h.hint_joystick_hidapi_switch_player_led;
pub const hint_joystick_hidapi_switch2 = hints_h.hint_joystick_hidapi_switch2;
pub const hint_joystick_hidapi_vertical_joy_cons = hints_h.hint_joystick_hidapi_vertical_joy_cons;
pub const hint_joystick_hidapi_wii = hints_h.hint_joystick_hidapi_wii;
pub const hint_joystick_hidapi_wii_player_led = hints_h.hint_joystick_hidapi_wii_player_led;
pub const hint_joystick_hidapi_xbox = hints_h.hint_joystick_hidapi_xbox;
pub const hint_joystick_hidapi_xbox_360 = hints_h.hint_joystick_hidapi_xbox_360;
pub const hint_joystick_hidapi_xbox_360_player_led = hints_h.hint_joystick_hidapi_xbox_360_player_led;
pub const hint_joystick_hidapi_xbox_360_wireless = hints_h.hint_joystick_hidapi_xbox_360_wireless;
pub const hint_joystick_hidapi_xbox_one = hints_h.hint_joystick_hidapi_xbox_one;
pub const hint_joystick_hidapi_xbox_one_home_led = hints_h.hint_joystick_hidapi_xbox_one_home_led;
pub const hint_joystick_hidapi_gip = hints_h.hint_joystick_hidapi_gip;
pub const hint_joystick_hidapi_gip_reset_for_metadata = hints_h.hint_joystick_hidapi_gip_reset_for_metadata;
pub const hint_joystick_iokit = hints_h.hint_joystick_iokit;
pub const hint_joystick_linux_classic = hints_h.hint_joystick_linux_classic;
pub const hint_joystick_linux_deadzones = hints_h.hint_joystick_linux_deadzones;
pub const hint_joystick_linux_digital_hats = hints_h.hint_joystick_linux_digital_hats;
pub const hint_joystick_linux_hat_deadzones = hints_h.hint_joystick_linux_hat_deadzones;
pub const hint_joystick_mfi = hints_h.hint_joystick_mfi;
pub const hint_joystick_rawinput = hints_h.hint_joystick_rawinput;
pub const hint_joystick_rawinput_correlate_xinput = hints_h.hint_joystick_rawinput_correlate_xinput;
pub const hint_joystick_rog_chakram = hints_h.hint_joystick_rog_chakram;
pub const hint_joystick_thread = hints_h.hint_joystick_thread;
pub const hint_joystick_throttle_devices = hints_h.hint_joystick_throttle_devices;
pub const hint_joystick_throttle_devices_excluded = hints_h.hint_joystick_throttle_devices_excluded;
pub const hint_joystick_wgi = hints_h.hint_joystick_wgi;
pub const hint_joystick_wheel_devices = hints_h.hint_joystick_wheel_devices;
pub const hint_joystick_wheel_devices_excluded = hints_h.hint_joystick_wheel_devices_excluded;
pub const hint_joystick_zero_centered_devices = hints_h.hint_joystick_zero_centered_devices;
pub const hint_joystick_haptic_axes = hints_h.hint_joystick_haptic_axes;
pub const hint_keycode_options = hints_h.hint_keycode_options;
pub const hint_kmsdrm_device_index = hints_h.hint_kmsdrm_device_index;
pub const hint_kmsdrm_require_drm_master = hints_h.hint_kmsdrm_require_drm_master;
pub const hint_kmsdrm_atomic = hints_h.hint_kmsdrm_atomic;
pub const hint_logging = hints_h.hint_logging;
pub const hint_mac_background_app = hints_h.hint_mac_background_app;
pub const hint_mac_ctrl_click_emulate_right_click = hints_h.hint_mac_ctrl_click_emulate_right_click;
pub const hint_mac_opengl_async_dispatch = hints_h.hint_mac_opengl_async_dispatch;
pub const hint_mac_option_as_alt = hints_h.hint_mac_option_as_alt;
pub const hint_mac_scroll_momentum = hints_h.hint_mac_scroll_momentum;
pub const hint_mac_press_and_hold = hints_h.hint_mac_press_and_hold;
pub const hint_main_callback_rate = hints_h.hint_main_callback_rate;
pub const hint_mouse_auto_capture = hints_h.hint_mouse_auto_capture;
pub const hint_mouse_double_click_radius = hints_h.hint_mouse_double_click_radius;
pub const hint_mouse_double_click_time = hints_h.hint_mouse_double_click_time;
pub const hint_mouse_default_system_cursor = hints_h.hint_mouse_default_system_cursor;
pub const hint_mouse_dpi_scale_cursors = hints_h.hint_mouse_dpi_scale_cursors;
pub const hint_mouse_emulate_warp_with_relative = hints_h.hint_mouse_emulate_warp_with_relative;
pub const hint_mouse_focus_clickthrough = hints_h.hint_mouse_focus_clickthrough;
pub const hint_mouse_normal_speed_scale = hints_h.hint_mouse_normal_speed_scale;
pub const hint_mouse_relative_mode_center = hints_h.hint_mouse_relative_mode_center;
pub const hint_mouse_relative_speed_scale = hints_h.hint_mouse_relative_speed_scale;
pub const hint_mouse_relative_system_scale = hints_h.hint_mouse_relative_system_scale;
pub const hint_mouse_relative_warp_motion = hints_h.hint_mouse_relative_warp_motion;
pub const hint_mouse_relative_cursor_visible = hints_h.hint_mouse_relative_cursor_visible;
pub const hint_mouse_touch_events = hints_h.hint_mouse_touch_events;
pub const hint_mute_console_keyboard = hints_h.hint_mute_console_keyboard;
pub const hint_no_signal_handlers = hints_h.hint_no_signal_handlers;
pub const hint_opengl_library = hints_h.hint_opengl_library;
pub const hint_egl_library = hints_h.hint_egl_library;
pub const hint_opengl_es_driver = hints_h.hint_opengl_es_driver;
pub const hint_opengl_force_srgb_framebuffer = hints_h.hint_opengl_force_srgb_framebuffer;
pub const hint_openvr_library = hints_h.hint_openvr_library;
pub const hint_orientations = hints_h.hint_orientations;
pub const hint_poll_sentinel = hints_h.hint_poll_sentinel;
pub const hint_preferred_locales = hints_h.hint_preferred_locales;
pub const hint_quit_on_last_window_close = hints_h.hint_quit_on_last_window_close;
pub const hint_render_direct3d_threadsafe = hints_h.hint_render_direct3d_threadsafe;
pub const hint_render_direct3d11_debug = hints_h.hint_render_direct3d11_debug;
pub const hint_render_direct3d11_warp = hints_h.hint_render_direct3d11_warp;
pub const hint_render_vulkan_debug = hints_h.hint_render_vulkan_debug;
pub const hint_render_gpu_debug = hints_h.hint_render_gpu_debug;
pub const hint_render_gpu_low_power = hints_h.hint_render_gpu_low_power;
pub const hint_render_driver = hints_h.hint_render_driver;
pub const hint_render_line_method = hints_h.hint_render_line_method;
pub const hint_render_metal_prefer_low_power_device = hints_h.hint_render_metal_prefer_low_power_device;
pub const hint_render_vsync = hints_h.hint_render_vsync;
pub const hint_return_key_hides_ime = hints_h.hint_return_key_hides_ime;
pub const hint_rog_gamepad_mice = hints_h.hint_rog_gamepad_mice;
pub const hint_rog_gamepad_mice_excluded = hints_h.hint_rog_gamepad_mice_excluded;
pub const hint_ps2_gs_width = hints_h.hint_ps2_gs_width;
pub const hint_ps2_gs_height = hints_h.hint_ps2_gs_height;
pub const hint_ps2_gs_progressive = hints_h.hint_ps2_gs_progressive;
pub const hint_ps2_gs_mode = hints_h.hint_ps2_gs_mode;
pub const hint_rpi_video_layer = hints_h.hint_rpi_video_layer;
pub const hint_screensaver_inhibit_activity_name = hints_h.hint_screensaver_inhibit_activity_name;
pub const hint_shutdown_dbus_on_quit = hints_h.hint_shutdown_dbus_on_quit;
pub const hint_storage_title_driver = hints_h.hint_storage_title_driver;
pub const hint_storage_user_driver = hints_h.hint_storage_user_driver;
pub const hint_thread_force_realtime_time_critical = hints_h.hint_thread_force_realtime_time_critical;
pub const hint_thread_priority_policy = hints_h.hint_thread_priority_policy;
pub const hint_timer_resolution = hints_h.hint_timer_resolution;
pub const hint_touch_mouse_events = hints_h.hint_touch_mouse_events;
pub const hint_trackpad_is_touch_only = hints_h.hint_trackpad_is_touch_only;
pub const hint_tv_remote_as_joystick = hints_h.hint_tv_remote_as_joystick;
pub const hint_video_allow_screensaver = hints_h.hint_video_allow_screensaver;
pub const hint_video_display_priority = hints_h.hint_video_display_priority;
pub const hint_video_double_buffer = hints_h.hint_video_double_buffer;
pub const hint_video_driver = hints_h.hint_video_driver;
pub const hint_video_dummy_save_frames = hints_h.hint_video_dummy_save_frames;
pub const hint_video_egl_allow_getdisplay_fallback = hints_h.hint_video_egl_allow_getdisplay_fallback;
pub const hint_video_force_egl = hints_h.hint_video_force_egl;
pub const hint_video_mac_fullscreen_spaces = hints_h.hint_video_mac_fullscreen_spaces;
pub const hint_video_mac_fullscreen_menu_visibility = hints_h.hint_video_mac_fullscreen_menu_visibility;
pub const hint_video_metal_auto_resize_drawable = hints_h.hint_video_metal_auto_resize_drawable;
pub const hint_video_match_exclusive_mode_on_move = hints_h.hint_video_match_exclusive_mode_on_move;
pub const hint_video_minimize_on_focus_loss = hints_h.hint_video_minimize_on_focus_loss;
pub const hint_video_offscreen_save_frames = hints_h.hint_video_offscreen_save_frames;
pub const hint_video_sync_window_operations = hints_h.hint_video_sync_window_operations;
pub const hint_video_wayland_allow_libdecor = hints_h.hint_video_wayland_allow_libdecor;
pub const hint_video_wayland_mode_emulation = hints_h.hint_video_wayland_mode_emulation;
pub const hint_video_wayland_mode_scaling = hints_h.hint_video_wayland_mode_scaling;
pub const hint_video_wayland_prefer_libdecor = hints_h.hint_video_wayland_prefer_libdecor;
pub const hint_video_wayland_scale_to_display = hints_h.hint_video_wayland_scale_to_display;
pub const hint_video_win_d3dcompiler = hints_h.hint_video_win_d3dcompiler;
pub const hint_video_x11_enable_xsync_ext = hints_h.hint_video_x11_enable_xsync_ext;
pub const hint_video_x11_external_window_input = hints_h.hint_video_x11_external_window_input;
pub const hint_video_x11_net_wm_bypass_compositor = hints_h.hint_video_x11_net_wm_bypass_compositor;
pub const hint_video_x11_net_wm_ping = hints_h.hint_video_x11_net_wm_ping;
pub const hint_video_x11_nodirectcolor = hints_h.hint_video_x11_nodirectcolor;
pub const hint_video_x11_scaling_factor = hints_h.hint_video_x11_scaling_factor;
pub const hint_video_x11_visualid = hints_h.hint_video_x11_visualid;
pub const hint_video_x11_window_visualid = hints_h.hint_video_x11_window_visualid;
pub const hint_video_x11_xrandr = hints_h.hint_video_x11_xrandr;
pub const hint_vita_enable_back_touch = hints_h.hint_vita_enable_back_touch;
pub const hint_vita_enable_front_touch = hints_h.hint_vita_enable_front_touch;
pub const hint_vita_module_path = hints_h.hint_vita_module_path;
pub const hint_vita_pvr_init = hints_h.hint_vita_pvr_init;
pub const hint_vita_resolution = hints_h.hint_vita_resolution;
pub const hint_vita_pvr_opengl = hints_h.hint_vita_pvr_opengl;
pub const hint_vita_touch_mouse_device = hints_h.hint_vita_touch_mouse_device;
pub const hint_vulkan_display = hints_h.hint_vulkan_display;
pub const hint_vulkan_library = hints_h.hint_vulkan_library;
pub const hint_wave_fact_chunk = hints_h.hint_wave_fact_chunk;
pub const hint_wave_chunk_limit = hints_h.hint_wave_chunk_limit;
pub const hint_wave_riff_chunk_size = hints_h.hint_wave_riff_chunk_size;
pub const hint_wave_truncation = hints_h.hint_wave_truncation;
pub const hint_window_activate_when_raised = hints_h.hint_window_activate_when_raised;
pub const hint_window_activate_when_shown = hints_h.hint_window_activate_when_shown;
pub const hint_window_allow_topmost = hints_h.hint_window_allow_topmost;
pub const hint_window_frame_usable_while_cursor_hidden = hints_h.hint_window_frame_usable_while_cursor_hidden;
pub const hint_windows_close_on_alt_f4 = hints_h.hint_windows_close_on_alt_f4;
pub const hint_windows_enable_menu_mnemonics = hints_h.hint_windows_enable_menu_mnemonics;
pub const hint_windows_enable_messageloop = hints_h.hint_windows_enable_messageloop;
pub const hint_windows_gameinput = hints_h.hint_windows_gameinput;
pub const hint_windows_raw_keyboard = hints_h.hint_windows_raw_keyboard;
pub const hint_windows_raw_keyboard_exclude_hotkeys = hints_h.hint_windows_raw_keyboard_exclude_hotkeys;
pub const hint_windows_raw_keyboard_inputsink = hints_h.hint_windows_raw_keyboard_inputsink;
pub const hint_windows_force_semaphore_kernel = hints_h.hint_windows_force_semaphore_kernel;
pub const hint_windows_intresource_icon = hints_h.hint_windows_intresource_icon;
pub const hint_windows_intresource_icon_small = hints_h.hint_windows_intresource_icon_small;
pub const hint_windows_use_d3d9ex = hints_h.hint_windows_use_d3d9ex;
pub const hint_windows_erase_background_mode = hints_h.hint_windows_erase_background_mode;
pub const hint_x11_force_override_redirect = hints_h.hint_x11_force_override_redirect;
pub const hint_x11_window_type = hints_h.hint_x11_window_type;
pub const hint_x11_xcb_library = hints_h.hint_x11_xcb_library;
pub const hint_xinput_enabled = hints_h.hint_xinput_enabled;
pub const hint_assert = hints_h.hint_assert;
pub const hint_pen_mouse_events = hints_h.hint_pen_mouse_events;
pub const hint_pen_touch_events = hints_h.hint_pen_touch_events;
pub const HintPriority = hints_h.HintPriority;
pub const setHintWithPriority = hints_h.setHintWithPriority;
pub const setHint = hints_h.setHint;
pub const resetHint = hints_h.resetHint;
pub const resetHints = hints_h.resetHints;
pub const getHint = hints_h.getHint;
pub const getHintBoolean = hints_h.getHintBoolean;
pub const HintCallback = hints_h.HintCallback;
pub const addHintCallback = hints_h.addHintCallback;
pub const removeHintCallback = hints_h.removeHintCallback;
const init_h = @import("sdl3/init.zig");
pub const InitFlags = init_h.InitFlags;
pub const AppResult = init_h.AppResult;
pub const AppInitFn = init_h.AppInitFn;
pub const AppIterateFn = init_h.AppIterateFn;
pub const AppEventFn = init_h.AppEventFn;
pub const AppQuitFn = init_h.AppQuitFn;
pub const init = init_h.init;
pub const initSubSystem = init_h.initSubSystem;
pub const quitSubSystem = init_h.quitSubSystem;
pub const wasInit = init_h.wasInit;
pub const quit = init_h.quit;
pub const isMainThread = init_h.isMainThread;
pub const MainThreadCallback = init_h.MainThreadCallback;
pub const runOnMainThread = init_h.runOnMainThread;
pub const setAppMetadata = init_h.setAppMetadata;
pub const setAppMetadataProperty = init_h.setAppMetadataProperty;
pub const prop_app_metadata_name_string = init_h.prop_app_metadata_name_string;
pub const prop_app_metadata_version_string = init_h.prop_app_metadata_version_string;
pub const prop_app_metadata_identifier_string = init_h.prop_app_metadata_identifier_string;
pub const prop_app_metadata_creator_string = init_h.prop_app_metadata_creator_string;
pub const prop_app_metadata_copyright_string = init_h.prop_app_metadata_copyright_string;
pub const prop_app_metadata_url_string = init_h.prop_app_metadata_url_string;
pub const prop_app_metadata_type_string = init_h.prop_app_metadata_type_string;
pub const getAppMetadataProperty = init_h.getAppMetadataProperty;
const iostream_h = @import("sdl3/iostream.zig");
pub const IOStatus = iostream_h.IOStatus;
pub const IOWhence = iostream_h.IOWhence;
pub const IOStreamInterface = iostream_h.IOStreamInterface;
pub const IOStream = iostream_h.IOStream;
pub const ioFromFile = iostream_h.ioFromFile;
pub const ioFromMem = iostream_h.ioFromMem;
pub const ioFromConstMem = iostream_h.ioFromConstMem;
pub const ioFromDynamicMem = iostream_h.ioFromDynamicMem;
pub const openIO = iostream_h.openIO;
pub const closeIO = iostream_h.closeIO;
pub const getIOProperties = iostream_h.getIOProperties;
pub const getIOStatus = iostream_h.getIOStatus;
pub const getIOSize = iostream_h.getIOSize;
pub const seekIO = iostream_h.seekIO;
pub const tellIO = iostream_h.tellIO;
pub const readIO = iostream_h.readIO;
pub const writeIO = iostream_h.writeIO;
pub const ioPrintf = iostream_h.ioPrintf;
pub const flushIO = iostream_h.flushIO;
pub const loadFile_IO = iostream_h.loadFile_IO;
pub const loadFile = iostream_h.loadFile;
pub const saveFile_IO = iostream_h.saveFile_IO;
pub const saveFile = iostream_h.saveFile;
pub const readU8 = iostream_h.readU8;
pub const readS8 = iostream_h.readS8;
pub const readU16LE = iostream_h.readU16LE;
pub const readS16LE = iostream_h.readS16LE;
pub const readU16BE = iostream_h.readU16BE;
pub const readS16BE = iostream_h.readS16BE;
pub const readU32LE = iostream_h.readU32LE;
pub const readS32LE = iostream_h.readS32LE;
pub const readU32BE = iostream_h.readU32BE;
pub const readS32BE = iostream_h.readS32BE;
pub const readU64LE = iostream_h.readU64LE;
pub const readS64LE = iostream_h.readS64LE;
pub const readU64BE = iostream_h.readU64BE;
pub const readS64BE = iostream_h.readS64BE;
pub const writeU8 = iostream_h.writeU8;
pub const writeS8 = iostream_h.writeS8;
pub const writeU16LE = iostream_h.writeU16LE;
pub const writeS16LE = iostream_h.writeS16LE;
pub const writeU16BE = iostream_h.writeU16BE;
pub const writeS16BE = iostream_h.writeS16BE;
pub const writeU32LE = iostream_h.writeU32LE;
pub const writeS32LE = iostream_h.writeS32LE;
pub const writeU32BE = iostream_h.writeU32BE;
pub const writeS32BE = iostream_h.writeS32BE;
pub const writeU64LE = iostream_h.writeU64LE;
pub const writeS64LE = iostream_h.writeS64LE;
pub const writeU64BE = iostream_h.writeU64BE;
pub const writeS64BE = iostream_h.writeS64BE;
const joystick_h = @import("sdl3/joystick.zig");
pub const Joystick = joystick_h.Joystick;
pub const JoystickId = joystick_h.JoystickId;
pub const JoystickType = joystick_h.JoystickType;
pub const JoystickConnectionState = joystick_h.JoystickConnectionState;
pub const joystick_axis_max = joystick_h.joystick_axis_max;
pub const joystick_axis_min = joystick_h.joystick_axis_min;
pub const lockJoysticks = joystick_h.lockJoysticks;
pub const unlockJoysticks = joystick_h.unlockJoysticks;
pub const hasJoystick = joystick_h.hasJoystick;
pub const getJoysticks = joystick_h.getJoysticks;
pub const getJoystickNameForId = joystick_h.getJoystickNameForId;
pub const getJoystickPathForId = joystick_h.getJoystickPathForId;
pub const getJoystickPlayerIndexForId = joystick_h.getJoystickPlayerIndexForId;
pub const getJoystickGUIDForId = joystick_h.getJoystickGUIDForId;
pub const getJoystickVendorForId = joystick_h.getJoystickVendorForId;
pub const getJoystickProductForId = joystick_h.getJoystickProductForId;
pub const getJoystickProductVersionForId = joystick_h.getJoystickProductVersionForId;
pub const getJoystickTypeForId = joystick_h.getJoystickTypeForId;
pub const openJoystick = joystick_h.openJoystick;
pub const getJoystickFromId = joystick_h.getJoystickFromId;
pub const getJoystickFromPlayerIndex = joystick_h.getJoystickFromPlayerIndex;
pub const VirtualJoystickTouchpadDesc = joystick_h.VirtualJoystickTouchpadDesc;
pub const VirtualJoystickSensorDesc = joystick_h.VirtualJoystickSensorDesc;
pub const VirtualJoystickDesc = joystick_h.VirtualJoystickDesc;
pub const attachVirtualJoystick = joystick_h.attachVirtualJoystick;
pub const detachVirtualJoystick = joystick_h.detachVirtualJoystick;
pub const isJoystickVirtual = joystick_h.isJoystickVirtual;
pub const setJoystickVirtualAxis = joystick_h.setJoystickVirtualAxis;
pub const setJoystickVirtualBall = joystick_h.setJoystickVirtualBall;
pub const setJoystickVirtualButton = joystick_h.setJoystickVirtualButton;
pub const setJoystickVirtualHat = joystick_h.setJoystickVirtualHat;
pub const setJoystickVirtualTouchpad = joystick_h.setJoystickVirtualTouchpad;
pub const sendJoystickVirtualSensorData = joystick_h.sendJoystickVirtualSensorData;
pub const getJoystickProperties = joystick_h.getJoystickProperties;
pub const getJoystickName = joystick_h.getJoystickName;
pub const getJoystickPath = joystick_h.getJoystickPath;
pub const getJoystickPlayerIndex = joystick_h.getJoystickPlayerIndex;
pub const setJoystickPlayerIndex = joystick_h.setJoystickPlayerIndex;
pub const getJoystickGUID = joystick_h.getJoystickGUID;
pub const getJoystickVendor = joystick_h.getJoystickVendor;
pub const getJoystickProduct = joystick_h.getJoystickProduct;
pub const getJoystickProductVersion = joystick_h.getJoystickProductVersion;
pub const getJoystickFirmwareVersion = joystick_h.getJoystickFirmwareVersion;
pub const getJoystickSerial = joystick_h.getJoystickSerial;
pub const getJoystickType = joystick_h.getJoystickType;
pub const getJoystickGUIDInfo = joystick_h.getJoystickGUIDInfo;
pub const joystickConnected = joystick_h.joystickConnected;
pub const getJoystickId = joystick_h.getJoystickId;
pub const getNumJoystickAxes = joystick_h.getNumJoystickAxes;
pub const getNumJoystickBalls = joystick_h.getNumJoystickBalls;
pub const getNumJoystickHats = joystick_h.getNumJoystickHats;
pub const getNumJoystickButtons = joystick_h.getNumJoystickButtons;
pub const setJoystickEventsEnabled = joystick_h.setJoystickEventsEnabled;
pub const joystickEventsEnabled = joystick_h.joystickEventsEnabled;
pub const updateJoysticks = joystick_h.updateJoysticks;
pub const getJoystickAxis = joystick_h.getJoystickAxis;
pub const getJoystickAxisInitialState = joystick_h.getJoystickAxisInitialState;
pub const getJoystickBall = joystick_h.getJoystickBall;
pub const getJoystickHat = joystick_h.getJoystickHat;
pub const HatState = joystick_h.HatState;
pub const getJoystickButton = joystick_h.getJoystickButton;
pub const rumbleJoystick = joystick_h.rumbleJoystick;
pub const rumbleJoystickTriggers = joystick_h.rumbleJoystickTriggers;
pub const setJoystickLED = joystick_h.setJoystickLED;
pub const sendJoystickEffect = joystick_h.sendJoystickEffect;
pub const closeJoystick = joystick_h.closeJoystick;
pub const getJoystickConnectionState = joystick_h.getJoystickConnectionState;
pub const getJoystickPowerInfo = joystick_h.getJoystickPowerInfo;
const keyboard_h = @import("sdl3/keyboard.zig");
pub const KeyboardId = keyboard_h.KeyboardId;
pub const hasKeyboard = keyboard_h.hasKeyboard;
pub const getKeyboards = keyboard_h.getKeyboards;
pub const getKeyboardNameForId = keyboard_h.getKeyboardNameForId;
pub const getKeyboardFocus = keyboard_h.getKeyboardFocus;
pub const getKeyboardState = keyboard_h.getKeyboardState;
pub const resetKeyboard = keyboard_h.resetKeyboard;
pub const getModState = keyboard_h.getModState;
pub const setModState = keyboard_h.setModState;
pub const getKeyFromScancode = keyboard_h.getKeyFromScancode;
pub const getScancodeFromKey = keyboard_h.getScancodeFromKey;
pub const setScancodeName = keyboard_h.setScancodeName;
pub const getScancodeName = keyboard_h.getScancodeName;
pub const getScancodeFromName = keyboard_h.getScancodeFromName;
pub const getKeyName = keyboard_h.getKeyName;
pub const getKeyFromName = keyboard_h.getKeyFromName;
pub const startTextInput = keyboard_h.startTextInput;
pub const TextInputType = keyboard_h.TextInputType;
pub const Capitalization = keyboard_h.Capitalization;
pub const startTextInputWithProperties = keyboard_h.startTextInputWithProperties;
pub const prop_textinput_capitalization_number = keyboard_h.prop_textinput_capitalization_number;
pub const prop_textinput_autocorrect_boolean = keyboard_h.prop_textinput_autocorrect_boolean;
pub const prop_textinput_multiline_boolean = keyboard_h.prop_textinput_multiline_boolean;
pub const prop_textinput_android_inputtype_number = keyboard_h.prop_textinput_android_inputtype_number;
pub const textInputActive = keyboard_h.textInputActive;
pub const stopTextInput = keyboard_h.stopTextInput;
pub const clearComposition = keyboard_h.clearComposition;
pub const setTextInputArea = keyboard_h.setTextInputArea;
pub const getTextInputArea = keyboard_h.getTextInputArea;
pub const hasScreenKeyboardSupport = keyboard_h.hasScreenKeyboardSupport;
pub const screenKeyboardShown = keyboard_h.screenKeyboardShown;
const keycode_h = @import("sdl3/keycode.zig");
pub const Keycode = keycode_h.Keycode;
pub const scancodeToKeycode = keycode_h.scancodeToKeycode;
pub const Keymod = keycode_h.Keymod;
const loadso_h = @import("sdl3/loadso.zig");
pub const SharedObject = loadso_h.SharedObject;
pub const loadObject = loadso_h.loadObject;
pub const loadFunction = loadso_h.loadFunction;
pub const unloadObject = loadso_h.unloadObject;
const locale_h = @import("sdl3/locale.zig");
pub const Locale = locale_h.Locale;
pub const getPreferredLocales = locale_h.getPreferredLocales;
const log_h = @import("sdl3/log.zig");
pub const max_log_message = log_h.max_log_message;
pub const LogCategory = log_h.LogCategory;
pub const LogPriority = log_h.LogPriority;
pub const setLogPriorities = log_h.setLogPriorities;
pub const setLogPriority = log_h.setLogPriority;
pub const getLogPriority = log_h.getLogPriority;
pub const resetLogPriorities = log_h.resetLogPriorities;
pub const setLogPriorityPrefix = log_h.setLogPriorityPrefix;
pub const log = log_h.log;
pub const logTrace = log_h.logTrace;
pub const logVerbose = log_h.logVerbose;
pub const logDebug = log_h.logDebug;
pub const logInfo = log_h.logInfo;
pub const logWarn = log_h.logWarn;
pub const logError = log_h.logError;
pub const logCritical = log_h.logCritical;
pub const logMessage = log_h.logMessage;
pub const LogOutputFunction = log_h.LogOutputFunction;
pub const getDefaultLogOutputFunction = log_h.getDefaultLogOutputFunction;
pub const getLogOutputFunction = log_h.getLogOutputFunction;
pub const setLogOutputFunction = log_h.setLogOutputFunction;
const main_h = @import("sdl3/main.zig");
pub const MainFn = main_h.MainFn;
pub const setMainReady = main_h.setMainReady;
pub const runApp = main_h.runApp;
pub const enterAppMainCallbacks = main_h.enterAppMainCallbacks;
pub const registerApp = main_h.registerApp;
pub const unregisterApp = main_h.unregisterApp;
pub const gdkSuspendComplete = main_h.gdkSuspendComplete;
const messagebox_h = @import("sdl3/messagebox.zig");
pub const MessageBoxFlags = messagebox_h.MessageBoxFlags;
pub const MessageBoxButtonFlags = messagebox_h.MessageBoxButtonFlags;
pub const MessageBoxButtonData = messagebox_h.MessageBoxButtonData;
pub const MessageBoxColor = messagebox_h.MessageBoxColor;
pub const MessageBoxColorType = messagebox_h.MessageBoxColorType;
pub const MessageBoxColorScheme = messagebox_h.MessageBoxColorScheme;
pub const MessageBoxData = messagebox_h.MessageBoxData;
pub const showMessageBox = messagebox_h.showMessageBox;
pub const showSimpleMessageBox = messagebox_h.showSimpleMessageBox;
const metal_h = @import("sdl3/metal.zig");
pub const MetalView = metal_h.MetalView;
pub const metal = metal_h.metal;
const misc_h = @import("sdl3/misc.zig");
pub const openURL = misc_h.openURL;
const mouse_h = @import("sdl3/mouse.zig");
pub const MouseId = mouse_h.MouseId;
pub const Cursor = mouse_h.Cursor;
pub const SystemCursor = mouse_h.SystemCursor;
pub const MouseWheelDirection = mouse_h.MouseWheelDirection;
pub const CursorFrameInfo = mouse_h.CursorFrameInfo;
pub const MouseButtonFlags = mouse_h.MouseButtonFlags;
pub const button_left = mouse_h.button_left;
pub const button_middle = mouse_h.button_middle;
pub const button_right = mouse_h.button_right;
pub const button_x1 = mouse_h.button_x1;
pub const button_x2 = mouse_h.button_x2;
pub const buttonMask = mouse_h.buttonMask;
pub const MouseMotionTransformCallback = mouse_h.MouseMotionTransformCallback;
pub const hasMouse = mouse_h.hasMouse;
pub const getMice = mouse_h.getMice;
pub const getMouseNameForId = mouse_h.getMouseNameForId;
pub const getMouseFocus = mouse_h.getMouseFocus;
pub const getMouseState = mouse_h.getMouseState;
pub const getGlobalMouseState = mouse_h.getGlobalMouseState;
pub const getRelativeMouseState = mouse_h.getRelativeMouseState;
pub const warpMouseInWindow = mouse_h.warpMouseInWindow;
pub const warpMouseGlobal = mouse_h.warpMouseGlobal;
pub const setRelativeMouseTransform = mouse_h.setRelativeMouseTransform;
pub const setWindowRelativeMouseMode = mouse_h.setWindowRelativeMouseMode;
pub const getWindowRelativeMouseMode = mouse_h.getWindowRelativeMouseMode;
pub const captureMouse = mouse_h.captureMouse;
pub const createCursor = mouse_h.createCursor;
pub const createColorCursor = mouse_h.createColorCursor;
pub const createAnimatedCursor = mouse_h.createAnimatedCursor;
pub const createSystemCursor = mouse_h.createSystemCursor;
pub const setCursor = mouse_h.setCursor;
pub const getCursor = mouse_h.getCursor;
pub const getDefaultCursor = mouse_h.getDefaultCursor;
pub const destroyCursor = mouse_h.destroyCursor;
pub const showCursor = mouse_h.showCursor;
pub const hideCursor = mouse_h.hideCursor;
pub const cursorVisible = mouse_h.cursorVisible;
const mutex_h = @import("sdl3/mutex.zig");
pub const Mutex = mutex_h.Mutex;
pub const createMutex = mutex_h.createMutex;
pub const lockMutex = mutex_h.lockMutex;
pub const tryLockMutex = mutex_h.tryLockMutex;
pub const unlockMutex = mutex_h.unlockMutex;
pub const destroyMutex = mutex_h.destroyMutex;
pub const RWLock = mutex_h.RWLock;
pub const createRWLock = mutex_h.createRWLock;
pub const lockRWLockForReading = mutex_h.lockRWLockForReading;
pub const lockRWLockForWriting = mutex_h.lockRWLockForWriting;
pub const tryLockRWLockForReading = mutex_h.tryLockRWLockForReading;
pub const tryLockRWLockForWriting = mutex_h.tryLockRWLockForWriting;
pub const unlockRWLock = mutex_h.unlockRWLock;
pub const destroyRWLock = mutex_h.destroyRWLock;
pub const Semaphore = mutex_h.Semaphore;
pub const createSemaphore = mutex_h.createSemaphore;
pub const destroySemaphore = mutex_h.destroySemaphore;
pub const waitSemaphore = mutex_h.waitSemaphore;
pub const tryWaitSemaphore = mutex_h.tryWaitSemaphore;
pub const waitSemaphoreTimeout = mutex_h.waitSemaphoreTimeout;
pub const signalSemaphore = mutex_h.signalSemaphore;
pub const getSemaphoreValue = mutex_h.getSemaphoreValue;
pub const Condition = mutex_h.Condition;
pub const createCondition = mutex_h.createCondition;
pub const destroyCondition = mutex_h.destroyCondition;
pub const signalCondition = mutex_h.signalCondition;
pub const broadcastCondition = mutex_h.broadcastCondition;
pub const waitCondition = mutex_h.waitCondition;
pub const waitConditionTimeout = mutex_h.waitConditionTimeout;
pub const InitStatus = mutex_h.InitStatus;
pub const InitState = mutex_h.InitState;
pub const shouldInit = mutex_h.shouldInit;
pub const shouldQuit = mutex_h.shouldQuit;
pub const setInitialized = mutex_h.setInitialized;
const pen_h = @import("sdl3/pen.zig");
pub const PenId = pen_h.PenId;
pub const pen_mouseid = pen_h.pen_mouseid;
pub const pen_touchid = pen_h.pen_touchid;
pub const PenInputFlags = pen_h.PenInputFlags;
pub const PenAxis = pen_h.PenAxis;
pub const PenDeviceType = pen_h.PenDeviceType;
pub const getPenDeviceType = pen_h.getPenDeviceType;
const pixels_h = @import("sdl3/pixels.zig");
pub const alpha_opaque = pixels_h.alpha_opaque;
pub const alpha_opaque_float = pixels_h.alpha_opaque_float;
pub const alpha_transparent = pixels_h.alpha_transparent;
pub const alpha_transparent_float = pixels_h.alpha_transparent_float;
pub const PixelType = pixels_h.PixelType;
pub const BitmapOrder = pixels_h.BitmapOrder;
pub const PackedOrder = pixels_h.PackedOrder;
pub const ArrayOrder = pixels_h.ArrayOrder;
pub const PackedLayout = pixels_h.PackedLayout;
pub const PixelFormat = pixels_h.PixelFormat;
pub const ColorType = pixels_h.ColorType;
pub const ColorRange = pixels_h.ColorRange;
pub const ColorPrimaries = pixels_h.ColorPrimaries;
pub const TransferCharacteristics = pixels_h.TransferCharacteristics;
pub const MatrixCoefficients = pixels_h.MatrixCoefficients;
pub const ChromaLocation = pixels_h.ChromaLocation;
pub const Colorspace = pixels_h.Colorspace;
pub const Color = pixels_h.Color;
pub const FColor = pixels_h.FColor;
pub const Palette = pixels_h.Palette;
pub const PixelFormatDetails = pixels_h.PixelFormatDetails;
pub const getPixelFormatName = pixels_h.getPixelFormatName;
pub const getMasksForPixelFormat = pixels_h.getMasksForPixelFormat;
pub const getPixelFormatForMasks = pixels_h.getPixelFormatForMasks;
pub const getPixelFormatDetails = pixels_h.getPixelFormatDetails;
pub const createPalette = pixels_h.createPalette;
pub const setPaletteColors = pixels_h.setPaletteColors;
pub const destroyPalette = pixels_h.destroyPalette;
pub const mapRGB = pixels_h.mapRGB;
pub const mapRGBA = pixels_h.mapRGBA;
pub const getRGB = pixels_h.getRGB;
pub const getRGBA = pixels_h.getRGBA;
const platform_h = @import("sdl3/platform.zig");
pub const getPlatform = platform_h.getPlatform;
const power_h = @import("sdl3/power.zig");
pub const PowerState = power_h.PowerState;
pub const getPowerInfo = power_h.getPowerInfo;
const process_h = @import("sdl3/process.zig");
pub const Process = process_h.Process;
pub const createProcess = process_h.createProcess;
pub const ProcessIO = process_h.ProcessIO;
pub const createProcessWithProperties = process_h.createProcessWithProperties;
pub const getProcessProperties = process_h.getProcessProperties;
pub const readProcess = process_h.readProcess;
pub const getProcessInput = process_h.getProcessInput;
pub const getProcessOutput = process_h.getProcessOutput;
pub const killProcess = process_h.killProcess;
pub const waitProcess = process_h.waitProcess;
pub const destroyProcess = process_h.destroyProcess;
const properties_h = @import("sdl3/properties.zig");
pub const PropertiesId = properties_h.PropertiesId;
pub const PropertyType = properties_h.PropertyType;
pub const prop_name_string = properties_h.prop_name_string;
pub const getGlobalProperties = properties_h.getGlobalProperties;
pub const createProperties = properties_h.createProperties;
pub const copyProperties = properties_h.copyProperties;
pub const lockProperties = properties_h.lockProperties;
pub const unlockProperties = properties_h.unlockProperties;
pub const CleanupPropertyCallback = properties_h.CleanupPropertyCallback;
pub const setPointerPropertyWithCleanup = properties_h.setPointerPropertyWithCleanup;
pub const setPointerProperty = properties_h.setPointerProperty;
pub const setStringProperty = properties_h.setStringProperty;
pub const setNumberProperty = properties_h.setNumberProperty;
pub const setFloatProperty = properties_h.setFloatProperty;
pub const setBooleanProperty = properties_h.setBooleanProperty;
pub const hasProperty = properties_h.hasProperty;
pub const getPropertyType = properties_h.getPropertyType;
pub const getPointerProperty = properties_h.getPointerProperty;
pub const getStringProperty = properties_h.getStringProperty;
pub const getNumberProperty = properties_h.getNumberProperty;
pub const getFloatProperty = properties_h.getFloatProperty;
pub const getBooleanProperty = properties_h.getBooleanProperty;
pub const clearProperty = properties_h.clearProperty;
pub const EnumeratePropertiesCallback = properties_h.EnumeratePropertiesCallback;
pub const enumerateProperties = properties_h.enumerateProperties;
pub const destroyProperties = properties_h.destroyProperties;
const rect_h = @import("sdl3/rect.zig");
pub const Point = rect_h.Point;
pub const FPoint = rect_h.FPoint;
pub const Rect = rect_h.Rect;
pub const FRect = rect_h.FRect;
pub const rectToFRect = rect_h.rectToFRect;
pub const pointInRect = rect_h.pointInRect;
pub const rectEmpty = rect_h.rectEmpty;
pub const rectsEqual = rect_h.rectsEqual;
pub const hasRectIntersection = rect_h.hasRectIntersection;
pub const getRectIntersection = rect_h.getRectIntersection;
pub const getRectUnion = rect_h.getRectUnion;
pub const getRectEnclosingPoints = rect_h.getRectEnclosingPoints;
pub const getRectAndLineIntersection = rect_h.getRectAndLineIntersection;
pub const pointInRectFloat = rect_h.pointInRectFloat;
pub const rectEmptyFloat = rect_h.rectEmptyFloat;
pub const rectsEqualEpsilon = rect_h.rectsEqualEpsilon;
pub const rectsEqualFloat = rect_h.rectsEqualFloat;
pub const hasRectIntersectionFloat = rect_h.hasRectIntersectionFloat;
pub const getRectIntersectionFloat = rect_h.getRectIntersectionFloat;
pub const getRectUnionFloat = rect_h.getRectUnionFloat;
pub const getRectEnclosingPointsFloat = rect_h.getRectEnclosingPointsFloat;
pub const getRectAndLineIntersectionFloat = rect_h.getRectAndLineIntersectionFloat;
const render_h = @import("sdl3/render.zig");
pub const software_renderer = render_h.software_renderer;
pub const gpu_renderer = render_h.gpu_renderer;
pub const Vertex = render_h.Vertex;
pub const TextureAccess = render_h.TextureAccess;
pub const TextureAddressMode = render_h.TextureAddressMode;
pub const RendererLogicalPresentation = render_h.RendererLogicalPresentation;
pub const Renderer = render_h.Renderer;
pub const Texture = render_h.Texture;
pub const getNumRenderDrivers = render_h.getNumRenderDrivers;
pub const getRenderDriver = render_h.getRenderDriver;
pub const createWindowAndRenderer = render_h.createWindowAndRenderer;
pub const createRenderer = render_h.createRenderer;
pub const createRendererWithProperties = render_h.createRendererWithProperties;
pub const createGPURenderer = render_h.createGPURenderer;
pub const getGPURendererDevice = render_h.getGPURendererDevice;
pub const createSoftwareRenderer = render_h.createSoftwareRenderer;
pub const getRenderer = render_h.getRenderer;
pub const getRenderWindow = render_h.getRenderWindow;
pub const getRendererName = render_h.getRendererName;
pub const getRendererProperties = render_h.getRendererProperties;
pub const getRenderOutputSize = render_h.getRenderOutputSize;
pub const getCurrentRenderOutputSize = render_h.getCurrentRenderOutputSize;
pub const createTexture = render_h.createTexture;
pub const createTextureFromSurface = render_h.createTextureFromSurface;
pub const createTextureWithProperties = render_h.createTextureWithProperties;
pub const getTextureProperties = render_h.getTextureProperties;
pub const getRendererFromTexture = render_h.getRendererFromTexture;
pub const getTextureSize = render_h.getTextureSize;
pub const setTexturePalette = render_h.setTexturePalette;
pub const getTexturePalette = render_h.getTexturePalette;
pub const setTextureColorMod = render_h.setTextureColorMod;
pub const setTextureColorModFloat = render_h.setTextureColorModFloat;
pub const getTextureColorMod = render_h.getTextureColorMod;
pub const getTextureColorModFloat = render_h.getTextureColorModFloat;
pub const setTextureAlphaMod = render_h.setTextureAlphaMod;
pub const setTextureAlphaModFloat = render_h.setTextureAlphaModFloat;
pub const getTextureAlphaMod = render_h.getTextureAlphaMod;
pub const getTextureAlphaModFloat = render_h.getTextureAlphaModFloat;
pub const setTextureBlendMode = render_h.setTextureBlendMode;
pub const getTextureBlendMode = render_h.getTextureBlendMode;
pub const setTextureScaleMode = render_h.setTextureScaleMode;
pub const getTextureScaleMode = render_h.getTextureScaleMode;
pub const updateTexture = render_h.updateTexture;
pub const updateYUVTexture = render_h.updateYUVTexture;
pub const updateNVTexture = render_h.updateNVTexture;
pub const lockTexture = render_h.lockTexture;
pub const lockTextureToSurface = render_h.lockTextureToSurface;
pub const unlockTexture = render_h.unlockTexture;
pub const setRenderTarget = render_h.setRenderTarget;
pub const getRenderTarget = render_h.getRenderTarget;
pub const setRenderLogicalPresentation = render_h.setRenderLogicalPresentation;
pub const getRenderLogicalPresentation = render_h.getRenderLogicalPresentation;
pub const getRenderLogicalPresentationRect = render_h.getRenderLogicalPresentationRect;
pub const renderCoordinatesFromWindow = render_h.renderCoordinatesFromWindow;
pub const renderCoordinatesToWindow = render_h.renderCoordinatesToWindow;
pub const convertEventToRenderCoordinates = render_h.convertEventToRenderCoordinates;
pub const setRenderViewport = render_h.setRenderViewport;
pub const getRenderViewport = render_h.getRenderViewport;
pub const renderViewportSet = render_h.renderViewportSet;
pub const getRenderSafeArea = render_h.getRenderSafeArea;
pub const setRenderClipRect = render_h.setRenderClipRect;
pub const getRenderClipRect = render_h.getRenderClipRect;
pub const renderClipEnabled = render_h.renderClipEnabled;
pub const setRenderScale = render_h.setRenderScale;
pub const getRenderScale = render_h.getRenderScale;
pub const setRenderDrawColor = render_h.setRenderDrawColor;
pub const setRenderDrawColorFloat = render_h.setRenderDrawColorFloat;
pub const getRenderDrawColor = render_h.getRenderDrawColor;
pub const getRenderDrawColorFloat = render_h.getRenderDrawColorFloat;
pub const setRenderColorScale = render_h.setRenderColorScale;
pub const getRenderColorScale = render_h.getRenderColorScale;
pub const setRenderDrawBlendMode = render_h.setRenderDrawBlendMode;
pub const getRenderDrawBlendMode = render_h.getRenderDrawBlendMode;
pub const renderClear = render_h.renderClear;
pub const renderPoint = render_h.renderPoint;
pub const renderPoints = render_h.renderPoints;
pub const renderLine = render_h.renderLine;
pub const renderLines = render_h.renderLines;
pub const renderRect = render_h.renderRect;
pub const renderRects = render_h.renderRects;
pub const renderFillRect = render_h.renderFillRect;
pub const renderFillRects = render_h.renderFillRects;
pub const renderTexture = render_h.renderTexture;
pub const renderTextureRotated = render_h.renderTextureRotated;
pub const renderTextureAffine = render_h.renderTextureAffine;
pub const renderTextureTiled = render_h.renderTextureTiled;
pub const renderTexture9Grid = render_h.renderTexture9Grid;
pub const renderTexture9GridTiled = render_h.renderTexture9GridTiled;
pub const renderGeometry = render_h.renderGeometry;
pub const renderGeometryRaw = render_h.renderGeometryRaw;
pub const setRenderTextureAddressMode = render_h.setRenderTextureAddressMode;
pub const getRenderTextureAddressMode = render_h.getRenderTextureAddressMode;
pub const renderReadPixels = render_h.renderReadPixels;
pub const renderPresent = render_h.renderPresent;
pub const destroyTexture = render_h.destroyTexture;
pub const destroyRenderer = render_h.destroyRenderer;
pub const flushRenderer = render_h.flushRenderer;
pub const getRenderMetalLayer = render_h.getRenderMetalLayer;
pub const getRenderMetalCommandEncoder = render_h.getRenderMetalCommandEncoder;
pub const addVulkanRenderSemaphores = render_h.addVulkanRenderSemaphores;
pub const setRenderVSync = render_h.setRenderVSync;
pub const renderer_vsync_disabled = render_h.renderer_vsync_disabled;
pub const renderer_vsync_adaptive = render_h.renderer_vsync_adaptive;
pub const getRenderVSync = render_h.getRenderVSync;
pub const debug_text_font_character_size = render_h.debug_text_font_character_size;
pub const renderDebugText = render_h.renderDebugText;
pub const renderDebugTextFormat = render_h.renderDebugTextFormat;
pub const setDefaultTextureScaleMode = render_h.setDefaultTextureScaleMode;
pub const getDefaultTextureScaleMode = render_h.getDefaultTextureScaleMode;
pub const GPURenderStateCreateInfo = render_h.GPURenderStateCreateInfo;
pub const GPURenderState = render_h.GPURenderState;
pub const createGPURenderState = render_h.createGPURenderState;
pub const setGPURenderStateFragmentUniforms = render_h.setGPURenderStateFragmentUniforms;
pub const setGPURenderState = render_h.setGPURenderState;
pub const destroyGPURenderState = render_h.destroyGPURenderState;
const scancode_h = @import("sdl3/scancode.zig");
pub const Scancode = scancode_h.Scancode;
const sensor_h = @import("sdl3/sensor.zig");
pub const Sensor = sensor_h.Sensor;
pub const SensorId = sensor_h.SensorId;
pub const standard_gravity = sensor_h.standard_gravity;
pub const SensorType = sensor_h.SensorType;
pub const getSensors = sensor_h.getSensors;
pub const getSensorNameForId = sensor_h.getSensorNameForId;
pub const getSensorTypeForId = sensor_h.getSensorTypeForId;
pub const getSensorNonPortableTypeForId = sensor_h.getSensorNonPortableTypeForId;
pub const openSensor = sensor_h.openSensor;
pub const getSensorFromId = sensor_h.getSensorFromId;
pub const getSensorProperties = sensor_h.getSensorProperties;
pub const getSensorName = sensor_h.getSensorName;
pub const getSensorType = sensor_h.getSensorType;
pub const getSensorNonPortableType = sensor_h.getSensorNonPortableType;
pub const getSensorId = sensor_h.getSensorId;
pub const getSensorData = sensor_h.getSensorData;
pub const closeSensor = sensor_h.closeSensor;
pub const updateSensors = sensor_h.updateSensors;
const stdinc_h = @import("sdl3/stdinc.zig");
pub const Time = stdinc_h.Time;
pub const max_time = stdinc_h.max_time;
pub const min_time = stdinc_h.min_time;
pub const fourcc = stdinc_h.fourcc;
pub const malloc = stdinc_h.malloc;
pub const calloc = stdinc_h.calloc;
pub const realloc = stdinc_h.realloc;
pub const free = stdinc_h.free;
pub const MallocFn = stdinc_h.MallocFn;
pub const CallocFn = stdinc_h.CallocFn;
pub const ReallocFn = stdinc_h.ReallocFn;
pub const FreeFn = stdinc_h.FreeFn;
pub const MemoryFunctions = stdinc_h.MemoryFunctions;
pub const getOriginalMemoryFunctions = stdinc_h.getOriginalMemoryFunctions;
pub const getMemoryFunctions = stdinc_h.getMemoryFunctions;
pub const setMemoryFunctions = stdinc_h.setMemoryFunctions;
pub const alignedAlloc = stdinc_h.alignedAlloc;
pub const alignedFree = stdinc_h.alignedFree;
pub const getNumAllocations = stdinc_h.getNumAllocations;
pub const allocator = stdinc_h.allocator;
const storage_h = @import("sdl3/storage.zig");
pub const StorageInterface = storage_h.StorageInterface;
pub const Storage = storage_h.Storage;
pub const openTitleStorage = storage_h.openTitleStorage;
pub const openUserStorage = storage_h.openUserStorage;
pub const openFileStorage = storage_h.openFileStorage;
pub const openStorage = storage_h.openStorage;
pub const closeStorage = storage_h.closeStorage;
pub const storageReady = storage_h.storageReady;
pub const getStorageFileSize = storage_h.getStorageFileSize;
pub const readStorageFile = storage_h.readStorageFile;
pub const writeStorageFile = storage_h.writeStorageFile;
pub const createStorageDirectory = storage_h.createStorageDirectory;
pub const enumerateStorageDirectory = storage_h.enumerateStorageDirectory;
pub const removeStoragePath = storage_h.removeStoragePath;
pub const renameStoragePath = storage_h.renameStoragePath;
pub const copyStorageFile = storage_h.copyStorageFile;
pub const getStoragePathInfo = storage_h.getStoragePathInfo;
pub const getStorageSpaceRemaining = storage_h.getStorageSpaceRemaining;
pub const globStorageDirectory = storage_h.globStorageDirectory;
const surface_h = @import("sdl3/surface.zig");
pub const SurfaceFlags = surface_h.SurfaceFlags;
pub const ScaleMode = surface_h.ScaleMode;
pub const FlipMode = surface_h.FlipMode;
pub const Surface = surface_h.Surface;
pub const createSurface = surface_h.createSurface;
pub const createSurfaceFrom = surface_h.createSurfaceFrom;
pub const destroySurface = surface_h.destroySurface;
pub const getSurfaceProperties = surface_h.getSurfaceProperties;
pub const setSurfaceColorspace = surface_h.setSurfaceColorspace;
pub const getSurfaceColorspace = surface_h.getSurfaceColorspace;
pub const createSurfacePalette = surface_h.createSurfacePalette;
pub const setSurfacePalette = surface_h.setSurfacePalette;
pub const getSurfacePalette = surface_h.getSurfacePalette;
pub const addSurfaceAlternateImage = surface_h.addSurfaceAlternateImage;
pub const surfaceHasAlternateImages = surface_h.surfaceHasAlternateImages;
pub const getSurfaceImages = surface_h.getSurfaceImages;
pub const removeSurfaceAlternateImages = surface_h.removeSurfaceAlternateImages;
pub const lockSurface = surface_h.lockSurface;
pub const unlockSurface = surface_h.unlockSurface;
pub const loadSurface_IO = surface_h.loadSurface_IO;
pub const loadSurface = surface_h.loadSurface;
pub const loadBMP_IO = surface_h.loadBMP_IO;
pub const loadBMP = surface_h.loadBMP;
pub const saveBMP_IO = surface_h.saveBMP_IO;
pub const saveBMP = surface_h.saveBMP;
pub const loadPNG_IO = surface_h.loadPNG_IO;
pub const loadPNG = surface_h.loadPNG;
pub const savePNG_IO = surface_h.savePNG_IO;
pub const savePNG = surface_h.savePNG;
pub const setSurfaceRLE = surface_h.setSurfaceRLE;
pub const surfaceHasRLE = surface_h.surfaceHasRLE;
pub const setSurfaceColorKey = surface_h.setSurfaceColorKey;
pub const surfaceHasColorKey = surface_h.surfaceHasColorKey;
pub const getSurfaceColorKey = surface_h.getSurfaceColorKey;
pub const setSurfaceColorMod = surface_h.setSurfaceColorMod;
pub const getSurfaceColorMod = surface_h.getSurfaceColorMod;
pub const setSurfaceAlphaMod = surface_h.setSurfaceAlphaMod;
pub const getSurfaceAlphaMod = surface_h.getSurfaceAlphaMod;
pub const setSurfaceBlendMode = surface_h.setSurfaceBlendMode;
pub const getSurfaceBlendMode = surface_h.getSurfaceBlendMode;
pub const setSurfaceClipRect = surface_h.setSurfaceClipRect;
pub const getSurfaceClipRect = surface_h.getSurfaceClipRect;
pub const flipSurface = surface_h.flipSurface;
pub const rotateSurface = surface_h.rotateSurface;
pub const duplicateSurface = surface_h.duplicateSurface;
pub const scaleSurface = surface_h.scaleSurface;
pub const convertSurface = surface_h.convertSurface;
pub const convertSurfaceAndColorspace = surface_h.convertSurfaceAndColorspace;
pub const convertPixels = surface_h.convertPixels;
pub const convertPixelsAndColorspace = surface_h.convertPixelsAndColorspace;
pub const premultiplyAlpha = surface_h.premultiplyAlpha;
pub const premultiplySurfaceAlpha = surface_h.premultiplySurfaceAlpha;
pub const clearSurface = surface_h.clearSurface;
pub const fillSurfaceRect = surface_h.fillSurfaceRect;
pub const fillSurfaceRects = surface_h.fillSurfaceRects;
pub const blitSurface = surface_h.blitSurface;
pub const blitSurfaceUnchecked = surface_h.blitSurfaceUnchecked;
pub const blitSurfaceScaled = surface_h.blitSurfaceScaled;
pub const blitSurfaceUncheckedScaled = surface_h.blitSurfaceUncheckedScaled;
pub const stretchSurface = surface_h.stretchSurface;
pub const blitSurfaceTiled = surface_h.blitSurfaceTiled;
pub const blitSurfaceTiledWithScale = surface_h.blitSurfaceTiledWithScale;
pub const blitSurface9Grid = surface_h.blitSurface9Grid;
pub const mapSurfaceRGB = surface_h.mapSurfaceRGB;
pub const mapSurfaceRGBA = surface_h.mapSurfaceRGBA;
pub const readSurfacePixel = surface_h.readSurfacePixel;
pub const readSurfacePixelFloat = surface_h.readSurfacePixelFloat;
pub const writeSurfacePixel = surface_h.writeSurfacePixel;
pub const writeSurfacePixelFloat = surface_h.writeSurfacePixelFloat;
const system_h = @import("sdl3/system.zig");
pub const MSG = system_h.MSG;
pub const WindowsMessageHook = system_h.WindowsMessageHook;
pub const setWindowsMessageHook = system_h.setWindowsMessageHook;
pub const getDirect3D9AdapterIndex = system_h.getDirect3D9AdapterIndex;
pub const getDXGIOutputInfo = system_h.getDXGIOutputInfo;
pub const XEvent = system_h.XEvent;
pub const X11EventHook = system_h.X11EventHook;
pub const setX11EventHook = system_h.setX11EventHook;
pub const setLinuxThreadPriority = system_h.setLinuxThreadPriority;
pub const setLinuxThreadPriorityAndPolicy = system_h.setLinuxThreadPriorityAndPolicy;
pub const IOSAnimationCallback = system_h.IOSAnimationCallback;
pub const setiOSAnimationCallback = system_h.setiOSAnimationCallback;
pub const setiOSEventPump = system_h.setiOSEventPump;
pub const getAndroidJNIEnv = system_h.getAndroidJNIEnv;
pub const getAndroidActivity = system_h.getAndroidActivity;
pub const getAndroidSDKVersion = system_h.getAndroidSDKVersion;
pub const isChromebook = system_h.isChromebook;
pub const isDeXMode = system_h.isDeXMode;
pub const sendAndroidBackButton = system_h.sendAndroidBackButton;
pub const android_external_storage_read = system_h.android_external_storage_read;
pub const android_external_storage_write = system_h.android_external_storage_write;
pub const getAndroidInternalStoragePath = system_h.getAndroidInternalStoragePath;
pub const getAndroidExternalStorageState = system_h.getAndroidExternalStorageState;
pub const getAndroidExternalStoragePath = system_h.getAndroidExternalStoragePath;
pub const getAndroidCachePath = system_h.getAndroidCachePath;
pub const RequestAndroidPermissionCallback = system_h.RequestAndroidPermissionCallback;
pub const requestAndroidPermission = system_h.requestAndroidPermission;
pub const showAndroidToast = system_h.showAndroidToast;
pub const sendAndroidMessage = system_h.sendAndroidMessage;
pub const isTablet = system_h.isTablet;
pub const isTV = system_h.isTV;
pub const Sandbox = system_h.Sandbox;
pub const getSandbox = system_h.getSandbox;
pub const onApplicationWillTerminate = system_h.onApplicationWillTerminate;
pub const onApplicationDidReceiveMemoryWarning = system_h.onApplicationDidReceiveMemoryWarning;
pub const onApplicationWillEnterBackground = system_h.onApplicationWillEnterBackground;
pub const onApplicationDidEnterBackground = system_h.onApplicationDidEnterBackground;
pub const onApplicationWillEnterForeground = system_h.onApplicationWillEnterForeground;
pub const onApplicationDidEnterForeground = system_h.onApplicationDidEnterForeground;
pub const onApplicationDidChangeStatusBarOrientation = system_h.onApplicationDidChangeStatusBarOrientation;
pub const XTaskQueueHandle = system_h.XTaskQueueHandle;
pub const XUserHandle = system_h.XUserHandle;
pub const getGDKTaskQueue = system_h.getGDKTaskQueue;
pub const getGDKDefaultUser = system_h.getGDKDefaultUser;
const thread_h = @import("sdl3/thread.zig");
pub const Thread = thread_h.Thread;
pub const ThreadId = thread_h.ThreadId;
pub const TLSID = thread_h.TLSID;
pub const ThreadPriority = thread_h.ThreadPriority;
pub const ThreadState = thread_h.ThreadState;
pub const ThreadFunction = thread_h.ThreadFunction;
pub const createThread = thread_h.createThread;
pub const createThreadWithProperties = thread_h.createThreadWithProperties;
pub const createThreadRuntime = thread_h.createThreadRuntime;
pub const createThreadWithPropertiesRuntime = thread_h.createThreadWithPropertiesRuntime;
pub const getThreadName = thread_h.getThreadName;
pub const getCurrentThreadId = thread_h.getCurrentThreadId;
pub const getThreadId = thread_h.getThreadId;
pub const setCurrentThreadPriority = thread_h.setCurrentThreadPriority;
pub const waitThread = thread_h.waitThread;
pub const getThreadState = thread_h.getThreadState;
pub const detachThread = thread_h.detachThread;
pub const getTLS = thread_h.getTLS;
pub const TLSDestructorCallback = thread_h.TLSDestructorCallback;
pub const setTLS = thread_h.setTLS;
pub const cleanupTLS = thread_h.cleanupTLS;
const time_h = @import("sdl3/time.zig");
pub const DateTime = time_h.DateTime;
pub const DateFormat = time_h.DateFormat;
pub const TimeFormat = time_h.TimeFormat;
pub const getDateTimeLocalePreferences = time_h.getDateTimeLocalePreferences;
pub const getCurrentTime = time_h.getCurrentTime;
pub const timeToDateTime = time_h.timeToDateTime;
pub const dateTimeToTime = time_h.dateTimeToTime;
pub const timeToWindows = time_h.timeToWindows;
pub const timeFromWindows = time_h.timeFromWindows;
pub const getDaysInMonth = time_h.getDaysInMonth;
pub const getDayOfYear = time_h.getDayOfYear;
pub const getDayOfWeek = time_h.getDayOfWeek;
const timer_h = @import("sdl3/timer.zig");
pub const ms_per_second = timer_h.ms_per_second;
pub const us_per_second = timer_h.us_per_second;
pub const ns_per_second = timer_h.ns_per_second;
pub const ns_per_ms = timer_h.ns_per_ms;
pub const ns_per_us = timer_h.ns_per_us;
pub const secondsToNS = timer_h.secondsToNS;
pub const nsToSeconds = timer_h.nsToSeconds;
pub const msToNS = timer_h.msToNS;
pub const nsToMS = timer_h.nsToMS;
pub const usToNS = timer_h.usToNS;
pub const nsToUS = timer_h.nsToUS;
pub const getTicks = timer_h.getTicks;
pub const getTicksNS = timer_h.getTicksNS;
pub const getPerformanceCounter = timer_h.getPerformanceCounter;
pub const getPerformanceFrequency = timer_h.getPerformanceFrequency;
pub const delay = timer_h.delay;
pub const delayNS = timer_h.delayNS;
pub const delayPrecise = timer_h.delayPrecise;
pub const TimerId = timer_h.TimerId;
pub const TimerCallback = timer_h.TimerCallback;
pub const addTimer = timer_h.addTimer;
pub const NSTimerCallback = timer_h.NSTimerCallback;
pub const addTimerNS = timer_h.addTimerNS;
pub const removeTimer = timer_h.removeTimer;
const touch_h = @import("sdl3/touch.zig");
pub const TouchId = touch_h.TouchId;
pub const FingerId = touch_h.FingerId;
pub const TouchDeviceType = touch_h.TouchDeviceType;
pub const Finger = touch_h.Finger;
pub const touch_mouseid = touch_h.touch_mouseid;
pub const mouse_touchid = touch_h.mouse_touchid;
pub const getTouchDevices = touch_h.getTouchDevices;
pub const getTouchDeviceName = touch_h.getTouchDeviceName;
pub const getTouchDeviceType = touch_h.getTouchDeviceType;
pub const getTouchFingers = touch_h.getTouchFingers;
const tray_h = @import("sdl3/tray.zig");
pub const Tray = tray_h.Tray;
pub const TrayMenu = tray_h.TrayMenu;
pub const TrayEntry = tray_h.TrayEntry;
pub const TrayEntryFlags = tray_h.TrayEntryFlags;
pub const TrayCallback = tray_h.TrayCallback;
pub const createTray = tray_h.createTray;
pub const setTrayIcon = tray_h.setTrayIcon;
pub const setTrayTooltip = tray_h.setTrayTooltip;
pub const createTrayMenu = tray_h.createTrayMenu;
pub const createTraySubmenu = tray_h.createTraySubmenu;
pub const getTrayMenu = tray_h.getTrayMenu;
pub const getTraySubmenu = tray_h.getTraySubmenu;
pub const getTrayEntries = tray_h.getTrayEntries;
pub const removeTrayEntry = tray_h.removeTrayEntry;
pub const insertTrayEntryAt = tray_h.insertTrayEntryAt;
pub const setTrayEntryLabel = tray_h.setTrayEntryLabel;
pub const getTrayEntryLabel = tray_h.getTrayEntryLabel;
pub const setTrayEntryChecked = tray_h.setTrayEntryChecked;
pub const getTrayEntryChecked = tray_h.getTrayEntryChecked;
pub const setTrayEntryEnabled = tray_h.setTrayEntryEnabled;
pub const getTrayEntryEnabled = tray_h.getTrayEntryEnabled;
pub const setTrayEntryCallback = tray_h.setTrayEntryCallback;
pub const clickTrayEntry = tray_h.clickTrayEntry;
pub const destroyTray = tray_h.destroyTray;
pub const getTrayEntryParent = tray_h.getTrayEntryParent;
pub const getTrayMenuParentEntry = tray_h.getTrayMenuParentEntry;
pub const getTrayMenuParentTray = tray_h.getTrayMenuParentTray;
pub const updateTrays = tray_h.updateTrays;
const version_h = @import("sdl3/version.zig");
pub const major_version = version_h.major_version;
pub const minor_version = version_h.minor_version;
pub const micro_version = version_h.micro_version;
pub const Version = version_h.Version;
pub const versionNum = version_h.versionNum;
pub const versionNumMajor = version_h.versionNumMajor;
pub const versionNumMinor = version_h.versionNumMinor;
pub const versionNumMicro = version_h.versionNumMicro;
pub const version = version_h.version;
pub const versionAtLeast = version_h.versionAtLeast;
pub const getVersion = version_h.getVersion;
pub const getRevision = version_h.getRevision;
const video_h = @import("sdl3/video.zig");
pub const DisplayId = video_h.DisplayId;
pub const WindowId = video_h.WindowId;
pub const prop_global_video_wayland_wl_display_pointer = video_h.prop_global_video_wayland_wl_display_pointer;
pub const SystemTheme = video_h.SystemTheme;
pub const DisplayModeData = video_h.DisplayModeData;
pub const DisplayMode = video_h.DisplayMode;
pub const DisplayOrientation = video_h.DisplayOrientation;
pub const Window = video_h.Window;
pub const WindowFlags = video_h.WindowFlags;
pub const posUndefinedDisplay = video_h.posUndefinedDisplay;
pub const pos_undefined = video_h.pos_undefined;
pub const posIsUndefined = video_h.posIsUndefined;
pub const posCenteredDisplay = video_h.posCenteredDisplay;
pub const pos_centered = video_h.pos_centered;
pub const posIsCentered = video_h.posIsCentered;
pub const FlashOperation = video_h.FlashOperation;
pub const ProgressState = video_h.ProgressState;
pub const GLContext = video_h.GLContext;
pub const GLContextState = video_h.GLContextState;
pub const EGLDisplay = video_h.EGLDisplay;
pub const EGLConfig = video_h.EGLConfig;
pub const EGLSurface = video_h.EGLSurface;
pub const EGLAttrib = video_h.EGLAttrib;
pub const EGLint = video_h.EGLint;
pub const EGLAttribArrayCallback = video_h.EGLAttribArrayCallback;
pub const EGLIntArrayCallback = video_h.EGLIntArrayCallback;
pub const egl = video_h.egl;
pub const gl = video_h.gl;
pub const getNumVideoDrivers = video_h.getNumVideoDrivers;
pub const getVideoDriver = video_h.getVideoDriver;
pub const getCurrentVideoDriver = video_h.getCurrentVideoDriver;
pub const getSystemTheme = video_h.getSystemTheme;
pub const getDisplays = video_h.getDisplays;
pub const getPrimaryDisplay = video_h.getPrimaryDisplay;
pub const getDisplayProperties = video_h.getDisplayProperties;
pub const getDisplayName = video_h.getDisplayName;
pub const getDisplayBounds = video_h.getDisplayBounds;
pub const getDisplayUsableBounds = video_h.getDisplayUsableBounds;
pub const getNaturalDisplayOrientation = video_h.getNaturalDisplayOrientation;
pub const getCurrentDisplayOrientation = video_h.getCurrentDisplayOrientation;
pub const getDisplayContentScale = video_h.getDisplayContentScale;
pub const getFullscreenDisplayModes = video_h.getFullscreenDisplayModes;
pub const getClosestFullscreenDisplayMode = video_h.getClosestFullscreenDisplayMode;
pub const getDesktopDisplayMode = video_h.getDesktopDisplayMode;
pub const getCurrentDisplayMode = video_h.getCurrentDisplayMode;
pub const getDisplayForPoint = video_h.getDisplayForPoint;
pub const getDisplayForRect = video_h.getDisplayForRect;
pub const getDisplayForWindow = video_h.getDisplayForWindow;
pub const getWindowPixelDensity = video_h.getWindowPixelDensity;
pub const getWindowDisplayScale = video_h.getWindowDisplayScale;
pub const setWindowFullscreenMode = video_h.setWindowFullscreenMode;
pub const getWindowFullscreenMode = video_h.getWindowFullscreenMode;
pub const getWindowICCProfile = video_h.getWindowICCProfile;
pub const getWindowPixelFormat = video_h.getWindowPixelFormat;
pub const getWindows = video_h.getWindows;
pub const createWindow = video_h.createWindow;
pub const createPopupWindow = video_h.createPopupWindow;
pub const createWindowWithProperties = video_h.createWindowWithProperties;
pub const getWindowId = video_h.getWindowId;
pub const getWindowFromId = video_h.getWindowFromId;
pub const getWindowParent = video_h.getWindowParent;
pub const getWindowProperties = video_h.getWindowProperties;
pub const getWindowFlags = video_h.getWindowFlags;
pub const setWindowTitle = video_h.setWindowTitle;
pub const getWindowTitle = video_h.getWindowTitle;
pub const setWindowIcon = video_h.setWindowIcon;
pub const setWindowPosition = video_h.setWindowPosition;
pub const getWindowPosition = video_h.getWindowPosition;
pub const setWindowSize = video_h.setWindowSize;
pub const getWindowSize = video_h.getWindowSize;
pub const getWindowSafeArea = video_h.getWindowSafeArea;
pub const setWindowAspectRatio = video_h.setWindowAspectRatio;
pub const getWindowAspectRatio = video_h.getWindowAspectRatio;
pub const getWindowBordersSize = video_h.getWindowBordersSize;
pub const getWindowSizeInPixels = video_h.getWindowSizeInPixels;
pub const setWindowMinimumSize = video_h.setWindowMinimumSize;
pub const getWindowMinimumSize = video_h.getWindowMinimumSize;
pub const setWindowMaximumSize = video_h.setWindowMaximumSize;
pub const getWindowMaximumSize = video_h.getWindowMaximumSize;
pub const setWindowBordered = video_h.setWindowBordered;
pub const setWindowResizable = video_h.setWindowResizable;
pub const setWindowAlwaysOnTop = video_h.setWindowAlwaysOnTop;
pub const setWindowFillDocument = video_h.setWindowFillDocument;
pub const showWindow = video_h.showWindow;
pub const hideWindow = video_h.hideWindow;
pub const raiseWindow = video_h.raiseWindow;
pub const maximizeWindow = video_h.maximizeWindow;
pub const minimizeWindow = video_h.minimizeWindow;
pub const restoreWindow = video_h.restoreWindow;
pub const setWindowFullscreen = video_h.setWindowFullscreen;
pub const syncWindow = video_h.syncWindow;
pub const windowHasSurface = video_h.windowHasSurface;
pub const getWindowSurface = video_h.getWindowSurface;
pub const setWindowSurfaceVSync = video_h.setWindowSurfaceVSync;
pub const window_surface_vsync_disabled = video_h.window_surface_vsync_disabled;
pub const window_surface_vsync_adaptive = video_h.window_surface_vsync_adaptive;
pub const getWindowSurfaceVSync = video_h.getWindowSurfaceVSync;
pub const updateWindowSurface = video_h.updateWindowSurface;
pub const updateWindowSurfaceRects = video_h.updateWindowSurfaceRects;
pub const destroyWindowSurface = video_h.destroyWindowSurface;
pub const setWindowKeyboardGrab = video_h.setWindowKeyboardGrab;
pub const setWindowMouseGrab = video_h.setWindowMouseGrab;
pub const getWindowKeyboardGrab = video_h.getWindowKeyboardGrab;
pub const getWindowMouseGrab = video_h.getWindowMouseGrab;
pub const getGrabbedWindow = video_h.getGrabbedWindow;
pub const setWindowMouseRect = video_h.setWindowMouseRect;
pub const getWindowMouseRect = video_h.getWindowMouseRect;
pub const setWindowOpacity = video_h.setWindowOpacity;
pub const getWindowOpacity = video_h.getWindowOpacity;
pub const setWindowParent = video_h.setWindowParent;
pub const setWindowModal = video_h.setWindowModal;
pub const setWindowFocusable = video_h.setWindowFocusable;
pub const showWindowSystemMenu = video_h.showWindowSystemMenu;
pub const HitTestResult = video_h.HitTestResult;
pub const HitTest = video_h.HitTest;
pub const setWindowHitTest = video_h.setWindowHitTest;
pub const setWindowShape = video_h.setWindowShape;
pub const flashWindow = video_h.flashWindow;
pub const setWindowProgressState = video_h.setWindowProgressState;
pub const getWindowProgressState = video_h.getWindowProgressState;
pub const setWindowProgressValue = video_h.setWindowProgressValue;
pub const getWindowProgressValue = video_h.getWindowProgressValue;
pub const destroyWindow = video_h.destroyWindow;
pub const screenSaverEnabled = video_h.screenSaverEnabled;
pub const enableScreenSaver = video_h.enableScreenSaver;
pub const disableScreenSaver = video_h.disableScreenSaver;
const vulkan_h = @import("sdl3/vulkan.zig");
pub const vk = vulkan_h.vk;

test {
    refAllDeclsRecursive(@This(), 4);
}

test "every public declaration is re-exported" {
    @setEvalBranchQuota(100_000);
    inline for (modules) |M| {
        inline for (comptime std.meta.declarations(M)) |decl| {
            if (!@hasDecl(@This(), decl)) @compileError("missing re-export: " ++ decl);
        }
    }
}

/// Functions that are only exported by SDL builds for their own platform.
/// Tests skip them unless targeting that platform.
fn mayBeMissingFromSdl(comptime name: []const u8) bool {
    @setEvalBranchQuota(10_000_000);
    const os = @import("builtin").os.tag;
    const abi = @import("builtin").abi;
    const groups = .{
        .{ abi.isAndroid(), .{
            "getAndroidJNIEnv",              "getAndroidActivity",             "getAndroidSDKVersion",
            "isChromebook",                  "isDeXMode",                      "sendAndroidBackButton",
            "getAndroidInternalStoragePath", "getAndroidExternalStorageState", "getAndroidExternalStoragePath",
            "getAndroidCachePath",           "requestAndroidPermission",       "showAndroidToast",
            "sendAndroidMessage",
        } },
        .{ os == .windows, .{
            "setWindowsMessageHook", "getDirect3D9AdapterIndex", "getDXGIOutputInfo",
            "registerApp",           "unregisterApp",            "getGDKTaskQueue",
            "getGDKDefaultUser",     "gdkSuspendGPU",            "gdkResumeGPU",
            "gdkSuspend",            "gdkResume",
        } },
        .{ os == .ios or os == .tvos or os == .visionos, .{
            "setiOSAnimationCallback", "setiOSEventPump", "onApplicationDidChangeStatusBarOrientation",
        } },
    };
    inline for (groups) |group| {
        if (!group[0]) inline for (group[1]) |n| {
            if (comptime std.mem.eql(u8, n, name)) return true;
        };
    }
    return false;
}

fn refAllDeclsRecursive(comptime T: type, comptime depth: u32) void {
    @setEvalBranchQuota(10_000_000);
    inline for (comptime std.meta.declarations(T)) |decl| {
        if (comptime mayBeMissingFromSdl(decl)) continue;
        const D = @field(T, decl);
        if (@TypeOf(D) == type) {
            if (depth > 0) switch (@typeInfo(D)) {
                .@"struct", .@"enum", .@"union", .@"opaque" => refAllDeclsRecursive(D, depth - 1),
                else => {},
            };
        } else {
            _ = &@field(T, decl);
        }
    }
}

pub const Error = error{SdlError};

/// Logs the current SDL error (see `getError`) and returns `error.SdlError`.
///
/// Logging is currently disabled to keep the original SDL3 workflow, the error will only be returned.
pub fn makeError() error{SdlError} {
    //const str = getError();
    //if (str.len > 0) logError(.@"error", "{s}", .{str});
    return error.SdlError;
}

// @generated-exports
// Everything below is re-exported from src/sdl3/*.zig, in header declaration order.

//--------------------------------------------------------------------------------------------------
// Application entry points (SDL_main.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Initialization and Shutdown (SDL_init.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Configuration Variables (SDL_hints.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Object Properties (SDL_properties.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Error Handling (SDL_error.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Log Handling (SDL_log.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Assertions (SDL_assert.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Querying SDL Version (SDL_version.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Display and Window Management (SDL_video.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// 2D Accelerated Rendering (SDL_render.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Pixel Formats and Conversion Routines (SDL_pixels.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Blend modes (SDL_blendmode.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Rectangle Functions (SDL_rect.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Surface Creation and Simple Drawing (SDL_surface.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Clipboard Handling (SDL_clipboard.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Vulkan Support (SDL_vulkan.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Metal Support (SDL_metal.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Camera (SDL_camera.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Event Handling (SDL_events.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Keyboard Support (SDL_keyboard.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Keyboard Scancodes (SDL_scancode.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Keyboard Keycodes (SDL_keycode.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Mouse Support (SDL_mouse.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Joystick Support (SDL_joystick.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Gamepad Support (SDL_gamepad.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Touch Support (SDL_touch.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Pen Support (SDL_pen.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Sensors (SDL_sensor.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// HIDAPI (SDL_hidapi.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Force Feedback Support (SDL_haptic.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Audio Device Management, Playing and Recording (SDL_audio.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// 3D Rendering and GPU Compute (SDL_gpu.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Thread Management (SDL_thread.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Thread Synchronization Primitives (SDL_mutex.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Atomic Operations (SDL_atomic.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Timer Support (SDL_timer.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Date and Time (SDL_time.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Filesystem Access (SDL_filesystem.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Storage Abstraction (SDL_storage.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// I/O Streams (SDL_iostream.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Async I/O (SDL_asyncio.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Shared Object/DLL Management (SDL_loadso.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Platform Detection (SDL_platform.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// CPU Feature Detection (SDL_cpuinfo.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Byte Order and Byte Swapping (SDL_endian.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Bit Manipulation (SDL_bits.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Power Management Status (SDL_power.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Process Control (SDL_process.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Message Boxes (SDL_messagebox.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// File Dialogs (SDL_dialog.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// System Tray (SDL_tray.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Locale Info (SDL_locale.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Platform-specific Functionality (SDL_system.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Standard Library Functionality (SDL_stdinc.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// GUIDs (SDL_guid.h)
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
// Miscellaneous (SDL_misc.h)
//--------------------------------------------------------------------------------------------------
const modules = .{
    main_h,
    init_h,
    hints_h,
    properties_h,
    error_h,
    log_h,
    assert_h,
    version_h,
    video_h,
    render_h,
    pixels_h,
    blendmode_h,
    rect_h,
    surface_h,
    clipboard_h,
    vulkan_h,
    metal_h,
    camera_h,
    events_h,
    keyboard_h,
    scancode_h,
    keycode_h,
    mouse_h,
    joystick_h,
    gamepad_h,
    touch_h,
    pen_h,
    sensor_h,
    hidapi_h,
    haptic_h,
    audio_h,
    gpu_h,
    thread_h,
    mutex_h,
    atomic_h,
    timer_h,
    time_h,
    filesystem_h,
    storage_h,
    iostream_h,
    asyncio_h,
    loadso_h,
    platform_h,
    cpuinfo_h,
    endian_h,
    bits_h,
    power_h,
    process_h,
    messagebox_h,
    dialog_h,
    tray_h,
    locale_h,
    system_h,
    stdinc_h,
    guid_h,
    misc_h,
};
