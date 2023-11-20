# frozen_string_literal: true

require './Day01/day01'

INPUT_PATH = './Day01/part1.txt'

RSpec.describe Day01 do
  it 'part1' do
    d = Day01.new(INPUT_PATH)
    expect(d.part1).to eq(24_000)
  end

  it 'part2' do
    d = Day01.new(INPUT_PATH)
    expect(d.part2).to eq(45_000)
  end
end
