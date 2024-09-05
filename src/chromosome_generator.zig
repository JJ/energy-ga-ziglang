const std = @import("std");
const generate = @import("generate.zig").generate;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const prng = std.crypto.random;

    var argsIterator = try std.process.argsWithAllocator(allocator);
    defer argsIterator.deinit();

    _ = argsIterator.next(); // First argument is the program name

    const stringLenArg = argsIterator.next() orelse "512";
    const stringLength = try std.fmt.parseInt(u16, stringLenArg, 10);

    const numStrings = 40000;

    const output = try generate(allocator, prng, stringLength, numStrings);
    defer {
        for (output) |str| allocator.free(str);
        allocator.free(output);
    }
    const stdout = std.io.getStdOut().writer();
    try stdout.print("{} \n", .{output.len});
}
