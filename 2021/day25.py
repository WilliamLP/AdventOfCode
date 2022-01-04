from copy import deepcopy

class Seafloor:
    def __init__(self):
        self.grid = []
        for line in open('day25.txt'):
            self.grid.append([ch for ch in line.strip()])

    def __str__(self):
        return '\n'.join([''.join([ch for ch in line]) for line in self.grid])

    def move(self, ch, di, dj):
        moved = False
        new_grid = deepcopy(self.grid)
        for i, row in enumerate(self.grid):
            for j, cell in enumerate(row):
                if cell == ch and self.grid[(i+di) % len(self.grid)][(j+dj) % len(row)] == '.':
                    moved = True
                    new_grid[i][j] = '.'
                    new_grid[(i+di) % len(self.grid)][(j+dj) % len(row)] = ch
        self.grid = new_grid
        return moved

def main():
    floor = Seafloor()
    step = 1
    while True:
        moved = any((floor.move('>', 0, 1), floor.move('v', 1, 0)))
        if not moved:
            break
        step += 1

    print(f'Part 1 answer: {step}')


main()