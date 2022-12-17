input = open('day17.txt').readline().strip()

blocks = [
    ['@@@@'],
    ['.@.', '@@@', '.@.'],
    ['@@@', '..@', '..@'],
    ['@', '@', '@', '@'],
    ['@@', '@@']
]

SIZE_X = 7
SIZE_Y = 40000

def display(grid, bottom_height, block, block_x, block_y):
    block_w, block_h = len(block[0]), len(block)
    for y in reversed(range(0, max(bottom_height, block_y + block_h))):
        str = grid[y]
        if y >= block_y and y < block_y + block_h:
            str = str[0:block_x] + block[y - block_y] + str[block_x + block_w:]
        print('|' + str + '|')
    print('+' + '-' * SIZE_X + '+')

def is_valid(grid, block, block_x, block_y):
    block_w, block_h = len(block[0]), len(block)
    if block_x < 0 or block_x + block_w > SIZE_X or block_y < 0:
        return False
    for y in range(block_h):
        for x in range(block_w):
            if block[y][x] == '.':
                continue
            if grid[y + block_y][x + block_x] == '#':
                return False
    return True

grid = ['.' * SIZE_X] * SIZE_Y
bottom_height = 0
y_offset = 0
jet_i = 0
block_type = 0
num_blocks = 0

hashes = {}

max_blocks = 1000000000000
while True:
    num_blocks += 1
    block = blocks[block_type]
    block_w, block_h = len(block[0]), len(block)
    block_x, block_y = 2, bottom_height + 3
    # display(grid, bottom_height, block, block_x, block_y)

    while True:
        # Jet blow
        if input[jet_i] == '>' and is_valid(grid, block, block_x + 1, block_y):
            block_x += 1
        if input[jet_i] == '<' and is_valid(grid, block, block_x - 1, block_y):
            block_x -= 1

        jet_i = (jet_i + 1) % len(input)

        # Fall
        if is_valid(grid, block, block_x, block_y - 1):
            block_y -= 1
        else:
            for y in range(0, block_h):
                gstr = grid[block_y + y]
                new_substr = ''
                for x in range(block_w):
                    if grid[block_y + y][block_x + x] == '#' or block[y][x] == '@':
                        new_substr += '#'
                    else:
                        new_substr += '.'
                grid[block_y + y] = gstr[0:block_x] + new_substr + gstr[block_x + block_w:]
            break

    bottom_height = max(bottom_height, block_y + block_h)

    full_row = set()
    for y in range(2):
        for x in range(SIZE_X):
            if grid[block_y - y][x] == '#':
                full_row.add(x)
    if len(full_row) == 7:
        # We found two rows that block the rest of the grid, so we can remove the bottom part,
        # which will allow us to eventually detect a cycle
        bottom_height -= (block_y - 1)
        grid = grid[block_y - 1:]
        y_offset += (block_y - 1)

    hsh = f'{hash(tuple(grid[0:bottom_height+1]))}|{block_type}|{jet_i}'
    if hsh in hashes:
        prev_blocks, prev_height = hashes[hsh]
        cycle_len = num_blocks - prev_blocks
        if cycle_len < (max_blocks - num_blocks):
            cycle_height = bottom_height + y_offset - prev_height
            # skip time ahead when we detect a cycle!
            ncycles = (max_blocks - num_blocks) // cycle_len
            print(f'Skipping ahead from {num_blocks}: {ncycles} cycles of length {cycle_len} with height {cycle_height}')
            num_blocks += ncycles * cycle_len
            y_offset += ncycles * cycle_height
    else:
        hashes[hsh] = (num_blocks, bottom_height + y_offset)

    if num_blocks == max_blocks:
        break
    block_type = (block_type + 1) % len(blocks)

print('Part 1', bottom_height + y_offset)