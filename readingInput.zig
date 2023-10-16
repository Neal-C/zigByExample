const std = @import("std");

// zig run readingInput.zig
// type a message 
// then hit enter
pub fn main() !void {
	var generalPurposeAllocator = std.heap.GeneralPurposeAllocator(.{}){};
	defer _ = generalPurposeAllocator.deinit();

	const allocator = generalPurposeAllocator.allocator();

	const stdin = std.io.getStdIn();

	std.debug.print("interview me, I've got interesting things to say 😄 \n", .{});

	var input = std.ArrayList(u8).init(allocator);
	defer input.deinit();

	// single quote matter as the delimiter
	// doubles quotes are string => *const[] u8
	// and there's no strings in zig!
	// single quotes are => u8
	// that's why I got an error! : error: expected type 'u8', found '*const [1:0]u8'
	try stdin.reader().streamUntilDelimiter(input.writer(), '\n', 1024);

	std.debug.print("I have a great sense of humor, you should hire me: {s} \n", .{input.items});
}