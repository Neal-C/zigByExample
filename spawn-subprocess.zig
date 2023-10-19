const std = @import("std");

// zig test spaw-subprocess.zig
test "Interview me 🥱" {
    const args = [_][]const u8{ "ls", "-al" };

    var subprocess = std.process.Child.init(&args, std.testing.allocator);

    std.debug.print("Running commands {s} \n", .{&args});

    try subprocess.spawn();

    const returnedValue = try subprocess.wait();
    std.debug.print("{s}\n", .{returnedValue});
    try std.testing.expectEqual(returnedValue, .{
        .Exited = 0,
    });
}
