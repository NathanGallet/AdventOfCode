package main

import (
	"adventOfCode/utils"
	"fmt"
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
	var fishes []*Fish
	for _, internalTimer := range inputs {
		fishes = newFish(internalTimer, fishes, 1)
	}

	for day := 0; day < 80; day++ {

		var newFishCount int
		for _, fish := range fishes {
			count := fish.newDay()
			if count != nil {
				newFishCount += *count
			}

		}
		fishes = update(fishes, newFishCount, day)
	}

	return countFish(fishes)
}

func Part2(inputs []int) int {
	var fishes []*Fish
	for _, internalTimer := range inputs {
		fishes = newFish(internalTimer, fishes, 1)
	}

	for day := 0; day < 256; day++ {
		var newFishCount int
		for _, fish := range fishes {
			count := fish.newDay()
			if count != nil {
				newFishCount += *count
			}

		}
		fishes = update(fishes, newFishCount, day)
	}

	return countFish(fishes)
}

type Fish struct {
	internalTimer int
	numberFish    int
}

func printFishes(day int, fishes []*Fish) {
	fmt.Print("\n=====PRINT FISHES=====\n\n")
	for _, fish := range fishes {
		fmt.Printf("Detail: internalTimer \t%v \tnumberFish \t%v\n", fish.internalTimer, fish.numberFish)
	}
}

func update(fishes []*Fish, count, day int) []*Fish {
	var updatedFishes []*Fish
	if count == 0 {
		return fishes
	}

	for _, fish := range fishes {
		if fish.internalTimer < 0 {
			updatedFishes = newFish(6, updatedFishes, fish.numberFish)
		} else {
			updatedFishes = newFish(fish.internalTimer, updatedFishes, fish.numberFish)
		}
	}

	return newFish(8, updatedFishes, count)
}

func countFish(fishes []*Fish) int {
	var count int
	for _, fish := range fishes {
		count += fish.numberFish
	}

	return count
}

func newFish(internalTimer int, fishes []*Fish, value int) []*Fish {
	var foundFish bool
	for _, fish := range fishes {
		if foundFish {
			continue
		}

		if fish.internalTimer == internalTimer {
			fish.numberFish += value
			foundFish = true
		}
	}

	if !foundFish {
		fishes = append(fishes, &Fish{
			internalTimer: internalTimer,
			numberFish:    value,
		})
	}
	return fishes
}

func (f *Fish) newDay() *int {
	f.internalTimer -= 1
	if f.internalTimer < 0 {
		return &f.numberFish
	}

	return nil
}
