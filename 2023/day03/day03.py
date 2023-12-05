def add_value_buffer(buffer, character, row, col):
    result = {}
    if bool(buffer):
        (number, coord) = list(buffer.items())[0]
        if type(coord[0]) is tuple:
            result[number + character] = (*coord, (row, col))
        else:
            result[number + character] = (coord, (row, col))
    else:
        result[character] = ((row, col))

    return result

def value(input):
    symbols = []
    gears = []
    engine = []
    points = {}
    buffer = {}

    for row, line in enumerate(input.strip().split("\n")):
        line = [l for l in line]
        engine.append(line)

        for col, character in enumerate(line):
            if character.isdigit():
                buffer = add_value_buffer(buffer, character, row, col)
                continue

            if bool(buffer):
                (number, coord) = list(buffer.items())[0]
                points[coord] = int(number)
                buffer = {}

            if character == '.':
                continue

            if character == '*':
                gears.append((row, col))

            symbols.append((row, col))

    return (points, engine, symbols, gears)

def around_symbol(coord, symbols, max_row, max_col):
    row, col = coord
    if row + 1 < max_row and (row + 1, col) in symbols:
        return True
    if row > 0 and (row - 1, col) in symbols:
        return True
    if col + 1 < max_col and (row, col + 1) in symbols:
        return True
    if col > 0 and (row, col - 1) in symbols:
        return True
    if row + 1 < max_row and col + 1 < max_col and (row + 1, col + 1) in symbols:
        return True
    if row + 1 < max_row and col > 0 and (row + 1, col - 1) in symbols:
        return True
    if row > 0 and col + 1 < max_col and (row - 1, col + 1) in symbols:
        return True
    if row > 0 and col > 0 and (row - 1, col - 1) in symbols:
        return True

    return False

def part1(engine, points, symbols):
    result = 0
    for coords, number in points.items():
        if type(coords[0]) is tuple and any(around_symbol(coord, symbols, len(engine), len(engine[0])) for coord in coords):
            result += number

        if type(coords[0]) is int and around_symbol(coords, symbols, len(engine), len(engine[0])):
            result += number

    return result

def part2(engine, points, gears):
    result = 0
    for gear in gears:
        numbers = []
        for coords, number in points.items():
            if type(coords[0]) is tuple and any(around_symbol(coord, [gear], len(engine), len(engine[0])) for coord in coords):
                numbers.append(number)

            if type(coords[0]) is int and around_symbol(coords, [gear], len(engine), len(engine[0])):
                numbers.append(number)

            if len(numbers) == 2:
                result += numbers[0] * numbers[1]
                break

    return result

points, engine, symbols, gears = value(open('./2023/day03/input.txt').read())

print(part1(engine, points, symbols))
print(part2(engine, points, gears))
