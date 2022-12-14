defmodule Day14Test do
  use ExUnit.Case

  test "day14" do
    input =
      """
      498,4 -> 498,6 -> 496,6
      503,4 -> 502,4 -> 502,9 -> 494,9
      """
      |> Day14.parse_input()

    assert Day14.part1(input) == 24
    assert Day14.part2(input) == 93
  end
end
