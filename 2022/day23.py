
def bounds():
    min_i = min([elf['i'] for elf in elves])
    max_i = max([elf['i'] for elf in elves])
    min_j = min([elf['j'] for elf in elves])
    max_j = max([elf['j'] for elf in elves])
    return min_i, max_i, min_j, max_j

def display():
    min_i, max_i, min_j, max_j = bounds()
    grid = [['.'] * (max_j - min_j + 1) for i in range(min_i, max_i + 1)]
    for elf in elves:
        grid[elf['i'] - min_i][elf['j'] - min_j] = '#'

    res = []
    for row in grid:
        res.append(''.join(row))
    return res


elves = []
cur_id = 0
for i, line in enumerate(open('day23.txt').readlines()):
    for j, ch in enumerate(line.strip()):
        if ch == '#':
            elves.append({'id': cur_id, 'i': i, 'j': j})
            cur_id += 1

dirs = {
    'NW': (-1, -1),
    'N': (-1, 0),
    'NE': (-1, 1),
    'W': (0, -1),
    'E': (0, 1),
    'SW': (1, -1),
    'S': (1, 0),
    'SE': (1, 1)
}

plans = [
    ['N', 'NW', 'NE'],
    ['S', 'SW', 'SE'],
    ['W', 'NW', 'SW'],
    ['E', 'NE', 'SE']
]

turn = 0
while True:
    min_i, max_i, min_j, max_j = bounds()
    if turn == 10:
        print('Part 1', (max_i - min_i + 1) * (max_j - min_j + 1) - len(elves))

    disp = display()
    # print('---')
    # print('\n'.join(disp))

    elf_proposed_pos = {}

    for elf in elves:
        all_empty = True

        i, j = elf['i'], elf['j']
        for (di, dj) in dirs.values():
            if i + di < min_i or i + di > max_i or j + dj < min_j or j + dj > max_j:
                continue
            if disp[i + di - min_i][j + dj - min_j] == '#':
                all_empty = False
                break
        if all_empty:
            continue

        for plan_i in range(4):
            plan = plans[(plan_i + turn) % 4]
            all_empty_plan = True
            for plan_dir in plan:
                di, dj = dirs[plan_dir]
                if i + di < min_i or i + di > max_i or j + dj < min_j or j + dj > max_j:
                    continue
                if disp[i + di - min_i][j + dj - min_j] == '#':
                    all_empty_plan = False
                    break
            if not all_empty_plan:
                continue
            di, dj = dirs[plan[0]]
            elf_proposed_pos[elf['id']] = (i + di, j + dj)
            break

    # make the moves
    elf_moved = False
    for elf in elves:
        if elf['id'] not in elf_proposed_pos:
            continue
        proposed_pos = elf_proposed_pos[elf['id']]
        if list(elf_proposed_pos.values()).count(proposed_pos) > 1:
            continue
        elf['i'], elf['j'] = proposed_pos
        elf_moved = True

    if not elf_moved:
        print('Part 2', turn + 1)
        break

    turn += 1


