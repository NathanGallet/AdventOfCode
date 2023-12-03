import re

def value(input):
    return input.strip().split("\n")

def part1(input):
    result = 0
    reg = re.compile(r'\d')
    for line in input:
        r = reg.findall(line)
        result += int('{}{}'.format(r[0], r[-1]))
    return result

def part2(input):
    result = 0
    reg = re.compile(r'(?=(one))|(?=(two))|(?=(three))|(?=(four))|(?=(five))|(?=(six))|(?=(seven))|(?=(eight))|(?=(nine))|(?=(\d))')
    for line in input:
        r = reg.findall(line)
        result += int('{}{}'.format(convert(r[0]), convert(r[-1])))
    return result

def convert(v):
    v = [a for a in v if a != ''][-1]
    match v:
        case "one":
            return 1
        case "two":
            return 2
        case "three":
            return 3
        case "four":
            return 4
        case "five":
            return 5
        case "six":
            return 6
        case "seven":
            return 7
        case "eight":
            return 8
        case "nine":
            return 9
        case _:
            return v

input = value(open('./2023/day01/input.txt').read())

print(part1(input))
print(part2(input))
