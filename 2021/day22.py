import re
from collections import defaultdict

def part1(volumes):
    grid = [[[False for z in range(101)]
             for y in range(101)]
            for x in range(101)]

    for v in volumes:
        if abs(v['x1']) > 50 or abs(v['x2']) > 50 or \
                abs(v['y1']) > 50 or abs(v['y2']) > 50 or \
                abs(v['z1']) > 50 or abs(v['z2']) > 50:
            continue
        for x in range(v['x1'], v['x2'] + 1):
            for y in range(v['y1'], v['y2'] + 1):
                for z in range(v['z1'], v['z2'] + 1):
                    grid[x+50][y+50][z+50] = v['state']

    count = 0
    for slice1 in grid:
        for slice2 in slice1:
            for slice3 in slice2:
                if slice3:
                    count += 1
    print(f'Part 1 answer: ', count)

def coord_range(volumes, key1, key2):
    coord_set = set()
    for v in volumes:
        coord_set.add(v[key1])
        coord_set.add(v[key2])

    res = []
    prev = None
    for coord in sorted(list(coord_set)):
        if prev is None:
            res.append((coord, coord))
        else:
            if coord - prev > 1:
                # Interior region
                res.append((prev+1, coord-1))
            res.append((coord, coord))
        prev = coord
    return res

def sub_range(cr, min, max):
    res = []
    for i, (lo, hi) in enumerate(cr):
        if hi < min:
            continue
        if lo > max:
            break
        res.append(i)
    return res

def part2(volumes):
    xr = coord_range(volumes, 'x1', 'x2')
    yr = coord_range(volumes, 'y1', 'y2')
    zr = coord_range(volumes, 'z1', 'z2')

    print(f'before create grid {len(xr)} {len(yr)} {len(zr)}')
    grid = [[[False for z in range(len(zr))]
             for y in range(len(yr))]
            for x in range(len(xr))]
    print('after create grid')

    for iv, v in enumerate(volumes):
        print(f'{iv}/{len(volumes)}')
        subxr = sub_range(xr, v['x1'], v['x2'])
        subyr = sub_range(yr, v['y1'], v['y2'])
        subzr = sub_range(zr, v['z1'], v['z2'])
        state = v['state']
        for ix in subxr:
            for iy in subyr:
                for iz in subzr:
                    grid[ix][iy][iz] = state

    sum = 0
    for ix, (x1, x2) in enumerate(xr):
        for iy, (y1, y2) in enumerate(yr):
            for iz, (z1, z2) in enumerate(zr):
                if grid[ix][iy][iz]:
                    sum += (x2 - x1 + 1) * (y2 - y1 + 1) * (z2 - z1 + 1)
    print(f'Part 2 answer: {sum}')

def main():
    volumes = []
    for str in open('day22.txt'):
        m = re.match('^(off|on) x=(-?\d+)\.\.(-?\d+),y=(-?\d+)\.\.(-?\d+),z=(-?\d+)\.\.(-?\d+)', str)
        volumes.append ({'state': m[1] == 'on',
                   'x1': int(m[2]), 'x2': int(m[3]),
                   'y1': int(m[4]), 'y2': int(m[5]),
                   'z1': int(m[6]), 'z2': int(m[7])})


    # part1(volumes)
    part2(volumes)

main()