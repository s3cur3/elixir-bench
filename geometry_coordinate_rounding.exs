defmodule GeometryCoordinateRoundingBench do
  use Benchfella

  @geometries Enum.map(1..1_000, fn i ->
                %{
                  coordinates: Enum.map(0..i, fn _ -> {:rand.uniform() * 360 - 180, :rand.uniform() * 180 - 90} end)
                }
              end)

  bench "Serializing the geometry as-is" do
    @geometries
    |> Enum.map(&make_coords_serializable/1)
    |> Jason.encode!()
  end

  bench "Rounding the coordinates to 6 digits" do
    @geometries
    |> Enum.map(&round_coords/1)
    |> Jason.encode!()
  end

  defp make_coords_serializable(%{coordinates: lon_lat_points} = element) do
    %{element | coordinates: Enum.map(lon_lat_points, &Tuple.to_list/1)}
  end

  defp round_coords(%{coordinates: lon_lat_points} = element) do
    %{
      element
      | coordinates:
          Enum.map(lon_lat_points, fn {lon, lat} ->
            [Float.round(lon, 6), Float.round(lat, 6)]
          end)
    }
  end
end
