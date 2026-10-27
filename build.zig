const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const system_sdl = b.option(
        bool,
        "system_sdl",
        "Link the SDL3 installed on the system instead of building it from source (default: false)",
    ) orelse false;
    const linkage = b.option(
        std.builtin.LinkMode,
        "linkage",
        "Build SDL3 as a static or a dynamic library (default: static)",
    ) orelse .static;
    // Needed by castholm/SDL when cross-compiling for macOS (point them at a macOS SDK).
    const system_include_path = b.option(std.Build.LazyPath, "system_include_path", "System header search path for cross-compiling");
    const system_framework_path = b.option(std.Build.LazyPath, "system_framework_path", "System framework search path for cross-compiling");
    const library_path = b.option(std.Build.LazyPath, "library_path", "Library search path for cross-compiling");

    const sdl3 = b.addModule("sdl3", .{
        .root_source_file = b.path("src/sdl3.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    if (system_sdl) {
        sdl3.linkSystemLibrary("SDL3", .{});
    } else if (b.lazyDependency("sdl", .{
        .target = target,
        .optimize = optimize,
        .preferred_linkage = linkage,
        .system_include_path = system_include_path,
        .system_framework_path = system_framework_path,
        .library_path = library_path,
    })) |sdl_dep| {
        const lib = sdl_dep.artifact("SDL3");
        sdl3.linkLibrary(lib);
        // Installed so dependents can get it with `dependency.artifact("SDL3")`,
        // e.g. to install the shared library next to their executable.
        b.installArtifact(lib);
    }

    const tests = b.addTest(.{ .root_module = sdl3 });
    const test_step = b.step("test", "Run the binding tests");
    test_step.dependOn(&b.addRunArtifact(tests).step);
}
