package main

import (
	"adventOfCode/utils"
	"fmt"
	"strconv"
	"strings"
)

type Cavern [][]int
type OctopusFlashed []Octopus
type Octopus struct {
	x int
	y int
}

func main() {
	var part1, part2 [][]int
	for _, input := range utils.ParseInputAsString() {
		var line1, line2 []int
		for _, l := range strings.Split(input, "") {
			value, _ := strconv.Atoi(l)
			line1 = append(line1, value)
			line2 = append(line2, value)
		}
		part1 = append(part1, line1)
		part2 = append(part2, line2)
	}
	fmt.Println("Result day 11 part 1: ", Part1(part1))
	fmt.Println("Result day 11 part 2: ", Part2(part2))
}

func Part1(input [][]int) int {
	var countFlash int
	var octopuses OctopusFlashed
	cavern := input

	for step := 0; step < 100; step++ {
		cavern, octopuses = UpdateCavern(AddOneToAll(cavern), octopuses, step)
		countFlash += len(octopuses)
		cavern, octopuses = UpdateOctopus(cavern, octopuses)
	}
	return countFlash
}

func Part2(cavern [][]int) int {
	var octopuses OctopusFlashed
	var cavernlength, step int
	cavernlength = len(cavern) * len(cavern[0])

	for {

		cavern, octopuses = UpdateCavern(AddOneToAll(cavern), octopuses, step)
		if len(octopuses) == cavernlength {
			step += 1
			break
		}

		cavern, octopuses = UpdateOctopus(cavern, octopuses)

		step += 1
	}

	return step
}

func AddOneToAll(cavern Cavern) Cavern {
	for i := 0; i < len(cavern); i++ {
		for j := 0; j < len(cavern[i]); j++ {
			cavern[i][j] += 1
		}
	}

	return cavern
}

func printCavern(cavern Cavern) {
	for _, line := range cavern {
		fmt.Println(line)
	}
	fmt.Print("\n\n")
}

func equalsCavern(cavernA, cavernB Cavern) bool {
	for i := 0; i < len(cavernA); i++ {
		for j := 0; j < len(cavernA[i]); j++ {
			if cavernA[i][j] != cavernB[i][j] {
				printCavern(cavernA)
				printCavern(cavernB)
				return false
			}

		}
	}

	return true
}

func UpdateOctopus(cavern Cavern, octopuses OctopusFlashed) (Cavern, OctopusFlashed) {
	for _, ococtopus := range octopuses {
		cavern[ococtopus.x][ococtopus.y] = 0
	}
	return cavern, OctopusFlashed{}
}

func UpdateCavern(cavern Cavern, octopuses OctopusFlashed, step int) (Cavern, OctopusFlashed) {
	var shouldUpdate bool

	for i := 0; i < len(cavern); i++ {
		for j := 0; j < len(cavern[i]); j++ {
			if cavern[i][j] <= 9 {
				continue
			}

			var octopusAlreadyFlash bool = false
			for _, ococtopus := range octopuses {
				if ococtopus.x == i && ococtopus.y == j {
					octopusAlreadyFlash = true
					break
				}
			}

			if octopusAlreadyFlash {
				continue
			}

			octopuses = append(octopuses, Octopus{
				x: i,
				y: j,
			})
			cavern = spreadFlash(cavern, i, j)
			shouldUpdate = true
		}
	}

	if shouldUpdate {
		return UpdateCavern(cavern, octopuses, step)
	}

	return cavern, octopuses
}

func spreadFlash(cavern Cavern, i, j int) Cavern {
	if i+1 <= len(cavern)-1 {
		cavern[i+1][j] += 1
		if j > 0 {
			cavern[i+1][j-1] += 1
		}
		if j < len(cavern[i+1])-1 {
			cavern[i+1][j+1] += 1
		}
	}

	if j > 0 {
		cavern[i][j-1] += 1
	}

	if j < len(cavern[i])-1 {
		cavern[i][j+1] += 1
	}

	if i > 0 {
		cavern[i-1][j] += 1
		if j > 0 {
			cavern[i-1][j-1] += 1
		}
		if j < len(cavern[i])-1 {
			cavern[i-1][j+1] += 1
		}
	}

	return cavern
}
