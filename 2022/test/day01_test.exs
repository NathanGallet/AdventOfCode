defmodule Day01Test do
  use ExUnit.Case

  test "day01-part1" do
    input = [
      199,
      200,
      208,
      210,
      200,
      207,
      240,
      269,
      260,
      263
    ]

    assert Day01.part1(input) == 7
  end
end
