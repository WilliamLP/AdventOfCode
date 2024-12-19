from queue import PriorityQueue

max = 70

bytes = {}
for i, l in enumerate(open('day18.txt')):
    xs, ys = l.strip().split(',')
    bytes[(int(xs), int(ys))] = i


def bfs(k):
    q = PriorityQueue()
    q.put((0, 0, 0))

    dists = {}

    while not q.empty():
        dist, x, y = q.get()

        if (x, y) in dists:
            continue
        dists[(x, y)] = dist

        for (dx, dy) in ((0, 1), (0, -1), (1, 0), (-1, 0)):
            nx, ny = x + dx, y + dy
            if nx < 0 or nx > max or ny < 0 or ny > max:
                continue
            byte = bytes.get((nx, ny))
            if byte is not None and byte < k:
                continue
            q.put((dist + 1, nx, ny))
    return dists

dists = bfs(1024)
print('Part 1:', dists[(max, max)])

lo, hi = 1024, len(bytes)
while hi - lo > 1:
    mid = (lo + hi) // 2
    dists = bfs(mid)
    if (max, max) in dists:
        lo, hi = mid, hi
    else:
        lo, hi = lo, mid
    # print(lo, mid, hi, '/', len(bytes))

for byte, i in bytes.items():
    if i == hi - 1:
        print('Part 2:', f'{byte[0]},{byte[1]}')