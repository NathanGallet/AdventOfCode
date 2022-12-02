defmodule Day02Test do
  use ExUnit.Case

  test "day02" do
    input =
      """
      A Y
      B X
      C Z
      """
      |> Day02.parse_input()

    assert Day02.part1(input) == 15
    assert Day02.part2(input) == 12
  end
end
