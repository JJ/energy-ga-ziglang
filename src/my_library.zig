const std = @import("std");
pub const generate = @import("string_generate.zig").generate;
pub const boolGenerate = @import("bool_generate.zig").boolGenerate;
pub const crossover = @import("string_crossover.zig").crossover;
pub const mutation = @import("string_mutation.zig").mutation;
pub const countOnes = @import("count_ones.zig").countOnes;
pub const HIFF = @import("HIFF.zig").HIFF;

test "all" {
    std.testing.refAllDecls(@This());
}
