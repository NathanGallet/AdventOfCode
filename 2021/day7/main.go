package main

import (
	"adventOfCode/utils"
	"fmt"
	"sort"
	"strconv"
	"strings"
)

func main() {
	var initialStats []int
	inputs := strings.Split(utils.ParseInputAsString()[0], ",")
	for _, input := range inputs {
		num, _ := strconv.Atoi(input)
		initialStats = append(initialStats, num)
	}
	fmt.Println("Result day 6 part 1: ", Part1(initialStats))
	fmt.Println("Result day 6 part 2: ", Part2(initialStats))
}

func Part1(inputs []int) int {
	median := median(inputs)
	return linearFuelCount(inputs, median)
}

func Part2(inputs []int) int {
	var count *int

	min, max := minMax(inputs)
	for i := min; i <= max; i++ {
		value := crabsFuelCount(inputs, i)
		if count == nil || value < *count {
			count = &value
		}
	}
	return *count
}

func linearFuelCount(numbers []int, median int) int {
	var count int
	for _, number := range numbers {
		count += abs(number, median)
	}

	return count
}

func crabsFuelCount(numbers []int, value int) int {
	var count int
	for _, number := range numbers {
		count += fuel(number, value)
	}

	return count
}

func median(numbers []int) int {
	sort.Ints(numbers)
	numberOfValue := len(numbers) / 2

	if numberOfValue%2 == 0 {
		return numbers[numberOfValue]
	}

	return (numbers[numberOfValue-1] + numbers[numberOfValue]) / 2
}

func mean(numbers []int) int {
	var sum int
	for _, number := range numbers {
		sum += number
	}

	return sum / 2
}

func abs(a, b int) int {
	value := a - b
	if value < 0 {
		return -value
	}
	return value
}

func fuel(a, b int) int {
	value := abs(a, b)
	return value * (value + 1) / 2
}

func minMax(numbers []int) (int, int) {
	sort.Ints(numbers)
	return numbers[0], numbers[len(numbers)-1]
}
