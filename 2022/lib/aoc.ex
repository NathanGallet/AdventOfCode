defmodule Aoc do
  @moduledoc false

  def read_input_as_list_of_integer!(day_number) do
    "./lib/inputs/#{day_number}.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
