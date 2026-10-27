//! Querying SDL Version (SDL_version.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");

/// The current major version of SDL headers.
///
/// If this were SDL version 3.2.1, this value would be 3.
pub const major_version = 3;

/// The current minor version of the SDL headers.
///
/// If this were SDL version 3.2.1, this value would be 2.
pub const minor_version = 4;

/// The current micro (or patchlevel) version of the SDL headers.
///
/// If this were SDL version 3.2.1, this value would be 1.
pub const micro_version = 18;

/// An SDL version, as decoded from a version number (see `versionNum`).
pub const Version = struct {
    major: u32,
    minor: u32,
    micro: u32,

    /// Decode a version number created by `versionNum`.
    pub fn fromNum(num: c_int) Version {
        return .{
            .major = versionNumMajor(num),
            .minor = versionNumMinor(num),
            .micro = versionNumMicro(num),
        };
    }

    /// Encode this version as a version number, as returned by `getVersion`.
    pub fn toNum(self: Version) c_int {
        return versionNum(self.major, self.minor, self.micro);
    }

    /// Check if this version is at least `major.minor.micro`.
    pub fn atLeast(self: Version, major: u32, minor: u32, micro: u32) bool {
        return self.toNum() >= versionNum(major, minor, micro);
    }
};

/// This macro turns the version numbers into a numeric value.
///
/// (1,2,3) becomes 1002003.
pub fn versionNum(major: u32, minor: u32, micro: u32) c_int {
    return @intCast(major * 1000000 + minor * 1000 + micro);
}

/// This macro extracts the major version from a version number
///
/// 1002003 becomes 1.
pub fn versionNumMajor(num: c_int) u32 {
    return @intCast(@divTrunc(num, 1000000));
}

/// This macro extracts the minor version from a version number
///
/// 1002003 becomes 2.
pub fn versionNumMinor(num: c_int) u32 {
    return @intCast(@mod(@divTrunc(num, 1000), 1000));
}

/// This macro extracts the micro version from a version number
///
/// 1002003 becomes 3.
pub fn versionNumMicro(num: c_int) u32 {
    return @intCast(@mod(num, 1000));
}

/// This is the version number of the SDL headers these bindings were written against.
pub const version = versionNum(major_version, minor_version, micro_version);

/// This macro will evaluate to true if compiled with SDL at least X.Y.Z.
pub fn versionAtLeast(x: u32, y: u32, z: u32) bool {
    return version >= versionNum(x, y, z);
}

/// Get the version of SDL that is linked against your program.
///
/// If you are linking to SDL dynamically, then it is possible that the current
/// version will be different than the version you compiled against. This
/// function returns the current version, while `version` is the version you
/// compiled with.
///
/// This function may be called safely at any time, even before `init`.
pub fn getVersion() Version {
    return .fromNum(SDL_GetVersion());
}
extern fn SDL_GetVersion() c_int;

/// Get the code revision of the SDL library that is linked against your
/// program.
///
/// This value is the revision of the code you are linking against and may be
/// different from the code you are compiling with.
///
/// The revision is an arbitrary string (a hash value) uniquely identifying the
/// exact revision of the SDL library in use, and is only useful in comparing
/// against other revisions. It is NOT an incrementing number.
///
/// If SDL wasn't built from a git repository with the appropriate tools, this
/// will return an empty string.
///
/// You shouldn't use this function for anything but logging it for debugging
/// purposes. The string is not intended to be reliable in any way.
pub fn getRevision() [:0]const u8 {
    return std.mem.span(SDL_GetRevision());
}
extern fn SDL_GetRevision() [*:0]const u8;
