import re

strs = open('day22.txt').readlines()
grid = [s.rstrip() for s in strs[0:-2]]

# print('\n'.join(grid))

min_j = [999 for i in range(len(grid))]
max_j = [0 for i in range(len(grid))]
min_i = [999 for j in range(max(len(row) for row in grid))]
max_i = [0 for j in range(max(len(row) for row in grid))]

for i, row in enumerate(grid):
    for j, ch in enumerate(row):
        if ch == ' ':
            continue
        min_j[i], max_j[i] = min(min_j[i], j), max(max_j[i], j)
        min_i[j], max_i[j] = min(min_i[j], i), max(max_i[j], i)

# print(min_j, max_j, min_i, max_i)

cmds = [(int(s[0:-1]), s[-1]) for s in re.findall('\d+[RL]', strs[-1])]
# print(cmds)

dir = (0, 1)
pos_i, pos_j = 0, min_j[0]

for step, rotation in cmds:
    for k in range(step):
        new_pos_i, new_pos_j = pos_i + dir[0], pos_j + dir[1]
        if new_pos_i < min_i[pos_j]:
            new_pos_i = max_i[pos_j]
        if new_pos_i > max_i[pos_j]:
            new_pos_i = min_i[pos_j]
        if new_pos_j < min_j[pos_i]:
            new_pos_j = max_j[pos_i]
        if new_pos_j > max_j[pos_i]:
            new_pos_j = min_j[pos_i]
        if grid[new_pos_i][new_pos_j] == '#':
            break
        pos_i, pos_j = new_pos_i, new_pos_j
    if rotation == 'R':
        dir = (dir[1], -dir[0])
    else:
        dir = (-dir[1], dir[0])

facing = [(0, 1), (1, 0), (0, -1), (-1, 0)].index(dir)
print('Part 1', 1000 * (pos_i + 1) + 4 * (pos_j + 1) + facing)
# print(pos_i + 1, pos_j + 1, facing)

