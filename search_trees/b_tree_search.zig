const std = @import("std");
const expect = std.testing.expect;
const Allocator = std.mem.Allocator;
const Error = Allocator.Error;

//Experiment with different degrees.
//Exercise: why can't `t = 1`?
const t = 2;

pub fn Node(comptime T: type) type {
    return struct { n: usize, leaf: bool, key: [2 * t]T, c: [2 * t]?*Node(T) };
}

pub fn SearchTuple(comptime T: type) type {
    return struct {
        node: *Node(T),
        index: usize,
    };
}

/// References: Introduction to algorithms / Thomas H. Cormen...[et al.]. -3rd ed.
/// To make things simpler diskWrite and diskRead are not implemented here but
/// the code contains comments when these would be performed.
pub fn Tree(comptime T: type) type {
    return struct {
        root: ?*Node(T) = null,

        pub fn create(self: *Tree(T), allocator: *Allocator) !void {
            var x = try allocator.create(Node(T));
            //Here we would write to disk -> diskWrite(x)
            x.n = 0;
            x.leaf = true;
            for (x.c) |_, i| {
                x.c[i] = null;
                x.key[i] = 0;
            }
            self.root = x;
        }

        pub fn insert(self: *Tree(T), k: T, allocator: *Allocator) !void {
            var r = self.root;
            if (r == null) {
                return;
            }
            if (r.?.n == 2 * t - 1) {
                var s = try allocator.create(Node(T));
                self.root = s;
                s.leaf = false;
                s.n = 0;
                for (s.c) |_, i| {
                    s.c[i] = null;
                    s.key[i] = 0;
                }
                s.c[0] = r;
                try Tree(T).splitChild(s, 1, allocator);
                try Tree(T).insertNonfull(s, k, allocator);
            } else {
                try Tree(T).insertNonfull(r.?, k, allocator);
            }
        }

        fn splitChild(x: *Node(T), i: usize, allocator: *Allocator) Error!void {
            var z = try allocator.create(Node(T));
            for (z.c) |_, index| {
                z.c[index] = null;
                z.key[index] = 0;
            }
            var y = x.c[i - 1].?;
            z.leaf = y.leaf;
            z.n = t - 1;
            var j: usize = 1;
            while (j <= t - 1) : (j += 1) {
                z.key[j - 1] = y.key[j - 1 + t];
            }
            if (!y.leaf) {
                j = 1;
                while (j <= t) : (j += 1) {
                    z.c[j - 1] = y.c[j - 1 + t];
                }
            }
            y.n = t - 1;
            j = x.n + 1;
            while (j >= i + 1) : (j -= 1) {
                x.c[j] = x.c[j - 1];
            }
            x.c[i] = z;
            j = x.n;
            while (j >= i) : (j -= 1) {
                x.key[j] = x.key[j - 1];
            }
            x.key[i - 1] = y.key[t - 1];
            x.n = x.n + 1;
            //diskWrite(y)
            //diskWrite(z)
            //diskWrite(x)
        }

        fn insertNonfull(x: *Node(T), k: T, allocator: *Allocator) Error!void {
            var i = x.n;
            if (x.leaf) {
                while (i >= 1 and k < x.key[i - 1]) : (i -= 1) {
                    x.key[i] = x.key[i - 1];
                }
                x.key[i] = k;
                x.n = x.n + 1;
                //Here we would write to disk -> diskWrite(x)
            } else {
                while (i >= 1 and k < x.key[i - 1]) : (i -= 1) {}
                i = i + 1;
                //Here we would read from disk -> diskRead(x.c[i-1])
                if (x.c[i - 1].?.n == 2 * t - 1) {
                    try splitChild(x, i, allocator);
                    if (k > x.key[i - 1]) {
                        i = i + 1;
                    }
                }
                try insertNonfull(x.c[i - 1].?, k, allocator);
            }
        }

        pub fn search(node: ?*Node(T), k: T) ?SearchTuple(T) {
            if (node) |x| {
                var i: usize = 1;
                while (i <= x.n and k > x.key[i - 1]) : (i += 1) {}
                if (i <= x.n and k == x.key[i - 1]) {
                    return SearchTuple(T){ .node = x, .index = i - 1 };
                } else if (x.leaf) {
                    return null;
                } else {
                    //Here we would read from disk -> diskRead(x.c[i-1])
                    return Tree(T).search(x.c[i - 1], k);
                }
            } else {
                return null;
            }
        }
    };
}

pub fn main() !void {}

test "search empty tree" {
    var tree = Tree(i32){};
    var result = Tree(i32).search(tree.root, 3);
    try expect(result == null);
}

test "verify tree creation" {
    var tree = Tree(i32){};
    var arena_allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_allocator.deinit();
    const allocator = &arena_allocator.allocator;
    try tree.create(allocator);
    try expect(tree.root.?.n == 0);
    try expect(tree.root.?.leaf);
}

test "search non-existent element" {
    var tree = Tree(i32){};
    var arena_allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_allocator.deinit();
    const allocator = &arena_allocator.allocator;
    try tree.create(allocator);
    try tree.insert(3, allocator);
    var result = Tree(i32).search(tree.root, 4);
    try expect(result == null);
}

test "search an existing element" {
    var tree = Tree(i32){};
    var arena_allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_allocator.deinit();
    const allocator = &arena_allocator.allocator;
    try tree.create(allocator);
    try tree.insert(3, allocator);
    var result = Tree(i32).search(tree.root, 3);
    const index = result.?.index;
    const node = result.?.node;
    try expect(index == 0);
    try expect(node.key[index] == 3);
}

test "search with u8 as key" {
    var tree = Tree(u8){};
    var arena_allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_allocator.deinit();
    const allocator = &arena_allocator.allocator;
    try tree.create(allocator);
    try tree.insert('F', allocator);
    try tree.insert('S', allocator);
    try tree.insert('Q', allocator);
    try tree.insert('K', allocator);
    var result = Tree(u8).search(tree.root, 'F');
    const index = result.?.index;
    const node = result.?.node;
    try expect(index == 0);
    try expect(node.key[index] == 'F');
}

test "search for an element with multiple nodes" {
    var tree = Tree(i32){};
    var arena_allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_allocator.deinit();
    const allocator = &arena_allocator.allocator;
    try tree.create(allocator);
    const values = [_]i32{ 15, 18, 17, 6, 7, 20, 3, 13, 2, 4, 9 };
    for (values) |v| {
        try tree.insert(v, allocator);
    }
    var result = Tree(i32).search(tree.root, 9);
    const index = result.?.index;
    const node = result.?.node;
    try expect(result != null);
    try expect(index == 0);
    try expect(node.key[index] == 9);
}
