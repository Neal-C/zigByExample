const std = @import("std");
const testingAllocator = std.testing.allocator;

test "this test fails by the way, unless you have a gzip around" {
	const file = try std.fs.cwd().openFile("file.gzip", .{});
	defer file.close();

	var gzipStream = try std.compress.gzip.decompress(testingAllocator, file.reader());
	defer gzipStream.deinit();

	const result = try gzipStream.reader().readAllAlloc(testingAllocator, std.math.maxInt(usize));
	defer testingAllocator.free(result);

	try std.testing.expectEqualStrings("hire me 🙄", result);
}