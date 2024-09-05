const std = @import("std");
const generate = @import("generate.zig").generate;

const HIFF = @import("HIFF.zig").HIFF;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const prng = std.crypto.random;

    var argsIterator = try std.process.argsWithAllocator(allocator);
    defer argsIterator.deinit();

    _ = argsIterator.next(); // First argument is the program name

    const stringLenArg = argsIterator.next() orelse "512";
    std.debug.print("String length argument: {s}\n", .{stringLenArg});
    const stringLength = try std.fmt.parseInt(u16, stringLenArg, 10);
    std.debug.print("String length: {}\n", .{stringLength});

    const numStrings = 40000;

    const chromosomes = try generate(allocator, prng, stringLength, numStrings);
    std.debug.print("Generated {} chromosomes\n", .{chromosomes.len});
    var fitness = std.ArrayList(usize).init(allocator);

    for (chromosomes) |chromosome| {
        const thisChromosome: []const u8 = chromosome;

        try fitness.append(HIFF(thisChromosome));
    }
    std.debug.print("Results: {}\n", .{fitness.items.len});
}
