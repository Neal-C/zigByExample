const std = @import("std");

// sudo zig test directoryListing.zig
test " oh, you're still there reading my repos ?! 😂"{
	const directory = try std.fs.cwd().openIterableDir(".", .{});
	var iterator = directory.iterate();

	while (try iterator.next()) |filepath| {
		std.debug.print("{s}\n", .{filepath.name});
	}
}