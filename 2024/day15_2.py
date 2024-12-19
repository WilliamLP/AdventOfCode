import copy

input = open("day15.txt").readlines()
empty_line = input.index('\n')
map_input, move_input = input[0:empty_line], input[empty_line+1:]

map = []
for input_row in map_input:
    map_row = []
    for ch in input_row.strip():
        if ch == '@':
            pos = (len(map_row), len(map))
            map_row += ['.', '.']
        if ch == '.':
            map_row += ['.', '.']
        if ch == '#':
            map_row += ['#', '#']
        if ch == 'O':
            map_row += ['[', ']']
    map.append(map_row)

move_coords = {'<': (-1, 0), '>': (1, 0), '^': (0, -1), 'v': (0, 1)}

moves = []
for move_row in move_input:
    for mv in move_row.strip():
        moves.append(move_coords[mv])

def print_map(map, pos):
    for y, rw in enumerate(map):
        rws = ''.join(rw)
        if y == pos[1]:
            rws = rws[0:pos[0]] + '@' + rws[pos[0] + 1:]
        print(rws)

def push(map, pos, move):
    next_pos = (pos[0] + move[0], pos[1] + move[1])
    next_ch = map[next_pos[1]][next_pos[0]]
    if next_ch in (']', '['):
        ahead1 = (next_pos[0] + move[0], next_pos[1] + move[1])
        if move[1] == 0:  # horizontal
            ahead2 = (ahead1[0] + move[0], ahead1[1])
            if push(map, ahead1, move):
                map[ahead2[1]][ahead2[0]] = map[ahead1[1]][ahead1[0]]
                map[ahead1[1]][ahead1[0]] = map[next_pos[1]][next_pos[0]]
                map[next_pos[1]][next_pos[0]] = '.'
                return True
            return False
        else:  # vertical
            ahead1 = (next_pos[0], next_pos[1] + move[1])
            side_x = next_pos[0] + 1 if next_ch == '[' else next_pos[0] - 1
            side_ahead = (side_x, next_pos[1] + move[1])
            p1 = push(map, next_pos, move)
            p2 = push(map, (side_x, next_pos[1]), move)
            if p1 and p2:
                map[ahead1[1]][ahead1[0]] = map[next_pos[1]][next_pos[0]]
                map[next_pos[1]][next_pos[0]] = '.'
                map[ahead1[1]][side_ahead[0]] = map[next_pos[1]][side_ahead[0]]
                map[next_pos[1]][side_ahead[0]] = '.'
                return True
            return False

    if next_ch == '.':
        return True
    if next_ch == '#':
        return False


print_map(map, pos)

for move in moves:
    #print(move)
    map_copy = copy.deepcopy(map)
    if(push(map_copy, pos, move)):
        pos = (pos[0] + move[0], pos[1] + move[1])
        map = map_copy
        # print_map(map, pos)

score = 0
for y, row in enumerate(map):
    for x, ch in enumerate(row):
        if ch != '[':
            continue
        score += 100 * y + x

print('Part 2', score)