package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestPart1(t *testing.T) {
	var inputs []string = []string{
		"forward 5",
		"down 5",
		"forward 8",
		"up 3",
		"down 8",
		"forward 2",
	}
	assert.Equal(t, 150, Part1(inputs))
}

func TestPart2(t *testing.T) {
	var inputs []string = []string{
		"forward 5",
		"down 5",
		"forward 8",
		"up 3",
		"down 8",
		"forward 2",
	}
	assert.Equal(t, 900, Part2(inputs))
}
