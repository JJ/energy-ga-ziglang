const std = @import("std");
const expect = std.testing.expect;

// Random number generator used all over
pub fn ourRng() !std.Random.DefaultPrng {
    return std.Random.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
}

// function that generates a string array
pub fn randomBoolean(random: std.Random) bool {
    return random.boolean();
}

// test the generator
test "random generators" {
    var first_rng = try ourRng();
    for (1..10) |_| {
        var second_rng = try ourRng();
        try expect(first_rng.random().int(i32) != second_rng.random().int(i32));
        first_rng = second_rng;
    }
}

test "boolean generator" {
    var first_rng = try ourRng();
    const rndGen = first_rng.random();
    const bool1 = randomBoolean(rndGen);
    const bool2 = randomBoolean(rndGen);
    try expect(bool1 != bool2);
}
