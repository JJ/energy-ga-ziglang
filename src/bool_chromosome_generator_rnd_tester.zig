const std = @import("std");
const boolGenerate = @import("bool_generate.zig").boolGenerate;
const createSeed = @import("utils.zig").createSeed;
const ourRng = @import("utils.zig").ourRng;

const RandomGenerator = union(enum) {
    isaac64: std.Random.Isaac64,
    pcg: std.Random.Pcg,
    romuTrio: std.Random.RomuTrio,
    sfc64: std.Random.Sfc64,
    xoroshiro128: std.Random.Xoroshiro128,
    xoshiro256: std.Random.Xoshiro256,

    pub fn get(self: *RandomGenerator) std.Random {
        return switch (self.*) {
            inline else => |*r| return r.random(),
        };
    }
};

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var argsIterator = try std.process.argsWithAllocator(allocator);
    defer argsIterator.deinit();

    _ = argsIterator.next(); // First argument is the program name

    const rngArgStr = argsIterator.next() orelse "0";
    const rngArg = try std.fmt.parseInt(u16, rngArgStr, 10);

    const thisSeed: u64 = try createSeed();
    var prng: RandomGenerator = switch (rngArg) {
        0 => .{ .isaac64 = std.Random.Isaac64.init(thisSeed) },
        1 => .{ .pcg = std.Random.Pcg.init(thisSeed) },
        2 => .{ .romuTrio = std.Random.RomuTrio.init(thisSeed) },
        3 => .{ .sfc64 = std.Random.Sfc64.init(thisSeed) },
        4 => .{ .xoroshiro128 = std.Random.Xoroshiro128.init(thisSeed) },
        5 => .{ .xoshiro256 = std.Random.Xoshiro256.init(thisSeed) },
        else => {
            std.debug.print("Invalid argument: {}\n", .{rngArg});
            return;
        },
    };

    const random = prng.get();
    const numStrings = 65535;
    const stringLength = 2048;

    const output = try boolGenerate(allocator, random, stringLength, numStrings);
    std.debug.print("Generated {} strings of length {}\n", .{ numStrings, stringLength });
    defer {
        for (output) |str| allocator.free(str);
        allocator.free(output);
    }
    const stdout = std.io.getStdOut().writer();
    try stdout.print("{} \n", .{output.len});
}
