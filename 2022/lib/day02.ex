defmodule Day02 do
  @moduledoc false

  @score %{
    "A" => 1,
    "B" => 2,
    "C" => 3
  }

  @winning_combinaison %{
    "A" => "C",
    "B" => "A",
    "C" => "B"
  }

  def run do
    input =
      "./lib/inputs/day02.txt"
      |> File.read!()
      |> parse_input()

    IO.puts("Value of part1 : #{part1(input)}")
    IO.puts("Value of part2 : #{part2(input)}")
  end

  def parse_input(input), do: String.split(input, "\n", trim: true)

  def part1(input) do
    input
    |> Enum.map(fn current_round ->
      [opponent_choice, my_choice] = String.split(current_round, " ")
      calculate_result(opponent_choice, convert_my_moves(my_choice))
    end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> Enum.map(fn current_round ->
      [opponent_choice, my_strategy] = String.split(current_round, " ")
      strategy(my_strategy, opponent_choice)
    end)
    |> Enum.sum()
  end

  defp convert_my_moves(<<ascii_value>>), do: List.to_string([ascii_value - 23])

  # Need to lose
  defp strategy("X", opponent_choice),
    do: calculate_result(opponent_choice, @winning_combinaison[opponent_choice])

  # Need a draw
  defp strategy("Y", opponent_choice), do: calculate_result(opponent_choice, opponent_choice)

  # Need a win
  defp strategy("Z", opponent_choice) do
    @winning_combinaison
    |> Enum.find(fn {_choice, win_against} -> win_against == opponent_choice end)
    |> elem(0)
    |> (&calculate_result(opponent_choice, &1)).()
  end

  defp calculate_result(opponent_choice, my_choice) when opponent_choice == my_choice,
    do: @score[my_choice] + 3

  defp calculate_result(opponent_choice, my_choice) do
    case @winning_combinaison[my_choice] == opponent_choice do
      true -> @score[my_choice] + 6
      false -> @score[my_choice]
    end
  end
end
