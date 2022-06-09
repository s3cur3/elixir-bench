defmodule StringHelpers do
  def random_string(length) do
    for _ <- 1..length, into: "" do
      <<Enum.random('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')>>
    end
  end
end

defmodule CaseInsensitiveStringCompareBench do
  use Benchfella

  @small_strings for _ <- 1..10_000, do: StringHelpers.random_string(Enum.random(1..32))
  @small_strings_matching_regexes Enum.map(@small_strings, & ~r/#{String.downcase(&1)}/i)
  @small_strings_nonmatching_regexes Enum.shuffle(@small_strings_matching_regexes)

  bench "Downcase (Small, Equal)" do
    for s <- @small_strings do
      s == String.downcase(s)
    end
  end

  bench "Downcase (Small, Not equal)" do
    @small_strings
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] -> a == String.downcase(b) end)
  end

  bench "Regex (Small, Matching)" do
    Enum.zip_with(
      @small_strings,
      @small_strings_matching_regexes,
      fn str, re -> str =~ re end
    )
  end

  bench "Regex (Small, Not matching)" do
    @small_strings
    |> Enum.zip(@small_strings_nonmatching_regexes)
    |> Enum.map(fn {str, re} -> str =~ re end)
  end


end
