const Builder = @import("std").build.Builder;
const fmt = std.fmt;

pub fn buildExample(b: *Builder, comptime name: []const u8) void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable(name, "sorting/" ++ name ++ ".zig");
    exe.setBuildMode(mode);
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step(name, "Run the algorithm");
    run_step.dependOn(&run_cmd.step);
}

pub fn build(b: *Builder) void {
    buildExample(b, "bubble_sort");
    buildExample(b, "heap_sort");
    buildExample(b, "insertion_sort");
    buildExample(b, "radix_sort");
    buildExample(b, "quicksort");
}
