defmodule PrioritizeBench do
  use Benchfella

  @size 10_000
  @ordered Enum.map(0..@size, &%{id: &1})
  @shuffled Enum.shuffle(@ordered)

  bench("Split + join (ordered)", do: split_join_prioritize(@ordered))
  bench("Split + join (shuffled)", do: split_join_prioritize(@shuffled))
  bench("Sort (ordered)", do: sort_prioritize(@ordered))
  bench("Sort (shuffled)", do: sort_prioritize(@shuffled))

  defp split_join_prioritize(enum) do
    half = div(@size, 2)
    {true_vals, false_vals} = Enum.split_with(enum, &(&1 < half))
    true_vals ++ false_vals
  end

  defp sort_prioritize(enum) do
    half = div(@size, 2)
    # :false always gets sorted before :true
    Enum.sort_by(enum, &(&1 >= half))
  end
end
