const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe_mod = b.createModule(.{
        .target = target,
        .optimize = optimize,

        .link_libc = true,
    });

    exe_mod.addCSourceFiles(.{
        .files = &.{
            "src/main.c",
        },
        .flags = &.{
            "-std=c11",
            "-Wall",
            "-Wextra",
        },
    });

    exe_mod.addLibraryPath(.{ .cwd_relative = "/usr/local/lib" });
    exe_mod.addIncludePath(.{ .cwd_relative = "/usr/local/include" });
    exe_mod.linkSystemLibrary("mujoco", .{});

    const exe = b.addExecutable(.{
        .name = "hello_mujoco",
        .root_module = exe_mod,
    });


    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
