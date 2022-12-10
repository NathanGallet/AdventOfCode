defmodule Day10 do
  @moduledoc false
  @cycles [
    20,
    60,
    100,
    140,
    180,
    220
  ]

  @sprite_width [
    40,
    80,
    120,
    160,
    200,
    240
  ]

  def run do
    input =
      "./lib/inputs/day10.txt"
      |> File.read!()
      |> parse_input()

    IO.puts("Value of part1 : #{part1(input)}")
    IO.inspect(part2(input))
  end

  def parse_input(input), do: String.split(input, "\n", trim: true)

  def part1(input) do
    input
    |> Enum.reduce({0, 1, 0}, fn instruction, {cycle, buffer, result} ->
      instruction(instruction, cycle, buffer, result, &add_cycle/3)
    end)
    |> elem(2)
  end

  def part2(input) do
    input
    |> Enum.reduce({0, 1, [[]]}, fn instruction, {cycle, buffer, result} ->
      instruction(instruction, cycle, buffer, result, &sprite/3)
    end)
    |> elem(2)
    |> Enum.reverse()
    |> Enum.map(&Enum.join(&1, ""))
  end

  defp instruction("noop", cycle, buffer, result, f), do: f.(cycle + 1, buffer, result)

  defp instruction("addx " <> value, cycle, buffer, result, f) do
    {cycle, buffer, result} =
      Enum.reduce(1..2, {cycle, buffer, result}, fn _current_cycle, {cycle, buffer, result} ->
        f.(cycle + 1, buffer, result)
      end)

    {cycle, buffer + String.to_integer(value), result}
  end

  defp add_cycle(cycle, buffer, result) when cycle in @cycles,
    do: {cycle, buffer, result + buffer * cycle}

  defp add_cycle(cycle, buffer, result), do: {cycle, buffer, result}

  defp sprite(cycle, buffer, result) when (cycle - 1) in @sprite_width,
    do: {1, buffer, [["#"] | result]}

  defp sprite(cycle, buffer, [current_line | result]) do
    pixel =
      case abs(buffer - (cycle - 1)) <= 1 do
        true -> "#"
        false -> "."
      end

    {cycle, buffer, [List.insert_at(current_line, -1, pixel) | result]}
  end
end
