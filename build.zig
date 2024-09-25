const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const tests = b.addTest(.{
        .root_source_file = b.path("src/my_library.zig"),
        .target = target,
        .optimize = optimize,
    });

    const test_step = b.step("test", "Run library tests");
    const run_tests = b.addRunArtifact(tests);
    test_step.dependOn(&run_tests.step);

    const generators = [2][]const u8{ "string_chromosome_generator", "bool_chromosome_generator" };
    inline for (generators) |generator| {
        const exe = b.addExecutable(.{
            .name = generator,
            .root_source_file = b.path("src/" ++ generator ++ ".zig"),
            .target = target,
            .optimize = .ReleaseFast,
            .single_threaded = true,
        });

        b.installArtifact(exe);
    }

    const boolOps = b.addExecutable(.{
        .name = "bool_combined_ops",
        .root_source_file = b.path("src/bool_combined_ops.zig"),
        .target = target,
        .optimize = .ReleaseFast,
        .single_threaded = true,
    });
    boolOps.stack_size = 80000 * 4096;
    b.installArtifact(boolOps);

    const combined_ops = b.addExecutable(.{
        .name = "string_combined_ops",
        .root_source_file = b.path("src/string_combined_ops.zig"),
        .target = target,
        .optimize = .ReleaseFast,
        .single_threaded = true,
    });

    b.installArtifact(combined_ops);

    const hiff = b.addExecutable(.{
        .name = "run_hiff",
        .root_source_file = b.path("src/run_hiff.zig"),
        .target = target,
        .optimize = .ReleaseFast,
        .single_threaded = true,
    });

    b.installArtifact(hiff);

    const randomGenerators = b.addExecutable(.{
        .name = "rnd_tester",
        .root_source_file = b.path("src/bool_chromosome_generator_rnd_tester.zig"),
        .target = target,
        .optimize = .ReleaseFast,
        .single_threaded = true,
    });

    b.installArtifact(randomGenerators);
}
