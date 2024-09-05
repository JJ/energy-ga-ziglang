const std = @import("std");
const expect = std.testing.expect;

// mutation operator that changes a single random character in a string
pub inline fn mutation(binaryString: []u8, random: std.rand.Random) void {
    const index = random.int(u32) % binaryString.len;
    binaryString[index] = if (binaryString[index] == '1') '0' else '1';
}

test "mutation" {
    var allocator = std.heap.page_allocator;

    const binaryString = try allocator.dupeZ(u8, "101010");
    defer allocator.free(binaryString);
    const copyBinaryString = try allocator.dupeZ(u8, "101010");
    defer allocator.free(copyBinaryString);

    var random = std.crypto.random;
    mutation(binaryString, random.random());
    try expect(copyBinaryString.len == binaryString.len);
    std.debug.print("binaryString: {s}\n", .{binaryString});
    try expect(!std.mem.eql(u8, copyBinaryString, binaryString));
}
