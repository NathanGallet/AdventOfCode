defmodule Day05Test do
  use ExUnit.Case

  test "day05" do
    input =
      """
          [D]
      [N] [C]
      [Z] [M] [P]
       1   2   3

      move 1 from 2 to 1
      move 3 from 1 to 3
      move 2 from 2 to 1
      move 1 from 1 to 2
      """
      |> Day05.parse_input()

    assert Day05.part1(input) == "CMZ"
    assert Day05.part2(input) == "MCD"
  end
end
