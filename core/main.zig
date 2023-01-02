const mach = @import("mach");
const std = @import("std");
const gpu = @import("gpu");

queue: *gpu.Queue,

pub const App = @This();

pub fn init(app: *App, core: *mach.Core) !void {
    std.debug.print("App started\n", .{});
    app.queue = core.device.getQueue();
}

pub fn deinit(_: *App, _: *mach.Core) void {
    std.debug.print("App closed\n", .{});
}

pub fn update(app: *App, core: *mach.Core) !void {
    const back_buffer_view = core.swap_chain.?.getCurrentTextureView();
    const encoder = core.device.createCommandEncoder(null);

    const color_attachment = gpu.RenderPassColorAttachment{
        .view = back_buffer_view,
        .clear_value = std.mem.zeroes(gpu.Color),
        .load_op = .clear,
        .store_op = .store,
    };

    const render_pass_descriptor = gpu.RenderPassDescriptor.init(.{
        .color_attachments = &.{color_attachment},
    });

    const render_pass = encoder.beginRenderPass(&render_pass_descriptor);
    render_pass.end();

    var command = encoder.finish(null);
    encoder.release();
    app.queue.submit(&[_]*gpu.CommandBuffer{command});
    command.release();
    core.swap_chain.?.present();
    back_buffer_view.release();
}
