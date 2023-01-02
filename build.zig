const std = @import("std");
const mach = @import("libs/mach/build.zig");

pub fn build(b: *std.build.Builder) !void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const app = try mach.App.init(b, .{
        .name = "space_caravan2",
        .src = "core/main.zig",
        .target = target,
        .deps = &[_]std.build.Pkg{},
        .mode = mode,
    });
    try app.link(.{});
    app.install();

    const run_cmd = try app.run();
    run_cmd.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(run_cmd);
}