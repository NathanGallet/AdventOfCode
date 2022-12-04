defmodule Day04 do
  @moduledoc false

  def run do
    input =
      "./lib/inputs/day04.txt"
      |> File.read!()
      |> parse_input()

    IO.puts("Value of part1 : #{part1(input)}")
    IO.puts("Value of part2 : #{part2(input)}")
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(fn section ->
        section
        |> String.split("-")
        |> Enum.map(&String.to_integer/1)
      end)
    end)
  end

  def part1(input) do
    input
    |> Enum.count(fn [section1, section2] ->
      contains?(section1, section2) or contains?(section2, section1)
    end)
  end

  def part2(input) do
    input
    |> Enum.count(fn [[min1, max1], [min2, max2]] ->
      not Range.disjoint?(min1..max1, min2..max2)
    end)
  end

  defp contains?([min1, max1], [min2, max2]), do: min1 >= min2 and max1 <= max2
end
