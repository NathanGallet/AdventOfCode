defmodule Day03 do
  @moduledoc false

  def run do
    input =
      "./lib/inputs/day03.txt"
      |> File.read!()
      |> parse_input()

    IO.puts("Value of part1 : #{part1(input)}")
    IO.puts("Value of part2 : #{part2(input)}")
  end

  def parse_input(input), do: String.split(input, "\n", trim: true)

  def part1(input) do
    input
    |> Enum.map(fn rucksack ->
      half_bag = Integer.floor_div(String.length(rucksack), 2)

      [first_compartment, seconde_compartment] =
        rucksack
        |> String.codepoints()
        |> Enum.chunk_every(half_bag)

      first_compartment
      |> Enum.reject(fn item -> item not in seconde_compartment end)
      |> Enum.uniq()
      |> score()
    end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> Enum.chunk_every(3)
    |> Enum.map(fn [rucksack_one, rucksack_two, rucksack_three] ->
      items_two = String.codepoints(rucksack_two)
      items_three = String.codepoints(rucksack_three)

      rucksack_one
      |> String.codepoints()
      |> Enum.reject(fn item ->
        item not in items_two || item not in items_three
      end)
      |> Enum.uniq()
      |> score()
    end)
    |> Enum.sum()
  end

  defp score(items) when is_list(items) do
    items
    |> Enum.map(&score/1)
    |> Enum.sum()
  end

  defp score(<<ascii>> = item) when is_binary(item) do
    case String.upcase(item) == item do
      true -> ascii - 38
      false -> ascii - 96
    end
  end
end
