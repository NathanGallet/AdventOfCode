package main

import (
	"adventOfCode/utils"
	"fmt"
)

func main() {
	inputs := utils.ParseInputAsInt()
	fmt.Println("Result day 1 part 1: ", Part1(inputs))
	fmt.Println("Result day 2 part 2: ", Part2(inputs))
}

func Part1(inputs []int) int {
	var result int
	for index, input := range inputs {
		if index == 0 {
			continue
		}

		if input > inputs[index-1] {
			result += 1
		}
	}

	return result
}

func Part2(inputs []int) int {
	var result int
	var index int = 1

	for index <= len(inputs)-3 {
		if windowSum(index, inputs) > windowSum(index-1, inputs) {
			result += 1
		}
		index += 1
	}

	return result
}

func windowSum(index int, inputs []int) int {
	return inputs[index] + inputs[index+1] + inputs[index+2]
}
