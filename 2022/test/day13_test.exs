defmodule Day13Test do
  use ExUnit.Case

  test "day13" do
    input =
      """
      [1,1,3,1,1]
      [1,1,5,1,1]

      [[1],[2,3,4]]
      [[1],4]

      [9]
      [[8,7,6]]

      [[4,4],4,4]
      [[4,4],4,4,4]

      [7,7,7,7]
      [7,7,7]

      []
      [3]

      [[[]]]
      [[]]

      [1,[2,[3,[4,[5,6,7]]]],8,9]
      [1,[2,[3,[4,[5,6,0]]]],8,9]
      """
      |> Day13.parse_input()

    assert Day13.part1(input) == 13
    assert Day13.part2(input) == 140
  end
end
