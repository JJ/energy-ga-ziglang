const std = @import("std");
const expect = std.testing.expect;

// mutation operator that changes a single random character in a string
pub inline fn boolMutation(boolString: []bool, random: std.rand.Random) void {
    const index = random.int(usize) % boolString.len;
    boolString[index] = if (boolString[index] == true) false else true;
}

test "mutation" {
    var boolString = [_]bool{ true, false, true, false, true, false };
    var copyBoolString = [_]bool{ true, false, true, false, true, false };

    var random = std.crypto.random;
    boolMutation(&boolString, random);
    try expect(copyBoolString.len == boolString.len);
    std.debug.print("boolString: {any}\n", .{boolString});
    try expect(!std.mem.eql(bool, &copyBoolString, &boolString));
}
