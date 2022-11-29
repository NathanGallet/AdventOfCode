package main

import (
	"adventOfCode/utils"
	"fmt"
	"strconv"
)

var BITSIZE = 12
var NUMBERBIT = 1000

func main() {
	fmt.Println("Result day 3 part 1: ", Part1(utils.ParseInputAsBinary()))
	fmt.Println("Result day 3 part 2: ", Part2(utils.ParseInputAsBinary()))
}

func Part1(inputs []int) int64 {
	gammaRate := make([]byte, BITSIZE)
	epsilonRate := make([]byte, BITSIZE)
	allBits := make([]byte, NUMBERBIT)

	for i := 0; i < BITSIZE; i++ {
		for index, input := range inputs {
			allBits[index] = byte((input & (1 << i)) >> i)
		}

		nbZero, nbOne := mostCommonBit(allBits)

		if nbZero > nbOne {
			gammaRate[BITSIZE-i-1] = byte(0)
			epsilonRate[BITSIZE-i-1] = byte(1)
		} else {
			gammaRate[BITSIZE-i-1] = byte(1)
			epsilonRate[BITSIZE-i-1] = byte(0)
		}
	}

	return convertBytesToInt(gammaRate) * convertBytesToInt(epsilonRate)
}

func Part2(inputs []int) int {

	oxygen := inputs
	for i := 0; len(oxygen) != 1; i++ {
		oxygen = getNewInputs(BITSIZE-i-1, oxygen, true)
	}

	co2 := inputs
	for i := 0; len(co2) != 1; i++ {
		co2 = getNewInputs(BITSIZE-i-1, co2, false)
	}

	return oxygen[0] * co2[0]
}

func getNewInputs(rank int, previousInputs []int, isOxygen bool) []int {
	var nbZero, nbOne int
	allBits := make([]byte, len(previousInputs))

	for index, input := range previousInputs {
		allBits[index] = byte((input & (1 << rank)) >> rank)
	}

	nbZero, nbOne = mostCommonBit(allBits)

	if isOxygen {
		if nbZero > nbOne {
			return keepValue(0, rank, previousInputs)
		} else if nbZero < nbOne {
			return keepValue(1, rank, previousInputs)
		} else if isOxygen {
			return keepValue(1, rank, previousInputs)
		} else {
			return keepValue(0, rank, previousInputs)
		}
	} else {
		if nbZero > nbOne {
			return keepValue(1, rank, previousInputs)
		} else if nbZero < nbOne {
			return keepValue(0, rank, previousInputs)
		} else if isOxygen {
			return keepValue(1, rank, previousInputs)
		} else {
			return keepValue(0, rank, previousInputs)
		}
	}
}

func keepValue(value, index int, previousInputs []int) []int {
	var newInputs []int
	for i, input := range previousInputs {
		if (input&(1<<index))>>index == value {
			newInputs = append(newInputs, previousInputs[i])
		}
	}

	return newInputs
}

func mostCommonBit(number []byte) (int, int) {
	var numberOfZero, numberOfOne int
	for i := 0; i < len(number); i++ {
		if number[i]&0b1111 == 0 {
			numberOfZero += 1
		} else {
			numberOfOne += 1
		}
	}

	return numberOfZero, numberOfOne
}

func convertBytesToInt(value []byte) int64 {
	var strValue string

	for i := 0; i < len(value); i++ {
		strValue = fmt.Sprintf("%s%d", strValue, int(value[i]))
	}

	intValue, _ := strconv.ParseInt(strValue, 2, 64)

	return intValue
}
