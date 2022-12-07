defmodule Day07Test do
  use ExUnit.Case

  test "day07" do
    input =
      """
      $ cd /
      $ ls
      dir a
      14848514 b.txt
      8504156 c.dat
      dir d
      $ cd a
      $ ls
      dir e
      29116 f
      2557 g
      62596 h.lst
      $ cd e
      $ ls
      584 i
      $ cd ..
      $ cd ..
      $ cd d
      $ ls
      4060174 j
      8033020 d.log
      5626152 d.ext
      7214296 k
      """
      |> Day07.parse_input()

    # assert Day07.part1(input) == 95437
    assert Day07.part2(input) == 24_933_642
  end
end
