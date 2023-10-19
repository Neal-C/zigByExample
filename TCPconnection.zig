const std = @import("std");

const clientMessage = "hello";
const serverMessage = "goodbye";

const Server = struct {
    const Self = @This();
    streamServer: std.net.StreamServer,

    pub fn init() !Self {
        const address = std.net.Address.initIp4([4]u8{ 127, 0, 0, 1 }, 8080);
        var server = std.net.StreamServer.init(.{
            .reuse_address = true,
        });

        try server.listen(address);
        return Self{
            .streamServer = server,
        };
    }

    pub fn deinit(self: *Self) void {
        self.streamServer.deinit();
    }

    pub fn accept(self: *Self) !void {
        const connection = try self.streamServer.accept();
        defer connection.stream.close();

        var buffer: [1024]u8 = undefined;
        const messageSize = try connection.stream.read(buffer[0..]);

        try std.testing.expectEqualStrings(clientMessage, buffer[0..messageSize]);

        _ = try connection.stream.write(serverMessage);
    }
};

fn sendMessageToServer(serverAddress: std.net.Address) !void {
    const connection = try std.net.tcpConnectToAddress(serverAddress);
    defer connection.close(); // free memory on scope exit

    _ = try connection.write(clientMessage);

    var buffer: [1024]u8 = undefined;
    const responseSize = try connection.read(buffer[0..]);

    try std.testing.expectEqualStrings(serverMessage, buffer[0..responseSize]);
}

test "Send me a technical test" {
    var server = try Server.init();
    defer server.deinit();

    const clientThread = try std.Thread.spawn(.{}, sendMessageToServer, .{server.streamServer.listen_address});
    defer clientThread.join();

    try server.accept();
}
