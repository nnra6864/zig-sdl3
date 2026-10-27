# zig-sdl3

Zig bindings for [SDL3](https://libsdl.org) 3.4.18.

- Covers every SDL3 header, one Zig file per header under `src/sdl3/`, re-exported flat from `src/sdl3.zig` (`sdl.createWindow`, `sdl.Window`, ...).
- Zig-friendly signatures: slices instead of pointer + length, `Error!T` instead of `bool`/null returns, results returned instead of written to out-pointers, packed structs for flags.
- Opaque handles have method aliases (`window.setTitle(...)`, `renderer.clear()`), and their property names live in `Type.Properties`.
- Doc comments come from the SDL headers, with C names converted to their Zig equivalents.
- SDL is built from source with [castholm/SDL](https://github.com/castholm/SDL), so no prebuilt binaries or CMake are needed. You can link the system's SDL3 instead.

Requires Zig 0.17.0.

## Usage

```sh
zig fetch --save git+https://git.nnstdios.com/nnra6864/zig-sdl3
```

In `build.zig`:

```zig
const sdl3 = b.dependency("zig_sdl3", .{ .target = target, .optimize = optimize });
exe.root_module.addImport("sdl3", sdl3.module("sdl3"));
```

Importing the module links SDL3 for you.

```zig
const sdl = @import("sdl3");

pub fn main() !void {
    try sdl.init(.{ .video = true });
    defer sdl.quit();

    const window = try sdl.createWindow("Hello SDL3", 800, 600, .{ .resizable = true });
    defer window.destroy();
    const renderer = try sdl.createRenderer(window, null);
    defer renderer.destroy();

    main_loop: while (true) {
        var event: sdl.Event = undefined;
        while (sdl.pollEvent(&event)) {
            if (event.type == .quit) break :main_loop;
        }
        try renderer.setDrawColor(30, 30, 46, 255);
        try renderer.clear();
        try renderer.present();
    }
}
```

### Build options

| Option | Default | Description |
| --- | --- | --- |
| `system_sdl` | `false` | Link the SDL3 installed on the system instead of building it from source. |
| `linkage` | `static` | Build SDL3 as a `static` or `dynamic` library. |
| `system_include_path`, `system_framework_path`, `library_path` | | Paths into a macOS SDK, required when cross-compiling for macOS. |

With `linkage = .dynamic`, install the library next to your executable with
`b.installArtifact(sdl3.artifact("SDL3"))`.

## Not bound

- Most of `SDL_stdinc.h` (strings, math, sorting, ...): use Zig's `std`. Memory functions, `Time` and `sdl.allocator` (a `std.mem.Allocator` backed by SDL) are bound.
- C-only macros and functions that take a `va_list`. The printf-style functions (`log*`, `setError`, `ioPrintf`, ...) take a `std.fmt` format string instead.
- `SDL_main`/`SDL_App*`, which your program implements. Use `sdl.runApp` or `sdl.enterAppMainCallbacks`.

## Testing

```sh
zig build test                     # builds SDL from source
zig build test -Dsystem_sdl=true   # uses the system SDL3
```

## License

The bindings are released into the public domain under [CC0 1.0](LICENSE).

SDL itself is © Sam Lantinga and distributed under the
[zlib license](https://github.com/libsdl-org/SDL/blob/main/LICENSE.txt). The doc
comments in `src/sdl3/` are adapted from SDL's headers and remain under that
license.
