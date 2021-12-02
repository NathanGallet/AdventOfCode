package utils

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"os"
	"strconv"
	"strings"
)

func ParseInputAsInt() (result []int) {
	data := ReadFile()
	fileContent := string(bytes.TrimSpace(data))
	lines := strings.Split(fileContent, "\n")

	for _, line := range lines {
		i, err := strconv.Atoi(line)
		if err != nil {
			panic(fmt.Sprintf("Can't convert string %s to int %s", line, err.Error()))
		}

		result = append(result, i)
	}

	return result
}

func ParseInputAsString() []string {
	data := ReadFile()
	fileContent := string(bytes.TrimSpace(data))

	return strings.Split(fileContent, "\n")
}

func ReadFile() []byte {
	dir, err := os.Getwd()

	if err != nil {
		panic(fmt.Sprintf("Error getting working directory %s", err.Error()))
	}

	path := fmt.Sprintf("%s/input.txt", dir)

	if _, err := os.Stat(path); err != nil {
		panic(fmt.Sprintf("Can't file in path %s, err %s", path, err.Error()))
	}

	data, err := ioutil.ReadFile(path)

	if err != nil {
		panic(fmt.Sprintf("Can't read file in path %s, err %s", path, err.Error()))
	}

	return data
}