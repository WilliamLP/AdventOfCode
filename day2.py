from collections import defaultdict

with open("day2.txt") as f:
    l = list(f)


contains_pair = 0
contains_triple = 0

for line in l:
    sums = defaultdict(int)
    for chr in line:
        sums[chr] += 1

    if 2 in sums.values():
        contains_pair += 1
    if 3 in sums.values():
        contains_triple += 1

print('{} * {} = {}'.format(contains_pair, contains_triple, contains_pair * contains_triple))

# Part 2

def diff(s1, s2):
    res = 0
    if len(s1) != len(s2):
        raise Exception('Whoops!')
    for (chr1, chr2) in zip(s1, s2):
        if chr1 != chr2:
            res += 1
    return res


for i, val in enumerate(l):
    for val2 in (l[i+1:]):
        if diff(val, val2) == 1:
            print('Two close ones! \n {} {}'.format(val, val2))
