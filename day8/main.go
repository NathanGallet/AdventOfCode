package main

import (
	"adventOfCode/utils"
	"fmt"
	"sort"
	"strconv"
	"strings"
)

func main() {
	inputs := utils.ParseInputAsString()
	fmt.Println("Result day 8 part 1: ", Part1(inputs))
	fmt.Println("Result day 8 part 2: ", Part2(inputs))
}

func Part1(inputs []string) int {
	var count int
	var numbers Numbers
	for _, line := range inputs {
		_, outputs := getCombinaison(line)
		lineCount := numbers.parseSimpleOutputs(outputs)
		count += lineCount
	}

	return count
}

func Part2(inputs []string) int {
	var count int
	for _, line := range inputs {
		var numbers = &Numbers{}
		signalPattern, outputs := getCombinaison(line)
		numbers.parseSimpleOutputs(outputs)
		numbers.parseSimpleOutputs(signalPattern)
		numbers.GuessOneFourSevenHeight()
		numbers.FindNumbers(signalPattern, outputs)
		count += numbers.NumberOutput(outputs)
	}

	return count
}

func getCombinaison(line string) ([]string, []string) {
	splitLine := strings.Split(line, "|")
	return strings.Split(strings.TrimSpace(splitLine[0]), " "),
		strings.Split(strings.TrimSpace(splitLine[1]), " ")
}

// One		-> 2 digits turned on cc - ff
// Four		-> 4 digits turned on bb - cc - dddd - ff
// Seven	-> 3 digits turned on aaaa - cc - ff
// Height	-> 7 digits turned on aaaa - bb - cc - dddd - ee - ff - gggg

// Zero		-> 6 digits turned on aaaa - bb - cc - ee - ff - gggg
// Six		-> 6 digits turned on aaaa - bb - dddd - ee - ff - gggg
// Nine		-> 6 digits turned on aaaa - bb - cc - dddd - ff - gggg

// Two		-> 5 digits turned on aaaa - cc - dddd - ee - gggg
// Three	-> 5 digits turned on aaaa - cc - dddd - ff - gggg
// Five		-> 5 digits turned on aaaa - bb - dddd - ff - gggg
type Numbers struct {
	Zero        []string
	One         []string
	Two         []string
	Three       []string
	Four        []string
	Five        []string
	Six         []string
	Seven       []string
	Height      []string
	Nine        []string
	Top         string
	TopRight    string
	TopLeft     string
	Middle      string
	Bottom      string
	BottomRight string
	BottomLeft  string
}

func (n *Numbers) GuessOneFourSevenHeight() {
	for _, segmentSeven := range n.Seven {
		if !utils.ContainsString(n.One, segmentSeven) {
			n.Top = segmentSeven
		}
	}

	for _, segmentNine := range n.Nine {
		if !utils.ContainsString(append(n.Four, n.Top), segmentNine) {
			n.Bottom = segmentNine
		}
	}

}

func (n *Numbers) parseSimpleOutputs(outputs []string) int {
	var count int
	for _, output := range outputs {
		l := len(output)
		if l == 2 {
			n.One = strings.Split(output, "")
			sort.Strings(n.One)
			count += 1
		}

		if l == 4 {
			n.Four = strings.Split(output, "")
			sort.Strings(n.Four)
			count += 1
		}

		if l == 3 {
			n.Seven = strings.Split(output, "")
			sort.Strings(n.Seven)
			count += 1
		}

		if l == 7 {
			n.Height = strings.Split(output, "")
			sort.Strings(n.Height)
			count += 1
		}
	}

	return count
}

func (n *Numbers) FindNumbers(signalPatterns, outputs []string) {
	// Parse informations
	var zeroSixNineStr []string
	var twoThreeFiveStr []string
	for _, signalPattern := range signalPatterns {
		if len(signalPattern) == 6 {
			zeroSixNineStr = append(zeroSixNineStr, signalPattern)
		}

		if len(signalPattern) == 5 {
			twoThreeFiveStr = append(twoThreeFiveStr, signalPattern)
		}
	}

	for _, output := range outputs {
		if len(output) == 6 {
			zeroSixNineStr = append(zeroSixNineStr, output)
		}

		if len(output) == 5 {
			twoThreeFiveStr = append(twoThreeFiveStr, output)
		}
	}

	// Guess from zero six nine
	var zeroSixNines [][]string
	var missingZeroSixNineSegment []string

	for _, number := range zeroSixNineStr {
		numbers := strings.Split(number, "")
		sort.Strings(numbers)
		zeroSixNines = append(zeroSixNines, numbers)
	}

	for _, segments := range zeroSixNines {
		for _, segmentHeight := range n.Height {
			if !utils.ContainsString(segments, segmentHeight) && !utils.ContainsString(missingZeroSixNineSegment, segmentHeight) {
				missingZeroSixNineSegment = append(missingZeroSixNineSegment, segmentHeight)
			}
		}
	}

	for _, missingSegment := range missingZeroSixNineSegment {
		if !utils.ContainsString(n.Four, missingSegment) {
			n.BottomLeft = missingSegment
		}
	}

	for _, missingSegment := range missingZeroSixNineSegment {
		if missingSegment == n.BottomLeft {
			continue
		}

		if !utils.ContainsString(n.One, missingSegment) {
			n.Middle = missingSegment
		} else {
			n.TopRight = missingSegment
		}
	}

	for _, zeroSixNine := range zeroSixNines {
		if !utils.ContainsString(zeroSixNine, n.Middle) {
			sort.Strings(zeroSixNine)
			n.Zero = zeroSixNine
		}

		if !utils.ContainsString(zeroSixNine, n.BottomLeft) {
			sort.Strings(zeroSixNine)
			n.Nine = zeroSixNine
		}

		if !utils.ContainsString(zeroSixNine, n.TopRight) {
			sort.Strings(zeroSixNine)
			n.Six = zeroSixNine
		}
	}

	// Guess from zero six nine
	var twoThreeFives [][]string

	for _, number := range twoThreeFiveStr {
		numbers := strings.Split(number, "")
		sort.Strings(numbers)
		twoThreeFives = append(twoThreeFives, numbers)
	}

	for _, segments := range twoThreeFives {
		if !utils.ContainsString(segments, n.TopRight) && !utils.ContainsString(segments, n.BottomLeft) {
			sort.Strings(segments)
			n.Five = segments
			continue
		}

		if !utils.ContainsString(segments, n.BottomLeft) {
			sort.Strings(segments)
			n.Three = segments
			continue
		}

		sort.Strings(segments)
		n.Two = segments
	}
}
func (n *Numbers) NumberOutput(outputs []string) int {
	var outputStr string
	for _, output := range outputs {
		numbers := strings.Split(output, "")
		sort.Strings(numbers)
		if utils.EqualsStringsSlice(numbers, n.Zero) {
			outputStr = fmt.Sprintf("%s%d", outputStr, 0)
		}
		if utils.EqualsStringsSlice(numbers, n.One) {
			outputStr = fmt.Sprintf("%s%d", outputStr, 1)
		}
		if utils.EqualsStringsSlice(numbers, n.Two) {
			outputStr = fmt.Sprintf("%s%d", outputStr, 2)
		}
		if utils.EqualsStringsSlice(numbers, n.Three) {
			outputStr = fmt.Sprintf("%s%d", outputStr, 3)
		}
		if utils.EqualsStringsSlice(numbers, n.Four) {
			outputStr = fmt.Sprintf("%s%d", outputStr, 4)
		}
		if utils.EqualsStringsSlice(numbers, n.Five) {
			outputStr = fmt.Sprintf("%s%d", outputStr, 5)
		}
		if utils.EqualsStringsSlice(numbers, n.Six) {
			outputStr = fmt.Sprintf("%s%d", outputStr, 6)
		}
		if utils.EqualsStringsSlice(numbers, n.Seven) {
			outputStr = fmt.Sprintf("%s%d", outputStr, 7)
		}
		if utils.EqualsStringsSlice(numbers, n.Height) {
			outputStr = fmt.Sprintf("%s%d", outputStr, 8)
		}
		if utils.EqualsStringsSlice(numbers, n.Nine) {
			outputStr = fmt.Sprintf("%s%d", outputStr, 9)
		}
	}
	v, _ := strconv.Atoi(outputStr)

	return v
}
