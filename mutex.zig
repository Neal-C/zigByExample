const std = @import("std");

const ThreadSafeCounter = struct {
    lock: std.Thread.Mutex,
    count: usize,

    pub fn increase(self: *ThreadSafeCounter, n: u32) void {
        var i: i32 = 0;
        while (i < n) : (i += 1) {
            self.lock.lock();
            defer self.lock.unlock();
            self.count += 1;
        }
    }
};

// zig test mutex.zig
test "Quick question to the reader: Have you, in your whole career, ever used a semaphore ? (Answer me via my mail)" {
    var threads: [3]std.Thread = undefined;
    var threadSafeCounter = ThreadSafeCounter{
        .lock = .{}, // ???
        .count = 0,
    };

    for (&threads) |*thrd| {
        thrd.* = try std.Thread.spawn(.{}, ThreadSafeCounter.increase, .{ &threadSafeCounter, 1000 }); // comptime fn and its arguments (including positional argument)
    }

    for (threads) |thrd| {
        thrd.join();
    }

    try std.testing.expectEqual(threadSafeCounter.count, 3000);
}
