const std = @import("std");

// LIFO data structure
fn Stack(comptime T: type) type {
	const Node = struct {
		const Self = @This();
		value: T,
		next: ?*Self,
	};

	return struct {
		const Self = @This();

		head: ?*Node,
		allocator: std.mem.Allocator,

		fn new(memallocator: std.mem.Allocator) Self {
			return .{
				.allocator = memallocator,
				.head = null,
			};
		}

		fn push(self: *Self, value: T) !void {
			var node = try self.allocator.create(Node);
			node.value = value;

			var head = self.head;
			node.next = head; // next is current top
			self.head = node; // top becomes becomes the new node
		}

		fn pop(self: *Self) ?T {
			if(self.head) |head|{
				self.head = head.next; // below node becomes the head
				var value = head.value; // copy the value
				self.allocator.destroy(head); // pop the stack
				return value; // the return the value of what we just destroyed
			}

			return null;
		}

		fn print(self: *Self) void {
			var current = self.head;
			std.log.info("-- stack printing --", .{});
			while(current) |node| {
				std.log.info("-> {d}", .{node.value}); 
				current = node.next;
			}

		}
	};
}

const IntStack = Stack(i32);

pub fn main() !void {
	var arenaAllocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
	defer arenaAllocator.deinit(); // free memory on scope exit;

	var allocator = arenaAllocator.allocator();

	var stack = IntStack.new(allocator);

	try stack.push(42);
	stack.print();
	try stack.push(47);
	stack.print();
	try stack.push(50);
	stack.print();
	try stack.push(55);
	stack.print();

	var value = stack.pop();

	if (value) |val| {
		std.log.info("popped value is: {d}", .{val});
	}

	stack.print();
	std.log.info("If you're reading this, send me a technical test or: just straight up, hire me no questions asked 😄", .{} );
	std.log.info("the end, hope you enjoyed", .{});
}