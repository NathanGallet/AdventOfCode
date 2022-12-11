defmodule Day11 do
  @moduledoc false
  def run do
    input =
      "./lib/inputs/day11.txt"
      |> File.read!()
      |> parse_input()

    IO.puts("Value of part1 : #{part1(input)}")
    IO.puts("Value of part2 : #{part2(input)}")
  end

  def parse_input(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.reduce(%{}, fn monkey_instruction, result ->
      [
        number,
        items,
        operation,
        test,
        success,
        error
      ] = String.split(monkey_instruction, "\n", trim: true)

      "Monkey " <> number = String.trim(number)
      "Starting items: " <> items = String.trim(items)
      "Operation: new = old " <> operation = String.trim(operation)
      "Test: divisible by " <> test = String.trim(test)
      "If true: throw to monkey " <> success = String.trim(success)
      "If false: throw to monkey " <> error = String.trim(error)

      number =
        number
        |> String.replace(":", "")
        |> String.to_integer()

      items =
        items
        |> String.split(",")
        |> Enum.map(fn item ->
          item
          |> String.trim()
          |> String.to_integer()
        end)

      test = String.to_integer(test)
      error = String.to_integer(error)
      success = String.to_integer(success)
      operation_fn = parse_operation(operation)

      Map.put(result, number, %{
        "items" => items,
        "operation" => operation_fn,
        "test" => test,
        "error" => error,
        "success" => success
      })
    end)
  end

  def part1(input) do
    result =
      input
      |> Map.keys()
      |> Enum.map(fn monkey_number ->
        {monkey_number, 0}
      end)
      |> Enum.into(%{})

    Enum.reduce(1..20, {input, result}, fn _round, {monkeys, result} ->
      Enum.reduce(monkeys, {monkeys, result}, fn {monkey_number, monkey}, {monkeys, result} ->
        result = %{
          result
          | monkey_number => result[monkey_number] + length(monkeys[monkey_number]["items"])
        }

        monkeys =
          monkeys[monkey_number]["items"]
          |> Enum.reduce(monkeys, fn item, acc ->
            worry_level = trunc(monkey["operation"].(item) / 3)

            to_monkey_number =
              case rem(worry_level, monkey["test"]) == 0 do
                true -> monkey["success"]
                false -> monkey["error"]
              end

            Map.put(acc, to_monkey_number, %{
              acc[to_monkey_number]
              | "items" => [worry_level | acc[to_monkey_number]["items"]]
            })
          end)
          |> Map.put(monkey_number, %{monkeys[monkey_number] | "items" => []})

        {monkeys, result}
      end)
    end)
    |> elem(1)
    |> Enum.map(fn {_monkey_number, result} ->
      result
    end)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> multiply
  end

  def part2(input) do
    mod =
      Enum.reduce(input, 1, fn {_, %{"test" => test_value}}, acc ->
        test_value * acc
      end)

    Enum.reduce(1..10000, {input, init_result(input)}, fn _round, {monkeys, result} ->
      Enum.reduce(monkeys, {monkeys, result}, fn {monkey_number, monkey}, {monkeys, result} ->
        result = %{
          result
          | monkey_number => result[monkey_number] + length(monkeys[monkey_number]["items"])
        }

        monkeys =
          monkeys[monkey_number]["items"]
          |> Enum.reduce(monkeys, fn item, acc ->
            worry_level = rem(monkey["operation"].(item), mod)

            to_monkey_number =
              case rem(worry_level, monkey["test"]) == 0 do
                true -> monkey["success"]
                false -> monkey["error"]
              end

            Map.put(acc, to_monkey_number, %{
              acc[to_monkey_number]
              | "items" => [worry_level | acc[to_monkey_number]["items"]]
            })
          end)
          |> Map.put(monkey_number, %{monkeys[monkey_number] | "items" => []})

        {monkeys, result}
      end)
    end)
    |> elem(1)
    |> Enum.map(fn {_monkey_number, result} ->
      result
    end)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> multiply
  end

  defp parse_operation(operation) do
    [symbole, value] = String.split(operation, " ")
    parse_operation(symbole, Integer.parse(value))
  end

  defp parse_operation("*", {value, ""}), do: fn v -> v * value end
  defp parse_operation("+", {value, ""}), do: fn v -> v + value end
  defp parse_operation("*", :error), do: fn v -> v * v end
  defp parse_operation("+", :error), do: fn v -> v + v end

  defp multiply(list) when is_list(list) do
    Enum.reduce(list, 1, fn elem, acc ->
      acc * elem
    end)
  end

  defp init_result(input) do
    input
    |> Map.keys()
    |> Enum.map(fn monkey_number ->
      {monkey_number, 0}
    end)
    |> Enum.into(%{})
  end
end
