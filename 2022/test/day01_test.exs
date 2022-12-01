defmodule Day01Test do
  use ExUnit.Case

  test "day01-part1" do
    input =
      """
      1000
      2000
      3000

      4000

      5000
      6000

      7000
      8000
      9000

      10000
      """
      |> Day01.parse_input()

    assert Day01.part1(input) == 24000
    assert Day01.part2(input) == 45000
  end
end
