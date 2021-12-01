import re
with open("day3.txt") as f:
    l = list(f)

"""
l = ['#1 @ 1,3: 4x4',
'#2 @ 3,1: 4x4',
'#3 @ 5,5: 2x2']
"""

SIZE = 1000
grid = [[0] * SIZE for i in range(SIZE)]

overlaps = 0
for line in l:
    parsed = re.split(r'[^0-9]+', line)
    x, y, sx, sy = [int(item) for item in parsed[2:6]]

    for i in range(x, x+sx):
        for j in range(y, y+sy):
            grid[i][j] += 1
            if grid[i][j] == 2:
                overlaps += 1

print('Overlaps: {}'.format(overlaps))

# Part two - which one has no overlap?
for line in l:
    parsed = re.split(r'[^0-9]+', line)
    id, x, y, sx, sy = [int(item) for item in parsed[1:6]]

    overlap = False
    for i in range(x, x+sx):
        for j in range(y, y+sy):
            if grid[i][j] > 1:
                overlap = True
    if not overlap:
        print('No overlap for item {}'.format(id))
