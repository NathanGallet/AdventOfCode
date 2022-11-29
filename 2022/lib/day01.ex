defmodule Day01 do
  @moduledoc false

  def run do
    "day01"
    |> Aoc.read_input_as_list_of_integer!()
    |> part1()
  end

  def part1(input) do
    input
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [left, right] -> right > left end)
  end
end
