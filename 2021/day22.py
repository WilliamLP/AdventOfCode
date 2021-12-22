import re

def coord_range(volumes, key1, key2):
    coord_set = set()
    for v in volumes:
        coord_set.add(v[key1])
        coord_set.add(v[key2])

    res = []
    prev = None
    for coord in sorted(list(coord_set)):

        if prev and coord - prev > 1:
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

def count_points(volumes):
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
    return sum

def main():
    volumes = []
    for str in open('day22.txt'):
        m = re.match('^(off|on) x=(-?\d+)\.\.(-?\d+),y=(-?\d+)\.\.(-?\d+),z=(-?\d+)\.\.(-?\d+)', str)
        volumes.append ({'state': m[1] == 'on',
                   'x1': int(m[2]), 'x2': int(m[3]),
                   'y1': int(m[4]), 'y2': int(m[5]),
                   'z1': int(m[6]), 'z2': int(m[7])})


    count = count_points(volumes)
    print(f'Part 2 answer: {count}')

main()