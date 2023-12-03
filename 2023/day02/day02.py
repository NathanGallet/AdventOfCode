import re

def value(input):
    return input.strip().split("\n")

def check_game_result(game):
    for result in game:
        blue = int(result[1]) if result[1] != '' else 0
        red = int(result[2]) if result[2] != '' else 0
        green = int(result[3]) if result[3] != '' else 0

        if blue > 14 or red > 12 or green > 13:
            return 0

    return int(game[0][0])

def find_minimum_required(game):
    min_red = 0
    min_blue = 0
    min_green = 0

    for result in game:
        blue = int(result[1]) if result[1] != '' else 0
        red = int(result[2]) if result[2] != '' else 0
        green = int(result[3]) if result[3] != '' else 0

        min_blue = blue if blue > min_blue else min_blue
        min_red = red if red > min_red else min_red
        min_green = green if green > min_green else min_green

    return min_blue * min_red * min_green


def part1(games):
    regex = re.compile(r'Game (\d+)|(\d+) blue|(\d+) red|(\d+) green')
    score = 0
    for game in games:
        score += check_game_result(re.findall(regex, game))

    return score

def part2(games):
    regex = re.compile(r'Game (\d+)|(\d+) blue|(\d+) red|(\d+) green')
    score = 0
    for game in games:
        score += find_minimum_required(re.findall(regex, game))

    return score


input = value(open('./2023/day02/input.txt').read())

print(part1(input))
print(part2(input))
