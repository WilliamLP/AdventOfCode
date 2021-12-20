from collections import defaultdict


def parse():
    f = open('day20.txt')
    algo = f.readline().strip()
    f.readline()
    points = []
    i = 0
    for str in f.readlines():
        i += 1
        for j, ch in enumerate(str.strip(), start=1):
            if ch == '#':
                points.append((i, j))
    return algo, points

def next_points(points, directions, algo):
    point_agg = defaultdict(lambda: defaultdict(int))
    for i, j in points:
        for di, dj, bit in directions:
            point_agg[i - di][j - dj] += bit

    res = []
    for i, dict_j in point_agg.items():
        for j, lookup in dict_j.items():
            # print(lookup)
            if algo[lookup] == '#':
                res.append((i, j))
    return res

def print_pts(points):
    grid = []
    for i in range(-2, 102):
        grid.append('.' * 104)
    for i, j in points:
        grid[i+1] = grid[i+1][0:(j+1)] + '#' + grid[i+1][(j+1)+1:]
    print('=====')
    for line in grid:
        print(line)

def main():
    algo, points = parse()
    directions = ((-1, -1, 256), (-1, 0, 128), (-1, 1, 64),
                   (0, -1, 32), (0, 0, 16), (0, 1, 8),
                   (1, -1, 4), (1, 0, 2), (1, 1, 1))

    step = 0
    while step < 2:
        print_pts(points)
        points = next_points(points, directions, algo)
        step += 1

    print_pts(points)
    print(f'Part 1 answer: {len(points)}')
main()


