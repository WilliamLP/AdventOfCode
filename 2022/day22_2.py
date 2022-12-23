import re

strs = open('day22.txt').readlines()
grid = [s.rstrip() for s in strs[0:-2]]

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

print(min_j, max_j, min_i, max_i)

cmds = [(int(s[0:-1]), s[-1]) for s in re.findall('\d+[RLN]', strs[-1].strip() + 'N')]

def make_step(pos_i, pos_j, dir, test=False):
    new_pos_i, new_pos_j = pos_i + dir[0], pos_j + dir[1]
    new_dir = dir
    block_i, block_j = pos_i // 50, pos_j // 50

    if new_pos_i < min_i[pos_j]:
        if block_j == 0:
            new_pos_i, new_pos_j = 50 + pos_j, 50
            new_dir = (0, 1)
        elif block_j == 1:
            new_pos_i, new_pos_j = 150 + pos_j - 50, 0
            new_dir = (0, 1)
        elif block_j == 2:
            new_pos_i, new_pos_j = 150 + 49, pos_j - 100
            new_dir = (-1, 0)
        else:
            raise Exception('Invalid edge')

    elif new_pos_i > max_i[pos_j]:
        if block_j == 0:
            new_pos_i, new_pos_j = 0, 100 + pos_j
            new_dir = (1, 0)
        elif block_j == 1:
            new_pos_i, new_pos_j = 150 + pos_j - 50, 49
            new_dir = (0, -1)
        elif block_j == 2:
            new_pos_i, new_pos_j = 50 + pos_j - 100, 50 + 49
            new_dir = (0, -1)
        else:
            raise Exception('Invalid edge')

    elif new_pos_j < min_j[pos_i]:
        if block_i == 0:
            new_pos_i, new_pos_j = 100 + 49 - pos_i, 0
            new_dir = (0, 1)
        elif block_i == 1:
            new_pos_i, new_pos_j = 100, pos_i - 50
            new_dir = (1, 0)
        elif block_i == 2:
            new_pos_i, new_pos_j = 149 - pos_i, 50
            new_dir = (0, 1)
        elif block_i == 3:
            new_pos_i, new_pos_j = 0, pos_i - 150 + 50
            new_dir = (1, 0)
        else:
            raise Exception('Invalid edge')

    elif new_pos_j > max_j[pos_i]:
        if block_i == 0:
            new_pos_i, new_pos_j = 49 - pos_i + 100, 50 + 49
            new_dir = (0, -1)
        elif block_i == 1:
            new_pos_i, new_pos_j = 49, pos_i - 50 + 100
            new_dir = (-1, 0)
        elif block_i == 2:
            new_pos_i, new_pos_j = 149 - pos_i, 100 + 49
            new_dir = (0, -1)
        elif block_i == 3:
            new_pos_i, new_pos_j = 100 + 49, pos_i - 150 + 50
            new_dir = (-1, 0)
        else:
            raise Exception('Invalid edge')

    if not test:
        test_pos_i, test_pos_j, test_dir = make_step(
            new_pos_i, new_pos_j, (-new_dir[0], -new_dir[1]), True)
        test_dir = (-test_dir[0], -test_dir[1])
        if (test_pos_i, test_pos_j, test_dir) != (pos_i, pos_j, dir):
            print('What?!')

    return new_pos_i, new_pos_j, new_dir

dir = (0, 1)
pos_i, pos_j = 0, min_j[0]

for step, rotation in cmds:
    for k in range(step):
        new_pos_i, new_pos_j, new_dir = make_step(pos_i, pos_j, dir)
        try:
            if grid[new_pos_i][new_pos_j] == '#':
                break
        except Exception:
            print('whoah')
        pos_i, pos_j, dir = new_pos_i, new_pos_j, new_dir

    if rotation == 'R':
        dir = (dir[1], -dir[0])
    elif rotation == 'L':
        dir = (-dir[1], dir[0])

facing = [(0, 1), (1, 0), (0, -1), (-1, 0)].index(dir)
print(dir, facing)

print('Part 2', 1000 * (pos_i + 1) + 4 * (pos_j + 1) + facing)

