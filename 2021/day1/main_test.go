package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestPart1(t *testing.T) {
	var inputs []int = []int{
		199,
		200,
		208,
		210,
		200,
		207,
		240,
		269,
		260,
		263,
	}
	assert.Equal(t, 7, Part1(inputs))
}

func TestPart2(t *testing.T) {
	var inputs []int = []int{
		607,
		618,
		618,
		617,
		647,
		716,
		769,
		792,
	}
	assert.Equal(t, 5, Part2(inputs))
}
