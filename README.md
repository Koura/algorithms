<h2 align="center">Collection of Algorithms</h2>

<p align="center">Simple standalone implementations of algorithms in Zig</p>

## Table of Contents

- [About](#about)
- [Prerequisite](#prerequisite)
- [Running](#running)
- [Testing](#testing)
- [Algorithms](#algorithms)
  - [Search Trees](#search_trees)
  - [Sorting](#sorting)
- [Contributing](CONTRIBUTING.md)
- [License](LICENSE)

## About <a name = "about"></a>

The purpose of this project is to provide example implementations of algorithms with minimal dependencies for educational use. The algorithms implemented here are meant to be easy to run and try out to support reviewing, discovering and gaining a deeper understanding of the algorithms showcased in this repository. Optimizations are applied to implementations if they either make the implementation easier to understand or highlight the essence of the algorithm well.

A new algorithm will be added at least once every other week.

## Prerequisite <a name = "prerequisite"></a>

- [Zig](https://ziglang.org/download/)

## Running <a name = "running"></a>

```console
zig build bubble_sort
```

Use `zig build --help` to see other available algorithms.

## Testing <a name = "testing"></a>

Heap sort:

```console
zig test sorting/heap_sort.zig --main-pkg-path .
```

Everything else:

```console
zig test <path_to_algorithm>.zig
```

## :hammer: Algorithms <a name = "algorithms"></a>

### Search Trees <a name = "search_trees">

- [Binary search tree](search_trees/binary_search_tree.zig)

### Sorting <a name = "sorting"></a>

- [Bubble sort](sorting/bubble_sort.zig)
- [Heap sort](sorting/heap_sort.zig)
- [Insertion sort](sorting/insertion_sort.zig)
- [Merge sort](sorting/merge_sort.zig)
- [Quicksort](sorting/quicksort.zig)
- [Radix sort](sorting/radix_sort.zig)
