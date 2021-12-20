from collections import defaultdict

PADDING = 50
WIDTH = 100 + 2 * PADDING

def parse():
    f = open('day20.txt')
    algo = f.readline().strip()
    f.readline()
    points = ['.' * (WIDTH)] * PADDING
    for str in f.readlines():
        points.append(('.' * PADDING) + str.strip() + ('.' * PADDING))
    points.extend(['.' * (WIDTH)] * PADDING)
    return algo, points

def next_points(points, directions, algo, inf):
    res = []
    for i in range(len(points)):
        row = ''
        for j in range(len(points[0])):
            sum = 0
            for di, dj, bit in directions:
                if i + di < 0 or i + di >= WIDTH or j + dj < 0 or j + dj >= WIDTH:
                    if inf == '#':
                        sum += bit
                elif points[i + di][j + dj] == '#':
                    sum += bit
            row += algo[sum]
        res.append(row)
    return res

    res = []
    for i, dict_j in point_agg.items():
        for j, lookup in dict_j.items():
            # print(lookup)
            if algo[lookup] == '#':
                res.append((i, j))
    return res

def print_pts(points):
    print('=' * (2 * PADDING + WIDTH))
    for line in points:
        print(line)

def count_points(points):
    sum = 0
    for line in points:
        for ch in line:
            if ch == '#':
                sum += 1
    return sum

def main():
    algo, points = parse()
    directions = ((-1, -1, 256), (-1, 0, 128), (-1, 1, 64),
                   (0, -1, 32), (0, 0, 16), (0, 1, 8),
                   (1, -1, 4), (1, 0, 2), (1, 1, 1))

    step = 0
    inf = '.'
    while step < 50:
        points = next_points(points, directions, algo, inf)
        # print_pts(points)
        step += 1
        inf = algo[0] if inf == '.' else algo[511]
        if step in (2, 50):
            print(f'Point count after step {step}: {count_points(points)}')

main()


