global_max = 4000000

sensors = []
beacons = []
for str in open('day15.txt'):
    parts = str.strip().split(' ')
    sensor_x = int(parts[2].replace('x=', '').replace(',', ''))
    sensor_y = int(parts[3].replace('y=', '').replace(':', ''))
    beacon_x = int(parts[8].replace('x=', '').replace(',', ''))
    beacon_y = int(parts[9].replace('y=', ''))

    beacons.append((beacon_x, beacon_y))
    # x, y, dist
    sensors.append((sensor_x, sensor_y, abs(sensor_x - beacon_x) + abs(sensor_y - beacon_y)))

def add_seg(segs, min_x, max_x):
    cur_min_x, cur_max_x = max(min_x, 0), min(max_x, global_max)
    new_segs = []
    for (min_x, max_x) in segs:
        if min_x > cur_max_x or max_x < cur_min_x:
            new_segs.append((min_x, max_x))
        else:
            cur_min_x = min(cur_min_x, min_x)
            cur_max_x = max(cur_max_x, max_x)
    new_segs.append((cur_min_x, cur_max_x))

    return new_segs

for test_y in range(0, global_max + 1):
    if test_y % 100000 == 0:
        print(test_y)
    line_segs = []
    for (x, y, radius) in sensors:
        if abs(y - test_y) > radius:
            continue
        line_segs = add_seg(line_segs, x - (radius - abs(y - test_y)), x + (radius - abs(y - test_y)))

    x_count = sum([max_x - min_x + 1 for (min_x, max_x) in line_segs])
    if x_count == global_max:
        for test_x in range(0, global_max + 1):
            overlap = sum([1 for (min_x, max_x) in line_segs if min_x <= test_x and max_x >= test_x])
            if not overlap:
                print('Part 2', test_x * 4000000 + test_y)
                import sys; sys.exit()

