<h2 align="center">Sorting Algorithms</h2>

## Sections

- [Running](#running)
- [Testing](#testing)
- [Comparison](#comparison)
- [Benchmarks](#benchmarks)
- [Animations](#animations)

## Running <a name = "running"></a>

To test another algorithm change the name of the `.zig` file to point to another implementation.

```console
zig build-exe bubble_sort.zig
./bubble_sort
```

## Testing <a name = "testing"></a>

```console
zig test bubble_sort.zig
```

## Comparison <a name = "comparison"></a>

Information in the table applies for the versions of algorithms implemented here. Other variants of the same algorithms may have differing characteristics.

| Algorithm      | Stable | Average Performance | Auxiliary Space Complexity |
| -------------- | :----: | :-----------------: | :------------------------: |
| Bubble sort    |  yes   | _O(n<sup>2</sup>)_  |           _O(1)_           |
| Insertion sort |  yes   | _O(n<sup>2</sup>)_  |           _O(1)_           |
| Quicksort      |   no   |    _O(n log n)_     |           _O(n)_           |
| Merge sort     |  yes   |    _O(n log n)_     |           _O(n)_           |
| Radix sort     |  yes   |      _O(w\*n)_      |          _O(w+n)_          |

Table glossary:

**Stable:** original order of elements of equal value is preserved\
**n:** length of the array\
**w:** number of bits required to store each key

## Benchmarks <a name = "benchmarks"></a>

Benchmark results and instructions for running them coming soon...

## Animations <a name = "animations"></a>

Animations of the algoritms running in actions coming soon...
