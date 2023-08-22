const std = @import("std");
const expect = std.testing.expect;
const Allocator = std.mem.Allocator;

const Node = struct {
    //What changes would the children field need in order to implement sorting?
    children: std.AutoHashMap(u8, *Node),
    value: bool = false,

    pub fn init(allocator: *const Allocator) !*Node {
        var node = try allocator.create(Node);
        node.children = std.AutoHashMap(u8, *Node).init(allocator.*);
        node.value = false;
        return node;
    }
};

///References: https://en.wikipedia.org/wiki/Trie
const Tree = struct {
    root: *Node,

    pub fn init(allocator: *const Allocator) !Tree {
        var node = try Node.init(allocator);
        return Tree{ .root = node };
    }

    pub fn insert(self: *Tree, key: []const u8, allocator: *const Allocator) !void {
        var node = self.root;
        for (key) |char| {
            if (!node.children.contains(char)) {
                var new_node = try Node.init(allocator);
                try node.children.put(char, new_node);
            }
            node = node.children.get(char).?;
        }
        node.value = true;
    }

    //Returns true if the word is present in the trie
    pub fn search(self: *Tree, key: []const u8) bool {
        var node = self.root;
        for (key) |char| {
            if (node.children.contains(char)) {
                node = node.children.get(char).?;
            } else {
                return false;
            }
        }
        return node.value;
    }
};

pub fn main() !void {}

test "search empty tree" {
    var arena_allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_allocator.deinit();
    const allocator = &arena_allocator.allocator();
    var tree = try Tree.init(allocator);
    var result = tree.search("car");
    try expect(result == false);
}

test "search existing element" {
    var arena_allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_allocator.deinit();
    const allocator = &arena_allocator.allocator();
    var tree = try Tree.init(allocator);
    try tree.insert("car", allocator);
    var result = tree.search("car");
    try expect(result == true);
}

test "search non-existing element" {
    var arena_allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_allocator.deinit();
    const allocator = &arena_allocator.allocator();
    var tree = try Tree.init(allocator);
    try tree.insert("car", allocator);
    var result = tree.search("There is no trie");
    try expect(result == false);
    //Make sure that partial matches are not marked as present
    result = tree.search("ca");
    try expect(result == false);
}

test "search with multiple words present" {
    var arena_allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_allocator.deinit();
    const allocator = &arena_allocator.allocator();
    var tree = try Tree.init(allocator);
    var words = [_][]const u8{
        "A", "to", "tea", "ted", "ten", "i", "in", "inn",
    };
    for (words) |word| {
        try tree.insert(word, allocator);
    }
    for (words) |word| {
        var result = tree.search(word);
        try expect(result == true);
    }
    //Root should have 'A', 't' and 'i' as its children
    try expect(tree.root.children.count() == 3);
}
