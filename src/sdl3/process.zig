//! Process Control (SDL_process.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// An opaque handle representing a system process.
pub const Process = opaque {
    pub const Properties = struct {
        pub const create_args_pointer = "SDL.process.create.args";
        pub const create_environment_pointer = "SDL.process.create.environment";
        pub const create_working_directory_string = "SDL.process.create.working_directory";
        pub const create_stdin_number = "SDL.process.create.stdin_option";
        pub const create_stdin_pointer = "SDL.process.create.stdin_source";
        pub const create_stdout_number = "SDL.process.create.stdout_option";
        pub const create_stdout_pointer = "SDL.process.create.stdout_source";
        pub const create_stderr_number = "SDL.process.create.stderr_option";
        pub const create_stderr_pointer = "SDL.process.create.stderr_source";
        pub const create_stderr_to_stdout_boolean = "SDL.process.create.stderr_to_stdout";
        pub const create_background_boolean = "SDL.process.create.background";
        pub const create_cmdline_string = "SDL.process.create.cmdline";
        pub const pid_number = "SDL.process.pid";
        pub const stdin_pointer = "SDL.process.stdin";
        pub const stdout_pointer = "SDL.process.stdout";
        pub const stderr_pointer = "SDL.process.stderr";
        pub const background_boolean = "SDL.process.background";
    };
    pub const create = createProcess;
    pub const createWithProperties = createProcessWithProperties;
    pub const getProperties = getProcessProperties;
    pub const read = readProcess;
    pub const getInput = getProcessInput;
    pub const getOutput = getProcessOutput;
    pub const kill = killProcess;
    pub const wait = waitProcess;
    pub const destroy = destroyProcess;
};

/// Create a new process.
///
/// The path to the executable is supplied in args[0]. args[1..N] are
/// additional arguments passed on the command line of the new process, and the
/// argument list should be terminated with a null, e.g.:
///
/// ```c
/// const char *args[] = { "myprogram", "argument", NULL };
/// ```
///
/// Setting pipe_stdio to true is equivalent to setting
/// `Process.Properties.create_stdin_number` and
/// `Process.Properties.create_stdout_number` to `ProcessIO.app`, and
/// will allow the use of `readProcess` or `getProcessInput` and
/// `getProcessOutput`.
///
/// See `createProcessWithProperties` for more details.
pub fn createProcess(args: [*:null]const ?[*:0]const u8, pipe_stdio: bool) Error!*Process {
    return SDL_CreateProcess(args, pipe_stdio) orelse makeError();
}
extern fn SDL_CreateProcess(args: [*:null]const ?[*:0]const u8, pipe_stdio: bool) ?*Process;

/// Description of where standard I/O should be directed when creating a
/// process.
///
/// If a standard I/O stream is set to `ProcessIO.inherited`, it will go
/// to the same place as the application's I/O stream. This is the default for
/// standard output and standard error.
///
/// If a standard I/O stream is set to `ProcessIO.@"null"`, it is connected
/// to `NUL:` on Windows and `/dev/null` on POSIX systems. This is the default
/// for standard input.
///
/// If a standard I/O stream is set to `ProcessIO.app`, it is connected
/// to a new `IOStream` that is available to the application. Standard input
/// will be available as `Process.Properties.stdin_pointer` and allows
/// `getProcessInput`, standard output will be available as
/// `Process.Properties.stdout_pointer` and allows `readProcess` and
/// `getProcessOutput`, and standard error will be available as
/// `Process.Properties.stderr_pointer` in the properties for the created
/// process.
///
/// If a standard I/O stream is set to `ProcessIO.redirect`, it is
/// connected to an existing `IOStream` provided by the application. Standard
/// input is provided using `Process.Properties.create_stdin_pointer`, standard
/// output is provided using `Process.Properties.create_stdout_pointer`, and
/// standard error is provided using `Process.Properties.create_stderr_pointer`
/// in the creation properties. These existing streams should be closed by the
/// application once the new process is created.
///
/// In order to use an `IOStream` with `ProcessIO.redirect`, it must
/// have `IOStream.Properties.windows_handle_pointer` or
/// `IOStream.Properties.file_descriptor_number` set. This is true for streams
/// representing files and process I/O.
pub const ProcessIO = enum(c_int) {
    /// The I/O stream is inherited from the application.
    inherited,
    /// The I/O stream is ignored.
    null,
    /// The I/O stream is connected to a new `IOStream` that the application can read or write
    app,
    /// The I/O stream is redirected to an existing `IOStream`.
    redirect,
};

/// Create a new process with the specified properties.
///
/// These are the supported properties:
///
/// - `Process.Properties.create_args_pointer`: an array of strings containing
///   the program to run, any arguments, and a null pointer, e.g. const char
///   *args[] = { "myprogram", "argument", null }. This is a required property.
/// - `Process.Properties.create_environment_pointer`: an `Environment`
///   pointer. If this property is set, it will be the entire environment for
///   the process, otherwise the current environment is used.
/// - `Process.Properties.create_working_directory_string`: a UTF-8 encoded
///   string representing the working directory for the process, defaults to
///   the current working directory.
/// - `Process.Properties.create_stdin_number`: a `ProcessIO` value describing
///   where standard input for the process comes from, defaults to
///   `ProcessIO.@"null"`.
/// - `Process.Properties.create_stdin_pointer`: an `IOStream` pointer used for
///   standard input when `Process.Properties.create_stdin_number` is set to
///   `ProcessIO.redirect`.
/// - `Process.Properties.create_stdout_number`: a `ProcessIO` value
///   describing where standard output for the process goes to, defaults to
///   `ProcessIO.inherited`.
/// - `Process.Properties.create_stdout_pointer`: an `IOStream` pointer used
///   for standard output when `Process.Properties.create_stdout_number` is set
///   to `ProcessIO.redirect`.
/// - `Process.Properties.create_stderr_number`: a `ProcessIO` value
///   describing where standard error for the process goes to, defaults to
///   `ProcessIO.inherited`.
/// - `Process.Properties.create_stderr_pointer`: an `IOStream` pointer used
///   for standard error when `Process.Properties.create_stderr_number` is set to
///   `ProcessIO.redirect`.
/// - `Process.Properties.create_stderr_to_stdout_boolean`: true if the error
///   output of the process should be redirected into the standard output of
///   the process. This property has no effect if
///   `Process.Properties.create_stderr_number` is set.
/// - `Process.Properties.create_background_boolean`: true if the process should
///   run in the background. In this case the default input and output is
///   `ProcessIO.@"null"` and the exitcode of the process is not
///   available, and will always be 0.
/// - `Process.Properties.create_cmdline_string`: a string containing the program
///   to run and any parameters. This string is passed directly to
///   `CreateProcess` on Windows, and does nothing on other platforms. This
///   property is only important if you want to start programs that does
///   non-standard command-line processing, and in most cases using
///   `Process.Properties.create_args_pointer` is sufficient.
///
/// On POSIX platforms, wait() and waitpid(-1, ...) should not be called, and
/// SIGCHLD should not be ignored or handled because those would prevent SDL
/// from properly tracking the lifetime of the underlying process. You should
/// use `waitProcess` instead.
pub fn createProcessWithProperties(props: sdl.PropertiesId) Error!*Process {
    return SDL_CreateProcessWithProperties(props) orelse makeError();
}
extern fn SDL_CreateProcessWithProperties(props: sdl.PropertiesId) ?*Process;

/// Get the properties associated with a process.
///
/// The following read-only properties are provided by SDL:
///
/// - `Process.Properties.pid_number`: the process ID of the process.
/// - `Process.Properties.stdin_pointer`: an `IOStream` that can be used to
///   write input to the process, if it was created with
///   `Process.Properties.create_stdin_number` set to `ProcessIO.app`.
/// - `Process.Properties.stdout_pointer`: a non-blocking `IOStream` that can
///   be used to read output from the process, if it was created with
///   `Process.Properties.create_stdout_number` set to `ProcessIO.app`.
/// - `Process.Properties.stderr_pointer`: a non-blocking `IOStream` that can
///   be used to read error output from the process, if it was created with
///   `Process.Properties.create_stderr_number` set to `ProcessIO.app`.
/// - `Process.Properties.background_boolean`: true if the process is running in
///   the background.
pub fn getProcessProperties(process: *Process) Error!sdl.PropertiesId {
    const result = SDL_GetProcessProperties(process);
    if (@backingInt(result) == 0) return makeError();
    return result;
}
extern fn SDL_GetProcessProperties(process: *Process) sdl.PropertiesId;

/// Read all the output from a process.
///
/// If a process was created with I/O enabled, you can use this function to
/// read the output. This function blocks until the process is complete,
/// capturing all output, and providing the process exit code.
///
/// The data is allocated with a zero byte at the end (null terminated) for
/// convenience. This extra byte is not included in the value reported via
/// `datasize`.
///
/// The data should be freed with `free`.
pub fn readProcess(process: *Process) Error!struct { data: [:0]u8, exitcode: c_int } {
    var datasize: usize = undefined;
    var exitcode: c_int = undefined;
    const ptr: [*:0]u8 = @ptrCast(SDL_ReadProcess(process, &datasize, &exitcode) orelse return makeError());
    return .{ .data = ptr[0..datasize :0], .exitcode = exitcode };
}
extern fn SDL_ReadProcess(process: *Process, datasize: ?*usize, exitcode: ?*c_int) ?*anyopaque;

/// Get the `IOStream` associated with process standard input.
///
/// The process must have been created with `createProcess` and pipe_stdio
/// set to true, or with `createProcessWithProperties` and
/// `Process.Properties.create_stdin_number` set to `ProcessIO.app`.
///
/// Writing to this stream can return less data than expected if the process
/// hasn't read its input. It may be blocked waiting for its output to be read,
/// if so you may need to call `getProcessOutput` and read the output in
/// parallel with writing input.
pub fn getProcessInput(process: *Process) Error!*sdl.IOStream {
    return SDL_GetProcessInput(process) orelse makeError();
}
extern fn SDL_GetProcessInput(process: *Process) ?*sdl.IOStream;

/// Get the `IOStream` associated with process standard output.
///
/// The process must have been created with `createProcess` and pipe_stdio
/// set to true, or with `createProcessWithProperties` and
/// `Process.Properties.create_stdout_number` set to `ProcessIO.app`.
///
/// Reading from this stream can return 0 with `getIOStatus` returning
/// `IOStatus.not_ready` if no output is available yet.
pub fn getProcessOutput(process: *Process) Error!*sdl.IOStream {
    return SDL_GetProcessOutput(process) orelse makeError();
}
extern fn SDL_GetProcessOutput(process: *Process) ?*sdl.IOStream;

/// Stop a process.
pub fn killProcess(process: *Process, force: bool) Error!void {
    if (!SDL_KillProcess(process, force)) return makeError();
}
extern fn SDL_KillProcess(process: *Process, force: bool) bool;

/// Wait for a process to finish.
///
/// This can be called multiple times to get the status of a process.
///
/// The exit code will be the exit code of the process if it terminates
/// normally, a negative signal if it terminated due to a signal, or -255
/// otherwise. It will not be changed if the process is still running.
///
/// If you create a process with standard output piped to the application
/// (`pipe_stdio` being true) then you should read all of the process output
/// before calling `waitProcess`. If you don't do this the process might be
/// blocked indefinitely waiting for output to be read and `waitProcess`
/// will never return true;
///
/// Returns the exit code of the process, or null if the process is still
/// running.
pub fn waitProcess(process: *Process, block: bool) ?c_int {
    var exitcode: c_int = undefined;
    if (!SDL_WaitProcess(process, block, &exitcode)) return null;
    return exitcode;
}
extern fn SDL_WaitProcess(process: *Process, block: bool, exitcode: ?*c_int) bool;

/// Destroy a previously created process object.
///
/// Note that this does not stop the process, just destroys the SDL object used
/// to track it. If you want to stop the process you should use
/// `killProcess`.
pub const destroyProcess = SDL_DestroyProcess;
extern fn SDL_DestroyProcess(process: *Process) void;

test "run a process and read its output" {
    if (@import("builtin").os.tag != .linux) return error.SkipZigTest;
    const args = [_:null]?[*:0]const u8{ "echo", "hello" };
    const process = try createProcess(&args, true);
    defer destroyProcess(process);
    const result = try readProcess(process);
    defer sdl.free(result.data.ptr);
    try std.testing.expectEqualStrings("hello\n", result.data);
    try std.testing.expectEqual(0, result.exitcode);
}
