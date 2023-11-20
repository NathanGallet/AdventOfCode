defmodule Day15 do
  @moduledoc false
  def run do
    input =
      "./lib/inputs/day15.txt"
      |> File.read!()
      |> parse_input()

    IO.puts("Value of part1 : #{part1(input, 2_000_000)}")
    # IO.puts("Value of part2 : #{part2(input)}")
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce([], fn line, result ->
      [[_, sensor_x], [_, sensor_y], [_, beacon_x], [_, beacon_y]] =
        Regex.scan(~r/[x|y]=(-?\d+)/, line)

      [sensor_x, sensor_y, beacon_x, beacon_y] =
        Enum.map([sensor_x, sensor_y, beacon_x, beacon_y], &String.to_integer/1)

      sensor = {sensor_x, sensor_y}
      beacon = {beacon_x, beacon_y}

      [%{sensor: sensor, beacon: beacon}, distance: manhattan_distance(sensor, beacon) | result]
    end)
  end

  def part1(input, line) do
    input
    |> Enum.reduce(0, fn %{sensor: {sensor_x, sensor_y}, beacon: beacon, distance: distance},
                         result ->
      limit = distance - abs(sensor_y - line)
      nil
    end)
  end

  def part2(input) do
    input
  end

  defp manhattan_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  defp print(map) do
    map
    |> Enum.reduce(%{}, fn {{row, col}, value}, acc ->
      case is_nil(acc[row]) do
        true -> Map.put(acc, row, [{col, value}])
        false -> %{acc | row => [{col, value} | acc[row]]}
      end
    end)
    |> Enum.map(fn {_row, col} ->
      col
      |> Enum.sort_by(fn {col_number, _} -> col_number end)
      |> Enum.map(fn {_, value} ->
        case value do
          :empty -> "."
          :beacon -> "B"
          :sensor -> "S"
          value -> value
        end
      end)
      |> Enum.join("")
    end)
    |> Enum.each(fn line ->
      IO.inspect(line)
    end)

    IO.puts("\n")

    map
  end
end
