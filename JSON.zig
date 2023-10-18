const std = @import("std");

const myJSON =
    \\{
    \\    "vals": {
    \\        "testing": 1,
    \\        "production": 42
    \\    },
    \\    "uptime": 9999
    \\}
    \\
; // neat json representation but quite a strech

const myConfig = struct {
    vals: struct {
        testing: u8,
        production: u8,
    },
    uptime: u64,
};

// zig test JSON.zig
test "Let's have a talk, interview me 😀" {
    const config = try std.json.parseFromSlice(myConfig, std.testing.allocator, myJSON, .{});
    defer config.deinit();

    try std.testing.expect(config.value.vals.testing == 1);
    try std.testing.expect(config.value.vals.production == 42);
    try std.testing.expect(config.value.uptime == 9999);
}
