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
            var temp = std.Random.Isaac64.init(thisSeed);
            prng = temp.random();
        },
        1 => {
            var temp = std.Random.Pcg.init(thisSeed);
            prng = temp.random();
        },
        2 => {
            var temp = std.Random.RomuTrio.init(thisSeed);
            prng = temp.random();
        },
        3 => {
            var temp = std.Random.Sfc64.init(thisSeed);
            prng = temp.random();
        },
        4 => {
            var temp = std.Random.Xoroshiro128.init(thisSeed);
            prng = temp.random();
        },
        5 => {
            var temp = std.Random.Xoshiro256.init(thisSeed);
            prng = temp.random();
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
