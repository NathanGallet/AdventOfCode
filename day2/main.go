package main

import (
	"adventOfCode/utils"
	"fmt"
	"strconv"
	"strings"
)

func main() {
	inputs := utils.ParseInputAsString()
	fmt.Println("Result day 2 part 1: ", Part1(inputs))
	fmt.Println("Result day 2 part 2: ", Part2(inputs))
}

func Part1(inputs []string) int {
	var horizontal, depth int
	for _, instruction := range inputs {
		direction, value := convertStringAndInt(instruction)
		switch direction {
		case "forward":
			horizontal += value
		case "down":
			depth += value
		case "up":
			depth -= value
		}
	}

	return horizontal * depth
}

func Part2(inputs []string) int {
	var horizontal, aim, depth int
	for _, instruction := range inputs {
		direction, value := convertStringAndInt(instruction)
		switch direction {
		case "forward":
			horizontal += value
			depth += aim * value
		case "down":
			aim += value
		case "up":
			aim -= value
		}
	}

	return horizontal * depth
}

func convertStringAndInt(line string) (string, int) {
	instructions := strings.Split(line, " ")
	if len(instructions) != 2 {
		panic("Array should be bigger")
	}

	direction := instructions[0]
	valueStr := instructions[1]

	value, err := strconv.Atoi(valueStr)
	if err != nil {
		panic(fmt.Sprintf("Can't convert string %s to int %s", line, err.Error()))
	}

	return direction, value
}
