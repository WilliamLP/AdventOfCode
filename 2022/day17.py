input = open('day17.txt').readline().strip()

blocks = [
    ['@@@@'],
    ['.@.', '@@@', '.@.'],
    ['@@@', '..@', '..@'],
    ['@', '@', '@', '@'],
    ['@@', '@@']
]

SIZE_X = 7
SIZE_Y = 4000

def display(grid, bottom_height, block, block_x, block_y):
    block_w, block_h = len(block[0]), len(block)
    for y in reversed(range(0, max(bottom_height + 1, block_y + block_h))):
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
jet_i = 0
block_type = 0
num_blocks = 0
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
        # display(grid, bottom_height, block, block_x, block_y)

        # Fall
        if is_valid(grid, block, block_x, block_y - 1):
            block_y -= 1
            # display(grid, bottom_height, block, block_x, block_y)
        else:
            # display(grid, bottom_height, block, block_x, block_y)
            for y in range(0, block_h):
                str = grid[block_y + y]
                new_substr = ''
                for x in range(block_w):
                    if grid[block_y + y][block_x + x] == '#' or block[y][x] == '@':
                        new_substr += '#'
                    else:
                        new_substr += '.'
                grid[block_y + y] = str[0:block_x] + new_substr + str[block_x + block_w:]
            break

    bottom_height = max(bottom_height, block_y + block_h)
    print(bottom_height)
    block_type = (block_type + 1) % len(blocks)
    if num_blocks == 2022:
        break

print('Part 1', bottom_height)