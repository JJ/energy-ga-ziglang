const std = @import("std");
const expect = std.testing.expect;

// Random number generator used all over
pub fn ourRng() !std.Random.DefaultPrng {
    return std.Random.DefaultPrng.init(try createSeed());
}

pub fn createSeed() !u64 {
    var seed: u64 = undefined;
    try std.posix.getrandom(std.mem.asBytes(&seed));
    return seed;
}

test "Random seed" {
    const seed = try createSeed();
    try expect(seed != 0);
    const anotherSeed = try createSeed();
    try expect(seed != anotherSeed);
}

test "random generators" {
    var first_rng = try ourRng();
    for (1..10) |_| {
        var second_rng = try ourRng();
        try expect(first_rng.random().int(i32) != second_rng.random().int(i32));
        first_rng = second_rng;
    }
}
