defmodule Day07 do
  @moduledoc false

  def run do
    input =
      "./lib/inputs/day07.txt"
      |> File.read!()
      |> parse_input()

    IO.puts("Value of part1 : #{part1(input)}")
    IO.puts("Value of part2 : #{part2(input)}")
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reject(fn instruction -> instruction == "$ ls" end)
    |> Enum.reduce({%{}, []}, fn instruction, {tree, path} ->
      [head | tail] = String.split(instruction)

      cond do
        head == "$" ->
          ["cd", directory] = tail
          move(directory, tree, path)

        head == "dir" ->
          [directory_name] = tail
          {add_directory(tree, Enum.reverse(path), directory_name), path}

        true ->
          {head
           |> String.to_integer()
           |> add_file(Enum.reverse(path), tree), path}
      end
    end)
    |> elem(0)
  end

  defp move("..", tree, [_head | path]), do: {tree, path}

  defp move(directory, _tree, []), do: {%{"/" => %{}}, [directory]}

  defp move(directory, tree, path) do
    case directory in Map.keys(get_in(tree, Enum.reverse(path))) do
      true -> {tree, [directory | path]}
      false -> {add_directory(tree, Enum.reverse(path), directory), [directory | path]}
    end
  end

  defp add_directory(tree, path, key),
    do: put_in(tree, path, Map.merge(get_in(tree, path), %{key => %{}}))

  defp add_file(value, path, tree) do
    case "values" in Map.keys(get_in(tree, path)) do
      true ->
        path = Enum.concat(path, ["values"])
        put_in(tree, path, [value | get_in(tree, path)])

      false ->
        put_in(tree, path, %{"values" => [value]})
    end
  end

  def part1(input) do
    input["/"]
    |> find_all_directory_size([])
    |> elem(1)
    |> Enum.reduce([], fn value, result ->
      case value < 100_000 do
        true -> [value | result]
        false -> result
      end
    end)
    |> Enum.sum()
  end

  def part2(input) do
    [disk_used | disk] =
      input["/"]
      |> find_all_directory_size([])
      |> elem(1)
      |> Enum.sort(:desc)

    unused = 70_000_000 - disk_used

    disk
    |> Enum.reverse()
    |> Enum.find(fn value ->
      unused + value > 30_000_000
    end)
  end

  defp find_all_directory_size(tree, result) do
    initial_size =
      case tree["values"] == nil do
        true -> 0
        false -> Enum.sum(tree["values"])
      end

    {directory_size, result} =
      tree
      |> Map.delete("values")
      |> Enum.reduce({initial_size, result}, fn {_name, child}, {directory_size, result} ->
        {children_size, result} = find_all_directory_size(child, result)
        {directory_size + children_size, result}
      end)

    {directory_size, [directory_size | result]}
  end
end
