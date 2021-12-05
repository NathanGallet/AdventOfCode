package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestPart1(t *testing.T) {
	BITSIZE = 5
	NUMBERBIT = 12

	var inputs []int = []int{
		0b00100,
		0b11110,
		0b10110,
		0b10111,
		0b10101,
		0b01111,
		0b00111,
		0b11100,
		0b10000,
		0b11001,
		0b00010,
		0b01010,
	}
	assert.Equal(t, int64(198), Part1(inputs))
}

func TestPart2(t *testing.T) {
	BITSIZE = 5
	NUMBERBIT = 12

	var inputs []int = []int{
		0b00100,
		0b11110,
		0b10110,
		0b10111,
		0b10101,
		0b01111,
		0b00111,
		0b11100,
		0b10000,
		0b11001,
		0b00010,
		0b01010,
	}

	assert.Equal(t, 230, Part2(inputs))
}
