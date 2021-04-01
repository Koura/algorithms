const Builder = @import("std").build.Builder;
const fmt = std.fmt;

pub fn buildExample(b: *Builder, comptime path: []const u8, comptime name: []const u8) void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable(name, path ++ "/" ++ name ++ ".zig");
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
    buildExample(b, "sorting", "bubble_sort");
    buildExample(b, "sorting", "heap_sort");
    buildExample(b, "sorting", "insertion_sort");
    buildExample(b, "sorting", "radix_sort");
    buildExample(b, "sorting", "quicksort");
    buildExample(b, "search_trees", "binary_search_tree");
}
