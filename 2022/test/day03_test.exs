defmodule Day03Test do
  use ExUnit.Case

  test "day03" do
    input =
      """
      vJrwpWtwJgWrhcsFMMfFFhFp
      jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
      PmmdzqPrVvPwwTWBwg
      wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
      ttgJtRGJQctTZtZT
      CrZsJsPPZsGzwwsLwLmpwMDw
      """
      |> Day03.parse_input()

    assert Day03.part1(input) == 157
    assert Day03.part2(input) == 70
  end
end
