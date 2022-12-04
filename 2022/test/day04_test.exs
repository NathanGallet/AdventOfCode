defmodule Day04Test do
  use ExUnit.Case

  test "day04" do
    input =
      """
      2-4,6-8
      2-3,4-5
      5-7,7-9
      2-8,3-7
      6-6,4-6
      2-6,4-8
      """
      |> Day04.parse_input()

    assert Day04.part1(input) == 2
    assert Day04.part2(input) == 4
  end
end
