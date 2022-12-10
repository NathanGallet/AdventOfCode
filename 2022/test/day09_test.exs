defmodule Day09Test do
  use ExUnit.Case

  test "day09 part1" do
    input =
      """
      R 4
      U 4
      L 3
      D 1
      R 4
      D 1
      L 5
      R 2
      """
      |> Day09.parse_input()

    assert Day09.part1(input) == 13
    assert Day09.part2(input) == 1
  end

  test "day09 part2" do
    input =
      """
      R 5
      U 8
      L 8
      D 3
      R 17
      D 10
      L 25
      U 20
      """
      |> Day09.parse_input()

    assert Day09.part2(input) == 36
  end
end
