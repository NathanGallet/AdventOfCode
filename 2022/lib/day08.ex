defmodule Day08 do
  @moduledoc false

  def run do
    input =
      "./lib/inputs/day08.txt"
      |> File.read!()
      |> parse_input()

    IO.puts("Value of part1 : #{part1(input)}")
    IO.puts("Value of part2 : #{part2(input)}")
  end

  def parse_input(input) do
    input = String.split(input, "\n", trim: true)

    forest =
      for {line, row} <- Enum.with_index(input),
          {number, col} <- Enum.with_index(String.to_charlist(line)),
          into: %{} do
        {{row, col}, number - ?0}
      end

    max_row = length(input)

    max_col =
      input
      |> Enum.at(0)
      |> String.length()

    {forest, {max_row - 1, max_col - 1}}
  end

  def part1({forest, {max_row, max_col}}) do
    forest
    |> Enum.count(fn {{row, col}, _height} ->
      visible_vertical?(forest, {row, col}, max_row, 0, row - 1) or
        visible_vertical?(forest, {row, col}, max_row, row + 1, max_row) or
        visible_horizontal?(forest, {row, col}, max_col, col + 1, max_col) or
        visible_horizontal?(forest, {row, col}, max_col, 0, col - 1)
    end)
  end

  def part2({forest, {max_row, max_col}}) do
    forest
    |> Enum.map(fn {{row, col}, _height} ->
      count_vertical(forest, {row, col}, max_row, row - 1, 0) *
        count_vertical(forest, {row, col}, max_row, row + 1, max_row) *
        count_horizontal(forest, {row, col}, max_col, col + 1, max_col) *
        count_horizontal(forest, {row, col}, max_col, col - 1, 0)
    end)
    |> Enum.max()
  end

  defp count_vertical(_forest, {0, _col}, _max_row, _from, _to), do: 0
  defp count_vertical(_forest, {row, _col}, max_row, _from, _to) when row == max_row, do: 0

  defp count_vertical(forest, {row, col}, _max_row, from, to) do
    height = forest[{row, col}]

    Enum.reduce_while(from..to, 0, fn tree_row, result ->
      case forest[{tree_row, col}] < height do
        true -> {:cont, result + 1}
        false -> {:halt, result + 1}
      end
    end)
  end

  defp count_horizontal(_forest, {_row, col}, max_col, _from, _to) when col == max_col, do: 0
  defp count_horizontal(_forest, {_row, 0}, _max_col, _from, _to), do: 0

  defp count_horizontal(forest, {row, col}, _max_row, from, to) do
    height = forest[{row, col}]

    Enum.reduce_while(from..to, 0, fn tree_col, result ->
      case forest[{row, tree_col}] < height do
        true -> {:cont, result + 1}
        false -> {:halt, result + 1}
      end
    end)
  end

  defp visible_vertical?(_forest, {0, _col}, _max, _from, _to), do: true
  defp visible_vertical?(_forest, {row, _col}, max, _from, _to) when row == max, do: true

  defp visible_vertical?(forest, {row, col}, _max, from, to) do
    height = forest[{row, col}]

    Enum.all?(from..to, fn tree_row ->
      forest[{tree_row, col}] < height
    end)
  end

  defp visible_horizontal?(_forest, {_row, 0}, _max, _from, _to), do: true
  defp visible_horizontal?(_forest, {_row, col}, max, _from, _to) when col == max, do: true

  defp visible_horizontal?(forest, {row, col}, _max, from, to) do
    height = forest[{row, col}]

    Enum.all?(from..to, fn tree_col ->
      forest[{row, tree_col}] < height
    end)
  end
end
