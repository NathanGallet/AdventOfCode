defmodule Day06 do
  @moduledoc false

  def run do
    input =
      "./lib/inputs/day06.txt"
      |> File.read!()

    IO.puts("Value of part1 : #{part1(input)}")
    IO.puts("Value of part2 : #{part2(input)}")
  end

  def part1(input) do
    input
    |> String.codepoints()
    |> Enum.reduce({[], 0}, fn charactere, {pattern, index} ->
      solution(pattern, index, charactere, 4)
    end)
    |> elem(1)
  end

  def part2(input) do
    input
    |> String.codepoints()
    |> Enum.reduce({[], 0}, fn charactere, {pattern, index} ->
      solution(pattern, index, charactere, 14)
    end)
    |> elem(1)
  end

  defp solution(pattern, index, charactere, size) when length(pattern) == size do
    case Enum.uniq(pattern) == pattern do
      true ->
        {pattern, index}

      false ->
        remove_value(pattern, charactere, index)
    end
  end

  defp solution(pattern, index, charactere, _size),
    do: {Enum.concat(pattern, [charactere]), index + 1}

  defp remove_value([tail | head], charactere, index) do
    case tail in head do
      false ->
        remove_value(head, charactere, index)

      true ->
        {Enum.concat(head, [charactere]), index + 1}
    end
  end
end
