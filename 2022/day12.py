grid = []
for j, str in enumerate(open('day12.txt')):
    if 'S' in str:
        start = (str.index('S'), j)
    if 'E' in str:
        finish = (str.index('E'), j)
    grid.append(str.strip().replace('S', 'a').replace('E', 'z'))

size_x, size_y = len(grid[0]), len(grid)
dist = 0
visited = {start}
next_list = [start]
while next_list:
    lst = next_list
    next_list = []
    dist += 1
    for cell in lst:
        for adj in (cell[0] - 1, cell[1]), (cell[0] + 1, cell[1]), (cell[0], cell[1] - 1), (cell[0], cell[1] + 1):
            if adj[0] < 0 or adj[0] >= size_x or adj[1] < 0 or adj[1] >= size_y:
                continue
            if adj in visited:
                continue
            if ord(grid[adj[1]][adj[0]]) > ord(grid[cell[1]][cell[0]]) + 1:
                continue
            if adj == finish:
                print('Part 1: ', dist)
            visited.add(adj)
            next_list.append(adj)
