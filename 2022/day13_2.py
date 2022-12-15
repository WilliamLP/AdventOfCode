def cmp(l1, l2):
    if isinstance(l1, int) and isinstance(l2, int):
        return l1 - l2
    if isinstance(l1, int):
        return cmp([l1], l2)
    if isinstance(l2, int):
        return cmp(l1, [l2])
    if not l1 or not l2:
        return len(l1) - len(l2)
    return cmp(l1[0], l2[0]) or cmp(l1[1:], l2[1:])

exprs = [eval(str) for str in open('day13_test.txt') if str.strip()]
part1_sum = 0
for i in range(0, len(exprs), 2):
    if cmp(exprs[i], exprs[i+1]) <= 0:
        part1_sum += i // 2 + 1
print('part1', part1_sum)

d1_index, d1 = 1, [[2]]
d2_index, d2 = 2, [[6]]
for expr in exprs:
    if cmp(d1, expr) > 0:
        d1_index += 1
    if cmp(d2, expr) > 0:
        d2_index += 1
print('part2', d1_index, d2_index, d1_index * d2_index)