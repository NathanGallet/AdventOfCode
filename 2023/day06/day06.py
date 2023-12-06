import re
import math

def value(input):
    return [list(map(int, re.findall(r'\d+', v))) for v in input.strip().split("\n")]

def is_winning(hold, time, distance):
    speed = hold
    result = 0
    for i in range(hold, time):
        result += speed

    return result > distance

def part1(races):
    result = 1
    for race in range(0, len(races[0])):
        time = races[0][race]
        distance = races[1][race]
        hold = 0
        race_result = 0

        while(hold != time):
            if is_winning(hold, time, distance):
                race_result += 1

            hold += 1

        result = result * race_result

    return result

def part2(races):
    races = [int(''.join(map(str, v))) for v in races]
    time = races[0]
    distance = races[1]
    min = (-time+math.sqrt((time**2)-(4*(distance))))/(-2)
    max = (-time-math.sqrt((time**2)-(4*(distance))))/(-2)
    return math.trunc(max) - math.trunc(min)


input = value(open('./2023/day06/input.txt').read())


print(part1(input))
print(part2(input))
