const std = @import("std");
const expect = std.testing.expect;
const mem = std.mem;
const math = std.math;

pub fn max(A: []i32) i32 {
    var max_val: comptime i32 = 0;
    for (A) |value, index| {
        if (value > max_val) {
            max_val = A[index];
        }
    }
    return max_val;
}

//Stable sort that expects C to only contain values `x` such that `0 <= x < radix`
pub fn counting_sort(A: []i32, B: []i32, C: []usize, exp: i32, radix: usize) void {
    //Reset all elements of array C to 0
    mem.set(usize, C, 0);

    for (A) |_, index| {
        const digit_of_Ai = @rem(@intCast(usize, @divFloor(A[index], exp)), radix);
        C[digit_of_Ai] = C[digit_of_Ai] + 1;
    }

    var j: usize = 1;
    while (j < radix) : (j = j + 1) {
        C[j] = C[j] + C[j - 1];
    }

    var m = A.len - 1;
    while (m != math.maxInt(usize) and m >= 0) : (m = m -% 1) {
        const digit_of_Ai = @rem(@intCast(usize, @divFloor(A[m], exp)), radix);
        C[digit_of_Ai] = C[digit_of_Ai] - 1;
        //Output stored in B
        B[C[digit_of_Ai]] = A[m];
    }
}

///References: https://brilliant.org/wiki/radix-sort/
///         https://en.wikipedia.org/wiki/Radix_sort
///LSD radix sort
pub fn sort(A: []i32, B: []i32, radix: usize) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        _ = gpa.deinit();
    }
    const C = try gpa.allocator.alloc(usize, radix);
    defer gpa.allocator.free(C);

    var k = max(A);

    var exp: i32 = 1;
    //Utilize counting sort to order A digit wise starting from the least significant digit
    while (@divFloor(k, exp) > 0) : (exp *= 10) {
        counting_sort(A, B, C, exp, radix);
        //Copy output of B to A
        for (B) |value, index| {
            A[index] = value;
        }
    }
}

pub fn main() !void {}

test "empty array" {
    var array: []i32 = &.{};
    var work_array: []i32 = &.{};
    try sort(array, work_array, 10);
    const a = array.len;
    try expect(a == 0);
}

test "array with one element" {
    var array: [1]i32 = .{5};
    var work_array: [1]i32 = .{0};
    try sort(&array, &work_array, 10);
    const a = array.len;
    try expect(a == 1);
    try expect(array[0] == 5);
}

test "sorted array" {
    var array: [10]i32 = .{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
    var work_array: [10]i32 = .{0} ** 10;
    try sort(&array, &work_array, 10);
    for (array) |value, i| {
        try expect(value == (i + 1));
    }
}

test "reverse order" {
    var array: [10]i32 = .{ 10, 9, 8, 7, 6, 5, 4, 3, 2, 1 };
    var work_array: [10]i32 = .{0} ** 10;
    try sort(&array, &work_array, 10);
    for (array) |value, i| {
        try expect(value == (i + 1));
    }
}

test "unsorted array" {
    var array: [5]i32 = .{ 5, 3, 4, 1, 2 };
    var work_array: [5]i32 = .{0} ** 5;
    try sort(&array, &work_array, 10);
    for (array) |value, i| {
        try expect(value == (i + 1));
    }
}

test "two last unordered" {
    var array: [10]i32 = .{ 1, 2, 3, 4, 5, 6, 7, 8, 10, 9 };
    var work_array: [10]i32 = .{0} ** 10;
    try sort(&array, &work_array, 10);
    for (array) |value, i| {
        try expect(value == (i + 1));
    }
}

test "two first unordered" {
    var array: [10]i32 = .{ 2, 1, 3, 4, 5, 6, 7, 8, 9, 10 };
    var work_array: [10]i32 = .{0} ** 10;
    try sort(&array, &work_array, 10);
    for (array) |value, i| {
        try expect(value == (i + 1));
    }
}
