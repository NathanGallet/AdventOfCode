defmodule Day05 do
  @moduledoc false

  def run do
    input =
      "./lib/inputs/day05.txt"
      |> File.read!()
      |> parse_input()

    IO.inspect(input)

    IO.puts("Value of part1 : #{part1(input)}")
    IO.puts("Value of part2 : #{part2(input)}")
  end

  def parse_input(input) do
    [stacks, instructions] =
      input
      |> String.split("\n\n", trim: true)

    stack =
      stacks
      |> String.split("\n")
      |> Enum.reverse()
      |> tl()
      |> Enum.reverse()
      |> Enum.reduce(
        %{
          "1" => [],
          "2" => [],
          "3" => [],
          "4" => [],
          "5" => [],
          "6" => [],
          "7" => [],
          "8" => [],
          "9" => []
        },
        fn line, stack ->
          line
          |> String.codepoints()
          |> Enum.chunk_every(4)
          |> Enum.reduce({stack, 1}, fn value, {stack, index} ->
            value
            |> Enum.join()
            |> String.trim()
            |> add_to_stack(index, stack)
          end)
          |> elem(0)
        end
      )

    instructions =
      instructions
      |> String.split("\n", trim: true)
      |> Enum.map(fn instruction ->
        ~r/\d+/
        |> Regex.scan(instruction)
        |> List.flatten()
      end)

    [stack, instructions]
  end

  def part1([stack, instructions]) do
    instructions
    |> Enum.reduce(stack, fn [number, from, to], stack ->
      {new_from, to_move} =
        Enum.split(stack[from], length(stack[from]) - String.to_integer(number))

      new_to = Enum.concat(stack[to], Enum.reverse(to_move))

      %{stack | from => new_from, to => new_to}
    end)
    |> response()
  end

  def part2([stack, instructions]) do
    instructions
    |> Enum.reduce(stack, fn [number, from, to], stack ->
      {new_from, to_move} =
        Enum.split(stack[from], length(stack[from]) - String.to_integer(number))

      new_to = Enum.concat(stack[to], to_move)

      %{stack | from => new_from, to => new_to}
    end)
    |> response()
  end

  defp add_to_stack("", index, stack), do: {stack, index + 1}

  defp add_to_stack(value, index, stack) do
    [item] = Regex.run(~r/\w/, value)
    {%{stack | to_string(index) => [item | stack[to_string(index)]]}, index + 1}
  end

  defp response(stack) do
    stack
    |> Enum.map(fn {_key, value} ->
      Enum.take(value, -1)
    end)
    |> Enum.join()
  end
end
