import re

def value(input):
    return [line.split("|") for line in input.strip().split("\n")]

def part1(cards):
    result = 0
    for card in cards:
        winners = re.findall(r'\d+', card[0].split(":")[1])
        numbers = re.findall(r'\d+', card[1])
        wins = sum(num in winners for num in numbers)
        if wins > 0:
            result += pow(2, wins - 1)

    return result

def part2(cards):
    result = {}
    for card_number in range(1, len(cards)+1):
        result[card_number] = 1

    for card in cards:
        winners = [re.findall(r'\d+', my_card) for my_card in card[0].split(":")]
        numbers = re.findall(r'\d+', card[1])
        wins = sum(num in winners[1] for num in numbers)

        if wins > 0:
            win_card = int(winners[0][0])
            for _copy in range(0, result[win_card]):
                for i in range(win_card + 1, win_card + wins + 1):
                    result[i] += 1

    return sum(list(result.values()))

input = value(open('./2023/day04/input.txt').read())

print(part1(input))
print(part2(input))
