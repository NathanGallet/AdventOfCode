defmodule Day13 do
  @moduledoc false

  def run do
    input =
      "./lib/inputs/day13.txt"
      |> File.read!()
      |> parse_input()

    IO.puts("Value of part1 : #{part1(input)}")
    IO.puts("Value of part2 : #{part2(input)}")
  end

  def parse_input(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.with_index(fn lines, index ->
      [{left, _}, {right, _}] =
        lines
        |> String.split("\n", trim: true)
        |> Enum.map(&Code.eval_string/1)

      {index, %{left: left, right: right}}
    end)
    |> Enum.into(%{})
  end

  def part1(input) do
    input
    |> Enum.reduce([], fn {index, %{left: left, right: right}}, result ->
      case is_smaller?(left, right) do
        true -> [index + 1 | result]
        false -> result
      end
    end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> Enum.reduce([[[2]], [[6]]], fn {_index, %{left: left, right: right}}, acc ->
      Enum.concat(acc, [left, right])
    end)
    |> Enum.sort(fn left, right -> is_smaller?(left, right) end)
    |> Enum.with_index()
    |> Enum.filter(fn {value, _index} -> value == [[2]] or value == [[6]] end)
    |> Enum.reduce(1, fn {_value, index}, result -> (index + 1) * result end)
  end

  defp is_smaller?(left, right) when is_integer(left) and is_integer(right) do
    cond do
      left < right -> true
      left > right -> false
      left == right -> :equal
    end
  end

  defp is_smaller?([l | left], [r | right]) do
    case is_smaller?(l, r) do
      :equal -> is_smaller?(left, right)
      result -> result
    end
  end

  defp is_smaller?(left, right) when is_integer(left), do: is_smaller?([left], right)
  defp is_smaller?(left, right) when is_integer(right), do: is_smaller?(left, [right])
  defp is_smaller?([], []), do: :equal
  defp is_smaller?([], _), do: true
  defp is_smaller?(_, []), do: false
end
