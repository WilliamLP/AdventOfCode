from collections import defaultdict

class Transform:
    @classmethod
    def all(cls):
        # 6 permutations of coordinates, 8 flips
        # Composing them yields 48 transforms, but half of them have the wrong chirality
        # We check for only those with determinant = 1
        permutes = [[0, 1, 2], [0, 2, 1], [1, 0, 2], [1, 2, 0], [2, 0, 1], [2, 1, 0]]
        t_permutes = []
        for permute in permutes:
            t_permute = []
            for i in range(3):
                row = [0, 0, 0]
                row[permute[i]] = 1
                t_permute.append(row)
            t_permutes.append(Transform(t_permute))

        t_flips = []
        for i in (-1, 1):
            for j in (-1, 1):
                for k in (-1, 1):
                    t_flips.append(Transform([[i, 0, 0], [0, j, 0], [0, 0, k]]))

        res = []
        for t1 in t_permutes:
            for t2 in t_flips:
                composed = t1.compose(t2)
                if composed.determinant() == 1:
                    res.append(composed)
        return res

    def __init__(self, arr):
        self.arr = arr

    def __str__(self):
        return '\n'.join([str(elem) for elem in self.arr])

    def compose(self, t2):
        res = []
        for i in range(3):
            row = []
            res.append(row)
            for j in range(3):
                row.append(
                    self.arr[i][0] * t2.arr[0][j] +
                    self.arr[i][1] * t2.arr[1][j] +
                    self.arr[i][2] * t2.arr[2][j]
                )
        return Transform(res)

    def determinant(self):
        return self.arr[0][0] * (self.arr[1][1] * self.arr[2][2] - self.arr[1][2] * self.arr[2][1]) +\
            self.arr[0][1] * (self.arr[1][2] * self.arr[2][0] - self.arr[1][0] * self.arr[2][2]) +\
            self.arr[0][2] * (self.arr[1][0] * self.arr[2][1] - self.arr[1][1] * self.arr[2][0])

    def transform_coord(self, coord):
        res = []
        for i in range(3):
            res.append(coord[0] * self.arr[i][0] + coord[1] * self.arr[i][1] + coord[2] * self.arr[i][2])
        return res

    def transform(self, arr):
        return [self.transform_coord(coord) for coord in arr]

def parse():
    scanners = []
    scanner = None
    for str in open('day19.txt'):
        if str.strip() == '':
            continue
        if 'scanner' in str:
            scanner = []
            scanners.append(scanner)
            continue
        scanner.append([int(num) for num in str.strip().split(',')])
    return scanners

def check_correlation(arr1, arr2):
    freqs = defaultdict(int)
    for c1 in arr1:
        for c2 in arr2:
            diff = [c2[0] - c1[0], c2[1] - c1[1], c2[2] - c1[2]]
            freqs[str(diff)] += 1
            if freqs[str(diff)] == 12:
                return diff

def normalize(arr, coord):
    for elem in arr:
        elem[0] -= coord[0]
        elem[1] -= coord[1]
        elem[2] -= coord[2]
    return arr

def part1(scanners):
    distinct = set()
    for scanner in scanners:
        for coord in scanner:
            distinct.add(str(coord))
    print(f'Part 1 answer: {len(distinct)}')

def part2(coords):
    max_dist = -1
    for i in range(len(coords)):
        for j in range(i + 1, len(coords)):
            m_dist = abs(coords[i][0] - coords[j][0]) +\
                abs(coords[i][1] - coords[j][1]) +\
                abs(coords[i][2] - coords[j][2])
            max_dist = max(max_dist, m_dist)
    print(f'Part 2 answer: {max_dist}')

def main():
    scanners = parse()
    diff_from_0 = [None for i in range(len(scanners))]
    diff_from_0[0] = [0, 0, 0]
    transforms = Transform.all()

    queue = [0]
    while queue:
        queue_index = queue.pop()
        base = scanners[queue_index]
        for j in range(len(scanners)):
            if diff_from_0[j] is not None:
                continue
            for transform in transforms:
                transformed = transform.transform(scanners[j])
                correlation = check_correlation(base, transformed)
                if correlation:
                    print(f'Found correlation {queue_index} {j} {correlation}')
                    scanners[j] = normalize(transformed, correlation)
                    diff_from_0[j] = correlation
                    queue.append(j)
                    break

    part1(scanners)
    part2(diff_from_0)

main()