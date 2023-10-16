const std = @import("std");

// zig test readWritefile.zig
test "if you're reading this, send me a technical test 😀"{

	const value = "hello, I know about Clean Architecture and TDD";

	var myFile = try std.fs.cwd().createFile("interviewMe.txt", .{ .read = true});
	defer myFile.close();

	_ = try myFile.write(value);

	var buffer : [value.len]u8 = undefined;
	
	try myFile.seekTo(0);
	
	const numberOfbytesRead = try myFile.read(&buffer);

	try std.testing.expectEqualStrings(value, buffer[0..numberOfbytesRead]);
}