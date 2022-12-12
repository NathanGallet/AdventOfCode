defmodule Day12 do
  @moduledoc false

  @infinity 10_000
  def run do
    input =
      "./lib/inputs/day12.txt"
      |> File.read!()
      |> parse_input()

    IO.puts("Value of part1 : #{part1(input)}")
    IO.puts("Value of part2 : #{part2(input)}")
  end

  def parse_input(input) do
    input = String.split(input, "\n", trim: true)

    map =
      for {line, row} <- Enum.with_index(input),
          {letter, col} <- Enum.with_index(String.graphemes(line)),
          into: %{} do
        {{row, col}, letter}
      end

    init_value =
      map
      |> Enum.map(fn {{row, col}, _value} -> {{row, col}, @infinity} end)
      |> Enum.into(%{})

    {start, _} = Enum.find(map, fn {{_row, _col}, value} -> value == "S" end)
    {finish, _} = Enum.find(map, fn {{_row, _col}, value} -> value == "E" end)

    map =
      Enum.map(map, fn {coord, <<value::utf8>> = letter} ->
        case letter do
          "S" -> {coord, ?a - 97}
          "E" -> {coord, ?z - 97}
          _ -> {coord, value - 97}
        end
      end)
      |> Enum.into(%{})

    {map, init_value, start, finish}
  end

  def part1({map, distances, start, finish}) do
    distances = %{distances | start => 0}

    MapSet.new([start])
    |> dijkstra(map, distances, MapSet.new())
    |> Access.get(finish)
  end

  def part2({map, distances, _start, finish}) do
    map
    |> Enum.filter(fn {_node, elevation} -> elevation == 0 end)
    |> Enum.map(fn {node, _value} -> MapSet.new([node]) end)
    |> Enum.map(fn start ->
      node =
        start
        |> MapSet.to_list()
        |> hd()

      distances = %{distances | node => 0}

      start
      |> dijkstra(map, distances, MapSet.new())
      |> Access.get(finish)
    end)
    |> Enum.sort()
    |> hd()
  end

  defp dijkstra(nodes, map, distances, visited) do
    case MapSet.size(nodes) == 0 do
      true ->
        distances

      false ->
        [current_node | nodes] = Enum.sort_by(nodes, fn node -> distances[node] end)

        nodes = MapSet.new(nodes)

        {nodes, distances} =
          current_node
          |> next_moves(map)
          |> Enum.reject(fn node -> node in visited end)
          |> Enum.reduce({nodes, distances}, fn next_node, {nodes, distances} ->
            {
              MapSet.put(nodes, next_node),
              update(distances, distances[next_node], next_node, current_node)
            }
          end)

        dijkstra(nodes, map, distances, MapSet.put(visited, current_node))
    end
  end

  defp update(distances, distances_value, node, current_node) do
    case distances[current_node] + 1 < distances_value do
      true -> %{distances | node => distances[current_node] + 1}
      false -> distances
    end
  end

  defp next_moves({row, col}, map) do
    elevation = map[{row, col}]

    []
    |> next_move(map[{row + 1, col}], row + 1, col, elevation)
    |> next_move(map[{row - 1, col}], row - 1, col, elevation)
    |> next_move(map[{row, col + 1}], row, col + 1, elevation)
    |> next_move(map[{row, col - 1}], row, col - 1, elevation)
  end

  defp next_move(moves, value, _, _, _) when is_nil(value), do: moves

  defp next_move(moves, value, row, col, elevation) do
    case value <= elevation + 1 do
      true -> [{row, col} | moves]
      false -> moves
    end
  end
end
