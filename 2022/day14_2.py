
maxx = 0
maxy = 0
lines = []
for str in open('day14.txt'):
    line_strs = str.strip().split(' -> ')
    line_coords = [[int(crd) for crd in s.split(',')] for s in line_strs]
    for i in range(len(line_coords) - 1):
        lines.append((line_coords[i], line_coords[i+1]))
        maxx = max(maxx, line_coords[i][0], line_coords[i+1][0])
        maxy = max(maxy, line_coords[i][1], line_coords[i+1][1])
# print(lines, maxx, maxy, len(lines))

grid = [[' '] * (maxy + 3) for i in range(2 * maxx + 1)]
def sign(i):
    if i > 1:
        return 1
    if i == 0:
        return 0
    return -1

def add_line(grid, line):
    dx, dy = sign(line[1][0] - line[0][0]), sign(line[1][1] - line[0][1])
    x, y = line[0]
    print(line, maxx, maxy, line[1][1], line[0][1], line[1][1] - line[0][1], len(grid), len(grid[0]))
    while [x, y] != line[1]:
        #print(x, y)
        grid[x][y] = '#'
        x += dx
        y += dy
    grid[x][y] = '#'

for line in lines:
    add_line(grid, line)
add_line(grid, ([0, maxy+2], [2 * maxx, maxy+2]))

def drop_sand(grid):
    x, y = 500, 0
    if grid[x][y] == '.':
        return False
    while True:
        if grid[x][y+1] == ' ':
            y += 1
            continue
        if grid[x-1][y+1] == ' ':
            x -= 1
            y += 1
            continue
        if grid[x+1][y+1] == ' ':
            x += 1
            y += 1
            continue
        grid[x][y] = '.'
        return True

count = 0
while drop_sand(grid):
    count += 1
print('Part 2', count)