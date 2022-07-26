defmodule StreamBench do
  use Benchfella

  @range 1..10_000
  @list Enum.shuffle(@range)

  bench "Filter a list using Enum" do
    @list
    |> Enum.filter(&is_even/1)
    |> Enum.sum()
  end

  bench "Filter a list using Stream" do
    @list
    |> Stream.filter(&is_even/1)
    |> Enum.sum()
  end

  bench "Filter a range using Enum" do
    @range
    |> Enum.filter(&is_even/1)
    |> Enum.sum()
  end

  bench "Filter a range using Stream" do
    @range
    |> Stream.filter(&is_even/1)
    |> Enum.sum()
  end

  defp is_even(val) do
    rem(val, 2) == 0
  end
end
