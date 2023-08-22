const std = @import("std");
const builtin = std.builtin;
const expect = std.testing.expect;
const max_heap = @import("../data_structures/max_heap.zig");
const mem = std.mem;

/// References: Introduction to algorithms / Thomas H. Cormen...[et al.]. -3rd ed.
pub fn sort(A: []i32) void {
    if (A.len <= 1) {
        return;
    }
    max_heap.build_max_heap(A);
    var heap_size = A.len;
    var i = A.len - 1;
    while (i > 0) : (i -= 1) {
        //Use qualities of max heap to perform the sort. How would you implement a sort in reverse order?
        mem.swap(i32, &A[0], &A[i]);
        heap_size -= 1;
        max_heap.max_heapify(A, 0, heap_size);
    }
}

pub fn main() !void {}

test "empty array" {
    var array: []i32 = &.{};
    sort(array);
    const a = array.len;
    try expect(a == 0);
}

test "array with one element" {
    var array: [1]i32 = .{5};
    sort(&array);
    const a = array.len;
    try expect(a == 1);
    try expect(array[0] == 5);
}

test "sorted array" {
    var array: [10]i32 = .{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
    sort(&array);
    for (array, 0..) |value, i| {
        try expect(value == (i + 1));
    }
}

test "reverse order" {
    var array: [10]i32 = .{ 10, 9, 8, 7, 6, 5, 4, 3, 2, 1 };
    sort(&array);
    for (array, 0..) |value, i| {
        try expect(value == (i + 1));
    }
}

test "unsorted array" {
    var array: [5]i32 = .{ 5, 3, 4, 1, 2 };
    sort(&array);
    for (array, 0..) |value, i| {
        try expect(value == (i + 1));
    }
}

test "two last unordered" {
    var array: [10]i32 = .{ 1, 2, 3, 4, 5, 6, 7, 8, 10, 9 };
    sort(&array);
    for (array, 0..) |value, i| {
        try expect(value == (i + 1));
    }
}

test "two first unordered" {
    var array: [10]i32 = .{ 2, 1, 3, 4, 5, 6, 7, 8, 9, 10 };
    sort(&array);
    for (array, 0..) |value, i| {
        try expect(value == (i + 1));
    }
}
