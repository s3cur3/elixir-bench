defmodule FilterMapBench do
  use Benchfella

  @values Enum.to_list(0..10_000) |> Enum.shuffle()

  bench "Map + filter" do
    @values
    |> Enum.filter(&even?/1)
    |> Enum.map(&square/1)
  end

  bench "For comprehension removing odd values with function capture" do
    # Simulate wrapping this all in a utility function
    mapper = fn val -> val * val end

    for val <- @values, even?(val) do
      mapper.(val)
    end
  end

  bench "For comprehension removing odd values without function capture" do
    for val <- @values, even?(val) do
      square(val)
    end
  end

  bench ":lists.filtermap with function capture" do
    # Simulate wrapping this all in a utility function
    mapper = fn val -> val * val end

    :lists.filtermap(
      fn x ->
        if even?(x) do
          {true, mapper.(x)}
        else
          false
        end
      end,
      @values
    )
  end

  bench ":lists.filtermap without function capture" do
    :lists.filtermap(
      fn x ->
        if even?(x) do
          {true, square(x)}
        else
          false
        end
      end,
      @values
    )
  end

  defp even?(val), do: rem(val, 2) == 0
  defp square(val), do: val * val
end
