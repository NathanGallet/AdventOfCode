package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestPart1(t *testing.T) {
	var inputs []int = []int{3, 4, 3, 1, 2}
	assert.Equal(t, 5934, Part1(inputs))
}

func TestPart2(t *testing.T) {
	var inputs []int = []int{3, 4, 3, 1, 2}
	assert.Equal(t, 26984457539, Part2(inputs))
}
