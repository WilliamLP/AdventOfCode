from queue import PriorityQueue

map = []

for i, line in enumerate(open("day16.txt")):
    if 'S' in line:
        start = (i, line.find('S'))
    if 'E' in line:
        end = (i, line.find('E'))
    map.append([ch for ch in line.strip()])

def print_map(map):
    for y, rw in enumerate(map):
        print(''.join(rw))

q = PriorityQueue()
q.put((0, start[0], start[1], 0, 1, None))

paths = {}
dists = {}
end_state = None

while not q.empty():
    dist, i, j, di, dj, prev_state = q.get()
    state = (i, j, di, dj)
    if (i, j) == end and not end_state:
        end_state = state

    if state in dists:
        dist_last = dists[state]
        if dist == dist_last:
            for p in paths[prev_state]:
                paths[state].append(p + [state])
        continue

    dists[state] = dist
    paths[state] = []
    if (i, j) == start:
        paths[state].append([state])
    else:
        for p in paths[prev_state]:
            paths[state].append(p + [state])


    if map[i + di][j + dj] != '#':
        q.put((dist + 1, i + di, j + dj, di, dj, state))
    # turn left or right
    q.put((dist + 1000, i, j, dj, -di, state))
    q.put((dist + 1000, i, j, -dj, di, state))

print('Part 1:', dists[end_state])
part2_pos = set()
for p in paths[end_state]:
    for s in p:
        part2_pos.add((s[0], s[1]))
print('Part 2:', len(part2_pos))
