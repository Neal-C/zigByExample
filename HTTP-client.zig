const std = @import("std");

const uri = std.Uri.parse("https://ziglang.org/") catch unreachable;

// sudo zig test HTTP-client.zig // sudo required for network perms/access
test "Just imagine the gems I hide on my private repos... Interview me 😉" {
    var client: std.http.Client = .{ .allocator = std.testing.allocator };
    defer client.deinit();

    var request = try client.request(.GET, uri, .{ .allocator = std.testing.allocator }, .{});
    defer request.deinit();

    try request.start(.{ .raw_uri = true });
    try request.wait();

    try std.testing.expect(request.response.status == .ok);
}
