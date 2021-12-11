package main

import (
	"adventOfCode/utils"
	"fmt"
	"sort"
	"strconv"
	"strings"
)

type LowPoint struct {
	Value       int
	IndexLine   int
	IndexColumn int
}

func main() {
	var initialState [][]int
	for _, input := range utils.ParseInputAsString() {

		var line []int
		for _, l := range strings.Split(input, "") {
			value, _ := strconv.Atoi(l)
			line = append(line, value)
		}
		initialState = append(initialState, line)
	}
	fmt.Println("Result day 9 part 1: ", Part1(initialState))
	fmt.Println("Result day 9 part 2: ", Part2(initialState))
}

func Part1(inputs [][]int) int {
	count, _ := FindLowPoint(inputs)
	return count
}

func Part2(inputs [][]int) int {
	var bassinSize []int
	_, listPoints := FindLowPoint(inputs)
	for _, point := range listPoints {
		bassin := FindBassin(point, inputs, []LowPoint{})
		bassinSize = append(bassinSize, len(bassin))
	}
	sort.Ints(bassinSize)
	l := len(bassinSize)
	return bassinSize[l-1] * bassinSize[l-2] * bassinSize[l-3]
}

func printMap(inputs [][]int) {
	for _, line := range inputs {
		fmt.Println(line)
	}
}

func FindBassin(point LowPoint, heightmap [][]int, bassin []LowPoint) []LowPoint {
	if ContainsPoints(bassin, point) {
		return bassin
	}

	if point.Value < 9 {
		bassin = AddBassin(point, bassin)
	}

	// check right
	if point.IndexColumn != len(heightmap[point.IndexLine])-1 {
		for i := point.IndexColumn; i < len(heightmap[point.IndexLine]); i++ {
			if heightmap[point.IndexLine][i] == 9 {
				break
			}

			bassin = AddBassin(LowPoint{
				Value:       heightmap[point.IndexLine][i],
				IndexLine:   point.IndexLine,
				IndexColumn: i,
			}, bassin)

			if point.IndexLine > 0 && heightmap[point.IndexLine-1][i] < 9 {
				bassin = FindBassin(LowPoint{
					Value:       heightmap[point.IndexLine-1][i],
					IndexLine:   point.IndexLine - 1,
					IndexColumn: i,
				}, heightmap, bassin)
			}

			if point.IndexLine < len(heightmap)-1 && heightmap[point.IndexLine+1][i] < 9 {
				bassin = FindBassin(LowPoint{
					Value:       heightmap[point.IndexLine+1][i],
					IndexLine:   point.IndexLine + 1,
					IndexColumn: i,
				}, heightmap, bassin)
			}
		}
	}

	// check left
	if point.IndexColumn != 0 {
		for i := point.IndexColumn; i >= 0; i-- {
			if heightmap[point.IndexLine][i] == 9 {
				break
			}

			bassin = AddBassin(LowPoint{
				Value:       heightmap[point.IndexLine][i],
				IndexLine:   point.IndexLine,
				IndexColumn: i,
			}, bassin)

			if point.IndexLine > 0 && heightmap[point.IndexLine-1][i] < 9 {
				bassin = FindBassin(LowPoint{
					Value:       heightmap[point.IndexLine-1][i],
					IndexLine:   point.IndexLine - 1,
					IndexColumn: i,
				}, heightmap, bassin)
			}

			if point.IndexLine < len(heightmap)-1 && heightmap[point.IndexLine+1][i] < 9 {
				bassin = FindBassin(LowPoint{
					Value:       heightmap[point.IndexLine+1][i],
					IndexLine:   point.IndexLine + 1,
					IndexColumn: i,
				}, heightmap, bassin)
			}
		}
	}

	return bassin
}

func AddBassin(point LowPoint, bassin []LowPoint) []LowPoint {
	if ContainsPoints(bassin, point) {
		return bassin
	}

	return append(bassin, point)
}

func FindLowPoint(heightmap [][]int) (int, []LowPoint) {
	var count int
	var lowPoints []LowPoint
	for indexLine, line := range heightmap {
		for indexColumn, element := range line {
			var isLeftInf, isRightInf, isTopInf, isBottomInf bool

			if indexLine == 0 {
				isTopInf = true
			}
			if indexLine == len(heightmap)-1 {
				isBottomInf = true
			}
			if indexColumn == 0 {
				isLeftInf = true
			}
			if indexColumn == len(line)-1 {
				isRightInf = true
			}

			if !isLeftInf {
				isLeftInf = line[indexColumn-1] > element
			}

			if !isRightInf {
				isRightInf = line[indexColumn+1] > element
			}

			if !isTopInf {
				isTopInf = heightmap[indexLine-1][indexColumn] > element
			}

			if !isBottomInf {
				isBottomInf = heightmap[indexLine+1][indexColumn] > element
			}

			if isLeftInf && isRightInf && isTopInf && isBottomInf {
				lowPoints = append(lowPoints, LowPoint{
					Value:       element,
					IndexLine:   indexLine,
					IndexColumn: indexColumn,
				})
				count += 1
				count += element
			}
		}
	}

	return count, lowPoints
}

func AreEqualPoints(a, b LowPoint) bool {
	return a.Value == b.Value && a.IndexColumn == b.IndexColumn && a.IndexLine == b.IndexLine
}

func ContainsPoints(s []LowPoint, e LowPoint) bool {
	for _, a := range s {
		if AreEqualPoints(a, e) {
			return true
		}
	}
	return false
}
