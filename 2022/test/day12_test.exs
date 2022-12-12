defmodule Day12Test do
  use ExUnit.Case

  test "part1" do
    input =
      """
      Sabqponm
      abcryxxl
      accszExk
      acctuvwj
      abdefghi
      """
      |> Day12.parse_input()

    assert Day12.part1(input) == 31
    assert Day12.part2(input) == 29
  end
end
