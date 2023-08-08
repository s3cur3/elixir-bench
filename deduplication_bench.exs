defmodule DeduplicationBench do
  use Benchfella

  @unique_values Enum.map(0..10_000, &%{id: &1})
  @duplicated_values Enum.shuffle(@unique_values ++ @unique_values)

  bench "Enum.uniq/1" do
    Enum.uniq(@duplicated_values)
  end

  bench "MapSet" do
    MapSet.new(@duplicated_values)
  end

  bench "MapSet back to list" do
    @duplicated_values
    |> MapSet.new()
    |> Enum.to_list()
  end
end
