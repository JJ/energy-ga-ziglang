const std = @import("std");
const generate = @import("bitset_generate.zig").generate;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const prng = std.crypto.random;

    var argsIterator = try std.process.argsWithAllocator(allocator);
    defer argsIterator.deinit();

    _ = argsIterator.next(); // First argument is the program name

    const stringLenArg = argsIterator.next() orelse "512";

    var bitsetType: type = undefined;
    switch (stringLenArg) {
        512 => bitsetType = std.bit_set.StaticBitSet(512),
        1024 => bitsetType = std.bit_set.StaticBitSet(1024),
        2048 => bitsetType = std.bit_set.StaticBitSet(2048),
        else => return std.debug.print("Invalid string length\n", .{}),
    }

    const numStrings = 40000;
    const output = try generate(allocator, prng, bitsetType, numStrings);

    defer allocator.free(output);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{} \n", .{output.len});
}
