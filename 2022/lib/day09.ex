defmodule Day09 do
  @moduledoc false
  def run do
    input =
      "./lib/inputs/day09.txt"
      |> File.read!()
      |> parse_input()

    IO.puts("Value of part1 : #{part1(input)}")
    IO.puts("Value of part2 : #{part2(input)}")
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn <<direction, " ", step::binary>> ->
      add_coord =
        case direction do
          ?U -> {0, 1}
          ?D -> {0, -1}
          ?R -> {1, 0}
          ?L -> {-1, 0}
        end

      {add_coord, String.to_integer(step)}
    end)
  end

  def part1(input) do
    rope = List.duplicate({0, 0}, 2)
    result = MapSet.put(MapSet.new(), {0, 0})

    input
    |> Enum.reduce({rope, result}, fn instruction, {position, result} ->
      move({position, result}, instruction)
    end)
    |> elem(1)
    |> MapSet.to_list()
    |> Enum.count()
  end

  def part2(input) do
    rope = List.duplicate({0, 0}, 10)
    result = MapSet.put(MapSet.new(), {0, 0})

    input
    |> Enum.reduce({rope, result}, fn instruction, {position, result} ->
      move({position, result}, instruction)
    end)
    |> elem(1)
    |> MapSet.to_list()
    |> Enum.count()
  end

  defp move({position, result}, {_add_coord, 0}), do: {position, result}

  defp move({[{head_x, head_y} | tail], result}, {{add_x, add_y} = add_coord, step}) do
    [{head_x + add_x, head_y + add_y} | tail]
    |> update_tail(result)
    |> move({add_coord, step - 1})
  end

  defp update_tail([head | tail], result) do
    positions =
      Enum.reduce(tail, [head], fn node, result ->
        [update_tail(hd(result), node) | result]
      end)

    [tail_position | _rest] = positions

    {Enum.reverse(positions), MapSet.put(result, tail_position)}
  end

  defp update_tail({hx, hy}, {tx, ty}) do
    dx = hx - tx
    dy = hy - ty

    cond do
      abs(dx) <= 1 and abs(dy) <= 1 ->
        {tx, ty}

      abs(dx) >= 2 and abs(dy) >= 2 ->
        {if(tx < hx, do: hx - 1, else: hx + 1), if(ty < hy, do: hy - 1, else: hy + 1)}

      abs(dx) >= 2 ->
        {if(tx < hx, do: hx - 1, else: hx + 1), hy}

      abs(dy) >= 2 ->
        {hx, if(ty < hy, do: hy - 1, else: hy + 1)}
    end
  end
end
