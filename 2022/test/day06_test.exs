defmodule Day06Test do
  use ExUnit.Case

  test "day06" do
    assert Day06.part1("mjqjpqmgbljsphdztnvjfqwrcgsmlb") == 7
    assert Day06.part1("bvwbjplbgvbhsrlpgdmjqwftvncz") == 5
    assert Day06.part1("nppdvjthqldpwncqszvftbrmjlhg") == 6
    assert Day06.part1("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 10
    assert Day06.part1("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 11

    assert Day06.part2("mjqjpqmgbljsphdztnvjfqwrcgsmlb") == 19
    assert Day06.part2("bvwbjplbgvbhsrlpgdmjqwftvncz") == 23
    assert Day06.part2("nppdvjthqldpwncqszvftbrmjlhg") == 23
    assert Day06.part2("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 29
    assert Day06.part2("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 26
  end
end
