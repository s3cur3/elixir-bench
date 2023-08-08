defmodule DeduplicationBench do
  use Benchfella

  @unique_values Enum.map(0..10_000, &%{id: &1})
  @many_duplicates Enum.shuffle(@unique_values ++ @unique_values)
  @single_duplicate Enum.shuffle([%{id: 1000} | @unique_values])

  bench "Enum.uniq/1 (many duplicates)" do
    Enum.uniq(@many_duplicates)
  end

  bench "MapSet (many duplicates)" do
    MapSet.new(@many_duplicates)
  end

  bench "MapSet back to list (many duplicates)" do
    @many_duplicates
    |> MapSet.new()
    |> Enum.to_list()
  end

  bench "Enum.uniq/1 (single duplicate)" do
    Enum.uniq(@single_duplicate)
  end

  bench "MapSet (single duplicate)" do
    MapSet.new(@single_duplicate)
  end

  bench "MapSet back to list (single duplicate)" do
    @single_duplicate
    |> MapSet.new()
    |> Enum.to_list()
  end
end
