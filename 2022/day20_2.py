seq = [(orig_i, int(s) * 811589153) for orig_i, s in enumerate(open('day20.txt').readlines())]

for mix_round in range(10):
    print(f'Starting mix round {mix_round + 1}')
    for orig_i in range(len(seq)):
        cur_i, cur_val = [(j, seq[j][1]) for j in range(len(seq)) if seq[j][0] == orig_i][0]

        if cur_val == 0:
            continue

        # Weird physics to roll off the ends?
        if cur_val > 0:
            new_i = (cur_i + cur_val) % (len(seq) - 1)
        if cur_val < 0:
            new_i = (cur_i + cur_val) % (len(seq) - 1)
            if new_i == 0:
                new_i = (len(seq) - 1)

        del seq[cur_i]

        seq = seq[0:new_i] + [(orig_i, cur_val)] + seq[new_i:]
        # print([s[1] for s in seq])

pos_0 = [j for j in range(len(seq)) if seq[j][1] == 0][0]
part1 = 0
for val in [1000, 2000, 3000]:
    part1 += seq[(pos_0 + val) % len(seq)][1]
print('Part 1', part1)
