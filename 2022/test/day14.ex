defmodule Day14 do
  @moduledoc false

  @sand {0, 500}
  @blocker [:sand, :rock]

  def run do
    input =
      "./lib/inputs/day14.txt"
      |> File.read!()
      |> parse_input()

    IO.puts("Value of part1 : #{part1(input)}")
    IO.puts("Value of part2 : #{part2(input)}")
  end

  def parse_input(input) do
    input =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split("->", trim: true)
        |> Enum.map(fn coord ->
          coord
          |> String.trim()
          |> String.split(",")
          |> Enum.map(&String.to_integer/1)
        end)
      end)

    [[min_col, max_col], max_row] =
      input
      |> Enum.map(&find_min_max/1)
      |> find_min_max()

    init_map =
      for row <- Enum.to_list(0..max_row),
          col <- Enum.to_list(min_col..max_col),
          into: %{} do
        {{row, col}, :empty}
      end

    {input
     |> Enum.reduce(init_map, fn line, map ->
       line
       |> Enum.chunk_every(2, 1, :discard)
       |> Enum.reduce(map, fn [[col1, row1], [col2, row2]], map ->
         cond do
           col1 == col2 ->
             row1..row2
             |> Enum.to_list()
             |> Enum.reduce(map, fn row, map -> %{map | {row, col1} => :rock} end)

           row1 == row2 ->
             col1..col2
             |> Enum.to_list()
             |> Enum.reduce(map, fn col, map -> %{map | {row1, col} => :rock} end)

           true ->
             IO.puts("Da fuck?")
         end
       end)
     end), [[min_col, max_col], max_row]}
  end

  def part1({map, _max}) do
    map
    |> fall(@sand, nil)
    |> Enum.reduce(0, fn {_node, value}, result ->
      case value do
        :sand -> result + 1
        _ -> result
      end
    end)
  end

  def part2({map, [[min_col, max_col], max_row]}) do
    min_col..max_col
    |> Enum.to_list()
    |> Enum.reduce(map, fn col, map ->
      map
      |> Map.put({max_row + 1, col}, :empty)
      |> Map.put({max_row + 2, col}, :rock)
    end)
    |> fall(@sand, max_row + 2)
    |> Enum.reduce(1, fn {_node, value}, result ->
      case value do
        :sand -> result + 1
        _ -> result
      end
    end)
  end

  defp fall(map, :into_the_abyss, _), do: map

  defp fall(map, {row, col}, ground) do
    cond do
      map[{row + 1, col}] == :empty ->
        fall(map, {row + 1, col}, ground)

      empty_left?(map, {row, col}) ->
        fall(map, {row + 1, col - 1}, ground)

      empty_right?(map, {row, col}) ->
        fall(map, {row + 1, col + 1}, ground)

      is_surround?(map, {row, col}) ->
        case {row, col} == @sand do
          true -> fall(map, :into_the_abyss, ground)
          false -> fall(%{map | {row, col} => :sand}, @sand, ground)
        end

      not is_nil(ground) ->
        {min, max} = find_min_max(map)

        0..ground
        |> Enum.to_list()
        |> Enum.reduce(map, fn row, map ->
          blocker =
            case row == ground do
              true -> :rock
              false -> :empty
            end

          map
          |> Map.put({row, min - 1}, blocker)
          |> Map.put({row, max + 1}, blocker)
        end)
        |> fall(@sand, ground)

      true ->
        fall(map, :into_the_abyss, ground)
    end
  end

  defp empty_left?(map, {row, col}) do
    map[{row + 1, col - 1}] == :empty
  end

  defp empty_right?(map, {row, col}) do
    map[{row + 1, col + 1}] == :empty
  end

  defp is_surround?(map, {row, col}) do
    blocker_under =
      map[{row + 1, col}] in @blocker and
        map[{row + 1, col - 1}] in @blocker and
        map[{row + 1, col + 1}] in @blocker

    trapped =
      map[{row + 1, col}] in @blocker and
        map[{row, col - 1}] in @blocker and
        map[{row, col + 1}] in @blocker

    blocker_under or trapped
  end

  defp find_min_max([[x, y] | _rest] = list) when is_integer(x) and is_integer(y) do
    Enum.reduce(list, [[10000, 0], 0], fn [x, y], [[min_x, max_x], max_y] ->
      [
        [
          if(x < min_x, do: x, else: min_x),
          if(x > max_x, do: x, else: max_x)
        ],
        if(y > max_y, do: y, else: max_y)
      ]
    end)
  end

  defp find_min_max(list) when is_list(list) do
    Enum.reduce(list, [[10000, 0], 0], fn [[x1, x2], y], [[min_x, max_x], max_y] ->
      [
        [
          if(x1 < min_x, do: x1, else: min_x),
          if(x2 > max_x, do: x2, else: max_x)
        ],
        if(y > max_y, do: y, else: max_y)
      ]
    end)
  end

  defp find_min_max(map) when is_map(map) do
    map
    |> Map.keys()
    |> Enum.map(fn {_row, col} -> col end)
    |> Enum.min_max()
  end
end
