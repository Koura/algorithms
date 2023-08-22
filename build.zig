const Builder = @import("std").build.Builder;

pub fn buildExample(b: *Builder, comptime path: []const u8, comptime name: []const u8) void {
    //TODO: find a way to include these in the build
    // const target = b.standardTargetOptions(.{});
    // const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{ .name = name, .root_source_file = .{ .path = path ++ "/" ++ name ++ ".zig" } });
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
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
    buildExample(b, "search_trees", "b_tree_search");
    buildExample(b, "search_trees", "trie");
}
