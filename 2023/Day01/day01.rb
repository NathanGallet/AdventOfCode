# frozen_string_literal: true

class Day01
  def initialize(path)
    @input = File.read(path)
  end

  def part1
    @input
      .split("\n\n")
      .map { |elems| elems.split("\n").map(&:to_i).sum }
      .max
  end

  def part2
    @input
      .split("\n\n")
      .map { |elems| elems.split("\n").map(&:to_i).sum }
      .sort
      .reverse
      .take(3)
      .sum
  end
end
