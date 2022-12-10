defmodule Day08Test do
  use ExUnit.Case

  test "day08 part1" do
    input =
      """
      30373
      25512
      65332
      33549
      35390
      """
      |> Day08.parse_input()

    assert Day08.part1(input) == 21
    assert Day08.part2(input) == 8
  end
end
