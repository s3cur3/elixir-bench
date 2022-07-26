# Elixir Benchmarks

A collection of random benchmarks, for answering questions I have about which way to do a thing is faster.

Run `$ mix bench [something]_bench.exs` from the root directory

## My results

Note that I've run all these tests using a version of Erlang/OTP with the JIT (v24+ on Intel, v25+ on ARM).

### List comprehension

```
$ mix bench list_comprehension_bench.exs 
Settings:
  duration:      1.0 s

## ListComprehensionBench
[09:46:57] 1/4: Evens using `Enum` with anonymous function
[09:46:59] 2/4: Evens using `Enum` with named function
[09:47:01] 3/4: Evens using `for` comprehension with inline test
[09:47:03] 4/4: Evens using `for` comprehension with named function

Finished in 7.87 seconds

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
[20:29:37] 1/4: Filter a list using Enum
[20:29:54] 2/4: Filter a list using Stream
[20:30:14] 3/4: Filter a range using Enum
[20:30:26] 4/4: Filter a range using Stream

Finished in 68.89 seconds

## StreamBench
benchmark name               iterations   average time 
Filter a list using Enum         100000   151.99 µs/op
Filter a list using Stream       100000   179.55 µs/op
Filter a range using Enum        100000   103.00 µs/op
Filter a range using Stream      100000   179.51 µs/op
```
