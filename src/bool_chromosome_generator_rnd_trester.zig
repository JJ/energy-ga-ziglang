const std = @import("std");
const boolGenerate = @import("bool_generate.zig").boolGenerate;
const createSeed = @import("utils.zig").createSeed;
const ourRng = @import("utils.zig").ourRng;

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var argsIterator = try std.process.argsWithAllocator(allocator);
    defer argsIterator.deinit();

    _ = argsIterator.next(); // First argument is the program name

    const rngArgStr = argsIterator.next() orelse "0";
    const rngArg = try std.fmt.parseInt(u16, rngArgStr, 10);

    var prng: std.Random = undefined;
    const thisSeed: u64 = try createSeed();
    switch (rngArg) {
        0 => {
            prng = std.Random.Isaac64.init(thisSeed).random();
        },
        1 => {
            prng = std.Random.Pcg.init(thisSeed).random();
        },
        else => {
            std.debug.print("Invalid argument: {}\n", .{rngArg});
            return;
        },
    }

    const numStrings = 65535;
    const stringLength = 1024;

    const output = try boolGenerate(allocator, prng, stringLength, numStrings);
    std.debug.print("Generated {} strings of length {}\n", .{ numStrings, stringLength });
    defer {
        for (output) |str| allocator.free(str);
        allocator.free(output);
    }
    const stdout = std.io.getStdOut().writer();
    try stdout.print("{} \n", .{output.len});
}
