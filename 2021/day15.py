
def find_closest(n, weights, dists):
    # import pdb; pdb.set_trace()
    closest_dist = 99999
    for i in range(n):
        for j in range(n):
            if dists[i][j] != -1:
                continue
            for adj_i, adj_j in [(i-1, j), (i+1, j), (i, j-1), (i, j+1)]:
                if adj_i < 0 or adj_j < 0 or adj_i >= n or adj_j >= n or dists[adj_i][adj_j] == -1:
                    continue
                dist = dists[adj_i][adj_j] + weights[i][j]
                if dist < closest_dist:
                    closest_dist = dist
                    closest_i = i
                    closest_j = j
    dists[closest_i][closest_j] = closest_dist

def main():
    weights = []
    for str in open('day15.txt'):
        weights.append([int(ch) for ch in str.strip()])
    n = len(weights)

    dists = [[-1 for i in range(n)] for j in range(n)]
    dists[0][0] = 0
    steps = 0
    while dists[n-1][n-1] == -1:
        find_closest(n, weights, dists)
        steps += 1
        print(f'Step: {steps}')

    print(dists[n-1][n-1])

main()