const std = @import("std");
const builtin = std.builtin;
const expect = std.testing.expect;
const mem = std.mem;
const maxInt = std.math.maxInt;

//For now only contains heap functionality relevant to sorting

fn left(i: usize) usize {
    return 2 * i + 1;
}

fn right(i: usize) usize {
    return 2 * i + 2;
}

pub fn max_heapify(A: []i32, i: usize, heap_size: usize) void {
    var l = left(i);
    var r = right(i);

    var largest = if (l < heap_size and A[l] > A[i]) l else i;
    if (r < heap_size and A[r] > A[largest]) {
        largest = r;
    }
    if (largest != i) {
        mem.swap(i32, &A[i], &A[largest]);
        max_heapify(A, largest, heap_size);
    }
}

pub fn build_max_heap(A: []i32) void {
    const heap_size = A.len;
    var i = (A.len / 2) - 1;
    while (i != maxInt(usize) and i >= 0) {
        max_heapify(A, i, heap_size);
        i = i -% 1;
    }
}

test "building a heap" {
    var array: [10]i32 = .{ 4, 1, 3, 2, 16, 9, 10, 14, 8, 7 };
    var expected_result: [10]i32 = .{ 16, 14, 10, 8, 7, 9, 3, 2, 4, 1 };
    build_max_heap(&array);
    for (array) |value, i| {
        try expect(expected_result[i] == value);
    }
}
