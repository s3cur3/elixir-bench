defmodule ElixirStartingPoint.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_bench,
      version: "0.1.0",
      elixir: "~> 1.13",
      consolidate_protocols: Mix.env() != :test,
      deps: deps()
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:benchfella, ">= 0.0.0"},
      {:credo, "~> 1.6.1", only: [:dev, :test], runtime: false}
    ]
  end
end
