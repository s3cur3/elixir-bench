# Elixir Benchmarks

A collection of random benchmarks, for answering questions I have about which way to do a thing is faster.

Run `$ mix bench [something]_bench.exs` from the root directory

## My results

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
