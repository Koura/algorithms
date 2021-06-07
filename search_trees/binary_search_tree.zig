const std = @import("std");
const expect = std.testing.expect;

fn Node(comptime T: type) type {
    return struct {
        value: T,
        parent: ?*Node(T) = null,
        left: ?*Node(T) = null,
        right: ?*Node(T) = null,
    };
}

/// Sources: Introduction to algorithms / Thomas H. Cormen...[et al.]. -3rd ed.
fn Tree(comptime T: type) type {
    return struct {
        root: ?*Node(T) = null,

        //Exercise: why does the worst case performance of binary search trees
        //`O(n)` differ from binary search on sorted arrays `O(log n)`?
        pub fn search(node: ?*Node(T), value: T) ?*Node(T) {
            if (node == null or node.?.value == value) {
                return node;
            }
            if (value < node.?.value) {
                return search(node.?.left, value);
            } else {
                return search(node.?.right, value);
            }
        }

        //Based on the insertions can you see how this data structure relates
        //to sorting? Hint: try outputting the resulting tree
        pub fn insert(self: *Tree(T), z: *Node(T)) void {
            var y: ?*Node(T) = null;
            var x = self.root;
            while (x) |node| {
                y = node;
                if (z.value < node.value) {
                    x = node.left;
                } else {
                    x = node.right;
                }
            }
            z.parent = y;
            if (y == null) {
                self.root = z;
            } else if (z.value < y.?.value) {
                y.?.left = z;
            } else {
                y.?.right = z;
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

test "search an existing element" {
    var tree = Tree(i32){};
    var node = Node(i32){ .value = 3 };
    tree.insert(&node);
    var result = Tree(i32).search(tree.root, 3);
    try expect(result.? == &node);
}

test "search non-existent element" {
    var tree = Tree(i32){};
    var node = Node(i32){ .value = 3 };
    tree.insert(&node);
    var result = Tree(i32).search(tree.root, 4);
    try expect(result == null);
}

test "search for an element with multiple nodes" {
    var tree = Tree(i32){};
    const values = [_]i32{ 15, 18, 17, 6, 7, 20, 3, 13, 2, 4, 9 };
    for (values) |v| {
        var node = Node(i32){ .value = v };
        tree.insert(&node);
    }
    var result = Tree(i32).search(tree.root, 9);
    try expect(result.?.value == 9);
}
