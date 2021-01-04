usingnamespace @import("std").builtin;
/// Deprecated
pub const arch = Target.current.cpu.arch;
/// Deprecated
pub const endian = Target.current.cpu.arch.endian();
pub const output_mode = OutputMode.Exe;
pub const link_mode = LinkMode.Static;
pub const is_test = false;
pub const single_threaded = false;
pub const abi = Abi.gnu;
pub const cpu: Cpu = Cpu{
    .arch = .x86_64,
    .model = &Target.x86.cpu.skylake,
    .features = Target.x86.featureSet(&[_]Target.x86.Feature{
        .@"64bit",
        .@"adx",
        .@"aes",
        .@"avx",
        .@"avx2",
        .@"bmi",
        .@"bmi2",
        .@"clflushopt",
        .@"cmov",
        .@"cx16",
        .@"cx8",
        .@"ermsb",
        .@"f16c",
        .@"false_deps_popcnt",
        .@"fast_15bytenop",
        .@"fast_gather",
        .@"fast_scalar_fsqrt",
        .@"fast_shld_rotate",
        .@"fast_variable_shuffle",
        .@"fast_vector_fsqrt",
        .@"fma",
        .@"fsgsbase",
        .@"fxsr",
        .@"idivq_to_divl",
        .@"invpcid",
        .@"lzcnt",
        .@"macrofusion",
        .@"merge_to_threeway_branch",
        .@"mmx",
        .@"movbe",
        .@"nopl",
        .@"pclmul",
        .@"popcnt",
        .@"prfchw",
        .@"rdrnd",
        .@"rdseed",
        .@"sahf",
        .@"sgx",
        .@"slow_3ops_lea",
        .@"sse",
        .@"sse2",
        .@"sse3",
        .@"sse4_1",
        .@"sse4_2",
        .@"ssse3",
        .@"vzeroupper",
        .@"x87",
        .@"xsave",
        .@"xsavec",
        .@"xsaveopt",
        .@"xsaves",
    }),
};
pub const os = Os{
    .tag = .linux,
    .version_range = .{ .linux = .{
        .range = .{
            .min = .{
                .major = 4,
                .minor = 15,
                .patch = 0,
            },
            .max = .{
                .major = 4,
                .minor = 15,
                .patch = 0,
            },
        },
        .glibc = .{
            .major = 2,
            .minor = 17,
            .patch = 0,
        },
    }},
};
pub const object_format = ObjectFormat.elf;
pub const mode = Mode.Debug;
pub const link_libc = false;
pub const link_libcpp = false;
pub const have_error_return_tracing = true;
pub const valgrind_support = true;
pub const position_independent_code = false;
pub const strip_debug_info = false;
pub const code_model = CodeModel.default;
