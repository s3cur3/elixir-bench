defmodule MapCompactBench do
  use Benchfella

  @real_values Enum.map(0..10_000, &%{id: &1})
  @nil_values List.duplicate(%{id: nil}, 1_000)
  @values Enum.concat(@real_values, @nil_values) |> Enum.shuffle()

  bench "Map + reject" do
    @values
    |> Enum.map(&select_id/1)
    |> Enum.reject(&is_nil/1)
  end

  bench "For comprehension removing nil values with function capture" do
    # Do a function capture here to simulate wrapping this all in a utility function
    func = &select_id/1

    for val <- @values, mapped_val = func.(val), not is_nil(mapped_val) do
      mapped_val
    end
  end

  bench "For comprehension removing nil values without function capture" do
    for val <- @values, mapped_val = select_id(val), not is_nil(mapped_val) do
      mapped_val
    end
  end

  bench ":lists.filtermap with function capture" do
    # Do a function capture here to simulate wrapping this all in a utility function
    func = &select_id/1

    :lists.filtermap(
      fn x ->
        case func.(x) do
          nil -> false
          mapped_val -> {true, mapped_val}
        end
      end,
      @values
    )
  end

  bench ":lists.filtermap without function capture" do
    :lists.filtermap(
      fn x ->
        case select_id(x) do
          nil -> false
          mapped_val -> {true, mapped_val}
        end
      end,
      @values
    )
  end

  bench "Flat map + List.wrap" do
    Enum.flat_map(@values, &List.wrap(select_id(&1)))
  end

  defp select_id(%{id: id}), do: id
end
