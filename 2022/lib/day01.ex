defmodule Day01 do
  @moduledoc false

  def run do
    input =
      "./lib/inputs/day01.txt"
      |> File.read!()
      |> parse_input()

    IO.puts("Value of part1 : #{part1(input)}")
    IO.puts("Value of part2 : #{part2(input)}")
  end

  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.chunk_by(&(&1 == ""))
    |> Enum.reject(&(&1 == [""]))
    |> Enum.map(fn elf_calories ->
      elf_calories
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()
    end)
  end

  def part1(input), do: Enum.max(input)

  def part2(input) do
    input
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end
end
