const std = @import("std");

const Blake3 = std.crypto.hash.Blake3;

// zig test hashing.zig
test "hashing is not encoding! and is not encrypting! Please learn the difference or better yet, hire me, someone who does know the diff 🙂 \n" {
    const input: []const u8 = "hello";
    var output: [Blake3.digest_length]u8 = undefined;

    Blake3.hash(input, &output, .{});

    std.debug.print("{s} \n", .{std.fmt.fmtSliceHexLower(&output)});
}
