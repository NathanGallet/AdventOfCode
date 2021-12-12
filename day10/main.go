package main

import (
	"adventOfCode/utils"
	"fmt"
	"sort"
)

var (
	match = map[rune]rune{
		')': '(',
		']': '[',
		'}': '{',
		'>': '<',
	}

	points = map[rune]int{
		')': 3,
		']': 57,
		'}': 1197,
		'>': 25137,
	}
	pointsUncorrupted = map[rune]int{
		'(': 1,
		'[': 2,
		'{': 3,
		'<': 4,
	}
)

func main() {
	inputs := utils.ParseInputAsString()
	fmt.Println("Result day 10 part 1: ", Part1(inputs))
	fmt.Println("Result day 10 part 2: ", Part2(inputs))
}

func Part1(lines []string) int {
	var score int
	for _, line := range lines {
		var stack []rune
		var last rune
		for _, char := range line {

			if isOpeningDelimiter(char) {
				stack = append(stack, char)
			}

			if isClosingDelimiter(char) {
				last = stack[len(stack)-1]
				stack = stack[:len(stack)-1]

				if last != match[char] {
					score += points[char]
				}
			}
		}
	}

	return score
}

func Part2(lines []string) int {
	var isCorrupted bool
	var scores []int
	for _, line := range lines {
		isCorrupted = false
		var stack []rune
		var last rune
		for _, char := range line {
			if isOpeningDelimiter(char) {
				stack = append(stack, char)
			}

			if isClosingDelimiter(char) {
				last = stack[len(stack)-1]
				stack = stack[:len(stack)-1]

				if last != match[char] {
					isCorrupted = true
					break
				}
			}
		}

		if !isCorrupted {
			scores = append(scores, calculateScore(stack))
		}
	}

	sort.Ints(scores)

	return scores[len(scores)/2]
}

func calculateScore(stack []rune) int {
	var score int
	for i := len(stack) - 1; i >= 0; i-- {
		score = score * 5
		score += pointsUncorrupted[stack[i]]
	}

	return score

}

func isOpeningDelimiter(char rune) bool {
	var openingDelimiter []rune = []rune{
		'(',
		'[',
		'{',
		'<',
	}
	for _, opening := range openingDelimiter {
		if opening == char {
			return true
		}
	}
	return false
}

func isClosingDelimiter(char rune) bool {
	var closingDelimiter []rune = []rune{
		')',
		']',
		'}',
		'>',
	}
	for _, closing := range closingDelimiter {
		if closing == char {
			return true
		}
	}
	return false
}
