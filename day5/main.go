package main

import (
	"adventOfCode/utils"
	"fmt"
	"strconv"
	"strings"
)

func main() {
	inputs := utils.ParseInputAsString()
	fmt.Println("Result day 5 part 1: ", Part1(inputs))
	fmt.Println("Result day 5 part 2: ", Part2(inputs))
}

func Part1(inputs []string) int {
	var coords []Coord
	var maxX, maxY int
	for _, line := range inputs {
		coord := parseLine(line)
		if coord.IsVerticalOrHorizontalMatching() {
			if coord.MaxX() > maxX {
				maxX = coord.MaxX()
			}
			if coord.MaxY() > maxY {
				maxY = coord.MaxY()
			}
			coords = append(coords, coord)
		}
	}

	matrice := generateMatrix(maxX+1, maxY+1)
	matrice = populateMatrice(matrice, coords)

	return countLinesCover(matrice)
}

func Part2(inputs []string) int {
	var coords []Coord
	var maxX, maxY int
	for _, line := range inputs {
		coord := parseLine(line)
		if coord.MaxX() > maxX {
			maxX = coord.MaxX()
		}
		if coord.MaxY() > maxY {
			maxY = coord.MaxY()
		}
		coords = append(coords, coord)
	}

	matrice := generateMatrix(maxX+1, maxY+1)
	matrice = populateMatrice(matrice, coords)

	printMatrice(matrice)
	return countLinesCover(matrice)
}

func generateMatrix(maxX, maxY int) [][]int {
	var matrice = make([][]int, maxY)
	for i := range matrice {
		matrice[i] = make([]int, maxX)
	}

	return matrice
}

func populateMatrice(matrice [][]int, coords []Coord) [][]int {
	for _, coord := range coords {
		if coord.IsHorizontal() {
			yinit, yfinal := coord.PopulateHorizontal()
			for i := yinit; i <= yfinal; i++ {
				matrice[i][coord.xfinal] += 1
			}
		} else if coord.IsVeritical() {
			xinit, xfinal := coord.PopulateVerical()
			for i := xinit; i <= xfinal; i++ {
				matrice[coord.yfinal][i] += 1
			}
		} else {
			var diff int

			if coord.xinit < coord.xfinal {
				diff = coord.xfinal - coord.xinit

				if coord.yinit < coord.yfinal {
					for i := 0; i <= diff; i++ {
						matrice[coord.yinit+i][coord.xinit+i] += 1
					}
				} else {
					for i := 0; i <= diff; i++ {
						matrice[coord.yinit-i][coord.xinit+i] += 1
					}
				}
			} else {
				diff = coord.xinit - coord.xfinal
				if coord.yinit < coord.yfinal {
					for i := 0; i <= diff; i++ {
						matrice[coord.yinit+i][coord.xinit-i] += 1
					}
				} else {
					for i := 0; i <= diff; i++ {
						matrice[coord.yinit-i][coord.xinit-i] += 1
					}
				}
			}
		}
	}

	return matrice
}

func countLinesCover(matrice [][]int) int {
	var sum int
	for i := 0; i < len(matrice); i++ {
		for j := 0; j < len(matrice[i]); j++ {
			if matrice[i][j] >= 2 {
				sum += 1
			}
		}
	}

	return sum
}

func printMatrice(matrice [][]int) {
	for i := 0; i < len(matrice); i++ {
		fmt.Printf("%v\n", matrice[i])
	}
}

type Coord struct {
	xinit  int
	yinit  int
	xfinal int
	yfinal int
}

func newCoord(coordInitStr, coordFinalStr string) Coord {
	coordInit := strings.Split(coordInitStr, ",")
	xinit, _ := strconv.Atoi(coordInit[0])
	yinit, _ := strconv.Atoi(coordInit[1])

	coordFinal := strings.Split(coordFinalStr, ",")
	xfinal, _ := strconv.Atoi(coordFinal[0])
	yfinal, _ := strconv.Atoi(coordFinal[1])

	return Coord{
		xinit:  xinit,
		yinit:  yinit,
		xfinal: xfinal,
		yfinal: yfinal,
	}
}

func parseLine(line string) Coord {
	coords := strings.Split(strings.ReplaceAll(line, " ", ""), "->")
	return newCoord(coords[0], coords[1])
}

func (c Coord) IsVerticalOrHorizontalMatching() bool {
	return c.xinit == c.xfinal || c.yinit == c.yfinal
}

func (c Coord) MaxX() int {
	if c.xinit > c.xfinal {
		return c.xinit
	} else {
		return c.xfinal
	}
}

func (c Coord) MaxY() int {
	if c.yinit > c.yfinal {
		return c.yinit
	} else {
		return c.yfinal
	}
}

func (c Coord) IsVeritical() bool {
	return c.yinit == c.yfinal
}

func (c Coord) IsHorizontal() bool {
	return c.xinit == c.xfinal
}

func (c Coord) PopulateVerical() (int, int) {
	if c.xfinal > c.xinit {
		return c.xinit, c.xfinal
	} else {
		return c.xfinal, c.xinit
	}
}

func (c Coord) PopulateHorizontal() (int, int) {
	if c.yfinal > c.yinit {
		return c.yinit, c.yfinal
	} else {
		return c.yfinal, c.yinit
	}
}
