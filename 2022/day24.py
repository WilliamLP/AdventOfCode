grid_at_time = {}
def get_grid(time):
    if time < len(grid_at_time):
        return grid_at_time[time]
    grid = [['.'] * width for i in range(height)]
    for blizzard in blizzards:
        i = (blizzard[0] + blizzard[2] * time) % height
        j = (blizzard[1] + blizzard[3] * time) % width
        grid[i][j] = '#'
    grid_at_time[time] = grid
    return grid

def bfs(time, is_start):
    queue = {(-1, 0) if is_start else (height, width - 1)}
    while queue:
        next_queue = set()
        time += 1
        grid = get_grid(time)
        for (i, j) in queue:
            if is_start and i == height - 1 and j == width - 1:
                return time
            if not is_start and i == 0 and j == 0:
                return time

            for di, dj in ((1, 0), (0, 1), (0, 0), (-1, 0), (0, -1)):
                if di != 0 or dj != 0:  # Waiting is always allowed
                    if i + di < 0 or j + dj < 0 or i + di >= height or j + dj >= width:
                        continue
                if i == -1 or i == height or grid[i + di][j + dj] == '.':
                    next_queue.add((i + di, j + dj))
        queue = next_queue

blizzards = []
for i, line in enumerate(open('day24.txt').readlines()[1:-1]):
    height = i + 1
    width = len(line.strip()) - 2
    for j, ch in enumerate(line.strip()[1:-1]):
        if ch == '<':
            di, dj = 0, -1
        elif ch == '>':
            di, dj = 0, 1
        elif ch == '^':
            di, dj = -1, 0
        elif ch == 'v':
            di, dj = 1, 0
        else:
            continue
        blizzards.append((i, j, di, dj))

t1 = bfs(0, True)
print('Part 1', t1)
t2 = bfs(t1, False)
print('Part 2', bfs(t2, True))
