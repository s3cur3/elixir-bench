defmodule LoggerBench do
  require Logger
  use Benchfella

  Logger.configure(level: :info)

  @range 1..1_000
  @iolist ["foo", ?\s, "bar", ?\s, "baz"]
  @binary ["foo bar baz"]

  bench "Logging using an iolist message generator" do
    for val <- @range do
      Logger.info(fn -> @iolist end)
    end
  end

  bench "Logging using a straight iolist" do
    for val <- @range do
      Logger.info(@iolist)
    end
  end

  bench "Logging using a binary" do
    for val <- @range do
      Logger.info(@binary)
    end
  end

  bench "Skipping logging using an iolist message generator" do
    for val <- @range do
      Logger.debug(fn -> @iolist end)
    end
  end

  bench "Skipping logging using a straight iolist" do
    for val <- @range do
      Logger.debug(@iolist)
    end
  end

  bench "Skipping logging using a binary" do
    for val <- @range do
      Logger.debug(@binary)
    end
  end

  defp is_even(val) do
    rem(val, 2) == 0
  end
end
