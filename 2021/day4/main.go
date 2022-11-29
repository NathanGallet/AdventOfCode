package main

import (
	"adventOfCode/utils"
	"fmt"
	"strconv"
	"strings"
)

const LINES = 5
const COLUMNS = 5

type Grid struct {
	Columns [LINES][COLUMNS]int
	Rows    [LINES][COLUMNS]int
}

func main() {
	inputs := utils.ParseInputAsString()
	fmt.Println("Result day 4 part 1: ", Part1(inputs))
	fmt.Println("Result day 4 part 2: ", Part2(inputs))
}

func Part1(inputs []string) int {
	numbers, grids := GameGeneration(inputs)
	for i := 5; i < len(numbers); i++ {
		sum, isFinished := RunGamePart1(numbers[:i], grids)

		if isFinished {
			return sum * numbers[i-1]
		}
	}
	return 0
}

func Part2(inputs []string) int {
	numbers, grids := GameGeneration(inputs)
	for i := 5; i < len(numbers); i++ {
		grids := RunGamePart2(numbers[:i], grids)

		if len(grids) == 1 {
			return countUnmarkedNumber(numbers[:i+1], grids[0]) * numbers[i]
		}
	}
	return 0
}

func RunGamePart1(numbers []int, grids []Grid) (int, bool) {
	for _, grid := range grids {
		for _, column := range grid.Columns {
			if contains(numbers, column) {
				return countUnmarkedNumber(numbers, grid), true
			}
		}

		for _, row := range grid.Rows {
			if contains(numbers, row) {
				return countUnmarkedNumber(numbers, grid), true
			}
		}
	}

	return 0, false
}

func RunGamePart2(numbers []int, grids []Grid) []Grid {
	var newGrid []Grid
	for _, grid := range grids {
		if columnContainBingo(grid.Columns, numbers) || columnContainBingo(grid.Rows, numbers) {
			continue
		}
		newGrid = append(newGrid, grid)
	}

	return newGrid
}

func columnContainBingo(rowOrColumn [LINES][COLUMNS]int, numbers []int) bool {
	for _, value := range rowOrColumn {
		if contains(numbers, value) {
			return true
		}
	}

	return false
}

func countUnmarkedNumber(numbers []int, grid Grid) int {
	var sum int
	for _, row := range grid.Rows {
		for _, rowValue := range row {
			if !isContain(numbers, rowValue) {
				sum += rowValue
			}
		}
	}

	return sum
}

func isContain(numbers []int, value int) bool {
	for _, number := range numbers {
		if number == value {
			return true
		}
	}

	return false
}
func contains(numbers []int, values [5]int) bool {
	var isValueContained bool = false
	for _, value := range values {
		isValueContained = false

		for _, number := range numbers {
			if value == number || isValueContained {
				isValueContained = true
				continue
			}
		}

		if !isValueContained {
			return false
		}
	}

	return true
}

func GameGeneration(inputs []string) ([]int, []Grid) {
	var numbers []int
	var grids []Grid
	var grid Grid

	numbersStr := strings.Split(inputs[0], ",")

	for _, numberStr := range numbersStr {
		number, _ := strconv.Atoi(numberStr)
		numbers = append(numbers, number)
	}

	var columnIndex int
	for index, input := range inputs {

		if index == 0 || index == 1 {
			continue
		}

		if input == "" {
			grids = append(grids, grid)
			grid = Grid{}
			columnIndex = 0
			continue
		}

		uncleanValuesStr := strings.Split(strings.TrimSpace(input), " ")

		var rows [LINES]int
		var rowIndex int

		for _, uncleanValueStr := range uncleanValuesStr {
			if uncleanValueStr == "" {
				continue
			}

			rowNumber, _ := strconv.Atoi(uncleanValueStr)
			rows[rowIndex] = rowNumber

			grid.Columns[rowIndex][columnIndex] = rowNumber
			rowIndex += 1
		}
		grid.Rows[columnIndex] = rows

		columnIndex += 1
		if index == len(inputs)-1 {
			grids = append(grids, grid)
		}
	}

	return numbers, grids
}
