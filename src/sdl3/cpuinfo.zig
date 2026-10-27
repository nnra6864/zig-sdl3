//! CPU Feature Detection (SDL_cpuinfo.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");

/// A guess for the cacheline size used for padding.
///
/// Most x86 processors have a 64 byte cache line. The 64-bit PowerPC
/// processors have a 128 byte cache line. We use the larger value to be
/// generally safe.
pub const cacheline_size = 128;

/// Get the number of logical CPU cores available.
pub const getNumLogicalCPUCores = SDL_GetNumLogicalCPUCores;
extern fn SDL_GetNumLogicalCPUCores() c_int;

/// Determine the L1 cache line size of the CPU.
///
/// This is useful for determining multi-threaded structure padding or SIMD
/// prefetch sizes.
pub const getCPUCacheLineSize = SDL_GetCPUCacheLineSize;
extern fn SDL_GetCPUCacheLineSize() c_int;

/// Determine whether the CPU has AltiVec features.
///
/// This always returns false on CPUs that aren't using PowerPC instruction
/// sets.
pub const hasAltiVec = SDL_HasAltiVec;
extern fn SDL_HasAltiVec() bool;

/// Determine whether the CPU has MMX features.
///
/// This always returns false on CPUs that aren't using Intel instruction sets.
pub const hasMMX = SDL_HasMMX;
extern fn SDL_HasMMX() bool;

/// Determine whether the CPU has SSE features.
///
/// This always returns false on CPUs that aren't using Intel instruction sets.
pub const hasSSE = SDL_HasSSE;
extern fn SDL_HasSSE() bool;

/// Determine whether the CPU has SSE2 features.
///
/// This always returns false on CPUs that aren't using Intel instruction sets.
pub const hasSSE2 = SDL_HasSSE2;
extern fn SDL_HasSSE2() bool;

/// Determine whether the CPU has SSE3 features.
///
/// This always returns false on CPUs that aren't using Intel instruction sets.
pub const hasSSE3 = SDL_HasSSE3;
extern fn SDL_HasSSE3() bool;

/// Determine whether the CPU has SSE4.1 features.
///
/// This always returns false on CPUs that aren't using Intel instruction sets.
pub const hasSSE41 = SDL_HasSSE41;
extern fn SDL_HasSSE41() bool;

/// Determine whether the CPU has SSE4.2 features.
///
/// This always returns false on CPUs that aren't using Intel instruction sets.
pub const hasSSE42 = SDL_HasSSE42;
extern fn SDL_HasSSE42() bool;

/// Determine whether the CPU has AVX features.
///
/// This always returns false on CPUs that aren't using Intel instruction sets.
pub const hasAVX = SDL_HasAVX;
extern fn SDL_HasAVX() bool;

/// Determine whether the CPU has AVX2 features.
///
/// This always returns false on CPUs that aren't using Intel instruction sets.
pub const hasAVX2 = SDL_HasAVX2;
extern fn SDL_HasAVX2() bool;

/// Determine whether the CPU has AVX-512F (foundation) features.
///
/// This always returns false on CPUs that aren't using Intel instruction sets.
pub const hasAVX512F = SDL_HasAVX512F;
extern fn SDL_HasAVX512F() bool;

/// Determine whether the CPU has ARM SIMD (ARMv6) features.
///
/// This is different from ARM NEON, which is a different instruction set.
///
/// This always returns false on CPUs that aren't using ARM instruction sets.
pub const hasARMSIMD = SDL_HasARMSIMD;
extern fn SDL_HasARMSIMD() bool;

/// Determine whether the CPU has NEON (ARM SIMD) features.
///
/// This always returns false on CPUs that aren't using ARM instruction sets.
pub const hasNEON = SDL_HasNEON;
extern fn SDL_HasNEON() bool;

/// Determine whether the CPU has LSX (LOONGARCH SIMD) features.
///
/// This always returns false on CPUs that aren't using LOONGARCH instruction
/// sets.
pub const hasLSX = SDL_HasLSX;
extern fn SDL_HasLSX() bool;

/// Determine whether the CPU has LASX (LOONGARCH SIMD) features.
///
/// This always returns false on CPUs that aren't using LOONGARCH instruction
/// sets.
pub const hasLASX = SDL_HasLASX;
extern fn SDL_HasLASX() bool;

/// Get the amount of RAM configured in the system.
pub const getSystemRAM = SDL_GetSystemRAM;
extern fn SDL_GetSystemRAM() c_int;

/// Report the alignment this system needs for SIMD allocations.
///
/// This will return the minimum number of bytes to which a pointer must be
/// aligned to be compatible with SIMD instructions on the current machine. For
/// example, if the machine supports SSE only, it will return 16, but if it
/// supports AVX-512F, it'll return 64 (etc). This only reports values for
/// instruction sets SDL knows about, so if your SDL build doesn't have
/// `hasAVX512F`, then it might return 16 for the SSE support it sees and
/// not 64 for the AVX-512 instructions that exist but SDL doesn't know about.
/// Plan accordingly.
pub const getSIMDAlignment = SDL_GetSIMDAlignment;
extern fn SDL_GetSIMDAlignment() usize;

/// Report the size of a page of memory.
///
/// Different platforms might have different memory page sizes. In current
/// times, 4 kilobytes is not unusual, but newer systems are moving to larger
/// page sizes, and esoteric platforms might have any unexpected size.
///
/// Note that this function can return 0, which means SDL can't determine the
/// page size on this platform. It will _not_ set an error string to be
/// retrieved with `getError` in this case! In this case, defaulting to
/// 4096 is often a reasonable option.
pub const getSystemPageSize = SDL_GetSystemPageSize;
extern fn SDL_GetSystemPageSize() c_int;
