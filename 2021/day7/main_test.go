package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestPart1(t *testing.T) {
	var inputs []int = []int{16, 1, 2, 0, 4, 2, 7, 1, 2, 14}
	assert.Equal(t, 37, Part1(inputs))
}

func TestPart2(t *testing.T) {

	var inputs []int = []int{16, 1, 2, 0, 4, 2, 7, 1, 2, 14}
	assert.Equal(t, 168, Part2(inputs))
}
