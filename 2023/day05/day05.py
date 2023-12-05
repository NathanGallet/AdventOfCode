import re
import sys

def value(input):
    almanac = {}

    for line in input.strip().split("\n\n"):
        maps = line.split(":")
        title = re.sub(r'-', '_', re.sub(r'\s.*', '', maps[0]))
        values = []
        for map_lines in maps[1].strip().split('\n'):
            values.append(tuple([int(value) for value in re.findall(r'\d+', map_lines)]))

        almanac[title] = values
    almanac['seeds'] = almanac['seeds'][0]
    return almanac

def convert(value, mappings):
    for mapping in mappings:
        destination, source, length = mapping
        if value in range(source, source + length):
            return destination + value - source

    return value

def convert_range(ranges, mappings):
    results = []

    for value in ranges:

        value_range = range(value[0], value[0] + value[1])
        result = value

        for mapping in mappings:
            destination, source, length = mapping

            source_range = range(source, source + length)
            intersec = range(max(value_range.start,source_range.start), min(value_range.stop,source_range.stop)) or None

            if intersec is not None:
                shift = destination - source
                if intersec == value_range:
                    result = (value_range.start + shift, value_range.stop - value_range.start + shift)
                    break
                elif value_range.start == intersec.start:
                    result = [(value_range.start + shift, intersec.stop - intersec.start + shift), (intersec.stop + 1, value_range.stop - intersec.stop + 1 )]
                    break
                elif value_range.stop == intersec.stop:
                    result = [(value_range.start, intersec.start - 1 - value_range.start), (intersec.start, intersec.stop - intersec.start )]
                    break
                else :
                    print('')
                    print('value_range', value_range)
                    print('source_range', source_range)
                    print('intersec', intersec)
                    print('shift', shift)
                    print('')

        if type(result) is list:
            results = results + result
        else:
            results.append(result)

    print('list(set(result))', results)
    return results


def part1(almanac):
    result = []
    for seed in almanac['seeds']:
        soil = convert(seed, almanac['seed_to_soil'])
        fertilizer = convert(soil, almanac['soil_to_fertilizer'])
        water = convert(fertilizer, almanac['fertilizer_to_water'])
        light = convert(water, almanac['water_to_light'])
        temperature = convert(light, almanac['light_to_temperature'])
        humidity = convert(temperature, almanac['temperature_to_humidity'])
        location = convert(humidity, almanac['humidity_to_location'])

        result.append(location)

    return min(result)

def part2(almanac):
    result = []
    seeds = [almanac['seeds'][i:i + 2] for i in range(0, len(almanac['seeds']), 2)]

    print('\n======soil\n')
    soil = convert_range(seeds, almanac['seed_to_soil'])
    print('\n======fertilizer\n')
    fertilizer = convert_range(soil, almanac['soil_to_fertilizer'])
    print('\n======water\n')
    water = convert_range(fertilizer, almanac['fertilizer_to_water'])
    print('\n======light\n')
    light = convert_range(water, almanac['water_to_light'])
    print('\n======temperature\n')
    temperature = convert_range(light, almanac['light_to_temperature'])
    print('\n======humidity\n')
    humidity = convert_range(temperature, almanac['temperature_to_humidity'])
    print('\n======location\n')
    location = convert_range(humidity, almanac['humidity_to_location'])

    print('location', location)


    my_min = sys.maxsize
    for l in location:
        if l[0] < my_min:
            my_min = l[0]

    result.append(my_min)

    return min(soil)

almanac = value(open('./2023/day05/input.txt').read())

# print(part1(almanac))
print(part2(almanac))
