defmodule ListComprehensionBench do
  use Benchfella

  @range 1..10_000

  bench "Evens using `for` comprehension with named function" do
    for val <- @range, is_even(val) do
      val
    end
  end

  bench "Evens using `for` comprehension with inline test" do
    for val <- @range, rem(val, 2) == 0 do
      val
    end
  end

  bench "Evens using `Enum` with named function" do
    Enum.filter(@range, &is_even/1)
  end

  bench "Evens using `Enum` with anonymous function" do
    Enum.filter(@range, &(rem(&1, 2) == 0))
  end

  defp is_even(val) do
    rem(val, 2) == 0
  end
end
