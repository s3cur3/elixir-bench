# Elixir Benchmarks

A collection of random benchmarks, for answering questions I have about which way to do a thing is faster.

Run `$ mix bench [something]_bench.exs` from the root directory

## My results

Note that I've run all these tests using a version of Erlang/OTP with the JIT (v24+ on Intel, v25+ on ARM).

### List comprehension

```
## ListComprehensionBench
benchmark name                                        iterations   average time 
Evens using `for` comprehension with inline test           10000   145.34 µs/op
Evens using `for` comprehension with named function        10000   174.75 µs/op
Evens using `Enum` with anonymous function                 10000   193.00 µs/op
Evens using `Enum` with named function                     10000   194.82 µs/op
```

### Stream versus Enum

This one does a *little* more than filtering (on the assumption that this isn't the final step in your pipeline... if you're considering `Stream`, you probably still have to do *something* with it at the end).

```
## StreamBench
benchmark name               iterations   average time 
Filter a list using Enum         100000   151.99 µs/op
Filter a list using Stream       100000   179.55 µs/op
Filter a range using Enum        100000   103.00 µs/op
Filter a range using Stream      100000   179.51 µs/op
```

### Logging with a generator function vs. iolist vs. binary

If your data is cheap to generate, it makes roughly no difference
whether you use a generator versus an iolist. A binary may be a tiny, tiny bit
slower, but the actual time to write the log massively dominates those differences.

```
## Loggerbench
benchmark name                                      iterations   average time 
Skipping logging using a straight iolist                 50000   59.60 µs/op
Skipping logging using an iolist message generator       50000   59.91 µs/op
Skipping logging using a binary                          50000   60.15 µs/op
Logging using an iolist message generator                   50   32229.96 µs/op
Logging using a straight iolist                             50   32782.38 µs/op
Logging using a binary                                     100   33229.38 µs/op
```

### Geometry coordinate rounding

For large geometry collections, it looks like doing a `Float.round/2` on each
of the coordinates has a smaller impact on the serialization time than I expected.
(JIT FTW!)

```
## GeometryCoordinateRoundingBench
benchmark name                        iterations   average time 
Serializing the geometry as-is                 1   1434005.00 µs/op
Rounding the coordinates to 6 digits           1   2914367.00 µs/op
```

## Compact map (i.e., mapping over a collection, then removing nil values)

This algorithm comes [from the Swift standard library](https://developer.apple.com/documentation/swift/sequence/compactmap(_:)).

Interestingly, the `for` comprehension is *way* faster here. I have no explanation for why `:lists.filtermap/2` is so much slower *without* the function capture, but I've rewritten that benchmark a half dozen different ways and keep getting the same results. 

```
## CompactMapBench
benchmark name                                                  iterations   average time 
For comprehension removing nil values without function capture      500000   137.33 µs/op
For comprehension removing nil values with function capture         500000   149.56 µs/op
:lists.filtermap with function capture                              200000   250.37 µs/op
Flat map + List.wrap                                                100000   342.46 µs/op
Map + reject                                                        100000   346.86 µs/op
:lists.filtermap without function capture                           100000   427.62 µs/op
```

