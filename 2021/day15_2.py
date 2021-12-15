import heapq

def find_closest(n, weights, dists, heap):
    while True:
        dist, i, j = heapq.heappop(heap)
        if dists[i][j] == -1:
            break

    dists[i][j] = dist
    for adj_i, adj_j in ((i - 1, j), (i + 1, j), (i, j - 1), (i, j + 1)):
        if adj_i < 0 or adj_j < 0 or adj_i >= n or adj_j >= n or dists[adj_i][adj_j] != -1:
            continue
        heapq.heappush(heap, (dist + weights[adj_i][adj_j], adj_i, adj_j))

def main():
    initial = []
    for str in open('day15.txt'):
        initial.append([int(ch) for ch in str.strip()])
    n_initial = len(initial)

    n = n_initial * 5
    weights = []
    for i in range(n):
        row = []
        for j in range(n):
            weight = initial[i % n_initial][j % n_initial] + i // n_initial + j // n_initial
            weight = ((weight - 1) % 9) + 1
            row.append(weight)
        weights.append(row)

    dists = [[-1 for i in range(n)] for j in range(n)]
    dists[0][0] = 0
    heap = [(weights[1][0], 1, 0), (weights[0][1], 0, 1)]
    heapq.heapify(heap)

    steps = 0
    while dists[n-1][n-1] == -1:
        find_closest(n, weights, dists, heap)
        steps += 1
        if steps % 1000 == 0:
            print(f'Step: {steps}')

    print(dists[n-1][n-1])

main()