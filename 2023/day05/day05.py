import re

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

    while(len(ranges) > 0):
        value = ranges.pop()
        result = None

        for mapping in mappings:
            destination, source, length = mapping
            source_range = range(source, source + length)
            intersec = range(max(value.start, source_range.start), min(value.stop, source_range.stop)) or None

            if intersec is not None:
                shift = destination - source
                if intersec == value:
                    result = [range(value.start + shift, value.stop + shift)]
                    break
                elif value.start == intersec.start:
                    result = [range(value.start + shift, intersec.stop + shift)]
                    ranges += [range(intersec.stop, value.stop)]
                    break
                elif value.stop == intersec.stop:
                    result = [range(intersec.start + shift, intersec.stop + shift)]
                    ranges += [range(value.start, intersec.start)]
                    break
                else:
                    result = [range(intersec.start + shift, intersec.stop + shift)]
                    ranges += [range(value.start, intersec.start), range(intersec.stop, value.stop)]
                    break

        if result is None:
            results += [value]
        else:
            results += result

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
    seeds = []
    for i in range(0, len(almanac['seeds']), 2):
        start, size = almanac['seeds'][i:i + 2]
        seeds.append(range(start, start + size))

    soil = convert_range(seeds, almanac['seed_to_soil'])

    fertilizer = convert_range(soil, almanac['soil_to_fertilizer'])
    water = convert_range(fertilizer, almanac['fertilizer_to_water'])
    light = convert_range(water, almanac['water_to_light'])
    temperature = convert_range(light, almanac['light_to_temperature'])
    humidity = convert_range(temperature, almanac['temperature_to_humidity'])
    location = convert_range(humidity, almanac['humidity_to_location'])

    return min([loc.start for loc in location])

almanac = value(open('./2023/day05/input.txt').read())

print(part1(almanac))
print(part2(almanac))

#551761867
#57451709
